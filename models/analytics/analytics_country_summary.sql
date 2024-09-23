-- models/analytics/analytics_country_summary.sql

WITH sales AS (
    SELECT
        Country,
        SUM(total_quantity) AS total_sales_quantity,
        SUM(total_quantity * avg_unit_price) AS total_sales_value
    FROM {{ ref('stg_online_retail_sales') }}
    GROUP BY Country
),
returns AS (
    SELECT
        Country,
        SUM(total_returned_quantity) AS total_returned_quantity,
        SUM(total_returned_quantity * avg_returned_unit_price) AS total_returns_value
    FROM {{ ref('stg_online_retail_returns') }}
    GROUP BY Country
)

SELECT
    COALESCE(sales.Country, returns.Country) AS Country,  -- Combine countries with sales or returns
    COALESCE(total_sales_quantity, 0) AS total_sales_quantity,
    COALESCE(total_sales_value, 0) AS total_sales_value,
    COALESCE(total_returned_quantity, 0) AS total_returned_quantity,
    COALESCE(total_returns_value, 0) AS total_returns_value,
    (COALESCE(total_sales_value, 0) + COALESCE(total_returns_value, 0)) AS net_value
FROM sales
FULL OUTER JOIN returns ON sales.Country = returns.Country
