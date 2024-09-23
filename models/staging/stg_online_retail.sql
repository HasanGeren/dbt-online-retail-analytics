-- models/staging/stg_online_retail.sql

with source as (
    select
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        UnitPrice,
        CustomerID,
        Country
    from {{ source('public', 'online_retail') }}
)

select * from source;
