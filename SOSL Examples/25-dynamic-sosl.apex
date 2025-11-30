/**
 * Dynamic SOSL Examples
 * Building SOSL queries dynamically using Search.query()
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class DynamicSOSLExamples {
    
    public static List<List<sObject>> dynamicBasicSearch(String searchTerm) {
        String soslQuery = 'FIND \'' + String.escapeSingleQuotes(searchTerm) + '\' RETURNING Account(Name), Contact(Name)';
        List<List<sObject>> results = Search.query(soslQuery);
        return results;
    }
    
    public static List<List<sObject>> buildDynamicQuery(String term, String objectName, List<String> fields) {
        String fieldList = String.join(fields, ', ');
        String query = 'FIND \'' + String.escapeSingleQuotes(term) + '\' RETURNING ' + objectName + '(' + fieldList + ')';
        return Search.query(query);
    }
    
    public static List<List<sObject>> dynamicWithFilters(String term, String whereClause) {
        String query = 'FIND \'' + String.escapeSingleQuotes(term) + '\' ';
        query += 'RETURNING Account(Name, Industry WHERE ' + whereClause + ')';
        return Search.query(query);
    }
    
    public static List<List<sObject>> userInputSearch(String userInput) {
        // CRITICAL: Always escape user input to prevent SOSL injection
        if (String.isBlank(userInput) || userInput.length() < 2) {
            return new List<List<sObject>>();
        }
        
        String sanitized = String.escapeSingleQuotes(userInput);
        String query = 'FIND \'' + sanitized + '\' IN ALL FIELDS RETURNING Account(Name), Contact(Name)';
        
        try {
            return Search.query(query);
        } catch (Exception e) {
            System.debug('Search error: ' + e.getMessage());
            return new List<List<sObject>>();
        }
    }
    
    public static List<List<sObject>> advancedDynamicQuery(Map<String, Object> params) {
        String searchTerm = String.escapeSingleQuotes((String)params.get('term'));
        String inClause = (String)params.get('searchIn'); // 'ALL FIELDS', 'NAME FIELDS', etc.
        Integer limitCount = (Integer)params.get('limitCount');
        
        String query = 'FIND \'' + searchTerm + '\' IN ' + inClause;
        query += ' RETURNING Account(Name, Industry LIMIT ' + limitCount + ')';
        
        System.debug('Dynamic query: ' + query);
        return Search.query(query);
    }
}

/**
 * USAGE:
 * DynamicSOSLExamples.dynamicBasicSearch('Acme');
 * DynamicSOSLExamples.userInputSearch('test search');
 * 
 * Map<String, Object> params = new Map<String, Object>{
 *     'term' => 'Technology',
 *     'searchIn' => 'ALL FIELDS',
 *     'limitCount' => 10
 * };
 * DynamicSOSLExamples.advancedDynamicQuery(params);
 */
