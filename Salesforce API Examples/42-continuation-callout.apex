/**
 * @title Continuation Long Callout
 * @description Salesforce API Example: Continuation Long Callout
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */
public with sharing class continuation_calloutExample {
    // Named Credential (if used): Callout_NC
    // Base Endpoint comment examples provided below.

    // ========= CONFIG =========
    private static final String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    // ========= CORE EXAMPLE =========
    public static void runExample(){
        System.debug('Running example: Continuation Long Callout');
        // Add specific logic per API type below.
    }

    // ========= HTTP HELPER =========
    private static HttpResponse doGet(String relative){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + relative);
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        return h.send(req);
    }

    // ========= ERROR HANDLING PATTERN =========
    private static void handleResponse(HttpResponse res){
        if(res == null){
            throw new CalloutException('Null response');
        }
        Integer code = res.getStatusCode();
        if(code >=200 && code <300){
            System.debug('Success: ' + res.getBody());
        } else {
            System.debug(LoggingLevel.ERROR,'Error ' + code + ' Body=' + res.getBody());
        }
    }

    // ========= SAMPLE USAGE COMMENT =========
    /*
    Example curl (outside Salesforce):
    curl -H "Authorization: Bearer <token>" \
         -H "Accept: application/json" \
         ${BASE_URL}/services/data/v65.0/...
    */
}