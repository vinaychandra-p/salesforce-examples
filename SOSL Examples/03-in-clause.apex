/**
 * IN Clause Examples
 * Demonstrates searching in specific field groups
 * 
 * The IN clause specifies which types of fields to search:
 * - ALL FIELDS (default)
 * - NAME FIELDS
 * - EMAIL FIELDS
 * - PHONE FIELDS
 * - SIDEBAR FIELDS
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class InClauseExamples {
    
    /**
     * Example 1: IN ALL FIELDS (Default)
     * Searches across all searchable fields
     */
    public static void searchAllFields() {
        // IN ALL FIELDS is the default behavior
        List<List<sObject>> results1 = [
            FIND 'Acme'
            IN ALL FIELDS
            RETURNING Account(Name, Industry, Description)
        ];
        
        // Equivalent query without IN clause
        List<List<sObject>> results2 = [
            FIND 'Acme'
            RETURNING Account(Name, Industry, Description)
        ];
        
        System.debug('ALL FIELDS search: ' + results1[0].size());
        System.debug('Default search: ' + results2[0].size());
        System.debug('Both should return same results');
    }
    
    /**
     * Example 2: IN NAME FIELDS
     * Searches only in name-type fields
     */
    public static void searchNameFields() {
        // Searches only in Name, FirstName, LastName, and similar fields
        List<List<sObject>> results = [
            FIND 'Smith'
            IN NAME FIELDS
            RETURNING Account(Name), Contact(FirstName, LastName), Lead(FirstName, LastName)
        ];
        
        System.debug('=== NAME FIELDS SEARCH ===');
        
        // Accounts with "Smith" in Name
        Account[] accounts = (Account[])results[0];
        System.debug('Accounts with "Smith" in name: ' + accounts.size());
        for (Account acc : accounts) {
            System.debug('  ' + acc.Name);
        }
        
        // Contacts with "Smith" in FirstName or LastName
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts with "Smith": ' + contacts.size());
        for (Contact con : contacts) {
            System.debug('  ' + con.FirstName + ' ' + con.LastName);
        }
        
        // Leads
        Lead[] leads = (Lead[])results[2];
        System.debug('Leads with "Smith": ' + leads.size());
    }
    
    /**
     * Example 3: IN EMAIL FIELDS
     * Searches only in email fields
     */
    public static void searchEmailFields() {
        // Searches only Email and email-type fields
        List<List<sObject>> results = [
            FIND 'gmail.com'
            IN EMAIL FIELDS
            RETURNING Contact(FirstName, LastName, Email), Lead(FirstName, LastName, Email)
        ];
        
        System.debug('=== EMAIL FIELDS SEARCH ===');
        
        Contact[] contacts = (Contact[])results[0];
        System.debug('Contacts with gmail.com: ' + contacts.size());
        for (Contact con : contacts) {
            System.debug('  ' + con.FirstName + ' ' + con.LastName + ': ' + con.Email);
        }
        
        if (results.size() > 1) {
            Lead[] leads = (Lead[])results[1];
            System.debug('Leads with gmail.com: ' + leads.size());
        }
    }
    
    /**
     * Example 4: IN PHONE FIELDS
     * Searches only in phone number fields
     */
    public static void searchPhoneFields() {
        // Searches Phone, Mobile, Fax, and other phone-type fields
        List<List<sObject>> results = [
            FIND '415'
            IN PHONE FIELDS
            RETURNING Account(Name, Phone), Contact(FirstName, LastName, Phone, MobilePhone)
        ];
        
        System.debug('=== PHONE FIELDS SEARCH ===');
        
        Account[] accounts = (Account[])results[0];
        System.debug('Accounts with 415 area code: ' + accounts.size());
        for (Account acc : accounts) {
            System.debug('  ' + acc.Name + ': ' + acc.Phone);
        }
        
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts with 415: ' + contacts.size());
        for (Contact con : contacts) {
            System.debug('  ' + con.FirstName + ' ' + con.LastName);
            if (con.Phone != null) System.debug('    Phone: ' + con.Phone);
            if (con.MobilePhone != null) System.debug('    Mobile: ' + con.MobilePhone);
        }
    }
    
    /**
     * Example 5: IN SIDEBAR FIELDS
     * Searches fields displayed in sidebar (Name, Email, Phone)
     */
    public static void searchSidebarFields() {
        // SIDEBAR FIELDS includes: Name, Email, Phone fields
        List<List<sObject>> results = [
            FIND 'John'
            IN SIDEBAR FIELDS
            RETURNING Contact(FirstName, LastName, Email, Phone)
        ];
        
        System.debug('=== SIDEBAR FIELDS SEARCH ===');
        System.debug('Searches Name, Email, and Phone fields');
        
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' - ' + con.Email);
        }
    }
    
    /**
     * Example 6: Comparing Different IN Clauses
     * Understanding the scope of each IN option
     */
    public static void compareInClauses() {
        String searchTerm = 'Acme';
        
        // Search in all fields
        List<List<sObject>> allFields = [
            FIND :searchTerm IN ALL FIELDS RETURNING Account
        ];
        
        // Search in name fields only
        List<List<sObject>> nameFields = [
            FIND :searchTerm IN NAME FIELDS RETURNING Account
        ];
        
        // Search in sidebar fields
        List<List<sObject>> sidebarFields = [
            FIND :searchTerm IN SIDEBAR FIELDS RETURNING Account
        ];
        
        System.debug('=== COMPARISON ===');
        System.debug('ALL FIELDS: ' + allFields[0].size() + ' results');
        System.debug('NAME FIELDS: ' + nameFields[0].size() + ' results');
        System.debug('SIDEBAR FIELDS: ' + sidebarFields[0].size() + ' results');
        System.debug('ALL FIELDS >= SIDEBAR FIELDS >= NAME FIELDS (typically)');
    }
    
    /**
     * Example 7: Performance - Name Fields vs All Fields
     * NAME FIELDS is more efficient than ALL FIELDS
     */
    public static void performanceComparison() {
        Long startTime, endTime;
        
        // Measure ALL FIELDS search
        startTime = System.now().getTime();
        List<List<sObject>> allFieldsResults = [
            FIND 'Smith' IN ALL FIELDS RETURNING Contact
        ];
        endTime = System.now().getTime();
        Long allFieldsTime = endTime - startTime;
        
        // Measure NAME FIELDS search
        startTime = System.now().getTime();
        List<List<sObject>> nameFieldsResults = [
            FIND 'Smith' IN NAME FIELDS RETURNING Contact
        ];
        endTime = System.now().getTime();
        Long nameFieldsTime = endTime - startTime;
        
        System.debug('=== PERFORMANCE ===');
        System.debug('ALL FIELDS time: ' + allFieldsTime + 'ms');
        System.debug('NAME FIELDS time: ' + nameFieldsTime + 'ms');
        System.debug('NAME FIELDS is typically faster (smaller search scope)');
    }
    
    /**
     * Example 8: Email Search - Partial Match
     * Finding emails by domain or username
     */
    public static void emailPartialSearch() {
        // Search for specific email domain
        List<List<sObject>> results = [
            FIND 'acme.com'
            IN EMAIL FIELDS
            RETURNING Contact(FirstName, LastName, Email, AccountId)
        ];
        
        System.debug('Emails from acme.com domain:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug('  ' + con.Email);
        }
    }
    
    /**
     * Example 9: Phone Search - Area Code
     * Finding records by phone area code
     */
    public static void phoneAreaCodeSearch() {
        // Search for San Francisco area code
        List<List<sObject>> results = [
            FIND '415*'
            IN PHONE FIELDS
            RETURNING Account(Name, Phone, BillingCity), 
                     Contact(FirstName, LastName, Phone, MailingCity)
        ];
        
        System.debug('=== 415 AREA CODE SEARCH ===');
        
        Account[] accounts = (Account[])results[0];
        System.debug('Accounts: ' + accounts.size());
        for (Account acc : accounts) {
            System.debug('  ' + acc.Name + ' (' + acc.BillingCity + '): ' + acc.Phone);
        }
        
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts: ' + contacts.size());
    }
    
    /**
     * Example 10: Name Fields with Wildcards
     * Finding names with partial information
     */
    public static void nameFieldsWildcard() {
        // Find all people with first name starting with "John"
        List<List<sObject>> results = [
            FIND 'John*'
            IN NAME FIELDS
            RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)
        ];
        
        System.debug('Names starting with "John":');
        
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug('  Contact: ' + con.FirstName + ' ' + con.LastName);
        }
        
        if (results.size() > 1) {
            Lead[] leads = (Lead[])results[1];
            for (Lead ld : leads) {
                System.debug('  Lead: ' + ld.FirstName + ' ' + ld.LastName);
            }
        }
    }
    
    /**
     * Example 11: Multi-Object Email Search
     * Finding email across all standard objects
     */
    public static void multiObjectEmailSearch() {
        List<List<sObject>> results = [
            FIND 'john@*'
            IN EMAIL FIELDS
            RETURNING 
                Contact(FirstName, LastName, Email),
                Lead(FirstName, LastName, Email),
                User(FirstName, LastName, Email)
        ];
        
        System.debug('=== EMAIL SEARCH: john@* ===');
        
        if (!results[0].isEmpty()) {
            System.debug('Contacts: ' + results[0].size());
        }
        if (results.size() > 1 && !results[1].isEmpty()) {
            System.debug('Leads: ' + results[1].size());
        }
        if (results.size() > 2 && !results[2].isEmpty()) {
            System.debug('Users: ' + results[2].size());
        }
    }
    
    /**
     * Example 12: Sidebar Fields Best Practice
     * When to use SIDEBAR FIELDS
     */
    public static void sidebarFieldsBestPractice() {
        // Use SIDEBAR FIELDS for quick lookups in key fields
        // Perfect for search bars and auto-complete features
        
        String userInput = 'Acme';
        
        List<List<sObject>> results = [
            FIND :userInput
            IN SIDEBAR FIELDS
            RETURNING Account(Id, Name, Phone, Type)
        ];
        
        System.debug('Quick lookup results for: ' + userInput);
        Account[] accounts = (Account[])results[0];
        
        if (!accounts.isEmpty()) {
            System.debug('Found ' + accounts.size() + ' accounts');
            for (Integer i = 0; i < Math.min(5, accounts.size()); i++) {
                Account acc = accounts[i];
                System.debug('  ' + acc.Name + ' - ' + acc.Phone);
            }
        } else {
            System.debug('No results found');
        }
    }
    
    /**
     * Example 13: Field Coverage Understanding
     * Which fields are searched by each IN clause
     */
    public static void fieldCoverageDemo() {
        System.debug('=== FIELD COVERAGE ===');
        System.debug('');
        System.debug('ALL FIELDS:');
        System.debug('  - All searchable fields on the object');
        System.debug('  - Name, Email, Phone, Text, TextArea, etc.');
        System.debug('');
        System.debug('NAME FIELDS:');
        System.debug('  - Name, FirstName, LastName');
        System.debug('  - Company (for Leads)');
        System.debug('  - Custom fields ending in __Name');
        System.debug('');
        System.debug('EMAIL FIELDS:');
        System.debug('  - Email');
        System.debug('  - Custom fields of type Email');
        System.debug('');
        System.debug('PHONE FIELDS:');
        System.debug('  - Phone, Mobile, Fax');
        System.debug('  - Custom fields of type Phone');
        System.debug('');
        System.debug('SIDEBAR FIELDS:');
        System.debug('  - NAME + EMAIL + PHONE fields combined');
    }
    
    /**
     * Example 14: Real-World Use Cases
     * Practical applications of different IN clauses
     */
    public static void realWorldUseCases() {
        System.debug('=== REAL-WORLD USE CASES ===');
        
        // Use Case 1: Contact Lookup by Name
        System.debug('1. Contact Lookup:');
        List<List<sObject>> nameSearch = [
            FIND 'Smith' IN NAME FIELDS RETURNING Contact(FirstName, LastName, Phone)
        ];
        System.debug('   Found ' + nameSearch[0].size() + ' contacts named Smith');
        
        // Use Case 2: Find Customer by Email
        System.debug('2. Customer Email Lookup:');
        List<List<sObject>> emailSearch = [
            FIND 'john@acme.com' IN EMAIL FIELDS RETURNING Contact(FirstName, LastName, AccountId)
        ];
        System.debug('   Email search completed');
        
        // Use Case 3: Support Ticket - Find by Phone
        System.debug('3. Support Phone Lookup:');
        List<List<sObject>> phoneSearch = [
            FIND '555-1234' IN PHONE FIELDS RETURNING Contact(Name, Email), Case(CaseNumber)
        ];
        System.debug('   Phone search completed');
        
        // Use Case 4: Global Search Bar
        System.debug('4. Global Search (Sidebar):');
        String searchInput = 'Acme';
        List<List<sObject>> globalSearch = [
            FIND :searchInput IN SIDEBAR FIELDS 
            RETURNING Account(Name), Contact(Name), Lead(Name)
        ];
        System.debug('   Global search completed');
    }
    
    /**
     * Example 15: Optimization Strategy
     * Choosing the right IN clause for performance
     */
    public static void optimizationStrategy() {
        String searchTerm = 'John';
        
        System.debug('=== OPTIMIZATION STRATEGY ===');
        System.debug('');
        System.debug('If searching for person names:');
        System.debug('  ✓ Use IN NAME FIELDS (fastest)');
        List<List<sObject>> nameResults = [
            FIND :searchTerm IN NAME FIELDS RETURNING Contact
        ];
        System.debug('  Results: ' + nameResults[0].size());
        
        System.debug('');
        System.debug('If searching for email addresses:');
        System.debug('  ✓ Use IN EMAIL FIELDS (targeted)');
        List<List<sObject>> emailResults = [
            FIND :searchTerm IN EMAIL FIELDS RETURNING Contact
        ];
        System.debug('  Results: ' + emailResults[0].size());
        
        System.debug('');
        System.debug('If searching for any contact info:');
        System.debug('  ✓ Use IN SIDEBAR FIELDS (balanced)');
        List<List<sObject>> sidebarResults = [
            FIND :searchTerm IN SIDEBAR FIELDS RETURNING Contact
        ];
        System.debug('  Results: ' + sidebarResults[0].size());
        
        System.debug('');
        System.debug('Only use IN ALL FIELDS when necessary!');
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * InClauseExamples.searchAllFields();
 * InClauseExamples.searchNameFields();
 * InClauseExamples.searchEmailFields();
 * InClauseExamples.searchPhoneFields();
 * InClauseExamples.searchSidebarFields();
 * InClauseExamples.compareInClauses();
 * InClauseExamples.performanceComparison();
 * InClauseExamples.realWorldUseCases();
 * InClauseExamples.optimizationStrategy();
 */
