-- models/staging/stg_online_retail_product_focused.sql

with source as (
    select
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        UnitPrice,
        CustomerID,
        Country,
        InvoiceDate
    from {{ source('public', 'online_retail') }}
    -- Keeping rows with NULL CustomerID and not deduplicating InvoiceNo
)

select * from source
