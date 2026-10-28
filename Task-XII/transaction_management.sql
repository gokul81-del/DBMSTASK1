CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;


DROP PROCEDURE IF EXISTS Place_Order_Transaction;
DROP PROCEDURE IF EXISTS Demonstrate_Rollback;

DELIMITER $$

CREATE PROCEDURE Place_Order_Transaction(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_payment_mode VARCHAR(30)
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
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

    IF NOT EXISTS (
        SELECT 1
        FROM Customer
        WHERE customer_id = p_customer_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;

    SELECT price, stock
    INTO v_price, v_stock
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

    INSERT INTO Order_Details (
        order_id, product_id, quantity, unit_price, total_price
    )
    VALUES (
        v_order_id, p_product_id, p_quantity, v_price, v_total
    );

    UPDATE Product
    SET stock = stock - p_quantity
    WHERE product_id = p_product_id;

    INSERT INTO Payment (
        order_id, payment_mode, payment_date, amount, payment_status
    )
    VALUES (
        v_order_id, p_payment_mode, CURRENT_DATE, v_total, 'SUCCESS'
    );

    COMMIT;

    SELECT v_order_id AS order_id,
           v_total AS total_amount,
           'SUCCESS' AS transaction_status;
END$$

CREATE PROCEDURE Demonstrate_Rollback(
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    START TRANSACTION;

    SELECT stock
    INTO v_stock
    FROM Product
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for rollback demonstration';
    END IF;

    UPDATE Product
    SET stock = stock - p_quantity
    WHERE product_id = p_product_id;

    ROLLBACK;

    SELECT product_id, product_name, stock,
           'ROLLBACK completed; stock change was cancelled' AS transaction_status
    FROM Product
    WHERE product_id = p_product_id;
END$$

DELIMITER ;

CALL Place_Order_Transaction(1, 1, 1, 'UPI');

CALL Demonstrate_Rollback(1, 1);

SELECT * FROM Orders ORDER BY order_id DESC;
SELECT * FROM Order_Details ORDER BY order_detail_id DESC;
SELECT * FROM Payment ORDER BY payment_id DESC;
SELECT product_id, product_name, stock FROM Product ORDER BY product_id;

SELECT
    o.order_id,
    o.total_amount,
    COALESCE(SUM(od.total_price), 0.00) AS details_total,
    CASE
        WHEN o.total_amount = COALESCE(SUM(od.total_price), 0.00)
        THEN 'CONSISTENT'
        ELSE 'CHECK REQUIRED'
    END AS consistency_status
FROM Orders o
LEFT JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id, o.total_amount
ORDER BY o.order_id DESC;
