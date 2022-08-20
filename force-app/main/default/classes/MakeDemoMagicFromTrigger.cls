global class MakeDemoMagicFromTrigger {
    // class needs to take necessary information from W2C submission
    // and create the following:
    // 1. Individual Object detail 
    // 2. Person Account Detail (Individual ID as PersonIndividualId on Account record)
    // 2. Contact Point Email details (Individual ID as parent)
    // 3. Contact Point Phone details (Individual ID as parent)
    // 4. Generate random formatted string for union ID
    public static void createDemoRecord(Case c) {

    // create associated individual record
    Individual indToInsert = new Individual();
    indToInsert.FirstName = c.CN_FirstName__c;
    indToInsert.LastName = c.CN_LastName__c;
    indToInsert.CanStorePiiElsewhere = c.CN_Cross_Border_Transfer__c;
    indToInsert.HasOptedOutGeoTracking = c.CN_Geo_Tracking__c;
    indToInsert.HasOptedOutProcessing = c.CN_Data_Processing__c;
    indToInsert.HasOptedOutProfiling = c.CN_Profiling__c;
    indToInsert.HasOptedOutTracking = c.CN_Website_Tracking__c;

    insert indToInsert;

    // Create today's date for inserting
    Date startDate = System.today();
    Date endDate = startDate.addDays(30);


    // create contact point email address with Individual
    ContactPointEmail cpeToInsert = new ContactPointEmail();
    cpeToInsert.EmailAddress = c.CN_Email__c;
    cpeToInsert.ParentId = indToInsert.Id;
    cpeToInsert.ActiveFromDate = startDate;
    cpeToInsert.ActiveToDate = endDate;

    insert cpeToInsert;

        // create contact point phone with Individual
        ContactPointPhone cppToInsert = new ContactPointPhone();
        cppToInsert.TelephoneNumber = c.CN_Mobile__c;
        cppToInsert.ParentId = indToInsert.Id;
        cppToInsert.ActiveFromDate = startDate;
        cppToInsert.ActiveToDate = endDate;
        cppToInsert.IsPersonalPhone = true;
    
        insert cppToInsert;

    // grab recordTypeID for person account
    Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

    // generate sham union ID
    String fakeId = RandomUnionIdGenerator.generateUnionId();
    // create associate person account record
    Account perAccInsert = new Account();
    perAccInsert.FirstName = indToInsert.FirstName;
    perAccInsert.LastName = indToInsert.LastName;
    perAccInsert.RecordTypeId = personAccountRecordTypeId;
    perAccInsert.PersonIndividualId = indToInsert.Id;
    perAccInsert.PersonEmail = c.CN_Email__c;
    perAccInsert.PersonMobilePhone = c.CN_Mobile__c;
    perAccInsert.Union_Id__c = fakeId;

    insert perAccInsert;
    
    }
}
