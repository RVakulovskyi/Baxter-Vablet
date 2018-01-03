// Akshay 11/25/2016
// Description - This class will be used for test coverage of ClsLookupSObjectController.

@isTest
public class ClsLookupSObjectController_Test{

    Static testMethod void Test_ClsLookupSObjectController1(){
        test.startTest();
        Account acc1 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Test Account1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', BST_Account_Number__c='12' ,
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
        insert acc1;
        
        List<INTEGRATION_LOG__c> iList1 = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc1.id limit 1];
        if(iList1.size()>0)
        system.assertEquals(acc1.Id,iList1[0].BST_ACCOUNT_ID__c,'Error');
        system.assertEquals('Belgium',acc1.BST_Country__c,'Country updation failed'); 
        
        Account acc2 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Test Account2',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', BST_Account_Number__c='1',
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
        insert acc2;
        
        List<INTEGRATION_LOG__c> iList2 = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc2.id limit 1];
        if(iList2.size()>0)
        system.assertEquals(acc2.Id,iList2[0].BST_ACCOUNT_ID__c,'Error');
        system.assertEquals('Belgium',acc2.BST_Country__c,'Country updation failed'); 
        
        Contact con1 = new Contact(RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId(), 
                          Salutation = 'Mr.', FirstName = 'First Test', LastName = 'Last Test', AccountId = acc1.Id, 
                          DP_IND_GENDER__c = 'Male', DP_IND_STATUS__c = 'Valid', DP_IND_STATE__c = 'Active', DP_IND_PROFESSIONAL_TYPE__c = 'Nurse', 
                          DP_IND_SPEC_1__c = 'Student', BST_COUNTRY__c = 'Belgium');
        insert con1;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = acc2.Id;
        acr.ContactId = con1.Id;
        acr.BST_COUNTRY__c = 'Belgium';
        system.debug('Value of acc2:' +acc2.Id);
        insert acr;    
      
        Test.setFixedSearchResults(new List<id>{acc2.Id});
        ClsLookupSObjectController.lookup('Test','Account','IMSAccount' ,'Name,billingState,billingCountry',con1.id,true);   
        test.stopTest(); 
   }
   
   Static testMethod void Test_ClsLookupSObjectController2(){
       
        test.startTest();
        Account acc1 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Test Account1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', BST_Account_Number__c='12',
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
        insert acc1;
      
        Account acc2 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Test Account2',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', BST_Account_Number__c='1' ,
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
        insert acc2;
      
        Contact con1 = new Contact(RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId(), 
                          Salutation = 'Mr.', FirstName = 'First Test', LastName = 'Last Test', AccountId = acc1.Id, 
                          DP_IND_GENDER__c = 'Male', DP_IND_STATUS__c = 'Valid', DP_IND_STATE__c = 'Active', DP_IND_PROFESSIONAL_TYPE__c = 'Nurse', 
                          DP_IND_SPEC_1__c = 'Student', BST_COUNTRY__c = 'Belgium');
        insert con1;
      
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = acc2.Id;
        acr.ContactId = con1.Id;
        acr.BST_COUNTRY__c = 'Belgium';        
        insert acr;    
        
        system.assertEquals(acc2.Id,acr.AccountId,'Insertion Failed');
        system.assertEquals(con1.Id,acr.ContactId,'Insertion Failed');
        
        Test.setFixedSearchResults(new List<id>{con1.Id});
        ClsLookupSObjectController.lookup('First Test','Contact','IMSContact' ,'FirstName',acc2.id ,true); 
        test.stopTest();   
   }
       // This is to cover the code of the class ClsLookupSObjectController (question object)
       Static testMethod void Test_ClsLookupSObjectController3() {  
        Test.startTest();
        list<Question__c> questobj = TestClassHelper.createQuestionRecs();
        system.assert(questobj.size()>0);
        /*
        list<Question__c> questobj2 = new list<Question__c>();
        for(Question__c obb:questobj){
            //obb.RecordType.DeveloperName = 'BST_Global_Question';
            obb.BST_Status__c = 'Active';
            questobj2.add(obb);
        }
        update questobj2;
        */
        ClsLookupSObjectController.lookup('Test','Question__c','AccountProfileQuestion','Name',questobj[0].id,True);        
        
        Test.StopTest();

       }
}