/**
 * @description Component Properties - Public and Private Properties
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

// ============ HTML TEMPLATE ============
/*
<template>
    <lightning-card title="Component Properties" icon-name="standard:customer">
        <div class="slds-m-around_medium">
            <div class="slds-form-element">
                <label class="slds-form-element__label">First Name</label>
                <div class="slds-form-element__control">
                    <input type="text" class="slds-input" value={firstName} onchange={handleFirstNameChange}/>
                </div>
            </div>
            <div class="slds-form-element slds-m-top_small">
                <label class="slds-form-element__label">Last Name</label>
                <div class="slds-form-element__control">
                    <input type="text" class="slds-input" value={lastName} onchange={handleLastNameChange}/>
                </div>
            </div>
            <p class="slds-m-top_medium">Full Name: <strong>{fullName}</strong></p>
            <p>Email: <strong>{email}</strong></p>
        </div>
    </lightning-card>
</template>
*/

// ============ JAVASCRIPT CONTROLLER ============
import { LightningElement, api } from 'lwc';

export default class ComponentProperties extends LightningElement {
    // Public property - Can be set by parent component
    @api recordId;
    @api objectApiName;
    
    // Private properties
    firstName = 'John';
    lastName = 'Doe';
    
    // Private property with default value
    _email = 'john.doe@example.com';
    
    // Getter for computed property
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
    
    // Getter/Setter for email
    get email() {
        return this._email;
    }
    
    set email(value) {
        this._email = value.toLowerCase();
    }
    
    // Event handlers
    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }
    
    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }
}

// ============ KEY CONCEPTS ============
/*
1. @api decorator - Makes property public
2. Private properties - No decorator needed
3. Getters - Computed properties
4. Setters - Transform data on assignment
5. Property reactivity - UI updates automatically
*/