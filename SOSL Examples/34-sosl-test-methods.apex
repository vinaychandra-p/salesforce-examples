/**
 * SOSL Testing Examples
 * Using Test.setFixedSearchResults() for unit testing
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

@isTest
public class SOSLTestMethodsExamples {
    
    @isTest
    static void testBasicSearch() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Acme Corp');
        insert testAccount;
        
        // Set fixed search results
        List<Id> fixedResults = new List<Id>{testAccount.Id};
        Test.setFixedSearchResults(fixedResults);
        
        // Execute search
        List<List<sObject>> results = [FIND 'Acme' RETURNING Account(Name)];
        
        // Assertions
        System.assert(!results[0].isEmpty(), 'Should find account');
        Account found = (Account)results[0][0];
        System.assertEquals('Test Acme Corp', found.Name);
    }
    
    @isTest
    static void testMultipleObjectSearch() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName = 'John', LastName = 'Smith', AccountId = acc.Id);
        insert con;
        
        List<Id> fixedResults = new List<Id>{acc.Id, con.Id};
        Test.setFixedSearchResults(fixedResults);
        
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Account(Name), Contact(FirstName, LastName)
        ];
        
        System.assertEquals(1, results[0].size(), 'Should find 1 account');
        System.assertEquals(1, results[1].size(), 'Should find 1 contact');
    }
    
    @isTest
    static void testEmptySearchResults() {
        List<Id> fixedResults = new List<Id>();
        Test.setFixedSearchResults(fixedResults);
        
        List<List<sObject>> results = [FIND 'NonExistent' RETURNING Account];
        
        System.assert(results[0].isEmpty(), 'Should return empty results');
    }
    
    @isTest
    static void testDynamicSOSL() {
        Account acc = new Account(Name = 'Dynamic Test');
        insert acc;
        
        Test.setFixedSearchResults(new List<Id>{acc.Id});
        
        String query = 'FIND \'Test\' RETURNING Account(Name)';
        List<List<sObject>> results = Search.query(query);
        
        System.assertEquals(1, results[0].size());
    }
    
    @isTest
    static void testSearchWithFilters() {
        Account acc = new Account(Name = 'Tech Corp', Industry = 'Technology');
        insert acc;
        
        Test.setFixedSearchResults(new List<Id>{acc.Id});
        
        List<List<sObject>> results = [
            FIND 'Tech'
            RETURNING Account(Name, Industry WHERE Industry = 'Technology')
        ];
        
        System.assertEquals(1, results[0].size());
        Account found = (Account)results[0][0];
        System.assertEquals('Technology', found.Industry);
    }
}

/**
 * IMPORTANT TESTING NOTES:
 * - Test.setFixedSearchResults() must be called BEFORE SOSL query
 * - Only IDs of records that exist in test context can be returned
 * - The method controls what SOSL will find
 * - All SOSL queries in test context require fixed results
 * - Call Test.setFixedSearchResults() once per test method
 */
