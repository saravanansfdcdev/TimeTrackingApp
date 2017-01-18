/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 16 JAN 2017
    * @modified : 16 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : THIS IS TIME ENTRY TRIGGER HANDLER CLASS, WHICH WILL HANDLE ALL TRIGGER LOGICS. FOLLOWING LITE WIEGHT TRIGGER HANDLER PATTERN
********************************************************************************************************/

Public class TimeEntryTriggerHandler extends TriggerHandlerPattern {
    
    /*******************************************************************************************************
    * @description : CONSTRUCTOR
    * @param :  
    * @param : 
    * @return : 
    * @example :  
    *  
    *******************************************************************************************************/
    Public TimeEntryTriggerHandler( ) {  }
    
    
    /*******************************************************************************************************
    * @description : FOLLOWING ARE THE TRIGGER EVENT METHODS
    * @param :  
    * @param : 
    * @return : 
    * @example :  
    *  
    *******************************************************************************************************/
    
    
    /* CONTEXT OVERRIDES - AFTER INSERT */
    Protected override void  afterInsert() {
        // GET TIME ENTRY RECORDS ID
        Map<Id,Time_Entry__c> timeEntryRecords = New Map<Id,Time_Entry__c>  ( (List<Time_Entry__c>) Trigger.new ) ;
        
        //CALL TIME LOG UTILS TO CREATE NEW TIME LOGS 
        TimeLogUtils.newTimeLogs( timeEntryRecords.keyset() , Datetime.Now() );
    }
    
    /* CONTEXT OVERRIDES - AFTER UPDATE */
    Protected override void  afterUpdate() {
        timerStatusUpdate();
    }
    
     
    
    /*******************************************************************************************************
    * @description : HELPER METHOD, HANLES WHEN THE TIMER IS PAUSED AND RESUME LOGICS
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Private void timerStatusUpdate() {
    
        // LOCAL COLLECTION VARIABLES - MAP TRIGGER NEW AND OLD VALUES 
        Map<String,Time_Entry__c> TriggerNew = New Map<String,Time_Entry__c>  ( (List<Time_Entry__c>) Trigger.new ) ;
        Map<String,Time_Entry__c> TriggerOld = New Map<String,Time_Entry__c>  ( (List<Time_Entry__c>) Trigger.Old ) ;
        
        //SET COLLECTION TO GET THE TIMER PAUSED AND RESUMES RECORDS
        Set<Id> pauseTimers  = New Set<Id> ();
        Set<Id> resumeTimers = New Set<Id> ();
        
        //ITERATE
        for(Time_Entry__c t : (List<Time_Entry__c>) Trigger.Old) {
            
            //TIMER PAUSED
            if ( ( t.Timer_Status__c == 'Running' && TriggerNew.get(t.id).Timer_Status__c == 'Paused' ) 
                || ( t.Timer_Status__c == 'Running' && TriggerNew.get(t.id).Timer_Status__c == 'Stopped' ) ) 
                pauseTimers.add(t.id);
             
            
            //TIMER RESUME
            if ( t.Timer_Status__c <> 'Running' && TriggerNew.get(t.id).Timer_Status__c == 'Running' ) 
                resumeTimers.add(t.id);
            
        }
        
        //CALL TIME LOG UTILS TO UPDATE PAUSED TIME LOGS
        if ( !pauseTimers.isEmpty() ) 
            TimeLogUtils.timerPaused(pauseTimers, DateTime.Now());
        
        //CALL TIME LOG UTILS TO UPDATE PAUSED TIME LOGS 
        if ( !resumeTimers.isEmpty() ) 
            TimeLogUtils.newTimeLogs(resumeTimers, DateTime.Now());
        
    }
  
}