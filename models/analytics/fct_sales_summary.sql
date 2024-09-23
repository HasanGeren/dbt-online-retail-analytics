-- models/analytics/fct_sales_summary.sql

with sales_data as (
    select
        InvoiceNo,
        sum(Quantity * UnitPrice) as total_sales,
        Country,
        date_trunc('day', InvoiceDate) as sales_date
    from {{ ref('stg_online_retail') }}
    group by InvoiceNo, Country, sales_date
)

select
    sales_date,
    Country,
    sum(total_sales) as total_sales_by_country
from sales_data
group by sales_date, Country
order by sales_date
