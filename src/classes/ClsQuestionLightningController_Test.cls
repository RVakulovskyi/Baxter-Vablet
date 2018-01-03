/********************************************************************************
Apex Class Name - ClsQuestionLightningController_Test
Version - 1.0
Created Date- 12-June-2017 by - Shashank 
Function - This class will be used for test coverage of ClsQuestionLightningController.
********************************************************************************/

@isTest
public class ClsQuestionLightningController_Test{

        Static testMethod void testClsApexUtil1()
        {
            test.startTest();
            
                Question__c ques= ClsTestDataUtility.createGlobalQuestion();
                insert ques;
                user u = ClsTestDataUtility.createUser('Belgium','Belgium');
                System.runAs(u){ 
                Question__c ques1= ClsTestDataUtility.createLocalQuestion();
                insert ques1;
                }
                
                ClsQuestionLightningController.getRecordTypeId('Question__c','Global Question');
                ClsQuestionLightningController.getRecordTypeId('Question__c','Account Profile Question');
                ClsQuestionLightningController.getUserInfo();
                ClsQuestionLightningController.getQuestionRecordTypes();
                ClsQuestionLightningController.getCountryValues();
                
                ClsQuestionLightningController.getMajorCategory(u.BST_SECONDARY_COUNTRY__c);
                ClsQuestionLightningController.getCategory('Renal');
                
                ClsQuestionLightningController.getQuestionType();
                ClsQuestionLightningController.getResponseType();
                ClsQuestionLightningController.getSalesforceGroup(u.BST_SECONDARY_COUNTRY__c);
                ClsQuestionLightningController.getSalesProcess();
                ClsQuestionLightningController.getStatus();
                ClsQuestionLightningController.getProfileType();
                ClsQuestionLightningController.saveQuestion(ques);
                ClsQuestionLightningController.getQuestionDetails(ques.Id);
                ClsQuestionLightningController.getUserCountry();
                ClsQuestionLightningController.getHelptextMap();
            test.stopTest();
        
        }
        
        
        
}