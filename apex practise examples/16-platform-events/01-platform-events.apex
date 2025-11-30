/**
 * 16 - PLATFORM EVENTS - Event-Driven Architecture
 * Publishing, subscribing, error handling, best practices
 */

// ========== PLATFORM EVENT DEFINITION ==========
/*
Create in Setup -> Platform Events:
- API Name: Order_Event__e
- Fields:
  - Order_Number__c (Text)
  - Status__c (Text)
  - Amount__c (Number)
*/

// ========== PUBLISHING EVENTS ==========
public class EventPublisher {
    
    // Publish single event
    public static void publishOrderEvent(String orderNumber, String status, Decimal amount) {
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = orderNumber,
            Status__c = status,
            Amount__c = amount
        );
        
        // Publish
        Database.SaveResult result = EventBus.publish(event);
        
        if (!result.isSuccess()) {
            for (Database.Error error : result.getErrors()) {
                System.debug('Error: ' + error.getMessage());
            }
        }
    }
    
    // Publish multiple events (bulk)
    public static void publishMultipleEvents(List<Map<String, Object>> orders) {
        List<Order_Event__e> events = new List<Order_Event__e>();
        
        for (Map<String, Object> order : orders) {
            events.add(new Order_Event__e(
                Order_Number__c = (String) order.get('orderNumber'),
                Status__c = (String) order.get('status'),
                Amount__c = (Decimal) order.get('amount')
            ));
        }
        
        // Publish in bulk
        List<Database.SaveResult> results = EventBus.publish(events);
        
        // Check results
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                System.debug('Failed to publish event');
            }
        }
    }
}

// Usage:
// EventPublisher.publishOrderEvent('ORD-001', 'Completed', 1500.00);

// ========== TRIGGER SUBSCRIBER ==========
trigger OrderEventTrigger on Order_Event__e (after insert) {
    OrderEventHandler.handleOrderEvents(Trigger.new);
}

public class OrderEventHandler {
    
    public static void handleOrderEvents(List<Order_Event__e> events) {
        List<Order__c> ordersToUpdate = new List<Order__c>();
        
        for (Order_Event__e event : events) {
            System.debug('Event received: ' + event.Order_Number__c);
            System.debug('Status: ' + event.Status__c);
            System.debug('Amount: ' + event.Amount__c);
            
            // Query and update related records
            List<Order__c> orders = [
                SELECT Id, Status__c
                FROM Order__c
                WHERE Order_Number__c = :event.Order_Number__c
                LIMIT 1
            ];
            
            if (!orders.isEmpty()) {
                Order__c order = orders[0];
                order.Status__c = event.Status__c;
                order.Amount__c = event.Amount__c;
                ordersToUpdate.add(order);
            }
        }
        
        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }
}

// ========== APEX SUBSCRIBER (Alternative) ==========
public class ApexEventSubscriber {
    
    // Subscribe to events programmatically
    @future
    public static void subscribeToEvents() {
        // Note: Triggers are the recommended way
        // This is for illustration only
        
        List<Order_Event__e> events = [
            SELECT Order_Number__c, Status__c, Amount__c, CreatedDate, CreatedById
            FROM Order_Event__e
            WHERE CreatedDate = TODAY
        ];
        
        // Process events
        for (Order_Event__e event : events) {
            System.debug('Processing: ' + event.Order_Number__c);
        }
    }
}

// ========== ERROR HANDLING ==========
public class EventPublisherWithErrorHandling {
    
    public static void publishWithRetry(String orderNumber, String status, Decimal amount) {
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = orderNumber,
            Status__c = status,
            Amount__c = amount
        );
        
        Database.SaveResult result = EventBus.publish(event);
        
        if (result.isSuccess()) {
            System.debug('Event published successfully');
        } else {
            // Handle errors
            for (Database.Error error : result.getErrors()) {
                System.debug('Error publishing event: ' + error.getMessage());
                
                // Log error
                Error_Log__c log = new Error_Log__c(
                    ErrorMessage__c = error.getMessage(),
                    RecordId__c = orderNumber,
                    ErrorType__c = 'Platform Event'
                );
                insert log;
            }
        }
    }
    
    public static void publishBulkWithPartialSuccess(List<Map<String, Object>> orders) {
        List<Order_Event__e> events = new List<Order_Event__e>();
        
        for (Map<String, Object> order : orders) {
            events.add(new Order_Event__e(
                Order_Number__c = (String) order.get('orderNumber'),
                Status__c = (String) order.get('status'),
                Amount__c = (Decimal) order.get('amount')
            ));
        }
        
        List<Database.SaveResult> results = EventBus.publish(events);
        
        Integer successCount = 0;
        Integer failureCount = 0;
        
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                successCount++;
            } else {
                failureCount++;
                System.debug('Failed event ' + i + ': ' + events[i].Order_Number__c);
            }
        }
        
        System.debug('Published: ' + successCount + ', Failed: ' + failureCount);
    }
}

// ========== EVENT REPLAY ==========
public class EventReplayExample {
    
    // Get event replay ID
    public static void getReplayId() {
        // EventBus.getReplayId() in triggers
        // Available in after insert trigger context
    }
}

trigger OrderEventReplayTrigger on Order_Event__e (after insert) {
    for (Order_Event__e event : Trigger.new) {
        // Get replay ID for this event
        EventBus.ReplayId replayId = EventBus.getReplayId(event);
        System.debug('Replay ID: ' + replayId);
        
        // Store replay ID if needed for replay
    }
}

// ========== COMPLEX SUBSCRIBER ==========
trigger ComplexOrderEventTrigger on Order_Event__e (after insert) {
    ComplexOrderEventHandler.process(Trigger.new);
}

public class ComplexOrderEventHandler {
    
    public static void process(List<Order_Event__e> events) {
        // Separate events by type
        List<Order_Event__e> completedOrders = new List<Order_Event__e>();
        List<Order_Event__e> cancelledOrders = new List<Order_Event__e>();
        List<Order_Event__e> pendingOrders = new List<Order_Event__e>();
        
        for (Order_Event__e event : events) {
            if (event.Status__c == 'Completed') {
                completedOrders.add(event);
            } else if (event.Status__c == 'Cancelled') {
                cancelledOrders.add(event);
            } else if (event.Status__c == 'Pending') {
                pendingOrders.add(event);
            }
        }
        
        // Process each type
        if (!completedOrders.isEmpty()) {
            handleCompletedOrders(completedOrders);
        }
        
        if (!cancelledOrders.isEmpty()) {
            handleCancelledOrders(cancelledOrders);
        }
        
        if (!pendingOrders.isEmpty()) {
            handlePendingOrders(pendingOrders);
        }
    }
    
    private static void handleCompletedOrders(List<Order_Event__e> events) {
        // Update orders
        // Send notifications
        // Update inventory
    }
    
    private static void handleCancelledOrders(List<Order_Event__e> events) {
        // Refund processing
        // Restore inventory
    }
    
    private static void handlePendingOrders(List<Order_Event__e> events) {
        // Queue for processing
    }
}

// ========== PUBLISH FROM TRIGGER ==========
trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountEventPublisher.publishNewAccounts(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountEventPublisher.publishUpdatedAccounts(Trigger.newMap, Trigger.oldMap);
    }
}

public class AccountEventPublisher {
    
    public static void publishNewAccounts(List<Account> newAccounts) {
        List<Account_Event__e> events = new List<Account_Event__e>();
        
        for (Account acc : newAccounts) {
            events.add(new Account_Event__e(
                Account_Id__c = acc.Id,
                Account_Name__c = acc.Name,
                Event_Type__c = 'Created'
            ));
        }
        
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
    
    public static void publishUpdatedAccounts(
        Map<Id, Account> newMap,
        Map<Id, Account> oldMap
    ) {
        List<Account_Event__e> events = new List<Account_Event__e>();
        
        for (Id accId : newMap.keySet()) {
            Account newAcc = newMap.get(accId);
            Account oldAcc = oldMap.get(accId);
            
            // Only publish if specific fields changed
            if (newAcc.Status__c != oldAcc.Status__c) {
                events.add(new Account_Event__e(
                    Account_Id__c = newAcc.Id,
                    Account_Name__c = newAcc.Name,
                    Event_Type__c = 'Status Changed',
                    Old_Value__c = oldAcc.Status__c,
                    New_Value__c = newAcc.Status__c
                ));
            }
        }
        
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
}

// ========== EXTERNAL SYSTEM INTEGRATION ==========
public class ExternalSystemPublisher {
    
    @future(callout=true)
    public static void publishToExternalSystem(String eventData) {
        // First, publish to Salesforce Platform Event
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = eventData,
            Status__c = 'Processing',
            Amount__c = 0
        );
        
        EventBus.publish(event);
        
        // Then, send to external system via API
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://external-system.com/api/events');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(event));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('External response: ' + res.getStatusCode());
    }
}

// ========== TESTING PLATFORM EVENTS ==========
@isTest
private class PlatformEventTest {
    
    @isTest
    static void testEventPublish() {
        Test.startTest();
        
        // Publish event
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = 'TEST-001',
            Status__c = 'Completed',
            Amount__c = 1000
        );
        
        Database.SaveResult result = EventBus.publish(event);
        
        Test.stopTest();
        
        // Verify
        System.assert(result.isSuccess(), 'Event should publish successfully');
    }
    
    @isTest
    static void testBulkEventPublish() {
        List<Order_Event__e> events = new List<Order_Event__e>();
        
        for (Integer i = 0; i < 10; i++) {
            events.add(new Order_Event__e(
                Order_Number__c = 'TEST-' + i,
                Status__c = 'Completed',
                Amount__c = 100 * i
            ));
        }
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(events);
        Test.stopTest();
        
        // Verify all published
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
        }
    }
    
    @isTest
    static void testEventSubscriber() {
        // Create test data
        insert new Order__c(Order_Number__c = 'TEST-001', Status__c = 'Pending');
        
        Test.startTest();
        
        // Publish event (trigger will handle)
        Order_Event__e event = new Order_Event__e(
            Order_Number__c = 'TEST-001',
            Status__c = 'Completed',
            Amount__c = 1500
        );
        EventBus.publish(event);
        
        Test.stopTest();
        
        // Note: In test context, triggers may not fire immediately
        // Use Test.getEventBus().deliver() if available in your org
    }
}

/* PLATFORM EVENT LIMITS:
- Event message size: 1 MB
- Max event publishes per hour: Based on edition
- Max trigger executions per hour: Based on edition
- Events retained for 24 hours (standard)
- Events retained for 72 hours (high volume)

DELIVERY GUARANTEES:
- At least once delivery
- May be delivered multiple times
- Order not guaranteed across different event types

WHEN TO USE:
- Decouple systems
- Async processing
- External integrations
- Real-time notifications
- Event-driven architecture

ALTERNATIVES:
- Outbound Messages
- Streaming API
- Change Data Capture
- Platform Events (recommended for new development)
*/

/* BEST PRACTICES:
1. Use bulkified publishing
2. Handle duplicate events (idempotent processing)
3. Store replay IDs for recovery
4. Monitor event usage
5. Use meaningful event names
6. Version your events
7. Document event schema
8. Test thoroughly
*/

/* MONITORING:
Setup -> Event Manager
Setup -> Platform Events
Debug logs show EventBus operations
*/
