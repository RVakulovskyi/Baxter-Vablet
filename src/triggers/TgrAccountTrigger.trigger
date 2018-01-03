/*************************************************************************************************
Apex Trigger Name : TgrAccountTrigger                                                            *
Version : 1.0                                                                                    *
Created Date : 18/04/2017                                                                        *  
Function :  Trigger created to manage all actions for Account object                             *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Nuno Fonseca              18/04/2017          New trigger framework to follow best practices   *
* Rashmi Rani               20/04/2017          Trigger Logic to handle records for IMS Audit    *
*                                               process                                          *    
*************************************************************************************************/
trigger TgrAccountTrigger on Account (before insert, before update, after insert, after update) 
{
    
    ClsIMSFieldAuditTriggerHandler accntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
         accntTriggerHandler.sObjectType = 'Account';
         accntTriggerHandler.processInvalidRecords(Trigger.new);
        } 
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
         accntTriggerHandler.lstNewRecordsMap= (Map<Id, Account>)(Trigger.newMap);
         accntTriggerHandler.triggerEvent = 'Create';
         accntTriggerHandler.sObjectType = 'Account';
         accntTriggerHandler.processRecords(Trigger.new);   
        }
        if(Trigger.isUpdate)
        {
         accntTriggerHandler.lstNewRecordsMap= (Map<Id, Account>)(Trigger.newMap);
         accntTriggerHandler.lstOldRecordsMap= (Map<Id, Account>)(Trigger.oldMap);
         accntTriggerHandler.triggerEvent = 'Update';
         accntTriggerHandler.sObjectType = 'Account';
         accntTriggerHandler.processRecords(Trigger.new);  
        }
    }
    
}