-- RidgeLine Outfitters | Silver | 04_Silver_Inventory
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE silver_inventory AS

SELECT
    InventoryID,
    ProductID,
    WarehouseID,
    QuantityOnHand,
    ReorderPoint,

    QuantityOnHand - ReorderPoint AS UnitsAboveReorderPoint,

    CASE
        WHEN QuantityOnHand = 0 THEN 'Out of Stock'
        WHEN QuantityOnHand <= ReorderPoint THEN 'Reorder Needed'
        ELSE 'In Stock'
    END AS InventoryStatus,

    ModifiedDate

FROM bronze_inventory;
