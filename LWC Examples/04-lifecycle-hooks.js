/**
 * @description Lifecycle Hooks - Component Lifecycle Management
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class LifecycleHooks extends LightningElement {
    constructor() {
        super();
        console.log('1. Constructor called');
    }
    
    connectedCallback() {
        console.log('2. Component inserted into DOM');
        // Perform initialization logic
    }
    
    renderedCallback() {
        console.log('3. Component rendered');
        // Access DOM elements
    }
    
    disconnectedCallback() {
        console.log('4. Component removed from DOM');
        // Cleanup: remove event listeners
    }
    
    errorCallback(error, stack) {
        console.error('Error occurred:', error);
        console.error('Stack:', stack);
    }
}