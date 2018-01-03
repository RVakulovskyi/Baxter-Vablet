/********************************************************************************
Apex Class Name - ClsSelectRecordTypeController_Test
Version - 1.0
Created Date- 19-June-2017 by - Arpit
Function - This class will be used for test coverage of ClsSelectRecordTypeController.
********************************************************************************/

@isTest
public class ClsSelectRecordTypeController_Test{

 Static testMethod void testGetRecordType(){
        
        Test.startTest();
        ClsSelectRecordTypeController.getQuestionRecordTypes();
        Test.stopTest();
   }
}