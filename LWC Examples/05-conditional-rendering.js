/**
 * @description Conditional Rendering - if:true, if:false, template if:true
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {
    isVisible = true;
    userType = 'admin';
    hasAccess = false;
    
    get isAdmin() {
        return this.userType === 'admin';
    }
    
    get isUser() {
        return this.userType === 'user';
    }
    
    toggleVisibility() {
        this.isVisible = !this.isVisible;
    }
    
    changeUserType(event) {
        this.userType = event.target.value;
    }
}

/* HTML Template Example:
<template>
    <template if:true={isVisible}>
        <p>This content is visible</p>
    </template>
    
    <template if:false={isVisible}>
        <p>This content is hidden</p>
    </template>
    
    <template if:true={isAdmin}>
        <p>Admin Panel</p>
    </template>
</template>
*/