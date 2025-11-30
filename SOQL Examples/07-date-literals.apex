/**
 * Date Literals Examples
 * TODAY, YESTERDAY, THIS_WEEK literals
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class DateliteralsExamples {
    
    /**
     * Example 1: Basic Query
     */
    public static void basicExample() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        System.debug('Found ' + accounts.size() + ' accounts');
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
        }
    }
    
    /**
     * Example 2: With WHERE Clause
     */
    public static void withWhereClause() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE LastName = 'Smith'
            LIMIT 10
        ];
        System.debug('Contacts found: ' + contacts.size());
    }
    
    /**
     * Example 3: With Relationships
     */
    public static void withRelationships() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Account.Name, Account.Industry
            FROM Contact
            WHERE Account.Industry = 'Technology'
            LIMIT 10
        ];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' at ' + con.Account.Name);
        }
    }
    
    /**
     * Example 4: Aggregate Query
     */
    public static void aggregateExample() {
        AggregateResult[] results = [
            SELECT COUNT(Id) total, Industry
            FROM Account
            WHERE Industry != null
            GROUP BY Industry
        ];
        for (AggregateResult ar : results) {
            System.debug(ar.get('Industry') + ': ' + ar.get('total'));
        }
    }
    
    /**
     * Example 5: Dynamic Query
     */
    public static List<sObject> dynamicQuery(String objectName, String fieldName, String value) {
        String query = 'SELECT Id, Name FROM ' + objectName;
        query += ' WHERE ' + fieldName + ' = :value LIMIT 10';
        return Database.query(query);
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * DateliteralsExamples.basicExample();
 * DateliteralsExamples.withWhereClause();
 * DateliteralsExamples.withRelationships();
 * DateliteralsExamples.aggregateExample();
 * List<sObject> results = DateliteralsExamples.dynamicQuery('Account', 'Industry', 'Technology');
 */
