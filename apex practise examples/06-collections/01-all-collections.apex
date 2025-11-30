/**
 * 06 - COLLECTIONS - Comprehensive Examples
 * Lists, Sets, Maps, and advanced collection operations
 */

// ========== LIST OPERATIONS ==========
public class ListOperations {
    
    // List basics
    public static void listBasics() {
        // Initialization
        List<String> names = new List<String>();
        List<Integer> numbers = new List<Integer>{1, 2, 3, 4, 5};
        
        // Add elements
        names.add('Alice');
        names.add('Bob');
        names.add(1, 'Charlie'); // Insert at index
        
        // Access elements
        String first = names.get(0);
        String second = names[1]; // Index notation
        
        // Size
        Integer size = names.size();
        
        // Check empty
        Boolean isEmpty = names.isEmpty();
        
        // Contains
        Boolean hasAlice = names.contains('Alice');
        
        System.debug('Names: ' + names);
        System.debug('Size: ' + size);
    }
    
    // List modification
    public static void listModification() {
        List<Integer> numbers = new List<Integer>{1, 2, 3, 4, 5};
        
        // Set element
        numbers.set(0, 10); // Change first element to 10
        
        // Remove by index
        numbers.remove(2); // Remove element at index 2
        
        // Clear all
        List<String> temp = new List<String>{'A', 'B'};
        temp.clear();
        
        System.debug('Modified: ' + numbers);
        System.debug('Cleared size: ' + temp.size());
    }
    
    // List iteration
    public static void listIteration() {
        List<String> fruits = new List<String>{'Apple', 'Banana', 'Orange'};
        
        // Enhanced for loop
        for (String fruit : fruits) {
            System.debug('Fruit: ' + fruit);
        }
        
        // Traditional for loop
        for (Integer i = 0; i < fruits.size(); i++) {
            System.debug(i + ': ' + fruits[i]);
        }
    }
    
    // List sorting
    public static void listSorting() {
        List<Integer> numbers = new List<Integer>{5, 2, 8, 1, 9};
        numbers.sort(); // Ascending order
        System.debug('Sorted: ' + numbers);
        
        List<String> names = new List<String>{'Charlie', 'Alice', 'Bob'};
        names.sort();
        System.debug('Sorted names: ' + names);
    }
    
    // List of sObjects
    public static void sObjectList() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
        
        insert accounts;
        
        // Access inserted Ids
        for (Account acc : accounts) {
            System.debug('Created: ' + acc.Id);
        }
    }
}

// ========== SET OPERATIONS ==========
public class SetOperations {
    
    // Set basics (no duplicates)
    public static void setBasics() {
        Set<Integer> numbers = new Set<Integer>{1, 2, 3, 3, 4};
        System.debug('Set: ' + numbers); // {1, 2, 3, 4}
        
        // Add (duplicates ignored)
        numbers.add(5);
        numbers.add(3); // Won't add duplicate
        
        // Contains
        Boolean hasThree = numbers.contains(3);
        
        // Size
        Integer size = numbers.size();
        
        // Remove
        numbers.remove(2);
        
        System.debug('Final set: ' + numbers);
        System.debug('Size: ' + size);
    }
    
    // Set operations
    public static void setOperations() {
        Set<Integer> set1 = new Set<Integer>{1, 2, 3, 4};
        Set<Integer> set2 = new Set<Integer>{3, 4, 5, 6};
        
        // Union (add all)
        Set<Integer> union = set1.clone();
        union.addAll(set2);
        System.debug('Union: ' + union); // {1, 2, 3, 4, 5, 6}
        
        // Intersection
        Set<Integer> intersection = set1.clone();
        intersection.retainAll(set2);
        System.debug('Intersection: ' + intersection); // {3, 4}
        
        // Difference
        Set<Integer> difference = set1.clone();
        difference.removeAll(set2);
        System.debug('Difference: ' + difference); // {1, 2}
    }
    
    // Set with Ids
    public static void setWithIds() {
        Set<Id> accountIds = new Set<Id>();
        
        List<Account> accounts = [SELECT Id FROM Account LIMIT 10];
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        System.debug('Unique Account Ids: ' + accountIds.size());
    }
    
    // Set iteration
    public static void setIteration() {
        Set<String> colors = new Set<String>{'Red', 'Green', 'Blue'};
        
        for (String color : colors) {
            System.debug('Color: ' + color);
        }
    }
}

// ========== MAP OPERATIONS ==========
public class MapOperations {
    
    // Map basics
    public static void mapBasics() {
        Map<String, Integer> scores = new Map<String, Integer>();
        
        // Put key-value pairs
        scores.put('Alice', 95);
        scores.put('Bob', 87);
        scores.put('Charlie', 92);
        
        // Get value
        Integer aliceScore = scores.get('Alice');
        
        // Check if key exists
        Boolean hasBob = scores.containsKey('Bob');
        
        // Get all keys
        Set<String> names = scores.keySet();
        
        // Get all values
        List<Integer> allScores = scores.values();
        
        // Size
        Integer size = scores.size();
        
        System.debug('Alice score: ' + aliceScore);
        System.debug('All keys: ' + names);
        System.debug('Map size: ' + size);
    }
    
    // Map initialization
    public static void mapInitialization() {
        // Inline initialization
        Map<String, String> capitals = new Map<String, String>{
            'USA' => 'Washington',
            'UK' => 'London',
            'France' => 'Paris'
        };
        
        System.debug('UK capital: ' + capitals.get('UK'));
    }
    
    // Map iteration
    public static void mapIteration() {
        Map<String, Decimal> prices = new Map<String, Decimal>{
            'Apple' => 1.99,
            'Banana' => 0.99,
            'Orange' => 2.49
        };
        
        // Iterate over keys
        for (String item : prices.keySet()) {
            System.debug(item + ': $' + prices.get(item));
        }
        
        // Iterate over values
        for (Decimal price : prices.values()) {
            System.debug('Price: $' + price);
        }
    }
    
    // Map of sObjects
    public static void sObjectMap() {
        // Query into map
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Name FROM Account LIMIT 10]
        );
        
        System.debug('Map size: ' + accountMap.size());
        
        // Access by Id
        for (Id accId : accountMap.keySet()) {
            System.debug('Account: ' + accountMap.get(accId).Name);
        }
    }
    
    // Nested map
    public static void nestedMap() {
        Map<String, Map<String, Integer>> studentGrades = new Map<String, Map<String, Integer>>();
        
        Map<String, Integer> aliceGrades = new Map<String, Integer>{
            'Math' => 95,
            'English' => 88
        };
        studentGrades.put('Alice', aliceGrades);
        
        // Access nested value
        Integer aliceMath = studentGrades.get('Alice').get('Math');
        System.debug('Alice Math: ' + aliceMath);
    }
}

// ========== COLLECTION ALGORITHMS ==========
public class CollectionAlgorithms {
    
    // Filter list
    public static List<Integer> filterEven(List<Integer> numbers) {
        List<Integer> result = new List<Integer>();
        for (Integer num : numbers) {
            if (Math.mod(num, 2) == 0) {
                result.add(num);
            }
        }
        return result;
    }
    
    // Transform list
    public static List<Integer> multiplyBy2(List<Integer> numbers) {
        List<Integer> result = new List<Integer>();
        for (Integer num : numbers) {
            result.add(num * 2);
        }
        return result;
    }
    
    // Reduce/aggregate
    public static Integer sum(List<Integer> numbers) {
        Integer total = 0;
        for (Integer num : numbers) {
            total += num;
        }
        return total;
    }
    
    // Find max
    public static Integer findMax(List<Integer> numbers) {
        if (numbers == null || numbers.isEmpty()) {
            return null;
        }
        Integer max = numbers[0];
        for (Integer num : numbers) {
            if (num > max) {
                max = num;
            }
        }
        return max;
    }
    
    // Group by
    public static Map<String, List<Account>> groupByIndustry(List<Account> accounts) {
        Map<String, List<Account>> grouped = new Map<String, List<Account>>();
        
        for (Account acc : accounts) {
            String industry = acc.Industry != null ? acc.Industry : 'Unknown';
            
            if (!grouped.containsKey(industry)) {
                grouped.put(industry, new List<Account>());
            }
            grouped.get(industry).add(acc);
        }
        
        return grouped;
    }
    
    // Remove duplicates
    public static List<String> removeDuplicates(List<String> items) {
        Set<String> uniqueSet = new Set<String>(items);
        return new List<String>(uniqueSet);
    }
}

// ========== COLLECTION CONVERSIONS ==========
public class CollectionConversions {
    
    // List to Set
    public static void listToSet() {
        List<Integer> numbers = new List<Integer>{1, 2, 2, 3, 3, 4};
        Set<Integer> uniqueNumbers = new Set<Integer>(numbers);
        System.debug('Unique: ' + uniqueNumbers); // {1, 2, 3, 4}
    }
    
    // Set to List
    public static void setToList() {
        Set<String> uniqueNames = new Set<String>{'Alice', 'Bob', 'Charlie'};
        List<String> namesList = new List<String>(uniqueNames);
        System.debug('List: ' + namesList);
    }
    
    // sObject List to Map
    public static void listToMap() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        System.debug('Map size: ' + accountMap.size());
    }
    
    // Map to List
    public static void mapToList() {
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Name FROM Account LIMIT 10]
        );
        List<Account> accountList = accountMap.values();
        System.debug('List size: ' + accountList.size());
    }
}

/* USAGE EXAMPLES:

// Lists
ListOperations.listBasics();
ListOperations.listSorting();

// Sets
SetOperations.setBasics();
SetOperations.setOperations();

// Maps
MapOperations.mapBasics();
MapOperations.mapIteration();
MapOperations.sObjectMap();

// Algorithms
List<Integer> nums = new List<Integer>{1, 2, 3, 4, 5, 6};
System.debug('Even: ' + CollectionAlgorithms.filterEven(nums));
System.debug('Doubled: ' + CollectionAlgorithms.multiplyBy2(nums));
System.debug('Sum: ' + CollectionAlgorithms.sum(nums));
System.debug('Max: ' + CollectionAlgorithms.findMax(nums));

// Conversions
CollectionConversions.listToSet();
CollectionConversions.setToList();
*/
