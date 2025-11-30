/**
 * 08 - SOQL (Salesforce Object Query Language) - Part 1
 * Covering: Basic queries, WHERE clauses, relationships, aggregations
 */

// ========== BASIC SOQL QUERIES ==========
public class BasicSOQLExamples {
    
    // Simple SELECT
    public static void basicSelect() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
        }
    }
    
    // SELECT all fields (use specific fields in production)
    public static void selectMultipleFields() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email, Phone, AccountId
            FROM Contact
            LIMIT 10
        ];
        
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ': ' + con.Email);
        }
    }
    
    // SELECT with LIMIT
    public static void selectWithLimit() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 5];
        System.debug('Found ' + accounts.size() + ' accounts');
    }
    
    // SELECT with OFFSET
    public static void selectWithOffset() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10 OFFSET 20];
        System.debug('Accounts from 21-30');
    }
}

// ========== WHERE CLAUSES ==========
public class WhereClauseExamples {
    
    // Equality
    public static void equalityFilter() {
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Industry = 'Technology'
        ];
        System.debug('Tech accounts: ' + accounts.size());
    }
    
    // Multiple conditions with AND
    public static void andConditions() {
        List<Account> accounts = [
            SELECT Id, Name, Industry, AnnualRevenue
            FROM Account
            WHERE Industry = 'Technology'
            AND AnnualRevenue > 1000000
        ];
        System.debug('Large tech accounts: ' + accounts.size());
    }
    
    // Multiple conditions with OR
    public static void orConditions() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName
            FROM Contact
            WHERE FirstName = 'John'
            OR FirstName = 'Jane'
        ];
        System.debug('Johns and Janes: ' + contacts.size());
    }
    
    // NOT operator
    public static void notCondition() {
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE NOT Industry = 'Technology'
        ];
        System.debug('Non-tech accounts: ' + accounts.size());
    }
    
    // IN operator
    public static void inOperator() {
        List<Account> accounts = [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry IN ('Technology', 'Finance', 'Healthcare')
        ];
        System.debug('Filtered accounts: ' + accounts.size());
    }
    
    // NOT IN operator
    public static void notInOperator() {
        List<String> excludedIndustries = new List<String>{'Retail', 'Manufacturing'};
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Industry NOT IN :excludedIndustries
        ];
        System.debug('Accounts: ' + accounts.size());
    }
    
    // LIKE operator (wildcards)
    public static void likeOperator() {
        // Starts with 'Acme'
        List<Account> accounts1 = [SELECT Id, Name FROM Account WHERE Name LIKE 'Acme%'];
        
        // Ends with 'Inc'
        List<Account> accounts2 = [SELECT Id, Name FROM Account WHERE Name LIKE '%Inc'];
        
        // Contains 'Corp'
        List<Account> accounts3 = [SELECT Id, Name FROM Account WHERE Name LIKE '%Corp%'];
        
        System.debug('Starts with Acme: ' + accounts1.size());
        System.debug('Ends with Inc: ' + accounts2.size());
        System.debug('Contains Corp: ' + accounts3.size());
    }
    
    // NULL checks
    public static void nullChecks() {
        // IS NULL
        List<Contact> noEmail = [
            SELECT Id, FirstName, LastName
            FROM Contact
            WHERE Email = null
        ];
        
        // IS NOT NULL
        List<Contact> hasEmail = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE Email != null
        ];
        
        System.debug('No email: ' + noEmail.size());
        System.debug('Has email: ' + hasEmail.size());
    }
    
    // Comparison operators
    public static void comparisonOperators() {
        Date thirtyDaysAgo = Date.today().addDays(-30);
        
        List<Opportunity> recentOpps = [
            SELECT Id, Name, Amount, CloseDate
            FROM Opportunity
            WHERE CloseDate >= :thirtyDaysAgo
            AND Amount > 10000
        ];
        
        System.debug('Recent large opportunities: ' + recentOpps.size());
    }
}

// ========== BIND VARIABLES ==========
public class BindVariableExamples {
    
    // Simple bind variable
    public static List<Account> getAccountsByIndustry(String industry) {
        return [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry = :industry
        ];
    }
    
    // Multiple bind variables
    public static List<Contact> searchContacts(String firstName, String lastName) {
        return [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE FirstName = :firstName
            AND LastName = :lastName
        ];
    }
    
    // Collection bind variable
    public static List<Account> getAccountsByIds(Set<Id> accountIds) {
        return [
            SELECT Id, Name
            FROM Account
            WHERE Id IN :accountIds
        ];
    }
    
    // Date bind variable
    public static List<Opportunity> getOpportunitiesByDate(Date startDate, Date endDate) {
        return [
            SELECT Id, Name, CloseDate, Amount
            FROM Opportunity
            WHERE CloseDate >= :startDate
            AND CloseDate <= :endDate
        ];
    }
}

// ========== RELATIONSHIP QUERIES ==========
public class RelationshipQueryExamples {
    
    // Parent to Child (one-to-many)
    public static void queryChildRecords() {
        List<Account> accountsWithContacts = [
            SELECT Id, Name,
                (SELECT Id, FirstName, LastName, Email FROM Contacts)
            FROM Account
            WHERE Id != null
            LIMIT 5
        ];
        
        for (Account acc : accountsWithContacts) {
            System.debug('Account: ' + acc.Name);
            for (Contact con : acc.Contacts) {
                System.debug('  Contact: ' + con.FirstName + ' ' + con.LastName);
            }
        }
    }
    
    // Multiple child relationships
    public static void queryMultipleChildren() {
        List<Account> accounts = [
            SELECT Id, Name,
                (SELECT Id, FirstName, LastName FROM Contacts),
                (SELECT Id, Name, StageName FROM Opportunities)
            FROM Account
            LIMIT 5
        ];
        
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
            System.debug('  Contacts: ' + acc.Contacts.size());
            System.debug('  Opportunities: ' + acc.Opportunities.size());
        }
    }
    
    // Child to Parent (many-to-one)
    public static void queryParentFields() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName,
                Account.Name, Account.Industry, Account.AnnualRevenue
            FROM Contact
            WHERE AccountId != null
            LIMIT 10
        ];
        
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' works at ' + con.Account.Name);
            System.debug('  Industry: ' + con.Account.Industry);
        }
    }
    
    // Multi-level parent traversal
    public static void queryGrandparent() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName,
                Account.Name,
                Account.Owner.Name,
                Account.Owner.Profile.Name
            FROM Contact
            WHERE AccountId != null
            LIMIT 5
        ];
        
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' at ' + con.Account.Name);
            System.debug('  Owner: ' + con.Account.Owner.Name);
        }
    }
}

// ========== ORDER BY ==========
public class OrderByExamples {
    
    // Simple ORDER BY
    public static void orderByAscending() {
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            ORDER BY Name ASC
            LIMIT 10
        ];
        
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    // ORDER BY descending
    public static void orderByDescending() {
        List<Opportunity> opps = [
            SELECT Id, Name, Amount
            FROM Opportunity
            WHERE Amount != null
            ORDER BY Amount DESC
            LIMIT 10
        ];
        
        for (Opportunity opp : opps) {
            System.debug(opp.Name + ': $' + opp.Amount);
        }
    }
    
    // Multiple ORDER BY fields
    public static void orderByMultiple() {
        List<Contact> contacts = [
            SELECT Id, LastName, FirstName
            FROM Contact
            ORDER BY LastName ASC, FirstName ASC
            LIMIT 20
        ];
        
        for (Contact con : contacts) {
            System.debug(con.LastName + ', ' + con.FirstName);
        }
    }
    
    // ORDER BY with NULL handling
    public static void orderByNullsFirst() {
        List<Account> accounts = [
            SELECT Id, Name, AnnualRevenue
            FROM Account
            ORDER BY AnnualRevenue ASC NULLS FIRST
            LIMIT 10
        ];
        
        for (Account acc : accounts) {
            System.debug(acc.Name + ': ' + acc.AnnualRevenue);
        }
    }
}

// ========== AGGREGATE FUNCTIONS ==========
public class AggregateQueryExamples {
    
    // COUNT
    public static void countRecords() {
        Integer accountCount = [SELECT COUNT() FROM Account];
        System.debug('Total accounts: ' + accountCount);
        
        Integer techAccountCount = [
            SELECT COUNT()
            FROM Account
            WHERE Industry = 'Technology'
        ];
        System.debug('Tech accounts: ' + techAccountCount);
    }
    
    // COUNT with field
    public static void countField() {
        Integer contactsWithEmail = [
            SELECT COUNT(Email)
            FROM Contact
            WHERE Email != null
        ];
        System.debug('Contacts with email: ' + contactsWithEmail);
    }
    
    // SUM, AVG, MIN, MAX
    public static void aggregateFunctions() {
        List<AggregateResult> results = [
            SELECT
                SUM(Amount) totalAmount,
                AVG(Amount) avgAmount,
                MIN(Amount) minAmount,
                MAX(Amount) maxAmount,
                COUNT(Id) oppCount
            FROM Opportunity
            WHERE Amount != null
        ];
        
        AggregateResult ar = results[0];
        System.debug('Total: $' + ar.get('totalAmount'));
        System.debug('Average: $' + ar.get('avgAmount'));
        System.debug('Min: $' + ar.get('minAmount'));
        System.debug('Max: $' + ar.get('maxAmount'));
        System.debug('Count: ' + ar.get('oppCount'));
    }
    
    // GROUP BY
    public static void groupByExample() {
        List<AggregateResult> results = [
            SELECT Industry, COUNT(Id) accountCount
            FROM Account
            WHERE Industry != null
            GROUP BY Industry
            ORDER BY COUNT(Id) DESC
        ];
        
        for (AggregateResult ar : results) {
            System.debug(ar.get('Industry') + ': ' + ar.get('accountCount'));
        }
    }
    
    // GROUP BY with HAVING
    public static void groupByWithHaving() {
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId != null
            GROUP BY AccountId
            HAVING COUNT(Id) > 5
        ];
        
        System.debug('Accounts with more than 5 contacts: ' + results.size());
    }
}

/* USAGE EXAMPLES:

// Basic queries
BasicSOQLExamples.basicSelect();
BasicSOQLExamples.selectWithLimit();

// WHERE clauses
WhereClauseExamples.equalityFilter();
WhereClauseExamples.andConditions();
WhereClauseExamples.inOperator();
WhereClauseExamples.likeOperator();

// Bind variables
List<Account> techAccounts = BindVariableExamples.getAccountsByIndustry('Technology');
System.debug('Found: ' + techAccounts.size());

// Relationships
RelationshipQueryExamples.queryChildRecords();
RelationshipQueryExamples.queryParentFields();

// ORDER BY
OrderByExamples.orderByDescending();
OrderByExamples.orderByMultiple();

// Aggregates
AggregateQueryExamples.countRecords();
AggregateQueryExamples.aggregateFunctions();
AggregateQueryExamples.groupByExample();
*/
