/**
 * 15 - FUTURE METHODS - Comprehensive Async Patterns
 * @future annotation, callouts, best practices
 */

// ========== BASIC FUTURE METHOD ==========
public class BasicFutureExample {
    
    @future
    public static void updateAccountsAsync(Set<Id> accountIds) {
        List<Account> accounts = [
            SELECT Id, Name, Description
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : accounts) {
            acc.Description = 'Updated async on ' + DateTime.now();
        }
        
        update accounts;
    }
}

// Call: BasicFutureExample.updateAccountsAsync(accountIdSet);

// ========== FUTURE WITH CALLOUT ==========
public class FutureCalloutExample {
    
    @future(callout=true)
    public static void makeHttpCallout(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String body = res.getBody();
            System.debug('Response: ' + body);
            
            // Process response and update SF records
            processAPIResponse(body);
        } else {
            System.debug('Error: ' + res.getStatusCode());
        }
    }
    
    private static void processAPIResponse(String jsonBody) {
        // Parse JSON and update records
    }
}

// ========== FUTURE METHOD LIMITATIONS ==========
public class FutureLimitations {
    
    // ❌ CANNOT pass sObjects
    /*
    @future
    public static void processAccount(Account acc) {  // WRONG!
        update acc;
    }
    */
    
    // ✅ MUST pass primitives or collections
    @future
    public static void processAccount(Id accountId) {  // CORRECT
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        acc.Description = 'Updated';
        update acc;
    }
    
    // ✅ Can pass Set or List of primitives
    @future
    public static void processAccounts(Set<Id> ids, List<String> statuses) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :ids];
        // Process...
    }
    
    // ❌ CANNOT call future from future
    @future
    public static void method1() {
        // method2();  // WRONG! Cannot call future from future
    }
    
    @future
    public static void method2() {
        // Logic
    }
    
    // ❌ MUST be static
    /*
    @future
    public void instanceMethod() {  // WRONG!
    }
    */
}

// ========== FUTURE VS QUEUEABLE ==========
public class FutureVsQueueable {
    
    // OLD WAY: Future method
    @future
    public static void updateRecordsFuture(Set<Id> ids) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :ids];
        update accounts;
        
        // Cannot chain
        // Cannot pass complex objects
        // Cannot get job ID
    }
    
    // BETTER: Queueable
    public class UpdateRecordsQueueable implements Queueable {
        private Set<Id> ids;
        
        public UpdateRecordsQueueable(Set<Id> accountIds) {
            this.ids = accountIds;
        }
        
        public void execute(QueueableContext context) {
            List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :ids];
            update accounts;
            
            // Can chain
            // Can pass complex objects
            // Can get job ID: context.getJobId()
        }
    }
}

// ========== FUTURE METHOD PATTERNS ==========
public class FutureMethodPatterns {
    
    // Pattern 1: Async DML
    @future
    public static void updateRecordsAsync(Set<Id> recordIds) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :recordIds];
        
        for (Account acc : accounts) {
            acc.Description = 'Updated';
        }
        
        update accounts;
    }
    
    // Pattern 2: External callout
    @future(callout=true)
    public static void syncWithExternalSystem(String recordId, String data) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/sync');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(data);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Update record with response
    }
    
    // Pattern 3: Heavy computation
    @future
    public static void performComplexCalculation(Set<Id> accountIds) {
        List<Account> accounts = [
            SELECT Id, (SELECT Amount FROM Opportunities)
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : accounts) {
            Decimal total = 0;
            for (Opportunity opp : acc.Opportunities) {
                total += opp.Amount;
            }
            acc.AnnualRevenue = total;
        }
        
        update accounts;
    }
    
    // Pattern 4: Trigger async processing
    @future
    public static void processAfterTrigger(Set<Id> newIds) {
        // Heavy processing that shouldn't block trigger
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :newIds];
        
        // Complex logic...
        
        update accounts;
    }
}

// ========== FUTURE WITH WEB SERVICE ==========
public class FutureWebService {
    
    @future(callout=true)
    public static void callSoapService(String accountId) {
        // SOAP callout
        String soapRequest = 
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '  <soap:Body>' +
            '    <GetAccount>' +
            '      <AccountId>' + accountId + '</AccountId>' +
            '    </GetAccount>' +
            '  </soap:Body>' +
            '</soap:Envelope>';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/soap');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setBody(soapRequest);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Parse SOAP response
            Dom.Document doc = res.getBodyDocument();
            // Process XML
        }
    }
    
    @future(callout=true)
    public static void callRestService(String recordId) {
        // REST callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts/' + recordId);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + getAccessToken());
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> data = 
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            // Update Salesforce records
        }
    }
    
    private static String getAccessToken() {
        // Get OAuth token
        return 'your-token';
    }
}

// ========== FUTURE ERROR HANDLING ==========
public class FutureErrorHandling {
    
    @future
    public static void processWithErrorHandling(Set<Id> recordIds) {
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        
        try {
            List<Account> accounts = [
                SELECT Id, Name
                FROM Account
                WHERE Id IN :recordIds
            ];
            
            Database.SaveResult[] results = Database.update(accounts, false);
            
            // Handle partial success
            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    for (Database.Error error : results[i].getErrors()) {
                        errorLogs.add(new Error_Log__c(
                            RecordId__c = accounts[i].Id,
                            ErrorMessage__c = error.getMessage(),
                            ErrorType__c = 'DML'
                        ));
                    }
                }
            }
            
        } catch (Exception e) {
            errorLogs.add(new Error_Log__c(
                ErrorMessage__c = e.getMessage(),
                StackTrace__c = e.getStackTraceString(),
                ErrorType__c = 'Exception'
            ));
        }
        
        if (!errorLogs.isEmpty()) {
            insert errorLogs;
        }
    }
}

// ========== TRIGGER WITH FUTURE ==========
public class AccountTriggerHandler {
    
    public static void afterInsert(List<Account> newAccounts) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : newAccounts) {
            if (acc.Industry == 'Technology') {
                accountIds.add(acc.Id);
            }
        }
        
        if (!accountIds.isEmpty()) {
            // Async processing to avoid limits
            FutureMethods.processNewAccounts(accountIds);
        }
    }
}

public class FutureMethods {
    
    @future
    public static void processNewAccounts(Set<Id> accountIds) {
        List<Account> accounts = [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (Account acc : accounts) {
            contactsToCreate.add(new Contact(
                FirstName = 'Default',
                LastName = 'Contact',
                AccountId = acc.Id
            ));
        }
        
        insert contactsToCreate;
    }
}

// ========== TESTING FUTURE METHODS ==========
@isTest
private class FutureMethodTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = 'Test ' + i));
        }
        insert accounts;
    }
    
    @isTest
    static void testFutureMethod() {
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        BasicFutureExample.updateAccountsAsync(accountIds);
        Test.stopTest();  // Future method completes here
        
        // Verify results
        List<Account> updatedAccounts = [
            SELECT Id, Description
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Description);
        }
    }
    
    @isTest
    static void testFutureCallout() {
        // Set mock for HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        FutureCalloutExample.makeHttpCallout('https://api.example.com/test');
        Test.stopTest();
        
        // Verify
    }
}

// Mock for testing
@isTest
global class MockHttpResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(200);
        return res;
    }
}

/* FUTURE METHOD LIMITS:
- Max 50 future calls per transaction
- Cannot call future from future
- Must be static
- Can only pass primitives or collections of primitives
- Shares heap size with other async jobs

WHEN TO USE FUTURE:
- Simple async operations
- HTTP callouts
- Mixed DML operations (setup vs non-setup objects)
- Avoiding "future method cannot be called from future" errors

WHEN TO USE QUEUEABLE INSTEAD:
- Need to chain jobs
- Need to pass complex objects
- Need job monitoring
- More than basic async needs

EXECUTION:
- Runs when resources available
- No guaranteed execution time
- Cannot be scheduled directly
*/

/* MIXED DML EXAMPLE:
@future
public static void createUserAsync(Id contactId) {
    // Can do setup object DML (User) separate from trigger
    Contact con = [SELECT FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
    
    User newUser = new User(
        FirstName = con.FirstName,
        LastName = con.LastName,
        Email = con.Email,
        // ... other required fields
    );
    
    insert newUser;
}
*/
