USE ecommerce_db;

SELECT
    product_id,
    product_name,
    price
FROM Product
WHERE price > (
    SELECT AVG(price)
    FROM Product
)
ORDER BY price DESC;

SELECT
    c.customer_id,
    c.customer_name,
    o.total_purchase
FROM Customer c
INNER JOIN (
    SELECT
        customer_id,
        SUM(total_amount) AS total_purchase
    FROM Orders
    GROUP BY customer_id
) o ON c.customer_id = o.customer_id
WHERE o.total_purchase = (
    SELECT MAX(total_purchase)
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS total_purchase
        FROM Orders
        GROUP BY customer_id
    ) x
);

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_purchase
FROM Customer c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) >= (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_total
        FROM Orders
        GROUP BY customer_id
    ) x
)
ORDER BY total_purchase DESC;

SELECT
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM Product p
INNER JOIN Category c ON p.category_id = c.category_id
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM Product p2
    WHERE p2.category_id = p.category_id
)
ORDER BY c.category_name, p.price DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM Product p
INNER JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) = (
    SELECT MAX(product_quantity)
    FROM (
        SELECT
            product_id,
            SUM(quantity) AS product_quantity
        FROM Order_Details
        GROUP BY product_id
    ) x
);

SELECT
    c.category_id,
    c.category_name,
    SUM(od.total_price) AS category_sales
FROM Category c
INNER JOIN Product p ON c.category_id = p.category_id
INNER JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY c.category_id, c.category_name
HAVING SUM(od.total_price) > (
    SELECT AVG(category_sales)
    FROM (
        SELECT
            p2.category_id,
            SUM(od2.total_price) AS category_sales
        FROM Product p2
        INNER JOIN Order_Details od2 ON p2.product_id = od2.product_id
        GROUP BY p2.category_id
    ) x
)
ORDER BY category_sales DESC;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_purchase,
    AVG(o.total_amount) AS average_order_value
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase DESC;

SELECT
    p.product_id,
    p.product_name,
    p.price,
    p.stock
FROM Product p
WHERE p.stock > (
    SELECT AVG(stock)
    FROM Product
)
ORDER BY p.stock DESC;

SELECT
    c.customer_id,
    c.customer_name,
    (
        SELECT COUNT(*)
        FROM Orders o
        WHERE o.customer_id = c.customer_id
    ) AS total_orders,
    (
        SELECT COALESCE(SUM(o.total_amount), 0)
        FROM Orders o
        WHERE o.customer_id = c.customer_id
    ) AS total_purchase
FROM Customer c
ORDER BY total_purchase DESC;

SELECT
    p.product_id,
    p.product_name,
    p.price,
    p.stock
FROM Product p
WHERE p.price = (
    SELECT MAX(price)
    FROM Product
)
ORDER BY p.product_id;
