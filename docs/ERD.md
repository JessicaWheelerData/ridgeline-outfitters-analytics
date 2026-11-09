# RidgeLine Outfitters — Entity Relationship Diagram

This diagram describes the **Silver-layer logical data model**, derived from the Databricks notebooks. PK = primary-key candidate; FK = foreign-key reference. The relationships reflect join logic and notebook validation, not a claim that physical foreign-key constraints are enforced in Databricks.

```mermaid
erDiagram
    silver_customers ||--o{ silver_orders : "CustomerID"
    silver_products ||--o{ silver_orders : "ProductID"
    silver_warehouses ||--o{ silver_orders : "WarehouseID"
    silver_products ||--o{ silver_inventory : "ProductID"
    silver_warehouses ||--o{ silver_inventory : "WarehouseID"

    silver_customers {
      int CustomerID PK
      string FirstName
      string LastName
      string AcquisitionSource
      boolean LoyaltyMember
    }
    silver_products {
      int ProductID PK
      string ProductName
      string Category
      decimal UnitCost
      decimal UnitPrice
    }
    silver_warehouses {
      int WarehouseID PK
      string WarehouseName
      string Region
    }
    silver_orders {
      int OrderID PK
      int CustomerID FK
      int ProductID FK
      int WarehouseID FK
      date OrderDate
      int Quantity
      decimal NetSales
    }
    silver_inventory {
      int InventoryID PK
      int ProductID FK
      int WarehouseID FK
      int QuantityOnHand
      int ReorderPoint
    }
```

![Silver-layer ERD](ERD.png)

## Gold analytical outputs

- `gold_sales_performance`: completed-order sales and estimated profitability, derived from `silver_orders`, `silver_products`, and `silver_warehouses`.
- `gold_inventory_demand_planning`: product-level inventory and 12-week demand planning, derived from `silver_products`, aggregated `silver_inventory`, and `silver_orders`. It is **not warehouse-grain**.
- `gold_customer_analysis`: customer-level lifetime metrics and segmentation, derived from `silver_customers`, `silver_orders`, and `silver_products`.

**Grain caution:** ProductName and customer full name are not unique identifiers. Use ProductID and CustomerID for distinct entity rankings.

**Validation:** On November 8, 2026, read-only Gold checks returned 17,826 distinct completed orders, 500 distinct products, and 1,000 distinct customers, matching dashboard totals. Those checks do not independently establish every Silver-layer relationship or physical key constraint.
