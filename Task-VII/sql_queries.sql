-- E-Commerce Order Management System
-- TASK VII - SQL Query Implementation

USE ecommerce_db;

-- 1. SELECT
SELECT * FROM Product;
SELECT product_id, product_name, price, stock FROM Product;

-- 2. WHERE: products within a price range
SELECT product_id, product_name, price FROM Product
WHERE price BETWEEN 500 AND 2000;

-- 3. Products by category
SELECT p.product_id, p.product_name, c.category_name, p.price
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

-- 4. Available products
SELECT product_id, product_name, price, stock FROM Product
WHERE stock > 0;

-- 5. Unavailable products
SELECT product_id, product_name, price, stock FROM Product
WHERE stock = 0;

-- 6. ORDER BY ascending price
SELECT product_id, product_name, price FROM Product
ORDER BY price ASC;

-- 7. ORDER BY descending price
SELECT product_id, product_name, price FROM Product
ORDER BY price DESC;

-- 8. DISTINCT available categories
SELECT DISTINCT c.category_name
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE p.stock > 0
ORDER BY c.category_name;

-- 9. Search products by minimum price
SELECT product_id, product_name, price, stock FROM Product
WHERE price >= 1000 ORDER BY price DESC;

-- 10. Search products by category and availability
SELECT p.product_id, p.product_name, c.category_name, p.price, p.stock
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics' AND p.stock > 0
ORDER BY p.price DESC;

-- 11. Retrieve customer information
SELECT customer_id, customer_name, email, phone, city
FROM Customer ORDER BY customer_name;

-- 12. Retrieve customers from Chennai
SELECT customer_id, customer_name, email, phone
FROM Customer WHERE city = 'Chennai';

-- 13. Retrieve product information with category
SELECT p.product_id, p.product_name, c.category_name, p.price, p.stock
FROM Product p JOIN Category c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- 14. Multiple filtering conditions
SELECT product_id, product_name, price, stock
FROM Product
WHERE price < 2000 AND stock >= 25
ORDER BY price ASC;

-- 15. Product name search
SELECT product_id, product_name, price FROM Product
WHERE product_name LIKE '%Book%';

-- 16. Basic business report: category-wise product count and stock
SELECT c.category_name,
       COUNT(p.product_id) AS product_count,
       COALESCE(SUM(p.stock), 0) AS total_stock
FROM Category c LEFT JOIN Product p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

-- 17. Basic business report: customer order totals
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM Customer c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- 18. Basic business report: payment status summary
SELECT payment_status,
       COUNT(payment_id) AS transaction_count,
       SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_status
ORDER BY transaction_count DESC;
