/*************************************************************************************************
Apex Class Name : ClsAuditLogFieldTracking                                                       *
Version : 1.0                                                                                    *
Created Date : 21/06/2017                                                                        *  
Function :  Handler class for creating Audit records when a new Question/Answer is created       *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Arpit Agarwal            21/06/2017         Handler class for creating Audit records when a    *
*                                             new Question/Answer is created                     *
*                                                                                                *    
*************************************************************************************************/
public class ClsAuditLogFieldTracking
{

    public Map<Id, SObject> lstNewRecordsMap = new Map<Id, SObject>();//Holds new map from the object trigger
    public Map<Id, SObject> lstOldRecordsMap = new Map<Id, SObject>();//Holds oldmap from the object trigger
    public String triggerEvent;//Holds the event being Create or Update
    public String sObjectType;//Holds the SObject type

    private Map<String, List<String>> auditFieldValuesMap = new Map<String, List<String>>();//Holds the ims updated fields and their values. Key in map will be Field API and the list will have 3 items, first item is field label, second item is field new value and third item is field old value
    
/**
    * Method Name: processRecords
    * Description: Method to process all triggered records
    * Parameter: List
    * Return Type: Void
    */    
    
    public void processRecords(List<SObject> recList)
    {                   
        if(triggerEvent == 'Create')
        {
            for(Id sObjectId : lstNewRecordsMap.keySet())
            {
                sObject sObj = lstNewRecordsMap.get(sObjectId);//Get current sObject 
                //Get all the changed IMS Audit field values
                auditFieldValuesMap = ClsAuditLogUtil.getChangedFieldDetails (sObj.Id, sObjectType, triggerEvent, sObj, sObj);  
                createLogAuditRecords (sObjectId, triggerEvent, auditFieldValuesMap, sObjectType);
            }
        }
        
        if(triggerEvent == 'Update')
        {
           system.debug('@@@@@in update');

            for(Id sObjectId : lstNewRecordsMap.keySet())
            {
                system.debug('Enter first for loop with sobjectid' + sObjectId);
                sObject newSObj = lstNewRecordsMap.get(sObjectId);//Get sObject with new values
                sObject oldSObj = lstOldRecordsMap.get(sObjectId);//Get current sObject with old values
                
                auditFieldValuesMap = ClsAuditLogUtil.getChangedFieldDetails (newSObj.Id, sObjectType, triggerEvent, newSObj, oldSObj);//Get all the changed IMS Audit field values
                createLogAuditRecords(sObjectId, triggerEvent, auditFieldValuesMap, sObjectType);
            }
        }       
            
    }
    
/**
    * Method Name: processRecords
    * Description: Method used to create an IMS Integration Log Audit records
    * Parameter: Id, String, Map, List, String
    * Return Type: Void
    */    
    
    private static void createLogAuditRecords (Id objId, String triggerEvent, Map<String, List<String>>auditFieldValuesMap, String objType)
    {
      //Insert records in Audit_Log_Question__c for change in Question__c
      if(objType == 'Question__c'){  
        List<Audit_Log_Question__c> newAuditLogQuestion = new List<Audit_Log_Question__c>();         
        //Go through the auditFieldValuesMap and create the audit records, which will be used for update operation later
        for(String fieldName : auditFieldValuesMap.keySet())
        {
            List<String> fieldValLst = new List<String>();
            fieldValLst.addAll(auditFieldValuesMap.get(fieldName));
            Audit_Log_Question__c auditLogQuestion = new Audit_Log_Question__c();
            auditLogQuestion.BST_QUESTION__c = objId;
            auditLogQuestion.BST_FIELD_API_NAME__c = fieldName;
            auditLogQuestion.BST_FIELD_LABEL__c = fieldValLst[0];
            auditLogQuestion.BST_FIELD_NEW_VALUE__c = fieldValLst[1];
            if(triggerEvent == 'Update')
            auditLogQuestion.BST_FIELD_OLD_VALUE__c = fieldValLst[2];
            newAuditLogQuestion.add(auditLogQuestion);
        }
        
        if(!newAuditLogQuestion.isEmpty())
        {
            try
            {
                insert newAuditLogQuestion;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
      }
      
     //Insert records in Audit_Log_Account_Answer__c for change in Account_Profile__c   
      else if(objType == 'Account_Profile__c'){
          List<Audit_Log_Account_Answer__c> newAuditLogAccAnswer = new List<Audit_Log_Account_Answer__c>();         
        //Go through the auditFieldValuesMap and create the audit records, which will be used for update operation later
        for(String fieldName : auditFieldValuesMap.keySet())
        {
            List<String> fieldValLst = new List<String>();
            fieldValLst.addAll(auditFieldValuesMap.get(fieldName));
            Audit_Log_Account_Answer__c auditLogAccAnswer = new Audit_Log_Account_Answer__c();
            auditLogAccAnswer.BST_ACCOUNT_PROFILE__c = objId;
            auditLogAccAnswer.BST_FIELD_API_NAME__c = fieldName;
            auditLogAccAnswer.BST_FIELD_LABEL__c = fieldValLst[0];
            auditLogAccAnswer.BST_FIELD_NEW_VALUE__c = fieldValLst[1];
            if(triggerEvent == 'Update')
            auditLogAccAnswer.BST_FIELD_OLD_VALUE__c = fieldValLst[2];
            newAuditLogAccAnswer.add(auditLogAccAnswer);
        }
        
        if(!newAuditLogAccAnswer.isEmpty())
        {
            try
            {
                insert newAuditLogAccAnswer;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
      
      }  
    }
}