-- Read-only checks: run in Databricks against the live Gold tables.
SELECT COUNT(*) AS completed_orders, COUNT(DISTINCT OrderID) AS distinct_orders,
 ROUND(SUM(NetSales),2) AS net_sales, ROUND(SUM(EstimatedProfit),2) AS estimated_profit,
 MAX(OrderDate) AS latest_sales_date FROM gold_sales_performance;

SELECT COUNT(*) AS products, COUNT(DISTINCT ProductID) AS distinct_products,
 ROUND(SUM(TotalQuantityOnHand * UnitCost),2) AS inventory_value,
 SUM(CASE WHEN ReplenishmentRecommendation='Reorder Now' THEN 1 ELSE 0 END) AS reorder_products,
 ROUND(SUM(CASE WHEN ReplenishmentRecommendation='Excess Inventory' THEN TotalQuantityOnHand * UnitCost ELSE 0 END),2) AS excess_inventory_value,
 ROUND(SUM(CASE WHEN ReplenishmentRecommendation='No Recent Demand' THEN TotalQuantityOnHand * UnitCost ELSE 0 END),2) AS no_demand_inventory_value
FROM gold_inventory_demand_planning;

SELECT CustomerActivitySegment, COUNT(*) AS customers FROM gold_customer_analysis
GROUP BY CustomerActivitySegment ORDER BY CustomerActivitySegment;

SELECT COUNT(*) AS customers, COUNT(DISTINCT CustomerID) AS distinct_customers,
 ROUND(SUM(LifetimeNetSales),2) AS lifetime_net_sales,
 ROUND(SUM(LifetimeEstimatedProfit),2) AS lifetime_estimated_profit
FROM gold_customer_analysis;
