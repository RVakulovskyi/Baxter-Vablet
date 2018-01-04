/***********************************************************************************************
Apex Trigger Name - VabletTriggerTest
Version - 1.0
Created Date - June 26, 2015
Function - Test clas for Vablet trigger Handler
Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     06/26/2015           vablet handler included
************************************************************************************************/

@isTest
public class VabletTriggerTest{
    
    public static testMethod void CreateMediaviewTestMethod(){
    	//Creating  Custom Settings
       // List<Trigger_Settings__c> triggerSetting = Test.loadData(Trigger_Settings__c.sObjectType, 'ApexTestClassDataLoad_TriggerSettings');
		VabletTestUtility.createCustomSettings();
        Task t= new Task();
        t.File_ID__c ='273175,272933';
        t.Description='<div style="word-wrap: break-word;width:500px" id="wrapperContainer">‌</div><br /><br />File name (attached): <br />Update_iPad_to_iOS_8.docx<br /><br /><br />File name (attached): <br />Sample_2.pdf<br /><br />';
        insert t;
        // Check if a Media_view__c record is created for the File
      //  String Fileid = [Select File_ID__c from Media_view__c where File_ID__c ='273175' limit 1].File_ID__c; 
       // System.assertEquals(Fileid,'273175');
    }
}