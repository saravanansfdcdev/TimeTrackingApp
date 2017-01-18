/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 17 JAN 2017
    * @modified : 17 JAN 2017
    * @group    :  
    * @group-content : 
    * @description : CODE COVERAGE CLASS - BatchandScheduleWeeklyTimeSheets
********************************************************************************************************/
@isTest
private class TestBatchandScheduleWeeklyTimeSheets {
  
   
  
  /*
    @purpose : unit test method for scheduled class
  */
    static testMethod void TestBatchandScheduleWeeklyTimeSheets() {
        
        //Project and Project Team Member
        Project_Team__c projectTeam = TestDataUtils.getProjectTeam();
        
        Test.startTest();
           
           Database.executeBatch(new BatchandScheduleWeeklyTimeSheets());
           String ScheduleJob = System.schedule('TestBatchandScheduleWeeklyTimeSheets','0 0 0 3 9 ? 2022', new BatchandScheduleWeeklyTimeSheets()); 
            
        Test.stopTest();
      
    }
    
    
}