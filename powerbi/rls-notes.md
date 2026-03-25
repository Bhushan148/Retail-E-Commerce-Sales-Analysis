# Row-Level Security (RLS) Notes

## Overview
The solution includes **Row-Level Security (RLS)** considerations to support controlled report access based on user context.

## Purpose
RLS is used to restrict data visibility so that users only see the subset of data relevant to their assigned business scope.

## Example Security Use Cases
Typical RLS implementation in this solution can be applied by:

- region
- business unit
- sales channel
- user-to-region mapping
- user-to-segment access rules

## RLS Design Considerations
The security design follows these principles:

- security logic should be simple and maintainable
- the model should support controlled data visibility without duplicating reports
- relationships should support predictable filter propagation
- role definitions should align with actual business access needs

## Dynamic RLS
Dynamic RLS can be designed using user identity mapping and filters such as:

- `USERPRINCIPALNAME()`
- access mapping tables
- region- or role-based filter conditions

## Testing
RLS should be validated by:

- testing each role in Power BI Desktop
- validating user-specific outputs in the Power BI Service
- confirming that totals, filters, and drill behavior remain correct under restricted access

## Notes
The project includes RLS design considerations as part of the overall semantic model and enterprise-oriented reporting approach.
