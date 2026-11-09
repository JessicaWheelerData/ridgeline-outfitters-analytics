-- RidgeLine Outfitters | Silver | 03_Silver_Warehouses
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE silver_warehouses AS

SELECT
    WarehouseID,
    TRIM(WarehouseName) AS WarehouseName,
    TRIM(Region) AS Region,
    UPPER(TRIM(StateCode)) AS StateCode,

    CASE
        WHEN LOWER(TRIM(Status)) = 'active' THEN 'Active'
        WHEN LOWER(TRIM(Status)) = 'inactive' THEN 'Inactive'
        ELSE TRIM(Status)
    END AS Status,

    ModifiedDate

FROM bronze_warehouses;
