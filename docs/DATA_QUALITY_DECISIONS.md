# Data quality and validation decisions

A portfolio should show the decisions that improved analytical reliability—not a diary of every development iteration.

- **Stable identifiers:** Multiple products share a ProductName and multiple customers share the same first/last names. Product rankings therefore use `ProductID`; customer rankings use `CustomerID` to avoid combining separate records.
- **Cross-table reconciliation:** Read-only checks of the Gold sales and customer tables each returned **$4,919,152.80 net sales** and **$2,021,282.81 estimated profit**, supporting consistency between transactional and customer-level analysis.
- **Unique analytical grains:** Gold checks showed **17,826 completed/distinct orders**, **500 total/distinct products**, and **1,000 total/distinct customers**.
- **Meaningful visual interactions:** Report interactions were reviewed so company-wide KPI cards and fixed Top N rankings are not misleadingly redefined by unrelated chart selections. Interactive exploration remains available where useful.
- **SQL version control:** The exported notebooks include historical transformation iterations and data repairs. GitHub contains selected final query extracts and documents that these are review/reference SQL, **not** a guaranteed fresh-install deployment pipeline.

**Limits:** These checks validate headline Gold metrics, not every Silver key relationship, every transformation, or all possible dashboard interactions. The ERD is a logical model; it does not assert physically enforced foreign keys.
