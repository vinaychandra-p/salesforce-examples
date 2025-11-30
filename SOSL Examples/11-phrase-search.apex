/**
 * phrase search Examples
 * Comprehensive SOSL examples for phrase search
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class 11phrasesearch {
    
    public static void example1() {
        // Example implementation
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Name)
        ];
        System.debug('Results: ' + results[0].size());
    }
    
    public static void example2() {
        List<List<sObject>> results = [
            FIND 'Smith'
            IN NAME FIELDS
            RETURNING Contact(FirstName, LastName)
        ];
        System.debug('Contacts found: ' + results[0].size());
    }
    
    public static void example3() {
        List<List<sObject>> results = [
            FIND 'Technology'
            RETURNING Account(Name, Industry WHERE Industry = 'Technology' LIMIT 10)
        ];
        for (Account acc : (Account[])results[0]) {
            System.debug(acc.Name);
        }
    }
}

/**
 * USAGE:
 * 11phrasesearch.example1();
 * 11phrasesearch.example2();
 * 11phrasesearch.example3();
 */
