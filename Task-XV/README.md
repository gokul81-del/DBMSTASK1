# Task XV — Industry Capstone Project: E-Commerce Intelligence Platform

## Project Objective

Integrate the e-commerce database modules into a complete SQL-based platform for managing customers, products, sellers, inventory, orders, payments, reviews, and ratings, with reporting and business analysis.

## Project Modules

- Customer management
- Product and category management
- Seller and inventory management
- Order and order-detail management
- Payment transaction management
- Product reviews and ratings
- Basic and advanced SQL queries
- Views, stored procedures, triggers, and indexes
- Business intelligence reports and AI data preparation

## Files

- `capstone_setup.sql` — Creates the normalized core schema and inserts realistic sample data.
- `capstone_objects.sql` — Creates reporting views, an order-processing procedure, a sales function, stock and order-detail triggers, indexes, and business insight queries.
- `README.md` — Project overview and execution instructions.

## Schema and Relationships

- One category can contain many products.
- Sellers and products are related through inventory.
- One customer can place many orders.
- Each order can contain multiple order details.
- Orders can have payment records.
- Customers can review products; ratings are associated with reviews.

The schema separates core entities into tables and uses primary keys, foreign keys, unique constraints, and check constraints to support data integrity.

## Execution Order

1. Run `capstone_setup.sql` in MySQL 8.0 or later. It creates `ecommerce_db` and resets the capstone tables before inserting sample data.
2. Run `capstone_objects.sql` to create indexes, triggers, views, procedure, function, and reporting queries.
3. Run the SELECT reports at the end of `capstone_objects.sql` to inspect the sample business insights.

**Warning:** The setup script drops existing tables in `ecommerce_db` before rebuilding them. Back up any existing data before running it. Run this capstone in a test database if you need to preserve earlier task data.

## Business Insights

The reporting queries show total sales, order status, payment status, best-selling products, category performance, customer spending segments, inventory availability, and product ratings.

## Notes

- The stored procedure creates an order for a customer and product, records order details, and reduces stock in a transaction.
- Triggers validate available stock and recalculate order totals when order details are inserted, updated, or deleted.
- The example dataset is synthetic and intended for learning and demonstration, not production use.
