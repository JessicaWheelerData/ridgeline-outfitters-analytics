-- RidgeLine Outfitters | Bronze | 02_Bronze_Products
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE bronze_products (
    ProductID INT,
    ProductName STRING,
    Category STRING,
    ProductLine STRING,
    UnitCost DECIMAL(10,2),
    UnitPrice DECIMAL(10,2),
    Status STRING,
    ModifiedDate DATE
);
