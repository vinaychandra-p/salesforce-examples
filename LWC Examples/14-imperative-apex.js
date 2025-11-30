/**
 * @description Imperative Apex Calls - Manual Data Fetching
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';

export default class ImperativeApex extends LightningElement {
    opportunities = [];
    error;
    isLoading = false;
    
    async loadOpportunities() {
        this.isLoading = true;
        try {
            this.opportunities = await getOpportunities();
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.opportunities = [];
        } finally {
            this.isLoading = false;
        }
    }
    
    handleRefresh() {
        this.loadOpportunities();
    }
}