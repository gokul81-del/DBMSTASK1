-- Task II: Product and Category Management System
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

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
    CHECK (price >= 0), CHECK (stock >= 0)
);

INSERT INTO Category (category_name, description) VALUES
('Electronics', 'Electronic products'), ('Clothing', 'Clothing products'),
('Books', 'Books and educational materials'), ('Home Appliances', 'Home and kitchen appliances');

INSERT INTO Product (product_name, category_id, price, stock, description) VALUES
('Wireless Headphones', 1, 1499.00, 50, 'Bluetooth wireless headphones'),
('Smart Watch', 1, 2499.00, 30, 'Fitness smart watch'),
('Cotton T-Shirt', 2, 599.00, 100, 'Premium cotton t-shirt'),
('Java Programming Book', 3, 799.00, 40, 'Java programming guide'),
('Electric Kettle', 4, 1299.00, 25, 'Stainless steel kettle');

-- INSERT
INSERT INTO Product (product_name, category_id, price, stock, description)
VALUES ('USB Keyboard', 1, 699.00, 60, 'Wired USB keyboard');

-- UPDATE
UPDATE Product SET price = 649.00, stock = 65 WHERE product_name = 'USB Keyboard';

-- DELETE
DELETE FROM Product WHERE product_name = 'USB Keyboard';

-- Category-wise product report
SELECT c.category_name, p.product_id, p.product_name, p.price, p.stock
FROM Category c JOIN Product p ON c.category_id = p.category_id
ORDER BY c.category_name, p.product_name;