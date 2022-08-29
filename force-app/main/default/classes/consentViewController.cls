public with sharing class consentViewController {


    @AuraEnabled(cacheable=true)
    public static ConsentResponseWrapper getConsentData(String accountId){
        // this controller needs to take the account id passed in and return
        // individual record with consent flags and contact point info

        Id indId = [SELECT PersonIndividualId FROM Account WHERE Id =: accountId].PersonIndividualId;

        ConsentResponseWrapper responder = new ConsentResponseWrapper();

        // Individual record from account
        responder.indRecord = [SELECT Id, FirstName, LastName, Union_ID__c, CanStorePiiElsewhere, HasOptedOutGeoTracking, HasOptedOutProcessing, HasOptedOutProfiling, HasOptedOutTracking
                               FROM Individual
                               WHERE Id =: indId  LIMIT 1];

        // // Contact Point Email from Individual Record
        // responder.cpe = [SELECT EmailAddress from ContactPointEmail where ParentId =: indId LIMIT 1];

        // Contact Point Email from Individual Record
        responder.cpp = [SELECT TelephoneNumber from ContactPointPhone where ParentId =: indId LIMIT 1];

        return responder;
    }
}
