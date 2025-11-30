/**
 * 12 - BATCH APEX - Comprehensive Batch Processing Examples
 * Database.Batchable, chunking, state management, error handling
 */

// ========== BASIC BATCH CLASS ==========
public class BasicBatchExample implements Database.Batchable<sObject> {
    
    // 1. START METHOD - Define query
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Returns up to 50 million records
        return Database.getQueryLocator([
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry = 'Technology'
        ]);
    }
    
    // 2. EXECUTE METHOD - Process each batch
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // scope contains 200 records by default
        for (Account acc : scope) {
            acc.Description = 'Processed on ' + DateTime.now();
        }
        update scope;
    }
    
    // 3. FINISH METHOD - Post-processing
    public void finish(Database.BatchableContext bc) {
        // Get job info
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                   TotalJobItems, CreatedDate, CompletedDate
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()
        ];
        
        // Send email notification
        System.debug('Job completed: ' + job.Status);
        System.debug('Records processed: ' + job.TotalJobItems);
        System.debug('Errors: ' + job.NumberOfErrors);
    }
}

// Execute: Database.executeBatch(new BasicBatchExample(), 200);

// ========== BATCH WITH ITERABLE ==========
public class IterableBatchExample implements Database.Batchable<Integer> {
    
    // Use Iterable instead of QueryLocator for custom logic
    public Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> numbers = new List<Integer>();
        for (Integer i = 1; i <= 1000; i++) {
            numbers.add(i);
        }
        return numbers;
    }
    
    public void execute(Database.BatchableContext bc, List<Integer> scope) {
        // Process custom iterable
        for (Integer num : scope) {
            System.debug('Processing number: ' + num);
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Iterable batch completed');
    }
}

// ========== STATEFUL BATCH ==========
public class StatefulBatchExample implements Database.Batchable<sObject>, Database.Stateful {
    
    // Maintain state across batches
    public Integer recordsProcessed = 0;
    public Integer recordsFailed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, AnnualRevenue
            FROM Account
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : scope) {
            try {
                acc.Description = 'Revenue: ' + acc.AnnualRevenue;
                accountsToUpdate.add(acc);
                recordsProcessed++;
            } catch (Exception e) {
                recordsFailed++;
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Total records processed: ' + recordsProcessed);
        System.debug('Total records failed: ' + recordsFailed);
        
        // Send summary email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{'admin@example.com'});
        email.setSubject('Batch Job Summary');
        email.setPlainTextBody(
            'Processed: ' + recordsProcessed + '\n' +
            'Failed: ' + recordsFailed
        );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}

// ========== BATCH ERROR HANDLING ==========
public class BatchErrorHandling implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Use Database methods for partial success
        List<Database.SaveResult> results = Database.update(scope, false);
        
        // Handle errors
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                for (Database.Error error : results[i].getErrors()) {
                    System.debug('Error on record ' + scope[i].Id + ': ' + error.getMessage());
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch completed');
    }
}

// ========== DYNAMIC BATCH ==========
public class DynamicBatch implements Database.Batchable<sObject> {
    
    private String objectName;
    private String fieldName;
    private String fieldValue;
    
    public DynamicBatch(String obj, String field, String value) {
        this.objectName = obj;
        this.fieldName = field;
        this.fieldValue = value;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name FROM ' + objectName + 
                      ' WHERE ' + fieldName + ' = \'' + fieldValue + '\'';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        // Process dynamically
        for (sObject obj : scope) {
            obj.put('Description', 'Updated by batch');
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Dynamic batch completed');
    }
}

// Execute: Database.executeBatch(new DynamicBatch('Account', 'Industry', 'Technology'));

// ========== BATCH CHAINING ==========
public class FirstBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Process accounts
    }
    
    public void finish(Database.BatchableContext bc) {
        // Chain to next batch
        Database.executeBatch(new SecondBatch());
    }
}

public class SecondBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Contact]);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        // Process contacts
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('All batches completed');
    }
}

// ========== BATCH WITH SCOPE SIZE ==========
public class CustomScopeBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        System.debug('Batch size: ' + scope.size());
        // Process records
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Completed');
    }
}

// Execute with custom scope size (1-2000)
// Database.executeBatch(new CustomScopeBatch(), 50);

// ========== SCHEDULABLE BATCH ==========
public class SchedulableBatchExample implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Execute batch from scheduled job
        Database.executeBatch(new BasicBatchExample(), 200);
    }
}

// Schedule: System.schedule('Daily Batch', '0 0 2 * * ?', new SchedulableBatchExample());

// ========== BATCH BEST PRACTICES ==========
public class BatchBestPractices implements Database.Batchable<sObject>, Database.Stateful {
    
    // Use Database.Stateful to maintain state
    private Integer totalRecords = 0;
    private List<String> errorMessages = new List<String>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Selective query - only necessary fields
        return Database.getQueryLocator([
            SELECT Id, Name, Industry, AnnualRevenue
            FROM Account
            WHERE Industry != null
            ORDER BY CreatedDate
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> toUpdate = new List<Account>();
        
        // Process efficiently
        for (Account acc : scope) {
            try {
                // Business logic
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                    toUpdate.add(acc);
                }
                totalRecords++;
            } catch (Exception e) {
                errorMessages.add('Error on ' + acc.Id + ': ' + e.getMessage());
            }
        }
        
        // Bulk DML
        if (!toUpdate.isEmpty()) {
            Database.SaveResult[] results = Database.update(toUpdate, false);
            
            // Handle partial success
            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    errorMessages.add('Update failed: ' + toUpdate[i].Id);
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Get job details
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                   TotalJobItems, CreatedDate, CompletedDate
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()
        ];
        
        // Log summary
        System.debug('=== BATCH SUMMARY ===');
        System.debug('Total Records: ' + totalRecords);
        System.debug('Batches: ' + job.TotalJobItems);
        System.debug('Errors: ' + job.NumberOfErrors);
        System.debug('Status: ' + job.Status);
        
        // Send notification if errors
        if (!errorMessages.isEmpty()) {
            // Send email with errors
        }
        
        // Chain next batch if needed
        // Database.executeBatch(new NextBatch());
    }
}

// ========== TESTING BATCH APEX ==========
@isTest
private class BatchApexTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(
                Name = 'Test ' + i,
                Industry = 'Technology'
            ));
        }
        insert accounts;
    }
    
    @isTest
    static void testBatch() {
        Test.startTest();
        Database.executeBatch(new BasicBatchExample());
        Test.stopTest();  // Batch completes here
        
        // Verify results
        List<Account> accounts = [SELECT Description FROM Account];
        for (Account acc : accounts) {
            System.assertNotEquals(null, acc.Description);
        }
    }
    
    @isTest
    static void testBatchWithScope() {
        Test.startTest();
        Database.executeBatch(new BasicBatchExample(), 50);
        Test.stopTest();
        
        // Verify
    }
}

/* BATCH APEX LIMITS:
- Max 5 batch jobs queued or active per org
- Max scope size: 2000 records
- Default scope size: 200 records
- QueryLocator: 50 million records
- Iterable: 50,000 records
- Max 250,000 records per batch transaction
*/

/* EXECUTION:
Id batchJobId = Database.executeBatch(new BasicBatchExample());
Id batchJobId = Database.executeBatch(new BasicBatchExample(), 100); // custom scope

// Check status
AsyncApexJob job = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :batchJobId];

// Abort
System.abortJob(batchJobId);
*/
