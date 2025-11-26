-- Створити підпрограму, що зменшує ціну товарів на вказаний відсоток (слід
-- обмежити значення відсотку в діапазоні від 1 до 50, інакше - помилка)
-- для товарів, яких було продано на загальну суму більше ніж вказано як
-- другий параметр. Також підпрограма має повертати дані про товари, для
-- яких відбулось зниження ціни у вигляді: Назва товару, стара ціна, нова
-- ціна, загальна кількість товарів.

CREATE OR ALTER PROCEDURE pz.DiscountProducts
(
    @discountPercent DECIMAL(5,2),
    @minTotalSales DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @discountPercent < 1 OR @discountPercent > 50
    BEGIN
        RAISERROR('Discount percent must be between 1 and 50.', 16, 1);
        RETURN;
    END;

    DECLARE @Result TABLE
    (
        product_name NVARCHAR(100),
        old_price DECIMAL(10,2),
        new_price DECIMAL(10,2),
        total_quantity INT
    );

    DECLARE @prodId INT;
    DECLARE @totalSold DECIMAL(18,2);

    DECLARE prod_cursor CURSOR FOR
    SELECT
        oi.product_id,
        SUM(oi.quantity * oi.price) AS total_sold
    FROM pz.order_items oi
    JOIN pz.orders o ON o.id = oi.order_id
    GROUP BY oi.product_id
    HAVING SUM(oi.quantity * oi.price) > @minTotalSales;

    OPEN prod_cursor;
    FETCH NEXT FROM prod_cursor INTO @prodId, @totalSold;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @oldPrice DECIMAL(10,2);
        DECLARE @newPrice DECIMAL(10,2);
        DECLARE @prodName NVARCHAR(100);
        DECLARE @stockQty INT;

        SELECT @prodName = product_name,
               @oldPrice = price,
               @stockQty = quantity -- which quantity?
        FROM pz.product
        WHERE id = @prodId;

        IF @prodName IS NOT NULL
        BEGIN
            SET @newPrice = CAST(ROUND(@oldPrice * (1 - @discountPercent / 100.0), 2) AS DECIMAL(10,2));

            UPDATE pz.product
            SET price = @newPrice
            WHERE id = @prodId;

            INSERT INTO @Result (product_name, old_price, new_price, total_quantity)
            VALUES (@prodName, @oldPrice, @newPrice, ISNULL(@stockQty, 0));
        END

        FETCH NEXT FROM prod_cursor INTO @prodId, @totalSold;
    END

    CLOSE prod_cursor;
    DEALLOCATE prod_cursor;

    SELECT product_name, old_price, new_price, total_quantity FROM @Result;
END;
GO
