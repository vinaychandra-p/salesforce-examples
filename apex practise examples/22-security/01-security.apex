/**
 * 22 - SECURITY - FLS, CRUD, Sharing, Injection Prevention
 * Field-level security, object permissions, sharing rules, secure coding
 */

// ========== SHARING KEYWORDS ==========

// WITH SHARING - Respects user's sharing rules
public with sharing class WithSharingExample {
    public List<Account> getAccounts() {
        // Only returns accounts user has access to
        return [SELECT Id, Name FROM Account];
    }
}

// WITHOUT SHARING - Runs in system mode
public without sharing class WithoutSharingExample {
    public List<Account> getAllAccounts() {
        // Returns all accounts regardless of user access
        return [SELECT Id, Name FROM Account];
    }
}

// INHERITED SHARING - Respects caller's sharing context
public inherited sharing class InheritedSharingExample {
    public List<Account> getAccounts() {
        // Inherits sharing from calling class
        return [SELECT Id, Name FROM Account];
    }
}

// ========== FIELD-LEVEL SECURITY (FLS) ==========
public class FieldLevelSecurityExamples {
    
    // Check read access
    public static void checkReadAccess() {
        if (Schema.sObjectType.Account.fields.Name.isAccessible()) {
            Account acc = [SELECT Name FROM Account LIMIT 1];
            System.debug('Name: ' + acc.Name);
        } else {
            System.debug('User cannot read Name field');
        }
    }
    
    // Check create access
    public static void checkCreateAccess() {
        Account acc = new Account();
        
        if (Schema.sObjectType.Account.fields.Name.isCreateable()) {
            acc.Name = 'New Account';
        }
        
        if (Schema.sObjectType.Account.fields.Industry.isCreateable()) {
            acc.Industry = 'Technology';
        }
        
        if (Schema.sObjectType.Account.isCreateable()) {
            insert acc;
        }
    }
    
    // Check update access
    public static void checkUpdateAccess(Id accountId) {
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new SecurityException('No read access to Account');
        }
        
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];
        
        if (Schema.sObjectType.Account.fields.Name.isUpdateable()) {
            acc.Name = 'Updated Name';
        }
        
        if (Schema.sObjectType.Account.isUpdateable()) {
            update acc;
        }
    }
    
    // Bulk FLS check
    public static void bulkFLSCheck(List<String> fieldNames) {
        Map<String, Schema.SObjectField> fieldMap = 
            Schema.sObjectType.Account.fields.getMap();
        
        for (String fieldName : fieldNames) {
            Schema.DescribeFieldResult fieldDescribe = 
                fieldMap.get(fieldName).getDescribe();
            
            if (!fieldDescribe.isAccessible()) {
                throw new SecurityException('No access to field: ' + fieldName);
            }
        }
    }
}

// ========== CRUD PERMISSIONS ==========
public class CRUDPermissionsExample {
    
    public static void checkAllCRUD() {
        // Create
        if (Schema.sObjectType.Account.isCreateable()) {
            System.debug('User can create Accounts');
        }
        
        // Read
        if (Schema.sObjectType.Account.isAccessible()) {
            System.debug('User can read Accounts');
        }
        
        // Update
        if (Schema.sObjectType.Account.isUpdateable()) {
            System.debug('User can update Accounts');
        }
        
        // Delete
        if (Schema.sObjectType.Account.isDeletable()) {
            System.debug('User can delete Accounts');
        }
    }
    
    public static void secureQuery() {
        // Check read access before query
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new SecurityException('No read access to Account');
        }
        
        // Check field access
        if (!Schema.sObjectType.Account.fields.Name.isAccessible() ||
            !Schema.sObjectType.Account.fields.Industry.isAccessible()) {
            throw new SecurityException('No access to required fields');
        }
        
        // Safe to query
        List<Account> accounts = [SELECT Id, Name, Industry FROM Account];
    }
}

// ========== SECURITY UTILITY CLASS ==========
public class SecurityUtils {
    
    public static void enforceObjectCRUD(Schema.SObjectType objType, String operation) {
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        
        if (operation == 'CREATE' && !describeResult.isCreateable()) {
            throw new SecurityException('No create permission');
        } else if (operation == 'READ' && !describeResult.isAccessible()) {
            throw new SecurityException('No read permission');
        } else if (operation == 'UPDATE' && !describeResult.isUpdateable()) {
            throw new SecurityException('No update permission');
        } else if (operation == 'DELETE' && !describeResult.isDeletable()) {
            throw new SecurityException('No delete permission');
        }
    }
    
    public static void enforceFLS(Schema.SObjectType objType, List<String> fieldNames, String operation) {
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        
        for (String fieldName : fieldNames) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName.toLowerCase()).getDescribe();
            
            if (operation == 'READ' && !fieldDescribe.isAccessible()) {
                throw new SecurityException('No read access to: ' + fieldName);
            } else if (operation == 'CREATE' && !fieldDescribe.isCreateable()) {
                throw new SecurityException('No create access to: ' + fieldName);
            } else if (operation == 'UPDATE' && !fieldDescribe.isUpdateable()) {
                throw new SecurityException('No update access to: ' + fieldName);
            }
        }
    }
    
    public static List<String> stripInaccessibleFields(Schema.SObjectType objType, List<String> fields) {
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        List<String> accessibleFields = new List<String>();
        
        for (String field : fields) {
            if (fieldMap.get(field.toLowerCase()).getDescribe().isAccessible()) {
                accessibleFields.add(field);
            }
        }
        return accessibleFields;
    }
}

// ========== SECURITY.STRIPINACCESSIBLE() ==========
public class StripInaccessibleExample {
    
    public static void stripOnQuery() {
        List<Account> accounts = [SELECT Id, Name, Industry, Revenue FROM Account];
        
        // Strip fields user can't access
        SObjectAccessDecision decision = Security.stripInaccessible(
            AccessType.READABLE,
            accounts
        );
        
        // Use sanitized records
        List<Account> sanitizedAccounts = decision.getRecords();
        
        // Check removed fields
        Map<String, Set<String>> removedFields = decision.getRemovedFields();
        if (!removedFields.isEmpty()) {
            System.debug('Removed fields: ' + removedFields);
        }
    }
    
    public static void stripOnInsert() {
        Account acc = new Account(
            Name = 'Test',
            Industry = 'Tech',
            AnnualRevenue = 1000000
        );
        
        // Strip non-createable fields
        SObjectAccessDecision decision = Security.stripInaccessible(
            AccessType.CREATABLE,
            new List<Account>{acc}
        );
        
        List<Account> sanitizedAccounts = decision.getRecords();
        insert sanitizedAccounts;
    }
    
    public static void stripOnUpdate() {
        List<Account> accounts = [SELECT Id, Name, Industry FROM Account LIMIT 1];
        accounts[0].Name = 'Updated';
        
        // Strip non-updateable fields
        SObjectAccessDecision decision = Security.stripInaccessible(
            AccessType.UPDATABLE,
            accounts
        );
        
        update decision.getRecords();
    }
}

// ========== SOQL INJECTION PREVENTION ==========
public class SOQLInjectionPrevention {
    
    // ❌ VULNERABLE - Never do this!
    public static List<Account> vulnerableQuery(String userInput) {
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userInput + '\'';
        return Database.query(query);
        // Attacker could input: ' OR '1'='1
    }
    
    // ✅ SAFE - Use bind variables
    public static List<Account> safeQuery(String userInput) {
        String query = 'SELECT Id, Name FROM Account WHERE Name = :userInput';
        return Database.query(query);
    }
    
    // ✅ SAFE - Escape special characters
    public static List<Account> escapedQuery(String userInput) {
        String escaped = String.escapeSingleQuotes(userInput);
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + escaped + '\'';
        return Database.query(query);
    }
    
    // ✅ SAFE - Static query with bind variable
    public static List<Account> staticQuery(String name) {
        return [SELECT Id, Name FROM Account WHERE Name = :name];
    }
}

// ========== XSS PREVENTION ==========
public class XSSPrevention {
    
    public static String sanitizeOutput(String userInput) {
        // Escape HTML
        String escaped = String.escapeHtml4(userInput);
        return escaped;
    }
    
    public static String sanitizeJavaScript(String userInput) {
        // Escape for JavaScript context
        String escaped = String.escapeEcmaScript(userInput);
        return escaped;
    }
    
    public static String sanitizeURL(String url) {
        // Validate URL
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
            throw new SecurityException('Invalid URL protocol');
        }
        return url;
    }
}

// ========== CSRF PREVENTION ==========
public class CSRFPrevention {
    // Use Visualforce's viewstate and action methods
    // Or use Lightning's automatic CSRF protection
    // Always validate state-changing operations
    
    public static Boolean validateToken(String token, String expectedToken) {
        return token == expectedToken;
    }
}

// ========== SECURE DATA HANDLING ==========
public class SecureDataHandling {
    
    // Encrypt sensitive data
    public static Blob encryptData(String data, Blob key) {
        Blob encryptedData = Crypto.encryptWithManagedIV(
            'AES256',
            key,
            Blob.valueOf(data)
        );
        return encryptedData;
    }
    
    // Decrypt sensitive data
    public static String decryptData(Blob encryptedData, Blob key) {
        Blob decryptedBlob = Crypto.decryptWithManagedIV(
            'AES256',
            key,
            encryptedData
        );
        return decryptedBlob.toString();
    }
    
    // Hash passwords
    public static String hashPassword(String password) {
        Blob hash = Crypto.generateDigest('SHA256', Blob.valueOf(password));
        return EncodingUtil.base64Encode(hash);
    }
    
    // Mask sensitive data in logs
    public static String maskSensitiveData(String data) {
        if (String.isBlank(data) || data.length() < 4) {
            return '****';
        }
        return data.substring(0, 2) + '****' + data.substring(data.length() - 2);
    }
}

// ========== SECURE API CLASS ==========
public with sharing class SecureAccountAPI {
    
    public static List<Account> getAccounts() {
        // Check permissions
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new SecurityException('No read access');
        }
        
        // Check field access
        List<String> fields = new List<String>{'Id', 'Name', 'Industry'};
        SecurityUtils.enforceFLS(Account.sObjectType, fields, 'READ');
        
        // Query
        List<Account> accounts = [SELECT Id, Name, Industry FROM Account];
        
        // Strip inaccessible
        return Security.stripInaccessible(AccessType.READABLE, accounts).getRecords();
    }
    
    public static void createAccount(Account acc) {
        // Check create permission
        SecurityUtils.enforceObjectCRUD(Account.sObjectType, 'CREATE');
        
        // Strip non-createable fields
        List<Account> accounts = new List<Account>{acc};
        accounts = Security.stripInaccessible(AccessType.CREATABLE, accounts).getRecords();
        
        insert accounts;
    }
    
    public static void updateAccount(Account acc) {
        // Check update permission
        SecurityUtils.enforceObjectCRUD(Account.sObjectType, 'UPDATE');
        
        // Strip non-updateable fields
        List<Account> accounts = new List<Account>{acc};
        accounts = Security.stripInaccessible(AccessType.UPDATABLE, accounts).getRecords();
        
        update accounts;
    }
}

// ========== BEST PRACTICES ==========
/*
SECURITY BEST PRACTICES:

1. SHARING
   - Use 'with sharing' by default
   - Use 'without sharing' only when needed
   - Document why 'without sharing' is used

2. CRUD & FLS
   - Always check CRUD before DML
   - Always check FLS before querying fields
   - Use Security.stripInaccessible()
   - Check permissions in service layer

3. INJECTION PREVENTION
   - Use bind variables in SOQL
   - Use String.escapeSingleQuotes()
   - Never concatenate user input in queries
   - Validate and sanitize all inputs

4. XSS PREVENTION
   - Escape output in Visualforce
   - Use Lightning's auto-escaping
   - Use String.escapeHtml4()
   - Use String.escapeEcmaScript()

5. SENSITIVE DATA
   - Encrypt sensitive fields
   - Use Platform Encryption
   - Mask data in logs
   - Don't log passwords/tokens

6. API SECURITY
   - Validate all inputs
   - Check permissions
   - Use HTTPS only
   - Implement rate limiting

7. GENERAL
   - Follow principle of least privilege
   - Review profiles and permission sets
   - Audit security regularly
   - Keep dependencies updated
   - Use managed packages when possible
*/

// Custom exception
public class SecurityException extends Exception {}
