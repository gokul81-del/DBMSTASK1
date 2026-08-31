# E-Commerce Order Management System

A DBMS project developed as five task-wise modules for an E-Commerce Order Management System.

## Project Tasks

### Task I — Requirement Analysis and Customer Database Module
- Analyze the business requirements of the E-Commerce Order Management System.
- Prepare the requirement specification.
- Design and maintain the Customer database module.

Files:
- `DBMS_TASK_1-SRS.pdf`
- `Entities.pdf`
- `ER DIAGRAM.pdf`
- `Task-I-Customer.sql`

### Task II — Product and Category Management System
- Design `Product` and `Category` tables.
- Define primary-key and foreign-key relationships.
- Store product name, category, price and stock.
- Perform product insertion, updating and deletion.
- Generate category-wise product reports.

File: `Task-II-Product-Category.sql`

### Task III — Seller and Inventory Management System
- Create `Seller` and `Inventory` tables.
- Establish relationships between sellers, products and stock.
- Maintain seller product information.
- Track available and unavailable products.
- Generate inventory status reports.

File: `Task-III-Seller-Inventory.sql`

### Task IV — Order Management System
- Design `Orders` and `Order_Details` tables.
- Manage customer product orders.
- Store order date, quantity and total amount.
- Perform order insertion and modification operations.
- Generate customer order history reports.

File: `Task-IV-Order-Management.sql`

### Task V — Payment Transaction Management System
- Create the `Payment` table.
- Store payment mode, date, amount and status.
- Manage successful, failed and pending transactions.
- Analyze payment methods used by customers.
- Generate payment transaction reports.

File: `Task-V-Payment-Transaction.sql`

## Database Relationship

```text
Customer
   |
   +---- Orders ---- Order_Details ---- Product ---- Category
   |                    |
   |                    +---------------- Seller / Inventory
   |
   +---- Payment
```

## SQL Execution Order

Run the files in this order because later tasks use tables created by earlier tasks:

1. `Task-I-Customer.sql`
2. `Task-II-Product-Category.sql`
3. `Task-III-Seller-Inventory.sql`
4. `Task-IV-Order-Management.sql`
5. `Task-V-Payment-Transaction.sql`

## Existing Documentation

The repository also contains the original Task-I requirement specification, ER diagram and entity documentation.
