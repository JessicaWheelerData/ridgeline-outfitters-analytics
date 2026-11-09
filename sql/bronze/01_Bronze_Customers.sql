-- RidgeLine Outfitters | Bronze | 01_Bronze_Customers
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE bronze_customers (
    CustomerID INT,
    FirstName STRING,
    LastName STRING,
    Email STRING,
    StateCode STRING,
    JoinDate DATE,
    LoyaltyMember BOOLEAN,
    AcquisitionSource STRING,
    Status STRING,
    ModifiedDate DATE
);
