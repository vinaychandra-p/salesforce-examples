/**
 * 04 - Method Overloading
 * Demonstrates: Multiple methods with same name but different parameters
 */

public class MethodOverloadingExample {
    // Method with no parameters
    public String greet() {
        return 'Hello!';
    }
    
    // Method with one parameter
    public String greet(String name) {
        return 'Hello, ' + name + '!';
    }
    
    // Method with two parameters
    public String greet(String firstName, String lastName) {
        return 'Hello, ' + firstName + ' ' + lastName + '!';
    }
    
    // Method with different parameter type
    public String greet(Integer age) {
        return 'Hello, ' + age + '-year-old!';
    }
    
    // Calculate sum - two integers
    public Integer add(Integer a, Integer b) {
        return a + b;
    }
    
    // Calculate sum - three integers
    public Integer add(Integer a, Integer b, Integer c) {
        return a + b + c;
    }
    
    // Calculate sum - two decimals
    public Decimal add(Decimal a, Decimal b) {
        return a + b;
    }
}

/* USAGE EXAMPLE:
MethodOverloadingExample example = new MethodOverloadingExample();

System.debug(example.greet()); // Hello!
System.debug(example.greet('Alice')); // Hello, Alice!
System.debug(example.greet('Bob', 'Smith')); // Hello, Bob Smith!
System.debug(example.greet(25)); // Hello, 25-year-old!

System.debug(example.add(5, 10)); // 15
System.debug(example.add(5, 10, 15)); // 30
System.debug(example.add(5.5, 10.2)); // 15.7
*/
