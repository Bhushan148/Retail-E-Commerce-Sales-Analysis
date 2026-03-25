# Scheduled Refresh

## Overview
The solution uses **Import mode**, so scheduled refresh is an important part of the reporting design.

## Purpose
Scheduled refresh keeps the semantic model synchronized with the latest processed data and ensures that report consumers see current information.

## Refresh Flow
The refresh process follows the backend-to-report sequence:

1. Dataflow Gen2 ingestion and initial transformation
2. Silver notebook standardization
3. Gold notebook dimensional modeling
4. Semantic model refresh
5. Updated report consumption

## Backend and Model Refresh
The solution combines:

- backend processing in Microsoft Fabric
- semantic model refresh after Gold layer completion
- report consumption from the refreshed semantic model

## Design Considerations
Scheduled refresh planning includes:

- aligning refresh timing with data availability
- ensuring backend layers complete before semantic model refresh
- keeping Import mode data current
- reducing manual intervention

## Operational Notes
The project workflow is designed so that the orchestration pipeline supports the backend execution flow and the semantic model can then be refreshed in a controlled sequence.

## Validation
Scheduled refresh should be validated by checking:

- semantic model refresh status
- latest data availability in the report
- consistency of Last Refresh status displayed in the report
- monitoring history in Fabric / Power BI Service
