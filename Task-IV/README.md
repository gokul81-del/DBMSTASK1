# Task IV – Order Management System

## Requirements
1. Design Orders and Order_Details tables.
2. Manage customer product orders.
3. Store order date, quantity, and total amount.
4. Perform order insertion and modification operations.
5. Generate customer order history reports.

## Files
- `orders.sql` – Orders and Order_Details tables, sample orders, insertion/modification operations, and customer history report.

## Relationships
- `Customer (1) -> (Many) Orders`
- `Orders (1) -> (Many) Order_Details`
- `Product (1) -> (Many) Order_Details`