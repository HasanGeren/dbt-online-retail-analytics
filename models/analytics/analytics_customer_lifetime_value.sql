-- models/analytics/analytics_customer_lifetime_value.sql

WITH customer_value AS (
    SELECT
        CustomerID,
        AVG(total_sales_value) AS avg_order_value,
        COUNT(DISTINCT InvoiceNo) AS num_orders,
        MAX(InvoiceDate) - MIN(InvoiceDate) AS customer_lifetime_days
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    avg_order_value,
    num_orders,
    customer_lifetime_days,
    (avg_order_value * num_orders) AS estimated_clv   -- Simple CLV calculation
FROM customer_value
