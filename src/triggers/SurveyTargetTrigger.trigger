/********************************************************************************
Apex Trigger Name - SurveyTargetTrigger 
Version - 1.0
Created Date - July 20, 2017
Function - This trigger is created for Survey_Target__c to fill additional detail on load


--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
********************************************************************************/
trigger SurveyTargetTrigger on Survey_Target__c (before update, after update) 
{  
		
	if(Trigger.isBefore && Trigger.isUpdate){
		SurveyTargetTriggerHandler.handleBeforeUpdate(Trigger.new,Trigger.old, Trigger.newMap, Trigger.oldMap);  
	}
	
	if(Trigger.isAfter && Trigger.isUpdate){
		SurveyTargetTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);  
	}
}