# Task XV — ER Diagram

This ER diagram represents the tables and foreign-key relationships in the E-Commerce Intelligence Platform. It uses Mermaid, so GitHub can render the diagram directly.

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDERS : places
    CUSTOMER ||--o{ REVIEW : writes
    CUSTOMER ||--o{ RATING : gives
    CATEGORY ||--o{ PRODUCT : contains
    SELLER ||--o{ INVENTORY : manages
    PRODUCT ||--o{ INVENTORY : stocked_in
    ORDERS ||--|{ ORDER_DETAILS : contains
    PRODUCT ||--o{ ORDER_DETAILS : included_in
    ORDERS ||--o{ PAYMENT : has
    PRODUCT ||--o{ REVIEW : receives
    REVIEW ||--o| RATING : has

    CUSTOMER {
        int customer_id PK
        varchar name
        varchar email UK
        varchar phone
        varchar address
        varchar city
        datetime created_at
    }

    CATEGORY {
        int category_id PK
        varchar category_name UK
        varchar description
    }

    SELLER {
        int seller_id PK
        varchar seller_name
        varchar email UK
        varchar phone
        varchar address
    }

    PRODUCT {
        int product_id PK
        varchar product_name
        int category_id FK
        decimal price
        int stock
        varchar description
    }

    INVENTORY {
        int inventory_id PK
        int seller_id FK
        int product_id FK
        int available_stock
        int unavailable_stock
        datetime last_updated
    }

    ORDERS {
        int order_id PK
        int customer_id FK
        date order_date
        decimal total_amount
        varchar order_status
    }

    ORDER_DETAILS {
        int order_detail_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        decimal total_price
    }

    PAYMENT {
        int payment_id PK
        int order_id FK
        varchar payment_mode
        date payment_date
        decimal amount
        varchar payment_status
    }

    REVIEW {
        int review_id PK
        int customer_id FK
        int product_id FK
        text review_text
        date review_date
    }

    RATING {
        int rating_id PK
        int review_id FK
        int customer_id FK
        int product_id FK
        int rating_value
        date rating_date
    }
```

## Relationship Summary

- One customer can place many orders.
- One category can contain many products.
- Sellers and products are connected through inventory records.
- One order contains one or more order-detail records; each detail refers to a product.
- An order can have multiple payment records.
- Customers can review products. Each review can have one rating record.
- Ratings also reference the customer and product.

**Key:** PK = Primary Key, FK = Foreign Key, UK = Unique Key.
