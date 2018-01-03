//Akshay 11/23/2016
//Description - This class will be used for creation of test data for all test classes


////Shashank 06/12/2017
// Description :- Added the method to create test records for question object.Methods added createGlobalQuestion() and  createLocalQuestion().


@isTest
public class ClsTestDataUtility{

    public static Question__c createGlobalQuestion()   
    {
        Question__c quest=new question__c();
        
        //quest.Name= 'Ques-0188';
        //quest.RecordtypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BST_Global_Question').getRecordTypeId();
        
        string strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Question__c' and Name = 'Global Question'].Id;
        quest.RecordtypeId=strRecordTypeId ;
        quest.BST_QUESTION_STATEMENT__c= 'This is a test record for Global Question';
        //quest.BST_PARENT_QUESTION__c=;
        //quest.BST_COUNTRY__c= 'Belgium';
        //quest.BST_MAJOR_CATEGORY__c='';
        //quest.BST_CATEGORY__c='';
        quest.BST_SALESFORCE_GROUP__c='AC;DS';
        //quest.BST_ORDER__c='';
        quest.BST_STATUS__c='Active';
        quest.BST_PROFILE_TYPE__c = 'Account';
        quest.BST_QUESTION_TYPE__c = 'Benelux Initiative';
        quest.BST_RESPONSE_VALID_TIME__c=1810;
        quest.BST_START_DATE__c=date.newInstance(2017 , 07 , 19);
        quest.BST_END_DATE__c=date.newInstance(2017 , 08 ,22);
        quest.BST_RESPONSE_TYPE__c='Number';
        quest.BST_PRIVATE__c=False;
        //quest.BST_MAJOR_CATEGORY__c = 'CRRT';
        
        
        return quest ;
    }
    
    public static Question__c createLocalQuestion()
    {
        Question__c quest1=new question__c();
        //quest1.Name= 'Ques-0166' ;
       //quest1.RecordtypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Account Profile Question').getRecordTypeId();
        
        string strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Question__c' and Name = 'Account Profile Question'].Id;
        quest1.RecordtypeId= strRecordTypeId;
        quest1.BST_QUESTION_STATEMENT__c= 'This is a test record for Local Question';
       // quest1.BST_PARENT_QUESTION__c= ;
        quest1.BST_COUNTRY__c= 'Belgium';
        quest1.BST_MAJOR_CATEGORY__c='Renal';
        quest1.BST_CATEGORY__c='Access';
        quest1.BST_SALESFORCE_GROUP__c='HD';
        quest1.BST_ORDER__c=222;
        quest1.BST_STATUS__c='Active';
        quest1.BST_RESPONSE_VALID_TIME__c=1810;
        quest1.BST_START_DATE__c=date.newInstance(2017 , 07 , 19);
        quest1.BST_END_DATE__c=date.newInstance(2017 , 08 ,22);
        quest1.BST_RESPONSE_TYPE__c='Number';
        quest1.BST_PRIVATE__c=False;
        
        return quest1 ;
    }  

  public static Account createAccount(String Country){
  
      Account acc = new account();
      acc.Name = 'test Account';
      acc.BST_COUNTRY__c = Country;
     // acc.BST_Account_Number__c='anum123456' ;
      acc.billingStreet = 'Test 123';
      acc.billingState = 'Test State';
      acc.billingCountry = 'Test Country';
      acc.billingCity = 'Test City';
      acc.billingPostalCode = '1111';
      acc.BST_BAX_SALES_TEAM__c = 'Other';
      acc.DP_WKP_STATUS__c = 'Valid';
      acc.DP_WKP_STATE__c = 'Open';

      return acc;
  }
  
  public static Contact createContact(){
      
      Account acc1 = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open', 
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
      insert acc1;
      
      Contact con = new Contact();
      con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId();
      con.Salutation = 'Mr.';
      con.FirstName = 'First Test';
      con.LastName = 'Last Test';
      con.AccountId = acc1.Id;
      con.DP_IND_GENDER__c = 'Male';
      con.DP_IND_STATUS__c = 'Valid';
      con.DP_IND_STATE__c = 'Active';
      con.DP_IND_PROFESSIONAL_TYPE__c = 'Nurse';
      con.DP_IND_SPEC_1__c = 'Student';
      con.BST_COUNTRY__c = 'Belgium';
      
      return con;
  }
  
  public static Event createEvent(){
      
      /*
      Account acc1 = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', 
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
      insert acc1;
      
      Contact con1 = new Contact(RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId(), 
                          Salutation = 'Mr.', FirstName = 'First Test', LastName = 'Last Test', AccountId = acc1.Id, 
                          DP_IND_GENDER__c = 'Male', DP_IND_STATUS__c = 'Valid', DP_IND_STATE__c = 'Active', DP_IND_PROFESSIONAL_TYPE__c = 'Student', 
                          DP_IND_SPEC_1__c = 'Student', BST_COUNTRY__c = 'Belgium');
      insert con1;
      */
      
      Account acc = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open', 
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
      insert acc;
      
      Contact con = ClsTestDataUtility.createContact();
      insert con;
      /*
      Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  

      User usr = new User(LastName = 'LIVESTON', FirstName='JASON', Alias = 'jliv', Email = 'jason.liveston@asdf.com', 
                          Username = 'jason.liveston@asdf.com', ProfileId = profileId.id, TimeZoneSidKey = 'GMT', 
                          LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');
      insert usr;
      */
      Event eve = new Event();
      eve.IsAllDayEvent = true;
      eve.OwnerId = UserInfo.getUserId();
      eve.BST_BEST_OUTCOME__c='test';
      eve.BST_CALL_OBJ__c='test';
      eve.BST_BAX_SALES_TEAM__c='Bax Company/Services';
      eve.BST_MAIN_TOPIC__c='Advanced Logistics Services';
      eve.BST_MIN_OUTCOME__c='asdas';
      eve.Description = 'test';
      eve.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Field Customer Call').getRecordTypeId();
      eve.WhoId = con.Id;
      eve.WhatId = acc.Id;
      eve.Subject = 'Call';
      eve.ActivityDate = Date.Today();
      eve.BST_COUNTRY__c = 'Belgium';
      eve.BST_CALL_NOTES__c = 'test'; //Added 11-Jan-2017
      eve.BST_OUTCOME_STATUS__c = 'Continuation'; //Added 11-Jan-2017
      eve.BST_SEC_PROD_CATH__c = 'HC - BioSurgery'; //Added 11-Jan-2017
      return eve;
  }
  
  public static INTEGRATION_LOG__c createINTEGRATION_LOG(){
      
      Account acc1 = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open',
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
      insert acc1;
      
      Contact con1 = new Contact(RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId(), 
                          Salutation = 'Mr.', FirstName = 'First Test', LastName = 'Last Test', AccountId = acc1.Id, 
                          DP_IND_GENDER__c = 'Male', DP_IND_STATUS__c = 'Valid', DP_IND_STATE__c = 'Active', DP_IND_PROFESSIONAL_TYPE__c = 'Nurse', 
                          DP_IND_SPEC_1__c = 'Student', BST_COUNTRY__c = 'Belgium');
      insert con1;
      
  INTEGRATION_LOG__c iLog = new INTEGRATION_LOG__c();
      iLog.BST_ACCOUNT_ID__c = acc1.Id;
      iLog.BST_CONTACT_ID__c = con1.Id;
      iLog.BST_COUNTRY__c = 'Belgium';
      iLog.BST_STATUS__c = 'IMS Accepted';
      iLog.BST_TYPE__c = 'Account Create';
      iLog.BST_COMMENTS__c = 'Test';
      
      return iLog;
  }
  
  public static ACCOUNT_ACCOUNT_RELATION__c createACCOUNT_ACCOUNT_RELATION(){
  
      Account acc1 = new Account(Name = 'Test Acc1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open', 
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
      insert acc1;
      
  ACCOUNT_ACCOUNT_RELATION__c aar = new ACCOUNT_ACCOUNT_RELATION__c();
      aar.DP_CHILD_ACCOUNT_ID__c = acc1.Id;
      aar.DP_PARENT_ACCOUNT_ID__c= acc1.Id;
      aar.BST_COUNTRY__c = 'Belgium';
      
      return aar;
  } 
  
  public static AccountContactRelation createAccountContactRelation(){
      
      List<Account> newAccounts = new List<Account>();
      Account acc1 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Test Account1',BST_COUNTRY__c = 'Belgium', billingStreet = 'Test 123', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open',
                          billingState = 'Test State', billingCountry = 'Test Country', billingCity = 'Test City', billingPostalCode = '1111');
     newAccounts.add(acc1);
      
      Account acc2 = new Account(RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(), 
                          Name = 'Unique Account',BST_COUNTRY__c = 'Belgium', billingStreet = 'GT Arena', DP_WKP_STATUS__c = 'Valid', DP_WKP_STATE__c = 'Open',
                          billingState = 'AP', billingCountry = 'US', billingCity = 'NYC', billingPostalCode = '345678');
      //newAccounts.add(acc2);
      insert newAccounts;
      
      Contact con1 = new Contact(RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId(), 
                          Salutation = 'Mr.', FirstName = 'First Test', LastName = 'Last Test', AccountId = newAccounts[0].Id, 
                          DP_IND_GENDER__c = 'Male', DP_IND_STATUS__c = 'Valid', DP_IND_STATE__c = 'Active', DP_IND_PROFESSIONAL_TYPE__c = 'Nurse', 
                          DP_IND_SPEC_1__c = 'Student', BST_COUNTRY__c = 'Belgium');
      insert con1;
      
  AccountContactRelation acr = [select AccountId,ContactId from AccountContactRelation where AccountId = :newAccounts[0].id];
      //acr.AccountId = newAccounts[1].Id;
      //acr.ContactId = con1.Id;
      //acr.BST_COUNTRY__c = 'Belgium';
      //[select AccountId,ContactId from AccountContactRelation where AccountId = :newAccounts[0].id];
      return acr;
  }

  public static User createUser(){
      
      Profile pId = [SELECT Id FROM Profile WHERE Name = 'BOOST – Sales Representative' LIMIT 1];
  
      User u = new User(LastName = 'Test Last Name', FirstName='Test First Name', Alias = 'Test', Email = 'test@test.com', 
                          Username = 'abcs@123test.com', ProfileId = pId.id, TimeZoneSidKey = 'GMT', 
                          LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');
      return u;
  }
  
  public static User createUser(String Country, String SecondaryCountry){
      
      Profile pId = [SELECT Id FROM Profile WHERE Name = 'BOOST – Sales Representative' LIMIT 1];
  
      User u = new User(LastName = 'Test Last Name', FirstName='Test First Name', Alias = 'Test', Email = 'test@test.com', 
                          Username = 'abcs@123test.com', ProfileId = pId.id, TimeZoneSidKey = 'GMT', 
                          LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');
      u.BST_COUNTRY__c=Country;
      u.BST_SECONDARY_COUNTRY__c=SecondaryCountry;
      u.BST_MAIN_BAXTER_TEAM__c='Bax Company/Services';                    
      return u;
  }        
}