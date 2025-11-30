/**
 * @description Lightning Data Service (LDS) - Efficient Data Management
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, wire, api } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_INDUSTRY from '@salesforce/schema/Account.Industry';

export default class LightningDataService extends LightningElement {
    @api recordId;
    
    @wire(getRecord, { 
        recordId: '$recordId', 
        fields: [ACCOUNT_NAME, ACCOUNT_INDUSTRY] 
    })
    account;
    
    async handleUpdate() {
        const fields = {
            Id: this.recordId,
            Name: 'Updated Name'
        };
        
        try {
            await updateRecord({ fields });
            console.log('Record updated');
        } catch (error) {
            console.error('Error updating:', error);
        }
    }
}