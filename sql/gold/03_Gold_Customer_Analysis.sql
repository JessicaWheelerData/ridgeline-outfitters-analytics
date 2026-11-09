-- RidgeLine Outfitters | Gold | 03_Gold_Customer_Analysis
-- Extracted from the LAST table-building statement in the exported notebook.
-- REVIEW ONLY: Do not execute until reconciled with the live Databricks tables.

CREATE OR REPLACE TABLE gold_customer_analysis AS

WITH completed_customer_orders AS (

    SELECT
        o.OrderID,
        o.OrderDate,
        o.CustomerID,
        o.ProductID,
        o.Quantity,
        o.NetSales,
        p.UnitCost,
        ROUND(
            o.NetSales - (o.Quantity * p.UnitCost),
            2
        ) AS EstimatedProfit

    FROM silver_orders o

    LEFT JOIN silver_products p
        ON o.ProductID = p.ProductID

    WHERE o.OrderStatus = 'Completed'
),

customer_purchase_summary AS (

    SELECT
        CustomerID,
        COUNT(DISTINCT OrderID) AS LifetimeOrders,
        SUM(Quantity) AS LifetimeUnitsPurchased,
        ROUND(SUM(NetSales), 2) AS LifetimeNetSales,
        ROUND(SUM(EstimatedProfit), 2) AS LifetimeEstimatedProfit,
        ROUND(AVG(NetSales), 2) AS AverageOrderValue,
        MIN(OrderDate) AS FirstPurchaseDate,
        MAX(OrderDate) AS LastPurchaseDate

    FROM completed_customer_orders

    GROUP BY CustomerID
),

customer_behavior AS (

    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        c.StateCode,
        c.LoyaltyMember,
        c.AcquisitionSource,
        c.Status AS CustomerStatus,
        c.JoinDate,

        COALESCE(s.LifetimeOrders, 0) AS LifetimeOrders,
        COALESCE(s.LifetimeUnitsPurchased, 0) AS LifetimeUnitsPurchased,
        COALESCE(s.LifetimeNetSales, 0) AS LifetimeNetSales,
        COALESCE(s.LifetimeEstimatedProfit, 0)
            AS LifetimeEstimatedProfit,
        COALESCE(s.AverageOrderValue, 0) AS AverageOrderValue,

        s.FirstPurchaseDate,
        s.LastPurchaseDate,

        DATEDIFF(
            (SELECT MAX(OrderDate) FROM silver_orders),
            s.LastPurchaseDate
        ) AS DaysSinceLastPurchase,

        DATEDIFF(
            (SELECT MAX(OrderDate) FROM silver_orders),
            c.JoinDate
        ) AS CustomerTenureDays,

        CASE
            WHEN COALESCE(s.LifetimeOrders, 0) = 0
                THEN 'No Purchase'

            WHEN s.LifetimeOrders <= 7
                THEN 'Occasional Customer'

            WHEN s.LifetimeOrders <= 21
                THEN 'Repeat Customer'

            ELSE 'High-Frequency Customer'
        END AS PurchaseFrequencySegment,

        CASE
            WHEN s.LastPurchaseDate IS NULL
                THEN 'No Purchase'

            WHEN DATEDIFF(
                (SELECT MAX(OrderDate) FROM silver_orders),
                s.LastPurchaseDate
            ) <= 90
                THEN 'Active'

            WHEN DATEDIFF(
                (SELECT MAX(OrderDate) FROM silver_orders),
                s.LastPurchaseDate
            ) <= 180
                THEN 'At Risk'

            ELSE 'Inactive'
        END AS CustomerActivitySegment

    FROM silver_customers c

    LEFT JOIN customer_purchase_summary s
        ON c.CustomerID = s.CustomerID
)

SELECT *
FROM customer_behavior;
