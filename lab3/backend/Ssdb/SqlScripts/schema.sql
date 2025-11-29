IF OBJECT_ID('lab.order_items','U') IS NOT NULL DROP TABLE lab.order_items;
IF OBJECT_ID('lab.orders','U') IS NOT NULL DROP TABLE lab.orders;
IF OBJECT_ID('lab.product','U') IS NOT NULL DROP TABLE lab.product;
IF OBJECT_ID('lab.users','U') IS NOT NULL DROP TABLE lab.users;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'lab')
BEGIN
    EXEC('CREATE SCHEMA lab');
END;
GO

CREATE TABLE lab.users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    phone NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE lab.product (
    id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(100) NOT NULL,
    department NVARCHAR(100) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    price DECIMAL(10, 2) CHECK (price >= 0),
    description NVARCHAR(200) NULL
);
GO

CREATE TABLE lab.orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    placed_at DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) CHECK (total >= 0),
    CONSTRAINT FK_orders_users FOREIGN KEY (user_id)
        REFERENCES lab.users(id)
        ON DELETE CASCADE
);
GO

CREATE TABLE lab.order_items (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id)
        REFERENCES lab.orders(id),
    CONSTRAINT FK_OrderItems_Product FOREIGN KEY (product_id)
        REFERENCES lab.product(id)
);
GO
