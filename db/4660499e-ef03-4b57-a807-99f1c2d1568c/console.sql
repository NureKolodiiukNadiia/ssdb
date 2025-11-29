-- IF OBJECT_ID('lab.order_items','U') IS NOT NULL DROP TABLE lab.order_items;
-- IF OBJECT_ID('lab.orders','U') IS NOT NULL DROP TABLE lab.orders;
-- IF OBJECT_ID('lab.product','U') IS NOT NULL DROP TABLE lab.product;
-- IF OBJECT_ID('lab.users','U') IS NOT NULL DROP TABLE lab.users;
--
-- IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'lab')
--     BEGIN
--         EXEC('CREATE SCHEMA lab');
--     END;
-- GO
--
-- CREATE TABLE lab.users (
--                            id INT IDENTITY(1,1) PRIMARY KEY,
--                            full_name NVARCHAR(100) NOT NULL,
--                            email NVARCHAR(100) UNIQUE,
--                            phone NVARCHAR(20),
--                            created_at DATETIME DEFAULT GETDATE()
-- );
-- GO
--
-- CREATE TABLE lab.product (
--                              id INT PRIMARY KEY IDENTITY(1,1),
--                              product_name NVARCHAR(100) NOT NULL,
--                              quantity INT CHECK (quantity >= 0),
--                              price DECIMAL(10, 2) CHECK (price >= 0),
-- );
-- GO
--
-- CREATE TABLE lab.orders (
--                             id INT PRIMARY KEY IDENTITY(1,1),
--                             user_id INT NOT NULL,
--                             placed_at DATETIME DEFAULT GETDATE(),
--                             total DECIMAL(10,2) CHECK (total >= 0),
--
--                             CONSTRAINT FK_orders_users FOREIGN KEY (user_id)
--                                 REFERENCES lab.users(id)
--                                 ON DELETE CASCADE
-- );
-- GO
--
-- CREATE TABLE lab.order_items (
--                                  id INT PRIMARY KEY IDENTITY(1,1),
--                                  order_id INT NOT NULL,
--                                  product_id INT NOT NULL,
--                                  quantity INT NOT NULL,
--                                  price DECIMAL(10, 2) NOT NULL,
--
--                                  CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id)
--                                      REFERENCES lab.orders(id),
--                                  CONSTRAINT FK_OrderItems_Product FOREIGN KEY (product_id)
--                                      REFERENCES lab.product(id)
-- );
-- GO

-- -- Seed
-- INSERT INTO lab.users (full_name, email, phone) VALUES
-- (N'User One', N'user1@example.com', N'+380501234000'),
-- (N'User Two', N'user2@example.com', N'+380501234001');
--
-- INSERT INTO lab.product (product_name, quantity, price) VALUES
-- (N'PopularProd', 1000, 10.00),
-- (N'OtherProd',   500,  5.00);
--
-- INSERT INTO lab.orders (user_id, total) VALUES
-- ((SELECT TOP (1) id FROM lab.users WHERE full_name = N'User One' ORDER BY id), 100.00),
-- ((SELECT TOP (1) id FROM lab.users WHERE full_name = N'User Two' ORDER BY id), 50.00);
--
-- -- Insert 100 existing order_items for PopularProd
-- INSERT INTO lab.order_items (order_id, product_id, quantity, price) VALUES
-- (
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)
-- );
--
-- INSERT INTO lab.order_items (order_id, product_id, quantity, price) VALUES
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id));
--
-- INSERT INTO lab.order_items (order_id, product_id, quantity, price) VALUES
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id));
--
-- INSERT INTO lab.order_items (order_id, product_id, quantity, price) VALUES
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id)),
-- ((SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id),1,(SELECT TOP (1) price FROM lab.product WHERE product_name = N'PopularProd' ORDER BY id));
--
-- -- Insert 10 order_items for OtherProd
-- INSERT INTO lab.order_items (order_id, product_id, quantity, price) VALUES
-- (
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- ),(
--  (SELECT TOP (1) id FROM lab.orders ORDER BY id),
--  (SELECT TOP (1) id FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id),
--  1, (SELECT TOP (1) price FROM lab.product WHERE product_name = N'OtherProd' ORDER BY id)
-- );

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

            THROW 50000, @err, 1;
        END


    INSERT INTO lab.order_items (order_id, product_id, quantity, price)
    SELECT order_id, product_id, quantity, price
    FROM inserted;
END;
GO


BEGIN TRY
    INSERT INTO lab.order_items (order_id, product_id, quantity, price)
    VALUES (1, 1, 1, 10.00);
    PRINT 'Test 1: Unexpectedly SUCCEEDED';
END TRY
BEGIN CATCH
    PRINT 'Test 1: Expected error: ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
     INSERT INTO lab.order_items (order_id, product_id, quantity, price)
     SELECT 1, 2, 1, 5.00;
    PRINT 'Test 2: Succeeded';
END TRY
BEGIN CATCH
    PRINT 'Test 2: Unexpected error: ' + ERROR_MESSAGE();
END CATCH
