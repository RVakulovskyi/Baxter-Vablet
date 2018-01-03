/*************************************************************************************************
Apex Trigger Name : TgrContactTrigger                                                            *
Version : 1.0                                                                                    *
Created Date : 18/04/2017                                                                        *  
Function :  Trigger created to manage all actions for Contact object                             *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Nuno Fonseca              18/04/2017          New trigger framework to follow best practices   * 
* Rashmi Rani               21/04/2017          Trigger Logic to handle records for IMS Audit    *
*                                               process                                          * 
*************************************************************************************************/
trigger TgrContactTrigger on Contact (before insert, before update, after insert, after update) 
{
    
    ClsIMSFieldAuditTriggerHandler cntctTriggerHandler = new ClsIMSFieldAuditTriggerHandler();
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
         cntctTriggerHandler.sObjectType = 'Contact';
         cntctTriggerHandler.processInvalidRecords(Trigger.new); 
        }  
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
         cntctTriggerHandler.lstNewRecordsMap= (Map<Id, Contact>)(Trigger.newMap);
         cntctTriggerHandler.triggerEvent = 'Create';
         cntctTriggerHandler.sObjectType = 'Contact';
         cntctTriggerHandler.processRecords(Trigger.new);  
        }
        if(Trigger.isUpdate)
        {
         cntctTriggerHandler.lstNewRecordsMap= (Map<Id, Contact>)(Trigger.newMap);
         cntctTriggerHandler.lstOldRecordsMap= (Map<Id, Contact>)(Trigger.oldMap);
         cntctTriggerHandler.triggerEvent = 'Update';
         cntctTriggerHandler.sObjectType = 'Contact';
         cntctTriggerHandler.processRecords(Trigger.new); 
        }
    }
    
}