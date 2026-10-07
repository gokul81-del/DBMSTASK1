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
    customer_id,
    customer_name
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_purchase)
        FROM (
            SELECT
                customer_id,
                SUM(total_amount) AS total_purchase
            FROM Orders
            GROUP BY customer_id
        ) x
    )
);

SELECT
    customer_id,
    customer_name
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING SUM(total_amount) >= (
        SELECT AVG(customer_total)
        FROM (
            SELECT
                customer_id,
                SUM(total_amount) AS customer_total
            FROM Orders
            GROUP BY customer_id
        ) x
    )
);

SELECT
    product_id,
    product_name,
    price,
    category_id
FROM Product p
WHERE price > (
    SELECT AVG(p2.price)
    FROM Product p2
    WHERE p2.category_id = p.category_id
)
ORDER BY category_id, price DESC;

SELECT
    product_id,
    product_name
FROM Product
WHERE product_id IN (
    SELECT product_id
    FROM Order_Details
    GROUP BY product_id
    HAVING SUM(quantity) = (
        SELECT MAX(product_quantity)
        FROM (
            SELECT
                product_id,
                SUM(quantity) AS product_quantity
            FROM Order_Details
            GROUP BY product_id
        ) x
    )
);

SELECT
    category_id,
    category_name
FROM Category
WHERE category_id IN (
    SELECT p.category_id
    FROM Product p
    WHERE p.product_id IN (
        SELECT od.product_id
        FROM Order_Details od
        GROUP BY od.product_id
        HAVING SUM(od.total_price) > (
            SELECT AVG(product_sales)
            FROM (
                SELECT
                    product_id,
                    SUM(total_price) AS product_sales
                FROM Order_Details
                GROUP BY product_id
            ) x
        )
    )
);

SELECT
    customer_id,
    customer_name,
    email
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

SELECT
    product_id,
    product_name,
    price,
    stock
FROM Product
WHERE stock > (
    SELECT AVG(stock)
    FROM Product
)
ORDER BY stock DESC;

SELECT
    customer_id,
    customer_name,
    email
FROM Customer c
WHERE (
    SELECT COALESCE(SUM(o.total_amount), 0)
    FROM Orders o
    WHERE o.customer_id = c.customer_id
) = (
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
    product_id,
    product_name,
    price
FROM Product
WHERE price = (
    SELECT MAX(price)
    FROM Product
);

SELECT
    customer_id,
    customer_name,
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
