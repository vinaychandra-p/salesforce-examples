/**
 * 05 - Constants and Final Variables
 * Demonstrates: final keyword, constants, naming conventions
 */

public class ConstantsExample {
    // Constants (public static final)
    public static final String APP_NAME = 'Salesforce App';
    public static final Integer MAX_RECORDS = 200;
    public static final Decimal TAX_RATE = 0.08;
    
    // Private constants
    private static final String API_VERSION = '65.0';
    private static final Integer TIMEOUT_SECONDS = 120;
    
    // Instance final variable (set in constructor, can't change after)
    private final String userId;
    
    public ConstantsExample(String userId) {
        this.userId = userId;
        // this.userId = 'different'; // ERROR: can't reassign final variable
    }
    
    public String getUserId() {
        return this.userId;
    }
    
    public static Decimal calculateTax(Decimal amount) {
        return amount * TAX_RATE;
    }
    
    public static String getApiVersion() {
        return API_VERSION;
    }
}

/* USAGE EXAMPLE:
System.debug(ConstantsExample.APP_NAME); // Salesforce App
System.debug(ConstantsExample.MAX_RECORDS); // 200

Decimal price = 100.00;
Decimal tax = ConstantsExample.calculateTax(price);
System.debug('Tax: ' + tax); // Tax: 8.00

ConstantsExample example = new ConstantsExample('005xx000001ABC123');
System.debug(example.getUserId());

// ConstantsExample.MAX_RECORDS = 300; // ERROR: can't modify final variable
*/
