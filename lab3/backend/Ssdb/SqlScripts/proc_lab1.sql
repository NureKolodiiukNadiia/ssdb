-- 9) Розробіть процедуру, що для товарів із заданого відділу, ціна яких
-- належіть до 25% найдорожчих товарів, в полі description записує «Дорогий товар»,
-- а для товарів з ціною, яка знаходиться в діапазоні 25% найдешевших товарів – «Дешевий товар»
-- (необхідно визначити мінімальну та максимальну ціну товарів,
-- розбити цей діапазон на 3 частини – 25%, 50% 25% та для першої та останньої групи товарів
-- в полі description дописати відповідну інформацію);

CREATE OR ALTER PROCEDURE lab.MarkProductsByPriceGroup
(
    @department NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @minPrice DECIMAL(10,2),
        @maxPrice DECIMAL(10,2),
        @range DECIMAL(18,6),
        @lowerCut DECIMAL(18,6),
        @upperCut DECIMAL(18,6);

    SELECT
        @minPrice = MIN(price),
        @maxPrice = MAX(price)
    FROM lab.product
    WHERE department = @department;

    IF @minPrice IS NULL OR @maxPrice IS NULL
        RETURN;

    SET @range = @maxPrice - @minPrice;
    IF @range = 0
        RETURN;

    SET @lowerCut = @minPrice + @range * 0.25;
    SET @upperCut = @minPrice + @range * 0.75;

    BEGIN TRAN;
    BEGIN TRY
        UPDATE lab.product
        SET description =
            CASE
                WHEN description IS NULL OR LTRIM(RTRIM(description)) = '' THEN N'Дешевий товар'
                WHEN CHARINDEX(N'Дешевий товар', description) = 0 THEN description + N'; Дешевий товар'
                ELSE description
            END
        WHERE department = @department AND price <= @lowerCut;

        UPDATE lab.product
        SET description =
            CASE
                WHEN description IS NULL OR LTRIM(RTRIM(description)) = '' THEN N'Дорогий товар'
                WHEN CHARINDEX(N'Дорогий товар', description) = 0 THEN description + N'; Дорогий товар'
                ELSE description
            END
        WHERE department = @department AND price >= @upperCut;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Procedure failed: %s', 16, 1, @err);
    END CATCH
END;
GO
