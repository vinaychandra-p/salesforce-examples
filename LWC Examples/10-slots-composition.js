/**
 * @description Slots and Composition - Reusable Components
 * @author vinaychandrap
 * @date 2025-11-30
 * @version Winter '26 (API v65.0)
 */

import { LightningElement } from 'lwc';

export default class SlotsComposition extends LightningElement {
    // Named slot usage
}

/* HTML Template:
<template>
    <div class="container">
        <div class="header">
            <slot name="header"></slot>
        </div>
        <div class="content">
            <slot></slot>
        </div>
        <div class="footer">
            <slot name="footer"></slot>
        </div>
    </div>
</template>

Usage in Parent:
<c-slots-composition>
    <h1 slot="header">Header Content</h1>
    <p>Main Content</p>
    <p slot="footer">Footer Content</p>
</c-slots-composition>
*/