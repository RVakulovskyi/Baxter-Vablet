/********************************************************************************
Apex Class Name - ClsLookupSObjectController
Version - 1.0
Created Date - Nov 3, 2016
Function - Apex Class for getting the search result on the basis 
           of the name in sObject Specify by the calling function
           
           

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Gaurav Jain             11/4/2016           Original Version
* Arpit Agarwal           06/09/2017          Change for Question Epic
* Arpit Agarwal			  08/22/2017 		  Change for BOOS-240	 
********************************************************************************/

public with sharing class ClsLookupSObjectController {
    
    /**
     * Function Name: lookup
     * Purpose: Aura enabled method to search a specified SObject for a specific string
     * 
     * @param searchString :    string conatins value to be search against name field
     * @param sObjectAPIName:   string contains sObject Api Name
     * 
     * Return Type: List<LookupSObjectController.Result>     
     * 
     */    
    @AuraEnabled
    public static List<ClsLookupSObjectController.Result> lookup(String searchString, String sObjectAPIName, String recordTypeName, String fieldsToDisplay, String currRecord, Boolean isForBUProfiling)
    {
        List<ClsLookupSObjectController.Result> results = new List<Result>();
        
         system.debug('recordTypeName'+recordTypeName);     
        String searchQuery;
        
        //Check if search or sObjectAPIName string is blank or null
        if(String.isBlank(searchString) && String.isBlank(sObjectAPIName))
            return results;
        
        // Sanitze the input  
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedFieldNames;
        List<String> sanitizedFieldsList;
        
        if(fieldsToDisplay != null) {
            sanitizedFieldNames = String.escapeSingleQuotes(fieldsToDisplay);
            sanitizedFieldsList = sanitizedFieldNames.split(',');
            String blank = '';
            while(sanitizedFieldsList.size() < 3) {
                sanitizedFieldsList.add(blank);
            }
            
        }
            
        else {
            sanitizedFieldNames = 'Name';
            
        }
        
        Set<Id> recordIds = new Set<Id>();
        if(sObjectAPIName == 'Account') 
        {
            if(isForBUProfiling == true)
            {   String namesearch= '%'+searchString+'%';
                List<Account> acr = [SELECT Id FROM Account where RecordType.DeveloperName IN ('BST_IMS_Account') and Name like :namesearch];         
                for(Account a : acr)
                {
                recordIds.add(a.Id);
                }
            } else
            {
                System.debug('###filtering by account');
                List<AccountContactRelation> acr = [SELECT AccountId FROM AccountContactRelation where ContactId = :currRecord];
                
                for(AccountContactRelation a : acr) 
                    {
                    recordIds.add(a.AccountId);
                    }
            }
        }
        
        if(sObjectAPIName == 'Question__c') {           
          List<Question__c> ques = new List<Question__c>();
		  if(recordTypeName == 'Account Profile Question'){		  
			  ques = [SELECT Id FROM Question__c where BST_Status__c =:'Active' and RecordType.DeveloperName = :'BST_Global_Question' and BST_PROFILE_TYPE__c = :'Account'];
		  }	   
		  else if(recordTypeName == 'Contact Profile Question'){
			  ques = [SELECT Id FROM Question__c where BST_Status__c =:'Active' and RecordType.DeveloperName = :'BST_Global_Question' and BST_PROFILE_TYPE__c = :'Contact'];
		  }	  
			  System.debug('The values are :' +ques);
			  for(Question__c q : ques) {
				recordIds.add(q.Id);
          }
        }
        
        if(sObjectAPIName == 'Contact') {
            System.debug('###filtering by contact');
            List<AccountContactRelation> acr = [SELECT ContactId FROM AccountContactRelation where AccountId = :currRecord];
            
            for(AccountContactRelation a : acr) {
                recordIds.add(a.ContactId);
            }
        }
        
         //Adding Code for campaign
         if(sObjectAPIName == 'Campaign') {
          System.debug('###filtering by Campaign');
           List<Campaign> acr = [SELECT id FROM Campaign where BST_Country__c = :currRecord and IsActive = True and (Type =:system.label.BST_Type_Event or Type =:system.label.BST_Type_Opportunity) and (RecordType.Name =:system.label.BST_RecordType_Lead_Metrics or RecordType.Name =:system.label.BST_RecordType_Lag_Metrics)];          
             
          for(Campaign a : acr) {
            recordIds.add(a.id);
          }
        }
        
        if(sObjectAPIName == 'Account' || sObjectAPIName == 'Contact')
        // Build our SOSL query
        searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN All FIELDS RETURNING ' + sanitizedSObjectAPIName + '(Id,' + sanitizedFieldNames + ' WHERE Id IN :recordIds) Limit 5';         
         else
            searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN All FIELDS RETURNING ' + sanitizedSObjectAPIName + '(Id,' + sanitizedFieldNames + ' WHERE Id IN :recordIds) Limit 5';         

        
        system.debug('searchQuery is ' + searchQuery);
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
                     
        // Create a list of matches to return
        for (SObject so : searchList[0])
        {
            if(sanitizedFieldsList[1] == '' && sanitizedFieldsList[2] != '')
                results.add(new Result((String)so.get(sanitizedFieldsList[0]), so.Id, null, null, (String)so.get(sanitizedFieldsList[2]), sanitizedFieldsList[2], sObjectAPIName));
            
            if(sanitizedFieldsList[2] == '' && sanitizedFieldsList[1] != '')
                results.add(new Result((String)so.get(sanitizedFieldsList[0]), so.Id, (String)so.get(sanitizedFieldsList[1]), sanitizedFieldsList[1], null, null, sObjectAPIName));
            
            if(sanitizedFieldsList[1] == '' && sanitizedFieldsList[2] == '')
                results.add(new Result((String)so.get(sanitizedFieldsList[0]), so.Id, null, null, null, null, sObjectAPIName));
                
            if(sanitizedFieldsList[1] != '' && sanitizedFieldsList[2] != '')
                results.add(new Result((String)so.get(sanitizedFieldsList[0]), so.Id, (String)so.get(sanitizedFieldsList[1]), sanitizedFieldsList[1], (String)so.get(sanitizedFieldsList[2]), sanitizedFieldsList[2], sObjectAPIName));
            
        }
        return results;
        
    }
    
    /**
     * Inner class to wrap up an SObject Label and its Id
     */
    public class Result
    {
        @AuraEnabled public String SObjectLabel;
        @AuraEnabled public Id SObjectId;
        @AuraEnabled public String sObjectExtraField1;
        @AuraEnabled public String sObjectExtraField1Label;
        @AuraEnabled public String sObjectExtraField2;
        @AuraEnabled public String sObjectExtraField2Label;
        @AuraEnabled public String sObjectAPIName;
         
        public Result(String sObjectLabel, Id sObjectId, String sObjectExtraField1, String sObjectExtraField1Label, String sObjectExtraField2, String sObjectExtraField2Label, String sObjectAPIName)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
            this.sObjectAPIName = sObjectAPIName;
            this.sObjectExtraField1 = sObjectExtraField1;
            this.sObjectExtraField2 = sObjectExtraField2;
            
            if(sObjectExtraField1Label != null)
                this.sObjectExtraField1Label = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().fields.getMap().get(sObjectExtraField1Label).getDescribe().getLabel();
            
            if(sObjectExtraField2Label != null)
                this.sObjectExtraField2Label = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().fields.getMap().get(sObjectExtraField2Label).getDescribe().getLabel();
        }
    }
}