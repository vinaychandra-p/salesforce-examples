/**
 * FIND Clause Examples
 * Demonstrates various search patterns using the FIND clause
 * 
 * The FIND clause specifies the text to search for.
 * It's the most important part of a SOSL query.
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class FindClauseExamples {
    
    /**
     * Example 1: Single Word Search
     * Searching for a single word across objects
     */
    public static void singleWordSearch() {
        // Searches for the word "Acme" in all searchable fields
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Name), Contact(FirstName, LastName)
        ];
        
        System.debug('Single word search for "Acme"');
        System.debug('Accounts: ' + results[0].size());
        System.debug('Contacts: ' + results[1].size());
    }
    
    /**
     * Example 2: Multi-Word Search (AND logic)
     * Multiple words are treated as AND by default
     */
    public static void multiWordSearch() {
        // Searches for records containing BOTH "Acme" AND "Corporation"
        List<List<sObject>> results = [
            FIND 'Acme Corporation'
            RETURNING Account(Name, Industry)
        ];
        
        if (!results[0].isEmpty()) {
            System.debug('Records containing both "Acme" AND "Corporation":');
            for (Account acc : (Account[])results[0]) {
                System.debug(acc.Name + ' - ' + acc.Industry);
            }
        }
    }
    
    /**
     * Example 3: Phrase Search (Exact Match)
     * Using quotes for exact phrase matching
     */
    public static void phraseSearch() {
        // Searches for exact phrase "Acme Corporation"
        List<List<sObject>> results = [
            FIND '"Acme Corporation"'
            RETURNING Account(Name)
        ];
        
        System.debug('Exact phrase search for "Acme Corporation"');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug('Exact match found: ' + acc.Name);
        }
    }
    
    /**
     * Example 4: OR Operator
     * Finding records matching any of the search terms
     */
    public static void orOperatorSearch() {
        // Searches for records containing "Acme" OR "Global"
        List<List<sObject>> results = [
            FIND 'Acme OR Global'
            RETURNING Account(Name, Type)
        ];
        
        System.debug('Records containing "Acme" OR "Global":');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' (' + acc.Type + ')');
        }
    }
    
    /**
     * Example 5: AND Operator (Explicit)
     * Using AND operator explicitly
     */
    public static void andOperatorSearch() {
        // Explicitly using AND (same as space-separated words)
        List<List<sObject>> results = [
            FIND 'Acme AND Corporation'
            RETURNING Account(Name)
        ];
        
        System.debug('Records with "Acme" AND "Corporation":');
        System.debug('Found: ' + results[0].size() + ' accounts');
    }
    
    /**
     * Example 6: NOT Operator
     * Excluding records with specific terms
     */
    public static void notOperatorSearch() {
        // Find records with "Acme" but NOT "Corporation"
        List<List<sObject>> results = [
            FIND 'Acme AND NOT Corporation'
            RETURNING Account(Name, Industry)
        ];
        
        System.debug('Records with "Acme" excluding "Corporation":');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    /**
     * Example 7: Complex Boolean Logic
     * Combining AND, OR, NOT operators
     */
    public static void complexBooleanSearch() {
        // Find: (Acme OR Global) AND NOT Test
        List<List<sObject>> results = [
            FIND '(Acme OR Global) AND NOT Test'
            RETURNING Account(Name, Type)
        ];
        
        System.debug('Complex search: (Acme OR Global) AND NOT Test');
        Account[] accounts = (Account[])results[0];
        System.debug('Found ' + accounts.size() + ' accounts');
        
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    /**
     * Example 8: Wildcard Search (Asterisk)
     * Using * for prefix matching
     */
    public static void wildcardAsteriskSearch() {
        // Find all records starting with "Acm"
        List<List<sObject>> results = [
            FIND 'Acm*'
            RETURNING Account(Name), Contact(LastName)
        ];
        
        System.debug('Wildcard search: Acm*');
        System.debug('Matches: Acme, Acme Corp, Acme Industries, etc.');
        
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
        }
    }
    
    /**
     * Example 9: Wildcard Search (Question Mark)
     * Using ? for single character matching
     */
    public static void wildcardQuestionMarkSearch() {
        // Find records like "Sm?th" (Smith, Smyth, etc.)
        List<List<sObject>> results = [
            FIND 'Sm?th'
            RETURNING Contact(FirstName, LastName)
        ];
        
        System.debug('Single character wildcard: Sm?th');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName);
        }
    }
    
    /**
     * Example 10: Numeric Search
     * Searching for numbers
     */
    public static void numericSearch() {
        // Search for phone numbers, zip codes, or other numeric data
        List<List<sObject>> results = [
            FIND '415'
            RETURNING Account(Name, Phone), Contact(FirstName, LastName, Phone)
        ];
        
        System.debug('Numeric search for "415" (area code)');
        
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name + ' - ' + acc.Phone);
        }
        
        Contact[] contacts = (Contact[])results[1];
        for (Contact con : contacts) {
            System.debug('Contact: ' + con.FirstName + ' ' + con.LastName + ' - ' + con.Phone);
        }
    }
    
    /**
     * Example 11: Email Search
     * Searching for email addresses
     */
    public static void emailSearch() {
        // Search for email patterns
        List<List<sObject>> results = [
            FIND 'gmail.com'
            RETURNING Contact(FirstName, LastName, Email), Lead(FirstName, LastName, Email)
        ];
        
        System.debug('Email domain search: gmail.com');
        
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug('Contact: ' + con.Email);
        }
    }
    
    /**
     * Example 12: Special Characters in Search
     * Handling special characters
     */
    public static void specialCharacterSearch() {
        // Some special characters need escaping
        // Use backslash to escape: & | ! { } [ ] ( ) ^ ~ * ? : \ " ' +
        
        // Searching for "C++" programming language
        List<List<sObject>> results = [
            FIND 'C\\+\\+'
            RETURNING Account(Name, Description)
        ];
        
        System.debug('Search with escaped special characters: C++');
        System.debug('Found: ' + results[0].size() + ' records');
    }
    
    /**
     * Example 13: Date-Related Text Search
     * Searching for date strings in text fields
     */
    public static void dateTextSearch() {
        // Searching for year in descriptions or notes
        List<List<sObject>> results = [
            FIND '2024'
            RETURNING Account(Name, Description), Contact(FirstName, LastName, Description)
        ];
        
        System.debug('Date text search for "2024"');
        System.debug('This searches text fields, not date fields');
    }
    
    /**
     * Example 14: Minimum Search Length
     * Understanding minimum character requirements
     */
    public static void minimumSearchLength() {
        try {
            // Valid: 2 or more characters
            List<List<sObject>> results1 = [FIND 'Ab' RETURNING Account];
            System.debug('2-character search successful: ' + results1[0].size());
            
            // Valid: 3+ characters
            List<List<sObject>> results2 = [FIND 'Abc' RETURNING Account];
            System.debug('3-character search successful: ' + results2[0].size());
            
        } catch (Exception e) {
            System.debug('Search error: ' + e.getMessage());
        }
    }
    
    /**
     * Example 15: Case Sensitivity Demonstration
     * SOSL is case-insensitive
     */
    public static void caseSensitivityDemo() {
        // All these searches return the same results
        String[] searchTerms = new String[]{'ACME', 'acme', 'Acme', 'AcMe'};
        
        for (String term : searchTerms) {
            List<List<sObject>> results = [
                FIND :term
                RETURNING Account(Name)
            ];
            System.debug('Search "' + term + '" found: ' + results[0].size() + ' accounts');
        }
        
        System.debug('All searches should return the same count');
    }
    
    /**
     * Example 16: Combined Wildcards and Operators
     * Advanced search patterns
     */
    public static void advancedPatterns() {
        // Find: starts with "Acm" OR exactly "Global Corp"
        List<List<sObject>> results = [
            FIND 'Acm* OR "Global Corp"'
            RETURNING Account(Name, Industry)
        ];
        
        System.debug('Advanced pattern: Acm* OR "Global Corp"');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.Industry);
        }
    }
    
    /**
     * Example 17: Multiple Phrase Search
     * Searching for multiple exact phrases
     */
    public static void multiplePhraseSearch() {
        // Find records with either phrase
        List<List<sObject>> results = [
            FIND '"Acme Corporation" OR "Global Industries"'
            RETURNING Account(Name, Type)
        ];
        
        System.debug('Multiple phrase search');
        Account[] accounts = (Account[])results[0];
        System.debug('Found ' + accounts.size() + ' matching accounts');
    }
    
    /**
     * Example 18: Negation with Wildcards
     * Combining NOT with wildcard searches
     */
    public static void negationWithWildcards() {
        // Find: starts with "Acm" but NOT "Acme Test"
        List<List<sObject>> results = [
            FIND 'Acm* AND NOT "Test"'
            RETURNING Account(Name)
        ];
        
        System.debug('Wildcard with negation: Acm* AND NOT Test');
        System.debug('Results: ' + results[0].size());
    }
    
    /**
     * Example 19: Empty/Null Search Handling
     * Proper handling of edge cases
     */
    public static void emptySearchHandling() {
        String searchTerm = ''; // User input might be empty
        
        if (String.isNotBlank(searchTerm) && searchTerm.length() >= 2) {
            List<List<sObject>> results = [
                FIND :searchTerm
                RETURNING Account
            ];
            System.debug('Search executed');
        } else {
            System.debug('Search term must be at least 2 characters');
        }
    }
    
    /**
     * Example 20: Real-World Search Pattern
     * Practical example combining multiple techniques
     */
    public static void realWorldSearchExample() {
        // Global search functionality: Find customer by name, email, or phone
        String userInput = 'john smith';
        
        if (String.isNotBlank(userInput) && userInput.length() >= 2) {
            List<List<sObject>> results = [
                FIND :userInput
                IN ALL FIELDS
                RETURNING 
                    Account(Id, Name, Phone, Type, Industry),
                    Contact(Id, FirstName, LastName, Email, Phone, AccountId),
                    Lead(Id, FirstName, LastName, Email, Phone, Company)
            ];
            
            // Process results
            System.debug('=== SEARCH RESULTS FOR: ' + userInput + ' ===');
            
            if (!results[0].isEmpty()) {
                System.debug('Accounts (' + results[0].size() + '):');
                for (Account acc : (Account[])results[0]) {
                    System.debug('  - ' + acc.Name);
                }
            }
            
            if (results.size() > 1 && !results[1].isEmpty()) {
                System.debug('Contacts (' + results[1].size() + '):');
                for (Contact con : (Contact[])results[1]) {
                    System.debug('  - ' + con.FirstName + ' ' + con.LastName);
                }
            }
            
            if (results.size() > 2 && !results[2].isEmpty()) {
                System.debug('Leads (' + results[2].size() + '):');
                for (Lead ld : (Lead[])results[2]) {
                    System.debug('  - ' + ld.FirstName + ' ' + ld.LastName);
                }
            }
        }
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * FindClauseExamples.singleWordSearch();
 * FindClauseExamples.multiWordSearch();
 * FindClauseExamples.phraseSearch();
 * FindClauseExamples.orOperatorSearch();
 * FindClauseExamples.andOperatorSearch();
 * FindClauseExamples.notOperatorSearch();
 * FindClauseExamples.complexBooleanSearch();
 * FindClauseExamples.wildcardAsteriskSearch();
 * FindClauseExamples.wildcardQuestionMarkSearch();
 * FindClauseExamples.realWorldSearchExample();
 */
