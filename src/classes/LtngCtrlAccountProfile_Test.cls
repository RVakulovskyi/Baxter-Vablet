/********************************************************************************
Apex Class Name - LtngCtrlAccountProfile_Test
Version - 1.0
Created Date - Nov 3rd, 2016
Function - Test class for  LtngCtrlAccountProfile 
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Dharani Pothula         11/03/2016           Original Version
* Shashank Mehra          13-june-2017         Added code for account and opportuity records insertion.
*******************************************************************************/

@isTest
public class LtngCtrlAccountProfile_Test {
    
    /**
    * Method Name: testGetAccount_ReturnAccount
    * Description: Checks for the current Account 
    * Parameter: None                             
    * Return Type: Account
    */
    public static testMethod void testGetAccount_ReturnAccount(){
        //Create Account with Account Number aNum1234
        
        Test.startTest();
        
        Account acc = new account();
        acc.Name = 'test name';
        acc.BST_COUNTRY__c = 'Belgium';
        acc.BST_Account_Number__c = 'aNum12345';
        acc.DP_WKP_STRUCTURE_TYPE__c = 'Organisation';
        acc.BillingStreet = 'test address';
        acc.BillingCity = 'test city';
        acc.BillingPostalCode = '102011';
        acc.BillingCountry = 'test country';
        insert acc;
        
        Opportunity Opp = new Opportunity();
        Opp.AccountId = acc.Id;
        Opp.name = 'Test Opp';
        Opp.StageName = 'Prospect';
        Opp.Closedate = date.today();
        Opp.BXGO_Country__c = 'Belgium';
        Opp.BXGO_Tender_Issued__c = date.today();
        insert Opp;
        
        
        Account testAccount = TestClassHelper.creatAccount();
        LtngCtrlAccountProfile.checkPermission();
        
        Account acc1 = LtngCtrlAccountProfile.getAccount(testAccount.Id);
        
        LtngCtrlAccountProfile.getAccountFromOpp(Opp.Id);
        
        system.assertEquals('aNum12345', acc.BST_Account_Number__c);  // Modified by Shashank
        Test.stopTest();
    }
    
    /**
    * Method Name: testGetOppty_ReturnAccount
    * Description: Checks for the oppty current Account 
    * Parameter: None                             
    * Return Type: Account
    */
    /*
    public static testMethod void testGetOppty_ReturnAccount(){
        //Create Account with Account Number aNum1234
        List<sObject> ls = Test.loadData(Trigger_Settings__c.sObjectType, 'ApexTestClassDataLoad_TriggerSettings');
        Opportunity testOpty = TestClassHelper.createOpportunity();
        testOpty.AccountId = TestClassHelper.accSList[0].Id;
        update testOpty;
        Account acc = LtngCtrlAccountProfile.getAccountFromOpp(testOpty.Id);
        system.assertEquals('aNum1234', acc.Account_Number__c);
        
    }
    */
    /** 
    * Method Name: getUIThemeDescription_ReturnString
    * Description: Checks for the current Theme 
    * Parameter: None                             
    * Return Type: String
    */
    public static testMethod void getUIThemeDescription_ReturnString(){
     
        String theme = LtngCtrlAccountProfile.getUIThemeDescription();
        
        system.assert(!string.isBlank(theme));
        
    }
}