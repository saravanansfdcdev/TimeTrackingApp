/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 16 JAN 2017
    * @modified : 16 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : THIS IS BATCHABLE AND SCHEDULE CLASS, OBJECTIVE - A NEW TIMESHEET IS AUTO GENERATED  FOR EACH WEEK IN ADVANCE OVER SUNDAY NIGHT   
********************************************************************************************************/

global with sharing class BatchandScheduleWeeklyTimeSheets implements Schedulable, Database.Batchable<sObject> {

    
  
   /*******************************************************************************************************
    * @description : BATCH CLASS START METHOD, QUERY THE PROJEC TEAM RECORDS (PROJECT USERS)  
    * @param : 
    * @param : 
    * @return : QUERY LOCATOR
    * @example :   
    *  
    *******************************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select User__c, Project__c FROM Project_Team__c ';
        return Database.getQueryLocator(query);
    }

 
   /*******************************************************************************************************
    * @description : BATCH CLASS EXECUTE METHOD, PROCESS OVER THE PROJECT TEAM RECORDS AND CREATE TIME SHEET FOR THESE USERS  
    * @param : 
    * @param : 
    * @return :  
    * @example :   
    *  
    *******************************************************************************************************/
   global void execute(Database.BatchableContext BC, List<Project_Team__c> scope){
       
       //LIST COLLECTION OF NEW TIMESHEETS
       List<Time_sheet2__c> newTimesheets = new List<Time_sheet2__c>();
       
       //ITERATE OVER THE PROJECT USER RECORDS
       for ( Project_Team__c p : scope ){
           
           newTimesheets.add( New Time_sheet2__c ( 
               Project__c    = p.Project__c, 
               Start_Date__c = Date.today().toStartOfWeek(),
               End_Date__c   = Date.today().toStartOfWeek().addDays(6),
               Project_User__c    = p.id
           ));
       }
       
       insert newTimesheets ;
       
   }
    
   
   /*******************************************************************************************************
    * @description : BATCH CLASS FINISH METHOD, NOT IN SCOPE. NEEDS TO BE EXTENDED WITH EMAIL OR LOGS CREATION TO TRACK THE SUCCESS AND FAILURES  
    * @param : 
    * @param : 
    * @return :  
    * @example :   
    *  
    *******************************************************************************************************/
    global void finish(Database.BatchableContext BC){
   
   }
   
   /*******************************************************************************************************
    * @description : SCHEDULABLE METHOD, METHOD WILL ENABLE THIS CLASS AS SCHEDULABLE  
    * @param : 
    * @param : 
    * @return : QUERY LOCATOR
    * @example :   
    *  
    *******************************************************************************************************/
   global void execute(SchedulableContext scMain) {
       
        Database.executeBatch(new BatchandScheduleWeeklyTimeSheets());
   
   }
    
     
    
}