/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 17 JAN 2017
    * @modified : 17 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : CODE COVERAGE CLASS 
********************************************************************************************************/

@isTest
private class TestOverallCodeCoverage {
  
   
    static testMethod void Project() {
        //Create Dependent Datas
        
        
        Test.startTest();
        
        //Project and Project Team Member
        Project_Team__c projectTeam = TestDataUtils.getProjectTeam();
        
        //Task
        Task__c Task = TestDataUtils.getTask();
        
        //Time Sheet
        Time_Sheet2__c TimeSheet = TestDataUtils.getTimeSheet();
        
        //Time Sheet
        Time_Entry__c TimeEntry = TestDataUtils.getTimeEntry();
        
        TimeEntry.Timer_Status__c = 'Paused' ;
        Update TimeEntry ;
        
        System.assertEquals(TimeEntry.Timer_Status__c, 'Paused');
        
        TimeEntry.Timer_Status__c = 'Running' ;
        Update TimeEntry ;
        
        System.assertEquals(TimeEntry.Timer_Status__c, 'Running');
        
        Project__c Proj = TestDataUtils.getProject();
        Proj.Project_Manager__c = NULL ;
        Update Proj ;
        
        Proj.Project_Manager__c = UserInfo.getUserid() ;
        Update Proj ;
        
        TimerTrackerCont timeTrackerCont = New TimerTrackerCont ();
        timeTrackerCont.getProjects();
        timeTrackerCont.getTasks();
        timeTrackerCont.getTimeSheets();
            
        Test.stopTest();
      
    }
    
     
}