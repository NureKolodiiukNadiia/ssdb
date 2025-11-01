CREATE TABLE user (
    user_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    password VARCHAR(255),
    role ENUM('customer', 'admin') NOT NULL,
    address VARCHAR(300),
    PRIMARY KEY (user_id)
);

CREATE TABLE Order (
    order_id INT NOT NULL AUTO_INCREMENT,
    status ENUM('created', 'accepted', 'collected', 'in_progress', 'delivered') NOT NULL,
    subtotal DECIMAL(9, 2) NOT NULL,
    description TEXT,
    payment_method ENUM('credit_card', 'cash') NOT NULL,
    payment_status ENUM('paid', 'unpaid') NOT NULL,
    delivery_fee DECIMAL(9, 2),
    collected_date DATETIME,
    delivered_date DATETIME,
    user_id INT NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) 
    ON UPDATE CASCADE ON DELETE SET NULL 
);

CREATE TABLE order_item (
    order_item_id INT NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(9, 2) NOT NULL,
    service_name VARCHAR(150) NOT NULL,
    order_id INT NOT NULL,
    PRIMARY KEY (order_item_id),
    FOREIGN KEY (order_id) REFERENCES Order(order_id) 
    ON UPDATE CASCADE ON DELETE SET NULL
);
