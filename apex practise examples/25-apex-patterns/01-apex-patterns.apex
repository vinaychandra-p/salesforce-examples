/**
 * 25 - APEX DESIGN PATTERNS - Enterprise Patterns
 * Singleton, Factory, Trigger Handler, Service Layer, Repository, Builder
 */

// ========== SINGLETON PATTERN ==========
public class ConfigurationManager {
    private static ConfigurationManager instance;
    private Map<String, String> config;
    
    // Private constructor
    private ConfigurationManager() {
        config = new Map<String, String>();
        loadConfiguration();
    }
    
    // Get instance
    public static ConfigurationManager getInstance() {
        if (instance == null) {
            instance = new ConfigurationManager();
        }
        return instance;
    }
    
    private void loadConfiguration() {
        // Load from custom settings or metadata
        config.put('API_ENDPOINT', 'https://api.example.com');
        config.put('TIMEOUT', '60000');
    }
    
    public String getSetting(String key) {
        return config.get(key);
    }
}

// Usage: ConfigurationManager.getInstance().getSetting('API_ENDPOINT');

// ========== FACTORY PATTERN ==========
public interface PaymentProcessor {
    void processPayment(Decimal amount);
    String getProcessorName();
}

public class CreditCardProcessor implements PaymentProcessor {
    public void processPayment(Decimal amount) {
        System.debug('Processing credit card payment: ' + amount);
    }
    
    public String getProcessorName() {
        return 'Credit Card';
    }
}

public class PayPalProcessor implements PaymentProcessor {
    public void processPayment(Decimal amount) {
        System.debug('Processing PayPal payment: ' + amount);
    }
    
    public String getProcessorName() {
        return 'PayPal';
    }
}

public class PaymentProcessorFactory {
    public static PaymentProcessor getProcessor(String type) {
        if (type == 'CreditCard') {
            return new CreditCardProcessor();
        } else if (type == 'PayPal') {
            return new PayPalProcessor();
        } else {
            throw new IllegalArgumentException('Unknown processor type: ' + type);
        }
    }
}

// Usage:
// PaymentProcessor processor = PaymentProcessorFactory.getProcessor('CreditCard');
// processor.processPayment(100.00);

// ========== TRIGGER HANDLER PATTERN ==========
public interface ITriggerHandler {
    void beforeInsert(List<sObject> newRecords);
    void afterInsert(List<sObject> newRecords);
    void beforeUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap);
    void afterUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap);
    void beforeDelete(Map<Id, sObject> oldMap);
    void afterDelete(Map<Id, sObject> oldMap);
    void afterUndelete(List<sObject> newRecords);
}

public virtual class TriggerHandler implements ITriggerHandler {
    
    public void run() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                this.beforeInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                this.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            } else if (Trigger.isDelete) {
                this.beforeDelete(Trigger.oldMap);
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                this.afterInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                this.afterUpdate(Trigger.newMap, Trigger.oldMap);
            } else if (Trigger.isDelete) {
                this.afterDelete(Trigger.oldMap);
            } else if (Trigger.isUndelete) {
                this.afterUndelete(Trigger.new);
            }
        }
    }
    
    // Virtual methods to be overridden
    public virtual void beforeInsert(List<sObject> newRecords) {}
    public virtual void afterInsert(List<sObject> newRecords) {}
    public virtual void beforeUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {}
    public virtual void afterUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {}
    public virtual void beforeDelete(Map<Id, sObject> oldMap) {}
    public virtual void afterDelete(Map<Id, sObject> oldMap) {}
    public virtual void afterUndelete(List<sObject> newRecords) {}
}

// Implementation
public class AccountTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert(List<sObject> newRecords) {
        List<Account> accounts = (List<Account>) newRecords;
        for (Account acc : accounts) {
            if (String.isBlank(acc.Rating)) {
                acc.Rating = 'Cold';
            }
        }
    }
    
    public override void afterInsert(List<sObject> newRecords) {
        List<Account> accounts = (List<Account>) newRecords;
        AccountService.createDefaultContacts(accounts);
    }
    
    public override void afterUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        Map<Id, Account> newAccounts = (Map<Id, Account>) newMap;
        Map<Id, Account> oldAccounts = (Map<Id, Account>) oldMap;
        
        List<Account> statusChanged = new List<Account>();
        for (Id accId : newAccounts.keySet()) {
            if (newAccounts.get(accId).Status__c != oldAccounts.get(accId).Status__c) {
                statusChanged.add(newAccounts.get(accId));
            }
        }
        
        if (!statusChanged.isEmpty()) {
            AccountService.handleStatusChange(statusChanged);
        }
    }
}

// Trigger
// trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
//     new AccountTriggerHandler().run();
// }

// ========== SERVICE LAYER PATTERN ==========
public class AccountService {
    
    public static void createDefaultContacts(List<Account> accounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Account acc : accounts) {
            contactsToInsert.add(new Contact(
                FirstName = 'Default',
                LastName = 'Contact',
                AccountId = acc.Id,
                Email = 'default@' + acc.Name.toLowerCase().replaceAll(' ', '') + '.com'
            ));
        }
        
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
    
    public static void handleStatusChange(List<Account> accounts) {
        // Business logic for status changes
        List<Task> tasksToCreate = new List<Task>();
        
        for (Account acc : accounts) {
            if (acc.Status__c == 'Active') {
                tasksToCreate.add(new Task(
                    Subject = 'Welcome Call',
                    WhatId = acc.Id,
                    ActivityDate = Date.today().addDays(1)
                ));
            }
        }
        
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
    
    public static List<Account> getAccountsByIndustry(String industry) {
        return AccountRepository.findByIndustry(industry);
    }
}

// ========== REPOSITORY PATTERN ==========
public class AccountRepository {
    
    public static List<Account> findAll() {
        return [SELECT Id, Name, Industry FROM Account];
    }
    
    public static Account findById(Id accountId) {
        List<Account> accounts = [
            SELECT Id, Name, Industry, AnnualRevenue
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        return accounts.isEmpty() ? null : accounts[0];
    }
    
    public static List<Account> findByIndustry(String industry) {
        return [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry = :industry
        ];
    }
    
    public static List<Account> findByName(String name) {
        String searchTerm = '%' + name + '%';
        return [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :searchTerm
        ];
    }
    
    public static void save(Account account) {
        if (account.Id == null) {
            insert account;
        } else {
            update account;
        }
    }
    
    public static void saveAll(List<Account> accounts) {
        List<Account> toInsert = new List<Account>();
        List<Account> toUpdate = new List<Account>();
        
        for (Account acc : accounts) {
            if (acc.Id == null) {
                toInsert.add(acc);
            } else {
                toUpdate.add(acc);
            }
        }
        
        if (!toInsert.isEmpty()) insert toInsert;
        if (!toUpdate.isEmpty()) update toUpdate;
    }
    
    public static void deleteAccount(Account account) {
        delete account;
    }
}

// ========== BUILDER PATTERN ==========
public class AccountBuilder {
    private Account account;
    
    public AccountBuilder() {
        account = new Account();
    }
    
    public AccountBuilder withName(String name) {
        account.Name = name;
        return this;
    }
    
    public AccountBuilder withIndustry(String industry) {
        account.Industry = industry;
        return this;
    }
    
    public AccountBuilder withRevenue(Decimal revenue) {
        account.AnnualRevenue = revenue;
        return this;
    }
    
    public AccountBuilder withRating(String rating) {
        account.Rating = rating;
        return this;
    }
    
    public Account build() {
        return account;
    }
    
    public Account buildAndSave() {
        insert account;
        return account;
    }
}

// Usage:
// Account acc = new AccountBuilder()
//     .withName('Tech Corp')
//     .withIndustry('Technology')
//     .withRevenue(1000000)
//     .withRating('Hot')
//     .buildAndSave();

// ========== STRATEGY PATTERN ==========
public interface DiscountStrategy {
    Decimal calculateDiscount(Decimal amount);
}

public class NoDiscount implements DiscountStrategy {
    public Decimal calculateDiscount(Decimal amount) {
        return 0;
    }
}

public class PercentageDiscount implements DiscountStrategy {
    private Decimal percentage;
    
    public PercentageDiscount(Decimal pct) {
        this.percentage = pct;
    }
    
    public Decimal calculateDiscount(Decimal amount) {
        return amount * (percentage / 100);
    }
}

public class FixedDiscount implements DiscountStrategy {
    private Decimal fixedAmount;
    
    public FixedDiscount(Decimal amount) {
        this.fixedAmount = amount;
    }
    
    public Decimal calculateDiscount(Decimal amount) {
        return Math.min(fixedAmount, amount);
    }
}

public class PriceCalculator {
    private DiscountStrategy strategy;
    
    public PriceCalculator(DiscountStrategy strategy) {
        this.strategy = strategy;
    }
    
    public Decimal calculateFinalPrice(Decimal originalPrice) {
        Decimal discount = strategy.calculateDiscount(originalPrice);
        return originalPrice - discount;
    }
}

// Usage:
// DiscountStrategy strategy = new PercentageDiscount(10);
// PriceCalculator calculator = new PriceCalculator(strategy);
// Decimal finalPrice = calculator.calculateFinalPrice(1000);

// ========== UNIT OF WORK PATTERN ==========
public class UnitOfWork {
    private List<sObject> newRecords = new List<sObject>();
    private List<sObject> dirtyRecords = new List<sObject>();
    private List<sObject> deletedRecords = new List<sObject>();
    
    public void registerNew(sObject record) {
        newRecords.add(record);
    }
    
    public void registerDirty(sObject record) {
        dirtyRecords.add(record);
    }
    
    public void registerDeleted(sObject record) {
        deletedRecords.add(record);
    }
    
    public void commitWork() {
        if (!newRecords.isEmpty()) {
            insert newRecords;
        }
        
        if (!dirtyRecords.isEmpty()) {
            update dirtyRecords;
        }
        
        if (!deletedRecords.isEmpty()) {
            delete deletedRecords;
        }
        
        // Clear lists after commit
        newRecords.clear();
        dirtyRecords.clear();
        deletedRecords.clear();
    }
}

// Usage:
// UnitOfWork uow = new UnitOfWork();
// uow.registerNew(new Account(Name='Test 1'));
// uow.registerNew(new Contact(LastName='Test'));
// uow.commitWork();

// ========== DEPENDENCY INJECTION ==========
public interface IEmailService {
    void sendEmail(String toAddress, String subject, String body);
}

public class SalesforceEmailService implements IEmailService {
    public void sendEmail(String toAddress, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{toAddress});
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}

public class NotificationService {
    private IEmailService emailService;
    
    // Constructor injection
    public NotificationService(IEmailService emailService) {
        this.emailService = emailService;
    }
    
    public void notifyUser(String email, String message) {
        emailService.sendEmail(email, 'Notification', message);
    }
}

// Usage:
// IEmailService emailService = new SalesforceEmailService();
// NotificationService notifier = new NotificationService(emailService);
// notifier.notifyUser('user@example.com', 'Hello!');

// ========== RECURSION PREVENTION ==========
public class RecursionHelper {
    private static Set<String> processedRecords = new Set<String>();
    
    public static Boolean isFirstRun(String context, Id recordId) {
        String key = context + '_' + recordId;
        if (processedRecords.contains(key)) {
            return false;
        }
        processedRecords.add(key);
        return true;
    }
    
    public static void reset() {
        processedRecords.clear();
    }
}

// Usage in trigger handler:
// if (RecursionHelper.isFirstRun('AccountTrigger', acc.Id)) {
//     // Process only once
// }

// ========== SELECTOR PATTERN (SOQL) ==========
public class AccountSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account.Id,
            Account.Name,
            Account.Industry,
            Account.AnnualRevenue
        };
    }
    
    public List<Account> selectById(Set<Id> idSet) {
        return [
            SELECT Id, Name, Industry, AnnualRevenue
            FROM Account
            WHERE Id IN :idSet
        ];
    }
    
    public List<Account> selectByIndustry(String industry) {
        return [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry = :industry
        ];
    }
    
    public List<Account> selectWithContacts(Set<Id> accountIds) {
        return [
            SELECT Id, Name,
                   (SELECT Id, FirstName, LastName FROM Contacts)
            FROM Account
            WHERE Id IN :accountIds
        ];
    }
}

/* PATTERN BENEFITS:

SINGLETON:
- Single instance across transaction
- Centralized configuration
- Prevent duplicate processing

FACTORY:
- Encapsulate object creation
- Easy to extend with new types
- Loose coupling

TRIGGER HANDLER:
- Separation of concerns
- Testable code
- Reusable logic
- Clean trigger code

SERVICE LAYER:
- Business logic separation
- Reusable across triggers/controllers
- Easier testing
- Transaction boundaries

REPOSITORY:
- Data access abstraction
- Centralized queries
- Easier mocking in tests

BUILDER:
- Fluent object creation
- Complex object construction
- Immutable objects

STRATEGY:
- Runtime algorithm selection
- Open/closed principle
- Testable algorithms

UNIT OF WORK:
- Manage transactions
- Bulk operations
- Maintain relationships

Best Practice: Combine patterns as needed for your use case
*/
