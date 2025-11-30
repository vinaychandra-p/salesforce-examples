/**
 * @description Platform Events - Event-Driven Architecture
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class PlatformEvents extends LightningElement {
    channelName = '/event/MyCustomEvent__e';
    subscription = {};
    
    connectedCallback() {
        this.handleSubscribe();
        this.registerErrorListener();
    }
    
    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('Event received:', response);
            this.handleEvent(response.data.payload);
        };
        
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    
    handleEvent(payload) {
        console.log('Payload:', payload);
    }
    
    registerErrorListener() {
        onError(error => {
            console.error('EMP API error:', error);
        });
    }
    
    disconnectedCallback() {
        unsubscribe(this.subscription);
    }
}