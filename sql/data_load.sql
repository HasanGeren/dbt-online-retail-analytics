\copy online_retail(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
FROM 'C:\Users\User\OneDrive\Belgeler\my-workspace\projects\dbt-online-retail-analytics\online_retail_analytics\data\data.csv'
DELIMITER ',' CSV HEADER;