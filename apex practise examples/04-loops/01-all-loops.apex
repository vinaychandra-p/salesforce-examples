/**
 * 04 - LOOPS - Comprehensive Examples
 * Covering: for loops, while loops, do-while, loop control, iteration patterns
 */

// ========== FOR LOOPS ==========
public class ForLoopExamples {
    
    // Traditional for loop
    public static void traditionalForLoop() {
        for (Integer i = 0; i < 5; i++) {
            System.debug('Iteration: ' + i);
        }
        
        // Countdown
        for (Integer i = 10; i > 0; i--) {
            System.debug('Countdown: ' + i);
        }
        
        // Step by 2
        for (Integer i = 0; i <= 10; i += 2) {
            System.debug('Even: ' + i);
        }
    }
    
    // List iteration
    public static void listIteration() {
        List<String> names = new List<String>{'Alice', 'Bob', 'Charlie'};
        
        // Enhanced for loop
        for (String name : names) {
            System.debug('Name: ' + name);
        }
        
        // Traditional with index
        for (Integer i = 0; i < names.size(); i++) {
            System.debug(i + ': ' + names[i]);
        }
    }
    
    // Set iteration
    public static void setIteration() {
        Set<Integer> numbers = new Set<Integer>{1, 2, 3, 4, 5};
        
        for (Integer num : numbers) {
            System.debug('Number: ' + num);
        }
    }
    
    // Map iteration
    public static void mapIteration() {
        Map<String, Integer> scores = new Map<String, Integer>{
            'Alice' => 95,
            'Bob' => 87,
            'Charlie' => 92
        };
        
        // Iterate over keys
        for (String key : scores.keySet()) {
            System.debug(key + ': ' + scores.get(key));
        }
        
        // Iterate over values
        for (Integer score : scores.values()) {
            System.debug('Score: ' + score);
        }
    }
    
    // sObject list iteration
    public static void sObjectIteration() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        
        for (Account acc : accounts) {
            System.debug('Account: ' + acc.Name);
        }
    }
}

// ========== WHILE LOOPS ==========
public class WhileLoopExamples {
    
    // Basic while loop
    public static void basicWhileLoop() {
        Integer count = 0;
        while (count < 5) {
            System.debug('Count: ' + count);
            count++;
        }
    }
    
    // While with complex condition
    public static void complexWhileLoop() {
        Integer sum = 0;
        Integer i = 1;
        
        while (sum < 100 && i <= 20) {
            sum += i;
            i++;
        }
        
        System.debug('Sum: ' + sum + ', iterations: ' + i);
    }
    
    // While with search pattern
    public static Integer findFirst(List<Integer> numbers, Integer target) {
        Integer index = 0;
        Boolean found = false;
        
        while (index < numbers.size() && !found) {
            if (numbers[index] == target) {
                found = true;
            } else {
                index++;
            }
        }
        
        return found ? index : -1;
    }
}

// ========== DO-WHILE LOOPS ==========
public class DoWhileLoopExamples {
    
    // Basic do-while
    public static void basicDoWhile() {
        Integer count = 0;
        do {
            System.debug('Count: ' + count);
            count++;
        } while (count < 5);
    }
    
    // Do-while ensures at least one execution
    public static void atLeastOnce() {
        Integer count = 10;
        do {
            System.debug('This runs at least once: ' + count);
            count++;
        } while (count < 5); // False, but body executed once
    }
    
    // Menu-driven pattern
    public static void menuPattern(List<String> options) {
        Integer choice = 0;
        do {
            System.debug('Option ' + choice + ': ' + options[choice]);
            choice++;
        } while (choice < options.size());
    }
}

// ========== LOOP CONTROL ==========
public class LoopControlExamples {
    
    // Break statement
    public static void useBreak() {
        for (Integer i = 0; i < 10; i++) {
            if (i == 5) {
                System.debug('Breaking at: ' + i);
                break; // Exit loop
            }
            System.debug('i: ' + i);
        }
    }
    
    // Continue statement
    public static void useContinue() {
        for (Integer i = 0; i < 10; i++) {
            if (i % 2 == 0) {
                continue; // Skip even numbers
            }
            System.debug('Odd number: ' + i);
        }
    }
    
    // Break in nested loops
    public static void breakNestedLoops() {
        Boolean found = false;
        for (Integer i = 0; i < 5 && !found; i++) {
            for (Integer j = 0; j < 5; j++) {
                if (i * j == 12) {
                    System.debug('Found: ' + i + ' * ' + j + ' = 12');
                    found = true;
                    break; // Exit inner loop
                }
            }
        }
    }
    
    // Continue with complex logic
    public static void processRecords(List<Integer> numbers) {
        for (Integer num : numbers) {
            // Skip null or invalid values
            if (num == null || num < 0) {
                continue;
            }
            
            // Skip even numbers
            if (Math.mod(num, 2) == 0) {
                continue;
            }
            
            // Process odd positive numbers
            System.debug('Processing: ' + num);
        }
    }
}

// ========== ADVANCED LOOP PATTERNS ==========
public class AdvancedLoopPatterns {
    
    // Nested loops
    public static void multiplicationTable() {
        for (Integer i = 1; i <= 5; i++) {
            String row = '';
            for (Integer j = 1; j <= 5; j++) {
                row += (i * j) + '\t';
            }
            System.debug(row);
        }
    }
    
    // Accumulator pattern
    public static Decimal calculateSum(List<Decimal> numbers) {
        Decimal sum = 0;
        for (Decimal num : numbers) {
            sum += num;
        }
        return sum;
    }
    
    // Find max/min
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
    
    // Filter pattern
    public static List<Integer> filterEven(List<Integer> numbers) {
        List<Integer> result = new List<Integer>();
        for (Integer num : numbers) {
            if (Math.mod(num, 2) == 0) {
                result.add(num);
            }
        }
        return result;
    }
    
    // Transform pattern
    public static List<Integer> doubleValues(List<Integer> numbers) {
        List<Integer> result = new List<Integer>();
        for (Integer num : numbers) {
            result.add(num * 2);
        }
        return result;
    }
    
    // Batch processing pattern (Governor Limits aware)
    public static void batchProcess(List<Account> accounts) {
        Integer batchSize = 200;
        List<Account> batch = new List<Account>();
        
        for (Account acc : accounts) {
            batch.add(acc);
            
            if (batch.size() == batchSize) {
                // Process batch
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

// ========== LOOP ANTI-PATTERNS (AVOID THESE) ==========
public class LoopAntiPatterns {
    
    // BAD: SOQL in loop
    public static void soqlInLoop_BAD(List<Contact> contacts) {
        for (Contact con : contacts) {
            // DON'T DO THIS - hits governor limits!
            // List<Account> accs = [SELECT Id FROM Account WHERE Id = :con.AccountId];
        }
    }
    
    // GOOD: SOQL outside loop
    public static void soqlOutsideLoop_GOOD(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : contacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        
        // Single SOQL query
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Name FROM Account WHERE Id IN :accountIds]
        );
    }
    
    // BAD: DML in loop
    public static void dmlInLoop_BAD(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'Updated';
            // DON'T DO THIS - hits governor limits!
            // update acc;
        }
    }
    
    // GOOD: Bulk DML
    public static void bulkDML_GOOD(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'Updated';
        }
        // Single DML statement
        update accounts;
    }
}

/* USAGE EXAMPLES:

// For loops
ForLoopExamples.traditionalForLoop();
ForLoopExamples.listIteration();
ForLoopExamples.mapIteration();

// While loops
WhileLoopExamples.basicWhileLoop();
List<Integer> nums = new List<Integer>{1, 5, 3, 7, 2};
System.debug('Index: ' + WhileLoopExamples.findFirst(nums, 7));

// Do-while
DoWhileLoopExamples.basicDoWhile();

// Loop control
LoopControlExamples.useBreak();
LoopControlExamples.useContinue();

// Advanced patterns
AdvancedLoopPatterns.multiplicationTable();
System.debug('Sum: ' + AdvancedLoopPatterns.calculateSum(new List<Decimal>{1.5, 2.5, 3.5}));
System.debug('Max: ' + AdvancedLoopPatterns.findMax(new List<Integer>{5, 2, 9, 1, 7}));
*/
