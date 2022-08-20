trigger ConsentFromCaseTrigger on Case (before insert) {
    // trigger will call custom class to do demo magic
    // then close the case. 
    String closeStatus = [SELECT MasterLabel FROM CaseStatus WHERE IsClosed = true LIMIT 1].MasterLabel;

    for (Case c : Trigger.New) {
        // call the Demo Magic Class
        MakeDemoMagicFromTrigger.createDemoRecord(c);
        
        // close the case
        c.Status = closeStatus;
        
    }
}