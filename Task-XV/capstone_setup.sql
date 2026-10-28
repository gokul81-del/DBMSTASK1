CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Seller;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Customer;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(80),
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE Seller (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255)
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT NOT NULL,
    product_id INT NOT NULL,
    available_stock INT NOT NULL DEFAULT 0,
    unavailable_stock INT NOT NULL DEFAULT 0,
    last_updated DATE NOT NULL DEFAULT (CURRENT_DATE),
    UNIQUE (seller_id, product_id),
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CHECK (available_stock >= 0),
    CHECK (unavailable_stock >= 0)
) ENGINE=InnoDB;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    order_status VARCHAR(30) NOT NULL DEFAULT 'PLACED',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CHECK (total_amount >= 0),
    CHECK (order_status IN ('PLACED', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED'))
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    review_text VARCHAR(500) NOT NULL,
    review_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    UNIQUE (customer_id, product_id)
) ENGINE=InnoDB;

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    review_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating_value INT NOT NULL,
    rating_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (review_id) REFERENCES Review(review_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CHECK (rating_value BETWEEN 1 AND 5)
) ENGINE=InnoDB;

INSERT INTO Customer (customer_name, email, phone, address, city) VALUES
('Arun Kumar', 'arun.kumar@example.com', '9000000001', 'Anna Nagar', 'Chennai'),
('Priya S', 'priya.s@example.com', '9000000002', 'Velachery', 'Chennai'),
('Karthik R', 'karthik.r@example.com', '9000000003', 'Tambaram', 'Chennai'),
('Meena Devi', 'meena.devi@example.com', '9000000004', 'RS Puram', 'Coimbatore'),
('Rahul M', 'rahul.m@example.com', '9000000005', 'Gandhipuram', 'Coimbatore'),
('Nisha P', 'nisha.p@example.com', '9000000006', 'KK Nagar', 'Madurai');

INSERT INTO Category (category_name, description) VALUES
('Electronics', 'Electronic accessories and devices'),
('Clothing', 'Everyday clothing'),
('Books', 'Education and programming books'),
('Home Appliances', 'Useful home appliances');

INSERT INTO Seller (seller_name, email, phone, address) VALUES
('Tech World', 'techworld@example.com', '9100000001', 'Chennai'),
('Fashion Store', 'fashion@example.com', '9100000002', 'Coimbatore'),
('Book House', 'bookhouse@example.com', '9100000003', 'Madurai'),
('Home Needs', 'homeneeds@example.com', '9100000004', 'Chennai');

INSERT INTO Product (product_name, category_id, price, stock, description) VALUES
('Wireless Headphones', 1, 1499.00, 50, 'Bluetooth headphones'),
('Smart Watch', 1, 2499.00, 30, 'Fitness and notification watch'),
('USB Keyboard', 1, 699.00, 65, 'Wired USB keyboard'),
('Cotton T-Shirt', 2, 599.00, 100, 'Cotton casual t-shirt'),
('Running Shoes', 2, 1899.00, 40, 'Everyday running shoes'),
('Java Programming Book', 3, 799.00, 40, 'Java learning guide'),
('SQL Fundamentals', 3, 649.00, 35, 'Database learning book'),
('Electric Kettle', 4, 1299.00, 25, 'Stainless steel kettle');

INSERT INTO Inventory (seller_id, product_id, available_stock, unavailable_stock) VALUES
(1, 1, 50, 0),
(1, 2, 30, 0),
(1, 3, 65, 0),
(2, 4, 100, 0),
(2, 5, 40, 0),
(3, 6, 40, 0),
(3, 7, 35, 0),
(4, 8, 25, 0);

INSERT INTO Orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2026-09-02', 2098.00, 'DELIVERED'),
(2, '2026-09-05', 2499.00, 'DELIVERED'),
(3, '2026-09-12', 1898.00, 'SHIPPED'),
(1, '2026-09-18', 1899.00, 'DELIVERED'),
(4, '2026-09-22', 1948.00, 'CONFIRMED'),
(5, '2026-09-25', 1299.00, 'PLACED'),
(6, '2026-09-28', 3148.00, 'DELIVERED');

INSERT INTO Order_Details (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 1499.00, 1499.00),
(1, 6, 1, 599.00, 599.00),
(2, 2, 1, 2499.00, 2499.00),
(3, 3, 1, 699.00, 699.00),
(3, 4, 2, 599.00, 1198.00),
(4, 5, 1, 1899.00, 1899.00),
(5, 6, 1, 799.00, 799.00),
(5, 7, 1, 649.00, 649.00),
(5, 4, 1, 500.00, 500.00),
(6, 8, 1, 1299.00, 1299.00),
(7, 1, 1, 1499.00, 1499.00),
(7, 7, 1, 649.00, 649.00),
(7, 4, 1, 1000.00, 1000.00);

INSERT INTO Payment (order_id, payment_mode, payment_date, amount, payment_status) VALUES
(1, 'UPI', '2026-09-02', 2098.00, 'SUCCESS'),
(2, 'CARD', '2026-09-05', 2499.00, 'SUCCESS'),
(3, 'UPI', '2026-09-12', 1898.00, 'SUCCESS'),
(4, 'WALLET', '2026-09-18', 1899.00, 'SUCCESS'),
(5, 'NET_BANKING', '2026-09-22', 1948.00, 'PENDING'),
(6, 'CASH_ON_DELIVERY', '2026-09-25', 1299.00, 'PENDING'),
(7, 'CARD', '2026-09-28', 3148.00, 'SUCCESS');

INSERT INTO Review (customer_id, product_id, review_text, review_date) VALUES
(1, 1, 'Clear sound and comfortable fit.', '2026-09-10'),
(2, 2, 'Useful features and easy to use.', '2026-09-11'),
(3, 3, 'Good keyboard for everyday work.', '2026-09-15'),
(4, 6, 'Helpful book for learning Java.', '2026-09-23'),
(5, 8, 'Heats water quickly and works well.', '2026-09-26');

INSERT INTO Rating (review_id, customer_id, product_id, rating_value, rating_date) VALUES
(1, 1, 1, 5, '2026-09-10'),
(2, 2, 2, 4, '2026-09-11'),
(3, 3, 3, 4, '2026-09-15'),
(4, 4, 6, 5, '2026-09-23'),
(5, 5, 8, 4, '2026-09-26');

SELECT 'Capstone schema and sample data created' AS setup_status;
