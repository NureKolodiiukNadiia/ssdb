-- 0) Розробіть функцію, яка за назвою відділу
-- повертає сумарну кількість товарів з цього відділу;

CREATE OR ALTER FUNCTION lab.fn_CountProductsByDepartment
(
    @deptPattern NVARCHAR(100) = NULL
)
    RETURNS INT
AS
BEGIN
    DECLARE @pattern NVARCHAR(100) =
        CASE
            WHEN @deptPattern IS NULL THEN '%'
            ELSE @deptPattern END;
    DECLARE @cnt INT = 0;

    IF COL_LENGTH('lab.product', 'department') IS NOT NULL
        BEGIN
            SELECT @cnt = COUNT(*)
            FROM lab.product
            WHERE department LIKE @pattern;
        END

    RETURN @cnt;
END;
GO

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


INSERT INTO lab.users (full_name, email, phone) VALUES
('Ivan Ivanov', 'ivan@example.com', '+380501234567'),
('Olena Petrenko', 'olena@example.com', '+380631234567');

INSERT INTO lab.product (product_name, department, quantity, price, description) VALUES
('Phone A',    'Electronics', 5,  10.00, NULL),          -- cheap
('Phone B',    'Electronics', 10, 20.00, N''),           -- cheap (empty description)
('Tablet',     'Electronics', 3,  30.00, N'Some info'),  -- middle
('Laptop',     'Electronics', 2,  40.00, N'Дешевий товар'), -- already labeled cheap
('Camera',     'Electronics', 4,  50.00, NULL),          -- middle
('Monitor',    'Electronics', 6,  60.00, N' '),          -- middle (whitespace)
('TV',         'Electronics', 1,  70.00, N'Old desc'),   -- expensive
('Speaker',    'Electronics', 7,  80.00, N'Дорогий товар'), -- already labeled expensive
('Vacuum',     'Home',        5, 150.00, NULL),
('Lamp',       'Home',       10,  30.00, NULL),
('Toy Car',    'Toys',       20,   5.00, NULL),
('Puzzle',     'Toys',       15,   7.00, NULL),
('Book A',     'Books',      10,  15.00, NULL),
('Book B',     'Books',       5,  15.00, N''),
('Shirt',      'Clothing',   10,  25.00, NULL);

GO

-- SELECT 'Electronics' AS dept, lab.fn_CountProductsByDepartment('Electronics') cnt
-- UNION ALL
-- SELECT 'Books', lab.fn_CountProductsByDepartment('Books')
-- UNION ALL
-- SELECT 'Toys', lab.fn_CountProductsByDepartment('Toys');
--
-- EXEC lab.MarkProductsByPriceGroup @department = N'Electronics';
--
-- SELECT id, product_name, department, price, description
-- FROM lab.product
-- ORDER BY department, price;
