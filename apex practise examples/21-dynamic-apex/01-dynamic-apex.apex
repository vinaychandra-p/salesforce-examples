/**
 * 21 - DYNAMIC APEX - Runtime Reflection & Dynamic SOQL/DML
 * Schema describe, Type class, dynamic queries, field sets
 */

// ========== SCHEMA DESCRIBE ==========
public class SchemaDescribeExamples {
    
    public static void describeObject() {
        Schema.DescribeSObjectResult accountDesc = Account.sObjectType.getDescribe();
        
        System.debug('Object Name: ' + accountDesc.getName());
        System.debug('Label: ' + accountDesc.getLabel());
        System.debug('Plural Label: ' + accountDesc.getLabelPlural());
        System.debug('Is Custom: ' + accountDesc.isCustom());
        System.debug('Is Createable: ' + accountDesc.isCreateable());
        System.debug('Is Updateable: ' + accountDesc.isUpdateable());
        System.debug('Is Deletable: ' + accountDesc.isDeletable());
    }
    
    public static void describeFields() {
        Map<String, Schema.SObjectField> fieldMap = Account.sObjectType.getDescribe().fields.getMap();
        
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
            
            System.debug('Field: ' + fieldDesc.getName());
            System.debug('Label: ' + fieldDesc.getLabel());
            System.debug('Type: ' + fieldDesc.getType());
            System.debug('Length: ' + fieldDesc.getLength());
            System.debug('Is Required: ' + fieldDesc.isNillable() == false);
            System.debug('---');
        }
    }
    
    public static void checkFieldAccess() {
        Schema.DescribeFieldResult fieldDesc = Account.Name.getDescribe();
        
        if (fieldDesc.isAccessible()) {
            System.debug('User can read this field');
        }
        
        if (fieldDesc.isCreateable()) {
            System.debug('User can set this field on insert');
        }
        
        if (fieldDesc.isUpdateable()) {
            System.debug('User can update this field');
        }
    }
}

// ========== GLOBAL DESCRIBE ==========
public class GlobalDescribeExamples {
    
    public static void getAllObjects() {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        
        for (String objectName : globalDescribe.keySet()) {
            System.debug('Object: ' + objectName);
        }
    }
    
    public static Schema.SObjectType getObjectType(String objectName) {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        return globalDescribe.get(objectName);
    }
    
    public static Boolean objectExists(String objectName) {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        return globalDescribe.containsKey(objectName.toLowerCase());
    }
}

// ========== DYNAMIC SOQL ==========
public class DynamicSOQL {
    
    public static List<sObject> queryByObjectName(String objectName) {
        String query = 'SELECT Id, Name FROM ' + objectName + ' LIMIT 10';
        List<sObject> records = Database.query(query);
        return records;
    }
    
    public static List<sObject> queryWithConditions(String objectName, String fieldName, String fieldValue) {
        String query = 'SELECT Id, Name FROM ' + objectName + 
                      ' WHERE ' + fieldName + ' = :fieldValue LIMIT 100';
        List<sObject> records = Database.query(query);
        return records;
    }
    
    public static List<sObject> buildDynamicQuery(String objectName, List<String> fields, String whereClause) {
        // Build field list
        String fieldList = String.join(fields, ', ');
        
        // Build query
        String query = 'SELECT ' + fieldList + ' FROM ' + objectName;
        
        if (String.isNotBlank(whereClause)) {
            query += ' WHERE ' + whereClause;
        }
        
        query += ' LIMIT 100';
        
        System.debug('Query: ' + query);
        return Database.query(query);
    }
    
    public static List<sObject> queryAllFields(String objectName) {
        // Get all fields
        Map<String, Schema.SObjectField> fieldMap = 
            Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        List<String> fieldNames = new List<String>(fieldMap.keySet());
        String query = 'SELECT ' + String.join(fieldNames, ', ') + 
                      ' FROM ' + objectName + ' LIMIT 1';
        
        return Database.query(query);
    }
}

// ========== DYNAMIC DML ==========
public class DynamicDML {
    
    public static void dynamicInsert(String objectName, Map<String, Object> fieldValues) {
        // Get object type
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        
        // Create instance
        sObject obj = objType.newSObject();
        
        // Set field values
        for (String fieldName : fieldValues.keySet()) {
            obj.put(fieldName, fieldValues.get(fieldName));
        }
        
        insert obj;
        System.debug('Inserted: ' + obj.Id);
    }
    
    public static void dynamicUpdate(String recordId, String objectName, Map<String, Object> fieldValues) {
        String query = 'SELECT Id FROM ' + objectName + ' WHERE Id = :recordId';
        sObject obj = Database.query(query);
        
        for (String fieldName : fieldValues.keySet()) {
            obj.put(fieldName, fieldValues.get(fieldName));
        }
        
        update obj;
    }
    
    public static void bulkDynamicInsert(String objectName, List<Map<String, Object>> records) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        List<sObject> objectsToInsert = new List<sObject>();
        
        for (Map<String, Object> record : records) {
            sObject obj = objType.newSObject();
            for (String fieldName : record.keySet()) {
                obj.put(fieldName, record.get(fieldName));
            }
            objectsToInsert.add(obj);
        }
        
        insert objectsToInsert;
    }
}

// ========== TYPE CLASS ==========
public class TypeClassExamples {
    
    public static void useTypeClass() {
        Type accountType = Type.forName('Account');
        System.debug('Type: ' + accountType.getName());
        
        // Create instance
        Object obj = accountType.newInstance();
        Account acc = (Account) obj;
        acc.Name = 'Dynamic Account';
        
        System.debug('Created: ' + acc);
    }
    
    public static void checkType() {
        Object obj = new Account(Name='Test');
        
        if (obj instanceof Account) {
            System.debug('Object is an Account');
        }
        
        // Using Type
        Type objType = obj.getClass();
        System.debug('Object type: ' + objType.getName());
    }
    
    public static Object createInstance(String className) {
        Type classType = Type.forName(className);
        if (classType != null) {
            return classType.newInstance();
        }
        return null;
    }
}

// ========== FIELD SETS ==========
public class FieldSetExamples {
    
    public static List<Schema.FieldSetMember> getFieldSetFields(String objectName, String fieldSetName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        
        Map<String, Schema.FieldSet> fieldSets = describeResult.fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSets.get(fieldSetName);
        
        if (fieldSet != null) {
            return fieldSet.getFields();
        }
        return new List<Schema.FieldSetMember>();
    }
    
    public static String buildQueryFromFieldSet(String objectName, String fieldSetName) {
        List<Schema.FieldSetMember> fields = getFieldSetFields(objectName, fieldSetName);
        
        List<String> fieldNames = new List<String>();
        for (Schema.FieldSetMember field : fields) {
            fieldNames.add(field.getFieldPath());
        }
        
        return 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + objectName;
    }
}

// ========== PICKLIST VALUES ==========
public class PicklistExamples {
    
    public static void getPicklistValues(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
        
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistValues) {
            System.debug('Value: ' + entry.getValue());
            System.debug('Label: ' + entry.getLabel());
            System.debug('Is Active: ' + entry.isActive());
            System.debug('Is Default: ' + entry.isDefaultValue());
        }
    }
    
    public static List<String> getActivePicklistValues(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
        
        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
            if (entry.isActive()) {
                values.add(entry.getValue());
            }
        }
        return values;
    }
}

// ========== RECORD TYPE ==========
public class RecordTypeExamples {
    
    public static void getRecordTypes(String objectName) {
        Schema.DescribeSObjectResult describeResult = 
            Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        Map<String, Schema.RecordTypeInfo> recordTypes = describeResult.getRecordTypeInfosByName();
        
        for (String rtName : recordTypes.keySet()) {
            Schema.RecordTypeInfo rtInfo = recordTypes.get(rtName);
            System.debug('Record Type: ' + rtName);
            System.debug('Id: ' + rtInfo.getRecordTypeId());
            System.debug('Is Available: ' + rtInfo.isAvailable());
            System.debug('Is Default: ' + rtInfo.isDefaultRecordTypeMapping());
        }
    }
    
    public static Id getRecordTypeId(String objectName, String recordTypeName) {
        Schema.DescribeSObjectResult describeResult = 
            Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        return describeResult.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
}

// ========== DYNAMIC APEX UTILITY ==========
public class DynamicApexUtils {
    
    // Check if field exists
    public static Boolean fieldExists(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType != null) {
            Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
            return fieldMap.containsKey(fieldName.toLowerCase());
        }
        return false;
    }
    
    // Get field type
    public static Schema.DisplayType getFieldType(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        return fieldMap.get(fieldName.toLowerCase()).getDescribe().getType();
    }
    
    // Get field label
    public static String getFieldLabel(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        return fieldMap.get(fieldName.toLowerCase()).getDescribe().getLabel();
    }
    
    // Check if object is custom
    public static Boolean isCustomObject(String objectName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType != null) {
            return objType.getDescribe().isCustom();
        }
        return false;
    }
    
    // Get relationship name
    public static String getRelationshipName(String objectName, String fieldName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName.toLowerCase()).getDescribe();
        return fieldDesc.getRelationshipName();
    }
}

// ========== DYNAMIC VALIDATION ==========
public class DynamicValidation {
    
    public static Boolean validateRequiredFields(sObject obj) {
        Schema.DescribeSObjectResult describeResult = obj.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDesc = field.getDescribe();
            
            // Check if required
            if (!fieldDesc.isNillable() && fieldDesc.isCreateable()) {
                Object value = obj.get(fieldDesc.getName());
                if (value == null) {
                    System.debug('Required field missing: ' + fieldDesc.getLabel());
                    return false;
                }
            }
        }
        return true;
    }
    
    public static List<String> getRequiredFields(String objectName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        
        List<String> requiredFields = new List<String>();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDesc = field.getDescribe();
            if (!fieldDesc.isNillable() && fieldDesc.isCreateable()) {
                requiredFields.add(fieldDesc.getName());
            }
        }
        return requiredFields;
    }
}

/* DYNAMIC APEX USE CASES:
1. Multi-object utilities
2. Dynamic forms/pages
3. Metadata-driven logic
4. Integration tools
5. Admin/config interfaces
6. Generic data loaders
7. Dynamic reports
8. Field-level security checks

PERFORMANCE CONSIDERATIONS:
- Describe calls are cached per transaction
- Global describe is expensive
- Use describe sparingly
- Cache describe results
- Avoid in loops

SECURITY:
- Always check FLS (Field Level Security)
- Use with sharing
- Validate user permissions
- Sanitize dynamic SOQL
*/
