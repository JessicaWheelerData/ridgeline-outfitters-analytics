# SQL review and release status

## Work completed offline

- Examined the exported Databricks project archive and extracted the **last** `CREATE OR REPLACE TABLE` statement for each of the five Bronze, five Silver, and three Gold notebooks.
- Excluded earlier table-building definitions from the packaged Gold inventory and customer scripts to avoid conflicting definitions.
- Preserved a read-only validation query file for future reconciliation.
- Organized scripts and documentation for a GitHub portfolio.

## Findings and risks

| Item | Finding | Disposition |
|---|---|---|
| Duplicate Gold definitions | Inventory and customer notebooks contain earlier and later table definitions | Package only last table-building statement |
| Historical data repair | Separate repair notebook affects previously generated data | Do not rerun or publish as a deployment step |
| Bronze reproducibility | Extracted CREATE statements do not capture all source-generation/repair steps | Mark as reference-only |
| Table replacement | `CREATE OR REPLACE TABLE` overwrites existing definitions | Do not execute packaged scripts against live tables |
| Profit definition | Estimated product-level profit, not booked accounting profit | Disclose in README and findings |
| Inventory grain | Product aggregate, not warehouse-specific | Disclose in README and findings |
| Name uniqueness | Product and customer names can repeat | Use stable IDs for rankings |
| Live validation | Not performed during offline review | Explicitly unverified |

## Validation status

Previously reviewed report reference values are in the repository README. `sql/validation/VALIDATION_QUERIES.sql` is available to compare those figures against live Gold tables, but **no result from those queries is claimed here**. This is a documented portfolio source snapshot, not a production-certified or fully reproducible pipeline.

## Safe next steps (optional, not required to read the portfolio)

1. Compare read-only query outputs to report reference values when live access is convenient.
2. Reconstruct Bronze data generation and historical repairs if end-to-end reproducibility becomes a goal.
3. Add Power BI PBIX and screenshots once those files are available.
4. Review the repository for secrets or sensitive data before publishing.
