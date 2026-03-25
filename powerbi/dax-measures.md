# DAX Measures

## Overview
This file documents the main measure categories used in the **Retail & E-Commerce Sales Analysis** semantic model. The model is designed to be measure-driven so that business logic remains centralized, reusable, and easier to maintain.

## Core KPI Measures
Typical KPI measures in the model include:

- **Net Revenue**
- **Gross Sales**
- **Order Count**
- **Customer Count**
- **Average Order Value (AOV)**
- **Gross Profit**
- **Gross Margin %**

## Profitability Measures
These measures support margin and cost analysis:

- Gross Profit
- Gross Margin %
- Discount Amount
- Return Amount
- Product Cost
- Revenue vs Profit comparison

## Customer Measures
Customer analysis is supported through measures such as:

- Total Customers
- New Customers
- Repeat Customers
- Repeat Customer Rate
- Customer Lifetime Value (where applicable)
- Customer contribution to revenue

## Order Quality Measures
Operational performance is analyzed using measures such as:

- Delivery Rate
- Cancellation Rate
- Return Rate
- Order Status breakdown
- Customer Order Sequence logic

## Time Intelligence Measures
The model supports time-based analysis using DAX patterns such as:

- Month-over-Month (MoM)
- Year-over-Year (YoY)
- Year-to-Date (YTD)
- Rolling period comparisons
- Prior period variance

## Product and Contribution Measures
Used for category, product, and share analysis:

- Product Revenue
- Category Revenue
- Product Contribution %
- Category Contribution %
- Regional Share
- Channel Share

## Dynamic Analysis
The report includes measure-driven interaction patterns such as:

- dynamic KPI selector
- context-aware KPI analysis
- reusable measures across multiple pages

## Design Approach
The semantic model avoids unnecessary calculated columns where possible and keeps logic in measures for better flexibility, readability, and performance.
