/** @description Lightning Web Component Example
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */
import { LightningElement, api } from 'lwc';
export default class LwcExample extends LightningElement {
    @api recordId;
    // Advanced LWC patterns and best practices
    connectedCallback() {
        this.initialize();
    }
    initialize() {
        console.log('Initialized:', this.recordId);
    }
}