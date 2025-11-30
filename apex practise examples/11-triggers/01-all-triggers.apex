/**
 * 11 - TRIGGERS - Comprehensive Examples
 * Before/After triggers, context variables, trigger handlers, patterns
 */

// ========== BASIC TRIGGERS ==========

// BEFORE INSERT TRIGGER
trigger AccountBeforeInsert on Account (before insert) {
    for (Account acc : Trigger.new) {
        // Set default values
        if (acc.Rating == null) {
            acc.Rating = 'Cold';
        }
        // Auto-generate code
        if (String.isBlank(acc.AccountNumber)) {
            acc.AccountNumber = 'ACC-' + String.valueOf(Math.random()).substring(2, 10);
        }
    }
}

// AFTER INSERT TRIGGER
trigger AccountAfterInsert on Account (after insert) {
    List<Contact> contacts = new List<Contact>();
    
    for (Account acc : Trigger.new) {
        // Create default contact for each new account
        contacts.add(new Contact(
            FirstName = 'Default',
            LastName = 'Contact',
            AccountId = acc.Id,
            Email = 'default@' + acc.Name.replaceAll('\\s', '').toLowerCase() + '.com'
        ));
    }
    
    if (!contacts.isEmpty()) {
        insert contacts;
    }
}

// BEFORE UPDATE TRIGGER
trigger AccountBeforeUpdate on Account (before update) {
    for (Account acc : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(acc.Id);
        
        // Track field changes
        if (acc.AnnualRevenue != oldAccount.AnnualRevenue) {
            acc.Description = 'Revenue changed from ' + oldAccount.AnnualRevenue + 
                            ' to ' + acc.AnnualRevenue + ' on ' + String.valueOf(Date.today());
        }
        
        // Prevent certain changes
        if (acc.Industry != oldAccount.Industry && acc.Industry == 'Government') {
            acc.addError('Cannot change industry to Government without approval');
        }
    }
}

// AFTER UPDATE TRIGGER
trigger OpportunityAfterUpdate on Opportunity (after update) {
    List<Task> tasks = new List<Task>();
    
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        
        // Stage changed to Closed Won
        if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
            tasks.add(new Task(
                Subject = 'Follow up on won opportunity',
                WhatId = opp.Id,
                OwnerId = opp.OwnerId,
                Status = 'Not Started',
                Priority = 'High'
            ));
        }
    }
    
    if (!tasks.isEmpty()) {
        insert tasks;
    }
}

// BEFORE DELETE TRIGGER
trigger AccountBeforeDelete on Account (before delete) {
    for (Account acc : Trigger.old) {
        // Prevent deletion of accounts with opportunities
        Integer oppCount = [
            SELECT COUNT()
            FROM Opportunity
            WHERE AccountId = :acc.Id
        ];
        
        if (oppCount > 0) {
            acc.addError('Cannot delete account with related opportunities');
        }
    }
}

// AFTER DELETE TRIGGER
trigger ContactAfterDelete on Contact (after delete) {
    // Log deleted contacts
    List<DeleteLog__c> logs = new List<DeleteLog__c>();
    
    for (Contact con : Trigger.old) {
        logs.add(new DeleteLog__c(
            RecordId__c = con.Id,
            RecordName__c = con.FirstName + ' ' + con.LastName,
            DeletedDate__c = Datetime.now()
        ));
    }
    
    if (!logs.isEmpty()) {
        insert logs;
    }
}

// AFTER UNDELETE TRIGGER
trigger AccountAfterUndelete on Account (after undelete) {
    List<Task> tasks = new List<Task>();
    
    for (Account acc : Trigger.new) {
        tasks.add(new Task(
            Subject = 'Account restored - verify data',
            WhatId = acc.Id,
            Status = 'Not Started',
            Priority = 'Normal'
        ));
    }
    
    if (!tasks.isEmpty()) {
        insert tasks;
    }
}

// ========== TRIGGER CONTEXT VARIABLES ==========

/*
USAGE IN TRIGGER:

trigger ExampleTrigger on Account (before insert, before update, after insert, after update) {
    
    // Trigger.new - List of new/updated records
    List<Account> newAccounts = Trigger.new;
    
    // Trigger.old - List of old records (before update/delete)
    List<Account> oldAccounts = Trigger.old;
    
    // Trigger.newMap - Map of Id => new record
    Map<Id, Account> newMap = Trigger.newMap;
    
    // Trigger.oldMap - Map of Id => old record
    Map<Id, Account> oldMap = Trigger.oldMap;
    
    // Trigger.size - Number of records
    Integer recordCount = Trigger.size;
    
    // Trigger context booleans
    Boolean isInsert = Trigger.isInsert;
    Boolean isUpdate = Trigger.isUpdate;
    Boolean isDelete = Trigger.isDelete;
    Boolean isUndelete = Trigger.isUndelete;
    Boolean isBefore = Trigger.isBefore;
    Boolean isAfter = Trigger.isAfter;
    
    // Trigger.isExecuting - True if in trigger context
    Boolean inTrigger = Trigger.isExecuting;
    
    // Example: Route to different methods
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // Before insert logic
        } else if (Trigger.isUpdate) {
            // Before update logic
        }
    }
}
*/

// ========== TRIGGER HANDLER PATTERN ==========

public class AccountTriggerHandler {
    
    public static void beforeInsert(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            // Validation
            if (String.isBlank(acc.Name)) {
                acc.addError('Name is required');
            }
            
            // Set defaults
            if (acc.Rating == null) {
                acc.Rating = 'Cold';
            }
        }
    }
    
    public static void beforeUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        for (Id accId : newMap.keySet()) {
            Account newAcc = newMap.get(accId);
            Account oldAcc = oldMap.get(accId);
            
            // Track changes
            if (newAcc.AnnualRevenue != oldAcc.AnnualRevenue) {
                newAcc.Description = 'Revenue updated';
            }
        }
    }
    
    public static void afterInsert(Map<Id, Account> newMap) {
        List<Contact> contacts = new List<Contact>();
        
        for (Account acc : newMap.values()) {
            contacts.add(new Contact(
                FirstName = 'Primary',
                LastName = 'Contact',
                AccountId = acc.Id
            ));
        }
        
        if (!contacts.isEmpty()) {
            insert contacts;
        }
    }
    
    public static void afterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        Set<Id> changedAccounts = new Set<Id>();
        
        for (Id accId : newMap.keySet()) {
            Account newAcc = newMap.get(accId);
            Account oldAcc = oldMap.get(accId);
            
            if (newAcc.Industry != oldAcc.Industry) {
                changedAccounts.add(accId);
            }
        }
        
        if (!changedAccounts.isEmpty()) {
            // Process changed accounts
            processIndustryChange(changedAccounts);
        }
    }
    
    private static void processIndustryChange(Set<Id> accountIds) {
        // Implementation
        System.debug('Processing industry change for: ' + accountIds);
    }
}

// TRIGGER USING HANDLER
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.newMap);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}

// ========== TRIGGER BEST PRACTICES ==========

public class TriggerBestPractices {
    
    // ONE TRIGGER PER OBJECT
    /*
    DON'T: Create multiple triggers
    - AccountTrigger1
    - AccountTrigger2
    - AccountTrigger3
    
    DO: One trigger that handles all events
    - AccountTrigger (all events)
    */
    
    // BULKIFY YOUR CODE
    public static void bulkifiedExample(List<Account> accounts) {
        // GOOD: Query once, process all
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        Map<Id, List<Contact>> contactMap = new Map<Id, List<Contact>>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
            if (!contactMap.containsKey(con.AccountId)) {
                contactMap.put(con.AccountId, new List<Contact>());
            }
            contactMap.get(con.AccountId).add(con);
        }
        
        // Process all accounts
        for (Account acc : accounts) {
            List<Contact> relatedContacts = contactMap.get(acc.Id);
            // Do something with contacts
        }
    }
    
    // AVOID RECURSION
    public static Boolean isExecuting = false;
    
    public static void preventRecursion(List<Account> accounts) {
        if (isExecuting) {
            return;  // Exit if already running
        }
        
        isExecuting = true;
        try {
            // Your logic here
        } finally {
            isExecuting = false;
        }
    }
    
    // USE MAPS FOR EFFICIENCY
    public static void useMapPattern(List<Opportunity> opps) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opps) {
            accountIds.add(opp.AccountId);
        }
        
        // Query once into map
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Name, Industry FROM Account WHERE Id IN :accountIds]
        );
        
        // Fast lookup
        for (Opportunity opp : opps) {
            Account acc = accountMap.get(opp.AccountId);
            if (acc != null) {
                // Use account data
            }
        }
    }
}

// ========== ADVANCED TRIGGER PATTERNS ==========

public class TriggerFramework {
    
    // Trigger handler interface
    public interface ITriggerHandler {
        void beforeInsert(List<SObject> newRecords);
        void afterInsert(Map<Id, SObject> newMap);
        void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
        void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
        void beforeDelete(Map<Id, SObject> oldMap);
        void afterDelete(Map<Id, SObject> oldMap);
        void afterUndelete(Map<Id, SObject> newMap);
    }
    
    // Generic trigger dispatcher
    public static void run(ITriggerHandler handler) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                handler.beforeInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            } else if (Trigger.isDelete) {
                handler.beforeDelete(Trigger.oldMap);
            }
        }
        
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                handler.afterInsert(Trigger.newMap);
            } else if (Trigger.isUpdate) {
                handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
            } else if (Trigger.isDelete) {
                handler.afterDelete(Trigger.oldMap);
            } else if (Trigger.isUndelete) {
                handler.afterUndelete(Trigger.newMap);
            }
        }
    }
}

// Implementation example
public class AccountTriggerHandlerImpl implements TriggerFramework.ITriggerHandler {
    
    public void beforeInsert(List<SObject> newRecords) {
        List<Account> accounts = (List<Account>) newRecords;
        // Before insert logic
    }
    
    public void afterInsert(Map<Id, SObject> newMap) {
        Map<Id, Account> accounts = (Map<Id, Account>) newMap;
        // After insert logic
    }
    
    public void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        // Before update logic
    }
    
    public void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        // After update logic
    }
    
    public void beforeDelete(Map<Id, SObject> oldMap) {
        // Before delete logic
    }
    
    public void afterDelete(Map<Id, SObject> oldMap) {
        // After delete logic
    }
    
    public void afterUndelete(Map<Id, SObject> newMap) {
        // After undelete logic
    }
}

// Usage in trigger
/*
trigger AccountTrigger on Account (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    TriggerFramework.run(new AccountTriggerHandlerImpl());
}
*/

/* EXECUTION ORDER:
1. System validation rules
2. BEFORE triggers
3. Custom validation rules
4. Duplicate rules
5. Record saved (not committed)
6. AFTER triggers
7. Assignment rules
8. Auto-response rules
9. Workflow rules
10. Processes
11. Escalation rules
12. Roll-up summary fields
13. Criteria-based sharing
14. Commit to database
15. Post-commit logic
*/
