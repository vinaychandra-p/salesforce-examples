/**
 * Multiple Objects Search Examples
 * Searching across 3+ object types simultaneously
 * 
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

public class MultipleObjectsExamples {
    public static void searchThreeObjects() {
        List<List<sObject>> results = [
            FIND 'Acme'
            RETURNING Account(Name), Contact(FirstName, LastName), Opportunity(Name)
        ];
        System.debug('Accounts: ' + results[0].size());
        System.debug('Contacts: ' + results[1].size());
        System.debug('Opportunities: ' + results[2].size());
    }
    
    public static void searchFiveObjects() {
        List<List<sObject>> results = [
            FIND 'Smith'
            RETURNING Account(Name), Contact(Name), Lead(Name), Case(CaseNumber), Opportunity(Name)
        ];
        for (Integer i = 0; i < results.size(); i++) {
            System.debug('Object ' + i + ': ' + results[i].size() + ' records');
        }
    }
    
    public static void processMultipleResults() {
        List<List<sObject>> results = [
            FIND 'Technology'
            RETURNING 
                Account(Name, Industry WHERE Industry = 'Technology' LIMIT 10),
                Contact(FirstName, LastName, Account.Name WHERE Account.Industry = 'Technology' LIMIT 20),
                Opportunity(Name, StageName, Amount WHERE StageName != 'Closed Lost' LIMIT 15)
        ];
        
        Account[] accounts = (Account[])results[0];
        Contact[] contacts = (Contact[])results[1];
        Opportunity[] opps = (Opportunity[])results[2];
        
        System.debug('=== TECHNOLOGY ACCOUNTS ===');
        for (Account acc : accounts) {
            System.debug(acc.Name);
        }
        
        System.debug('=== RELATED CONTACTS ===');
        for (Contact con : contacts) {
            System.debug(con.FirstName + ' ' + con.LastName + ' at ' + con.Account.Name);
        }
        
        System.debug('=== ACTIVE OPPORTUNITIES ===');
        for (Opportunity opp : opps) {
            System.debug(opp.Name + ' - $' + opp.Amount);
        }
    }
}
