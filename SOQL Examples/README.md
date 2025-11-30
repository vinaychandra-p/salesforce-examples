# SOQL (Salesforce Object Query Language) Examples

## Overview
This folder contains comprehensive examples demonstrating SOQL (Salesforce Object Query Language) functionality in Salesforce Apex. SOQL is used for querying specific records from Salesforce objects, similar to SQL but designed for the Salesforce platform.

## Environment
- **Salesforce API Version**: Winter '26 (v65.0)
- **Language**: Apex
- **Last Updated**: November 30, 2025

## What is SOQL?
SOQL (Salesforce Object Query Language) is a query language that allows you to retrieve specific records from a single Salesforce object and its related objects. Unlike SOSL which performs text searches across multiple objects, SOQL is designed for precise data retrieval based on field values.

## Key Differences: SOQL vs SOSL
- **SOQL**: Query specific records from one object (SELECT fields FROM object)
- **SOSL**: Text-based search across multiple objects (FIND 'search term')
- **SOQL**: Returns List of sObjects
- **SOSL**: Returns List of List of sObjects
- **SOQL**: More efficient for field-based queries
- **SOSL**: More efficient for text searches

## File Structure

### Basic SOQL Operations
- `01-basic-select-statements.apex` - Fundamental SELECT FROM WHERE syntax
- `02-selecting-fields.apex` - Field selection, wildcards, and best practices
- `03-where-clause.apex` - Filtering records with various conditions
- `04-comparison-operators.apex` - =, !=, <, >, <=, >=, LIKE, IN, NOT IN
- `05-logical-operators.apex` - AND, OR, NOT combinations

### Working with Data
- `06-null-values.apex` - Handling null with = null and != null
- `07-date-literals.apex` - TODAY, YESTERDAY, THIS_WEEK, LAST_MONTH, etc.
- `08-date-functions.apex` - CALENDAR_YEAR(), DAY_ONLY(), HOUR_IN_DAY()
- `09-string-functions.apex` - toLabel(), convertCurrency(), format()
- `10-type-conversion.apex` - Converting between data types in queries

### Relationships
- `11-parent-to-child.apex` - Querying child records (subqueries)
- `12-child-to-parent.apex` - Accessing parent fields via relationships
- `13-multi-level-relationships.apex` - Traversing multiple relationship levels
- `14-polymorphic-relationships.apex` - Querying Owner, What, Who fields
- `15-self-relationships.apex` - Querying hierarchical data (Parent Account)

### Aggregation
- `16-aggregate-functions.apex` - COUNT(), SUM(), AVG(), MIN(), MAX()
- `17-group-by.apex` - Grouping results by fields
- `18-having-clause.apex` - Filtering grouped results
- `19-count-queries.apex` - Counting records efficiently
- `20-rollup-summary.apex` - Understanding rollup summary behavior

### Sorting and Limiting
- `21-order-by.apex` - Sorting results ASC/DESC, NULLS FIRST/LAST
- `22-limit-offset.apex` - Pagination with LIMIT and OFFSET
- `23-for-update.apex` - Locking records for updates
- `24-for-reference.apex` - FOR REFERENCE (read-only)
- `25-for-view.apex` - FOR VIEW and UserId filtering

### Advanced SOQL
- `26-subqueries.apex` - Nested queries in SELECT and WHERE
- `27-semi-joins.apex` - Using subqueries with IN
- `28-anti-joins.apex` - Using subqueries with NOT IN
- `29-scope-filtering.apex` - USING SCOPE (Mine, Team, Queue, etc.)
- `30-record-type-queries.apex` - Querying by RecordType

### Dynamic SOQL
- `31-dynamic-soql.apex` - Building queries with Database.query()
- `32-bind-variables.apex` - Using variables in queries
- `33-soql-injection-prevention.apex` - Security best practices
- `34-dynamic-field-selection.apex` - Building field lists dynamically
- `35-query-builder-pattern.apex` - Reusable query builder class

### Performance & Optimization
- `36-selective-queries.apex` - Writing efficient queries
- `37-query-optimization.apex` - Indexing and performance tips
- `38-bulk-queries.apex` - Querying large data sets
- `39-soql-limits.apex` - Governor limits and best practices
- `40-query-plan.apex` - Understanding query execution plans

### Special Features
- `41-currency-fields.apex` - Multi-currency queries with convertCurrency()
- `42-geolocation-queries.apex` - DISTANCE() function for location-based queries
- `43-picklist-queries.apex` - Querying picklist and multi-select picklist fields
- `44-formula-field-queries.apex` - Understanding formula field limitations
- `45-encrypted-fields.apex` - Working with encrypted fields

### Testing
- `46-soql-test-methods.apex` - Unit testing SOQL queries
- `47-test-data-factory.apex` - Creating test data for queries
- `48-query-result-validation.apex` - Asserting query results

### Real-World Use Cases
- `49-search-functionality.apex` - Implementing search features
- `50-report-queries.apex` - Building report-style queries
- `51-dashboard-data.apex` - Querying data for dashboards
- `52-data-export.apex` - Batch queries for data export
- `53-lookup-queries.apex` - Efficient lookup implementations
- `54-related-list-queries.apex` - Querying related lists
- `55-complex-business-logic.apex` - Multi-object query patterns

## How to Use These Examples

### In Developer Console
1. Open Developer Console (Setup → Developer Console)
2. File → New → Apex Class
3. Copy the example code
4. Execute Anonymous Window (Debug → Open Execute Anonymous Window)
5. Paste and execute the code

### In VS Code with Salesforce Extensions
1. Install Salesforce Extension Pack
2. Authorize your org (Cmd/Ctrl + Shift + P → SFDX: Authorize an Org)
3. Create a new Apex class
4. Copy the example code
5. Right-click → SFDX: Execute Anonymous Apex with Currently Selected Text

### Important Notes
- SOQL queries return `List<sObject>` not `List<List<sObject>>`
- Always use selective queries (indexed fields in WHERE clause)
- Maximum 100 SOQL queries per transaction (sync), 200 (async)
- Maximum 50,000 records retrieved per transaction
- Use LIMIT to control result size
- Always handle null values and empty lists

## Governor Limits
- **SOQL Queries per Transaction**: 100 (Synchronous), 200 (Asynchronous)
- **Records Retrieved**: Maximum 50,000 records per transaction
- **Query Rows**: Maximum 50,000 rows
- **SOQL Query Rows (Aggregate)**: 50,000
- **Query Locator Rows**: 10,000 per batch in Batch Apex

## Best Practices
1. **Bulkify**: Write queries outside of loops
2. **Selective Queries**: Use indexed fields (Id, Name, Email, External IDs)
3. **Limit Results**: Always use WHERE clause or LIMIT
4. **Field Selection**: Only query fields you need
5. **Relationship Queries**: Use subqueries instead of multiple queries
6. **Security**: Use WITH SECURITY_ENFORCED or stripInaccessible()
7. **Dynamic SOQL**: Use bind variables, not string concatenation
8. **Testing**: Use @testSetup and query test data
9. **Performance**: Understand query selectivity and indexing
10. **Avoid**: Querying inside loops, using non-selective queries

## SOQL Security
- **WITH SECURITY_ENFORCED**: Enforces field and object-level security
- **WITH USER_MODE**: Enforces user permissions (API v58.0+)
- **stripInaccessible()**: Removes inaccessible fields from results
- **Sharing Rules**: Use WITH SHARING in class declarations

## Resources
- [Salesforce SOQL Documentation](https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/)
- [SOQL Best Practices](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_SOQL_VLSQ.htm)
- [Query Plan Tool](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_query_plan.htm)
- [Governor Limits](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm)

## Contributing
These examples are for educational purposes. Feel free to modify and expand them based on your learning needs.

## Version
**v1.0** - Initial comprehensive SOQL examples collection

---
*Last updated: November 30, 2025*
