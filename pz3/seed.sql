SET NOCOUNT ON;
GO

-- Users
INSERT INTO pz.users (full_name, email, phone) VALUES
('Alice Admin', 'alice@example.com', '1234567890'),
('Bob Buyer', 'bob@example.com', '0987654321');
GO

-- Products
INSERT INTO pz.product (product_name, quantity_in_stock, price) VALUES
('Gaming Laptop', 10, 30000.00),
('Wireless Mouse', 50, 500.00);
GO

-- Orders
INSERT INTO pz.orders (user_id, placed_at, total) VALUES
(1, GETDATE(), 60000.00),  -- 2 x Gaming Laptop
(2, GETDATE(), 1500.00);   -- 3 x Wireless Mouse
GO

-- Order items
INSERT INTO pz.order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 30000.00),
(2, 2, 3, 500.00);
GO
