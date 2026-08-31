-- E-Commerce Order Management System
-- Task I to Task V - MySQL Implementation

DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- TASK I: Customer Database Module
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    city VARCHAR(50),
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- TASK II: Product and Category Management
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    CHECK (price >= 0),
    CHECK (stock >= 0)
);

-- TASK III: Seller and Inventory Management
CREATE TABLE Seller (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255)
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT NOT NULL,
    product_id INT NOT NULL,
    available_stock INT NOT NULL DEFAULT 0,
    unavailable_stock INT NOT NULL DEFAULT 0,
    last_updated DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    UNIQUE (seller_id, product_id),
    CHECK (available_stock >= 0),
    CHECK (unavailable_stock >= 0)
);

-- TASK IV: Order Management
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
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    CHECK (total_price >= 0)
);

-- TASK V: Payment Transaction Management
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_mode VARCHAR(30) NOT NULL,
    payment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CHECK (amount >= 0),
    CHECK (payment_mode IN ('UPI', 'CARD', 'NET_BANKING', 'CASH_ON_DELIVERY', 'WALLET')),
    CHECK (payment_status IN ('SUCCESS', 'FAILED', 'PENDING'))
);

-- SAMPLE DATA
INSERT INTO Customer (customer_name, email, phone, address, city) VALUES
('Arun Kumar', 'arun@gmail.com', '9876543210', 'Anna Nagar', 'Chennai'),
('Priya S', 'priya@gmail.com', '9876543211', 'Velachery', 'Chennai'),
('Karthik R', 'karthik@gmail.com', '9876543212', 'Tambaram', 'Chennai');

INSERT INTO Category (category_name, description) VALUES
('Electronics', 'Electronic products'),
('Clothing', 'Men and women clothing'),
('Books', 'Books and educational materials'),
('Home Appliances', 'Home and kitchen appliances');

INSERT INTO Product (product_name, category_id, price, stock, description) VALUES
('Wireless Headphones', 1, 1499.00, 50, 'Bluetooth wireless headphones'),
('Smart Watch', 1, 2499.00, 30, 'Fitness smart watch'),
('Cotton T-Shirt', 2, 599.00, 100, 'Premium cotton t-shirt'),
('Java Programming Book', 3, 799.00, 40, 'Java programming guide'),
('Electric Kettle', 4, 1299.00, 25, 'Stainless steel kettle');

INSERT INTO Seller (seller_name, email, phone, address) VALUES
('Tech World', 'techworld@gmail.com', '9000000001', 'Chennai'),
('Fashion Store', 'fashion@gmail.com', '9000000002', 'Coimbatore'),
('Book House', 'bookhouse@gmail.com', '9000000003', 'Madurai');

INSERT INTO Inventory (seller_id, product_id, available_stock, unavailable_stock) VALUES
(1, 1, 50, 0), (1, 2, 30, 0), (2, 3, 100, 0),
(3, 4, 40, 0), (1, 5, 25, 0);

INSERT INTO Orders (customer_id, total_amount, order_status) VALUES
(1, 2098.00, 'PLACED'), (2, 2499.00, 'PLACED');

INSERT INTO Order_Details (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 1499.00, 1499.00),
(1, 3, 1, 599.00, 599.00),
(2, 2, 1, 2499.00, 2499.00);

INSERT INTO Payment (order_id, payment_mode, amount, payment_status) VALUES
(1, 'UPI', 2098.00, 'SUCCESS'),
(2, 'CARD', 2499.00, 'FAILED');

-- TASK II: Product insertion, update, deletion and category report
INSERT INTO Product (product_name, category_id, price, stock, description)
VALUES ('USB Keyboard', 1, 699.00, 60, 'Wired USB keyboard');

UPDATE Product SET price = 649.00, stock = 65
WHERE product_name = 'USB Keyboard';

DELETE FROM Product WHERE product_name = 'USB Keyboard';

SELECT c.category_name, p.product_id, p.product_name, p.price, p.stock
FROM Category c
JOIN Product p ON c.category_id = p.category_id
ORDER BY c.category_name, p.product_name;

-- TASK III: Inventory status report
SELECT s.seller_name, p.product_name,
       i.available_stock, i.unavailable_stock,
       CASE WHEN i.available_stock > 0 THEN 'AVAILABLE'
            ELSE 'UNAVAILABLE' END AS product_status
FROM Inventory i
JOIN Seller s ON i.seller_id = s.seller_id
JOIN Product p ON i.product_id = p.product_id
ORDER BY s.seller_name, p.product_name;

-- TASK IV: Order modification and customer order history
UPDATE Orders SET order_status = 'CONFIRMED'
WHERE order_id = 1;

SELECT c.customer_name, o.order_id, o.order_date, o.order_status,
       p.product_name, od.quantity, od.unit_price, od.total_price
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Product p ON od.product_id = p.product_id
ORDER BY c.customer_id, o.order_date DESC;

-- TASK V: Payment transaction report
SELECT p.payment_id, o.order_id, c.customer_name,
       p.payment_mode, p.payment_date, p.amount, p.payment_status
FROM Payment p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customer c ON o.customer_id = c.customer_id
ORDER BY p.payment_date DESC, p.payment_id;

-- Successful and failed transaction summary
SELECT payment_status, COUNT(*) AS transaction_count,
       SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_status;

-- Payment method usage analysis
SELECT payment_mode, COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_mode
ORDER BY total_transactions DESC;

-- Successful payment method analysis
SELECT payment_mode, COUNT(*) AS successful_transactions,
       SUM(amount) AS successful_amount
FROM Payment
WHERE payment_status = 'SUCCESS'
GROUP BY payment_mode
ORDER BY successful_transactions DESC;
