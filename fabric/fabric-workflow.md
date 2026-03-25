# Fabric Workflow

## Overview

This document explains the end-to-end Microsoft Fabric workflow used in the **Retail & E-Commerce Sales Analysis** solution, starting from raw source data ingestion and continuing through transformation, modeling, orchestration, semantic modeling, and Power BI report consumption.

The workflow is structured so that data preparation, backend processing, and reporting remain clearly separated while still supporting an automated end-to-end flow.

---

## Workflow Summary

```text
Source Data
→ Dataflow Gen2 Ingestion and Initial Transformation
→ dbo Layer in Lakehouse
→ Silver Layer Standardization Notebook
→ Gold Layer Dimensional Modeling Notebook
→ Semantic Model
→ Power BI Report
→ End-to-End Pipeline Orchestration
```

---

## Core Fabric Items Used

- `00_ORCH_EndToEnd_Data_Pipeline`
- `01_DFGen2_Ingestion_Transformation_DBO`
- `02_NB_Silver_Layer_Standardization`
- `03_NB_Gold_Layer_Dimensional_Model`
- `04_SM_Retail_ECommerce_Sales_Model`
- `05_RPT_Retail_ECommerce_Sales_Analysis`
- `LH_Ecommerce`

---

## Step 1: Source Data Collection

The workflow starts with collecting the retail and e-commerce source data. In this solution, the source data is first reviewed and understood so the required entities, business fields, and reporting scope are clear before loading into Fabric.

Typical business entities included in the flow are:

- customers
- products
- orders
- order items
- customer segments
- channels
- geography
- regions
- order statuses

This stage is important for understanding the source structure before building the analytical layers.

---

## Step 2: Data Ingestion and Initial Transformation

### Item
`01_DFGen2_Ingestion_Transformation_DBO`

Data ingestion is handled using **Dataflow Gen2**. This stage is used to connect to the source data, perform the initial shaping, and load the data into the Fabric environment.

### Role of This Step

- connect to source data
- ingest raw business data into Fabric
- apply initial transformation where required
- load the results into the `dbo` layer

### Output of This Step

The output is a set of source-aligned landing tables stored in the Fabric environment. These are used as the starting point for notebook-based backend transformation.

---

## Step 3: dbo Layer / Landing Layer

### Item
`LH_Ecommerce`

The `dbo` layer acts as the structured landing area after Dataflow Gen2 ingestion. At this stage, the data is available inside the Lakehouse in a more controlled format than the original source files, but it is not yet fully standardized for analytics.

### Purpose of dbo Layer

- serve as the ingestion landing layer
- preserve source-aligned table structure
- support downstream notebook transformation
- separate ingestion from later modeling logic

Typical landed tables include:

- `channels`
- `customer_addresses`
- `customer_segments`
- `customers`
- `geography`
- `order_items`
- `order_statuses`
- `orders`
- `products`
- `region`

---

## Step 4: Silver Layer Standardization

### Item
`02_NB_Silver_Layer_Standardization`

The Silver layer is created using a Fabric notebook. This step takes the landed `dbo` data and standardizes it into cleaner backend tables.

### Main Activities in Silver Layer

- validate source tables
- standardize structure and naming
- preserve clean source-aligned tables for downstream modeling
- prepare trusted data for Gold layer transformations

### Output of Silver Layer

The result is a clean Silver layer that can be used for dimensional modeling without mixing ingestion logic with analytics logic.

---

## Step 5: Gold Layer Dimensional Modeling

### Item
`03_NB_Gold_Layer_Dimensional_Model`

The Gold layer notebook builds the analytical model used by Power BI. At this stage, the backend transitions from table preparation to business-focused modeling.

### Main Activities in Gold Layer

- create dimension tables
- create the transaction fact table
- build a star schema
- generate analytical keys where required
- convert source-driven fields into reporting-ready structure
- align the model for Power BI consumption

### Gold Tables Created

Typical analytical tables in the model include:

- `dim_region`
- `dim_geography`
- `dim_customer`
- `dim_product`
- `fact_sales_order_item`

### Modeling Objective

The Gold layer is designed so the analytical model is:

- scalable
- reporting-friendly
- easier to relate in Power BI
- suitable for measure-driven analysis

---

## Step 6: Lakehouse as the Backend Foundation

### Item
`LH_Ecommerce`

The Lakehouse is the central backend storage layer used by the solution. It stores the backend data across the landing, Silver, and Gold processing stages.

### Role of the Lakehouse

- stores the backend tables used across the workflow
- acts as the data foundation for the analytical solution
- supports the transition from ingestion to semantic modeling
- provides a structured backend layer before Power BI consumption

---

## Step 7: Semantic Model Creation

### Item
`04_SM_Retail_ECommerce_Sales_Model`

Once the Gold layer is ready, the next step is to create the semantic model.

### Purpose of the Semantic Model

- define business-friendly relationships
- centralize DAX and business logic
- expose a clean analytical model for reporting
- support KPI and subject-area reporting across pages

### Design Approach

The semantic model is designed using **Import mode** and a **star schema** structure to support strong reporting performance and flexible DAX implementation.

### Areas Covered in the Semantic Model

- relationship management
- measure-driven analysis
- filter-flow control
- row-level security design
- incremental refresh planning
- scheduled refresh support

---

## Step 8: Power BI Report Development

### Item
`05_RPT_Retail_ECommerce_Sales_Analysis`

The report is built on top of the semantic model and acts as the final business-facing consumption layer.

### Report Scope

The report is designed to support:

- executive KPI monitoring
- sales analysis
- customer analysis
- product analysis
- detailed financial and operational review

### Report Features Included

- KPI cards
- trend analysis
- contribution visuals
- guided info pages
- KPI tooltips
- contextual tooltips
- bookmark-based filter pane
- reset actions
- navigation support
- last refresh status visibility

### Important Reporting Note

The report consumes the semantic model. Once the semantic model is refreshed, the report reflects the updated data automatically.

---

## Step 9: Power BI Connection

After the Gold layer is built, Power BI connects to the semantic model rather than directly to the raw source or transformation logic.

### Recommended Connection Flow

```text
Gold Layer → Semantic Model → Power BI Report
```

### Why This Matters

Connecting through the semantic model instead of directly to raw backend tables provides:

- cleaner business logic
- controlled relationships
- reusable measures
- better security control
- stronger maintainability
- better reporting performance

---

## Step 10: End-to-End Orchestration

### Item
`00_ORCH_EndToEnd_Data_Pipeline`

The orchestration pipeline manages the backend workflow in sequence so that the solution can run in a controlled end-to-end manner.

### Pipeline Flow

```text
01_DFGen2_Ingestion_Transformation_DBO
→ 02_NB_Silver_Layer_Standardization
→ 03_NB_Gold_Layer_Dimensional_Model
→ 04_SM_Retail_ECommerce_Sales_Model
```

### Role of the Pipeline

- run the Dataflow Gen2 ingestion step
- run the Silver notebook
- run the Gold notebook
- refresh the semantic model
- support backend sequencing and monitoring

This creates a clear separation between the backend processing flow and the final reporting layer.

---

## Refresh and Reporting Flow

The complete refresh-oriented flow can be viewed like this:

```text
Source Data
→ Dataflow Gen2 Refresh
→ dbo Layer
→ Silver Notebook Run
→ Gold Notebook Run
→ Semantic Model Refresh
→ Updated Power BI Report
```

### Refresh Considerations

The solution is designed with these reporting considerations in mind:

- Import mode semantic modeling
- scheduled refresh support
- incremental refresh planning
- controlled semantic model refresh after backend processing
- report visibility of latest refresh status

---

## Why the Workflow Is Structured This Way

This workflow is structured so that each stage has a clear role:

- **Dataflow Gen2** handles ingestion and first-stage shaping
- **dbo** acts as the landing layer
- **Silver notebook** standardizes and prepares trusted backend tables
- **Gold notebook** builds the analytics-ready dimensional model
- **Lakehouse** stores backend layers
- **Semantic model** organizes business logic for Power BI
- **Power BI report** delivers the final analytical experience
- **Pipeline** orchestrates the end-to-end backend execution

This separation makes the solution easier to maintain, easier to understand, and better aligned with a scalable analytical architecture.

---

## Prerequisites

Before running this workflow, the following are typically needed:

- Microsoft Fabric workspace access
- Dataflow Gen2 access
- Fabric Notebook support
- Lakehouse access
- Power BI Desktop
- Power BI semantic model / report access
- permissions to create or refresh Fabric items

---

## Execution Order

The practical execution order for this solution is:

1. Run `01_DFGen2_Ingestion_Transformation_DBO`
2. Validate landed tables in `LH_Ecommerce`
3. Run `02_NB_Silver_Layer_Standardization`
4. Validate Silver layer outputs
5. Run `03_NB_Gold_Layer_Dimensional_Model`
6. Validate Gold fact and dimension tables
7. Refresh `04_SM_Retail_ECommerce_Sales_Model`
8. Open `05_RPT_Retail_ECommerce_Sales_Analysis`

---

## Summary

This Fabric workflow covers the full backend-to-report path for the Retail & E-Commerce Sales Analysis solution:

- source ingestion
- landing into dbo
- Silver standardization
- Gold dimensional modeling
- Lakehouse-backed storage
- semantic model creation
- Power BI report connection
- pipeline-based orchestration

It provides a complete view of how data moves from raw source input to a final analytical reporting experience in Microsoft Fabric and Power BI.
