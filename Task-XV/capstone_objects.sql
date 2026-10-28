USE ecommerce_db;

CREATE INDEX idx_product_category_price ON Product(category_id, price);
CREATE INDEX idx_product_name ON Product(product_name);
CREATE INDEX idx_orders_customer_date ON Orders(customer_id, order_date);
CREATE INDEX idx_orders_status_date ON Orders(order_status, order_date);
CREATE INDEX idx_order_details_product ON Order_Details(product_id);
CREATE INDEX idx_payment_status_date ON Payment(payment_status, payment_date);
CREATE INDEX idx_review_product_date ON Review(product_id, review_date);
CREATE INDEX idx_rating_product_value ON Rating(product_id, rating_value);

DROP VIEW IF EXISTS Order_Summary;
DROP VIEW IF EXISTS Product_Sales_Report;
DROP VIEW IF EXISTS Payment_Report;
DROP VIEW IF EXISTS Customer_Segmentation;

CREATE VIEW Order_Summary AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.customer_name,
    c.city,
    o.total_amount
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id;

CREATE VIEW Product_Sales_Report AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock,
    COALESCE(SUM(od.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(od.total_price), 0.00) AS total_sales
FROM Product p
JOIN Category c ON c.category_id = p.category_id
LEFT JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name, c.category_name, p.price, p.stock;

CREATE VIEW Payment_Report AS
SELECT
    py.payment_id,
    py.order_id,
    c.customer_name,
    py.payment_mode,
    py.payment_date,
    py.amount,
    py.payment_status
FROM Payment py
JOIN Orders o ON o.order_id = py.order_id
JOIN Customer c ON c.customer_id = o.customer_id;

CREATE VIEW Customer_Segmentation AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0.00) AS total_spend,
    CASE
        WHEN COALESCE(SUM(o.total_amount), 0.00) >= 5000 THEN 'HIGH_VALUE'
        WHEN COALESCE(SUM(o.total_amount), 0.00) >= 2000 THEN 'MEDIUM_VALUE'
        WHEN COALESCE(SUM(o.total_amount), 0.00) > 0 THEN 'LOW_VALUE'
        ELSE 'NO_PURCHASE'
    END AS customer_segment
FROM Customer c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;

DROP TRIGGER IF EXISTS trg_order_details_before_insert;
DROP TRIGGER IF EXISTS trg_order_details_before_update;
DROP TRIGGER IF EXISTS trg_order_details_after_insert;
DROP TRIGGER IF EXISTS trg_order_details_after_update;
DROP TRIGGER IF EXISTS trg_order_details_after_delete;

DELIMITER $$

CREATE TRIGGER trg_order_details_before_insert
BEFORE INSERT ON Order_Details
FOR EACH ROW
BEGIN
    DECLARE v_stock INT DEFAULT NULL;

    SELECT stock INTO v_stock
    FROM Product
    WHERE product_id = NEW.product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF NEW.quantity <= 0 OR v_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid quantity or insufficient stock';
    END IF;

    SET NEW.unit_price = (SELECT price FROM Product WHERE product_id = NEW.product_id);
    SET NEW.total_price = NEW.unit_price * NEW.quantity;
END$$

CREATE TRIGGER trg_order_details_before_update
BEFORE UPDATE ON Order_Details
FOR EACH ROW
BEGIN
    DECLARE v_stock INT DEFAULT NULL;

    SELECT stock INTO v_stock
    FROM Product
    WHERE product_id = NEW.product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF NEW.quantity <= 0 OR (NEW.product_id = OLD.product_id AND v_stock + OLD.quantity < NEW.quantity) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid quantity or insufficient stock';
    END IF;

    SET NEW.unit_price = (SELECT price FROM Product WHERE product_id = NEW.product_id);
    SET NEW.total_price = NEW.unit_price * NEW.quantity;
END$$

CREATE TRIGGER trg_order_details_after_insert
AFTER INSERT ON Order_Details
FOR EACH ROW
BEGIN
    UPDATE Product
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(total_price), 0.00)
        FROM Order_Details
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END$$

CREATE TRIGGER trg_order_details_after_update
AFTER UPDATE ON Order_Details
FOR EACH ROW
BEGIN
    IF OLD.product_id = NEW.product_id THEN
        UPDATE Product
        SET stock = stock + OLD.quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    ELSE
        UPDATE Product
        SET stock = stock + OLD.quantity
        WHERE product_id = OLD.product_id;

        UPDATE Product
        SET stock = stock - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;

    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(total_price), 0.00)
        FROM Order_Details
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;

    IF OLD.order_id <> NEW.order_id THEN
        UPDATE Orders
        SET total_amount = (
            SELECT COALESCE(SUM(total_price), 0.00)
            FROM Order_Details
            WHERE order_id = OLD.order_id
        )
        WHERE order_id = OLD.order_id;
    END IF;
END$$

CREATE TRIGGER trg_order_details_after_delete
AFTER DELETE ON Order_Details
FOR EACH ROW
BEGIN
    UPDATE Product
    SET stock = stock + OLD.quantity
    WHERE product_id = OLD.product_id;

    UPDATE Orders
    SET total_amount = (
        SELECT COALESCE(SUM(total_price), 0.00)
        FROM Order_Details
        WHERE order_id = OLD.order_id
    )
    WHERE order_id = OLD.order_id;
END$$

DROP PROCEDURE IF EXISTS Process_Capstone_Order;
DROP FUNCTION IF EXISTS Calculate_Order_Sales;

CREATE PROCEDURE Process_Capstone_Order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_payment_mode VARCHAR(30)
)
BEGIN
    DECLARE v_price DECIMAL(10,2) DEFAULT NULL;
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_order_id INT;
    DECLARE v_total DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    IF p_payment_mode NOT IN ('UPI', 'CARD', 'NET_BANKING', 'CASH_ON_DELIVERY', 'WALLET') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid payment mode';
    END IF;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;

    SELECT price, stock INTO v_price, v_stock
    FROM Product
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    SET v_total = v_price * p_quantity;

    INSERT INTO Orders (customer_id, total_amount, order_status)
    VALUES (p_customer_id, v_total, 'PLACED');

    SET v_order_id = LAST_INSERT_ID();

    INSERT INTO Order_Details (order_id, product_id, quantity, unit_price, total_price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price, v_total);

    INSERT INTO Payment (order_id, payment_mode, amount, payment_status)
    VALUES (v_order_id, p_payment_mode, v_total, 'PENDING');

    COMMIT;

    SELECT v_order_id AS order_id, v_total AS total_amount, 'PENDING' AS payment_status;
END$$

CREATE FUNCTION Calculate_Order_Sales(p_order_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(total_price), 0.00)
    INTO v_total
    FROM Order_Details
    WHERE order_id = p_order_id;

    RETURN v_total;
END$$

DELIMITER ;

SELECT * FROM Order_Summary ORDER BY order_date DESC, order_id DESC;
SELECT * FROM Product_Sales_Report ORDER BY total_sales DESC;
SELECT * FROM Payment_Report ORDER BY payment_date DESC;
SELECT * FROM Customer_Segmentation ORDER BY total_spend DESC;

SELECT
    category_name,
    SUM(total_sales) AS category_sales
FROM Product_Sales_Report
GROUP BY category_name
ORDER BY category_sales DESC;

SELECT
    product_id,
    product_name,
    total_quantity_sold,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    ROW_NUMBER() OVER (ORDER BY total_quantity_sold DESC, product_id) AS quantity_row
FROM Product_Sales_Report
ORDER BY sales_rank, product_id;

SELECT
    payment_status,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_payment_amount
FROM Payment
GROUP BY payment_status
ORDER BY transaction_count DESC;

SELECT
    p.product_name,
    ROUND(AVG(r.rating_value), 2) AS average_rating,
    COUNT(r.rating_id) AS rating_count
FROM Product p
LEFT JOIN Rating r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

SELECT
    o.order_id,
    o.total_amount,
    Calculate_Order_Sales(o.order_id) AS calculated_detail_total
FROM Orders o
ORDER BY o.order_id;

EXPLAIN
SELECT order_id, order_date, total_amount
FROM Orders
WHERE customer_id = 1
ORDER BY order_date DESC;
