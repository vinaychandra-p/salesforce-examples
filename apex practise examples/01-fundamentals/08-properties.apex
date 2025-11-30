/**
 * 08 - Properties (Get/Set)
 * Demonstrates: Automatic properties, custom get/set, read-only, write-only
 */

public class PropertiesExample {
    // Automatic property (creates private variable automatically)
    public String AutoProperty { get; set; }
    
    // Read-only property (only get)
    public String ReadOnlyProperty { get; private set; }
    
    // Write-only property (only set)
    public String WriteOnlyProperty { private get; set; }
    
    // Custom property with validation
    private Integer ageValue;
    public Integer Age {
        get {
            return ageValue;
        }
        set {
            if (value >= 0 && value <= 150) {
                ageValue = value;
            } else {
                throw new IllegalArgumentException('Age must be between 0 and 150');
            }
        }
    }
    
    // Computed property (no backing field)
    private Decimal price;
    private Decimal taxRate = 0.08;
    
    public Decimal Price {
        get { return price; }
        set { price = value; }
    }
    
    public Decimal TotalPrice {
        get {
            return price * (1 + taxRate);
        }
    }
    
    // Constructor
    public PropertiesExample(String readOnly) {
        this.ReadOnlyProperty = readOnly;
        this.ageValue = 0;
        this.price = 0;
    }
}

/* USAGE EXAMPLE:
PropertiesExample example = new PropertiesExample('Constant');

// Automatic property
example.AutoProperty = 'Value';
System.debug(example.AutoProperty); // Value

// Read-only property
System.debug(example.ReadOnlyProperty); // Constant
// example.ReadOnlyProperty = 'New'; // ERROR: read-only

// Custom property with validation
example.Age = 25;
System.debug(example.Age); // 25
// example.Age = 200; // ERROR: throws exception

// Computed property
example.Price = 100;
System.debug(example.TotalPrice); // 108.0 (100 * 1.08)
*/
