/**
 * 10 - EXCEPTION HANDLING - Comprehensive Examples
 * Try/catch, custom exceptions, error handling patterns
 */

// ========== BASIC EXCEPTION HANDLING ==========
public class BasicExceptionHandling {
    
    // Simple try-catch
    public static void basicTryCatch() {
        try {
            Integer result = 10 / 0;  // Division by zero
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    // Multiple catch blocks
    public static void multipleCatchBlocks() {
        try {
            List<Integer> numbers = new List<Integer>{1, 2, 3};
            Integer value = numbers[10];  // Index out of bounds
        } catch (ListException e) {
            System.debug('List error: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('General error: ' + e.getMessage());
        }
    }
    
    // Finally block
    public static void finallyBlock() {
        try {
            System.debug('In try block');
            Integer result = 10 / 0;
        } catch (Exception e) {
            System.debug('In catch block');
        } finally {
            System.debug('In finally block - always executes');
        }
    }
}

// ========== COMMON EXCEPTION TYPES ==========
public class CommonExceptions {
    
    // NullPointerException
    public static void nullPointerExample() {
        try {
            Account acc = null;
            String name = acc.Name;  // NullPointerException
        } catch (NullPointerException e) {
            System.debug('Null pointer: ' + e.getMessage());
        }
    }
    
    // DMLException
    public static void dmlExceptionExample() {
        try {
            Account acc = new Account();  // Missing required Name field
            insert acc;
        } catch (DMLException e) {
            System.debug('DML Error: ' + e.getMessage());
            System.debug('Failed on record: ' + e.getDmlIndex(0));
            System.debug('Status code: ' + e.getDmlType(0));
        }
    }
    
    // QueryException
    public static void queryExceptionExample() {
        try {
            // getSObjectType() can be null if no records
            Account acc = [SELECT Id FROM Account WHERE Name = 'NonExistent'];
        } catch (QueryException e) {
            System.debug('Query error: ' + e.getMessage());
        }
    }
    
    // ListException
    public static void listExceptionExample() {
        try {
            List<String> items = new List<String>{'A', 'B', 'C'};
            String value = items[10];  // Index out of bounds
        } catch (ListException e) {
            System.debug('List error: ' + e.getMessage());
        }
    }
    
    // TypeException
    public static void typeExceptionExample() {
        try {
            Object obj = 'Hello';
            Integer num = (Integer)obj;  // Invalid cast
        } catch (TypeException e) {
            System.debug('Type error: ' + e.getMessage());
        }
    }
}

// ========== CUSTOM EXCEPTIONS ==========
public class InsufficientFundsException extends Exception {}
public class ValidationException extends Exception {}
public class BusinessRuleException extends Exception {}

public class CustomExceptionExamples {
    
    public static void withdraw(Decimal balance, Decimal amount) {
        if (amount > balance) {
            throw new InsufficientFundsException('Insufficient funds. Balance: ' + balance);
        }
        // Process withdrawal
        System.debug('Withdrawal successful');
    }
    
    public static void validateAge(Integer age) {
        if (age < 0) {
            throw new ValidationException('Age cannot be negative');
        }
        if (age > 150) {
            throw new ValidationException('Age seems invalid');
        }
        System.debug('Age is valid');
    }
    
    public static void useCustomExceptions() {
        try {
            withdraw(100, 150);
        } catch (InsufficientFundsException e) {
            System.debug('Custom error: ' + e.getMessage());
        }
        
        try {
            validateAge(-5);
        } catch (ValidationException e) {
            System.debug('Validation error: ' + e.getMessage());
        }
    }
}

// ========== EXCEPTION METHODS ==========
public class ExceptionMethods {
    
    public static void exceptionInfo() {
        try {
            Integer result = 10 / 0;
        } catch (Exception e) {
            // Get message
            String message = e.getMessage();
            
            // Get stack trace
            String stackTrace = e.getStackTraceString();
            
            // Get exception type
            String typeName = e.getTypeName();
            
            // Get line number
            Integer lineNumber = e.getLineNumber();
            
            System.debug('Message: ' + message);
            System.debug('Type: ' + typeName);
            System.debug('Line: ' + lineNumber);
            System.debug('Stack trace: ' + stackTrace);
        }
    }
}

// ========== DML EXCEPTION HANDLING ==========
public class DMLExceptionHandling {
    
    // Handle DML errors
    public static void handleDMLErrors() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Valid Account'));
        accounts.add(new Account());  // Invalid - missing Name
        accounts.add(new Account(Name='Another Valid'));
        
        try {
            insert accounts;
        } catch (DMLException e) {
            System.debug('Number of failures: ' + e.getNumDml());
            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug('Failed record index: ' + e.getDmlIndex(i));
                System.debug('Error message: ' + e.getDmlMessage(i));
                System.debug('Field causing error: ' + e.getDmlFieldNames(i));
            }
        }
    }
    
    // Partial success with Database methods
    public static void partialSuccessDML() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Valid 1'));
        accounts.add(new Account());  // Invalid
        accounts.add(new Account(Name='Valid 2'));
        
        Database.SaveResult[] results = Database.insert(accounts, false);
        
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Success: ' + accounts[i].Name);
            } else {
                for (Database.Error err : results[i].getErrors()) {
                    System.debug('Error on index ' + i + ': ' + err.getMessage());
                }
            }
        }
    }
}

// ========== ERROR HANDLING PATTERNS ==========
public class ErrorHandlingPatterns {
    
    // Guard clauses
    public static void processAccount(Account acc) {
        if (acc == null) {
            throw new ValidationException('Account cannot be null');
        }
        
        if (String.isBlank(acc.Name)) {
            throw new ValidationException('Account name is required');
        }
        
        // Process account
        System.debug('Processing: ' + acc.Name);
    }
    
    // Fail fast
    public static Decimal divide(Decimal a, Decimal b) {
        if (b == 0) {
            throw new MathException('Cannot divide by zero');
        }
        return a / b;
    }
    
    // Try-catch with retry logic
    public static void retryOperation() {
        Integer maxRetries = 3;
        Integer attempt = 0;
        Boolean success = false;
        
        while (attempt < maxRetries && !success) {
            try {
                attempt++;
                // Perform operation
                performRiskyOperation();
                success = true;
            } catch (Exception e) {
                System.debug('Attempt ' + attempt + ' failed: ' + e.getMessage());
                if (attempt >= maxRetries) {
                    throw e;  // Re-throw on final attempt
                }
            }
        }
    }
    
    private static void performRiskyOperation() {
        // Simulated operation
    }
    
    // Wrap and rethrow
    public static void wrapException() {
        try {
            // Low-level operation
            Integer result = 10 / 0;
        } catch (Exception e) {
            throw new BusinessRuleException('Business operation failed: ' + e.getMessage());
        }
    }
}

// ========== LOGGING AND DEBUGGING ==========
public class ExceptionLogging {
    
    public static void logException(Exception e) {
        System.debug('=== EXCEPTION LOGGED ===');
        System.debug('Type: ' + e.getTypeName());
        System.debug('Message: ' + e.getMessage());
        System.debug('Line: ' + e.getLineNumber());
        System.debug('Stack Trace:\n' + e.getStackTraceString());
        System.debug('========================');
    }
    
    public static void exampleWithLogging() {
        try {
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Test'];
        } catch (QueryException e) {
            logException(e);
            // Optionally create error record in database
        }
    }
}

// ========== BEST PRACTICES ==========
public class ExceptionBestPractices {
    
    // DON'T: Catch generic Exception without specific handling
    public static void badPractice() {
        try {
            // Some code
        } catch (Exception e) {
            System.debug('Error occurred');  // BAD: loses error details
        }
    }
    
    // DO: Catch specific exceptions
    public static void goodPractice() {
        try {
            Account acc = [SELECT Id FROM Account WHERE Name = 'Test'];
        } catch (QueryException e) {
            System.debug('No records found: ' + e.getMessage());
            // Handle specific case
        } catch (Exception e) {
            System.debug('Unexpected error: ' + e.getMessage());
            throw e;  // Re-throw unexpected errors
        }
    }
    
    // DO: Always clean up resources
    public static void resourceCleanup() {
        Savepoint sp = Database.setSavepoint();
        try {
            // Operations
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }
}

/* USAGE EXAMPLES:

// Basic
BasicExceptionHandling.basicTryCatch();
BasicExceptionHandling.finallyBlock();

// Common exceptions
CommonExceptions.nullPointerExample();
CommonExceptions.dmlExceptionExample();

// Custom exceptions
CustomExceptionExamples.useCustomExceptions();

// Exception methods
ExceptionMethods.exceptionInfo();

// DML exceptions
DMLExceptionHandling.handleDMLErrors();
DMLExceptionHandling.partialSuccessDML();

// Patterns
try {
    ErrorHandlingPatterns.divide(10, 0);
} catch (MathException e) {
    System.debug('Math error: ' + e.getMessage());
}

// Logging
ExceptionLogging.exampleWithLogging();
*/
