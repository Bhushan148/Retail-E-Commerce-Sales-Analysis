# Incremental Refresh

## Overview
The semantic model is designed with **incremental refresh** considerations to improve scalability and refresh efficiency for fact-level transactional data.

## Purpose
Incremental refresh reduces the need to fully reload historical data during each refresh cycle. Instead, only recent or changing partitions are refreshed.

## Relevance in This Solution
The **fact_sales_order_item** table is date-driven and is structured to support refresh logic based on order date.

## Benefits
Incremental refresh helps:

- reduce refresh duration
- improve scalability for growing fact data
- reduce resource usage
- make the model more production-oriented

## Implementation Considerations
Typical implementation includes:

- identifying the correct date column for partitioning
- defining historical vs refresh ranges
- ensuring the date logic is consistent across the fact table
- validating that the model behaves correctly after incremental setup

## Example Refresh Pattern
A common setup may include:

- storing multiple years of historical data
- refreshing only the most recent days or months
- partitioning fact data by date

## Validation
Incremental refresh should be validated by checking:

- row continuity across historical and refreshed ranges
- correctness of new data loads
- consistency between source data and semantic model outputs

## Notes
This project includes incremental refresh as part of the semantic model design and refresh strategy for the Power BI layer.
