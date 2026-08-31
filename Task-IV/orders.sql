-- Task IV: Order Management System
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    order_status VARCHAR(30) NOT NULL DEFAULT 'PLACED',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (total_amount >= 0)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CHECK (quantity > 0), CHECK (unit_price >= 0), CHECK (total_price >= 0)
);

INSERT INTO Orders (customer_id, total_amount, order_status) VALUES
(1, 2098.00, 'PLACED'), (2, 2499.00, 'PLACED');

INSERT INTO Order_Details (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 1499.00, 1499.00),
(1, 3, 1, 599.00, 599.00),
(2, 2, 1, 2499.00, 2499.00);

-- Order modification
UPDATE Orders SET order_status = 'CONFIRMED' WHERE order_id = 1;

-- Customer order history report
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.order_status,
       p.product_name, od.quantity, od.unit_price, od.total_price
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Product p ON od.product_id = p.product_id
ORDER BY c.customer_id, o.order_date DESC, o.order_id;