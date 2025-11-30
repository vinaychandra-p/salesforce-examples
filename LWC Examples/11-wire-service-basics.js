/**
 * @description Wire Service Basics - Data Binding
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';

export default class WireServiceBasics extends LightningElement {
    @api recordId;
    
    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    account;
    
    get accountName() {
        return this.account.data ? this.account.data.fields.Name.value : '';
    }
    
    get hasError() {
        return this.account.error !== undefined;
    }
}