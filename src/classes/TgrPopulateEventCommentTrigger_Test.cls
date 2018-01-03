//Akshay 11/23/2016
//Description - This class will be used for test coverage of TgrPopulateEventCommentTrigger trigger on Event

@isTest
public class TgrPopulateEventCommentTrigger_Test{

    
    static testMethod void testEventUpdate(){
        test.startTest();
	 //Changes 25-Oct-17 Start
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        u.BST_MAIN_BAXTER_TEAM__c = 'HC - BioSurgery';
        u.BST_OTHER_BAXTER_TEAM__c='Bax Company/Services'; 
        //insert u;
        //System.runAs(u) {
            list<Account> accountList = new list<Account>();
            Account acc1 = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open', 
                                       billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
            accountList.add(acc1);
            insert accountList;
            list<Contact> contactList = new list<contact>();
            Contact con = new Contact();
            con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId();
            con.Salutation = 'Mr.';
            con.FirstName = 'ContactMe';
            con.LastName = 'Now';
            con.AccountId = accountList[0].Id;
            con.DP_IND_GENDER__c = 'Male';
            con.DP_IND_STATUS__c = 'Valid';
            con.DP_IND_STATE__c = 'Active';
            con.DP_IND_PROFESSIONAL_TYPE__c = 'Nurse';
            con.DP_IND_SPEC_1__c = 'Student';
            con.BST_COUNTRY__c = 'Belgium';
            contactList.add(con);
            //insert con;
            insert contactList;
            Event eve = new event();
            eve.IsAllDayEvent = true;
            eve.OwnerId = UserInfo.getUserId();
            eve.BST_BEST_OUTCOME__c='test';
            eve.BST_CALL_OBJ__c='test';
            eve.BST_BAX_SALES_TEAM__c='Bax Company/Services';
            eve.BST_MAIN_TOPIC__c='Advanced Logistics Services';
            eve.BST_MIN_OUTCOME__c='asdas';
            eve.Description = 'test karthik 2510';
            eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Field Customer Call').getRecordTypeId();
            eve.WhoId = contactList[0].Id;
            eve.BST_CALL_TYPE__c = 'Third Party Congress';
            eve.WhatId = acc1.Id;
            eve.Subject = 'test karthik 2510';
            eve.ActivityDate = Date.Today();
            eve.BST_COUNTRY__c = 'Belgium';
            eve.BST_CALL_NOTES__c = 'test'; //Added 11-Jan-2017
            eve.BST_OUTCOME_STATUS__c = 'Continuation'; //Added 11-Jan-2017
            eve.BST_SEC_PROD_CATH__c = 'HC - BioSurgery'; //Added 11-Jan-2017
			eve.BST_STATUS__c = 'Completed';
            insert eve;
            eve.WhoId = null; //Updating contact for event to cover methods insertEventPrimaryContact and updateEventPrimaryContact
            eve.Description = 'Test First';
           
            update eve;            
       // }
	 //Changes 25-Oct-17 End
        test.stopTest();
    }
    static testMethod void testEventNonAdminInsert(){
     /*
        test.startTest();
      user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        u.BST_MAIN_BAXTER_TEAM__c = 'HC - BioSurgery';
        u.BST_OTHER_BAXTER_TEAM__c='Bax Company/Services'; 
        System.runAs(u) {
            Event eve = ClsTestDataUtility.createEvent();
            insert eve;
  //Changes 21-Feb-17 Start
            Contact con1 = ClsTestDataUtility.createContact();
            insert con1; 
            eve.whoid = con1.id;
  //Changes 21-Feb-17 End
            eve.Description = 'Descrp';
            update eve; 
            system.assertEquals(eve.whoId,con1.Id); //Changed on 21-Feb-17 
        }
        test.stopTest();*/
    }  
    
   
    // This method tests event deletion with logged in user has matching criteria in custom metadata types
    static testMethod void testPreventCompletedEventDeletion()
    {
        Profile pId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'Test Last Name', FirstName='Test First Name', Alias = 'Test', Email = 'test@test.com', 
                          Username = 'abcs@123test.com', ProfileId = pId.id, TimeZoneSidKey = 'GMT', 
                          LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',
                          BST_COUNTRY__c='Turkey', BST_MAIN_BAXTER_TEAM__c='Bax Company/Services');
        insert u;
        
        test.startTest();
        System.runAs(u)
        {
            Event eve = new Event();
            //Event eve = ClsTestDataUtility.createEvent();  - commented on 10/17
            try{
                // Inserting event record 
                eve.IsAllDayEvent = true;
                eve.OwnerId = UserInfo.getUserId();
                eve.BST_BEST_OUTCOME__c='test';
                eve.BST_CALL_OBJ__c='test';
                eve.BST_BAX_SALES_TEAM__c='Bax Company/Services';
                eve.BST_MAIN_TOPIC__c='Advanced Logistics Services';
                eve.BST_MIN_OUTCOME__c='asdas';
                eve.Description = 'test';
                eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Field Customer Call').getRecordTypeId();
                eve.BST_CALL_TYPE__c='Third Party Congress';
                eve.Subject = 'Call';
                eve.ActivityDate = Date.Today();
                eve.BST_COUNTRY__c = 'France';
                eve.BST_CALL_NOTES__c = 'test'; 
                eve.BST_OUTCOME_STATUS__c = 'Continuation'; 
                eve.BST_SEC_PROD_CATH__c = 'HC - BioSurgery';
                insert eve;
            }catch(exception e){
                system.debug('exception+ '+e.getLineNumber() + 'e message '+e.getMessage());
            }
            try
            {
               delete eve;    
            }
            catch(DMLException e)
            {
                system.assertNotEquals('Event Deleted', e.getMessage());
            }catch(exception e){
                system.debug('exception+ '+e.getLineNumber() + 'e message '+e.getMessage());
            }
            
        }
        test.stopTest();
    }
    
    // This method tests event deletion with logged in user has no matching criteria in custom metadata types
    static testMethod void testEventDeletion()
    {
        Profile pId = [SELECT Id FROM Profile WHERE Name = 'BOOST – Sales Representative' LIMIT 1];
        User u = new User(LastName = 'Test Last Name', FirstName='Test First Name', Alias = 'Test', Email = 'test@test.com', 
                          Username = 'abcs@123test.com', ProfileId = pId.id, TimeZoneSidKey = 'GMT', 
                          LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',
                          BST_COUNTRY__c='Belgium', BST_MAIN_BAXTER_TEAM__c='Bax Company/Services');
        insert u;
        
        test.startTest();
        System.runAs(u)
        {
            Event eve = new Event();
            //Event eve = ClsTestDataUtility.createEvent();  - commented on 10/17
            try{
                // Inserting event record 
                eve.IsAllDayEvent = true;
                eve.OwnerId = UserInfo.getUserId();
                eve.BST_BEST_OUTCOME__c='test';
                eve.BST_CALL_OBJ__c='test';
                eve.BST_BAX_SALES_TEAM__c='Bax Company/Services';
                eve.BST_MAIN_TOPIC__c='Advanced Logistics Services';
                eve.BST_MIN_OUTCOME__c='asdas';
                eve.Description = 'test';
                eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Field Customer Call').getRecordTypeId();
                eve.BST_CALL_TYPE__c='Third Party Congress';
                eve.Subject = 'Call';
                eve.ActivityDate = Date.Today();
                eve.BST_COUNTRY__c = 'Belgium';
                eve.BST_CALL_NOTES__c = 'test'; 
                eve.BST_OUTCOME_STATUS__c = 'Continuation'; 
                eve.BST_SEC_PROD_CATH__c = 'HC - BioSurgery';
                eve.BST_STATUS__c='Scheduled';
                insert eve;
            }catch(exception e){
                system.debug('exception+ '+e.getLineNumber() + 'e message '+e.getMessage());
            }
            try
            {
               delete eve;    
            }
            catch(DMLException e)
            {
                system.assertNotEquals('Event Deleted', e.getMessage());
            }catch(exception e){
                system.debug('exception+ '+e.getLineNumber() + 'e message '+e.getMessage());
            }
            
        }
        test.stopTest();
    }
    
}