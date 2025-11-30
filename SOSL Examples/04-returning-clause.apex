/**
 * RETURNING Clause Examples
 * Demonstrates specifying which objects and fields to return
 * 
 * The RETURNING clause specifies:
 * - Which sObject types to include in results
 * - Which fields to retrieve for each object
 * - Optional WHERE, ORDER BY, LIMIT clauses per object
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class ReturningClauseExamples {
    
    /**
     * Example 1: Single Object Return
     * Returning results from one object type
     */
    public static void singleObjectReturn() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Id, Name, Industry, Phone)
        ];
        
        System.debug('Single object return - Accounts only');
        Account[] accounts = (Account[])results[0];
        
        for (Account acc : accounts) {
            System.debug('ID: ' + acc.Id);
            System.debug('Name: ' + acc.Name);
            System.debug('Industry: ' + acc.Industry);
            System.debug('Phone: ' + acc.Phone);
            System.debug('---');
        }
    }
    
    /**
     * Example 2: Multiple Objects Return
     * Returning results from multiple object types
     */
    public static void multipleObjectsReturn() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Id, Name, Phone),
                Contact(Id, FirstName, LastName, Email),
                Opportunity(Id, Name, StageName, Amount)
        ];
        
        System.debug('=== MULTIPLE OBJECTS ===');
        
        // Results[0] = Accounts
        Account[] accounts = (Account[])results[0];
        System.debug('Accounts found: ' + accounts.size());
        
        // Results[1] = Contacts
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts found: ' + contacts.size());
        
        // Results[2] = Opportunities
        Opportunity[] opportunities = (Opportunity[])results[2];
        System.debug('Opportunities found: ' + opportunities.size());
    }
    
    /**
     * Example 3: Selecting Specific Fields
     * Choosing which fields to retrieve
     */
    public static void selectSpecificFields() {
        // Only retrieve the fields you need
        List<List<sObject>> results = [
            FIND 'Smith'
            IN NAME FIELDS
            RETURNING Contact(
                Id,
                FirstName,
                LastName,
                Email,
                Phone,
                AccountId,
                Account.Name  // Related field
            )
        ];
        
        System.debug('Specific field selection:');
        Contact[] contacts = (Contact[])results[0];
        
        for (Contact con : contacts) {
            System.debug('Name: ' + con.FirstName + ' ' + con.LastName);
            System.debug('Email: ' + con.Email);
            System.debug('Phone: ' + con.Phone);
            System.debug('Account: ' + con.Account.Name);
            System.debug('---');
        }
    }
    
    /**
     * Example 4: Including Related Fields
     * Accessing parent object fields
     */
    public static void relatedFieldsAccess() {
        List<List<sObject>> results = [
            FIND 'John'
            RETURNING Contact(
                FirstName,
                LastName,
                Email,
                Account.Name,           // Parent Account Name
                Account.Industry,       // Parent Account Industry
                Account.BillingCity     // Parent Account City
            )
        ];
        
        System.debug('=== RELATED FIELDS ===');
        Contact[] contacts = (Contact[])results[0];
        
        for (Contact con : contacts) {
            System.debug('Contact: ' + con.FirstName + ' ' + con.LastName);
            if (con.Account != null) {
                System.debug('  Company: ' + con.Account.Name);
                System.debug('  Industry: ' + con.Account.Industry);
                System.debug('  Location: ' + con.Account.BillingCity);
            }
            System.debug('---');
        }
    }
    
    /**
     * Example 5: RETURNING with WHERE Clause
     * Filtering results per object
     */
    public static void returningWithWhere() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, Industry WHERE Industry = 'Technology'),
                Contact(FirstName, LastName WHERE CreatedDate = THIS_YEAR)
        ];
        
        System.debug('=== FILTERED RESULTS ===');
        
        // Only Technology accounts
        Account[] accounts = (Account[])results[0];
        System.debug('Technology Accounts: ' + accounts.size());
        for (Account acc : accounts) {
            System.debug('  ' + acc.Name + ' - ' + acc.Industry);
        }
        
        // Only contacts created this year
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts created this year: ' + contacts.size());
    }
    
    /**
     * Example 6: RETURNING with ORDER BY
     * Sorting results per object
     */
    public static void returningWithOrderBy() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING 
                Account(Name, AnnualRevenue ORDER BY AnnualRevenue DESC),
                Contact(FirstName, LastName ORDER BY LastName ASC, FirstName ASC)
        ];
        
        System.debug('=== SORTED RESULTS ===');
        
        // Accounts sorted by revenue (highest first)
        Account[] accounts = (Account[])results[0];
        System.debug('Accounts (by revenue):');
        for (Account acc : accounts) {
            System.debug('  ' + acc.Name + ' - $' + acc.AnnualRevenue);
        }
        
        // Contacts sorted alphabetically
        Contact[] contacts = (Contact[])results[1];
        System.debug('Contacts (alphabetical):');
        for (Contact con : contacts) {
            System.debug('  ' + con.LastName + ', ' + con.FirstName);
        }
    }
    
    /**
     * Example 7: RETURNING with LIMIT
     * Limiting results per object
     */
    public static void returningWithLimit() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, Industry LIMIT 5),
                Contact(FirstName, LastName LIMIT 10),
                Opportunity(Name, StageName LIMIT 3)
        ];
        
        System.debug('=== LIMITED RESULTS ===');
        System.debug('Accounts (max 5): ' + results[0].size());
        System.debug('Contacts (max 10): ' + results[1].size());
        System.debug('Opportunities (max 3): ' + results[2].size());
    }
    
    /**
     * Example 8: Combining WHERE, ORDER BY, and LIMIT
     * Complete filtering and sorting
     */
    public static void completeReturningClause() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Id,
                Name,
                Industry,
                AnnualRevenue,
                CreatedDate
                WHERE Industry = 'Technology' 
                  AND AnnualRevenue > 1000000
                ORDER BY AnnualRevenue DESC
                LIMIT 10
            )
        ];
        
        System.debug('=== COMPLETE FILTERING ===');
        System.debug('Top 10 Technology accounts with revenue > $1M:');
        
        Account[] accounts = (Account[])results[0];
        for (Integer i = 0; i < accounts.size(); i++) {
            Account acc = accounts[i];
            System.debug((i+1) + '. ' + acc.Name + ' - $' + acc.AnnualRevenue);
        }
    }
    
    /**
     * Example 9: Multiple Fields and Relationships
     * Complex field selection
     */
    public static void complexFieldSelection() {
        List<List<sObject>> results = [
            FIND 'Johnson'
            RETURNING Contact(
                Id,
                FirstName,
                LastName,
                Email,
                Phone,
                Title,
                Department,
                MailingCity,
                MailingState,
                Account.Id,
                Account.Name,
                Account.Industry,
                Account.Phone,
                Owner.Name,
                Owner.Email
                WHERE Account.Industry != null
                ORDER BY LastName
            )
        ];
        
        System.debug('=== COMPLEX SELECTION ===');
        Contact[] contacts = (Contact[])results[0];
        
        for (Contact con : contacts) {
            System.debug('Contact: ' + con.FirstName + ' ' + con.LastName);
            System.debug('  Title: ' + con.Title);
            System.debug('  Email: ' + con.Email);
            System.debug('  Account: ' + con.Account.Name);
            System.debug('  Industry: ' + con.Account.Industry);
            System.debug('  Owner: ' + con.Owner.Name);
            System.debug('---');
        }
    }
    
    /**
     * Example 10: Standard and Custom Objects
     * Returning both standard and custom objects
     */
    public static void standardAndCustomObjects() {
        // Note: Replace CustomObject__c with your actual custom object
        List<List<sObject>> results = [
            FIND 'Test'
            RETURNING 
                Account(Name, Phone),
                Contact(FirstName, LastName),
                Case(CaseNumber, Subject, Status)
                // CustomObject__c(Name, Custom_Field__c)  // Uncomment if you have custom objects
        ];
        
        System.debug('Standard objects returned:');
        System.debug('Accounts: ' + results[0].size());
        System.debug('Contacts: ' + results[1].size());
        System.debug('Cases: ' + results[2].size());
    }
    
    /**
     * Example 11: Date Filtering in RETURNING
     * Using date literals in WHERE clause
     */
    public static void dateFilteringInReturning() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, CreatedDate WHERE CreatedDate = THIS_YEAR),
                Contact(FirstName, LastName WHERE CreatedDate = LAST_MONTH),
                Opportunity(Name, CloseDate WHERE CloseDate = THIS_QUARTER)
        ];
        
        System.debug('=== DATE FILTERING ===');
        System.debug('Accounts created this year: ' + results[0].size());
        System.debug('Contacts created last month: ' + results[1].size());
        System.debug('Opportunities closing this quarter: ' + results[2].size());
    }
    
    /**
     * Example 12: Field-Level Security
     * SOSL respects field-level security
     */
    public static void fieldLevelSecurityDemo() {
        // Fields that user doesn't have access to will return null
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name,           // Accessible to all
                Industry,       // Accessible to all
                AnnualRevenue   // May be restricted
            )
        ];
        
        System.debug('Field-level security applies:');
        Account[] accounts = (Account[])results[0];
        
        for (Account acc : accounts) {
            System.debug('Name: ' + acc.Name);
            System.debug('Industry: ' + acc.Industry);
            System.debug('Revenue: ' + (acc.AnnualRevenue != null ? 
                         String.valueOf(acc.AnnualRevenue) : 'No access or null'));
        }
    }
    
    /**
     * Example 13: Empty Results Handling
     * Proper handling when objects return no results
     */
    public static void emptyResultsHandling() {
        List<List<sObject>> results = [
            FIND 'NonExistentSearchTerm12345'
            RETURNING Account(Name), Contact(Name), Lead(Name)
        ];
        
        System.debug('=== EMPTY RESULTS HANDLING ===');
        
        // Check each object type
        if (!results[0].isEmpty()) {
            System.debug('Accounts found: ' + results[0].size());
        } else {
            System.debug('No accounts found');
        }
        
        if (results.size() > 1 && !results[1].isEmpty()) {
            System.debug('Contacts found: ' + results[1].size());
        } else {
            System.debug('No contacts found');
        }
        
        if (results.size() > 2 && !results[2].isEmpty()) {
            System.debug('Leads found: ' + results[2].size());
        } else {
            System.debug('No leads found');
        }
    }
    
    /**
     * Example 14: Polymorphic Relationships
     * Handling polymorphic fields like Owner
     */
    public static void polymorphicRelationships() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name,
                Owner.Name,        // Could be User or Queue
                Owner.Type,
                OwnerId
            )
        ];
        
        System.debug('=== POLYMORPHIC FIELDS ===');
        Account[] accounts = (Account[])results[0];
        
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
            System.debug('Owner: ' + acc.Owner.Name);
            System.debug('Owner ID: ' + acc.OwnerId);
            System.debug('---');
        }
    }
    
    /**
     * Example 15: Real-World Complete Example
     * Practical search implementation
     */
    public static List<Map<String, Object>> searchCustomers(String searchTerm) {
        // Comprehensive customer search
        List<Map<String, Object>> searchResults = new List<Map<String, Object>>();
        
        if (String.isBlank(searchTerm) || searchTerm.length() < 2) {
            return searchResults;
        }
        
        List<List<sObject>> results = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING 
                Account(
                    Id, Name, Phone, Industry, Type, BillingCity
                    WHERE Type = 'Customer'
                    ORDER BY Name
                    LIMIT 20
                ),
                Contact(
                    Id, FirstName, LastName, Email, Phone, Title,
                    Account.Name, Account.Id
                    WHERE Account.Type = 'Customer'
                    ORDER BY LastName, FirstName
                    LIMIT 20
                )
        ];
        
        // Process Accounts
        if (!results[0].isEmpty()) {
            for (Account acc : (Account[])results[0]) {
                Map<String, Object> accMap = new Map<String, Object>{
                    'type' => 'Account',
                    'id' => acc.Id,
                    'name' => acc.Name,
                    'phone' => acc.Phone,
                    'industry' => acc.Industry,
                    'city' => acc.BillingCity
                };
                searchResults.add(accMap);
            }
        }
        
        // Process Contacts
        if (results.size() > 1 && !results[1].isEmpty()) {
            for (Contact con : (Contact[])results[1]) {
                Map<String, Object> conMap = new Map<String, Object>{
                    'type' => 'Contact',
                    'id' => con.Id,
                    'name' => con.FirstName + ' ' + con.LastName,
                    'email' => con.Email,
                    'phone' => con.Phone,
                    'title' => con.Title,
                    'accountName' => con.Account.Name
                };
                searchResults.add(conMap);
            }
        }
        
        System.debug('Total results: ' + searchResults.size());
        return searchResults;
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * ReturningClauseExamples.singleObjectReturn();
 * ReturningClauseExamples.multipleObjectsReturn();
 * ReturningClauseExamples.selectSpecificFields();
 * ReturningClauseExamples.relatedFieldsAccess();
 * ReturningClauseExamples.returningWithWhere();
 * ReturningClauseExamples.returningWithOrderBy();
 * ReturningClauseExamples.returningWithLimit();
 * ReturningClauseExamples.completeReturningClause();
 * 
 * // Real-world usage:
 * List<Map<String, Object>> results = ReturningClauseExamples.searchCustomers('Acme');
 * System.debug(results);
 */
