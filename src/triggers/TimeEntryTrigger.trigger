trigger TimeEntryTrigger on Time_Entry__c ( Before Insert, Before Update, After Insert, After Update) {
    
    new TimeEntryTriggerHandler().run();
     
    
}