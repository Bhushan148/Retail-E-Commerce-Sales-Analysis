## Semantic Model

The Power BI semantic model is built on a star-schema foundation to support scalable and performant analytical reporting.

The model centers on `fact_sales_order_item` and connects it with key business dimensions such as:

- `dim_date`
- `dim_product`
- `dim_customer`
- `dim_geography`
- `dim_region`

In addition to the core model, the solution also includes supporting tables for:

- centralized DAX logic through `_Measures`
- dynamic metric switching through `KPI Selector`
- controlled detail row presentation through `_Detail Rows`
- bridge-style analysis support through `_Revenue Bridge`
- refresh visibility through `Last Refresh`
- row-level security support through `UserRegionAccess`

This structure supports reusable business logic, controlled filter flow, analytical flexibility, and secure report consumption.
