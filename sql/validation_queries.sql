/*==============================================================================
  PROJECT: Retail Sales Analytics
  SCRIPT : Gold Layer SQL Validation & Power BI Reconciliation
  PURPOSE:
      Independently validate the curated Gold-layer data and reconcile the
      business logic used by the Power BI semantic model.

  PLATFORM:
      Microsoft Fabric Lakehouse SQL Analytics Endpoint
      Client tool: SQL Server Management Studio (SSMS)

  CONNECTION:
      Connect SSMS directly to the SQL Analytics Endpoint for LH_Ecommerce
      using Microsoft Entra authentication.

  IMPORTANT:
      The Lakehouse SQL Analytics Endpoint is used here as a READ-ONLY
      validation/query layer. This script intentionally contains SELECT-only
      validation queries and does not modify Lakehouse data.

  DATA MODEL:
      Fact:
          gold.fact_sales_order_item
          Grain = one row per order item

      Dimensions:
          gold.dim_product
          gold.dim_customer
          gold.dim_geography
          gold.dim_region

  VALIDATION AREAS:
      1. Source inspection and table volume
      2. Fact-table grain and key integrity
      3. KPI reconciliation
      4. Revenue bridge validation
      5. Order-status logic
      6. Time-series reconciliation
      7. Region and channel analysis
      8. Product and customer analysis
      9. Referential-integrity and data-quality checks

  INTERVIEW SUMMARY:
      "I used SSMS against the Fabric SQL Analytics Endpoint to independently
       validate the Gold-layer data behind the Power BI report. I checked the
       fact-table grain, KPI formulas, dimensional joins, trend calculations,
       and key data-quality rules before reconciling the results with the
       semantic model."
==============================================================================*/
/*==============================================================================
  SECTION 1 — SOURCE INSPECTION
  Purpose:
      Confirm that the expected Gold-layer tables are available and understand
      the shape of the curated data before validating business metrics.
==============================================================================*/
SELECT TOP (10) *
FROM   gold.fact_sales_order_item;

SELECT TOP (10) *
FROM   gold.dim_product;

SELECT TOP (10) *
FROM   gold.dim_customer;

/*==============================================================================
  SECTION 2 — TABLE VOLUME CHECK
  Purpose:
      Validate expected table population and confirm that the fact/dimension
      layers contain data before deeper reconciliation.

  Why it matters:
      Unexpected row-count changes can indicate incomplete loads, duplicate
      ingestion, filtering problems, or upstream pipeline issues.
==============================================================================*/
SELECT 'fact_sales_order_item' AS table_name,
       COUNT(*) AS row_count
FROM   gold.fact_sales_order_item
UNION ALL
SELECT 'dim_customer',
       COUNT(*)
FROM   gold.dim_customer
UNION ALL
SELECT 'dim_product',
       COUNT(*)
FROM   gold.dim_product
UNION ALL
SELECT 'dim_geography',
       COUNT(*)
FROM   gold.dim_geography
UNION ALL
SELECT 'dim_region',
       COUNT(*)
FROM   gold.dim_region;

/*==============================================================================
  SECTION 3 — FACT GRAIN & ORDER-LEVEL VALIDATION
  Purpose:
      Confirm the analytical grain of the fact table.

  Business rule:
      One row represents one ORDER ITEM, therefore order-level metrics must use
      COUNT(DISTINCT OrderID) rather than COUNT(*).

  Why it matters:
      Using COUNT(*) for orders would overstate order volume whenever an order
      contains multiple products.
==============================================================================*/
SELECT COUNT(*) AS fact_rows,
       COUNT(DISTINCT OrderItemID) AS distinct_order_items,
       COUNT(DISTINCT OrderID) AS distinct_orders,
       COUNT(DISTINCT CustomerKey) AS purchasing_customers
FROM   gold.fact_sales_order_item;

/*==============================================================================
  SECTION 4 — CORE KPI RECONCILIATION
  Purpose:
      Independently reproduce the primary business KPIs from the Gold fact table.

  These results can be reconciled with the Power BI semantic model under the
  same report-filter context.
==============================================================================*/
SELECT SUM(GrossSalesUSD) AS total_revenue,
       SUM(NetRevenueUSD) AS net_revenue,
       SUM(GrossProfitUSD) AS gross_profit,
       COUNT(DISTINCT OrderID) AS total_orders,
       COUNT(DISTINCT CustomerKey) AS total_customers,
       SUM(Quantity) AS units_sold
FROM   gold.fact_sales_order_item;

/*------------------------------------------------------------------------------
  Derived KPIs
  - Average Order Value = Net Revenue / Distinct Orders
  - Gross Profit Margin = Gross Profit / Net Revenue
------------------------------------------------------------------------------*/
SELECT SUM(NetRevenueUSD) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS average_order_value,
       SUM(GrossProfitUSD) * 1.0 / NULLIF (SUM(NetRevenueUSD), 0) AS gross_profit_margin
FROM   gold.fact_sales_order_item;

/*==============================================================================
  SECTION 5 — REVENUE BRIDGE VALIDATION
  Purpose:
      Validate the financial relationship used in the reporting model.

  Business rule:
      Net Revenue = Gross Sales - Discount - Returns

  Why it matters:
      This check verifies that the stored NetRevenueUSD measure is consistent
      with its component fields rather than relying only on the final value.
==============================================================================*/
SELECT SUM(GrossSalesUSD) AS gross_sales,
       SUM(DiscountUSD) AS total_discount,
       SUM(ReturnAmountUSD) AS total_returns,
       SUM(GrossSalesUSD) - SUM(DiscountUSD) - SUM(ReturnAmountUSD) AS calculated_net_revenue,
       SUM(NetRevenueUSD) AS stored_net_revenue,
       SUM(NetRevenueUSD) - (SUM(GrossSalesUSD) - SUM(DiscountUSD) - SUM(ReturnAmountUSD)) AS reconciliation_difference
FROM   gold.fact_sales_order_item;

/*==============================================================================
  SECTION 6 — ORDER STATUS VALIDATION
  Purpose:
      Validate operational KPIs for delivered, returned, and cancelled orders.

  Important:
      Flags and final OrderStatus answer different business questions.
      An order may have been delivered and subsequently returned, while the final
      status records only its latest state.
==============================================================================*/
SELECT COUNT(DISTINCT CASE WHEN IsDelivered = 1 THEN OrderID END) AS delivered_orders,
       COUNT(DISTINCT CASE WHEN IsReturned = 1 THEN OrderID END) AS returned_orders,
       COUNT(DISTINCT CASE WHEN IsCancelled = 1 THEN OrderID END) AS cancelled_orders,
       COUNT(DISTINCT OrderID) AS total_orders
FROM   gold.fact_sales_order_item;

/*------------------------------------------------------------------------------
  Order rates
------------------------------------------------------------------------------*/
SELECT COUNT(DISTINCT CASE WHEN IsDelivered = 1 THEN OrderID END) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS delivery_rate,
       COUNT(DISTINCT CASE WHEN IsReturned = 1 THEN OrderID END) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS return_rate,
       COUNT(DISTINCT CASE WHEN IsCancelled = 1 THEN OrderID END) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS cancellation_rate
FROM   gold.fact_sales_order_item;

/*------------------------------------------------------------------------------
  Final order-status distribution
------------------------------------------------------------------------------*/
SELECT   OrderStatus,
         COUNT(DISTINCT OrderID) AS orders
FROM     gold.fact_sales_order_item
GROUP BY OrderStatus
ORDER BY orders DESC;

/*==============================================================================
  SECTION 7 — YEARLY SALES TREND
  Purpose:
      Reconcile annual revenue, order volume, profit, and average order value.

  Note:
      Partial years should be interpreted separately from completed years.
==============================================================================*/
SELECT   YEAR(OrderDate) AS order_year,
         SUM(NetRevenueUSD) AS net_revenue,
         COUNT(DISTINCT OrderID) AS orders,
         SUM(GrossProfitUSD) AS gross_profit
FROM     gold.fact_sales_order_item
WHERE    OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate)
ORDER BY order_year;

/*------------------------------------------------------------------------------
  Average Order Value by year
------------------------------------------------------------------------------*/
SELECT   YEAR(OrderDate) AS order_year,
         SUM(NetRevenueUSD) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS average_order_value
FROM     gold.fact_sales_order_item
WHERE    OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate)
ORDER BY order_year;

/*==============================================================================
  SECTION 8 — MONTHLY TREND & MoM VALIDATION
  Purpose:
      Validate monthly reporting logic and month-over-month revenue movement.

  Design note:
      MoM is calculated across the complete monthly series first, and the target
      year is filtered afterward. This allows January to compare with the prior
      December rather than incorrectly returning NULL.
==============================================================================*/
WITH     monthly_revenue
AS       (SELECT   YEAR(OrderDate) AS order_year,
                   MONTH(OrderDate) AS order_month,
                   SUM(NetRevenueUSD) AS net_revenue
          FROM     gold.fact_sales_order_item
          WHERE    OrderDate IS NOT NULL
          GROUP BY YEAR(OrderDate), MONTH(OrderDate)),
         monthly_with_previous
AS       (SELECT order_year,
                 order_month,
                 net_revenue,
                 LAG(net_revenue) OVER (ORDER BY order_year, order_month) AS previous_month_revenue
          FROM   monthly_revenue)
SELECT   order_year,
         order_month,
         net_revenue,
         previous_month_revenue,
         (net_revenue - previous_month_revenue) * 1.0 / NULLIF (previous_month_revenue, 0) AS mom_change
FROM     monthly_with_previous
WHERE    order_year = 2025
ORDER BY order_month;

/*==============================================================================
  SECTION 9 — REGION RECONCILIATION
  Purpose:
      Validate revenue and order metrics across the geography hierarchy.

  Model path:
      fact_sales_order_item
          -> dim_geography
          -> dim_region

  Data-quality note:
      GeographyKey currently requires an explicit CAST because the fact and
      dimension columns are stored with different data types.

      This works for validation, but the preferred production design is to align
      key data types upstream in the Gold layer so joins do not require runtime
      conversion.
==============================================================================*/
SELECT   r.RegionName,
         SUM(f.NetRevenueUSD) AS net_revenue,
         COUNT(DISTINCT f.OrderID) AS orders
FROM     gold.fact_sales_order_item AS f
         INNER JOIN
         gold.dim_geography AS g
         ON CAST (f.GeographyKey AS VARCHAR (50)) = g.GeographyKey
         INNER JOIN
         gold.dim_region AS r
         ON g.RegionID = r.RegionID
GROUP BY r.RegionName
ORDER BY net_revenue DESC;

/*==============================================================================
  SECTION 10 — CHANNEL PERFORMANCE
  Purpose:
      Validate commercial performance by customer acquisition/order channel.
==============================================================================*/
SELECT   CustomerChannel,
         SUM(NetRevenueUSD) AS net_revenue,
         COUNT(DISTINCT OrderID) AS orders
FROM     gold.fact_sales_order_item
GROUP BY CustomerChannel
ORDER BY net_revenue DESC;

/*==============================================================================
  SECTION 11 — PRODUCT PERFORMANCE
  Purpose:
      Validate category-level and product-level revenue performance using the
      product dimension.
==============================================================================*/
SELECT   p.CategoryName,
         SUM(f.NetRevenueUSD) AS net_revenue,
         SUM(f.GrossProfitUSD) AS gross_profit
FROM     gold.fact_sales_order_item AS f
         INNER JOIN
         gold.dim_product AS p
         ON f.ProductKey = p.ProductKey
GROUP BY p.CategoryName
ORDER BY net_revenue DESC;

/*------------------------------------------------------------------------------
  Top 5 products by Net Revenue
------------------------------------------------------------------------------*/
SELECT   TOP (5) p.ProductName,
                 SUM(f.NetRevenueUSD) AS net_revenue
FROM     gold.fact_sales_order_item AS f
         INNER JOIN
         gold.dim_product AS p
         ON f.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY net_revenue DESC;

/*==============================================================================
  SECTION 12 — CUSTOMER ANALYTICS VALIDATION
  Purpose:
      Reconcile customer counts, repeat-customer logic, customer segments, and
      segment-level revenue.
==============================================================================*/
SELECT COUNT(DISTINCT CustomerKey) AS total_customers,
       COUNT(DISTINCT CASE WHEN IsRepeatCustomer = 1 THEN CustomerKey END) AS returning_customers,
       COUNT(DISTINCT CASE WHEN IsRepeatCustomer = 1 THEN CustomerKey END) * 1.0 / NULLIF (COUNT(DISTINCT CustomerKey), 0) AS repeat_customer_rate
FROM   gold.fact_sales_order_item;

/*------------------------------------------------------------------------------
  Customer segment performance
------------------------------------------------------------------------------*/
SELECT   c.CustomerSegmentName,
         COUNT(DISTINCT f.CustomerKey) AS customers,
         SUM(f.NetRevenueUSD) AS net_revenue
FROM     gold.fact_sales_order_item AS f
         INNER JOIN
         gold.dim_customer AS c
         ON f.CustomerKey = c.CustomerKey
GROUP BY c.CustomerSegmentName
ORDER BY net_revenue DESC;

/*==============================================================================
  SECTION 13 — DATA QUALITY & REFERENTIAL INTEGRITY
  Purpose:
      Identify common analytical-data issues before trusting report results.

  Expected outcome:
      Ideally each check returns zero problem rows.
==============================================================================*/
-- 13.1 Missing order dates
SELECT 'Missing OrderDate' AS check_name,
       COUNT(*) AS problem_rows
FROM   gold.fact_sales_order_item
WHERE  OrderDate IS NULL;

-- 13.2 Missing OrderItemID
SELECT 'Missing OrderItemID' AS check_name,
       COUNT(*) AS problem_rows
FROM   gold.fact_sales_order_item
WHERE  OrderItemID IS NULL;

-- 13.3 Duplicate OrderItemID values
SELECT 'Duplicate OrderItemID' AS check_name,
       COUNT(*) AS problem_rows
FROM   (SELECT   OrderItemID
        FROM     gold.fact_sales_order_item
        WHERE    OrderItemID IS NOT NULL
        GROUP BY OrderItemID
        HAVING   COUNT(*) > 1) AS duplicates;

-- 13.4 Fact customers not found in customer dimension
SELECT 'Fact CustomerKey missing from dim_customer' AS check_name,
       COUNT(*) AS problem_rows
FROM   gold.fact_sales_order_item AS f
WHERE  NOT EXISTS (SELECT 1
                   FROM   gold.dim_customer AS d
                   WHERE  d.CustomerKey = f.CustomerKey);

-- 13.5 Fact products not found in product dimension
SELECT 'Fact ProductKey missing from dim_product' AS check_name,
       COUNT(*) AS problem_rows
FROM   gold.fact_sales_order_item AS f
WHERE  NOT EXISTS (SELECT 1
                   FROM   gold.dim_product AS d
                   WHERE  d.ProductKey = f.ProductKey);

/*==============================================================================
  SECTION 14 — OPTIONAL SINGLE-SCREEN VALIDATION SUMMARY
  Purpose:
      Produce a compact set of high-level metrics useful during project review,
      demonstration, or reconciliation with the Power BI Overview page.
==============================================================================*/
SELECT COUNT(*) AS fact_rows,
       COUNT(DISTINCT OrderID) AS total_orders,
       COUNT(DISTINCT CustomerKey) AS purchasing_customers,
       SUM(Quantity) AS units_sold,
       SUM(GrossSalesUSD) AS gross_sales,
       SUM(DiscountUSD) AS discount_amount,
       SUM(ReturnAmountUSD) AS return_amount,
       SUM(NetRevenueUSD) AS net_revenue,
       SUM(GrossProfitUSD) AS gross_profit,
       SUM(NetRevenueUSD) * 1.0 / NULLIF (COUNT(DISTINCT OrderID), 0) AS average_order_value,
       SUM(GrossProfitUSD) * 1.0 / NULLIF (SUM(NetRevenueUSD), 0) AS gross_profit_margin
FROM   gold.fact_sales_order_item;


/*==============================================================================
  PROJECT TALKING POINTS

  1. Grain
     The Gold fact table is at order-item grain. Therefore order metrics use
     COUNT(DISTINCT OrderID), while units use SUM(Quantity).

  2. KPI reconciliation
     Core Power BI KPIs were reproduced independently in SQL against the Gold
     layer under equivalent filter context.

  3. Financial validation
     Net Revenue was checked both as a stored field and as:
         Gross Sales - Discount - Returns.

  4. Dimensional-model validation
     Product, customer, geography, and region joins were tested to ensure the
     dimensions reconcile correctly with the fact table.

  5. Data-quality validation
     The script checks null business keys, duplicate order-item keys, and missing
     dimension references before report results are trusted.

  6. Time intelligence
     Yearly and monthly trends were validated in SQL. MoM logic intentionally
     preserves the previous December when evaluating January.

  7. Known modeling improvement
     GeographyKey has a data-type mismatch between fact and dimension tables.
     The validation query uses CAST temporarily, while the recommended fix is to
     standardize the key data type upstream in the curated Gold layer.

  8. Fabric usage
     SSMS is used as the local SQL client, while the queries execute against the
     Microsoft Fabric Lakehouse SQL Analytics Endpoint. The validation therefore
     checks the same centralized Gold data consumed by downstream analytics.
==============================================================================*/
