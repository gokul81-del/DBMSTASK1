# Task XIV — Business Intelligence and AI Data Preparation

## Requirements

1. Create analytical reports using SQL.
2. Apply window functions such as RANK() and ROW_NUMBER().
3. Generate customer segmentation data.
4. Prepare datasets for AI models.
5. Perform feature extraction using SQL.

## SQL File

- `business_intelligence_ai.sql` — Contains business reports, window-function examples, customer segments, and model-ready feature datasets.

## Reports and Features

- Customer spending and order summary
- Product sales ranking with RANK() and ROW_NUMBER()
- Customer segmentation based on total spending
- Customer-level features such as order count, total spend, average order value, and recency
- Product-level features such as price, stock, quantity sold, and revenue
- A model-ready customer dataset with one row per customer

## Execution

Run Tasks I to V first so the required tables and sample data exist. Then execute `business_intelligence_ai.sql` in MySQL 8.0 or later because the script uses window functions and common table expressions.

The segmentation thresholds are example rules for this assignment and can be adjusted to suit a real dataset. Review the output and handle missing values and data quality before training an AI model.
