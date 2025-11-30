/**
 * 18 - GOVERNOR LIMITS - Comprehensive Limits Guide
 * Understanding, tracking, and optimizing against Salesforce limits
 */

// ========== UNDERSTANDING LIMITS ==========
public class LimitsOverview {
    
    public static void displayCurrentLimits() {
        System.debug('=== GOVERNOR LIMITS ===');
        
        // SOQL Queries
        System.debug('SOQL Queries: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
        
        // DML Statements
        System.debug('DML Statements: ' + Limits.getDmlStatements() + ' / ' + Limits.getLimitDmlStatements());
        
        // DML Rows
        System.debug('DML Rows: ' + Limits.getDmlRows() + ' / ' + Limits.getLimitDmlRows());
        
        // CPU Time
        System.debug('CPU Time: ' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime());
        
        // Heap Size
        System.debug('Heap Size: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
        
        // Callouts
        System.debug('Callouts: ' + Limits.getCallouts() + ' / ' + Limits.getLimitCallouts());
        
        // Email Invocations
        System.debug('Emails: ' + Limits.getEmailInvocations() + ' / ' + Limits.getLimitEmailInvocations());
        
        // Future Calls
        System.debug('Future Calls: ' + Limits.getFutureCalls() + ' / ' + Limits.getLimitFutureCalls());
        
        // Queueable Jobs
        System.debug('Queueable Jobs: ' + Limits.getQueueableJobs() + ' / ' + Limits.getLimitQueueableJobs());
    }
}

/* KEY LIMITS (Synchronous):
- SOQL Queries: 100
- SOQL Query Rows: 50,000
- DML Statements: 150
- DML Rows: 10,000
- CPU Time: 10,000ms (10 seconds)
- Heap Size: 6 MB
- Callouts: 100
- Callout Time: 120 seconds total
- Email Invocations: 10
- Future Calls: 50
- Queueable Jobs: 50
*/

/* KEY LIMITS (Asynchronous - Future, Batch, Queueable):
- SOQL Queries: 200
- SOQL Query Rows: 50,000
- DML Statements: 150
- DML Rows: 10,000
- CPU Time: 60,000ms (60 seconds)
- Heap Size: 12 MB
- Callouts: 100
*/

// ========== SOQL LIMIT PATTERNS ==========
public class SOQLLimitPatterns {
    
    // ❌ BAD: Query inside loop (hits SOQL limit fast)
    public static void inefficientQueries(List<Account> accounts) {
        for (Account acc : accounts) {
            // Query inside loop - WRONG!
            List<Contact> contacts = [
                SELECT Id, Name
                FROM Contact
                WHERE AccountId = :acc.Id
            ];
            // Process contacts...
        }
    }
    
    // ✅ GOOD: Single query with relationship
    public static void efficientQueries(List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        // Single query for all contacts
        Map<Id, List<Contact>> contactsByAccount = new Map<Id, List<Contact>>();
        for (Contact con : [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
            if (!contactsByAccount.containsKey(con.AccountId)) {
                contactsByAccount.put(con.AccountId, new List<Contact>());
            }
            contactsByAccount.get(con.AccountId).add(con);
        }
        
        // Process
        for (Account acc : accounts) {
            List<Contact> contacts = contactsByAccount.get(acc.Id);
            if (contacts != null) {
                // Process contacts
            }
        }
    }
    
    // ✅ BETTER: Use relationship query
    public static void relationshipQuery(List<Id> accountIds) {
        List<Account> accounts = [
            SELECT Id, Name,
                   (SELECT Id, Name FROM Contacts)
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for (Account acc : accounts) {
            for (Contact con : acc.Contacts) {
                // Process contact
            }
        }
    }
}

// ========== DML LIMIT PATTERNS ==========
public class DMLLimitPatterns {
    
    // ❌ BAD: DML inside loop
    public static void inefficientDML(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'Updated';
            update acc;  // WRONG! DML in loop
        }
    }
    
    // ✅ GOOD: Bulkified DML
    public static void efficientDML(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'Updated';
        }
        update accounts;  // Single DML statement
    }
    
    // ✅ GOOD: Batch large updates
    public static void batchedDML(List<Account> accounts) {
        Integer batchSize = 200;
        List<Account> batch = new List<Account>();
        
        for (Integer i = 0; i < accounts.size(); i++) {
            batch.add(accounts[i]);
            
            // Update every 200 records
            if (Math.mod(i + 1, batchSize) == 0 || i == accounts.size() - 1) {
                update batch;
                batch.clear();
            }
        }
    }
}

// ========== QUERY ROW LIMIT PATTERNS ==========
public class QueryRowLimitPatterns {
    
    // ❌ BAD: Might hit 50,000 row limit
    public static void unboundedQuery() {
        List<Account> accounts = [SELECT Id FROM Account];  // Could be > 50,000
    }
    
    // ✅ GOOD: Use LIMIT
    public static void boundedQuery() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 10000];
    }
    
    // ✅ BETTER: Use Batch Apex for large datasets
    public static void useBatchForLargeData() {
        // Database.executeBatch(new MyBatchClass(), 200);
    }
    
    // ✅ GOOD: Use Query Locator
    public static Database.QueryLocator getQueryLocator() {
        // For batch apex - supports up to 50 million records
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
}

// ========== CPU TIME LIMIT PATTERNS ==========
public class CPUTimeLimitPatterns {
    
    // ❌ BAD: Inefficient loops
    public static void inefficientProcessing(List<Account> accounts) {
        for (Account acc : accounts) {
            // Complex computation
            for (Integer i = 0; i < 10000; i++) {
                String temp = acc.Name + i;  // Wasteful
            }
        }
    }
    
    // ✅ GOOD: Optimize algorithms
    public static void efficientProcessing(List<Account> accounts) {
        Set<String> names = new Set<String>();
        for (Account acc : accounts) {
            names.add(acc.Name);  // Efficient
        }
    }
    
    // ✅ GOOD: Use Maps for lookups instead of nested loops
    public static void useMapForLookup(List<Account> accounts, List<Contact> contacts) {
        // ❌ BAD: O(n²)
        // for (Contact con : contacts) {
        //     for (Account acc : accounts) {
        //         if (con.AccountId == acc.Id) { }
        //     }
        // }
        
        // ✅ GOOD: O(n)
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        for (Contact con : contacts) {
            Account acc = accountMap.get(con.AccountId);
            if (acc != null) {
                // Process
            }
        }
    }
}

// ========== HEAP SIZE LIMIT PATTERNS ==========
public class HeapSizeLimitPatterns {
    
    // ❌ BAD: Loading too much data
    public static void excessiveMemory() {
        List<Account> accounts = [
            SELECT Id, Name, Description, BillingAddress, /* many fields */
            FROM Account
        ];
        
        List<String> bigList = new List<String>();
        for (Account acc : accounts) {
            bigList.add(acc.Name);
            bigList.add(acc.Description);
            bigList.add(String.valueOf(acc.BillingAddress));
        }
    }
    
    // ✅ GOOD: Query only needed fields
    public static void optimizedMemory() {
        List<Account> accounts = [
            SELECT Id, Name  // Only necessary fields
            FROM Account
        ];
        
        for (Account acc : accounts) {
            // Process immediately, don't store everything
            System.debug(acc.Name);
        }
    }
    
    // ✅ GOOD: Process in batches
    public static void batchedProcessing() {
        Integer offset = 0;
        Integer batchSize = 200;
        Boolean hasMore = true;
        
        while (hasMore) {
            List<Account> accounts = [
                SELECT Id, Name
                FROM Account
                LIMIT :batchSize
                OFFSET :offset
            ];
            
            if (accounts.isEmpty()) {
                hasMore = false;
            } else {
                // Process batch
                for (Account acc : accounts) {
                    // Process
                }
                offset += batchSize;
            }
        }
    }
}

// ========== LIMIT CHECKING ==========
public class LimitChecking {
    
    public static void checkBeforeOperation() {
        // Check SOQL limit
        if (Limits.getQueries() < Limits.getLimitQueries() - 10) {
            // Safe to query
            List<Account> accounts = [SELECT Id FROM Account];
        } else {
            System.debug('Approaching SOQL limit, deferring query');
        }
        
        // Check DML limit
        if (Limits.getDmlStatements() < Limits.getLimitDmlStatements()) {
            // Safe to DML
        }
        
        // Check CPU time
        if (Limits.getCpuTime() < Limits.getLimitCpuTime() - 1000) {
            // Safe to continue processing
        }
        
        // Check Heap size
        if (Limits.getHeapSize() < Limits.getLimitHeapSize() * 0.8) {
            // Safe to allocate more memory
        }
    }
    
    public static void monitorLimits() {
        Integer startQueries = Limits.getQueries();
        Integer startCpu = Limits.getCpuTime();
        
        // Perform operations
        List<Account> accounts = [SELECT Id FROM Account LIMIT 100];
        
        Integer endQueries = Limits.getQueries();
        Integer endCpu = Limits.getCpuTime();
        
        System.debug('SOQL used: ' + (endQueries - startQueries));
        System.debug('CPU used: ' + (endCpu - startCpu) + 'ms');
    }
}

// ========== AVOIDING LIMITS WITH ASYNC ==========
public class AsyncLimitAvoidance {
    
    // Use Future for additional limits
    public static void processWithFuture(Set<Id> accountIds) {
        // This uses main transaction limits
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
        
        // Offload to future for fresh limits
        if (!accountIds.isEmpty()) {
            processAccountsAsync(accountIds);
        }
    }
    
    @future
    public static void processAccountsAsync(Set<Id> accountIds) {
        // Fresh set of limits here
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
        update accounts;
    }
    
    // Use Queueable for chaining
    public static void processWithQueueable(List<Id> recordIds) {
        System.enqueueJob(new ProcessQueueable(recordIds));
    }
}

public class ProcessQueueable implements Queueable {
    private List<Id> recordIds;
    
    public ProcessQueueable(List<Id> ids) {
        this.recordIds = ids;
    }
    
    public void execute(QueueableContext context) {
        // Fresh limits
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :recordIds LIMIT 200];
        update accounts;
        
        // Chain if more records
        recordIds.remove(0, Math.min(200, recordIds.size()));
        if (!recordIds.isEmpty()) {
            System.enqueueJob(new ProcessQueueable(recordIds));
        }
    }
}

// ========== BEST PRACTICES ==========
public class LimitsBestPractices {
    
    public static void optimizedPattern(List<Account> accounts) {
        // 1. Bulkify everything
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        // 2. Single SOQL query
        Map<Id, List<Contact>> contactsByAccount = new Map<Id, List<Contact>>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
            if (!contactsByAccount.containsKey(con.AccountId)) {
                contactsByAccount.put(con.AccountId, new List<Contact>());
            }
            contactsByAccount.get(con.AccountId).add(con);
        }
        
        // 3. Process efficiently
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Account acc : accounts) {
            List<Contact> contacts = contactsByAccount.get(acc.Id);
            if (contacts != null) {
                for (Contact con : contacts) {
                    con.Description = 'Updated';
                    contactsToUpdate.add(con);
                }
            }
        }
        
        // 4. Single DML
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        
        // 5. Monitor limits
        System.debug('SOQL used: ' + Limits.getQueries());
        System.debug('DML used: ' + Limits.getDmlStatements());
        System.debug('CPU used: ' + Limits.getCpuTime());
    }
}

/* LIMIT EXCEPTIONS:
- System.LimitException: Thrown when limit exceeded
- Cannot be caught for CPU time or heap size
- Can be caught for SOQL/DML in some cases

STRATEGIES TO AVOID LIMITS:
1. Bulkify all code
2. Use Maps for lookups
3. Avoid SOQL/DML in loops
4. Query only needed fields
5. Use Batch Apex for large datasets
6. Use Future/Queueable for async processing
7. Monitor limits during execution
8. Optimize algorithms (use Set/Map over List loops)
9. Use relationship queries
10. Implement proper indexing
*/

/* MONITORING:
- Debug logs show limit usage
- Use Limits class in code
- Setup -> System Overview
- Developer Console → Logs
*/
