/**
 * 19 - HTTP CALLOUTS - REST/SOAP Integration
 * HTTP requests, authentication, error handling, testing
 */

// ========== BASIC HTTP GET ==========
public class BasicHTTPGet {
    
    public static void makeGetRequest() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts');
        req.setMethod('GET');
        req.setTimeout(60000);  // 60 seconds
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String body = res.getBody();
            System.debug('Response: ' + body);
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
        }
    }
}

// ========== HTTP POST ==========
public class HTTPPostExample {
    
    public static void createRecord() {
        // Create JSON payload
        Map<String, Object> data = new Map<String, Object>();
        data.put('name', 'New Account');
        data.put('industry', 'Technology');
        String jsonBody = JSON.serialize(data);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            System.debug('Created: ' + res.getBody());
        }
    }
}

// ========== HTTP PUT & PATCH ==========
public class HTTPUpdateExample {
    
    public static void updateRecordPUT(String recordId) {
        Map<String, Object> data = new Map<String, Object>();
        data.put('name', 'Updated Name');
        data.put('industry', 'Finance');
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts/' + recordId);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(data));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('Status: ' + res.getStatusCode());
    }
    
    public static void updateRecordPATCH(String recordId) {
        Map<String, Object> data = new Map<String, Object>();
        data.put('industry', 'Healthcare');  // Partial update
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts/' + recordId);
        req.setMethod('PATCH');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(data));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
}

// ========== HTTP DELETE ==========
public class HTTPDeleteExample {
    
    public static void deleteRecord(String recordId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/accounts/' + recordId);
        req.setMethod('DELETE');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 204) {
            System.debug('Record deleted successfully');
        }
    }
}

// ========== AUTHENTICATION PATTERNS ==========
public class AuthenticationExamples {
    
    // API Key authentication
    public static void apiKeyAuth() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        req.setHeader('X-API-Key', 'your-api-key-here');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    // Bearer Token authentication
    public static void bearerTokenAuth() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer your-token-here');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    // Basic authentication
    public static void basicAuth() {
        String username = 'user';
        String password = 'pass';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        req.setHeader('Authorization', authorizationHeader);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    // OAuth 2.0
    public static void oAuth2() {
        // First, get access token
        String accessToken = getAccessToken();
        
        // Then use token
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    private static String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://auth.example.com/oauth/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id=xxx&client_secret=yyy');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) result.get('access_token');
        }
        return null;
    }
}

// ========== NAMED CREDENTIALS ==========
public class NamedCredentialExample {
    
    public static void useNamedCredential() {
        // Named Credential handles authentication automatically
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:My_Named_Credential/api/accounts');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('Response: ' + res.getBody());
    }
    
    public static void namedCredentialPost() {
        Map<String, Object> data = new Map<String, Object>();
        data.put('name', 'Test');
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:My_Named_Credential/api/accounts');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(data));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
}

// ========== ERROR HANDLING ==========
public class CalloutErrorHandling {
    
    public static void comprehensiveErrorHandling() {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.example.com/data');
            req.setMethod('GET');
            req.setTimeout(60000);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Check status code
            if (res.getStatusCode() == 200) {
                // Success
                processResponse(res.getBody());
            } else if (res.getStatusCode() == 401) {
                System.debug('Authentication failed');
            } else if (res.getStatusCode() == 404) {
                System.debug('Resource not found');
            } else if (res.getStatusCode() == 500) {
                System.debug('Server error');
            } else {
                System.debug('Unexpected status: ' + res.getStatusCode());
            }
            
        } catch (System.CalloutException e) {
            System.debug('Callout failed: ' + e.getMessage());
            // Log error, retry, or notify
        }
    }
    
    private static void processResponse(String body) {
        // Parse and process response
    }
}

// ========== RETRY LOGIC ==========
public class CalloutWithRetry {
    
    public static HttpResponse makeCalloutWithRetry(String endpoint, Integer maxRetries) {
        Integer retryCount = 0;
        HttpResponse res;
        
        while (retryCount < maxRetries) {
            try {
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                req.setTimeout(60000);
                
                Http http = new Http();
                res = http.send(req);
                
                if (res.getStatusCode() == 200) {
                    return res;  // Success
                } else if (res.getStatusCode() >= 500) {
                    // Server error, retry
                    retryCount++;
                    System.debug('Retry ' + retryCount + ' due to server error');
                } else {
                    // Client error, don't retry
                    return res;
                }
                
            } catch (System.CalloutException e) {
                retryCount++;
                System.debug('Retry ' + retryCount + ' due to exception: ' + e.getMessage());
            }
        }
        
        throw new CalloutException('Failed after ' + maxRetries + ' retries');
    }
}

// ========== ASYNC CALLOUTS ==========
public class AsyncCallouts {
    
    @future(callout=true)
    public static void makeAsyncCallout(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Process response
        if (res.getStatusCode() == 200) {
            // Update Salesforce records
        }
    }
}

public class QueueableCallout implements Queueable, Database.AllowsCallouts {
    
    private String endpoint;
    
    public QueueableCallout(String url) {
        this.endpoint = url;
    }
    
    public void execute(QueueableContext context) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Process response
    }
}

// ========== SOAP CALLOUTS ==========
public class SOAPCalloutExample {
    
    public static void makeSoapCallout() {
        String soapRequest = 
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '  <soap:Body>' +
            '    <GetAccountInfo>' +
            '      <AccountId>12345</AccountId>' +
            '    </GetAccountInfo>' +
            '  </soap:Body>' +
            '</soap:Envelope>';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/soap');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', 'GetAccountInfo');
        req.setBody(soapRequest);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Parse SOAP response
            Dom.Document doc = res.getBodyDocument();
            // Extract data from XML
        }
    }
}

// ========== MULTIPART FORM DATA ==========
public class MultipartFormData {
    
    public static void uploadFile() {
        String boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW';
        String header = '--' + boundary + '\r\n';
        String footer = '--' + boundary + '--';
        
        String fileContent = 'Test file content';
        String bodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(fileContent));
        
        String body = header +
            'Content-Disposition: form-data; name="file"; filename="test.txt"\r\n' +
            'Content-Type: text/plain\r\n\r\n' +
            bodyEncoded + '\r\n' +
            footer;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/upload');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        req.setBodyAsBlob(Blob.valueOf(body));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
}

// ========== TESTING CALLOUTS ==========
@isTest
private class HTTPCalloutTest {
    
    @isTest
    static void testCallout() {
        // Set mock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        BasicHTTPGet.makeGetRequest();
        Test.stopTest();
        
        // Assertions
    }
}

// Mock class
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success","data":[]}');
        res.setStatusCode(200);
        return res;
    }
}

// Multiple endpoint mock
@isTest
global class MultiEndpointMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if (req.getEndpoint().endsWith('/accounts')) {
            res.setBody('{"accounts":[]}');
            res.setStatusCode(200);
        } else if (req.getEndpoint().endsWith('/contacts')) {
            res.setBody('{"contacts":[]}');
            res.setStatusCode(200);
        } else {
            res.setStatusCode(404);
        }
        
        return res;
    }
}

/* CALLOUT LIMITS:
- Max callouts per transaction: 100
- Max callout time per transaction: 120 seconds
- Max response size: 6 MB (synchronous), 12 MB (async)
- Must configure Remote Site Settings or Named Credentials

BEST PRACTICES:
1. Use Named Credentials for authentication
2. Always handle errors
3. Implement retry logic for transient failures
4. Use async callouts when possible
5. Mock callouts in tests
6. Log callout details
7. Set appropriate timeouts
8. Check response status codes
9. Parse responses safely
10. Consider bulkification

REMOTE SITE SETTINGS:
Setup -> Remote Site Settings
- Add external URLs before making callouts
- Or use Named Credentials (preferred)

NAMED CREDENTIALS:
Setup -> Named Credentials
- Handles authentication automatically
- Supports OAuth, Password, JWT
- More secure than hardcoded credentials
*/
