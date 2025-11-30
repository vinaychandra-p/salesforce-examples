/**
 * 05 - OPERATORS - Comprehensive Examples
 * Covering: Arithmetic, Assignment, Comparison, Logical, Bitwise, String
 */

// ========== ARITHMETIC OPERATORS ==========
public class ArithmeticOperators {
    
    public static void basicArithmetic() {
        Integer a = 10;
        Integer b = 3;
        
        // Addition
        Integer sum = a + b;              // 13
        
        // Subtraction
        Integer difference = a - b;       // 7
        
        // Multiplication
        Integer product = a * b;          // 30
        
        // Division
        Integer quotient = a / b;         // 3 (integer division)
        Decimal decQuotient = (Decimal)a / b;  // 3.33...
        
        // Modulus (remainder)
        Integer remainder = Math.mod(a, b);    // 1
        
        System.debug('Sum: ' + sum);
        System.debug('Quotient: ' + quotient);
        System.debug('Decimal Quotient: ' + decQuotient);
        System.debug('Remainder: ' + remainder);
    }
    
    public static void decimalArithmetic() {
        Decimal price = 99.99;
        Decimal tax = 8.5;
        Decimal quantity = 3;
        
        Decimal subtotal = price * quantity;
        Decimal taxAmount = subtotal * (tax / 100);
        Decimal total = subtotal + taxAmount;
        
        System.debug('Subtotal: $' + subtotal.setScale(2));
        System.debug('Tax: $' + taxAmount.setScale(2));
        System.debug('Total: $' + total.setScale(2));
    }
}

// ========== ASSIGNMENT OPERATORS ==========
public class AssignmentOperators {
    
    public static void basicAssignment() {
        Integer x = 10;
        
        // Compound assignment
        x += 5;   // x = x + 5  (15)
        x -= 3;   // x = x - 3  (12)
        x *= 2;   // x = x * 2  (24)
        x /= 4;   // x = x / 4  (6)
        
        System.debug('Final x: ' + x);
    }
    
    public static void incrementDecrement() {
        Integer count = 10;
        
        // Post-increment
        Integer a = count++;  // a = 10, count = 11
        System.debug('a: ' + a + ', count: ' + count);
        
        // Pre-increment
        Integer b = ++count;  // count = 12, b = 12
        System.debug('b: ' + b + ', count: ' + count);
        
        // Post-decrement
        Integer c = count--;  // c = 12, count = 11
        System.debug('c: ' + c + ', count: ' + count);
        
        // Pre-decrement
        Integer d = --count;  // count = 10, d = 10
        System.debug('d: ' + d + ', count: ' + count);
    }
}

// ========== COMPARISON OPERATORS ==========
public class ComparisonOperators {
    
    public static void basicComparison() {
        Integer a = 10;
        Integer b = 20;
        
        // Equal to
        Boolean isEqual = (a == b);       // false
        
        // Not equal to
        Boolean notEqual = (a != b);      // true
        
        // Greater than
        Boolean greater = (a > b);        // false
        
        // Less than
        Boolean less = (a < b);           // true
        
        // Greater than or equal
        Boolean greaterEqual = (a >= 10); // true
        
        // Less than or equal
        Boolean lessEqual = (b <= 20);    // true
        
        System.debug('Equal: ' + isEqual);
        System.debug('Not Equal: ' + notEqual);
        System.debug('Less: ' + less);
    }
    
    public static void stringComparison() {
        String str1 = 'Hello';
        String str2 = 'hello';
        
        // Case-sensitive comparison
        Boolean equal = (str1 == str2);           // false
        
        // Case-insensitive comparison
        Boolean equalIgnoreCase = str1.equalsIgnoreCase(str2); // true
        
        // String comparison methods
        Integer compare = str1.compareTo(str2);   // negative (comes before)
        
        System.debug('Equal: ' + equal);
        System.debug('Equal Ignore Case: ' + equalIgnoreCase);
    }
    
    public static void nullComparison() {
        String str = null;
        
        // Null check
        Boolean isNull = (str == null);           // true
        Boolean isNotNull = (str != null);        // false
        
        // Safe comparison
        if (str != null && str.length() > 0) {
            System.debug('String has content');
        }
        
        System.debug('Is Null: ' + isNull);
    }
}

// ========== LOGICAL OPERATORS ==========
public class LogicalOperators {
    
    public static void andOperator() {
        Boolean isActive = true;
        Boolean isPremium = true;
        
        // AND - both must be true
        if (isActive && isPremium) {
            System.debug('Active Premium User');
        }
        
        // Short-circuit evaluation
        Integer x = 0;
        if (x != 0 && 10 / x > 5) { // Second part not evaluated
            System.debug('This won\'t cause error');
        }
    }
    
    public static void orOperator() {
        Boolean hasEmail = false;
        Boolean hasPhone = true;
        
        // OR - at least one must be true
        if (hasEmail || hasPhone) {
            System.debug('Can contact user');
        }
        
        // Multiple OR conditions
        String status = 'Pending';
        if (status == 'Active' || status == 'Pending' || status == 'Trial') {
            System.debug('Valid status');
        }
    }
    
    public static void notOperator() {
        Boolean isDeleted = false;
        
        // NOT - inverts boolean
        if (!isDeleted) {
            System.debug('Record is active');
        }
        
        // Double negative
        Boolean isActive = !(!true);  // true
        
        System.debug('Is Active: ' + isActive);
    }
    
    public static void complexLogic() {
        Integer age = 25;
        Boolean hasLicense = true;
        Boolean hasInsurance = true;
        
        // Complex condition with parentheses
        if ((age >= 18 && hasLicense) && hasInsurance) {
            System.debug('Can rent car');
        }
        
        // De Morgan's Laws
        Boolean a = true;
        Boolean b = false;
        
        // !(a && b) == !a || !b
        Boolean result1 = !(a && b);
        Boolean result2 = !a || !b;
        System.debug('DeMorgan 1: ' + (result1 == result2)); // true
        
        // !(a || b) == !a && !b
        Boolean result3 = !(a || b);
        Boolean result4 = !a && !b;
        System.debug('DeMorgan 2: ' + (result3 == result4)); // true
    }
}

// ========== STRING OPERATORS ==========
public class StringOperators {
    
    public static void concatenation() {
        String first = 'John';
        String last = 'Doe';
        
        // + operator
        String fullName = first + ' ' + last;
        System.debug(fullName); // John Doe
        
        // += operator
        String message = 'Hello';
        message += ', ';
        message += 'World';
        System.debug(message); // Hello, World
        
        // Multiple concatenations
        String address = '123 ' + 'Main ' + 'St, ' + 'City';
        System.debug(address);
    }
    
    public static void stringWithNumbers() {
        String text = 'Value: ';
        Integer num = 42;
        
        // String + number = string
        String result = text + num;
        System.debug(result); // Value: 42
        
        // Number + string
        String result2 = num + ' items';
        System.debug(result2); // 42 items
    }
}

// ========== TERNARY OPERATOR ==========
public class TernaryOperator {
    
    public static void basicTernary() {
        Integer age = 20;
        String category = (age >= 18) ? 'Adult' : 'Minor';
        System.debug(category); // Adult
        
        Integer score = 85;
        String result = (score >= 60) ? 'Pass' : 'Fail';
        System.debug(result); // Pass
    }
    
    public static void nestedTernary() {
        Integer score = 75;
        String grade = (score >= 90) ? 'A' :
                      (score >= 80) ? 'B' :
                      (score >= 70) ? 'C' :
                      (score >= 60) ? 'D' : 'F';
        System.debug('Grade: ' + grade); // C
    }
    
    public static void ternaryWithObjects() {
        Account acc = null;
        String name = (acc != null) ? acc.Name : 'No Account';
        System.debug(name); // No Account
        
        List<String> items = new List<String>{'A', 'B'};
        String first = (items != null && !items.isEmpty()) ? items[0] : 'Empty';
        System.debug(first); // A
    }
}

// ========== INSTANCEOF OPERATOR ==========
public class InstanceofOperator {
    
    public static void checkTypes() {
        Object obj = 'Hello';
        
        if (obj instanceof String) {
            System.debug('It\'s a String');
        }
        
        obj = 42;
        if (obj instanceof Integer) {
            System.debug('It\'s an Integer');
        }
        
        obj = new Account(Name='Test');
        if (obj instanceof Account) {
            Account acc = (Account)obj;
            System.debug('Account: ' + acc.Name);
        }
    }
    
    public static void sObjectTypeCheck(sObject obj) {
        if (obj instanceof Account) {
            System.debug('Processing Account');
        } else if (obj instanceof Contact) {
            System.debug('Processing Contact');
        } else if (obj instanceof Opportunity) {
            System.debug('Processing Opportunity');
        } else {
            System.debug('Unknown sObject type');
        }
    }
}

// ========== OPERATOR PRECEDENCE ==========
public class OperatorPrecedence {
    
    public static void demonstratePrecedence() {
        // Precedence: * before +
        Integer result1 = 2 + 3 * 4;      // 14 (not 20)
        Integer result2 = (2 + 3) * 4;    // 20
        
        // Precedence: NOT before AND before OR
        Boolean a = true;
        Boolean b = false;
        Boolean c = true;
        
        Boolean result3 = a || b && c;     // true (AND first)
        Boolean result4 = (a || b) && c;   // true
        Boolean result5 = a || (b && c);   // true
        
        System.debug('2 + 3 * 4 = ' + result1);
        System.debug('(2 + 3) * 4 = ' + result2);
    }
}

/* USAGE EXAMPLES:

// Arithmetic
ArithmeticOperators.basicArithmetic();
ArithmeticOperators.decimalArithmetic();

// Assignment
AssignmentOperators.basicAssignment();
AssignmentOperators.incrementDecrement();

// Comparison
ComparisonOperators.basicComparison();
ComparisonOperators.stringComparison();
ComparisonOperators.nullComparison();

// Logical
LogicalOperators.andOperator();
LogicalOperators.orOperator();
LogicalOperators.notOperator();
LogicalOperators.complexLogic();

// String
StringOperators.concatenation();
StringOperators.stringWithNumbers();

// Ternary
TernaryOperator.basicTernary();
TernaryOperator.nestedTernary();

// Instanceof
InstanceofOperator.checkTypes();

// Precedence
OperatorPrecedence.demonstratePrecedence();
*/
