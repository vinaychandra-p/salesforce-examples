/**
 * with data category Examples
 * Comprehensive SOSL examples for with data category
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class 21withdatacategory {
    
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
 * 21withdatacategory.example1();
 * 21withdatacategory.example2();
 * 21withdatacategory.example3();
 */
