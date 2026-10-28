# Task XI — Database Automation using Views and Procedures

## Requirements

1. Create views for frequently used reports.
2. Develop stored procedures for order processing.
3. Create functions for sales calculations.
4. Automate repetitive database operations.
5. Test database objects.

## SQL File

- `database_automation.sql` — Contains views, a stored procedure, a sales calculation function, and test queries.

## Database Objects

- `Order_Summary` — Shows customer and order information.
- `Product_Sales_Report` — Summarizes quantities sold and sales by product.
- `Payment_Report` — Shows payment and customer details.
- `Process_Order` — Validates the customer, product, quantity and stock, creates an order, records order details, reduces stock, and commits the transaction.
- `Calculate_Order_Sales` — Calculates the total sales amount for a specified order.

## Execution

Run the SQL files for Tasks I to V first, then execute `database_automation.sql` in MySQL.

The final SELECT statements test the views and function. To test the procedure, run `CALL Process_Order(1, 1, 1);` after confirming that customer ID 1 and product ID 1 exist and that the product has sufficient stock. This call creates a real order and reduces product stock.
