# Data architecture and lineage

## Medallion model

**Bronze:** `bronze_customers`, `bronze_products`, `bronze_warehouses`, `bronze_inventory`, and `bronze_orders` represent the operational source entities. The exported Bronze notebooks contain a mixture of table definitions, synthetic data population, and historical changes. The extracted Bronze SQL alone does not reproduce the live dataset.

**Silver:** `silver_customers`, `silver_products`, `silver_warehouses`, `silver_inventory`, and `silver_orders` provide standardized entities for analysis.

**Gold:**

| Table | Primary sources | Grain / purpose |
|---|---|---|
| `gold_sales_performance` | `silver_orders` joined to `silver_products` and `silver_warehouses` | Completed sales records with product, category, geography and estimated profit |
| `gold_inventory_demand_planning` | `silver_products`, aggregated `silver_inventory`, completed `silver_orders` | One row per product; inventory, 12-week demand, weeks of cover and recommendation |
| `gold_customer_analysis` | `silver_customers`, completed `silver_orders`, `silver_products` | One row per customer; lifetime sales/profit, purchase frequency and activity segment |

## Analytical logic

- Completed-order filtering is used for Gold sales and demand calculations.
- Estimated cost is `Quantity × UnitCost`; estimated profit is `NetSales − EstimatedCost`.
- Inventory demand measures recent completed orders within a 12-week window anchored to the latest completed order date.
- Replenishment classes in the extracted final inventory SQL use `WeeksOfCover` thresholds, including less than four weeks for reorder and at least 52 weeks for excess, with separate no-demand handling. Refer to the SQL for precise CASE precedence.
- Customer activity and frequency segments derive from historical completed orders and the reference date logic in the Gold customer query.

## Data quality and modeling considerations

1. `ProductID` is the product key; `ProductName` is not unique.
2. `CustomerID` is the customer key; full customer names are not unique.
3. Product-level inventory is aggregated across warehouses, so recommendations do not represent a warehouse-specific replenishment plan.
4. Estimated profit uses current product unit cost and does not represent a historical cost ledger.
5. Historical repair actions are not incorporated into the extracted final CREATE statements; rerunning Bronze is unsafe without reconstruction and reconciliation.
6. Live results and data permissions were not verified during this offline packaging session.
