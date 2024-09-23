-- models/analytics/analytics_monthly_summary.sql

WITH sales AS (
    SELECT
        DATE_TRUNC('month', InvoiceDate) AS month,
        SUM(total_quantity) AS total_sales_quantity,
        SUM(total_quantity * avg_unit_price) AS total_sales_value
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY DATE_TRUNC('month', InvoiceDate)
),
returns AS (
    SELECT
        DATE_TRUNC('month', InvoiceDate) AS month,
        SUM(total_returned_quantity) AS total_returned_quantity,
        SUM(total_returned_quantity * avg_returned_unit_price) AS total_returns_value
    FROM {{ ref('stg_online_retail_returns') }}
    GROUP BY DATE_TRUNC('month', InvoiceDate)
)

SELECT
    COALESCE(sales.month, returns.month) AS month,  -- Combine months with sales or returns
    COALESCE(total_sales_quantity, 0) AS total_sales_quantity,
    COALESCE(total_sales_value, 0) AS total_sales_value,
    COALESCE(total_returned_quantity, 0) AS total_returned_quantity,
    COALESCE(total_returns_value, 0) AS total_returns_value,
    (COALESCE(total_sales_value, 0) + COALESCE(total_returns_value, 0)) AS net_value
FROM sales
FULL OUTER JOIN returns ON sales.month = returns.month
ORDER BY month
