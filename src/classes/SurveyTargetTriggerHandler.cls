/********************************************************************************
Apex Class Name - SurveyTargetTriggerHandler 
Version - 1.0
Created Date - July 21, 2017
Description - Trigger Handler class for Survey Target.

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     07/21/2017           Original Version
********************************************************************************/
public class SurveyTargetTriggerHandler {
    
    /*
     * Handle beforeUpdate trigger event
    */       
    public static void handleBeforeUpdate(list<Survey_Target__c> newSurveyTarget, list<Survey_Target__c> oldSurveyTarget, 
    										map<Id, Survey_Target__c> newMap, map<Id, Survey_Target__c> oldMap)
    {
    	map<Id,Survey_Target__c> completedSurvey = new map<Id,Survey_Target__c>();
    	map<Id,String> surveyAccountMap = new map<Id,String>();
    	map<Id, TerritoryHierarchy> surveyHierarchyMap = new Map<Id, TerritoryHierarchy>();
    	map<Id, Id> surveyTerritoryMap = new Map<Id, Id>();
    	
    	set<Id> accountList = new set<Id>();
     	for(Survey_Target__c survey : newSurveyTarget){
    		if(survey.status__c == 'Completed' && oldMap.get(survey.Id).status__c != survey.status__c){
    			completedSurvey.put(survey.Id, survey);
    			surveyAccountMap.put(survey.Id,survey.account__c + '~' + survey.sales_group__c);
    			accountList.add(survey.account__c);
    		}
    	}
    	if(completedSurvey.size() > 0){
    		surveyHierarchyMap = TerritoryHierarchyHelper.getAccountHierarchy(accountList, surveyAccountMap);
    		for(Survey_Target__c survey : newSurveyTarget){
    			if(surveyHierarchyMap.get(survey.Id) != NULL && surveyHierarchyMap.get(survey.Id).TBMcode!= NULL){
		    		survey.Territory__c  = surveyHierarchyMap.get(survey.Id).TBMcode;
					survey.Territory_Up_Level1__c = surveyHierarchyMap.get(survey.Id).RBMcode;
					survey.Territory_Up_Level2__c = surveyHierarchyMap.get(survey.Id).AVPcode;
					survey.Territory_Business_Manager__c = (surveyHierarchyMap.get(survey.Id).TBMuser != NULL?surveyHierarchyMap.get(survey.Id).TBMuser:NULL);
					survey.Regional_Business_Manager__c = (surveyHierarchyMap.get(survey.Id).RBMuser != NULL?surveyHierarchyMap.get(survey.Id).RBMuser:NULL);
					survey.Area_Vice_President__c = (surveyHierarchyMap.get(survey.Id).AVPuser != NULL?surveyHierarchyMap.get(survey.Id).AVPuser:NULL);
					//optout handling
					if(survey.Opt_Out__c && survey.recipient_id__c != NULL){
						survey.recipient_id__c = survey.recipient_id__c.substring(survey.recipient_id__c.IndexOf('MLRP'));
					}
					surveyTerritoryMap.put(survey.Id, surveyHierarchyMap.get(survey.Id).TBMID);
	    		}
    		}
    		if(surveyTerritoryMap.size() > 0)
				SurveyTargetHelper.shareSurveyTBMTerritory(surveyTerritoryMap);
    	}
    } 
    
    /*
     * Handle afterInsert trigger event
    */    
    public static void handleAfterInsert(list<Survey_Target__c> newSurveyTarget)
    {
          
    }

    /*
     * Handle afterUpdate trigger event
    */    
    public static void handleAfterUpdate(map<Id, Survey_Target__c> newMap, map<Id, Survey_Target__c> oldMap)
    {
    	list<Id> stTaskClose = new list<Id>(); 
    	list<Id> stTaskUpdate = new list<Id>();    
    	map<String,String> optOutList = new map<String,String>(); 	
     	for(Survey_Target__c survey : newMap.values()){
    		if(survey.status__c == 'Completed'){
	    		if(String.isBlank(oldMap.get(survey.Id).root_cause__c) && String.isNotBlank(newMap.get(survey.Id).root_cause__c)){
	    			stTaskClose.add(survey.id);
	    		}
	    		else if(String.isBlank(oldMap.get(survey.Id).comments__c) && String.isNotBlank(newMap.get(survey.Id).comments__c)){
	    			stTaskUpdate.add(survey.id);
	    		}
	    		
	    		if(survey.Opt_Out__c && survey.recipient_id__c != NULL && oldMap.get(survey.Id).recipient_id__c == NULL){
	    			optOutList.put(survey.recipient_id__c, survey.contact_email__c);
	    		}
    		}

    	}
    	if(stTaskClose.size() > 0)
    		SurveyTargetHelper.closeDetractorTask(stTaskClose);	 
    	if(stTaskUpdate.size() > 0)
    		SurveyTargetHelper.updateDetractorTaskStatus(stTaskUpdate);	   
    	/*if(optOutList.size() > 0)
    		SurveyTargetHelper.optoutInQualtrics(optOutList);
    	*/	    
    }
}