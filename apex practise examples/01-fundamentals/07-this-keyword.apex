/**
 * 07 - this Keyword
 * Demonstrates: Using this to reference current instance
 */

public class ThisKeywordExample {
    private String name;
    private Integer value;
    
    // Using 'this' to distinguish parameter from field
    public ThisKeywordExample(String name, Integer value) {
        this.name = name;     // 'this.name' refers to instance variable
        this.value = value;   // 'name' and 'value' are parameters
    }
    
    // Method chaining with 'this'
    public ThisKeywordExample setName(String name) {
        this.name = name;
        return this;  // Return current instance for chaining
    }
    
    public ThisKeywordExample setValue(Integer value) {
        this.value = value;
        return this;
    }
    
    // Calling another constructor
    public ThisKeywordExample(String name) {
        this(name, 0);  // Calls the two-parameter constructor
    }
    
    public String getInfo() {
        return this.name + ': ' + this.value;
    }
    
    // Passing current instance to another method
    public void processThis() {
        HelperClass.process(this);
    }
}

public class HelperClass {
    public static void process(ThisKeywordExample obj) {
        System.debug('Processing: ' + obj.getInfo());
    }
}

/* USAGE EXAMPLE:
// Method chaining
ThisKeywordExample obj = new ThisKeywordExample('Test', 5)
    .setName('Updated')
    .setValue(10);
System.debug(obj.getInfo()); // Updated: 10

// Constructor chaining
ThisKeywordExample obj2 = new ThisKeywordExample('Simple');
System.debug(obj2.getInfo()); // Simple: 0
*/
