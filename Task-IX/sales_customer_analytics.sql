USE ecommerce_db;

SELECT
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order_value,
    MIN(total_amount) AS minimum_order_value,
    MAX(total_amount) AS maximum_order_value
FROM Orders;

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order_value
FROM Orders;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_purchase_amount,
    AVG(o.total_amount) AS average_purchase_amount
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase_amount DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.total_price) AS total_sales,
    AVG(od.unit_price) AS average_selling_price
FROM Product p
INNER JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC, total_sales DESC;

SELECT
    c.category_id,
    c.category_name,
    COUNT(DISTINCT od.order_id) AS total_orders,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.total_price) AS total_sales,
    AVG(od.total_price) AS average_sale_value,
    MIN(od.total_price) AS minimum_sale_value,
    MAX(od.total_price) AS maximum_sale_value
FROM Category c
INNER JOIN Product p ON c.category_id = p.category_id
INNER JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM Product p
INNER JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_purchase_amount
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase_amount DESC
LIMIT 5;
