-- RidgeLine Outfitters | Silver | 01_Silver_Customers
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE silver_customers AS

SELECT
    CustomerID,
    TRIM(FirstName) AS FirstName,
    TRIM(LastName) AS LastName,
    LOWER(TRIM(Email)) AS Email,
    UPPER(TRIM(StateCode)) AS StateCode,
    JoinDate,
    LoyaltyMember,
    TRIM(AcquisitionSource) AS AcquisitionSource,
    TRIM(Status) AS Status,

    CASE
        WHEN Email IS NULL OR TRIM(Email) = '' THEN TRUE
        ELSE FALSE
    END AS EmailMissingFlag,

    ModifiedDate

FROM bronze_customers;
