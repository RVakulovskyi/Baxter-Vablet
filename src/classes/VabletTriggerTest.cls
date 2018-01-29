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
* Rodion Vakulovskyi	  09/01/2018		   modifying class
************************************************************************************************/

@isTest
public class VabletTriggerTest{
    
    public static testMethod void CreateMediaviewTestMethod(){
   		VabletTestUtility.createCustomSettings();
        Task t= new Task();
        t.File_ID__c ='273175,272933';
        t.Description='<div style="word-wrap: break-word;width:500px" id="wrapperContainer">‌</div><br /><br />File name (attached): <br />Update_iPad_to_iOS_8.docx<br /><br /><br />File name (attached): <br />Sample_2.pdf<br /><br />';
        insert t;
        Integer sizeOfList  = [SELECT Id FROM Media_view__c].size(); 
        System.assertEquals(true,sizeOfList > 0, 'Size should be more than 0');
    }

	public static testMethod void CreateMediaviewElseTestMethod(){
   		VabletTestUtility.createCustomSettings();
        Task t= new Task();
        t.File_ID__c ='273175,272933';
        t.Description='<div style="word-wrap: break-word;width:500px" id="wrapperContainer">‌</div><br /><br />File name: <br />Update_iPad_to_iOS_8.docx<br /><br /><br />File name: <br />Sample_2.pdf<br /><br />';
        insert t;
        Integer sizeOfList  = [SELECT Id, File_ID__c FROM Media_view__c].size(); 
        System.assertEquals(false, sizeOfList > 0, 'Size should be  0.Because of wrong separators');
    }
}