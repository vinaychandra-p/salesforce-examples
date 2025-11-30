/**
 * 09 - DML (Data Manipulation Language) - Comprehensive Examples
 * Covering: INSERT, UPDATE, DELETE, UNDELETE, UPSERT, Database methods
 */

// ========== INSERT OPERATIONS ==========
public class InsertExamples {
    
    // Insert single record
    public static Id insertSingleAccount() {
        Account acc = new Account(
            Name = 'Acme Corporation',
            Industry = 'Technology',
            AnnualRevenue = 1000000
        );
        
        insert acc;
        System.debug('Created Account Id: ' + acc.Id);
        return acc.Id;
    }
    
    // Insert multiple records (bulk)
    public static List<Id> insertMultipleAccounts() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Technology'
            ));
        }
        
        insert accounts;
        System.debug('Created ' + accounts.size() + ' accounts');
        
        List<Id> ids = new List<Id>();
        for (Account acc : accounts) {
            ids.add(acc.Id);
        }
        return ids;
    }
    
    // Insert with related records
    public static void insertWithRelated() {
        Account acc = new Account(Name = 'Parent Account');
        insert acc;
        
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                AccountId = acc.Id
            ));
        }
        
        insert contacts;
        System.debug('Created account with ' + contacts.size() + ' contacts');
    }
}

// ========== UPDATE OPERATIONS ==========
public class UpdateExamples {
    
    // Update single record
    public static void updateSingleAccount(Id accountId) {
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        acc.Name = acc.Name + ' (Updated)';
        acc.Description = 'Updated on ' + String.valueOf(Date.today());
        
        update acc;
        System.debug('Updated: ' + acc.Name);
    }
    
    // Update multiple records (bulk)
    public static void updateMultipleAccounts() {
        List<Account> accounts = [
            SELECT Id, Name, Description
            FROM Account
            WHERE Industry = 'Technology'
            LIMIT 200
        ];
        
        for (Account acc : accounts) {
            acc.Description = 'Bulk updated on ' + String.valueOf(Datetime.now());
        }
        
        update accounts;
        System.debug('Updated ' + accounts.size() + ' accounts');
    }
    
    // Conditional update
    public static void conditionalUpdate() {
        List<Opportunity> opps = [
            SELECT Id, StageName, Amount
            FROM Opportunity
            WHERE StageName = 'Prospecting'
            AND Amount > 10000
        ];
        
        for (Opportunity opp : opps) {
            opp.StageName = 'Qualification';
        }
        
        if (!opps.isEmpty()) {
            update opps;
            System.debug('Updated ' + opps.size() + ' opportunities');
        }
    }
}

// ========== DELETE OPERATIONS ==========
public class DeleteExamples {
    
    // Delete single record
    public static void deleteSingleAccount(Id accountId) {
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
        delete acc;
        System.debug('Deleted account: ' + accountId);
    }
    
    // Delete multiple records
    public static void deleteMultipleAccounts() {
        List<Account> accountsToDelete = [
            SELECT Id
            FROM Account
            WHERE Name LIKE 'Test%'
            AND CreatedDate = TODAY
        ];
        
        delete accountsToDelete;
        System.debug('Deleted ' + accountsToDelete.size() + ' test accounts');
    }
    
    // Delete with query
    public static void deleteOldRecords() {
        Date sixMonthsAgo = Date.today().addMonths(-6);
        
        List<Opportunity> oldOpps = [
            SELECT Id
            FROM Opportunity
            WHERE CloseDate < :sixMonthsAgo
            AND StageName = 'Closed Lost'
        ];
        
        if (!oldOpps.isEmpty()) {
            delete oldOpps;
            System.debug('Deleted ' + oldOpps.size() + ' old opportunities');
        }
    }
}

// ========== UNDELETE OPERATIONS ==========
public class UndeleteExamples {
    
    // Undelete single record
    public static void undeleteSingleRecord(Id recordId) {
        Account acc = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :recordId
            ALL ROWS  // Include deleted records
        ];
        
        undelete acc;
        System.debug('Restored: ' + acc.Name);
    }
    
    // Undelete multiple records
    public static void undeleteMultipleRecords() {
        List<Account> deletedAccounts = [
            SELECT Id, Name
            FROM Account
            WHERE IsDeleted = true
            AND Name LIKE 'Important%'
            ALL ROWS
            LIMIT 200
        ];
        
        if (!deletedAccounts.isEmpty()) {
            undelete deletedAccounts;
            System.debug('Restored ' + deletedAccounts.size() + ' accounts');
        }
    }
}

// ========== UPSERT OPERATIONS ==========
public class UpsertExamples {
    
    // Upsert with Id
    public static void upsertWithId() {
        List<Account> accounts = new List<Account>();
        
        // This will update (has Id)
        accounts.add(new Account(
            Id = '001xx000003DGb0AAG',
            Name = 'Updated Account'
        ));
        
        // This will insert (no Id)
        accounts.add(new Account(
            Name = 'New Account'
        ));
        
        upsert accounts;
        System.debug('Upserted ' + accounts.size() + ' accounts');
    }
    
    // Upsert with external Id
    public static void upsertWithExternalId() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(
                Name = 'Account ' + i,
                External_Id__c = 'EXT-' + i  // Custom external Id field
            ));
        }
        
        // First run: inserts all
        // Second run: updates all (matches on External_Id__c)
        upsert accounts External_Id__c;
        System.debug('Upserted ' + accounts.size() + ' accounts');
    }
}

// ========== DATABASE METHODS ==========
public class DatabaseMethodExamples {
    
    // Database.insert with partial success
    public static void databaseInsertPartial() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Valid Account'));
        accounts.add(new Account());  // Invalid: no Name
        accounts.add(new Account(Name = 'Another Valid'));
        
        // allOrNone = false: continue on errors
        Database.SaveResult[] results = Database.insert(accounts, false);
        
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Success: ' + accounts[i].Name);
            } else {
                for (Database.Error err : results[i].getErrors()) {
                    System.debug('Error: ' + err.getMessage());
                }
            }
        }
    }
    
    // Database.update with error handling
    public static void databaseUpdateWithErrors() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 5];
        
        for (Account acc : accounts) {
            acc.Name = acc.Name + ' (Updated)';
        }
        
        Database.SaveResult[] results = Database.update(accounts, false);
        
        Integer successCount = 0;
        Integer errorCount = 0;
        
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                successCount++;
            } else {
                errorCount++;
            }
        }
        
        System.debug('Success: ' + successCount + ', Errors: ' + errorCount);
    }
    
    // Database.delete with error handling
    public static void databaseDeleteSafe() {
        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Name LIKE 'Test%'
            LIMIT 100
        ];
        
        Database.DeleteResult[] results = Database.delete(accounts, false);
        
        for (Database.DeleteResult dr : results) {
            if (!dr.isSuccess()) {
                for (Database.Error err : dr.getErrors()) {
                    System.debug('Delete error: ' + err.getMessage());
                }
            }
        }
    }
    
    // Database.upsert with partial success
    public static void databaseUpsertPartial() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'New Account 1'));
        accounts.add(new Account(
            Id = '001xx000003DGb0AAG',
            Name = 'Updated Account'
        ));
        
        Database.UpsertResult[] results = Database.upsert(accounts, false);
        
        for (Database.UpsertResult ur : results) {
            if (ur.isSuccess()) {
                System.debug('Upserted Id: ' + ur.getId());
                System.debug('Created: ' + ur.isCreated());
            }
        }
    }
}

// ========== DML LIMITS AND BEST PRACTICES ==========
public class DMLBestPractices {
    
    // GOOD: Bulk DML
    public static void bulkDMLGood(List<Contact> contacts) {
        for (Contact con : contacts) {
            con.Description = 'Updated';
        }
        
        // Single DML statement for all records
        update contacts;
    }
    
    // BAD: DML in loop (hits governor limits)
    public static void dmlInLoopBad(List<Contact> contacts) {
        for (Contact con : contacts) {
            con.Description = 'Updated';
            // DON'T DO THIS!
            // update con;
        }
    }
    
    // Governor limits aware
    public static void checkDMLLimits() {
        Integer dmlStatements = Limits.getDMLStatements();
        Integer dmlRows = Limits.getDMLRows();
        
        System.debug('DML Statements used: ' + dmlStatements + '/' + Limits.getLimitDMLStatements());
        System.debug('DML Rows used: ' + dmlRows + '/' + Limits.getLimitDMLRows());
    }
    
    // Batch processing pattern
    public static void batchDMLPattern(List<Account> accounts) {
        List<Account> batch = new List<Account>();
        Integer batchSize = 200;
        
        for (Account acc : accounts) {
            acc.Description = 'Processed';
            batch.add(acc);
            
            if (batch.size() == batchSize) {
                update batch;
                batch.clear();
            }
        }
        
        // Process remaining
        if (!batch.isEmpty()) {
            update batch;
        }
    }
}

// ========== TRANSACTION CONTROL ==========
public class TransactionExamples {
    
    // Savepoint and rollback
    public static void useSavepoint() {
        Savepoint sp = Database.setSavepoint();
        
        try {
            Account acc = new Account(Name = 'Test Account');
            insert acc;
            
            // Simulate error
            if (true) {
                throw new DMLException('Simulated error');
            }
            
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = acc.Id
            );
            insert con;
            
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('Transaction rolled back: ' + e.getMessage());
        }
    }
    
    // All-or-nothing transaction
    public static void allOrNothingTransaction() {
        Account acc = new Account(Name = 'Parent Account');
        insert acc;
        
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                AccountId = acc.Id
            ));
        }
        
        // If any contact fails, all will rollback (default behavior)
        insert contacts;
    }
}

/* USAGE EXAMPLES:

// INSERT
Id accId = InsertExamples.insertSingleAccount();
List<Id> ids = InsertExamples.insertMultipleAccounts();

// UPDATE
UpdateExamples.updateSingleAccount(accId);
UpdateExamples.updateMultipleAccounts();

// DELETE
DeleteExamples.deleteMultipleAccounts();

// UPSERT
UpsertExamples.upsertWithId();

// Database methods
DatabaseMethodExamples.databaseInsertPartial();

// Best practices
DMLBestPractices.checkDMLLimits();

// Transactions
TransactionExamples.useSavepoint();
*/
