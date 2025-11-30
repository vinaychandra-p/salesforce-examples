/**
 * 01 - Basic Class Structure
 * Demonstrates: Class declaration, properties, methods, constructors
 */

public class BasicExample {
    // Class variables (properties)
    private String name;
    private Integer age;
    
    // Constructor
    public BasicExample(String name, Integer age) {
        this.name = name;
        this.age = age;
    }
    
    // Default constructor
    public BasicExample() {
        this('Unknown', 0);
    }
    
    // Getter methods
    public String getName() {
        return this.name;
    }
    
    public Integer getAge() {
        return this.age;
    }
    
    // Setter methods
    public void setName(String name) {
        this.name = name;
    }
    
    public void setAge(Integer age) {
        if (age >= 0) {
            this.age = age;
        }
    }
    
    // Instance method
    public String getInfo() {
        return 'Name: ' + this.name + ', Age: ' + this.age;
    }
    
    // Static method
    public static String getClassName() {
        return 'BasicExample';
    }
}

/* USAGE EXAMPLE (Execute Anonymous):
BasicExample person = new BasicExample('John', 30);
System.debug(person.getInfo()); // Name: John, Age: 30
person.setAge(31);
System.debug(person.getAge()); // 31
System.debug(BasicExample.getClassName()); // BasicExample
*/
