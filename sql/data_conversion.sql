-- data_conversion.sql

INSERT INTO online_retail (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
SELECT InvoiceNo, StockCode, Description, Quantity, 
       to_timestamp(InvoiceDate, 'MM/DD/YYYY HH24:MI') as InvoiceDate, 
       UnitPrice, CustomerID, Country
FROM online_retail_staging;
