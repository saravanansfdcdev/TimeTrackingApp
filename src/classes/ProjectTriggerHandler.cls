/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 16 JAN 2017
    * @modified : 16 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : PROJECT TRIGGER HANDLER CLASS, WHICH WILL HANDLE ALL TRIGGER LOGICS. FOLLOWING LITE WIEGHT TRIGGER HANDLER PATTERN
********************************************************************************************************/

Public class ProjectTriggerHandler extends TriggerHandlerPattern {
    
    /*******************************************************************************************************
    * @description : CONSTRUCTOR
    * @param :  
    * @param : 
    * @return : 
    * @example :  
    *  
    *******************************************************************************************************/
    Public ProjectTriggerHandler( ) {  }
    
    
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
        // GET PROJECT RECORDS  
        Map<Id,Project__c> Projects = New Map<Id,Project__c>  ( (List<Project__c>) Trigger.new ) ;
        
        //ADD PROJECT MANGER INTO PROJECT TEAM
        addProjectMngIntoProjectTeam(Projects);
          
    }
    
    /* CONTEXT OVERRIDES - AFTER UPDATE */
    Protected override void  afterUpdate() {
         
        // LOCAL COLLECTION VARIABLES - MAP TRIGGER NEW AND OLD VALUES 
        Map<String,Project__c> TriggerNew = New Map<String,Project__c>  ( (List<Project__c>) Trigger.new ) ;
        Map<Id,Project__c> Projects = New Map<Id,Project__c>  () ;
         //ITERATE
        for(Project__c p : (List<Project__c>) Trigger.Old) {
            
            //IS PROJECT MANAGER CHANGED
            if ( (P.Project_Manager__c <> NULL ) && ( TriggerNew.get(p.id).Project_Manager__c == NULL || 
                    P.Project_Manager__c <> TriggerNew.get(p.id).Project_Manager__c ) ) {
                 
                 Projects.put(p.id,p) ;      
            }
            
        }
        
        //ADD PROJECT MANGER INTO PROJECT TEAM
        addProjectMngIntoProjectTeam(Projects);
        
    }
    
     
    
    /*******************************************************************************************************
    * @description : ADD PROJECT MANAGER TO TEAM
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Private void addProjectMngIntoProjectTeam(Map<Id,Project__c> Projects) {
        
        try{
            
            List<Project_Team__c> ProjectMngMember = New List<Project_Team__c> () ;
            //ITERATE THROUGH THE LIST
            for( Project__c p : Projects.Values()  ) {
                //CREATE PROJECT MANGER INTO PROJECT TEAM   
                if ( p.Project_Manager__c <> NULL  )
                ProjectMngMember.add( New Project_Team__c ( Project__c = P.Id, User__c = p.Project_Manager__c , Billable_Rate__c = 0 ) ) ;              
            }
            
            insert  ProjectMngMember ;
            
        } Catch (Exception e) {
            System.Debug(' Exception ==> ' +  e);
        }
        
    }
  
}