/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 19-JAN-2017
    * @modified : 19-JAN-2017
    * @group    :  
    * @group-content : 
    * @description : TIME TRACKER VISUALFORCE PAGE CONTROLLER
********************************************************************************************************/

Public WITH SHARING Class TimerTrackerCont{
    
    //GLOBAL VARIABLES
    Public List<Time_Entry__c> TimeEntries {get;set;}
    Public String  projectId {get;set;}
    Public String  taskId {get;set;}
    Public Time_Entry__c timeEntry {get;set;}
    Public Date TimeEntryDate {get;set;}
    Public Set<Id> ProjectIds {get;set;}
    Public String TimeSheet {get;set;}
    Public Map<String,Time_Sheet2__c> TimeSheets ;
    
    /*******************************************************************************************************
    * @description : CONSTRUCTOR 
    * @param :  
    * @param : 
    * @return :  
    * @example :  
    *  
    *******************************************************************************************************/
    Public TimerTrackerCont() {
        TimeEntryDate = Date.Today();
        init ();
    }
    
    
    
    /*******************************************************************************************************
    * @description : GET TIME SHEETS FOR THE CURRENT USER TO CREATE TIME ENTRY 
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Public List<SelectOption> getTimeSheets() {
        List<SelectOption> options = new List<SelectOption>();
        
        TimeSheets = New Map<String,Time_Sheet2__c> ([SELECT Id,Name, Project__c, End_Date__c, Start_Date__c 
                                                            FROM Time_Sheet2__c 
                                                        WHERE User__c =: Userinfo.getuserid() AND Approval_Status__c = 'New'  ]) ;
        
         
        for ( Time_Sheet2__c TS :TimeSheets.values() ){
            String fmtStartDate = TS.Start_Date__c.Month()+'/'+TS.Start_Date__c.Day()+'/'+TS.Start_Date__c.Year();
            String fmtEndDate   = TS.End_Date__c.Month()+'/'+TS.End_Date__c.Day()+'/'+TS.End_Date__c.Year();
            options.add(new SelectOption(TS.Id,fmtStartDate +'-'+ fmtEndDate));
        }
        return options;
    } 
    
    /*******************************************************************************************************
    * @description : GET LIST OF PROECTS FOR CURRENT USER 
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Public List<SelectOption> getProjects() {
        List<SelectOption> options = new List<SelectOption>();
        
        
        List<Project_Team__c> projectsUserIn = New  List<Project_Team__c>  ();
        projectsUserIn = [SELECT Id, Project__c FROM Project_Team__c WHERE User__c =: Userinfo.getuserid() OR Project__r.Project_Manager__c   =: Userinfo.getuserid()  ] ;
        ProjectIds = New Set<Id> ();
        
        for ( Project_Team__c p : projectsUserIn ){
            ProjectIds.add(p.Project__c);
        }
        
        List<Project__c> projectList = New  List<Project__c>  ();
        projectList = [SELECT Id, Name FROM Project__c  ] ;
        
        for ( Project__c  project :projectList ){
            options.add(new SelectOption(project.Id,project.Name));
        }
        
        return options;
    } 
    
    /*******************************************************************************************************
    * @description : GET TASKS FOR CURRENT USER 
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Public List<SelectOption> getTasks() {
        List<SelectOption> options = new List<SelectOption>();
            
        List<Task__c> taskList = New  List<Task__c>  ();
        taskList = [SELECT Id, Name FROM Task__c WHERE Project__c IN :ProjectIds ] ;
        
        for ( Task__c  task :taskList ){
            options.add(new SelectOption(task.Id,task.Name));
        }
        
        return options;
    }
    
    /*******************************************************************************************************
    * @description : INIT METHOD
    * @param : NA 
    * @param : 
    * @return : NA
    * @example : THIS METHOD WILL QUERY THE SERVER TO GET THE COUNT OF ALL INCOMING STEMAIL OBJECT RECORDS, 
    *            WILL CONTRUCT THE DATAS TO WRAPPERCLASS 'SNAPSHOT' TO ARTICULATE THE DATA IN TABLE FORMAT  
    *******************************************************************************************************/
    Public void init () {
     try{   
         
         String currentUserId = UserInfo.getUserId()  ;
         String PMProfileId = Label.Project_Manager_Profile_Id;
         
         TimeEntries = New  List<Time_Entry__c>  ();
          
         List<Time_Entry__c> tmpTimeEntries = New  List<Time_Entry__c>  ();
         tmpTimeEntries = [SELECT Id, Date__c, Total_Hours2__c, Timer_Status__c, Project__r.Name, Task__r.Name, Time_Sheet__r.Name,
                             Time_Sheet__r.Start_Date__c , Time_Sheet__r.End_Date__c, Time_Sheet__c, Project__c, Task__c, User__c, Time_Sheet__r.User__c,
                             Time_Sheet__r.Approval_Status__c 
                         FROM Time_Entry__c  ];
            
         if ( UserInfo.getProfileId().contains(PMProfileId)  ) {
             TimeEntries.addall(tmpTimeEntries) ;
         } else {
             for ( Time_Entry__c t : tmpTimeEntries) { 
                 if (  t.Time_Sheet__r.User__c == currentUserId )
                     TimeEntries.add(t); 
                  
             }
         }
         
          
      } Catch (Exception e ){
          System.Debug(' Exception ==> ' + e );
      } 
         
    }
    
    /*******************************************************************************************************
    * @description : ADD NEW TIME ENTRY 
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    
    Public void  newTimeEntry () {
        
        Time_Entry__c newTimeEntry = New Time_Entry__c ();
        newTimeEntry.Date__c = TimeEntryDate ;
        newTimeEntry.Project__c = projectId ;
        newTimeEntry.Task__c = taskId;
        newTimeEntry.Time_Sheet__c = TimeSheet;
        
        Project_Team__c[] currentProjectMember = [Select Id FROM Project_Team__c WHERE User__c =: Userinfo.getuserId() AND Project__c = :projectId ] ;
        if ( !currentProjectMember.isEmpty() ){
            newTimeEntry.Person__c = currentProjectMember[0].Id ;
        }
        
        System.Debug('newTimeEntry  ==> ' + newTimeEntry );
        insert newTimeEntry ;
         
    }
    
    
    /*******************************************************************************************************
    * @description : UPDATE THE STATUS OF TIME ENTRY, WHEN USER CLICK TIMER ON SCREEN 
    * @param :  
    * @param : 
    * @return : VOID
    * @example :  
    *  
    *******************************************************************************************************/
    Public Void UpdateStatus(){
       try{    
          String recId = Apexpages.currentPage().getParameters().get('recId');
          String newStatus = Apexpages.currentPage().getParameters().get('newStatus');
          
          if ( String.isNotBlank(recId)  && String.isNotBlank(newStatus) ){
              
              Time_Entry__c UpdateTimeEntry = New Time_Entry__c ();
               UpdateTimeEntry.Id = recId ;
               UpdateTimeEntry.Timer_Status__c = newStatus ; 
               
               Update UpdateTimeEntry ;
              System.Debug(' UpdateTimeEntry ==> ' + UpdateTimeEntry  );
              init ();
               
          }
      
      } Catch (Exception e ){
          System.Debug(' Exception ==> ' + e );
      }  
    
    }
    
    
    
     
   
    
     
}