/**
 * @description Wire Service with Parameters - Dynamic Data Loading
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class WireServiceParameters extends LightningElement {
    searchKey = '';
    limitRecords = 10;
    
    @wire(getAccounts, { searchTerm: '$searchKey', recordLimit: '$limitRecords' })
    accounts;
    
    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }
    
    handleLimitChange(event) {
        this.limitRecords = event.target.value;
    }
}