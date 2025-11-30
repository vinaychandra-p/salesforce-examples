/**
 * 03 - CONTROL FLOW - Comprehensive Examples
 * Covering: if/else, switch, ternary operator, control flow patterns
 */

// ========== IF/ELSE STATEMENTS ==========
public class IfElseExample {
    
    public static void basicIfElse(Integer score) {
        if (score >= 90) {
            System.debug('Grade: A');
        } else if (score >= 80) {
            System.debug('Grade: B');
        } else if (score >= 70) {
            System.debug('Grade: C');
        } else if (score >= 60) {
            System.debug('Grade: D');
        } else {
            System.debug('Grade: F');
        }
    }
    
    public static void nestedIfElse(Boolean isActive, Boolean isPremium) {
        if (isActive) {
            if (isPremium) {
                System.debug('Active Premium User');
            } else {
                System.debug('Active Standard User');
            }
        } else {
            System.debug('Inactive User');
        }
    }
    
    public static void logicalOperators(Integer age, Boolean hasLicense) {
        // AND operator
        if (age >= 18 && hasLicense) {
            System.debug('Can drive');
        }
        
        // OR operator
        if (age < 18 || !hasLicense) {
            System.debug('Cannot drive');
        }
        
        // Complex conditions
        if ((age >= 18 && hasLicense) || age >= 21) {
            System.debug('Special case');
        }
    }
}

// ========== SWITCH STATEMENTS ==========
public class SwitchExample {
    
    // Switch on Integer
    public static void switchOnInteger(Integer dayNum) {
        switch on dayNum {
            when 1 {
                System.debug('Monday');
            }
            when 2 {
                System.debug('Tuesday');
            }
            when 3 {
                System.debug('Wednesday');
            }
            when 4 {
                System.debug('Thursday');
            }
            when 5 {
                System.debug('Friday');
            }
            when 6, 7 {
                System.debug('Weekend');
            }
            when else {
                System.debug('Invalid day');
            }
        }
    }
    
    // Switch on String
    public static void switchOnString(String status) {
        switch on status {
            when 'New' {
                System.debug('Processing new record');
            }
            when 'In Progress' {
                System.debug('Record in progress');
            }
            when 'Completed' {
                System.debug('Record completed');
            }
            when 'Cancelled', 'Rejected' {
                System.debug('Record terminated');
            }
            when else {
                System.debug('Unknown status');
            }
        }
    }
    
    // Switch on sObject
    public static void switchOnSObject(sObject obj) {
        switch on obj {
            when Account acc {
                System.debug('Account: ' + acc.Name);
            }
            when Contact con {
                System.debug('Contact: ' + con.FirstName);
            }
            when Opportunity opp {
                System.debug('Opportunity: ' + opp.Name);
            }
            when else {
                System.debug('Unknown sObject type');
            }
        }
    }
    
    // Switch with when blocks
    public static String getSeasonDescription(String season) {
        String description;
        switch on season.toLowerCase() {
            when 'winter' {
                description = 'Cold season';
            }
            when 'spring' {
                description = 'Flowers blooming';
            }
            when 'summer' {
                description = 'Hot season';
            }
            when 'fall', 'autumn' {
                description = 'Leaves falling';
            }
            when else {
                description = 'Unknown season';
            }
        }
        return description;
    }
}

// ========== TERNARY OPERATOR ==========
public class TernaryOperatorExample {
    
    public static void basicTernary() {
        Integer age = 20;
        String status = (age >= 18) ? 'Adult' : 'Minor';
        System.debug(status); // Adult
        
        Boolean isActive = true;
        String message = isActive ? 'Active' : 'Inactive';
        System.debug(message); // Active
    }
    
    public static void nestedTernary() {
        Integer score = 85;
        String grade = (score >= 90) ? 'A' :
                      (score >= 80) ? 'B' :
                      (score >= 70) ? 'C' :
                      (score >= 60) ? 'D' : 'F';
        System.debug(grade); // B
    }
    
    public static void ternaryWithNull() {
        String name = null;
        String displayName = (name != null) ? name : 'Guest';
        System.debug(displayName); // Guest
        
        Account acc = null;
        String accName = (acc != null && acc.Name != null) ? acc.Name : 'Unknown';
        System.debug(accName); // Unknown
    }
}

// ========== CONTROL FLOW PATTERNS ==========
public class ControlFlowPatterns {
    
    // Early return pattern
    public static String validateAndProcess(String input) {
        // Guard clauses
        if (input == null) {
            return 'Error: Input is null';
        }
        
        if (input.length() == 0) {
            return 'Error: Input is empty';
        }
        
        if (input.length() > 100) {
            return 'Error: Input too long';
        }
        
        // Main logic
        return 'Processed: ' + input;
    }
    
    // Multiple condition checking
    public static Boolean isValidUser(Integer age, String email, Boolean agreed) {
        return age >= 18 &&
               email != null &&
               email.contains('@') &&
               agreed == true;
    }
    
    // Complex business logic
    public static String calculateDiscount(Decimal amount, Boolean isPremium, Integer itemCount) {
        Decimal discount = 0;
        
        if (isPremium) {
            if (amount > 1000) {
                discount = 0.20; // 20% for premium + high amount
            } else {
                discount = 0.10; // 10% for premium
            }
        } else {
            if (itemCount > 10) {
                discount = 0.05; // 5% for bulk purchase
            }
        }
        
        Decimal finalAmount = amount * (1 - discount);
        return 'Original: $' + amount + ', Discount: ' + (discount * 100) + '%, Final: $' + finalAmount;
    }
    
    // State machine pattern
    public static String processOrder(String currentState, String action) {
        String newState;
        
        switch on currentState {
            when 'Draft' {
                newState = (action == 'submit') ? 'Pending' : 'Draft';
            }
            when 'Pending' {
                switch on action {
                    when 'approve' {
                        newState = 'Approved';
                    }
                    when 'reject' {
                        newState = 'Rejected';
                    }
                    when else {
                        newState = 'Pending';
                    }
                }
            }
            when 'Approved' {
                newState = (action == 'ship') ? 'Shipped' : 'Approved';
            }
            when else {
                newState = currentState;
            }
        }
        
        return newState;
    }
}

/* USAGE EXAMPLES:

// If/Else
IfElseExample.basicIfElse(85);
IfElseExample.nestedIfElse(true, true);
IfElseExample.logicalOperators(20, true);

// Switch
SwitchExample.switchOnInteger(3);
SwitchExample.switchOnString('In Progress');
System.debug(SwitchExample.getSeasonDescription('summer'));

// Ternary
TernaryOperatorExample.basicTernary();
TernaryOperatorExample.nestedTernary();
TernaryOperatorExample.ternaryWithNull();

// Patterns
System.debug(ControlFlowPatterns.validateAndProcess('test'));
System.debug(ControlFlowPatterns.isValidUser(20, 'test@test.com', true));
System.debug(ControlFlowPatterns.calculateDiscount(1500, true, 5));
System.debug(ControlFlowPatterns.processOrder('Draft', 'submit'));
*/
