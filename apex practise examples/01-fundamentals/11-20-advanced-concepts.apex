/**
 * 11-20 - Additional Fundamental Concepts
 * Combined file with inheritance, abstract classes, polymorphism, and more
 */

// ========== 11. ABSTRACT CLASSES ==========
public abstract class Animal {
    protected String name;
    
    public Animal(String name) {
        this.name = name;
    }
    
    // Abstract method (must be implemented by subclasses)
    public abstract void makeSound();
    
    // Concrete method (inherited by subclasses)
    public void sleep() {
        System.debug(name + ' is sleeping');
    }
}

public class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }
    
    public override void makeSound() {
        System.debug(name + ' says: Woof!');
    }
}

// ========== 12. INHERITANCE ==========
public virtual class Vehicle {
    protected String brand;
    protected Integer year;
    
    public Vehicle(String brand, Integer year) {
        this.brand = brand;
        this.year = year;
    }
    
    public virtual String getInfo() {
        return year + ' ' + brand;
    }
}

public class Car extends Vehicle {
    private Integer doors;
    
    public Car(String brand, Integer year, Integer doors) {
        super(brand, year);  // Call parent constructor
        this.doors = doors;
    }
    
    public override String getInfo() {
        return super.getInfo() + ' (' + doors + ' doors)';
    }
}

// ========== 13. POLYMORPHISM ==========
public class PolymorphismExample {
    public static void demonstratePolymorphism() {
        // Parent reference, child object
        Vehicle v1 = new Vehicle('Generic', 2020);
        Vehicle v2 = new Car('Toyota', 2023, 4);
        
        System.debug(v1.getInfo()); // 2020 Generic
        System.debug(v2.getInfo()); // 2023 Toyota (4 doors)
        
        // List of parent type holding child objects
        List<Vehicle> vehicles = new List<Vehicle>{
            new Vehicle('Brand1', 2020),
            new Car('Brand2', 2021, 2),
            new Car('Brand3', 2022, 4)
        };
        
        for (Vehicle v : vehicles) {
            System.debug(v.getInfo());
        }
    }
}

// ========== 14. INNER CLASSES ==========
public class OuterClass {
    private String outerField = 'Outer';
    
    public class InnerClass {
        private String innerField = 'Inner';
        
        public String getOuterField() {
            return outerField;  // Can access outer class members
        }
        
        public String getBoth() {
            return outerField + ' - ' + innerField;
        }
    }
    
    public void useInnerClass() {
        InnerClass inner = new InnerClass();
        System.debug(inner.getBoth());
    }
}

// ========== 15. WITH/WITHOUT SHARING ==========
public with sharing class WithSharingExample {
    // Enforces user's sharing rules
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account LIMIT 10];
    }
}

public without sharing class WithoutSharingExample {
    // Bypasses user's sharing rules (system context)
    public static List<Account> getAllAccounts() {
        return [SELECT Id, Name FROM Account LIMIT 10];
    }
}

public inherited sharing class InheritedSharingExample {
    // Inherits sharing from calling class
    public static void processRecords() {
        System.debug('Uses caller\'s sharing context');
    }
}

// ========== 16. INSTANCEOF OPERATOR ==========
public class InstanceOfExample {
    public static void checkType(Object obj) {
        if (obj instanceof String) {
            System.debug('It\'s a String: ' + (String)obj);
        } else if (obj instanceof Integer) {
            System.debug('It\'s an Integer: ' + (Integer)obj);
        } else if (obj instanceof Account) {
            System.debug('It\'s an Account: ' + ((Account)obj).Name);
        } else {
            System.debug('Unknown type');
        }
    }
}

// ========== 17. TYPE CASTING ==========
public class CastingExample {
    public static void demonstrateCasting() {
        // Implicit casting (widening)
        Integer intValue = 100;
        Long longValue = intValue;  // int -> long
        Decimal decValue = intValue; // int -> decimal
        
        // Explicit casting (narrowing)
        Decimal dec = 10.99;
        Integer intFromDec = (Integer)dec;  // 10 (loses decimal part)
        
        // Object casting
        Vehicle vehicle = new Car('Honda', 2023, 4);
        if (vehicle instanceof Car) {
            Car car = (Car)vehicle;  // Downcast
            System.debug(car.getInfo());
        }
    }
}

// ========== 18. WRAPPER CLASSES ==========
public class ContactWrapper {
    public Contact con { get; set; }
    public Boolean selected { get; set; }
    
    public ContactWrapper(Contact c) {
        this.con = c;
        this.selected = false;
    }
}

public class WrapperExample {
    public static List<ContactWrapper> getWrappedContacts() {
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact LIMIT 5];
        List<ContactWrapper> wrappers = new List<ContactWrapper>();
        
        for (Contact c : contacts) {
            wrappers.add(new ContactWrapper(c));
        }
        
        return wrappers;
    }
}

/* USAGE EXAMPLES:

// Abstract classes
Dog myDog = new Dog('Buddy');
myDog.makeSound(); // Buddy says: Woof!
myDog.sleep(); // Buddy is sleeping

// Inheritance & Polymorphism
PolymorphismExample.demonstratePolymorphism();

// Inner classes
OuterClass outer = new OuterClass();
OuterClass.InnerClass inner = outer.new InnerClass();
System.debug(inner.getBoth());

// instanceof
InstanceOfExample.checkType('Hello');
InstanceOfExample.checkType(42);

// Casting
CastingExample.demonstrateCasting();

// Wrapper classes
List<ContactWrapper> wrapped = WrapperExample.getWrappedContacts();
wrapped[0].selected = true;
*/
