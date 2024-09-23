-- models/analytics/analytics_product_summary.sql

WITH sales AS (
    SELECT
        StockCode,
        SUM(total_sales_quantity) AS total_sales_quantity,      -- Total quantity sold for each product
        SUM(total_sales_quantity * UnitPrice) AS total_sales_value  -- Total value of sales for each product
    FROM {{ ref('stg_online_retail_product_focused') }}
    WHERE total_sales_quantity > 0
    GROUP BY StockCode
),
returns AS (
    SELECT
        StockCode,
        SUM(total_returned_quantity) AS total_returned_quantity,  -- Total quantity returned for each product
        SUM(total_returned_quantity * UnitPrice) AS total_returns_value  -- Total value of returns for each product
    FROM {{ ref('stg_online_retail_product_focused') }}
    WHERE total_returned_quantity < 0
    GROUP BY StockCode
)

SELECT
    COALESCE(sales.StockCode, returns.StockCode) AS StockCode,  -- Combine StockCode from sales and returns
    COALESCE(total_sales_quantity, 0) AS total_sales_quantity,
    COALESCE(total_sales_value, 0) AS total_sales_value,
    COALESCE(total_returned_quantity, 0) AS total_returned_quantity,
    COALESCE(total_returns_value, 0) AS total_returns_value,
    (COALESCE(total_sales_value, 0) + COALESCE(total_returns_value, 0)) AS net_value
FROM sales
FULL OUTER JOIN returns ON sales.StockCode = returns.StockCode
