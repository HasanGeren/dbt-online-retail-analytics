-- models/staging/stg_online_retail_product_focused.sql

WITH source AS (
    SELECT
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        UnitPrice,
        CustomerID,
        Country
    FROM {{ source('public', 'online_retail') }}
    WHERE CustomerID IS NOT NULL  -- Exclude rows with NULL CustomerID if necessary
)

SELECT
    InvoiceNo,
    StockCode,
    Description,
    CASE
        WHEN Quantity > 0 THEN Quantity
        ELSE 0
    END AS total_sales_quantity,
    CASE
        WHEN Quantity < 0 THEN Quantity
        ELSE 0
    END AS total_returned_quantity,
    UnitPrice,
    CustomerID,
    Country,
    InvoiceDate
FROM source
