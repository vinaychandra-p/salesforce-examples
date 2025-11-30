/**
 * Ordering Results Examples
 * Demonstrates sorting SOSL search results
 * 
 * ORDER BY clause sorts results for each object type
 * Syntax: ORDER BY field [ASC|DESC] [NULLS FIRST|NULLS LAST]
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class OrderingResultsExamples {
    
    /**
     * Example 1: Basic Ascending Order
     */
    public static void basicAscendingOrder() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Name, Industry ORDER BY Name ASC)
        ];
        
        System.debug('Accounts sorted A-Z:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
    }
    
    /**
     * Example 2: Descending Order
     */
    public static void descendingOrder() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(Name, AnnualRevenue ORDER BY AnnualRevenue DESC)
        ];
        
        System.debug('Accounts by revenue (highest first):');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - $' + acc.AnnualRevenue);
        }
    }
    
    /**
     * Example 3: Multiple Field Ordering
     */
    public static void multipleFieldOrdering() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Contact(
                FirstName, LastName, Title
                ORDER BY LastName ASC, FirstName ASC
            )
        ];
        
        System.debug('Contacts sorted by last name, then first name:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.LastName + ', ' + con.FirstName);
        }
    }
    
    /**
     * Example 4: Date Ordering
     */
    public static void dateOrdering() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, CreatedDate ORDER BY CreatedDate DESC),
                Contact(FirstName, LastName, CreatedDate ORDER BY CreatedDate ASC)
        ];
        
        System.debug('Newest accounts first:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.CreatedDate.format());
        }
        
        System.debug('Oldest contacts first:');
        Contact[] contacts = (Contact[])results[1];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' - ' + con.CreatedDate.format());
        }
    }
    
    /**
     * Example 5: NULLS FIRST
     */
    public static void nullsFirst() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(
                Name, Industry
                ORDER BY Industry ASC NULLS FIRST
            )
        ];
        
        System.debug('Industry sorted (nulls first):');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            String industry = acc.Industry != null ? acc.Industry : '(No Industry)';
            System.debug(acc.Name + ' - ' + industry);
        }
    }
    
    /**
     * Example 6: NULLS LAST
     */
    public static void nullsLast() {
        List<List<sObject>> results = [
            FIND 'Tech'
            RETURNING Account(
                Name, AnnualRevenue
                ORDER BY AnnualRevenue DESC NULLS LAST
            )
        ];
        
        System.debug('Revenue sorted (nulls last):');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            String revenue = acc.AnnualRevenue != null ? '$' + String.valueOf(acc.AnnualRevenue) : '(No Revenue)';
            System.debug(acc.Name + ' - ' + revenue);
        }
    }
    
    /**
     * Example 7: Complex Multi-Field Sorting
     */
    public static void complexMultiFieldSorting() {
        List<List<sObject>> results = [
            FIND 'Manager'
            RETURNING Contact(
                FirstName, LastName, Title, Department, CreatedDate
                ORDER BY Department ASC, Title DESC, LastName ASC
            )
        ];
        
        System.debug('Contacts sorted by: Department, Title (desc), Name:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.Department + ' | ' + con.Title + ' | ' + con.LastName);
        }
    }
    
    /**
     * Example 8: Opportunity Amount Ordering
     */
    public static void opportunityAmountOrdering() {
        List<List<sObject>> results = [
            FIND 'Enterprise'
            RETURNING Opportunity(
                Name, StageName, Amount, CloseDate
                ORDER BY Amount DESC, CloseDate ASC
            )
        ];
        
        System.debug('Opportunities by amount (high to low), then close date:');
        Opportunity[] opps = (Opportunity[])results[0];
        for (Opportunity opp : opps) {
            System.debug('$' + opp.Amount + ' - ' + opp.Name + ' (Closes: ' + opp.CloseDate.format() + ')');
        }
    }
    
    /**
     * Example 9: Case Priority Ordering
     */
    public static void casePriorityOrdering() {
        List<List<sObject>> results = [
            FIND 'urgent'
            RETURNING Case(
                CaseNumber, Subject, Priority, Status, CreatedDate
                ORDER BY Priority ASC, CreatedDate DESC
            )
        ];
        
        System.debug('Cases by priority, newest first:');
        Case[] cases = (Case[])results[0];
        for (Case c : cases) {
            System.debug(c.Priority + ' | ' + c.CaseNumber + ': ' + c.Subject);
        }
    }
    
    /**
     * Example 10: Order with LIMIT
     */
    public static void orderWithLimit() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name, AnnualRevenue
                ORDER BY AnnualRevenue DESC
                LIMIT 10
            )
        ];
        
        System.debug('Top 10 accounts by revenue:');
        Account[] accounts = (Account[])results[0];
        for (Integer i = 0; i < accounts.size(); i++) {
            System.debug((i+1) + '. ' + accounts[i].Name + ' - $' + accounts[i].AnnualRevenue);
        }
    }
}

/**
 * USAGE:
 * OrderingResultsExamples.basicAscendingOrder();
 * OrderingResultsExamples.descendingOrder();
 * OrderingResultsExamples.multipleFieldOrdering();
 * OrderingResultsExamples.nullsFirst();
 * OrderingResultsExamples.orderWithLimit();
 */
