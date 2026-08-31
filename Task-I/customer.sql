-- Task I: Customer Database Module
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    city VARCHAR(50),
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE)
);

INSERT INTO Customer (customer_name, email, phone, address, city) VALUES
('Arun Kumar', 'arun@gmail.com', '9876543210', 'Anna Nagar', 'Chennai'),
('Priya S', 'priya@gmail.com', '9876543211', 'Velachery', 'Chennai'),
('Karthik R', 'karthik@gmail.com', '9876543212', 'Tambaram', 'Chennai');

SELECT * FROM Customer;