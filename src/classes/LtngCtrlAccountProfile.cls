/********************************************************************************
Apex Class Name - AccountProfileAllController
Version - 1.0
Created Date - Oct 31, 2016
Function - Apex Class for the Questionnaire Page to show All Questions and Account Profiles 
           for an Account
           -As the Account Pfoile is Saved on MII Account Refernce
           -without sharing is used to get access to the MII Account

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Dharani Pothula	      10/31/2016	       Original Version
* Shikhar Srivastava	  06/06/2017           Boost-Sprint1/Squad1
********************************************************************************/
public class LtngCtrlAccountProfile {
	
    /**
    * Method Name: getAccount
    * Description: Method to get Current Account, calls generic method in class ClsAccountDetailsUtility
    * Parameter: None                             
    * Return Type: Account
    */
    @AuraEnabled
    public static Account getAccount(Id accountId){
        return ClsAccountDetailsUtility.getAccount(accountId);
    }
	
    /**
    * Method Name: checkPermission
    * Description: Method to check whether user has permission to Account Profile
    * Parameter: None                             
    * Return Type: Boolean
    */
   
    @AuraEnabled
    public static Boolean checkPermission(){
        BST_Profile_User_Settings__c profileSetting = BST_Profile_User_Settings__c.getInstance();
        return profileSetting.BST_isWriteAccessForAccountProfile__c;
    }
    
     /**
    * Method Name: getAccountFromOpp
    * Description: Method to get Current Account, calls generic method in class ClsAccountDetailsUtility
    * Parameter: None                             
    * Return Type: Account
    */
    @AuraEnabled
    public static Account getAccountFromOpp(Id oppId){
        return ClsAccountDetailsUtility.getAccountFromOpp(oppId);
    }
    
	 /**
    * Method Name: getUIThemeDescription()
    * Description: Method to get the account of the recordId .
    * Parameter:   AccountId                             
    * Return Type: sObject
    */
    @AuraEnabled
    public static String getUIThemeDescription() {
        return ClsAccountDetailsUtility.getUIThemeDescription();
    }    
}