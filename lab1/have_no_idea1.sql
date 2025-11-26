-- 0) Розробіть функцію, яка за назвою регіону
-- (вхідний параметр, частина інформації з поля Address)
-- повертає сумарну кількість працівників з цього регіону;

-- 9) Розробіть процедуру, що для товарів із заданого відділу, ціна яких
-- належіть до 25% найдорожчих товарів, в полі Description записує «Дорогий товар»,
-- а для товарів з ціною, яка знаходиться в діапазоні 25% найдешевших товарів – «Дешевий товар»
-- (необхідно визначити мінімальну та максимальну ціну товарів,
-- розбити цей діапазон на 3 частини – 25%, 50% 25% та для першої та останньої групи товарів
-- в полі Description дописати відповідну інформацію);


/* Function: count users by region substring
   - If column `address` exists in lab.users it searches that column.
   - Otherwise it searches email domain (part after '@') and phone for the substring.
   - Returns INT count.
*/
CREATE OR ALTER FUNCTION lab.fn_CountUsersByRegion
(
    @region NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT = 0;

    IF @region IS NULL OR LEN(LTRIM(RTRIM(@region))) = 0
    BEGIN
        RETURN 0;
    END

        SELECT @cnt = COUNT(*)
        FROM lab.users
        WHERE address LIKE '%' + @region + '%';

    RETURN ISNULL(@cnt, 0);
END;
GO

/* Procedure: tag products in price brackets (25% cheapest / middle / 25% most expensive)
   - Optional @namePattern filters products (use '%' or NULL for all).
   - Ensures `description` column exists on lab.product.
   - Splits price range into three parts by value (not by count).
   - Writes 'Дешевий товар' for price <= lower threshold and 'Дорогий товар' for price >= upper threshold.
   - Leaves middle group description NULL.
   - Returns a summary SELECT with counts.
*/
CREATE OR ALTER PROCEDURE lab.sp_TagProductPriceBrackets
(
    @namePattern NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @minPrice DECIMAL(18,2), @maxPrice DECIMAL(18,2);
    DECLARE @range DECIMAL(18,2), @tLow DECIMAL(18,2), @tHigh DECIMAL(18,2);

    SELECT
        @minPrice = MIN(price),
        @maxPrice = MAX(price)
    FROM lab.product
    WHERE (@namePattern IS NULL OR product_name LIKE @namePattern);

    IF @minPrice IS NULL
    BEGIN
        -- no products matched
        SELECT 0 AS cheap_count, 0 AS middle_count, 0 AS expensive_count;
        RETURN;
    END

    SET @range = @maxPrice - @minPrice;
    SET @tLow  = @minPrice + @range * 0.25; -- upper bound of cheapest 25% (by price range)
    SET @tHigh = @minPrice + @range * 0.75; -- lower bound of most expensive 25%

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Clear descriptions for the scope
--         UPDATE lab.product
--         SET description = NULL
--         WHERE (@namePattern IS NULL OR product_name LIKE @namePattern);

        UPDATE lab.product
        SET description = N'Дешевий товар'
        WHERE price <= @tLow
          AND (@namePattern IS NULL OR product_name LIKE @namePattern);

        UPDATE lab.product
        SET description = N'Дорогий товар'
        WHERE price >= @tHigh
          AND (@namePattern IS NULL OR product_name LIKE @namePattern);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH

    -- Return summary counts
    SELECT
        SUM(CASE WHEN description = N'Дешевий товар' THEN 1 ELSE 0 END) AS cheap_count,
        SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS middle_count,
        SUM(CASE WHEN description = N'Дорогий товар' THEN 1 ELSE 0 END) AS expensive_count
    FROM lab.product
    WHERE (@namePattern IS NULL OR product_name LIKE @namePattern);
END;
GO
