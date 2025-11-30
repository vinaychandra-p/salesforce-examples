/**
 * Limiting Results Examples
 * Demonstrates using LIMIT to control result count
 * 
 * LIMIT restricts the number of records returned per object
 * Maximum: 2000 total records across all objects
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class LimitingResultsExamples {
    
    /**
     * Example 1: Basic LIMIT
     */
    public static void basicLimit() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Name LIMIT 5)
        ];
        
        System.debug('Limited to 5 accounts:');
        Account[] accounts = (Account[])results[0];
        System.debug('Results: ' + accounts.size() + ' accounts');
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    /**
     * Example 2: Different Limits per Object
     */
    public static void differentLimitsPerObject() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING 
                Account(Name LIMIT 10),
                Contact(FirstName, LastName LIMIT 20),
                Lead(FirstName, LastName LIMIT 15)
        ];
        
        System.debug('Accounts: ' + results[0].size() + ' (max 10)');
        System.debug('Contacts: ' + results[1].size() + ' (max 20)');
        System.debug('Leads: ' + results[2].size() + ' (max 15)');
    }
    
    /**
     * Example 3: LIMIT with ORDER BY
     */
    public static void limitWithOrderBy() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(
                Name, AnnualRevenue
                ORDER BY AnnualRevenue DESC
                LIMIT 5
            )
        ];
        
        System.debug('Top 5 accounts by revenue:');
        Account[] accounts = (Account[])results[0];
        for (Integer i = 0; i < accounts.size(); i++) {
            System.debug((i+1) + '. ' + accounts[i].Name + ' - $' + accounts[i].AnnualRevenue);
        }
    }
    
    /**
     * Example 4: LIMIT with WHERE
     */
    public static void limitWithWhere() {
        List<List<sObject>> results = [
            FIND 'Technology'
            RETURNING Account(
                Name, Industry, AnnualRevenue
                WHERE Industry = 'Technology'
                ORDER BY AnnualRevenue DESC
                LIMIT 10
            )
        ];
        
        System.debug('Top 10 technology accounts:');
        Account[] accounts = (Account[])results[0];
        System.debug('Found: ' + accounts.size());
    }
    
    /**
     * Example 5: Pagination Pattern (First Page)
     */
    public static void paginationFirstPage() {
        Integer pageSize = 10;
        
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Id, Name, CreatedDate
                ORDER BY CreatedDate DESC
                LIMIT :pageSize
            )
        ];
        
        System.debug('Page 1 (First ' + pageSize + ' results):');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    /**
     * Example 6: Total Results Understanding
     */
    public static void totalResultsUnderstanding() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Contact(FirstName, LastName LIMIT 5)
        ];
        
        System.debug('Requested LIMIT: 5');
        System.debug('Actual results: ' + results[0].size());
        System.debug('(May be less if fewer records match)');
    }
    
    /**
     * Example 7: Maximum Limit (2000)
     */
    public static void maximumLimit() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(Name LIMIT 2000)
        ];
        
        System.debug('Maximum LIMIT is 2000 records');
        System.debug('Returned: ' + results[0].size());
    }
    
    /**
     * Example 8: Search Result Truncation
     */
    public static void searchResultTruncation() {
        List<List<sObject>> results = [
            FIND 'a*'  // Very broad search
            RETURNING 
                Account(Name LIMIT 100),
                Contact(Name LIMIT 100),
                Lead(Name LIMIT 100)
        ];
        
        Integer total = results[0].size() + results[1].size() + results[2].size();
        System.debug('Total results: ' + total + ' (max 300 requested)');
        System.debug('SOSL can return max 2000 total across all objects');
    }
    
    /**
     * Example 9: Real-World Search with Limits
     */
    public static List<sObject> searchWithLimit(String searchTerm, Integer maxResults) {
        if (String.isBlank(searchTerm) || maxResults <= 0) {
            return new List<sObject>();
        }
        
        List<List<sObject>> results = [
            FIND :searchTerm
            IN NAME FIELDS
            RETURNING Account(
                Id, Name, Phone, Industry
                ORDER BY Name
                LIMIT :maxResults
            )
        ];
        
        System.debug('Search "' + searchTerm + '" - Limit: ' + maxResults);
        System.debug('Results: ' + results[0].size());
        
        return results[0];
    }
    
    /**
     * Example 10: Autocomplete Pattern
     */
    public static List<Map<String, String>> autocompleteSearch(String input) {
        List<Map<String, String>> suggestions = new List<Map<String, String>>();
        
        if (String.isBlank(input) || input.length() < 2) {
            return suggestions;
        }
        
        List<List<sObject>> results = [
            FIND :input + '*'
            IN NAME FIELDS
            RETURNING Account(Id, Name LIMIT 10)
        ];
        
        for (Account acc : (Account[])results[0]) {
            suggestions.add(new Map<String, String>{
                'id' => acc.Id,
                'name' => acc.Name
            });
        }
        
        return suggestions;
    }
}

/**
 * USAGE:
 * LimitingResultsExamples.basicLimit();
 * LimitingResultsExamples.limitWithOrderBy();
 * List<sObject> results = LimitingResultsExamples.searchWithLimit('Acme', 10);
 * List<Map<String, String>> suggestions = LimitingResultsExamples.autocompleteSearch('Ac');
 */
