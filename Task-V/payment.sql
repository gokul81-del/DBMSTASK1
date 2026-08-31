-- Task V: Payment Transaction Management System
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

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

INSERT INTO Payment (order_id, payment_mode, amount, payment_status) VALUES
(1, 'UPI', 2098.00, 'SUCCESS'),
(2, 'CARD', 2499.00, 'FAILED');

-- Payment transaction report
SELECT p.payment_id, o.order_id, c.customer_name, p.payment_mode,
       p.payment_date, p.amount, p.payment_status
FROM Payment p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customer c ON o.customer_id = c.customer_id
ORDER BY p.payment_date DESC, p.payment_id;

-- Successful and failed transaction summary
SELECT payment_status, COUNT(*) AS transaction_count,
       SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_status;

-- Payment methods used by customers
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