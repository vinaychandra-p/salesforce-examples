/**
 * @description List Rendering - for:each and iterator directives
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class ListRendering extends LightningElement {
    contacts = [
        {Id: '1', Name: 'John Doe', Email: 'john@example.com'},
        {Id: '2', Name: 'Jane Smith', Email: 'jane@example.com'},
        {Id: '3', Name: 'Bob Johnson', Email: 'bob@example.com'}
    ];
    
    products = [
        {id: '1', name: 'Product A', price: 100},
        {id: '2', name: 'Product B', price: 200},
        {id: '3', name: 'Product C', price: 300}
    ];
    
    handleContactClick(event) {
        const contactId = event.target.dataset.id;
        console.log('Contact clicked:', contactId);
    }
}

/* HTML Template with for:each:
<template>
    <template for:each={contacts} for:item="contact">
        <div key={contact.Id} data-id={contact.Id} onclick={handleContactClick}>
            <p>{contact.Name} - {contact.Email}</p>
        </div>
    </template>
</template>
*/