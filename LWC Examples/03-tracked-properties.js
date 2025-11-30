/**
 * @description Tracked Properties - Reactive State Management
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, track } from 'lwc';

export default class TrackedProperties extends LightningElement {
    // Primitive tracked property
    @track counter = 0;
    
    // Object tracked property
    @track user = {
        name: 'John Doe',
        email: 'john@example.com',
        address: {
            city: 'San Francisco',
            state: 'CA'
        }
    };
    
    // Array tracked property
    @track items = ['Item 1', 'Item 2', 'Item 3'];
    
    incrementCounter() {
        this.counter++;
    }
    
    updateUserName(event) {
        this.user.name = event.target.value;
    }
    
    updateCity(event) {
        this.user.address.city = event.target.value;
    }
    
    addItem() {
        this.items.push(`Item ${this.items.length + 1}`);
    }
}