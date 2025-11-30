/**
 * 17 - TESTING - Comprehensive Test Examples
 * Test classes, assertions, test data, mocking, best practices
 */

// ========== BASIC TEST CLASS ==========
@isTest
private class BasicTestExample {
    
    @isTest
    static void testAccountCreation() {
        // Test data setup
        Account acc = new Account(Name='Test Account', Industry='Technology');
        
        // Start test context
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, acc.Id, 'Account should have been inserted');
        
        Account insertedAcc = [SELECT Id, Name, Industry FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Test Account', insertedAcc.Name, 'Name should match');
        System.assertEquals('Technology', insertedAcc.Industry, 'Industry should match');
    }
}

// ========== TEST DATA SETUP ==========
@isTest
private class TestDataSetupExample {
    
    // @testSetup runs once for all test methods
    @testSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Technology',
                AnnualRevenue = 100000 * i
            ));
        }
        insert accounts;
        
        // Create related contacts
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = acc.Id,
                Email = 'test@example.com'
            ));
        }
        insert contacts;
    }
    
    @isTest
    static void testWithSetupData() {
        // Data from @testSetup is available
        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(10, accounts.size(), 'Should have 10 accounts');
        
        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(10, contacts.size(), 'Should have 10 contacts');
    }
}

// ========== ASSERTIONS ==========
@isTest
private class AssertionExamples {
    
    @isTest
    static void testAssertions() {
        // assertEquals
        Integer expected = 10;
        Integer actual = 5 + 5;
        System.assertEquals(expected, actual, 'Values should be equal');
        
        // assertNotEquals
        System.assertNotEquals(5, actual, 'Should not equal 5');
        
        // assert (assertTrue)
        Boolean condition = true;
        System.assert(condition, 'Condition should be true');
        
        // Assert collections
        List<String> items = new List<String>{'A', 'B', 'C'};
        System.assertEquals(3, items.size(), 'Should have 3 items');
        System.assert(items.contains('B'), 'Should contain B');
    }
    
    @isTest
    static void testNullAssertions() {
        String str = null;
        System.assertEquals(null, str, 'Should be null');
        
        Account acc = new Account(Name='Test');
        System.assertNotEquals(null, acc, 'Account should not be null');
    }
}

// ========== TEST.STARTTEST() AND TEST.STOPTEST() ==========
@isTest
private class TestContextExample {
    
    @isTest
    static void testGovernorLimits() {
        // Before Test.startTest()
        System.debug('SOQL before: ' + Limits.getQueries());
        
        // Reset governor limits
        Test.startTest();
        
        // This gets new governor limits
        for (Integer i = 0; i < 100; i++) {
            Account acc = new Account(Name='Test ' + i);
            insert acc;
        }
        
        System.debug('SOQL during: ' + Limits.getQueries());
        
        // Forces async operations to complete
        Test.stopTest();
        
        // Verify results
        Integer accountCount = [SELECT COUNT() FROM Account];
        System.assertEquals(100, accountCount);
    }
    
    @isTest
    static void testBatch() {
        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name='Batch Test ' + i));
        }
        insert accounts;
        
        Test.startTest();
        // Execute batch
        Database.executeBatch(new MyBatchClass(), 200);
        Test.stopTest();  // Batch completes here
        
        // Verify batch results
    }
}

// ========== TESTING DML OPERATIONS ==========
@isTest
private class DMLTestExamples {
    
    @isTest
    static void testInsert() {
        Account acc = new Account(Name='Test Account');
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        System.assertNotEquals(null, acc.Id);
        
        Account queriedAcc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Test Account', queriedAcc.Name);
    }
    
    @isTest
    static void testUpdate() {
        Account acc = new Account(Name='Original Name');
        insert acc;
        
        Test.startTest();
        acc.Name = 'Updated Name';
        update acc;
        Test.stopTest();
        
        Account updatedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated Name', updatedAcc.Name);
    }
    
    @isTest
    static void testDelete() {
        Account acc = new Account(Name='To Delete');
        insert acc;
        Id accId = acc.Id;
        
        Test.startTest();
        delete acc;
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accId];
        System.assertEquals(0, accounts.size(), 'Account should be deleted');
    }
    
    @isTest
    static void testBulkDML() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name='Bulk Test ' + i));
        }
        
        Test.startTest();
        insert accounts;
        Test.stopTest();
        
        System.assertEquals(200, accounts.size());
        for (Account acc : accounts) {
            System.assertNotEquals(null, acc.Id);
        }
    }
}

// ========== TESTING SOQL QUERIES ==========
@isTest
private class SOQLTestExamples {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Tech Corp', Industry='Technology'));
        accounts.add(new Account(Name='Finance Inc', Industry='Finance'));
        accounts.add(new Account(Name='Health Co', Industry='Healthcare'));
        insert accounts;
    }
    
    @isTest
    static void testQueryByIndustry() {
        Test.startTest();
        List<Account> techAccounts = [
            SELECT Id, Name
            FROM Account
            WHERE Industry = 'Technology'
        ];
        Test.stopTest();
        
        System.assertEquals(1, techAccounts.size());
        System.assertEquals('Tech Corp', techAccounts[0].Name);
    }
    
    @isTest
    static void testQueryWithRelationship() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = new Contact(
            FirstName='John',
            LastName='Doe',
            AccountId=acc.Id
        );
        insert con;
        
        Test.startTest();
        List<Account> accountsWithContacts = [
            SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts)
            FROM Account
            WHERE Id = :acc.Id
        ];
        Test.stopTest();
        
        System.assertEquals(1, accountsWithContacts.size());
        System.assertEquals(1, accountsWithContacts[0].Contacts.size());
        System.assertEquals('John', accountsWithContacts[0].Contacts[0].FirstName);
    }
}

// ========== TESTING TRIGGERS ==========
@isTest
private class TriggerTestExamples {
    
    @isTest
    static void testAccountTriggerBeforeInsert() {
        Account acc = new Account(Name='Test Account');
        // Don't set Rating - trigger should set default
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        Account insertedAcc = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Cold', insertedAcc.Rating, 'Trigger should set default rating');
    }
    
    @isTest
    static void testAccountTriggerAfterUpdate() {
        Account acc = new Account(Name='Test', AnnualRevenue=100000);
        insert acc;
        
        Test.startTest();
        acc.AnnualRevenue = 200000;
        update acc;
        Test.stopTest();
        
        Account updatedAcc = [SELECT Description FROM Account WHERE Id = :acc.Id];
        System.assert(updatedAcc.Description.contains('Revenue changed'));
    }
    
    @isTest
    static void testBulkTrigger() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name='Bulk Test ' + i));
        }
        
        Test.startTest();
        insert accounts;
        Test.stopTest();
        
        // Verify trigger processed all records
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :accounts];
        System.assertEquals(200, contacts.size(), 'Should create one contact per account');
    }
}

// ========== TESTING EXCEPTIONS ==========
@isTest
private class ExceptionTestExamples {
    
    @isTest
    static void testValidationException() {
        Account acc = new Account();  // Missing required Name
        
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            insert acc;
            Test.stopTest();
        } catch (DMLException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
        }
        
        System.assert(exceptionThrown, 'Should have thrown DMLException');
    }
    
    @isTest
    static void testCustomException() {
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            throw new ValidationException('Test error');
            Test.stopTest();
        } catch (ValidationException e) {
            exceptionThrown = true;
            System.assertEquals('Test error', e.getMessage());
        }
        
        System.assert(exceptionThrown);
    }
}

// ========== TESTING ASYNC APEX ==========
@isTest
private class AsyncTestExamples {
    
    @isTest
    static void testFutureMethod() {
        Account acc = new Account(Name='Future Test');
        insert acc;
        
        Test.startTest();
        MyClass.updateAccountAsync(acc.Id);
        Test.stopTest();  // Future method completes here
        
        Account updatedAcc = [SELECT Description FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated by future', updatedAcc.Description);
    }
    
    @isTest
    static void testQueueable() {
        Test.startTest();
        System.enqueueJob(new MyQueueableClass());
        Test.stopTest();  // Queueable completes here
        
        // Verify queueable results
    }
    
    @isTest
    static void testBatchApex() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name='Batch Test ' + i));
        }
        insert accounts;
        
        Test.startTest();
        Database.executeBatch(new MyBatchClass());
        Test.stopTest();  // Batch completes here
        
        // Verify batch processed all records
    }
    
    @isTest
    static void testScheduledApex() {
        String cronExp = '0 0 0 * * ?';  // Daily at midnight
        
        Test.startTest();
        String jobId = System.schedule('Test Job', cronExp, new MyScheduledClass());
        Test.stopTest();
        
        System.assertNotEquals(null, jobId);
    }
}

// ========== TEST DATA FACTORY ==========
@isTest
public class TestDataFactory {
    
    public static Account createAccount(String name) {
        return new Account(
            Name = name,
            Industry = 'Technology',
            AnnualRevenue = 1000000
        );
    }
    
    public static List<Account> createAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(createAccount('Test Account ' + i));
        }
        return accounts;
    }
    
    public static Contact createContact(Id accountId) {
        return new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = accountId,
            Email = 'test@example.com'
        );
    }
    
    public static Opportunity createOpportunity(Id accountId) {
        return new Opportunity(
            Name = 'Test Opportunity',
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 100000
        );
    }
}

// Usage
@isTest
private class TestDataFactoryUsage {
    
    @isTest
    static void testUsingFactory() {
        // Create test data using factory
        Account acc = TestDataFactory.createAccount('Test');
        insert acc;
        
        Contact con = TestDataFactory.createContact(acc.Id);
        insert con;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        insert opp;
        
        // Assertions
        System.assertNotEquals(null, acc.Id);
        System.assertNotEquals(null, con.Id);
        System.assertNotEquals(null, opp.Id);
    }
}

// ========== TESTING BEST PRACTICES ==========
@isTest
private class TestBestPractices {
    
    // ALWAYS use @isTest annotation
    // DON'T use @isTest(SeeAllData=true) - creates dependencies
    
    @isTest
    static void testPositiveCase() {
        // Test the happy path
        Account acc = new Account(Name='Valid Account');
        insert acc;
        System.assertNotEquals(null, acc.Id);
    }
    
    @isTest
    static void testNegativeCase() {
        // Test error conditions
        Account acc = new Account();  // Missing Name
        Boolean failed = false;
        try {
            insert acc;
        } catch (DMLException e) {
            failed = true;
        }
        System.assert(failed, 'Should have failed');
    }
    
    @isTest
    static void testBulkOperation() {
        // Always test with 200+ records
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name='Bulk ' + i));
        }
        insert accounts;
        System.assertEquals(200, accounts.size());
    }
    
    @isTest
    static void testWithProperAssertions() {
        Account acc = new Account(Name='Test');
        insert acc;
        
        // GOOD: Specific assertion with message
        System.assertNotEquals(null, acc.Id, 'Account should be inserted');
        
        // BAD: No assertion
        // insert acc;  // Don't do this!
    }
}

/* COVERAGE REQUIREMENTS:
- 75% code coverage required for deployment
- 100% for triggers is best practice
- Test all scenarios: positive, negative, bulk, edge cases
- Use Test.startTest() and Test.stopTest() for governor limit reset
- @testSetup for common test data
- Never use SeeAllData=true
*/
