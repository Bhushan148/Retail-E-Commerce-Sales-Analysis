# Retail & E-Commerce Sales Analysis

## Live Report

[View Power BI Report](Add your Power BI report link here)

---

## Overview

This project is an end-to-end Power BI solution developed to analyze retail and e-commerce performance across revenue, orders, customers, products, and profitability.

The objective was to design a business-focused reporting layer that consolidates transactional data into a structured analytical model, enabling both executive-level monitoring and detailed operational analysis.

The solution combines data modeling, transformation, DAX-based calculations, and report design to deliver a complete analytical workflow aligned with real-world BI practices.

---

## Objective

To build a scalable and reusable analytical model that supports key business decisions by providing visibility into:

- Revenue trends and performance drivers  
- Customer acquisition, retention, and lifetime value  
- Product and category contribution  
- Profitability and cost structure  
- Channel and regional distribution  

---

## Architecture

The project follows a structured BI lifecycle:

Data → Transform → Model → DAX → Optimize → Secure → Report → Validate

Each layer is designed to ensure separation of concerns between data preparation, business logic, and visualization.

---

## Data Sources and Transformation

### Local Excel
Used during the initial phase for:
- data exploration  
- schema design  
- DAX development  
- report prototyping  

### Microsoft Fabric
- Data ingested into Fabric environment  
- ETL transformations applied to clean and structure data  
- Dataset prepared for analytical consumption  
- Power BI connected to transformed Fabric model  

This demonstrates the ability to move from a file-based setup to a structured data platform with proper transformation logic.

---

## Data Model

A star schema design was implemented to ensure performance and scalability.

### Fact Table
- fact_sales_order_item (transaction-level sales data)

### Dimension Tables
- dim_date  
- dim_customer  
- dim_product  
- dim_region  
- dim_SalesChannel  

### Design Considerations
- Single-direction relationships for controlled filter flow  
- Avoidance of many-to-many relationships  
- Optimized column selection to reduce model size  
- Proper granularity at order item level  

---

## DAX Implementation

Business logic is centralized in a dedicated measures table, ensuring consistency across the report.

Key implementations include:

- Core KPIs: Revenue, Orders, Customers, AOV, Gross Profit  
- Profitability metrics: Margin, discount impact, return impact  
- Customer metrics: New, returning, repeat rate, lifetime value  
- Order quality metrics: delivery, cancellation, return rates  
- Time intelligence: MoM, YoY, YTD, rolling periods  
- Product analytics: contribution %, ranking, Pareto analysis  
- Channel and region share calculations  
- Dynamic KPI selection using parameter-driven logic  

The model is fully measure-driven, minimizing dependency on calculated columns and improving flexibility.

---

## Report Structure

The report is designed to support both high-level monitoring and detailed analysis.

### Home
Provides navigation and context for the report.

### Overview
- Executive KPIs  
- Monthly revenue trend  
- Regional contribution  
- Revenue to profit bridge  

### Sales
- Net revenue trend with MoM analysis  
- Order lifecycle breakdown  
- Channel performance  

### Products
- Category contribution  
- Price band analysis  
- Product-level performance  

### Customers
- Loyalty segmentation  
- Customer growth and retention trends  
- Demographic distribution  

### Details
- Financial breakdown with current vs prior year comparison  
- Variance and YoY analysis  
- Order and efficiency metrics  

---

## Design and User Experience

The report is built with a focus on clarity and usability.

- KPI-first layout for immediate visibility  
- Consistent visual hierarchy across pages  
- Controlled use of colors and formatting  
- Clear navigation between business areas  

Interactive features include:
- KPI selector to dynamically change analysis  
- Reset filters functionality  
- Slicer-driven analysis  
- Context-aware visuals  

---

## Performance Optimization

Several techniques were applied to ensure efficient performance:

- Removal of unnecessary columns and fields  
- Reduction of model cardinality  
- Use of variables in DAX for optimized calculations  
- Limiting high-density visuals per page  
- Efficient filter context handling  

---

## Security

The model supports dynamic row-level security (RLS), enabling user-specific data access based on role or region.

---

## Validation and Testing

The report was validated through:

- Cross-checking KPI outputs against source data  
- Comparing results between Excel and Fabric datasets  
- Testing filter interactions and visual consistency  
- Ensuring stability of calculations across different contexts  

---

## Repository Contents

This repository includes all components required to understand and reproduce the solution.

### Report Assets
- `/pbix` — Power BI report files  
- `/dax` — DAX measure definitions  
- `/reports` — report screenshots  

## Documentation

The `docs/` folder contains detailed documentation covering the full lifecycle of the project, from business understanding to deployment and validation.

- `01-project-overview.md`  
  Provides a high-level summary of the project, scope, objectives, and overall solution approach.

- `02-business-problem.md`  
  Defines the business context, reporting challenges, and key analytical requirements addressed by the solution.

- `03-data-model.md`  
  Explains the star schema design, table relationships, grain definition, and modeling decisions.

- `04-dax-measures.md`  
  Documents the DAX layer, including KPI definitions, calculation logic, and measure organization.

- `05-report-pages.md`  
  Walks through each report page, explaining visuals, purpose, and how users interact with the analysis.

- `06-design-and-ux.md`  
  Covers report layout, visual hierarchy, user experience considerations, and navigation design.

- `07-performance-optimization.md`  
  Details optimization techniques applied at model, DAX, and report levels to ensure efficient performance.

- `08-security-and-rls.md`  
  Describes the row-level security (RLS) approach and how user-based data access is handled.

- `09-data-sources.md`  
  Explains the use of local Excel and Microsoft Fabric as data sources, including setup and transition.

- `10-fabric-etl-transformation.md`  
  Documents the ETL process performed in Fabric, including data ingestion, transformation, and preparation for reporting.

- `11-deployment-and-refresh.md`  
  Covers publishing to Power BI Service, dataset configuration, and refresh setup.

- `12-validation-and-testing.md`  
  Outlines the validation process, including KPI verification, cross-source comparison, and report testing.

- `13-learnings-and-future-enhancements.md`  
  Summarizes key learnings and identifies potential improvements and extensions to the solution.

- `14-competition-submission.md`  
  Provides details about the dashboard challenge submission, including approach and positioning.

---

## Challenge Context

This project is submitted as part of the Power BI School dashboard challenge.

Challenge link:  
https://www.skool.com/powerbi-school-6896/can-your-dashboard-win-50

The focus of the submission is on:
- business storytelling  
- structured analysis  
- report usability and clarity  

---

## Conclusion

This project demonstrates the ability to design and implement a complete Power BI solution, covering data transformation, modeling, DAX engineering, and business-oriented reporting.

It reflects a practical approach to building scalable and maintainable analytics solutions that can transition from local development to a structured data platform.
