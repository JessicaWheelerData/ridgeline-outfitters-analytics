-- RidgeLine Outfitters | Gold | 01_Gold_Inventory_Demand_Planning
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE gold_inventory_demand_planning AS

WITH demand_window AS (

    SELECT
        MAX(OrderDate) AS EndDate,
        DATE_SUB(MAX(OrderDate), 83) AS StartDate
    FROM silver_orders
    WHERE OrderStatus = 'Completed'

),

recent_demand AS (

    SELECT
        o.ProductID,
        SUM(o.Quantity) AS UnitsSoldLast12Weeks,
        COUNT(DISTINCT o.OrderID) AS OrdersLast12Weeks,
        ROUND(SUM(o.NetSales), 2) AS NetSalesLast12Weeks

    FROM silver_orders o
    CROSS JOIN demand_window d

    WHERE o.OrderStatus = 'Completed'
      AND o.OrderDate BETWEEN d.StartDate AND d.EndDate

    GROUP BY o.ProductID
),

inventory_summary AS (

    SELECT
        ProductID,
        SUM(QuantityOnHand) AS TotalQuantityOnHand,
        SUM(ReorderPoint) AS TotalReorderPoint,
        COUNT(DISTINCT WarehouseID) AS WarehousesStockingProduct

    FROM silver_inventory

    GROUP BY ProductID
),

base_metrics AS (

    SELECT
        p.ProductID,
        p.ProductName,
        p.Category,
        p.ProductLine,
        p.UnitCost,
        p.UnitPrice,
        p.UnitMargin,
        p.PricingReviewFlag,

        COALESCE(i.TotalQuantityOnHand, 0) AS TotalQuantityOnHand,
        COALESCE(i.TotalReorderPoint, 0) AS TotalReorderPoint,
        COALESCE(i.WarehousesStockingProduct, 0) AS WarehousesStockingProduct,

        COALESCE(d.UnitsSoldLast12Weeks, 0) AS UnitsSoldLast12Weeks,
        COALESCE(d.OrdersLast12Weeks, 0) AS OrdersLast12Weeks,
        COALESCE(d.NetSalesLast12Weeks, 0) AS NetSalesLast12Weeks,

        ROUND(
            COALESCE(d.UnitsSoldLast12Weeks, 0) / 12.0,
            2
        ) AS AvgWeeklyDemand,

        CASE
            WHEN COALESCE(d.UnitsSoldLast12Weeks, 0) = 0
                THEN NULL
            ELSE ROUND(
                i.TotalQuantityOnHand /
                (d.UnitsSoldLast12Weeks / 12.0),
                2
            )
        END AS WeeksOfCover

    FROM silver_products p

    LEFT JOIN recent_demand d
        ON p.ProductID = d.ProductID

    LEFT JOIN inventory_summary i
        ON p.ProductID = i.ProductID
)

SELECT
    *,

    CASE
        WHEN UnitsSoldLast12Weeks = 0
            THEN 'No Recent Demand'

        WHEN WeeksOfCover < 4
            THEN 'Reorder Now'

        WHEN WeeksOfCover >= 52
            THEN 'Excess Inventory'

        WHEN WeeksOfCover >= 26
            THEN 'Elevated Inventory'

        ELSE 'Healthy'
    END AS ReplenishmentRecommendation

FROM base_metrics;
