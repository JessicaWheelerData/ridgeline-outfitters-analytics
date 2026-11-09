-- RidgeLine Outfitters | Bronze | 03_Bronze_Warehouses
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE bronze_warehouses (

    WarehouseID INT,
    WarehouseName STRING,
    Region STRING,
    StateCode STRING,
    Status STRING,
    ModifiedDate DATE

);
