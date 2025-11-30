/**
 * @description Record Form - Automatic Form Generation
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RecordForm extends LightningElement {
    @api recordId;
    @api objectApiName;
    
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Record Updated',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }
    
    handleError(event) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: event.detail.message,
            variant: 'error'
        });
        this.dispatchEvent(evt);
    }
}

/* HTML Template:
<template>
    <lightning-record-form
        record-id={recordId}
        object-api-name={objectApiName}
        layout-type="Full"
        mode="edit"
        onsuccess={handleSuccess}
        onerror={handleError}>
    </lightning-record-form>
</template>
*/