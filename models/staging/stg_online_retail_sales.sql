-- models/staging/stg_online_retail_sales.sql

WITH source AS (
    SELECT
        InvoiceNo,
        CustomerID,
        Country,
        MIN(InvoiceDate) AS InvoiceDate,     -- Use the earliest InvoiceDate 
        SUM(Quantity) AS total_quantity,     -- Aggregate total quantity sold
        AVG(UnitPrice) AS avg_unit_price     -- Average unit price for each InvoiceNo
    FROM {{ source('public', 'online_retail') }}
    WHERE CustomerID IS NOT NULL
      AND Quantity > 0            -- Filter for sales (positive quantity)
    GROUP BY InvoiceNo, CustomerID, Country
)

SELECT * FROM source
