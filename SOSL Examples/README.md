# SOSL (Salesforce Object Search Language) Examples

## Overview
This folder contains comprehensive examples demonstrating SOSL (Salesforce Object Search Language) functionality in Salesforce Apex. SOSL is used for text-based searches across multiple objects and fields.

## Environment
- **Salesforce API Version**: Winter '26 (v65.0)
- **Language**: Apex
- **Last Updated**: November 30, 2025

## What is SOSL?
SOSL (Salesforce Object Search Language) is a search language that allows you to perform text-based searches across multiple objects and their fields simultaneously. Unlike SOQL which queries specific objects, SOSL searches for text strings across various object types.

## Key Differences: SOSL vs SOQL
- **SOSL**: Text-based search across multiple objects (FIND 'search term')
- **SOQL**: Query specific records from one object (SELECT fields FROM object)
- **SOSL**: Returns List of List of sObjects
- **SOQL**: Returns List of sObjects
- **SOSL**: More efficient for text searches
- **SOQL**: More efficient for specific field queries

## File Structure

### Basic SOSL Operations
- `01-basic-sosl-syntax.apex` - Fundamental SOSL query structure and syntax
- `02-find-clause.apex` - Using FIND clause for text searches
- `03-in-clause.apex` - Searching in specific field groups (ALL FIELDS, NAME FIELDS, etc.)
- `04-returning-clause.apex` - Specifying which objects to return

### Advanced SOSL Queries
- `05-field-filtering.apex` - Filtering results with WHERE clauses
- `06-ordering-results.apex` - Sorting search results with ORDER BY
- `07-limiting-results.apex` - Using LIMIT to control result count
- `08-multiple-objects.apex` - Searching across multiple objects simultaneously
- `09-field-selection.apex` - Selecting specific fields in results

### Search Options
- `10-wildcards-operators.apex` - Using wildcards (*, ?) and logical operators
- `11-phrase-search.apex` - Searching for exact phrases
- `12-fuzzy-search.apex` - Finding similar matches with fuzzy logic
- `13-name-fields-search.apex` - Searching only in name fields
- `14-email-fields-search.apex` - Searching only in email fields
- `15-phone-fields-search.apex` - Searching only in phone fields

### Advanced Features
- `16-with-snippet.apex` - Highlighting search terms in results
- `17-with-spell-correction.apex` - Automatic spelling correction
- `18-with-network.apex` - Searching in Salesforce Communities
- `19-with-pricebook.apex` - Filtering by price book
- `20-with-division.apex` - Filtering by division

### Data Categories & Metadata
- `21-with-data-category.apex` - Searching within data categories
- `22-article-searches.apex` - Knowledge article-specific searches
- `23-metadata-search.apex` - Searching custom metadata

### Performance & Best Practices
- `24-sosl-limits.apex` - Understanding SOSL governor limits
- `25-dynamic-sosl.apex` - Building SOSL queries dynamically
- `26-search-optimization.apex` - Performance optimization techniques
- `27-error-handling.apex` - Proper exception handling

### Real-World Use Cases
- `28-global-search.apex` - Implementing global search functionality
- `29-autocomplete-search.apex` - Building autocomplete features
- `30-contact-account-search.apex` - Related object searches
- `31-product-search.apex` - Product catalog search implementation
- `32-case-search.apex` - Service case search functionality
- `33-knowledge-search.apex` - Knowledge base search

### Testing
- `34-sosl-test-methods.apex` - Testing SOSL queries with Test.setFixedSearchResults()
- `35-search-result-validation.apex` - Validating search results in tests

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
- SOSL queries return `List<List<sObject>>` not `List<sObject>`
- Use `Search.query()` for dynamic SOSL queries
- SOSL is case-insensitive by default
- Minimum search term length is 2 characters (1 for CJK languages)
- Maximum 2,000 records returned per SOSL query
- SOSL uses search indexes which update asynchronously

## Governor Limits
- **SOSL Queries per Transaction**: 20 (Synchronous), 20 (Asynchronous)
- **Records Retrieved**: Maximum 2,000 records
- **Search Term Length**: Minimum 2 characters (1 for CJK)
- **Objects Searched**: Maximum 200 objects per query

## Best Practices
1. Use SOSL for text-based searches across multiple objects
2. Use specific IN clauses (NAME FIELDS, EMAIL FIELDS) for better performance
3. Apply WHERE clauses to filter results further
4. Use LIMIT to control the number of results
5. Implement proper null checks for search results
6. Use Test.setFixedSearchResults() in test classes
7. Consider search index delays in production
8. Use dynamic SOSL for user-input searches (prevent SOSL injection)

## Resources
- [Salesforce SOSL Documentation](https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_sosl.htm)
- [SOSL vs SOQL](https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_sosl_soql_comparison.htm)
- [Search Class Methods](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_search.htm)
- [Testing SOSL Queries](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_SOSL.htm)

## Contributing
These examples are for educational purposes. Feel free to modify and expand them based on your learning needs.

## Version
**v1.0** - Initial comprehensive SOSL examples collection

---
*Last updated: November 30, 2025*
