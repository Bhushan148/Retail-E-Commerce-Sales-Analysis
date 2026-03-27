# Retail & E-Commerce Sales Analysis

## Live Report
https://app.powerbi.com/view?r=eyJrIjoiZGNkYzI4NGItY2FiNS00Njg0LTg5NGUtY2UyOTZiNGFkNTNkIiwidCI6IjI1Y2UwMjYxLWJiZDYtNDljZC1hMWUyLTU0MjYwODg2ZDE1OSJ9&pageName=fa9b1cf475e064bbb51d

## Challenge Context

This implementation aligns with the **Power BI School Dashboard Competition (Dashboard Wars: Season 1)**.

Challenge link:  
https://www.skool.com/powerbi-school-6896/can-your-dashboard-win-50

The challenge focused on building a business-oriented dashboard that translates raw data into meaningful and actionable insights through analytical clarity, usability, and storytelling.

---

## Overview

Retail & E-Commerce Sales Analysis is an end-to-end analytics solution built with **Microsoft Fabric** and **Power BI** to analyze revenue, orders, customers, products, profitability, channels, and geography.

The solution covers the full analytical lifecycle, including data ingestion, transformation, dimensional modeling, orchestration, semantic modeling, DAX implementation, refresh strategy, security design, and report development.

---

## Objective

The solution is designed to provide visibility into:

- revenue trends and performance drivers  
- customer acquisition, retention, and repeat behavior  
- product and category contribution  
- profitability and margin performance  
- channel and regional distribution  
- order quality metrics such as delivery, cancellation, and returns  

---

## Architecture

The implementation follows a structured medallion-style architecture inside Microsoft Fabric:

```text
Data Source → Dataflow Gen2 → dbo → Silver → Gold → Semantic Model → Power BI Report
```

### Layers

**Dataflow Gen2 / dbo**  
Source data is ingested and transformed into the `dbo` schema using Fabric Dataflow Gen2.

**Silver layer**  
Silver notebooks standardize and clean the source-aligned tables to ensure schema consistency and trusted downstream inputs.

**Gold layer**  
Gold notebooks build the dimensional model by creating fact and dimension tables for analytical consumption.

**Semantic model**  
A Power BI semantic model is built on top of the Gold layer using **Import mode**.

**Report layer**  
The final Power BI report delivers interactive business analysis through a structured dashboard experience.

---

## Fabric Orchestration

An orchestration pipeline manages the backend workflow end to end.

### Pipeline
`00_ORCH_EndToEnd_Data_Pipeline`

### Execution Flow

```text
→ 01_DFGen2_Ingestion_Transformation_DBO
→ 02_NB_Silver_Layer_Standardization
→ 03_NB_Gold_Layer_Dimensional_Model
→ 04_SM_Retail_ECommerce_Sales_Model
→ 05_RPT_Retail_ECommerce_Sales_Analysis
```

### Orchestration Scope

- dependency-based sequential execution  
- integration of Dataflow Gen2 and notebooks  
- backend automation across ingestion, Silver, and Gold layers  
- semantic model refresh as part of the workflow  
- monitoring through Fabric pipeline run history  

---

## Data Model

A **star schema** is implemented to support performance, scalability, and semantic clarity.

### Fact Table
- `fact_sales_order_item`

### Dimension Tables
- `dim_date`
- `dim_customer`
- `dim_product`
- `dim_geography`
- `dim_region`

### Modeling Principles

- clear separation between fact and dimension tables  
- single-direction relationship flow  
- optimized granularity at order-item level  
- avoidance of many-to-many relationships  
- business-friendly dimensional slicing for analysis  

---

## Data Processing in Fabric

The backend implementation includes the following stages:

- ingestion using **Dataflow Gen2**  
- landing into the `dbo` layer  
- Silver layer standardization  
- Gold layer dimensional modeling  
- schema alignment across business entities  
- key creation for dimensions  
- date key conversion into reporting-ready date fields  
- orchestration of backend execution using Fabric pipeline  

---

## Power BI Implementation

The reporting layer is built to reflect both technical modeling discipline and business usability.

### Semantic Model Design

- **Import mode** semantic model for analytical performance  
- relationship management using a star schema  
- measure-driven business logic  
- controlled filter flow for predictable analysis  

### DAX Implementation

Business logic is centralized in measures to support consistency and reuse across report pages.

#### DAX Areas Included

- KPI measures  
- filter context control using `CALCULATE`  
- conditional logic using `IF` and `SWITCH`  
- time-intelligence calculations  
- contribution and share calculations  
- profitability analysis  
- customer behavior analysis  
- dynamic KPI selection  

#### Core Metrics

- net revenue  
- gross sales  
- discount amount  
- return amount  
- gross profit  
- order count  
- customer count  
- average order value  
- repeat customer rate  
- cancellation rate  
- delivery rate  
- product contribution  
- regional and channel share  

---

## Report Features

The report includes several user-focused features to improve navigation, interpretability, and interaction.

### Info Pages and Guidance

Dedicated information pages are included to guide users on how to navigate the report and use each page effectively. These pages provide contextual help for report navigation, KPI-driven interaction, filter usage, reset behavior, and refresh status visibility.

### Tooltips

Tooltips are implemented wherever relevant to improve understanding without overcrowding the page layout.

#### Tooltip Usage Includes

- KPI tooltips to explain metric meaning and business context  
- contextual tooltips for selected visuals where added value is needed  
- hover-based information to support faster interpretation of the report  

### Filter Pane Interaction

A dedicated filter pane is included using **bookmarks** with show/hide behavior to improve usability while keeping the default page layout clean.

### Reset and Navigation Features

The report includes usability-focused interactions such as:

- reset all slicers action  
- page navigation menu  
- return-to-default-view interaction  
- guided help/information sections  

### Last Refresh Status

A visible **Last Refresh On** section is included in the report layout so users can quickly confirm the latest report data refresh timestamp.

---

## Refresh Strategy

Since the semantic model uses **Import mode**, refresh strategy is an important part of the design.

### Backend Refresh
The Fabric pipeline orchestrates data ingestion, Silver transformation, Gold modeling, and semantic model refresh in sequence.

### Semantic Model Refresh
The semantic model is refreshed after successful Gold layer completion to keep the reporting layer aligned with the latest processed data.

### Scheduled Refresh
Scheduled refresh is part of the operational design to ensure the analytical model remains current for report consumption.

### Incremental Refresh
The fact design is aligned to support **incremental refresh** based on date-driven partitioning for scalable model maintenance.

---

## Security

The solution includes **row-level security (RLS)** considerations for controlled access to report data.

### Security Scope

- role-based data access  
- user-based filtering logic  
- restricted visibility by business scope such as region or segment  

---

## Performance Optimization

Performance considerations are applied across both Fabric and Power BI layers.

### Optimization Areas

- star schema modeling  
- selective column usage  
- measure-first design  
- reduced dependency on calculated columns  
- clean relationship paths  
- appropriate fact granularity  
- efficient DAX design  
- report layouts optimized for usability and rendering efficiency  

---

## Report Structure

The report is organized to support both executive-level monitoring and detailed analysis.

### Pages

**Home**  
Navigation and report introduction

**Overview**  
Executive KPIs and high-level performance summaries

**Sales**  
Revenue trends, order metrics, channel analysis, and order status analysis

**Products**  
Category and product contribution analysis

**Customers**  
Customer growth, segmentation, and repeat behavior

**Details**  
Detailed financial and operational breakdowns

**Info / Guide Pages**  
Dedicated help pages explaining report usage, navigation, filter behavior, KPI interaction, and reset actions

---

## Design and User Experience

The report is built with a focus on clarity, usability, and analytical flow.

### Design Principles

- KPI-first layout  
- clear visual hierarchy  
- business-oriented storytelling  
- interactive slicers and filters  
- structured page-level organization  
- consistent formatting and navigation  
- guided report usage through info pages  
- clean interaction design using bookmarks and tooltips  

---

## Validation

Validation is applied across the backend and reporting layers.

### Validation Activities

- comparing KPI outputs against transformed source data  
- checking consistency across backend layers  
- validating joins and model relationships  
- testing filter interactions  
- verifying DAX outputs across different contexts  
- ensuring visual outputs remain aligned with business logic  

---

## Repository Structure

```text
Retail-ECommerce-Sales-Analysis/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── fabric/
│   ├── 00_ORCH_EndToEnd_Data_Pipeline
│   ├── 01_DFGen2_Ingestion_Transformation_DBO
│   ├── 02_NB_Silver_Layer_Standardization.ipynb
│   ├── 03_NB_Gold_Layer_Dimensional_Model.ipynb
│   ├── 04_SM_Retail_ECommerce_Sales_Model
│   └── LH_Ecommerce
│
├── powerbi/
│   ├── 05_RPT_Retail_ECommerce_Sales_Analysis.pbix
│   ├── dax-measures.md
│   ├── rls-notes.md
│   ├── incremental-refresh.md
│   ├── scheduled-refresh.md
│   ├── report-pages.md
│   └── bookmarks-tooltips-notes.md
│
├── docs/
│   ├── architecture-diagram.png
│   ├── pipeline-screenshot.png
│   ├── data-model-diagram.png
│   ├── report-screenshots/
│   ├── validation-notes.md
│   └── prerequisites.md
│
└── assets/
    ├── dashboard-cover.png
    ├── icons/
    └── theme-colors.md
```

---

## Technology Stack

- Microsoft Fabric  
- Dataflow Gen2  
- Fabric Pipelines  
- Lakehouse  
- Notebook-based transformation  
- Power BI  
- DAX  
- Import Mode Semantic Model  
- Bookmarks  
- Tooltips  
- Row-Level Security (RLS)  
- Incremental Refresh  

---

## Conclusion

This repository presents a complete retail and e-commerce analytics workflow built with Microsoft Fabric and Power BI, covering ingestion, transformation, dimensional modeling, orchestration, semantic modeling, DAX, security, refresh strategy, guided report interaction, and reporting in a single structured solution.

---

## Connect

For questions, feedback, or collaboration, connect on LinkedIn:

[LinkedIn Profile](https://www.linkedin.com/in/bhushangawali148/)
