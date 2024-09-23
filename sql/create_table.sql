-- create_table.sql
CREATE TABLE online_retail (
  InvoiceNo VARCHAR,
  StockCode VARCHAR,
  Description VARCHAR,
  Quantity INTEGER,
  InvoiceDate TIMESTAMP,
  UnitPrice FLOAT,
  CustomerID VARCHAR,
  Country VARCHAR
);

CREATE TABLE online_retail_staging (
  InvoiceNo VARCHAR,
  StockCode VARCHAR,
  Description VARCHAR,
  Quantity INTEGER,
  InvoiceDate TEXT,
  UnitPrice FLOAT,
  CustomerID VARCHAR,
  Country VARCHAR
);