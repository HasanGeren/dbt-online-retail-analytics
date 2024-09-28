-- models/analytics/analytics_churn.sql

WITH customer_churn AS (
    SELECT
        CustomerID,
        MAX(InvoiceDate) AS last_purchase_date,
        EXTRACT(DAY FROM (CURRENT_DATE - MAX(InvoiceDate))) AS days_since_last_purchase,
        EXTRACT(DAY FROM (MAX(InvoiceDate) - MIN(InvoiceDate))) AS total_time_between_purchases  -- Calculate time between first and last purchase
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY CustomerID
),
average_time_between_purchases AS (
    SELECT
        CustomerID,
        total_time_between_purchases,
        CASE
            WHEN total_time_between_purchases = 0 THEN NULL  -- Handle case where there is only one purchase
            ELSE total_time_between_purchases / COUNT(*)  -- Calculate average time between purchases
        END AS avg_time_between_purchases
    FROM customer_churn
    GROUP BY CustomerID, total_time_between_purchases
)

SELECT
    customer_churn.CustomerID,
    customer_churn.last_purchase_date,
    customer_churn.days_since_last_purchase,
    average_time_between_purchases.avg_time_between_purchases,
    CASE
        WHEN days_since_last_purchase > avg_time_between_purchases THEN 'Churned'
        ELSE 'Active'
    END AS churn_status
FROM customer_churn
JOIN average_time_between_purchases
    ON customer_churn.CustomerID = average_time_between_purchases.CustomerID
