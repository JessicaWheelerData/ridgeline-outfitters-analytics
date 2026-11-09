-- RidgeLine Outfitters | Gold | 02_Gold_Sales_Performance
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE gold_sales_performance AS

WITH completed_orders AS (

    SELECT
        o.OrderID,
        o.OrderDate,
        o.CustomerID,
        o.ProductID,
        o.WarehouseID,
        o.Quantity,
        o.UnitPrice,
        o.GrossSales,
        o.DiscountAmount,
        o.NetSales

    FROM silver_orders o

    WHERE o.OrderStatus = 'Completed'
),

enriched_sales AS (

    SELECT
        o.OrderID,
        o.OrderDate,

        YEAR(o.OrderDate) AS OrderYear,
        QUARTER(o.OrderDate) AS OrderQuarter,
        MONTH(o.OrderDate) AS OrderMonth,

        DATE_FORMAT(o.OrderDate, 'MMM') AS OrderMonthName,

        CASE
            WHEN MONTH(o.OrderDate) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(o.OrderDate) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(o.OrderDate) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS Season,

        o.CustomerID,
        o.ProductID,
        o.WarehouseID,

        p.ProductName,
        p.Category,
        p.ProductLine,

        w.WarehouseName,
        w.Region,
        w.StateCode AS WarehouseStateCode,

        o.Quantity,
        o.UnitPrice,
        o.GrossSales,
        o.DiscountAmount,
        o.NetSales,

        p.UnitCost,

        ROUND(
            o.Quantity * p.UnitCost,
            2
        ) AS EstimatedCost,

        ROUND(
            o.NetSales - (o.Quantity * p.UnitCost),
            2
        ) AS EstimatedProfit,

        CASE
            WHEN o.NetSales = 0
                THEN NULL

            ELSE ROUND(
                (
                    o.NetSales - (o.Quantity * p.UnitCost)
                ) / o.NetSales,
                4
            )
        END AS EstimatedProfitMargin,

        CASE
            WHEN o.GrossSales = 0
                THEN 0

            ELSE ROUND(
                o.DiscountAmount / o.GrossSales,
                4
            )
        END AS DiscountRate

    FROM completed_orders o

    LEFT JOIN silver_products p
        ON o.ProductID = p.ProductID

    LEFT JOIN silver_warehouses w
        ON o.WarehouseID = w.WarehouseID
)

SELECT *
FROM enriched_sales;
