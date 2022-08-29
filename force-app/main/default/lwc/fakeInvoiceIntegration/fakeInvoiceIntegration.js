import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import demoDataCannon from '@salesforce/apex/CreateDemoInvoiceData.demoDataCannon';

export default class FakeInvoiceIntegration extends LightningElement {

    @api recordId;
    spinner;

    renderedCallback() {
        console.log(`quick action component rendered with recordId: ${this.recordId}`);
    }
    // setup imperative apex call to respond to button click
    createInvoiceData() {
        this.spinner = true;
        demoDataCannon({ acctId: this.recordId})
            .then( result => {
                this.spinner = false;
                this.dispatchEvent(new CloseActionScreenEvent());
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Data Retrieved',
                        message: `${result} Invoice(s) retrieved.`,
                        variant: 'success'
                    })
                );
                getRecordNotifyChange([{ recordId: this.recordId }]);
            })
            .catch( error => {
                console.log(`there was an error: ${JSON.stringify(error)}`);
            })
    }

    handleCancel() {

        this.dispatchEvent(new CloseActionScreenEvent({bubbles:true, composed: true}));
    }
}