-- RidgeLine Outfitters | Bronze | 04_Bronze_Inventory
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE bronze_inventory (

    InventoryID INT,
    ProductID INT,
    WarehouseID INT,
    QuantityOnHand INT,
    ReorderPoint INT,
    ModifiedDate DATE

);
