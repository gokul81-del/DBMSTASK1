CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE ROLE IF NOT EXISTS 'ecommerce_readonly';
CREATE ROLE IF NOT EXISTS 'ecommerce_data_entry';

GRANT SELECT ON ecommerce_db.Customer TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce_db.Category TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce_db.Product TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce_db.Orders TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce_db.Order_Details TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce_db.Payment TO 'ecommerce_readonly';

GRANT SELECT, INSERT, UPDATE ON ecommerce_db.Customer TO 'ecommerce_data_entry';
GRANT SELECT, INSERT, UPDATE ON ecommerce_db.Product TO 'ecommerce_data_entry';
GRANT SELECT, INSERT, UPDATE ON ecommerce_db.Orders TO 'ecommerce_data_entry';
GRANT SELECT, INSERT, UPDATE ON ecommerce_db.Order_Details TO 'ecommerce_data_entry';
GRANT SELECT, INSERT, UPDATE ON ecommerce_db.Payment TO 'ecommerce_data_entry';

CREATE USER IF NOT EXISTS 'ecommerce_viewer'@'localhost'
IDENTIFIED BY 'ChangeThisViewer_123!';

CREATE USER IF NOT EXISTS 'ecommerce_operator'@'localhost'
IDENTIFIED BY 'ChangeThisOperator_123!';

GRANT 'ecommerce_readonly' TO 'ecommerce_viewer'@'localhost';
GRANT 'ecommerce_data_entry' TO 'ecommerce_operator'@'localhost';

SET DEFAULT ROLE 'ecommerce_readonly' TO 'ecommerce_viewer'@'localhost';
SET DEFAULT ROLE 'ecommerce_data_entry' TO 'ecommerce_operator'@'localhost';

REVOKE INSERT ON ecommerce_db.Payment FROM 'ecommerce_data_entry';

CREATE INDEX idx_customer_city ON Customer(city);
CREATE INDEX idx_product_name ON Product(product_name);
CREATE INDEX idx_product_category_price ON Product(category_id, price);
CREATE INDEX idx_orders_customer_date ON Orders(customer_id, order_date);
CREATE INDEX idx_orders_status ON Orders(order_status);
CREATE INDEX idx_order_details_product ON Order_Details(product_id);
CREATE INDEX idx_payment_status_date ON Payment(payment_status, payment_date);

EXPLAIN
SELECT product_id, product_name, price
FROM Product
WHERE product_name = 'Wireless Headphones';

EXPLAIN
SELECT product_id, product_name, price
FROM Product
WHERE category_id = 1 AND price < 2000;

EXPLAIN
SELECT order_id, order_date, total_amount, order_status
FROM Orders
WHERE customer_id = 1
ORDER BY order_date DESC;

EXPLAIN
SELECT payment_id, order_id, amount, payment_status
FROM Payment
WHERE payment_status = 'SUCCESS'
ORDER BY payment_date DESC;

SHOW INDEX FROM Customer;
SHOW INDEX FROM Product;
SHOW INDEX FROM Orders;
SHOW INDEX FROM Order_Details;
SHOW INDEX FROM Payment;

SHOW GRANTS FOR 'ecommerce_viewer'@'localhost';
SHOW GRANTS FOR 'ecommerce_operator'@'localhost';
SHOW GRANTS FOR 'ecommerce_readonly';
SHOW GRANTS FOR 'ecommerce_data_entry';
