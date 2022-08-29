import { LightningElement, wire, api } from 'lwc';
import getConsentData from '@salesforce/apex/consentViewController.getConsentData';

export default class ConsentView extends LightningElement {

    // component needs to look up individual record from linked Person Account
    // then disply necessary consent flags as required
    @api recordId;
    singleIndividual;
    // cpe;
    cpp;
    options = [];
    error;
    values = [];

    renderedCallback() {
        console.log(`hey this rendered with recordId: ${this.recordId}`);
    }


    @wire(getConsentData, { accountId: '$recordId' })
    consentData({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data));
            this.singleIndividual = data.indRecord[0];
            console.log(JSON.stringify(this.singleIndividual));
            for (const key in this.singleIndividual) {
                if ( key !=="Id" && key !=="FirstName" && key !=="LastName" && key !=="Union_ID__c") {
                    if (this.singleIndividual[key] === true) {
                        this.values.push(this.singleIndividual[key]);
                    }
                this.options.push({label: key, value: this.singleIndividual[key]});
                }
            }
            // this.cpe = data.cpe[0].EmailAddress;
            this.cpp = data.cpp[0].TelephoneNumber;
        } else if (error) {
            this.error = error;
            this.singleIndividual = undefined;
            console.log(`was there an error?: ${JSON.stringify(error)}`);
        }
    }
}