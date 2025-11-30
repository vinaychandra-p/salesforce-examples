/**
 * @description Record View Form - Read-Only Display
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, api } from 'lwc';

export default class RecordViewForm extends LightningElement {
    @api recordId;
    @api objectApiName = 'Account';
}

/* HTML:
<lightning-record-view-form
    record-id={recordId}
    object-api-name={objectApiName}>
    <lightning-output-field field-name="Name"></lightning-output-field>
    <lightning-output-field field-name="Industry"></lightning-output-field>
    <lightning-output-field field-name="AnnualRevenue"></lightning-output-field>
</lightning-record-view-form>
*/