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
