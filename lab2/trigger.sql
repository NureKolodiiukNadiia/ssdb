-- За допомогою тригера заборонити додавання купівлі товару,
-- якщо цього товару існує вже більше 100 продажів
-- (передбачити можливість додавання записів з таблиці).

CREATE OR ALTER TRIGGER lab.trg_limit_product_sales
ON lab.order_items
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @max_sales INT = 100;

    DECLARE @violations TABLE (
        product_id INT,
        product_name NVARCHAR(100),
        current_sales INT
    );

    INSERT INTO @violations (product_id, product_name, current_sales)
    SELECT
        di.product_id,
        p.product_name,
        COUNT(oi.id) AS current_sales
    FROM (SELECT DISTINCT product_id FROM inserted) AS di
    LEFT JOIN lab.product p ON di.product_id = p.id
    LEFT JOIN lab.order_items oi ON di.product_id = oi.product_id
    GROUP BY di.product_id, p.product_name
    HAVING COUNT(oi.id) >= @max_sales;

    IF EXISTS (SELECT 1 FROM @violations)
    BEGIN
        DECLARE @err NVARCHAR(MAX) = N'Cannot add purchases. The following products reached the sales limit ('
            + CAST(@max_sales AS NVARCHAR(10)) + N'):' + CHAR(13) + CHAR(10);

        SELECT @err = @err
            + N'- ' + ISNULL(product_name, N'(unknown)')
            + N' (ID: ' + CAST(product_id AS NVARCHAR(10)) + N')'
            + N' - current sales (rows): ' + CAST(current_sales AS NVARCHAR(10))
            + CHAR(13) + CHAR(10)
        FROM @violations;

        RAISERROR(@err, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO lab.order_items (order_id, product_id, quantity, price)
    SELECT order_id, product_id, quantity, price
    FROM inserted;
END;
GO
