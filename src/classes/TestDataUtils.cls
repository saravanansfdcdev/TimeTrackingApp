/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 17 JAN 2017
    * @modified : 17 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : THIS IS TEST DATA UTILS CLASS
********************************************************************************************************/

Public class TestDataUtils {
    
    /*******************************************************************************************************
    * @description : PROJECT RECORDS
    * @param :  
    * @param : 
    * @return : 
    * @example :  
    *  
    *******************************************************************************************************/
        
    public static  Project__c getProject() {
         
         Project__c Project = new Project__c( 
             Name='Salesforce Project' ,
             Project_Manager__c = UserInfo.getUserid()
         );
         
         insert project ;
         
        return project ;           
    }
    
    
    public static Project_Team__c getProjectTeam() {
         
         Project_Team__c ProjectTeam = new Project_Team__c ( 
             
             Project__c = TestDataUtils.getProject().Id ,
             Capacity__c = '40',
             Billable_Rate__c = 50,
             Cost_Rate__c = 40,
             User__c = UserInfo.getUserid()
         );
          
        insert  ProjectTeam ;
        return ProjectTeam ;           
    }
    
    
    public static Task__c getTask() {
         
         Task__c Task = new Task__c ( 
             
             Name = 'Customization',
             Project__c = TestDataUtils.getProject().Id ,
             Hourly_Rate__c = 50,
             Common_task__c = True 
         );
          
         insert  Task ;
        return Task ;           
    }
    
    Public static Time_Sheet2__c getTimeSheet() {
         
         Time_Sheet2__c TimeSheet = new Time_Sheet2__c ( 
             
             Start_Date__c = Date.Today(),
             Project__c = TestDataUtils.getProject().Id ,
             End_Date__c = Date.Today().adddays(3),
             Project_Manager__c = UserInfo.getUserid() ,
             User__c = UserInfo.getUserid()
         );
          
        insert TimeSheet ; 
        return TimeSheet ;           
    }
    
    Public static Time_Entry__c getTimeEntry() {
         
         Time_Entry__c TimeEntry = new Time_Entry__c ( 
             
             Date__c = Date.Today(),
             Project__c = TestDataUtils.getProject().Id ,
             Task__c = TestDataUtils.getTask().Id ,
             Time_Sheet__c = TestDataUtils.getTimeSheet().Id
         );
          
        insert TimeEntry ; 
        return TimeEntry ;           
    }
    
    
 
  
}