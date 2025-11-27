CREATE DATABASE SsdbDB;
GO

USE SsdbDB;
GO

CREATE SCHEMA pz;
GO

-- 1. Батьківська таблиця
CREATE TABLE pz.users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    phone NVARCHAR(20),
    created_at DATE DEFAULT GETDATE()
);
GO

-- 2. Залежна таблиця
CREATE TABLE pz.orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    placed_at DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) CHECK (total >= 0),
    CONSTRAINT FK_orders_users FOREIGN KEY (user_id)
        REFERENCES pz.users(id)
        ON DELETE CASCADE
);
GO

-- 3. Залежна таблиця
CREATE TABLE pz.product (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    quantity_in_stock INT CHECK (quantity_in_stock >= 0),
    price DECIMAL(10,2) CHECK (price >= 0),
    user_id INT NOT NULL,
    CONSTRAINT FK_product_users FOREIGN KEY (user_id)
        REFERENCES pz.users(id)
        ON DELETE CASCADE
);
GO

-- 4. Незалежна таблиця
CREATE TABLE pz.migration_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    description NVARCHAR(200) NOT NULL
);
GO
