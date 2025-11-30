/**
 * 02 - Access Modifiers
 * Demonstrates: public, private, protected, global modifiers
 */

public class AccessModifiersExample {
    // Public: Accessible within same namespace
    public String publicField = 'Public';
    
    // Private: Only accessible within this class
    private String privateField = 'Private';
    
    // Protected: Not used in Apex (use private instead)
    // Apex doesn't support protected
    
    // Global: Accessible across all namespaces (use sparingly)
    // global String globalField = 'Global';
    
    // Public method
    public String getPublicField() {
        return this.publicField;
    }
    
    // Private method (helper method)
    private String getPrivateField() {
        return this.privateField;
    }
    
    // Public method using private method
    public String getAllFields() {
        return 'Public: ' + getPublicField() + ', Private: ' + getPrivateField();
    }
    
    // Static vs Instance
    public static String staticMethod() {
        return 'Static method - no instance needed';
    }
    
    public String instanceMethod() {
        return 'Instance method - requires object';
    }
}

/* USAGE EXAMPLE:
AccessModifiersExample example = new AccessModifiersExample();
System.debug(example.publicField); // 'Public'
// System.debug(example.privateField); // ERROR: not accessible
System.debug(example.getAllFields());
System.debug(AccessModifiersExample.staticMethod()); // No instance needed
*/
