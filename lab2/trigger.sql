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

    ;WITH ins AS (
        SELECT product_id, COUNT(*) AS ins_count
        FROM inserted
        GROUP BY product_id
    ), existing AS (
        SELECT product_id, COUNT(*) AS exist_count
        FROM lab.order_items
        GROUP BY product_id
    )
    INSERT INTO @violations (product_id, product_name, current_sales)
    SELECT
        d.product_id,
        p.product_name,
        ISNULL(e.exist_count, 0) + ISNULL(i.ins_count, 0) AS current_sales
    FROM (SELECT DISTINCT product_id FROM inserted) AS d
    LEFT JOIN lab.product p ON d.product_id = p.id
    LEFT JOIN existing e ON d.product_id = e.product_id
    LEFT JOIN ins i ON d.product_id = i.product_id
    WHERE ISNULL(e.exist_count, 0) + ISNULL(i.ins_count, 0) > @max_sales;

    IF EXISTS (SELECT 1 FROM @violations)
    BEGIN
        DECLARE @err NVARCHAR(MAX) = N'Cannot add purchases. The following products would exceed the sales limit ('
            + CAST(@max_sales AS NVARCHAR(10)) + N'):' + CHAR(13) + CHAR(10);

        SELECT @err = @err
            + N'- ' + ISNULL(product_name, N'(unknown)')
            + N' (ID: ' + CAST(product_id AS NVARCHAR(10)) + N')'
            + N' - resulting sales (rows): ' + CAST(current_sales AS NVARCHAR(10))
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
