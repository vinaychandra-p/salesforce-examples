/**
 * @description Parent-Child Communication - Property Passing
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, api } from 'lwc';

// Parent Component
export class ParentComponent extends LightningElement {
    parentMessage = 'Hello from Parent';
    
    handleChildEvent(event) {
        const childData = event.detail;
        console.log('Received from child:', childData);
    }
}

// Child Component
export default class ChildComponent extends LightningElement {
    @api messageFromParent;
    
    handleClick() {
        // Send data to parent
        const event = new CustomEvent('childaction', {
            detail: { message: 'Hello from Child' }
        });
        this.dispatchEvent(event);
    }
}