/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 16 JAN 2017
    * @modified : 16 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : THIS IS UTILS CLASS FOR TIMELOG OBJECT, ALL RE-USABLE CODES WILL BE PLACED HERE
********************************************************************************************************/
    
Public with sharing  class TimeLogUtils{
    
    /*******************************************************************************************************
    * @description : TIMESHEET LOG RECORD WILL BE CREATED FOR GIVEN TIME ENTRY RECORD IDS - BULKIFIED  
    * @param : TIMEENTRY RECORD IDS, TIME NOW 
    * @param : 
    * @return : VOID
    * @example :   
    *  
    *******************************************************************************************************/
    Public Static void newTimeLogs(SET<ID> timeEntryRecordIds, DateTime TimeNow ) {
        
        try{    
            //COLLECTION LIST TYPE TO CREATE TIME LOGS
            List<Time_Log__c> TimeLogs = New List<Time_Log__c> ();
            
            //ITERATE THROUGH THE LIST
            for( String t : timeEntryRecordIds  ) {
                //CREATE NEW RECORD AND ADD IT TO THE LIST    
                TimeLogs.add( New Time_Log__c ( Time_Entry__c = t, Started_At__c = TimeNow  ) ) ;              
            }
            
            // CREATE TIME LOGS
            Insert TimeLogs ;
            
        } Catch ( Exception e ) {
            // EXCEPTION HANLDER
        }
        
    }
    
    /*******************************************************************************************************
    * @description : TIMESHEET LOG RECORD WILL BE UPDATED FOR GIVEN TIME ENTRY RECORD IDS, WHEN TIMER IS PAUSED - BULKIFIED  
    * @param : TIMEENTRY RECORD IDS, TIME NOW 
    * @param : 
    * @return : VOID
    * @example : 
    *  
    *******************************************************************************************************/
    Public Static void timerPaused(SET<ID> timeEntryRecordIds, DateTime TimetoUpdate ) {
        
        try{    
            //QUERY THE TIME LOG RECORDS TO UPDATE 
            Time_Log__c[] TimeLogs = [ SELECT Id 
                                        FROM Time_Log__c 
                                       WHERE Time_Entry__c IN : timeEntryRecordIds AND Ended_At__c = NULL ] ;
            
            //ITERATE THROUGH THE LIST
            for ( Time_Log__c  t: TimeLogs ) {
                //UPDATE THE ENDED AT FIELD
                t.Ended_At__c = TimetoUpdate ; 
            }  
            
            // CREATE TIME LOGS
            Update TimeLogs ;
            
        } Catch ( Exception e ) {
            // EXCEPTION HANLDER
        }
        
    }
    
     
   
   
}