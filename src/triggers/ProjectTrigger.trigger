trigger ProjectTrigger on Project__c (After Insert, After Update) {
    
    new ProjectTriggerHandler().run();
    
}