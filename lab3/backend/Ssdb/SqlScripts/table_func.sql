-- Returns products with quantity not exceeding a threshold
CREATE OR ALTER FUNCTION lab.fn_LowStockProducts
(
    @maxQuantity INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT id,
           product_name,
           department,
           quantity,
           price,
           description
    FROM lab.product
    WHERE quantity <= @maxQuantity
);
GO
