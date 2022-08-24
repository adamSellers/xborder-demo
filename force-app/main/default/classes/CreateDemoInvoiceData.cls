public with sharing class CreateDemoInvoiceData {
    // class to create fake demo data from user interaction
    // user will click quick action to run this.
    @AuraEnabled
    public static Integer demoDataCannon(String acctId) {
        System.debug('account ID is: ' + acctId);
        // this method takes account ID and creates fake invoices
        // from the NTO data stored in Product2

        // I need to:
        // 1. Generate 2-6 invoices
        // 2. Add random products to each invoice (1-6 products) 

        // number of invoices to be generated
        Integer numberOfInvoices = Integer.valueof((Math.random() * 5)) + 1;
        List<Imported_Invoice__c> newInvoices = new List<Imported_Invoice__c>();

        for (Integer i = 0; i < numberOfInvoices; i++) {
            Integer randomDays = Integer.valueof((Math.random() * 120));
            Imported_Invoice__c singleInvoice = new Imported_Invoice__c();
            singleInvoice.Invoice_Date__c = System.Date.today() - randomDays;
            singleInvoice.Invoice_Status__c = 'Closed';
            singleInvoice.Customer__c = acctId;
            newInvoices.add(singleInvoice);
        }
        insert newInvoices;

        // create pool of pricebook entries to select products on invoice from
        List<PricebookEntry> allLines = [Select Id, Name, ProductCode, Product2Id, UnitPrice from PricebookEntry where Pricebook2Id= '01s5i000008ZuT6AAK'];
        List<Imported_Invoice_Line__c> linesToInsert = new List<Imported_Invoice_Line__c>();

        // generate random list of products from pricebook entries for invoice lines
        for (Imported_Invoice__c inv : newInvoices) {
            // for each invoice, select random number of lines
            // from price book and create invoice lines
            List<Imported_Invoice_Line__c> invLines = new List<Imported_Invoice_Line__c>();
            
            // create random number of entries
            Decimal randomNumber = 0;
            List<Decimal> randNums = new List<Decimal>();
            Map<Decimal,PriceBookEntry> numbersToEntries = new Map<Decimal,PriceBookEntry>();
            List<PricebookEntry> pbLines = new List<PricebookEntry>();
            
            for (PriceBookEntry pb: allLines) {
                randomNumber = Math.random();
                randNums.add(randomNumber);
                numbersToEntries.put(randomNumber, pb);
            }
            
            randNums.sort();
            
            // determine between 1-6 lines per invoice
            Integer numberOfLines = Integer.valueof((Math.random() * 6)) + 1;
            
            // select the corresponding PB lines
            for (Integer i=0; i<numberOfLines; i++) {
                pbLines.add(numbersToEntries.get(randNums[i]));
            }
            
            // now create invoice lines from these PB entries
            for (PricebookEntry pbe : pbLines) {
                Imported_Invoice_Line__c singleLine = new Imported_Invoice_Line__c();
                singleLine.Invoice__c = inv.Id;
                singleLine.Product__c = pbe.Product2Id;
                singleLine.Quantity__c = Integer.valueof((Math.random() * 3)) + 1;
                singleLine.Unit_Price__c = pbe.UnitPrice;
                
                invLines.add(singleLine);
            }
            // add this batch of invoice lines to the total lines to insert
            linesToInsert.addAll(invLines);           
        }
        // insert the total amount of invoice lines to the system
        insert linesToInsert;

        // return the number of invoices created
        return numberOfInvoices;
    }
}
