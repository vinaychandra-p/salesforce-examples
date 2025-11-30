/**
 * search result validation Examples
 * Comprehensive SOSL examples for search result validation
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class 35searchresultvalidation {
    
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
 * 35searchresultvalidation.example1();
 * 35searchresultvalidation.example2();
 * 35searchresultvalidation.example3();
 */
