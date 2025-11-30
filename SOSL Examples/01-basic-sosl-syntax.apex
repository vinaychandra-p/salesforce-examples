/**
 * Basic SOSL Syntax Examples
 * Demonstrates fundamental SOSL query structure and syntax
 * 
 * SOSL Query Structure:
 * FIND 'SearchQuery' [IN SearchGroup] [RETURNING ObjectsAndFields]
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class BasicSOSLSyntax {
    
    /**
     * Example 1: Simplest SOSL Query
     * Searches for text across all searchable fields in all objects
     */
    public static void simpleSearch() {
        // Basic SOSL syntax - searches across all searchable objects
        List<List<sObject>> searchResults = [FIND 'Acme' IN ALL FIELDS RETURNING Account, Contact];
        
        System.debug('Total object types returned: ' + searchResults.size());
        
        // Access Accounts (first list in results)
        Account[] accounts = (Account[])searchResults[0];
        System.debug('Accounts found: ' + accounts.size());
        
        // Access Contacts (second list in results)
        Contact[] contacts = (Contact[])searchResults[1];
        System.debug('Contacts found: ' + contacts.size());
    }
    
    /**
     * Example 2: SOSL Query Structure Breakdown
     * Understanding each component of a SOSL query
     */
    public static void queryStructureExplanation() {
        // FIND: Specifies the search term
        // IN: Specifies which fields to search (optional)
        // RETURNING: Specifies which objects and fields to return
        
        List<List<sObject>> results = [
            FIND 'Smith'                    // Search term
            IN NAME FIELDS                  // Search only in name fields
            RETURNING Account(Name),        // Return Account records with Name field
                     Contact(FirstName, LastName)  // Return Contact records
        ];
        
        System.debug('Query executed successfully');
        System.debug('Results: ' + results);
    }
    
    /**
     * Example 3: Single Object Search
     * Searching in just one object type
     */
    public static void singleObjectSearch() {
        List<List<sObject>> searchResults = [
            FIND 'Test'
            IN ALL FIELDS
            RETURNING Account(Id, Name, Industry)
        ];
        
        // Even though we search one object, results are still List<List<sObject>>
        if (!searchResults.isEmpty() && !searchResults[0].isEmpty()) {
            Account[] accounts = (Account[])searchResults[0];
            for (Account acc : accounts) {
                System.debug('Account: ' + acc.Name + ' - ' + acc.Industry);
            }
        }
    }
    
    /**
     * Example 4: Multiple Object Search
     * Searching across multiple objects simultaneously
     */
    public static void multipleObjectSearch() {
        List<List<sObject>> searchResults = [
            FIND 'Acme'
            IN ALL FIELDS
            RETURNING Account(Name, Phone),
                     Contact(FirstName, LastName, Email),
                     Lead(FirstName, LastName, Company)
        ];
        
        // Process Accounts
        if (searchResults.size() > 0) {
            Account[] accounts = (Account[])searchResults[0];
            System.debug('=== ACCOUNTS ===');
            for (Account acc : accounts) {
                System.debug(acc.Name + ' - ' + acc.Phone);
            }
        }
        
        // Process Contacts
        if (searchResults.size() > 1) {
            Contact[] contacts = (Contact[])searchResults[1];
            System.debug('=== CONTACTS ===');
            for (Contact con : contacts) {
                System.debug(con.FirstName + ' ' + con.LastName);
            }
        }
        
        // Process Leads
        if (searchResults.size() > 2) {
            Lead[] leads = (Lead[])searchResults[2];
            System.debug('=== LEADS ===');
            for (Lead ld : leads) {
                System.debug(ld.FirstName + ' ' + ld.LastName + ' - ' + ld.Company);
            }
        }
    }
    
    /**
     * Example 5: Basic Search with Null Check
     * Always check for null/empty results
     */
    public static void searchWithNullCheck() {
        List<List<sObject>> searchResults = [
            FIND 'NonExistentTerm12345'
            RETURNING Account
        ];
        
        // Check if results exist
        if (searchResults != null && !searchResults.isEmpty()) {
            if (!searchResults[0].isEmpty()) {
                System.debug('Found ' + searchResults[0].size() + ' results');
            } else {
                System.debug('No results found');
            }
        } else {
            System.debug('Search returned null or empty');
        }
    }
    
    /**
     * Example 6: Case Insensitive Search
     * SOSL searches are case-insensitive by default
     */
    public static void caseInsensitiveSearch() {
        // These three searches will return the same results
        List<List<sObject>> results1 = [FIND 'ACME' RETURNING Account];
        List<List<sObject>> results2 = [FIND 'acme' RETURNING Account];
        List<List<sObject>> results3 = [FIND 'Acme' RETURNING Account];
        
        System.debug('ACME results: ' + results1[0].size());
        System.debug('acme results: ' + results2[0].size());
        System.debug('Acme results: ' + results3[0].size());
        // All three should return the same count
    }
    
    /**
     * Example 7: Accessing Specific Fields
     * Retrieving and using specific fields from search results
     */
    public static void accessingFields() {
        List<List<sObject>> searchResults = [
            FIND 'University'
            RETURNING Account(Id, Name, Phone, Industry, AnnualRevenue)
        ];
        
        if (!searchResults.isEmpty() && !searchResults[0].isEmpty()) {
            Account[] accounts = (Account[])searchResults[0];
            
            for (Account acc : accounts) {
                System.debug('Account Details:');
                System.debug('  ID: ' + acc.Id);
                System.debug('  Name: ' + acc.Name);
                System.debug('  Phone: ' + acc.Phone);
                System.debug('  Industry: ' + acc.Industry);
                System.debug('  Revenue: ' + acc.AnnualRevenue);
                System.debug('---');
            }
        }
    }
    
    /**
     * Example 8: Return Type Understanding
     * SOSL returns List<List<sObject>> not List<sObject>
     */
    public static void returnTypeDemo() {
        // SOSL always returns List<List<sObject>>
        List<List<sObject>> searchResults = [FIND 'Test' RETURNING Account, Contact];
        
        // First level: List of object types
        System.debug('Number of object types: ' + searchResults.size());
        
        // Second level: List of records for each object type
        for (Integer i = 0; i < searchResults.size(); i++) {
            System.debug('Object type ' + i + ' has ' + searchResults[i].size() + ' records');
        }
        
        // You must cast to specific sObject type to access fields
        if (!searchResults.isEmpty()) {
            // Correct way - cast to specific type
            Account[] accounts = (Account[])searchResults[0];
            
            // Incorrect way - this won't compile:
            // for (Account acc : searchResults[0]) { } // ERROR!
            
            // Correct iteration
            for (Account acc : accounts) {
                System.debug(acc.Name);
            }
        }
    }
    
    /**
     * Example 9: Empty Search Term Handling
     * What happens with empty or very short search terms
     */
    public static void emptySearchTerm() {
        try {
            // SOSL requires minimum 2 characters (1 for CJK languages)
            // This will throw an exception
            List<List<sObject>> results = [FIND 'A' RETURNING Account];
            System.debug('Results: ' + results);
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            System.debug('SOSL requires minimum 2 characters for search term');
        }
    }
    
    /**
     * Example 10: Basic Search Best Practices
     * Recommended patterns for SOSL queries
     */
    public static void searchBestPractices() {
        // 1. Always use specific field selection
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Id, Name, Phone)  // Specify fields instead of returning all
        ];
        
        // 2. Always check for null/empty
        if (results != null && !results.isEmpty()) {
            Account[] accounts = (Account[])results[0];
            
            // 3. Check specific list before processing
            if (!accounts.isEmpty()) {
                for (Account acc : accounts) {
                    // 4. Handle null field values
                    String phone = acc.Phone != null ? acc.Phone : 'No phone';
                    System.debug(acc.Name + ': ' + phone);
                }
            }
        }
        
        System.debug('Search completed with proper error handling');
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * // Execute in Developer Console Anonymous Window:
 * BasicSOSLSyntax.simpleSearch();
 * BasicSOSLSyntax.queryStructureExplanation();
 * BasicSOSLSyntax.singleObjectSearch();
 * BasicSOSLSyntax.multipleObjectSearch();
 * BasicSOSLSyntax.searchWithNullCheck();
 * BasicSOSLSyntax.caseInsensitiveSearch();
 * BasicSOSLSyntax.accessingFields();
 * BasicSOSLSyntax.returnTypeDemo();
 * BasicSOSLSyntax.emptySearchTerm();
 * BasicSOSLSyntax.searchBestPractices();
 */
