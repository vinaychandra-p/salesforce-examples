/**
 * 02 - DATA TYPES - Comprehensive Examples
 * Covering: Primitives, sObjects, Collections, Type Conversion
 */

// ========== PRIMITIVE DATA TYPES ==========
public class PrimitiveTypesExample {
    
    public static void demonstratePrimitives() {
        // Integer (32-bit signed)
        Integer count = 100;
        Integer negative = -50;
        
        // Long (64-bit signed)
        Long bigNumber = 2147483648L;
        
        // Decimal (arbitrary precision)
        Decimal price = 99.99;
        Decimal tax = 8.5;
        Decimal total = price + (price * tax / 100);
        
        // Double (64-bit floating point)
        Double pi = 3.14159;
        
        // Boolean
        Boolean isActive = true;
        Boolean isDeleted = false;
        
        // String
        String name = 'Salesforce';
        String message = 'Hello, ' + name;
        
        // ID (Salesforce record ID)
        Id accountId = '001xx000003DGbQAAW';
        
        // Date
        Date today = Date.today();
        Date birthday = Date.newInstance(1990, 5, 15);
        
        // Time
        Time noon = Time.newInstance(12, 0, 0, 0);
        
        // Datetime
        Datetime now = Datetime.now();
        Datetime future = Datetime.newInstance(2025, 12, 31, 23, 59, 59);
        
        // Blob (binary data)
        String text = 'Hello';
        Blob blobData = Blob.valueOf(text);
        
        System.debug('Integer: ' + count);
        System.debug('Decimal: ' + total);
        System.debug('Boolean: ' + isActive);
        System.debug('Date: ' + today);
        System.debug('Datetime: ' + now);
    }
}

// ========== TYPE CONVERSION ==========
public class TypeConversionExample {
    
    public static void demonstrateConversions() {
        // String to Integer
        String numStr = '123';
        Integer num = Integer.valueOf(numStr);
        
        // String to Decimal
        String priceStr = '99.99';
        Decimal price = Decimal.valueOf(priceStr);
        
        // Integer to String
        Integer count = 42;
        String countStr = String.valueOf(count);
        
        // String to Date
        String dateStr = '2025-11-30';
        Date d = Date.valueOf(dateStr);
        
        // Datetime to Date
        Datetime dt = Datetime.now();
        Date dateOnly = dt.date();
        
        // Date to Datetime
        Date today = Date.today();
        Datetime startOfDay = Datetime.newInstance(today, Time.newInstance(0, 0, 0, 0));
        
        // Number parsing
        String hexStr = '1A';
        Integer fromHex = Integer.valueOf(hexStr, 16); // 26
        
        System.debug('String to Integer: ' + num);
        System.debug('Hex to Integer: ' + fromHex);
    }
}

// ========== sOBJECT TYPES ==========
public class SObjectExample {
    
    public static void demonstrateSObjects() {
        // Creating sObjects
        Account acc = new Account();
        acc.Name = 'Acme Corporation';
        acc.Industry = 'Technology';
        acc.NumberOfEmployees = 500;
        
        // Generic sObject
        sObject obj = acc;
        String name = (String)obj.get('Name');
        obj.put('Phone', '555-1234');
        
        // sObject type checking
        if (obj instanceof Account) {
            Account typedAcc = (Account)obj;
            System.debug('Account Name: ' + typedAcc.Name);
        }
        
        // sObject methods
        String objType = obj.getSObjectType().getDescribe().getName();
        Map<String, Object> fieldMap = obj.getPopulatedFieldsAsMap();
        
        System.debug('Object Type: ' + objType);
        System.debug('Fields: ' + fieldMap);
    }
}

// ========== COLLECTION TYPES ==========
public class CollectionTypesExample {
    
    // LIST EXAMPLES
    public static void demonstrateLists() {
        // Integer List
        List<Integer> numbers = new List<Integer>{1, 2, 3, 4, 5};
        numbers.add(6);
        numbers.add(0, 0); // Insert at index 0
        Integer first = numbers.get(0);
        Integer size = numbers.size();
        
        // String List
        List<String> names = new List<String>();
        names.add('Alice');
        names.add('Bob');
        names.add('Charlie');
        
        // sObject List
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
        
        // List methods
        Boolean isEmpty = accounts.isEmpty();
        Boolean contains = names.contains('Alice');
        names.remove(1); // Remove Bob
        names.clear();   // Remove all
        
        System.debug('Numbers: ' + numbers);
        System.debug('Size: ' + size);
    }
    
    // SET EXAMPLES
    public static void demonstrateSets() {
        // Integer Set (no duplicates)
        Set<Integer> uniqueNumbers = new Set<Integer>{1, 2, 3, 3, 4};
        uniqueNumbers.add(5);
        uniqueNumbers.add(3); // Won't add duplicate
        
        // String Set
        Set<String> uniqueNames = new Set<String>{'Alice', 'Bob', 'Alice'};
        
        // ID Set
        Set<Id> accountIds = new Set<Id>();
        
        // Set methods
        Boolean contains = uniqueNumbers.contains(3);
        Integer size = uniqueNumbers.size();
        uniqueNumbers.remove(1);
        
        // Set operations
        Set<Integer> set1 = new Set<Integer>{1, 2, 3};
        Set<Integer> set2 = new Set<Integer>{3, 4, 5};
        set1.addAll(set2);    // Union
        set1.retainAll(set2); // Intersection
        
        System.debug('Unique Numbers: ' + uniqueNumbers);
        System.debug('Size: ' + size);
    }
    
    // MAP EXAMPLES
    public static void demonstrateMaps() {
        // String to Integer Map
        Map<String, Integer> scores = new Map<String, Integer>();
        scores.put('Alice', 95);
        scores.put('Bob', 87);
        scores.put('Charlie', 92);
        
        // Get value
        Integer aliceScore = scores.get('Alice');
        
        // Check if key exists
        Boolean hasBob = scores.containsKey('Bob');
        
        // Get all keys and values
        Set<String> names = scores.keySet();
        List<Integer> allScores = scores.values();
        
        // Iterate over map
        for (String name : scores.keySet()) {
            System.debug(name + ': ' + scores.get(name));
        }
        
        // ID to sObject Map
        Map<Id, Account> accountMap = new Map<Id, Account>();
        
        // Map methods
        Integer size = scores.size();
        scores.remove('Bob');
        scores.clear();
        
        System.debug('Map Size: ' + size);
    }
}

// ========== NULL VALUES ==========
public class NullHandlingExample {
    
    public static void demonstrateNulls() {
        // Null primitives
        Integer nullInt = null;
        String nullStr = null;
        Boolean nullBool = null;
        
        // Null checking
        if (nullInt == null) {
            System.debug('Integer is null');
        }
        
        // Null-safe navigation
        Account acc = null;
        // String name = acc.Name; // NullPointerException!
        
        // Safe approach
        String name = (acc != null) ? acc.Name : 'Unknown';
        
        // Collections can contain null
        List<String> list = new List<String>{'A', null, 'B'};
        
        // Default values for null
        Integer value = (nullInt != null) ? nullInt : 0;
        
        System.debug('Safe name: ' + name);
        System.debug('Default value: ' + value);
    }
}

/* USAGE EXAMPLES:

// Primitives
PrimitiveTypesExample.demonstratePrimitives();

// Type conversion
TypeConversionExample.demonstrateConversions();

// sObjects
SObjectExample.demonstrateSObjects();

// Collections
CollectionTypesExample.demonstrateLists();
CollectionTypesExample.demonstrateSets();
CollectionTypesExample.demonstrateMaps();

// Null handling
NullHandlingExample.demonstrateNulls();
*/
