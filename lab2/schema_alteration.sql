CREATE TABLE pz.order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CONSTRAINT CK_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id)
        REFERENCES pz.orders(id)
        ON DELETE CASCADE,
    CONSTRAINT FK_order_items_product FOREIGN KEY (product_id)
        REFERENCES pz.product(id)
        ON DELETE NO ACTION
);
GO
