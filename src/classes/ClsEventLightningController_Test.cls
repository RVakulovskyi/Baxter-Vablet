//Akshay 11/23/2016
//Description - This class will be used for test coverage of ClsEventLightningController.

@isTest
public class ClsEventLightningController_Test{
    
    Static testMethod void testClsApexUtil(){
        test.startTest();
        //Changes 25-10-2017 start
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        u.BST_MAIN_BAXTER_TEAM__c = 'HC - BioSurgery';
        u.BST_OTHER_BAXTER_TEAM__c='Bax Company/Services'; 
        System.runAs(u) {
            Account acc = new Account();
            acc.Name = 'test Account';
            acc.BST_COUNTRY__c = 'Belgium';
            // acc.BST_Account_Number__c='anum123456' ;
            acc.billingStreet = 'Test 123';
            acc.billingState = 'Test State';
            acc.billingCountry = 'Test Country';
            acc.billingCity = 'Test City';
            acc.billingPostalCode = '1111';
            acc.BST_BAX_SALES_TEAM__c = 'Other';
            acc.DP_WKP_STATUS__c = 'Valid';
            acc.DP_WKP_STATE__c = 'Open';
            Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
            acc.recordtypeid=rtByName.getRecordTypeId();
            insert acc; 
            
            List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
            if(iList.size()>0)
                system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
            system.assertEquals('Belgium',acc.BST_Country__c,'Country updation failed'); 
            
            Contact con = new contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId();
            con.Salutation = 'Mr.';
            con.FirstName = 'First Test';
            con.LastName = 'Last Test';
            con.AccountId = acc.Id;
            con.DP_IND_GENDER__c = 'Male';
            con.DP_IND_STATUS__c = 'Valid';
            con.DP_IND_STATE__c = 'Active';
            con.DP_IND_PROFESSIONAL_TYPE__c = 'Nurse';
            con.DP_IND_SPEC_1__c = 'Student';
            con.BST_COUNTRY__c = 'Belgium';
            insert con;
            
            List<AccountContactRelation> acccRelLst = [SELECT ContactId FROM AccountContactRelation WHERE ContactId =:con.Id];
            if(acccRelLst.size()>0)
                system.assertEquals(con.Id,acccRelLst[0].ContactId);
            
            Event eve = new event();
            eve.IsAllDayEvent = true;
            eve.BST_BEST_OUTCOME__c='test';
            eve.BST_CALL_OBJ__c='test';
            eve.BST_BAX_SALES_TEAM__c='Bax Company/Services';
            eve.BST_MAIN_TOPIC__c='Advanced Logistics Services';
            eve.BST_MIN_OUTCOME__c='asdas';
            eve.Description = 'test';
            eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Field Customer Call').getRecordTypeId();
            eve.WhoId = con.Id;
            eve.WhatId = acc.Id;
            eve.OwnerId = UserInfo.getUserId();
            eve.BST_COUNTRY__c = 'Belgium';
            eve.Subject = 'Call';
            eve.ActivityDate = Date.Today();
            eve.BST_COUNTRY__c = 'Belgium';
            eve.BST_CALL_NOTES__c = 'test'; //Added 11-Jan-2017
            eve.BST_OUTCOME_STATUS__c = 'Continuation'; //Added 11-Jan-2017
            eve.BST_SEC_PROD_CATH__c = 'HC - BioSurgery'; //Added 11-Jan-2017
            insert eve;
            //changes 25-10-2017 End
            list<id> currId = new list<id>();
            currId.add(eve.WhatId);                 //13/10/17(KP)
            DateTime startDate = system.now();      //13/10/17(KP)
            ClsEventLightningController.getContact(con.Id);
            ClsEventLightningController.getEndDateTime(startDate); //13/10/17(KP)
            ClsEventLightningController.getAccount(acc.Id);
            ClsEventLightningController.getUserCountry();
            ClsEventLightningController.getRecordTypeId('Account','IMS Account');
            ClsEventLightningController.getUserInfo();
            ClsEventLightningController.getUserMPC();
            ClsEventLightningController.getCountryValues();
            ClsEventLightningController.getEventTypeValues('Field Sales Call');
            ClsEventLightningController.getMainProductCategoryValues('IMS Account','Belgium');
            ClsEventLightningController.getMainTopicValues('Non Field Sales Activity','Bax Company/Services');
            ClsEventLightningController.getEventRecordTypes();
            ClsEventLightningController.getAssociatedContacts(con.Id);
            ClsEventLightningController.getUserProfile();
            ClsEventLightningController.getProfileId();
            ClsEventLightningController.getChatterUpdate(currId); //13/10/17(KP)
        }
        test.stopTest();
    }
    
    Static testMethod void testClsApexUtil2(){
        test.startTest();  
        Account acc = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123',
                                  RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(),
                                  billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
        insert acc;
        
        List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
        if(iList.size()>0)
            system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
        system.assertEquals('Belgium',acc.BST_Country__c,'Country updation failed'); 
        
        Contact con= ClsTestDataUtility.createContact();
        con.FirstName = 'Test FirstName';
        con.LastName = 'LastName';
        con.Salutation = 'Mr.';
        insert con;
        
        Campaign camp = new campaign(Name = 'ABC',Type='Event',isActive=true,BST_Country__c='Belgium' , RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lead Metrics').getRecordTypeId() );
        //camp.Name='ABC';
        insert camp;
        
        List<AccountContactRelation> acccRelLst = [SELECT ContactId FROM AccountContactRelation WHERE ContactId =:con.Id];
        if(acccRelLst.size()>0)
            system.assertEquals(con.Id,acccRelLst[0].ContactId);
        
        Event eve = new Event();
        eve.IsAllDayEvent = true;
        eve.OwnerId = UserInfo.getUserId();
        eve.Description = 'test';
        eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Non Field Customer Activity').getRecordTypeId();
        eve.WhoId = con.Id;
        eve.WhatId = acc.Id;
        eve.Subject = 'Call';
        eve.ActivityDate = Date.Today();
        eve.BST_COUNTRY__c = 'Belgium';
        eve.BST_CALL_TYPE__c='Sector Alignment Meeting';//Added on 27/12/2016 to pass validation rule
        eve.BST_Associated_Critical_Metrics__c=camp.Id;
        ClsEventLightningController.saveEventWithContact(eve,con.Id,acc.Id,camp.Id);
        system.assert(eve.WhoId!= null);
        test.stopTest();
    }
    Static testMethod void testPickListEntryWrapper(){
        test.startTest();
        PicklistEntryWrapper p = new PicklistEntryWrapper();
        p.active = 'Active Test';
        p.defaultValue = 'Test defaultValue';
        p.label = 'Test label';
        p.value = 'Test value';
        p.validFor = 'Test validFor';
        test.stopTest();
    }
}