-- models/staging/stg_online_retail_returns.sql

WITH source AS (
    SELECT
        InvoiceNo,
        CustomerID,
        Country,
        MIN(InvoiceDate) AS InvoiceDate,     -- Use the earliest InvoiceDate
        SUM(Quantity) AS total_returned_quantity,  -- Aggregate returned quantity
        AVG(UnitPrice) AS avg_returned_unit_price  -- Average price of returned items
    FROM {{ source('public', 'online_retail') }}
    WHERE CustomerID IS NOT NULL
      AND Quantity < 0            -- Filter for returns (negative quantity)
    GROUP BY InvoiceNo, CustomerID, Country
)

SELECT * FROM source
