CREATE TRIGGER trg_limit_product_sales_improved
ON pz.order_item
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @max_sales INT = 100;

    -- Check ALL products that would violate the limit
    DECLARE @violations TABLE (
        product_id INT,
        product_name NVARCHAR(100),
        current_sales INT
    );

    INSERT INTO @violations (product_id, product_name, current_sales)
    SELECT
        i.product_id,
        p.product_name,
        COUNT(oi.id) AS current_sales
    FROM inserted i
    INNER JOIN pz.product p ON i.product_id = p.id
    LEFT JOIN pz.order_item oi ON i.product_id = oi.product_id
    GROUP BY i.product_id, p.product_name
    HAVING COUNT(oi.id) >= @max_sales;

    -- If there are violations, report ALL of them
    IF EXISTS (SELECT 1 FROM @violations)
    BEGIN
        DECLARE @error_message NVARCHAR(MAX) = N'Неможливо додати купівлі. Наступні товари досягли ліміту продажів ('
            + CAST(@max_sales AS NVARCHAR(10)) + N'):' + CHAR(13) + CHAR(10);

        SELECT @error_message = @error_message
            + N'- ' + product_name
            + N' (ID: ' + CAST(product_id AS NVARCHAR(10)) + N')'
            + N' - поточних продажів: ' + CAST(current_sales AS NVARCHAR(10))
            + CHAR(13) + CHAR(10)
        FROM @violations;

        RAISERROR(@error_message, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If validation passes, insert all rows
    INSERT INTO pz.order_item (order_id, product_id, quantity, price)
    SELECT order_id, product_id, quantity, price FROM inserted;
END;
GO
