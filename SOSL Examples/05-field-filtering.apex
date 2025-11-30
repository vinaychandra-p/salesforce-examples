/**
 * Field Filtering Examples
 * Demonstrates filtering search results using WHERE clauses
 * 
 * WHERE clauses in RETURNING allow you to filter results
 * after the text search has been performed
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class FieldFilteringExamples {
    
    /**
     * Example 1: Basic WHERE Clause
     * Filtering by a single field
     */
    public static void basicWhereClause() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name, Industry, Type
                WHERE Industry = 'Technology'
            )
        ];
        
        System.debug('Accounts in Technology industry:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.Industry);
        }
    }
    
    /**
     * Example 2: Multiple Conditions (AND)
     */
    public static void multipleConditionsAnd() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Contact(
                FirstName, LastName, Title, Department
                WHERE Title != null 
                  AND Department = 'Sales'
            )
        ];
        
        System.debug('Sales contacts with titles:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' - ' + con.Title);
        }
    }
    
    /**
     * Example 3: OR Conditions
     */
    public static void orConditions() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name, Industry, Type
                WHERE Industry = 'Technology' 
                   OR Industry = 'Healthcare'
            )
        ];
        
        System.debug('Technology or Healthcare accounts:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' (' + acc.Industry + ')');
        }
    }
    
    /**
     * Example 4: Numeric Comparisons
     */
    public static void numericComparisons() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(
                Name, AnnualRevenue, NumberOfEmployees
                WHERE AnnualRevenue > 5000000 
                  AND NumberOfEmployees >= 100
            )
        ];
        
        System.debug('Large companies (>$5M revenue, 100+ employees):');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - $' + acc.AnnualRevenue + ', ' + acc.NumberOfEmployees + ' employees');
        }
    }
    
    /**
     * Example 5: Date Filtering with Literals
     */
    public static void dateFilteringLiterals() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, CreatedDate WHERE CreatedDate = THIS_YEAR),
                Contact(FirstName, LastName WHERE CreatedDate = LAST_MONTH),
                Opportunity(Name, CloseDate WHERE CloseDate = NEXT_QUARTER)
        ];
        
        System.debug('Accounts created this year: ' + results[0].size());
        System.debug('Contacts created last month: ' + results[1].size());
        System.debug('Opportunities closing next quarter: ' + results[2].size());
    }
    
    /**
     * Example 6: Date Range Filtering
     */
    public static void dateRangeFiltering() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Contact(
                FirstName, LastName, CreatedDate
                WHERE CreatedDate >= LAST_N_DAYS:90 
                  AND CreatedDate <= TODAY
            )
        ];
        
        System.debug('Contacts created in last 90 days:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' - ' + con.CreatedDate);
        }
    }
    
    /**
     * Example 7: IN Clause Filtering
     */
    public static void inClauseFiltering() {
        List<List<sObject>> results = [
            FIND 'Johnson'
            RETURNING Contact(
                FirstName, LastName, LeadSource
                WHERE LeadSource IN ('Web', 'Partner Referral', 'Trade Show')
            )
        ];
        
        System.debug('Contacts from specific lead sources:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' - ' + con.LeadSource);
        }
    }
    
    /**
     * Example 8: NOT IN Clause
     */
    public static void notInClause() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name, Type, Industry
                WHERE Type NOT IN ('Competitor', 'Partner')
            )
        ];
        
        System.debug('Accounts excluding Competitors and Partners:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.Type);
        }
    }
    
    /**
     * Example 9: NULL Checks
     */
    public static void nullChecks() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(
                Name, Phone, Website, Industry
                WHERE Phone != null 
                  AND Website != null
                  AND Industry != null
            )
        ];
        
        System.debug('Complete account records:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name);
            System.debug('  Phone: ' + acc.Phone);
            System.debug('  Website: ' + acc.Website);
            System.debug('  Industry: ' + acc.Industry);
        }
    }
    
    /**
     * Example 10: Boolean Field Filtering
     */
    public static void booleanFiltering() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Contact(
                FirstName, LastName, HasOptedOutOfEmail, DoNotCall
                WHERE HasOptedOutOfEmail = false 
                  AND DoNotCall = false
            )
        ];
        
        System.debug('Contacts available for marketing:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' (Contactable)');
        }
    }
    
    /**
     * Example 11: Relationship Filtering
     */
    public static void relationshipFiltering() {
        List<List<sObject>> results = [
            FIND 'Manager'
            RETURNING Contact(
                FirstName, LastName, Title, Account.Name, Account.Industry
                WHERE Account.Industry = 'Technology'
                  AND Account.AnnualRevenue > 1000000
            )
        ];
        
        System.debug('Contacts at large tech companies:');
        Contact[] contacts = (Contact[])results[0];
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName);
            System.debug('  Company: ' + con.Account.Name);
            System.debug('  Industry: ' + con.Account.Industry);
        }
    }
    
    /**
     * Example 12: LIKE Pattern Matching
     */
    public static void likePatternMatching() {
        List<List<sObject>> results = [
            FIND 'Tech'
            RETURNING Account(
                Name, Website
                WHERE Website LIKE '%.com'
            )
        ];
        
        System.debug('Accounts with .com websites:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.Website);
        }
    }
    
    /**
     * Example 13: Complex Boolean Logic
     */
    public static void complexBooleanLogic() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(
                Name, Industry, Type, AnnualRevenue
                WHERE (Industry = 'Technology' OR Industry = 'Healthcare')
                  AND (Type = 'Customer' OR Type = 'Prospect')
                  AND AnnualRevenue > 100000
            )
        ];
        
        System.debug('Filtered results with complex logic:');
        Account[] accounts = (Account[])results[0];
        System.debug('Found ' + accounts.size() + ' matching accounts');
    }
    
    /**
     * Example 14: Opportunity Stage Filtering
     */
    public static void opportunityStageFiltering() {
        List<List<sObject>> results = [
            FIND 'Enterprise'
            RETURNING Opportunity(
                Name, StageName, Amount, CloseDate
                WHERE StageName IN ('Proposal/Price Quote', 'Negotiation/Review', 'Closed Won')
                  AND Amount > 50000
                  AND CloseDate >= THIS_QUARTER
            )
        ];
        
        System.debug('High-value opportunities in late stages:');
        Opportunity[] opps = (Opportunity[])results[0];
        for (Opportunity opp : opps) {
            System.debug(opp.Name + ' - ' + opp.StageName + ' ($' + opp.Amount + ')');
        }
    }
    
    /**
     * Example 15: Case Status Filtering
     */
    public static void caseStatusFiltering() {
        List<List<sObject>> results = [
            FIND 'urgent'
            RETURNING Case(
                CaseNumber, Subject, Status, Priority, CreatedDate
                WHERE Status IN ('New', 'Working')
                  AND Priority = 'High'
                  AND CreatedDate = THIS_WEEK
            )
        ];
        
        System.debug('Urgent open cases this week:');
        Case[] cases = (Case[])results[0];
        for (Case c : cases) {
            System.debug(c.CaseNumber + ': ' + c.Subject + ' (' + c.Priority + ')');
        }
    }
    
    /**
     * Example 16: Geographic Filtering
     */
    public static void geographicFiltering() {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING 
                Account(Name, BillingCity, BillingState 
                    WHERE BillingState IN ('CA', 'NY', 'TX')),
                Contact(FirstName, LastName, MailingState 
                    WHERE MailingState IN ('CA', 'NY', 'TX'))
        ];
        
        System.debug('Accounts and Contacts in CA, NY, TX:');
        System.debug('Accounts: ' + results[0].size());
        System.debug('Contacts: ' + results[1].size());
    }
    
    /**
     * Example 17: RecordType Filtering
     */
    public static void recordTypeFiltering() {
        // Note: Replace with actual RecordType IDs in your org
        List<List<sObject>> results = [
            FIND 'Enterprise'
            RETURNING Account(
                Name, RecordType.Name
                WHERE RecordType.Name = 'Enterprise Account'
            )
        ];
        
        System.debug('Enterprise Account records:');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' (' + acc.RecordType.Name + ')');
        }
    }
    
    /**
     * Example 18: Owner Filtering
     */
    public static void ownerFiltering() {
        Id currentUserId = UserInfo.getUserId();
        
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING 
                Account(Name, Owner.Name WHERE OwnerId = :currentUserId),
                Contact(FirstName, LastName WHERE OwnerId = :currentUserId)
        ];
        
        System.debug('My owned records:');
        System.debug('My Accounts: ' + results[0].size());
        System.debug('My Contacts: ' + results[1].size());
    }
    
    /**
     * Example 19: Combined Filters Real-World Example
     */
    public static void combinedFiltersRealWorld() {
        Date thirtyDaysAgo = Date.today().addDays(-30);
        
        List<List<sObject>> results = [
            FIND 'Technology'
            RETURNING 
                Account(
                    Name, Industry, Type, AnnualRevenue, CreatedDate
                    WHERE Industry LIKE '%Tech%'
                      AND Type = 'Customer'
                      AND AnnualRevenue > 500000
                      AND Rating = 'Hot'
                      AND CreatedDate >= LAST_N_MONTHS:6
                ),
                Opportunity(
                    Name, StageName, Amount, CloseDate, Account.Name
                    WHERE StageName NOT IN ('Closed Lost', 'Closed Won')
                      AND Amount > 25000
                      AND CloseDate >= TODAY
                      AND Probability > 50
                )
        ];
        
        System.debug('=== HOT TECH CUSTOMERS ===');
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - $' + acc.AnnualRevenue);
        }
        
        System.debug('=== ACTIVE HIGH-VALUE OPPORTUNITIES ===');
        Opportunity[] opps = (Opportunity[])results[1];
        for (Opportunity opp : opps) {
            System.debug(opp.Name + ' - $' + opp.Amount + ' (' + opp.StageName + ')');
        }
    }
    
    /**
     * Example 20: Dynamic Filtering
     */
    public static void dynamicFiltering(String industry, Decimal minRevenue) {
        List<List<sObject>> results = [
            FIND 'Corp'
            RETURNING Account(
                Name, Industry, AnnualRevenue
                WHERE Industry = :industry
                  AND AnnualRevenue >= :minRevenue
            )
        ];
        
        System.debug('Filtered accounts: ' + industry + ', min revenue: $' + minRevenue);
        Account[] accounts = (Account[])results[0];
        for (Account acc : accounts) {
            System.debug(acc.Name + ' - ' + acc.Industry + ' ($' + acc.AnnualRevenue + ')');
        }
    }
}

/**
 * USAGE EXAMPLES:
 * 
 * FieldFilteringExamples.basicWhereClause();
 * FieldFilteringExamples.multipleConditionsAnd();
 * FieldFilteringExamples.dateFilteringLiterals();
 * FieldFilteringExamples.nullChecks();
 * FieldFilteringExamples.relationshipFiltering();
 * FieldFilteringExamples.combinedFiltersRealWorld();
 * FieldFilteringExamples.dynamicFiltering('Technology', 1000000);
 */
