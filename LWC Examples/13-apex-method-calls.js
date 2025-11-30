/**
 * @description Apex Method Calls - Server-Side Integration
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';
import createContact from '@salesforce/apex/ContactController.createContact';

export default class ApexMethodCalls extends LightningElement {
    @wire(getContactList)
    contacts;
    
    async handleCreateContact() {
        try {
            const result = await createContact({ 
                firstName: 'John', 
                lastName: 'Doe' 
            });
            console.log('Contact created:', result);
        } catch (error) {
            console.error('Error:', error);
        }
    }
}

/* Apex Controller:
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, Name, Email FROM Contact LIMIT 10];
    }
    
    @AuraEnabled
    public static Id createContact(String firstName, String lastName) {
        Contact c = new Contact(FirstName=firstName, LastName=lastName);
        insert c;
        return c.Id;
    }
}
*/