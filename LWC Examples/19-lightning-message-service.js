/**
 * @description Lightning Message Service - Cross-Component Communication
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement, wire } from 'lwc';
import { publish, subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import SAMPLE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class LightningMessageService extends LightningElement {
    subscription = null;
    
    @wire(MessageContext)
    messageContext;
    
    connectedCallback() {
        this.subscribeToMessageChannel();
    }
    
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            SAMPLE_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }
    
    handleMessage(message) {
        console.log('Message received:', message);
    }
    
    publishMessage() {
        const payload = { 
            recordId: '001xxx',
            message: 'Hello LMS' 
        };
        publish(this.messageContext, SAMPLE_CHANNEL, payload);
    }
    
    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}