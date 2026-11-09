-- RidgeLine Outfitters | Silver | 02_Silver_Products
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE silver_products AS

SELECT
    ProductID,
    TRIM(ProductName) AS ProductName,
    TRIM(Category) AS Category,
    TRIM(ProductLine) AS ProductLine,
    UnitCost,
    UnitPrice,

    ROUND(UnitPrice - UnitCost, 2) AS UnitMargin,

    CASE
        WHEN UnitPrice <= UnitCost THEN TRUE
        ELSE FALSE
    END AS PricingReviewFlag,

    CASE
        WHEN LOWER(TRIM(Status)) = 'active' THEN 'Active'
        WHEN LOWER(TRIM(Status)) = 'discontinued' THEN 'Discontinued'
        ELSE TRIM(Status)
    END AS Status,

    ModifiedDate

FROM bronze_products;
