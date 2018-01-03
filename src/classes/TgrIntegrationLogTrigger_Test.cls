//Akshay 11/23/2016
//Description: - This class will be used for test coverage of TgrIntegrationLogTrigger trigger on Integration Log.

@isTest
public class TgrIntegrationLogTrigger_Test{

      /* Test method to check approval process on object Integration Log. */
      static testMethod void testINTEGRATION_LOGNonAdminInsert(){
          test.starttest();
          User u = ClsTestDataUtility.createuser('Belgium','Belgium');
          Account acc = ClsTestDataUtility.createAccount('Belgium');
        
          System.runAs(u) {
              Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
              Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
              Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
              acc.recordtypeid=rtByName.getRecordTypeId();
              insert acc;
              //List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
              //system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
          }
 
          INTEGRATION_LOG__c iLog= new INTEGRATION_LOG__c();
          iLog = [select id, BST_Country__c from INTEGRATION_LOG__c where BST_ACCOUNT_ID__c =:acc.id limit 1];
          ilog.BST_STATUS__c='Baxter Rejected';
          iLog.BST_TYPE__c='Account Update';  
          update iLog;
          //system.assertEquals(acc.BST_Country__c,iLog.BST_Country__c,'Error');
          
          test.stopTest();
     }
     static testMethod void testEventDetailsMDT(){
         test.startTest();
         INTEGRATION_LOG__c iLog= ClsTestDataUtility.createINTEGRATION_LOG();
         insert iLog;
         ClsApexUtil.getPossibleLOVs('Field Customer Call','BST_BAX_SALES_TEAM__c');
         ClsApexUtil.getWorkItemId(iLog.Id);
         ClsApexUtil.rejectRecord(iLog,'Rejected');
         test.stopTest();
     }
}