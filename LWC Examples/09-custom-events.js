/**
 * @description Custom Events - Component Communication
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class CustomEvents extends LightningElement {
    handleNotify() {
        // Create custom event with data
        const event = new CustomEvent('notify', {
            detail: {
                message: 'Notification message',
                timestamp: new Date().toISOString(),
                type: 'success'
            },
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(event);
    }
    
    handleSelect(event) {
        const selectedId = event.detail.id;
        const selectEvent = new CustomEvent('itemselected', {
            detail: { selectedId }
        });
        this.dispatchEvent(selectEvent);
    }
}