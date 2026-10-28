# Task XII — Transaction Management System

## Requirements

1. Implement order placement transactions.
2. Apply COMMIT and ROLLBACK operations.
3. Demonstrate ACID properties.
4. Handle payment and stock update transactions.
5. Ensure database consistency.

## SQL File

- `transaction_management.sql` — Contains transactional order processing, payment insertion, stock updates, COMMIT, ROLLBACK, and consistency checks.

## Transactions Covered

- `Place_Order_Transaction` creates an order and order details, updates stock, records a successful payment, and commits all changes together.
- `Demonstrate_Rollback` changes stock inside a transaction and rolls it back to demonstrate that the stock change is cancelled.
- Final queries verify orders, order details, payments, stock, and order-total consistency.

## ACID Properties

- **Atomicity:** Order, order details, stock change, and payment are committed together or rolled back on an SQL error.
- **Consistency:** Input validation, foreign keys, and a consistency report help preserve valid data.
- **Isolation:** The product row is locked with `FOR UPDATE` while stock is checked and updated.
- **Durability:** A successful `COMMIT` saves the transaction.

## Execution

Run Tasks I to V first so the required tables exist. Then execute `transaction_management.sql` using MySQL.

The test call `CALL Place_Order_Transaction(1, 1, 1, 'UPI');` creates a real order, payment and stock update. Change the IDs and quantity if needed. The rollback demonstration does not keep its stock change.
