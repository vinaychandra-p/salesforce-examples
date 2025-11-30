/**
 * @description Hello World Component - Basic LWC Example
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 * 
 * This is the simplest Lightning Web Component showing basic structure
 * HTML Template: helloWorld.html
 * JavaScript: helloWorld.js
 * Meta XML: helloWorld.js-meta.xml
 */

// ============ HTML TEMPLATE (helloWorld.html) ============
/*
<template>
    <lightning-card title="Hello World Component" icon-name="custom:custom1">
        <div class="slds-m-around_medium">
            <p class="slds-text-heading_medium">Hello, {greeting}!</p>
            <p>Welcome to Lightning Web Components</p>
            <p>Current Date: {currentDate}</p>
        </div>
    </lightning-card>
</template>
*/

// ============ JAVASCRIPT CONTROLLER (helloWorld.js) ============
import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    greeting = 'World';
    
    get currentDate() {
        return new Date().toLocaleDateString();
    }
}

// ============ META XML (helloWorld.js-meta.xml) ============
/*
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>65.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
        <target>lightning__RecordPage</target>
        <target>lightning__HomePage</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__AppPage, lightning__HomePage">
            <property name="greeting" type="String" default="World" label="Greeting Text"/>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
*/

// ============ USAGE EXAMPLES ============
/*
1. Add to Lightning App Page:
   - Go to App Builder
   - Drag "Hello World" component to the page
   - Configure greeting text in properties panel

2. Use in Aura Component:
   <c:helloWorld greeting="Salesforce"/>

3. Add to Record Page:
   - Edit page layout
   - Add component to Lightning Record Page

Key Concepts Demonstrated:
- Basic component structure
- Property binding with {}
- Getter methods
- Component metadata configuration
*/
