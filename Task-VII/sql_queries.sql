USE ecommerce_db;

SELECT * FROM Product;
SELECT product_id, product_name, price, stock FROM Product;

SELECT product_id, product_name, price FROM Product
WHERE price BETWEEN 500 AND 2000;

SELECT p.product_id, p.product_name, c.category_name, p.price
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

SELECT product_id, product_name, price, stock FROM Product
WHERE stock > 0;

SELECT product_id, product_name, price, stock FROM Product
WHERE stock = 0;

SELECT product_id, product_name, price FROM Product
ORDER BY price ASC;

SELECT product_id, product_name, price FROM Product
ORDER BY price DESC;

SELECT DISTINCT c.category_name
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE p.stock > 0
ORDER BY c.category_name;

SELECT product_id, product_name, price, stock FROM Product
WHERE price >= 1000 ORDER BY price DESC;

SELECT p.product_id, p.product_name, c.category_name, p.price, p.stock
FROM Product p JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics' AND p.stock > 0
ORDER BY p.price DESC;

SELECT customer_id, customer_name, email, phone, city
FROM Customer ORDER BY customer_name;

SELECT customer_id, customer_name, email, phone
FROM Customer WHERE city = 'Chennai';

SELECT p.product_id, p.product_name, c.category_name, p.price, p.stock
FROM Product p JOIN Category c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

SELECT product_id, product_name, price, stock
FROM Product
WHERE price < 2000 AND stock >= 25
ORDER BY price ASC;

SELECT product_id, product_name, price FROM Product
WHERE product_name LIKE '%Book%';

SELECT c.category_name,
       COUNT(p.product_id) AS product_count,
       COALESCE(SUM(p.stock), 0) AS total_stock
FROM Category c LEFT JOIN Product p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM Customer c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

SELECT payment_status,
       COUNT(payment_id) AS transaction_count,
       SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_status
ORDER BY transaction_count DESC;
