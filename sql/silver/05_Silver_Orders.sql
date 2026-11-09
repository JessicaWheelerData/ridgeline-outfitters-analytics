-- RidgeLine Outfitters | Silver | 05_Silver_Orders
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE silver_orders AS

SELECT
    OrderID,
    CustomerID,
    ProductID,
    WarehouseID,
    OrderDate,
    Quantity,
    UnitPrice,
    DiscountPercent,
    ShippingCost,

    ROUND(
        Quantity * UnitPrice,
        2
    ) AS GrossSales,

    ROUND(
        (Quantity * UnitPrice) * (DiscountPercent / 100.0),
        2
    ) AS DiscountAmount,

    ROUND(
        (Quantity * UnitPrice) -
        ((Quantity * UnitPrice) * (DiscountPercent / 100.0)),
        2
    ) AS NetSales,

    CASE
        WHEN LOWER(TRIM(OrderStatus)) = 'completed' THEN 'Completed'
        WHEN LOWER(TRIM(OrderStatus)) = 'processing' THEN 'Processing'
        WHEN LOWER(TRIM(OrderStatus)) = 'returned' THEN 'Returned'
        WHEN LOWER(TRIM(OrderStatus)) = 'cancelled' THEN 'Cancelled'
        ELSE TRIM(OrderStatus)
    END AS OrderStatus,

    ModifiedDate

FROM bronze_orders;
