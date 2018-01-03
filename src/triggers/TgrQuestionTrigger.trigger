/*************************************************************************************************
Apex Trigger Name : TgrQuestionTrigger                                                            *
Version : 1.0                                                                                    *
Created Date : 21/06/2017                                                                        *  
Function :  Trigger created to manage all actions for Question object                            *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Arpit Agarwal            21/06/2017         Trigger Logic to handle records for Audit Logs     *
*                                             following framework for best practices             *
*                                                                                                *    
*************************************************************************************************/
trigger TgrQuestionTrigger on Question__c (after insert, after update) 
{
    
    ClsAuditLogFieldTracking auditTriggerHandler = new ClsAuditLogFieldTracking();
 
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
         auditTriggerHandler.lstNewRecordsMap= (Map<Id, Question__c>)(Trigger.newMap);
         auditTriggerHandler.triggerEvent = 'Create';
         auditTriggerHandler.sObjectType = 'Question__c';
         auditTriggerHandler.processRecords(Trigger.new);   
        }
        if(Trigger.isUpdate)
        {
         auditTriggerHandler.lstNewRecordsMap= (Map<Id, Question__c>)(Trigger.newMap);
         auditTriggerHandler.lstOldRecordsMap= (Map<Id, Question__c>)(Trigger.oldMap);
         auditTriggerHandler.triggerEvent = 'Update';
         auditTriggerHandler.sObjectType = 'Question__c';
         auditTriggerHandler.processRecords(Trigger.new);  
        }
    }
    
}