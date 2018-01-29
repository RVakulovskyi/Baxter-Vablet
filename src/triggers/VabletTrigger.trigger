/***********************************************************************************************
Apex Trigger Name - VabletTrigger 
Version - 1.0
Created Date - June 26, 2015
Function - Capture the email literature from vablet

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     06/26/2015           vablet handler included
* Cognizant Developer     11/16/2015           Updated logic for calling VabletTriggerHandler
* Rodion Vakulovskyi	  02/01/2018		   modifying class
************************************************************************************************/

trigger VabletTrigger on Task (after insert) {
    List<Task> vabletTaskList = new List<Task>();
    for(task ts:Trigger.new){
        if (ts.File_ID__c != null && ts.File_ID__c != ''){
            vabletTaskList.add(ts);
        }
    }
    if(!vabletTaskList.isEmpty()){
        VabletTriggerHandler.handleafterInsert(vabletTaskList);
    }
}