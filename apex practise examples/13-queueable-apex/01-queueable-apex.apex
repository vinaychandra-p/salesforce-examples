/**
 * 13 - QUEUEABLE APEX - Comprehensive Queueable Examples
 * Queueable interface, chaining, state management
 */

// ========== BASIC QUEUEABLE ==========
public class BasicQueueable implements Queueable {
    
    public void execute(QueueableContext context) {
        // Process logic here
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 100];
        
        for (Account acc : accounts) {
            acc.Description = 'Updated by queueable';
        }
        
        update accounts;
        
        System.debug('Job ID: ' + context.getJobId());
    }
}

// Execute: System.enqueueJob(new BasicQueueable());

// ========== QUEUEABLE WITH PARAMETERS ==========
public class QueueableWithParams implements Queueable {
    
    private List<Id> accountIds;
    private String status;
    
    // Constructor with parameters
    public QueueableWithParams(List<Id> ids, String newStatus) {
        this.accountIds = ids;
        this.status = newStatus;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accounts = [
            SELECT Id, Status__c
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : accounts) {
            acc.Status__c = status;
        }
        
        update accounts;
    }
}

// Execute: System.enqueueJob(new QueueableWithParams(accountIds, 'Active'));

// ========== QUEUEABLE CHAINING ==========
public class FirstQueueable implements Queueable {
    
    public void execute(QueueableContext context) {
        // First job work
        List<Account> accounts = [SELECT Id FROM Account LIMIT 100];
        // Process accounts...
        
        // Chain to next job
        System.enqueueJob(new SecondQueueable());
    }
}

public class SecondQueueable implements Queueable {
    
    public void execute(QueueableContext context) {
        // Second job work
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 100];
        // Process contacts...
        
        System.debug('Chained job completed');
    }
}

// ========== QUEUEABLE WITH CALLOUTS ==========
public class QueueableWithCallout implements Queueable, Database.AllowsCallouts {
    
    private String endpoint;
    
    public QueueableWithCallout(String url) {
        this.endpoint = url;
    }
    
    public void execute(QueueableContext context) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            System.debug('Response: ' + res.getBody());
            // Process response
        }
    }
}

// Execute: System.enqueueJob(new QueueableWithCallout('https://api.example.com/data'));

// ========== COMPLEX QUEUEABLE WITH STATE ==========
public class ComplexQueueable implements Queueable {
    
    private Integer batchNumber;
    private Integer totalBatches;
    private List<Id> remainingIds;
    
    public ComplexQueueable(Integer batch, Integer total, List<Id> ids) {
        this.batchNumber = batch;
        this.totalBatches = total;
        this.remainingIds = ids;
    }
    
    public void execute(QueueableContext context) {
        System.debug('Processing batch ' + batchNumber + ' of ' + totalBatches);
        
        // Process subset of IDs
        Integer batchSize = 100;
        Integer startIndex = (batchNumber - 1) * batchSize;
        Integer endIndex = Math.min(startIndex + batchSize, remainingIds.size());
        
        List<Id> currentBatch = new List<Id>();
        for (Integer i = startIndex; i < endIndex; i++) {
            currentBatch.add(remainingIds[i]);
        }
        
        // Process current batch
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id IN :currentBatch
        ];
        
        for (Account acc : accounts) {
            acc.Description = 'Batch ' + batchNumber;
        }
        update accounts;
        
        // Chain to next batch if more remain
        if (batchNumber < totalBatches) {
            System.enqueueJob(new ComplexQueueable(
                batchNumber + 1,
                totalBatches,
                remainingIds
            ));
        } else {
            System.debug('All batches completed');
        }
    }
}

// ========== QUEUEABLE ERROR HANDLING ==========
public class QueueableWithErrorHandling implements Queueable {
    
    public void execute(QueueableContext context) {
        try {
            List<Account> accounts = [SELECT Id FROM Account];
            
            for (Account acc : accounts) {
                acc.Name = null;  // Will cause error
            }
            
            update accounts;
            
        } catch (DMLException e) {
            // Log error
            System.debug('DML Error: ' + e.getMessage());
            
            // Create error log record
            Error_Log__c log = new Error_Log__c(
                JobId__c = String.valueOf(context.getJobId()),
                ErrorMessage__c = e.getMessage(),
                StackTrace__c = e.getStackTraceString()
            );
            insert log;
            
            // Don't chain if error
            return;
        }
        
        // Chain to next job on success
        System.enqueueJob(new NextQueueable());
    }
}

// ========== DYNAMIC QUEUEABLE ==========
public class DynamicQueueable implements Queueable {
    
    private String objectName;
    private Map<String, Object> fieldsToUpdate;
    
    public DynamicQueueable(String obj, Map<String, Object> fields) {
        this.objectName = obj;
        this.fieldsToUpdate = fields;
    }
    
    public void execute(QueueableContext context) {
        // Dynamic SOQL
        String query = 'SELECT Id FROM ' + objectName + ' LIMIT 100';
        List<sObject> records = Database.query(query);
        
        // Dynamic update
        for (sObject record : records) {
            for (String field : fieldsToUpdate.keySet()) {
                record.put(field, fieldsToUpdate.get(field));
            }
        }
        
        update records;
    }
}

// Execute:
// Map<String, Object> fields = new Map<String, Object>{'Description' => 'Updated'};
// System.enqueueJob(new DynamicQueueable('Account', fields));

// ========== QUEUEABLE VS FUTURE ==========

// FUTURE METHOD (Old way)
public class FutureExample {
    @future
    public static void updateAccountsFuture(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
        // Process...
        update accounts;
    }
}

// QUEUEABLE (Better approach)
public class QueueableExample implements Queueable {
    private Set<Id> accountIds;
    
    public QueueableExample(Set<Id> ids) {
        this.accountIds = ids;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
        // Process...
        update accounts;
        
        // Can chain
        // Can pass complex objects
        // Can get job ID
    }
}

// ========== QUEUEABLE BEST PRACTICES ==========
public class QueueableBestPractices implements Queueable, Database.AllowsCallouts {
    
    private List<Id> recordIds;
    private Integer retryCount;
    private static final Integer MAX_RETRIES = 3;
    
    public QueueableBestPractices(List<Id> ids) {
        this(ids, 0);
    }
    
    public QueueableBestPractices(List<Id> ids, Integer retries) {
        this.recordIds = ids;
        this.retryCount = retries;
    }
    
    public void execute(QueueableContext context) {
        try {
            // Check limits before processing
            if (Limits.getQueueableJobs() >= Limits.getLimitQueueableJobs()) {
                System.debug('Queue limit reached');
                return;
            }
            
            // Process in chunks
            Integer chunkSize = 100;
            List<Id> chunk = new List<Id>();
            
            for (Integer i = 0; i < Math.min(chunkSize, recordIds.size()); i++) {
                chunk.add(recordIds[i]);
            }
            
            // Process chunk
            List<Account> accounts = [
                SELECT Id, Name, Industry
                FROM Account
                WHERE Id IN :chunk
            ];
            
            for (Account acc : accounts) {
                acc.Description = 'Processed at ' + DateTime.now();
            }
            
            Database.SaveResult[] results = Database.update(accounts, false);
            
            // Handle partial success
            Boolean hasErrors = false;
            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    hasErrors = true;
                    System.debug('Error: ' + result.getErrors());
                }
            }
            
            // Retry on error
            if (hasErrors && retryCount < MAX_RETRIES) {
                System.enqueueJob(new QueueableBestPractices(
                    recordIds,
                    retryCount + 1
                ));
                return;
            }
            
            // Process remaining records
            recordIds.remove(0, chunkSize);
            if (!recordIds.isEmpty()) {
                System.enqueueJob(new QueueableBestPractices(recordIds, 0));
            }
            
        } catch (Exception e) {
            System.debug('Queueable error: ' + e.getMessage());
            
            // Retry or log
            if (retryCount < MAX_RETRIES) {
                System.enqueueJob(new QueueableBestPractices(
                    recordIds,
                    retryCount + 1
                ));
            }
        }
    }
}

// ========== TESTING QUEUEABLE ==========
@isTest
private class QueueableTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(Name = 'Test ' + i));
        }
        insert accounts;
    }
    
    @isTest
    static void testQueueable() {
        Test.startTest();
        System.enqueueJob(new BasicQueueable());
        Test.stopTest();  // Queueable completes here
        
        // Verify results
        List<Account> accounts = [SELECT Description FROM Account];
        for (Account acc : accounts) {
            System.assertNotEquals(null, acc.Description);
        }
    }
    
    @isTest
    static void testQueueableWithParams() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 10];
        List<Id> ids = new List<Id>();
        for (Account acc : accounts) {
            ids.add(acc.Id);
        }
        
        Test.startTest();
        System.enqueueJob(new QueueableWithParams(ids, 'Active'));
        Test.stopTest();
        
        // Verify
    }
    
    @isTest
    static void testQueueableChaining() {
        Test.startTest();
        Id jobId = System.enqueueJob(new FirstQueueable());
        Test.stopTest();
        
        System.assertNotEquals(null, jobId);
    }
}

/* QUEUEABLE LIMITS:
- Max 50 queueable jobs per transaction (synchronous)
- Max 1 queueable can be chained per execute
- No limit on depth of chaining
- Shares heap size with future/batch
- Can monitor via AsyncApexJob

ADVANTAGES OVER @FUTURE:
- Can chain jobs
- Can pass non-primitive types
- Can track job ID
- Can use with callouts
- Better error handling
*/

/* EXECUTION:
Id jobId = System.enqueueJob(new BasicQueueable());

// Check status
AsyncApexJob job = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId];

// Cannot abort queueable directly
*/
