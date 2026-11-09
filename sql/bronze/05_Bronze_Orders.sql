-- RidgeLine Outfitters | Bronze | 05_Bronze_Orders
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE bronze_orders AS

WITH customer_weights AS (

    SELECT
        CustomerID,

        CASE
            WHEN pmod(CustomerID * 37, 100) < 50 THEN 1
            WHEN pmod(CustomerID * 37, 100) < 80 THEN 3
            WHEN pmod(CustomerID * 37, 100) < 95 THEN 6
            ELSE 12
        END AS CustomerWeight

    FROM bronze_customers
),

weighted_customers AS (

    SELECT
        CustomerID,
        ROW_NUMBER() OVER (
            ORDER BY CustomerID, WeightSequence
        ) - 1 AS WeightedPosition

    FROM customer_weights

    LATERAL VIEW EXPLODE(
        SEQUENCE(1, CustomerWeight)
    ) exploded AS WeightSequence
),

weight_count AS (

    SELECT COUNT(*) AS TotalWeightedPositions
    FROM weighted_customers
),

orders_numbered AS (

    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY OrderID) - 1 AS OrderPosition

    FROM bronze_orders_pre_customer_fix
)

SELECT
    o.OrderID,

    wc.CustomerID,

    o.ProductID,
    o.WarehouseID,
    o.OrderDate,
    o.Quantity,
    o.UnitPrice,
    o.DiscountPercent,
    o.ShippingCost,
    o.OrderStatus,
    o.ModifiedDate

FROM orders_numbered o

CROSS JOIN weight_count x

LEFT JOIN weighted_customers wc
    ON wc.WeightedPosition =
       PMOD(o.OrderPosition * 7919, x.TotalWeightedPositions);
