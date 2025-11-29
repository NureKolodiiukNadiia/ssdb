IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'pz')
    BEGIN
        EXEC('CREATE SCHEMA pz');
    END;
GO

IF OBJECT_ID('pz.order_items','U') IS NOT NULL DROP TABLE pz.order_items;
IF OBJECT_ID('pz.orders','U') IS NOT NULL DROP TABLE pz.orders;
IF OBJECT_ID('pz.product','U') IS NOT NULL DROP TABLE pz.product;
IF OBJECT_ID('pz.users','U') IS NOT NULL DROP TABLE pz.users;

CREATE TABLE pz.users (
                          id INT IDENTITY(1,1) PRIMARY KEY,
                          full_name NVARCHAR(100) NOT NULL,
                          email NVARCHAR(100) UNIQUE,
                          phone NVARCHAR(20),
                          created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE pz.product (
                            id INT PRIMARY KEY IDENTITY(1,1),
                            product_name NVARCHAR(100) NOT NULL,
                            quantity INT CHECK (quantity >= 0),
                            price DECIMAL(10, 2) CHECK (price >= 0)
);
GO

CREATE TABLE pz.orders (
                           id INT PRIMARY KEY IDENTITY(1,1),
                           user_id INT NOT NULL,
                           placed_at DATETIME DEFAULT GETDATE(),
                           total DECIMAL(10,2) CHECK (total >= 0),
                           CONSTRAINT FK_orders_users FOREIGN KEY (user_id)
                               REFERENCES pz.users(id) ON DELETE CASCADE
);
GO

CREATE TABLE pz.order_items (
                                id INT PRIMARY KEY IDENTITY(1,1),
                                order_id INT NOT NULL,
                                product_id INT NOT NULL,
                                quantity INT NOT NULL,
                                price DECIMAL(10, 2) NOT NULL,
                                CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id)
                                    REFERENCES pz.orders(id),
                                CONSTRAINT FK_OrderItems_Product FOREIGN KEY (product_id)
                                    REFERENCES pz.product(id)
);
GO

INSERT INTO pz.users (full_name, email) VALUES
                                            ('Alice','alice@example.com'),
                                            ('Bob','bob@example.com');
GO

INSERT INTO pz.product (product_name, quantity, price) VALUES
                                                           ('Prod A', 100, 10.00),
                                                           ('Prod B', 50, 5.00);
GO

INSERT INTO pz.orders (user_id, total) VALUES (1, 100.00), (2, 30.00);
INSERT INTO pz.order_items (order_id, product_id, quantity, price) VALUES
                                                                       (1, 1, 10, 10.00),
                                                                       (1, 1, 5, 10.00),
                                                                       (2, 2, 6, 5.00);
GO
