-- models/analytics/analytics_customer_retention.sql

WITH customer_purchases AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_purchases,  -- Count unique invoices per customer
        MIN(InvoiceDate) AS first_purchase_date,       -- First purchase date
        MAX(InvoiceDate) AS last_purchase_date         -- Most recent purchase date
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_purchases,
    first_purchase_date,
    last_purchase_date,
    CASE
        WHEN total_purchases = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type
FROM customer_purchases
