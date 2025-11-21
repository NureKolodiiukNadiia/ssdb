CREATE FUNCTION pz.fn_DiscountProductsByTotalSales
(
    @discountPercent DECIMAL(5,2),
    @minTotalSales DECIMAL(10,2)
)
    RETURNS @result TABLE
                    (
                        product_name NVARCHAR(100),
                        old_price DECIMAL(10,2),
                        new_price DECIMAL(10,2),
                        total_quantity INT
                    )
AS
BEGIN
    -- Перевірка відсотку знижки
    IF @discountPercent < 1 OR @discountPercent > 50
        BEGIN
            -- Повертаємо порожню таблицю при некоректному відсотку
            RETURN;
        END

    -- Оголошення змінних для курсора
    DECLARE @productId INT;
    DECLARE @productName NVARCHAR(100);
    DECLARE @oldPrice DECIMAL(10,2);
    DECLARE @newPrice DECIMAL(10,2);
    DECLARE @totalQuantity INT;
    DECLARE @totalSales DECIMAL(10,2);

    -- Оголошення курсора для вибірки товарів
    DECLARE product_cursor CURSOR FOR
        SELECT
            p.id,
            p.product_name,
            p.price,
            p.quantity_in_stock,
            ISNULL(SUM(o.total), 0) as total_sales
        FROM pz.product p
                 INNER JOIN pz.orders o ON p.user_id = o.user_id
        GROUP BY p.id, p.product_name, p.price, p.quantity_in_stock
        HAVING ISNULL(SUM(o.total), 0) > @minTotalSales;

    -- Відкриття курсора
    OPEN product_cursor;

    -- Читання першого рядка
    FETCH NEXT FROM product_cursor
        INTO @productId, @productName, @oldPrice, @totalQuantity, @totalSales;

    -- Цикл обробки записів
    WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Розрахунок нової ціни
            SET @newPrice = @oldPrice * (1 - @discountPercent / 100.0);

            -- Оновлення ціни товару
            UPDATE pz.product
            SET price = @newPrice
            WHERE id = @productId;

            -- Додавання результату до таблиці
            INSERT INTO @result (product_name, old_price, new_price, total_quantity)
            VALUES (@productName, @oldPrice, @newPrice, @totalQuantity);

            -- Читання наступного рядка
            FETCH NEXT FROM product_cursor
                INTO @productId, @productName, @oldPrice, @totalQuantity, @totalSales;
        END

    -- Закриття та звільнення курсора
    CLOSE product_cursor;
    DEALLOCATE product_cursor;

    RETURN;
END;
GO
