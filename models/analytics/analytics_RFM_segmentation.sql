-- models/analytics/analytics_RFM_segmentation.sql

WITH customer_rfm AS (
    SELECT
        CustomerID,
        EXTRACT(DAY FROM (CURRENT_DATE - MAX(InvoiceDate))) AS recency,  -- Days since last purchase
        COUNT(DISTINCT InvoiceNo) AS frequency,                           -- Number of purchases
        SUM(total_sales_value) AS monetary                                -- Total value of purchases
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    recency,
    frequency,
    monetary,
    CASE
        WHEN recency < 30 THEN 'Very Recent'
        WHEN recency < 90 THEN 'Recent'
        ELSE 'Inactive'
    END AS recency_segment,
    CASE
        WHEN frequency > 10 THEN 'Frequent'
        ELSE 'Occasional'
    END AS frequency_segment
FROM customer_rfm
