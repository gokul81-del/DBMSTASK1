USE ecommerce_db;

SELECT c.customer_id, c.customer_name, o.order_id, o.order_date,
       o.order_status, p.product_name, od.quantity,
       od.unit_price, od.total_price, py.payment_mode,
       py.payment_status, py.amount
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Product p ON od.product_id = p.product_id
INNER JOIN Payment py ON o.order_id = py.order_id
ORDER BY o.order_id;

SELECT c.customer_id, c.customer_name, o.order_id,
       o.order_date, o.total_amount, o.order_status
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date DESC;

SELECT c.customer_id, c.customer_name, o.order_id,
       o.order_date, o.total_amount, o.order_status
FROM Customer c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;

SELECT o.order_id, o.order_date, o.order_status,
       c.customer_name, c.email, p.product_name,
       od.quantity, od.unit_price, od.total_price,
       py.payment_mode, py.payment_date,
       py.payment_status, py.amount
FROM Orders o
INNER JOIN Customer c ON o.customer_id = c.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Product p ON od.product_id = p.product_id
LEFT JOIN Payment py ON o.order_id = py.order_id
ORDER BY o.order_date DESC, o.order_id;

SELECT c.customer_id, c.customer_name,
       o.order_id, o.order_date, o.order_status,
       p.product_name, od.quantity, od.total_price
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Product p ON od.product_id = p.product_id
ORDER BY c.customer_id, o.order_date DESC;

SELECT c.customer_id, c.customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_purchase
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase DESC;

SELECT p.product_id, p.product_name,
       COUNT(DISTINCT od.order_id) AS total_orders,
       COALESCE(SUM(od.quantity), 0) AS total_quantity_sold,
       COALESCE(SUM(od.total_price), 0) AS total_sales
FROM Product p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;

SELECT o.order_id, c.customer_name,
       o.total_amount, py.payment_mode,
       py.payment_status
FROM Orders o
INNER JOIN Customer c ON o.customer_id = c.customer_id
LEFT JOIN Payment py ON o.order_id = py.order_id
ORDER BY o.order_id;
