/*************************************************************************************************
Apex Trigger Name : TgrRelatedAccountTrigger                                                     *
Version : 1.0                                                                                    *
Created Date : 18/04/2017                                                                        *  
Function :  Trigger created to manage all actions for RelatedAccount object                      *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Nuno Fonseca              18/04/2017          New trigger framework to follow best practices   * 
* Rashmi Rani               24/04/2017          Trigger Logic to handle records for IMS Audit    *
*                                               process                                          *
*************************************************************************************************/
trigger TgrRelatedAccountTrigger on ACCOUNT_ACCOUNT_RELATION__c (before insert, before update, after insert, after update) 
{
    
    ClsIMSFieldAuditTriggerHandler relAccntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
          relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
          relAccntTriggerHandler.populateAccountAccountRelationCountry(trigger.new);
          relAccntTriggerHandler.processStatusUpdate(trigger.new); 
        }
        if(Trigger.isUpdate)
        {
          relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
          relAccntTriggerHandler.processInvalidRecords(Trigger.new); 
        }
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
          relAccntTriggerHandler.lstNewRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.newMap);
          relAccntTriggerHandler.triggerEvent = 'Create';
          relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
          relAccntTriggerHandler.processRecords(Trigger.new);   
        }
        if(Trigger.isUpdate)
        {
          relAccntTriggerHandler.lstNewRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.newMap);
          relAccntTriggerHandler.lstOldRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.oldMap);
          relAccntTriggerHandler.triggerEvent = 'Update';
          relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
          relAccntTriggerHandler.processRecords(Trigger.new);  
        }
    }
    
}