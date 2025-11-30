/**
 * @description Record Edit Form - Customizable Forms
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, api } from 'lwc';

export default class RecordEditForm extends LightningElement {
    @api recordId;
    @api objectApiName = 'Account';
    
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Name = 'Modified: ' + fields.Name;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    
    handleSuccess() {
        console.log('Record saved successfully');
    }
}

/* HTML:
<lightning-record-edit-form
    record-id={recordId}
    object-api-name={objectApiName}
    onsubmit={handleSubmit}
    onsuccess={handleSuccess}>
    <lightning-input-field field-name="Name"></lightning-input-field>
    <lightning-input-field field-name="Industry"></lightning-input-field>
    <lightning-button type="submit" label="Save"></lightning-button>
</lightning-record-edit-form>
*/