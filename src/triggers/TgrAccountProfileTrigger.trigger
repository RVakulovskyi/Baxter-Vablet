/*************************************************************************************************
Apex Trigger Name : TgrAccountProfileTrigger                                                     *
Version : 1.0                                                                                    *
Created Date : 21/06/2017                                                                        *  
Function :  Trigger created to manage all actions for Account Profile object                     *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Arpit Agarwal            21/06/2017         Trigger Logic to handle records for Audit Logs     *
*                                             following framework for best practices             *
*                                                                                                *    
*************************************************************************************************/
trigger TgrAccountProfileTrigger on Account_Profile__c (after insert, after update) 
{
    
    ClsAuditLogFieldTracking auditTriggerHandler = new ClsAuditLogFieldTracking();
 
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
         auditTriggerHandler.lstNewRecordsMap= (Map<Id, Account_Profile__c>)(Trigger.newMap);
         auditTriggerHandler.triggerEvent = 'Create';
         auditTriggerHandler.sObjectType = 'Account_Profile__c';
         auditTriggerHandler.processRecords(Trigger.new);   
        }
        if(Trigger.isUpdate)
        {
         auditTriggerHandler.lstNewRecordsMap= (Map<Id, Account_Profile__c>)(Trigger.newMap);
         auditTriggerHandler.lstOldRecordsMap= (Map<Id, Account_Profile__c>)(Trigger.oldMap);
         auditTriggerHandler.triggerEvent = 'Update';
         auditTriggerHandler.sObjectType = 'Account_Profile__c';
         auditTriggerHandler.processRecords(Trigger.new);  
        }
    }
    
}