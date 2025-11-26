IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'pz')
BEGIN
    EXEC('CREATE SCHEMA [pz]')
END
GO

CREATE TABLE pz.users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    phone NVARCHAR(20),
    created_at DATE DEFAULT GETDATE()
);
GO

CREATE TABLE pz.product (
    id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(100) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    price DECIMAL(10, 2) CHECK (price >= 0),
);
GO

CREATE TABLE pz.orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    placed_at DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) CHECK (total >= 0),

    CONSTRAINT FK_orders_users FOREIGN KEY (user_id)
        REFERENCES pz.users(id)
        ON DELETE CASCADE
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
