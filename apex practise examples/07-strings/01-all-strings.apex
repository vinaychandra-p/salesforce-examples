/**
 * 07 - STRINGS - Comprehensive Examples
 * String methods, manipulation, formatting, parsing
 */

// ========== STRING BASICS ==========
public class StringBasics {
    
    public static void stringCreation() {
        // Literal
        String str1 = 'Hello';
        
        // Constructor
        String str2 = String.valueOf('World');
        
        // Concatenation
        String str3 = str1 + ' ' + str2;
        
        // Empty string
        String empty = '';
        
        // Null vs empty
        String nullStr = null;
        System.debug('Is null: ' + (nullStr == null));
        System.debug('Is empty: ' + (empty.length() == 0));
    }
    
    public static void stringLength() {
        String text = 'Hello World';
        Integer len = text.length();
        System.debug('Length: ' + len); // 11
        
        // Check empty
        Boolean isEmpty = (text.length() == 0);
        System.debug('Is empty: ' + isEmpty);
    }
}

// ========== STRING METHODS ==========
public class StringMethods {
    
    // Case conversion
    public static void caseConversion() {
        String text = 'Hello World';
        
        String upper = text.toUpperCase();    // HELLO WORLD
        String lower = text.toLowerCase();    // hello world
        
        // Capitalize first letter
        String capitalized = text.substring(0, 1).toUpperCase() + 
                           text.substring(1).toLowerCase();
        
        System.debug('Upper: ' + upper);
        System.debug('Lower: ' + lower);
        System.debug('Capitalized: ' + capitalized);
    }
    
    // Substring
    public static void substringExamples() {
        String text = 'Hello World';
        
        String sub1 = text.substring(0, 5);   // Hello
        String sub2 = text.substring(6);      // World
        
        // First 3 characters
        String first3 = text.substring(0, 3); // Hel
        
        // Last 5 characters
        String last5 = text.substring(text.length() - 5);
        
        System.debug('Substring(0,5): ' + sub1);
        System.debug('Substring(6): ' + sub2);
        System.debug('Last 5: ' + last5);
    }
    
    // IndexOf and contains
    public static void searchMethods() {
        String text = 'Hello World Hello';
        
        // Contains
        Boolean hasWorld = text.contains('World');  // true
        Boolean hasTest = text.contains('Test');    // false
        
        // IndexOf (first occurrence)
        Integer index1 = text.indexOf('Hello');     // 0
        Integer index2 = text.indexOf('World');     // 6
        Integer index3 = text.indexOf('Hello', 1);  // 12 (start from index 1)
        
        // LastIndexOf
        Integer lastIndex = text.lastIndexOf('Hello'); // 12
        
        System.debug('Contains World: ' + hasWorld);
        System.debug('First Hello at: ' + index1);
        System.debug('Last Hello at: ' + lastIndex);
    }
    
    // Replace
    public static void replaceMethods() {
        String text = 'Hello World';
        
        // Replace first occurrence
        String replaced1 = text.replace('Hello', 'Hi');
        
        // Replace all
        String text2 = 'apple banana apple';
        String replaced2 = text2.replaceAll('apple', 'orange');
        
        // Replace with regex
        String phone = '123-456-7890';
        String digitsOnly = phone.replaceAll('[^0-9]', '');
        
        System.debug('Replaced: ' + replaced1);
        System.debug('Replace all: ' + replaced2);
        System.debug('Digits only: ' + digitsOnly);
    }
    
    // Trim and strip
    public static void trimMethods() {
        String text = '  Hello World  ';
        
        String trimmed = text.trim();           // 'Hello World'
        String stripped = text.stripLeading();  // 'Hello World  '
        String stripped2 = text.stripTrailing(); // '  Hello World'
        
        System.debug('Original: |' + text + '|');
        System.debug('Trimmed: |' + trimmed + '|');
    }
    
    // StartsWith and EndsWith
    public static void startsEndsWithMethods() {
        String filename = 'document.pdf';
        
        Boolean isPdf = filename.endsWith('.pdf');
        Boolean isDoc = filename.startsWith('doc');
        
        System.debug('Is PDF: ' + isPdf);
        System.debug('Starts with doc: ' + isDoc);
    }
}

// ========== STRING SPLITTING AND JOINING ==========
public class StringSplitJoin {
    
    // Split string
    public static void splitExamples() {
        String csv = 'apple,banana,orange';
        List<String> fruits = csv.split(',');
        
        for (String fruit : fruits) {
            System.debug('Fruit: ' + fruit);
        }
        
        // Split with regex
        String text = 'one  two   three'; // Multiple spaces
        List<String> words = text.split('\\s+');
        System.debug('Words: ' + words);
    }
    
    // Join strings
    public static void joinExamples() {
        List<String> words = new List<String>{'Hello', 'World', 'Salesforce'};
        
        String joined = String.join(words, ' ');
        System.debug('Joined: ' + joined); // Hello World Salesforce
        
        String csv = String.join(words, ',');
        System.debug('CSV: ' + csv); // Hello,World,Salesforce
    }
}

// ========== STRING COMPARISON ==========
public class StringComparison {
    
    public static void compareStrings() {
        String str1 = 'Hello';
        String str2 = 'hello';
        String str3 = 'Hello';
        
        // Case-sensitive equality
        Boolean equal1 = (str1 == str3);              // true
        Boolean equal2 = (str1 == str2);              // false
        
        // Case-insensitive
        Boolean equalIgnoreCase = str1.equalsIgnoreCase(str2); // true
        
        // compareTo
        Integer compare1 = str1.compareTo(str3);      // 0 (equal)
        Integer compare2 = str1.compareTo(str2);      // negative (str1 < str2)
        
        System.debug('Equal (case-sensitive): ' + equal1);
        System.debug('Equal (ignore case): ' + equalIgnoreCase);
        System.debug('CompareTo: ' + compare1);
    }
}

// ========== STRING FORMATTING ==========
public class StringFormatting {
    
    // String.format
    public static void formatStrings() {
        String name = 'John';
        Integer age = 30;
        Decimal salary = 75000.50;
        
        String formatted1 = String.format('Name: {0}, Age: {1}', 
            new List<String>{name, String.valueOf(age)});
        
        String formatted2 = String.format('Salary: ${0}', 
            new List<String>{String.valueOf(salary)});
        
        System.debug(formatted1);
        System.debug(formatted2);
    }
    
    // Number formatting
    public static void numberFormatting() {
        Decimal amount = 1234567.89;
        
        // Format with commas
        String formatted = String.valueOf(amount.format());
        System.debug('Formatted: $' + formatted);
        
        // Decimal places
        String twoDecimals = amount.setScale(2).format();
        System.debug('Two decimals: $' + twoDecimals);
    }
    
    // Date formatting
    public static void dateFormatting() {
        Date today = Date.today();
        Datetime now = Datetime.now();
        
        String dateStr = today.format();
        String datetimeStr = now.format('yyyy-MM-dd HH:mm:ss');
        
        System.debug('Date: ' + dateStr);
        System.debug('Datetime: ' + datetimeStr);
    }
}

// ========== STRING PARSING ==========
public class StringParsing {
    
    // Parse numbers
    public static void parseNumbers() {
        String intStr = '123';
        Integer num = Integer.valueOf(intStr);
        
        String decStr = '123.45';
        Decimal dec = Decimal.valueOf(decStr);
        
        String longStr = '9876543210';
        Long longNum = Long.valueOf(longStr);
        
        System.debug('Integer: ' + num);
        System.debug('Decimal: ' + dec);
        System.debug('Long: ' + longNum);
    }
    
    // Parse dates
    public static void parseDates() {
        String dateStr = '2025-11-30';
        Date parsedDate = Date.valueOf(dateStr);
        
        String datetimeStr = '2025-11-30 14:30:00';
        Datetime parsedDatetime = Datetime.valueOf(datetimeStr);
        
        System.debug('Parsed Date: ' + parsedDate);
        System.debug('Parsed Datetime: ' + parsedDatetime);
    }
    
    // Parse boolean
    public static void parseBoolean() {
        String trueStr = 'true';
        String falseStr = 'false';
        
        Boolean bool1 = Boolean.valueOf(trueStr);
        Boolean bool2 = Boolean.valueOf(falseStr);
        
        System.debug('Bool1: ' + bool1);
        System.debug('Bool2: ' + bool2);
    }
}

// ========== STRING VALIDATION ==========
public class StringValidation {
    
    // Check blank
    public static Boolean isBlank(String str) {
        return str == null || str.trim().length() == 0;
    }
    
    // Check not blank
    public static Boolean isNotBlank(String str) {
        return !isBlank(str);
    }
    
    // Is numeric
    public static Boolean isNumeric(String str) {
        if (isBlank(str)) return false;
        try {
            Decimal.valueOf(str);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    // Is email
    public static Boolean isEmail(String str) {
        if (isBlank(str)) return false;
        Pattern emailPattern = Pattern.compile('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');
        return emailPattern.matcher(str).matches();
    }
    
    // Validate examples
    public static void validateExamples() {
        System.debug('Is blank: ' + isBlank('   '));
        System.debug('Is not blank: ' + isNotBlank('hello'));
        System.debug('Is numeric: ' + isNumeric('123.45'));
        System.debug('Is email: ' + isEmail('test@example.com'));
    }
}

// ========== STRING BUILDERS (Efficient concatenation) ==========
public class StringBuilderExample {
    
    // Inefficient way (creates many string objects)
    public static String inefficientConcat() {
        String result = '';
        for (Integer i = 0; i < 100; i++) {
            result += 'Item ' + i + ', ';  // BAD: creates new string each time
        }
        return result;
    }
    
    // Efficient way (use List and join)
    public static String efficientConcat() {
        List<String> items = new List<String>();
        for (Integer i = 0; i < 100; i++) {
            items.add('Item ' + i);
        }
        return String.join(items, ', ');
    }
}

// ========== ESCAPE AND ENCODE ==========
public class StringEscapeEncode {
    
    public static void escapeExamples() {
        String text = 'He said, "Hello"';
        String escaped = text.escapeHtml4();
        
        String json = '{"name":"John"}';
        String escapedJson = json.escapeJava();
        
        String url = 'hello world';
        String encoded = EncodingUtil.urlEncode(url, 'UTF-8');
        
        System.debug('Escaped HTML: ' + escaped);
        System.debug('Encoded URL: ' + encoded);
    }
}

/* USAGE EXAMPLES:

// Basics
StringBasics.stringCreation();
StringBasics.stringLength();

// Methods
StringMethods.caseConversion();
StringMethods.substringExamples();
StringMethods.searchMethods();
StringMethods.replaceMethods();

// Split & Join
StringSplitJoin.splitExamples();
StringSplitJoin.joinExamples();

// Comparison
StringComparison.compareStrings();

// Formatting
StringFormatting.formatStrings();
StringFormatting.numberFormatting();

// Parsing
StringParsing.parseNumbers();
StringParsing.parseDates();

// Validation
StringValidation.validateExamples();

// Efficient concatenation
String result = StringBuilderExample.efficientConcat();
*/
