-- E-Commerce Order Management System
-- TASK VI - Product Review and Rating Management System

USE ecommerce_db;

-- ============================================================
-- REVIEW TABLE
-- Stores customer feedback for products.
-- ============================================================
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    review_text VARCHAR(500) NOT NULL,
    review_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- ============================================================
-- RATING TABLE
-- Stores a rating from 1 to 5 for a product review.
-- ============================================================
CREATE TABLE Rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    review_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating_value INT NOT NULL,
    rating_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (review_id) REFERENCES Review(review_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CHECK (rating_value BETWEEN 1 AND 5)
);

-- ============================================================
-- SAMPLE REVIEWS
-- ============================================================
INSERT INTO Review (customer_id, product_id, review_text) VALUES
(1, 1, 'Good sound quality and comfortable to use.'),
(2, 1, 'The headphones are useful and have good battery life.'),
(3, 2, 'Smart watch has useful features and works well.'),
(1, 3, 'Comfortable cotton material and good quality.'),
(2, 4, 'Helpful book for learning Java programming.');

-- ============================================================
-- SAMPLE RATINGS
-- ============================================================
INSERT INTO Rating (review_id, customer_id, product_id, rating_value) VALUES
(1, 1, 1, 5),
(2, 2, 1, 4),
(3, 3, 2, 5),
(4, 1, 3, 4),
(5, 2, 4, 5);

-- ============================================================
-- TASK VI.3: RETRIEVE PRODUCT REVIEW DETAILS
-- ============================================================
SELECT
    r.review_id,
    c.customer_name,
    p.product_name,
    r.review_text,
    r.review_date,
    rt.rating_value
FROM Review r
JOIN Customer c ON r.customer_id = c.customer_id
JOIN Product p ON r.product_id = p.product_id
LEFT JOIN Rating rt ON r.review_id = rt.review_id
ORDER BY r.review_date DESC, r.review_id;

-- ============================================================
-- TASK VI.4: CALCULATE AVERAGE PRODUCT RATINGS
-- Uses the aggregate function AVG().
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    COUNT(rt.rating_id) AS total_ratings,
    ROUND(AVG(rt.rating_value), 2) AS average_rating
FROM Product p
LEFT JOIN Rating rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

-- ============================================================
-- TASK VI.5: IDENTIFY HIGHLY RATED PRODUCTS
-- Products with an average rating of 4 or above.
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(rt.rating_value), 2) AS average_rating,
    COUNT(rt.rating_id) AS total_ratings
FROM Product p
JOIN Rating rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(rt.rating_value) >= 4
ORDER BY average_rating DESC;
