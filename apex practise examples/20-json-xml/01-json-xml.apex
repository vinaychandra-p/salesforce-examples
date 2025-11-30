/**
 * 20 - JSON AND XML - Data Serialization & Parsing
 * JSON serialize/deserialize, XML parsing, custom serializers
 */

// ========== BASIC JSON SERIALIZATION ==========
public class JSONSerializationBasics {
    
    public static void serializeObject() {
        Account acc = new Account(Name='Test Account', Industry='Technology');
        
        // Serialize to JSON
        String jsonString = JSON.serialize(acc);
        System.debug('JSON: ' + jsonString);
        // Output: {"attributes":{"type":"Account"},"Name":"Test Account","Industry":"Technology"}
    }
    
    public static void serializeList() {
        List<Account> accounts = new List<Account>{
            new Account(Name='Account 1'),
            new Account(Name='Account 2')
        };
        
        String jsonString = JSON.serialize(accounts);
        System.debug(jsonString);
    }
    
    public static void serializeMap() {
        Map<String, Object> data = new Map<String, Object>();
        data.put('name', 'John Doe');
        data.put('age', 30);
        data.put('active', true);
        
        String jsonString = JSON.serialize(data);
        System.debug(jsonString);
        // Output: {"name":"John Doe","age":30,"active":true}
    }
}

// ========== BASIC JSON DESERIALIZATION ==========
public class JSONDeserializationBasics {
    
    public static void deserializeObject() {
        String jsonString = '{"Name":"Test Account","Industry":"Technology"}';
        
        // Deserialize to Account
        Account acc = (Account) JSON.deserialize(jsonString, Account.class);
        System.debug('Name: ' + acc.Name);
        System.debug('Industry: ' + acc.Industry);
    }
    
    public static void deserializeList() {
        String jsonString = '[{"Name":"Account 1"},{"Name":"Account 2"}]';
        
        List<Account> accounts = (List<Account>) JSON.deserialize(jsonString, List<Account>.class);
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    public static void deserializeToMap() {
        String jsonString = '{"name":"John","age":30,"active":true}';
        
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        System.debug('Name: ' + data.get('name'));
        System.debug('Age: ' + data.get('age'));
        System.debug('Active: ' + data.get('active'));
    }
}

// ========== CUSTOM APEX CLASSES ==========
public class Person {
    public String firstName;
    public String lastName;
    public Integer age;
    public Boolean active;
    public List<String> hobbies;
    
    public Person(String fName, String lName, Integer age) {
        this.firstName = fName;
        this.lastName = lName;
        this.age = age;
        this.hobbies = new List<String>();
    }
}

public class PersonSerializer {
    
    public static void serializePerson() {
        Person person = new Person('John', 'Doe', 30);
        person.active = true;
        person.hobbies.add('Reading');
        person.hobbies.add('Coding');
        
        String jsonString = JSON.serialize(person);
        System.debug(jsonString);
        // Output: {"firstName":"John","lastName":"Doe","age":30,"active":true,"hobbies":["Reading","Coding"]}
    }
    
    public static void deserializePerson() {
        String jsonString = '{"firstName":"Jane","lastName":"Smith","age":25,"active":true}';
        
        Person person = (Person) JSON.deserialize(jsonString, Person.class);
        System.debug('Name: ' + person.firstName + ' ' + person.lastName);
        System.debug('Age: ' + person.age);
    }
}

// ========== COMPLEX JSON PARSING ==========
public class ComplexJSONParsing {
    
    public static void parseNestedJSON() {
        String jsonString = '{' +
            '"company": "Tech Corp",' +
            '"employees": [' +
            '  {"name": "John", "role": "Developer"},' +
            '  {"name": "Jane", "role": "Manager"}' +
            '],' +
            '"location": {"city": "San Francisco", "country": "USA"}' +
            '}';
        
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        // Access company
        String company = (String) data.get('company');
        System.debug('Company: ' + company);
        
        // Access employees array
        List<Object> employees = (List<Object>) data.get('employees');
        for (Object emp : employees) {
            Map<String, Object> employee = (Map<String, Object>) emp;
            System.debug('Name: ' + employee.get('name') + ', Role: ' + employee.get('role'));
        }
        
        // Access nested location
        Map<String, Object> location = (Map<String, Object>) data.get('location');
        System.debug('City: ' + location.get('city'));
    }
    
    public static void parseArrayOfObjects() {
        String jsonString = '[' +
            '{"id": 1, "name": "Product A", "price": 99.99},' +
            '{"id": 2, "name": "Product B", "price": 149.99}' +
            ']';
        
        List<Object> products = (List<Object>) JSON.deserializeUntyped(jsonString);
        
        for (Object prod : products) {
            Map<String, Object> product = (Map<String, Object>) prod;
            System.debug('Product: ' + product.get('name') + ' - $' + product.get('price'));
        }
    }
}

// ========== JSON PRETTY PRINT ==========
public class JSONPrettyPrint {
    
    public static void prettyPrint() {
        Map<String, Object> data = new Map<String, Object>();
        data.put('name', 'John');
        data.put('age', 30);
        
        String jsonString = JSON.serializePretty(data);
        System.debug(jsonString);
        /* Output:
        {
          "name" : "John",
          "age" : 30
        }
        */
    }
}

// ========== JSON GENERATOR (Streaming) ==========
public class JSONGeneratorExample {
    
    public static String buildJSON() {
        JSONGenerator gen = JSON.createGenerator(true);  // true = pretty print
        
        gen.writeStartObject();
        gen.writeStringField('name', 'John Doe');
        gen.writeNumberField('age', 30);
        gen.writeBooleanField('active', true);
        
        gen.writeFieldName('hobbies');
        gen.writeStartArray();
        gen.writeString('Reading');
        gen.writeString('Coding');
        gen.writeEndArray();
        
        gen.writeFieldName('address');
        gen.writeStartObject();
        gen.writeStringField('city', 'San Francisco');
        gen.writeStringField('state', 'CA');
        gen.writeEndObject();
        
        gen.writeEndObject();
        
        return gen.getAsString();
    }
}

// ========== JSON PARSER (Streaming) ==========
public class JSONParserExample {
    
    public static void parseJSON(String jsonString) {
        JSONParser parser = JSON.createParser(jsonString);
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                
                if (fieldName == 'name') {
                    System.debug('Name: ' + parser.getText());
                } else if (fieldName == 'age') {
                    System.debug('Age: ' + parser.getIntegerValue());
                }
            }
        }
    }
}

// ========== XML PARSING ==========
public class XMLParsingExamples {
    
    public static void parseXML() {
        String xmlString = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<company>' +
            '  <name>Tech Corp</name>' +
            '  <employees>' +
            '    <employee>' +
            '      <name>John Doe</name>' +
            '      <role>Developer</role>' +
            '    </employee>' +
            '  </employees>' +
            '</company>';
        
        Dom.Document doc = new Dom.Document();
        doc.load(xmlString);
        
        Dom.XmlNode root = doc.getRootElement();
        System.debug('Root: ' + root.getName());
        
        // Get company name
        for (Dom.XmlNode child : root.getChildElements()) {
            if (child.getName() == 'name') {
                System.debug('Company: ' + child.getText());
            } else if (child.getName() == 'employees') {
                for (Dom.XmlNode emp : child.getChildElements()) {
                    for (Dom.XmlNode field : emp.getChildElements()) {
                        System.debug(field.getName() + ': ' + field.getText());
                    }
                }
            }
        }
    }
    
    public static void parseXMLWithNamespace() {
        String xmlString = '<?xml version="1.0"?>' +
            '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '  <soap:Body>' +
            '    <GetAccountResponse>' +
            '      <AccountId>12345</AccountId>' +
            '    </GetAccountResponse>' +
            '  </soap:Body>' +
            '</soap:Envelope>';
        
        Dom.Document doc = new Dom.Document();
        doc.load(xmlString);
        
        Dom.XmlNode root = doc.getRootElement();
        // Navigate through namespace
    }
}

// ========== XML GENERATION ==========
public class XMLGenerationExamples {
    
    public static String buildXML() {
        Dom.Document doc = new Dom.Document();
        
        Dom.XmlNode root = doc.createRootElement('company', null, null);
        
        Dom.XmlNode name = root.addChildElement('name', null, null);
        name.addTextNode('Tech Corp');
        
        Dom.XmlNode employees = root.addChildElement('employees', null, null);
        
        Dom.XmlNode employee = employees.addChildElement('employee', null, null);
        Dom.XmlNode empName = employee.addChildElement('name', null, null);
        empName.addTextNode('John Doe');
        
        return doc.toXmlString();
    }
}

// ========== CUSTOM JSON SERIALIZATION ==========
public class CustomSerializable {
    
    public String name;
    public Date birthDate;
    @JsonAccess(serializable='never')
    public String password;  // Never serialize
    @JsonAccess(deserializable='never')
    public String computedField;  // Never deserialize
    
    public CustomSerializable(String name, Date birthDate) {
        this.name = name;
        this.birthDate = birthDate;
    }
}

// ========== API RESPONSE WRAPPER ==========
public class APIResponse {
    public Boolean success;
    public String message;
    public Object data;
    public List<String> errors;
    
    public APIResponse(Boolean success, String message) {
        this.success = success;
        this.message = message;
        this.errors = new List<String>();
    }
    
    public String toJSON() {
        return JSON.serialize(this);
    }
    
    public static APIResponse fromJSON(String jsonString) {
        return (APIResponse) JSON.deserialize(jsonString, APIResponse.class);
    }
}

// Usage
public class APIResponseUsage {
    public static void example() {
        APIResponse response = new APIResponse(true, 'Operation successful');
        response.data = new List<Account>{new Account(Name='Test')};
        
        String json = response.toJSON();
        System.debug(json);
        
        // Parse back
        APIResponse parsed = APIResponse.fromJSON(json);
        System.debug('Success: ' + parsed.success);
    }
}

// ========== ERROR HANDLING ==========
public class JSONErrorHandling {
    
    public static void safeDeserialize(String jsonString) {
        try {
            Account acc = (Account) JSON.deserialize(jsonString, Account.class);
            System.debug('Deserialized: ' + acc.Name);
        } catch (JSONException e) {
            System.debug('JSON Error: ' + e.getMessage());
        }
    }
    
    public static void validateJSON(String jsonString) {
        try {
            Object obj = JSON.deserializeUntyped(jsonString);
            System.debug('Valid JSON');
        } catch (JSONException e) {
            System.debug('Invalid JSON: ' + e.getMessage());
        }
    }
}

/* JSON METHODS:
- JSON.serialize(obj)
- JSON.serializePretty(obj)
- JSON.deserialize(jsonString, Type)
- JSON.deserializeUntyped(jsonString)
- JSON.createGenerator(prettyPrint)
- JSON.createParser(jsonString)

XML METHODS:
- Dom.Document
- Dom.XmlNode
- Dom.Document.load(xmlString)
- Dom.Document.toXmlString()

BEST PRACTICES:
1. Use typed deserialization when possible
2. Handle JSONException
3. Validate JSON before parsing
4. Use JSONGenerator for large JSON
5. Use JSONParser for streaming
6. Consider memory limits
7. Use @JsonAccess for field control
8. Test serialization/deserialization
*/
