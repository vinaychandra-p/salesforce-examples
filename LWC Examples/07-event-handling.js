/**
 * @description Event Handling - User Interactions
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class EventHandling extends LightningElement {
    message = '';
    clickCount = 0;
    
    handleClick() {
        this.clickCount++;
        this.message = `Button clicked ${this.clickCount} times`;
    }
    
    handleInputChange(event) {
        this.message = event.target.value;
    }
    
    handleMouseEnter() {
        console.log('Mouse entered');
    }
    
    handleFocus() {
        console.log('Element focused');
    }
    
    handleBlur() {
        console.log('Element blurred');
    }
    
    handleKeyUp(event) {
        if (event.key === 'Enter') {
            console.log('Enter key pressed');
        }
    }
}