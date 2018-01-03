trigger TgrIMSAccountFieldAuditTrigger on Account (after insert, before update, after update)
{
//Jagan 10/15/2016
//Description - Trigger to handle records for IMS Audit    
    //Class handles all the logic required for IMS Audit process
    ClsIMSFieldAuditTriggerHandler accntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();

    if(Trigger.isInsert)
    {
        accntTriggerHandler.lstNewRecordsMap= (Map<Id, Account>)(Trigger.newMap);
        accntTriggerHandler.triggerEvent = 'Create';
        accntTriggerHandler.sObjectType = 'Account';
        accntTriggerHandler.processRecords(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {   
        accntTriggerHandler.sObjectType = 'Account';
        accntTriggerHandler.processInvalidRecords(Trigger.new);
    } 
    if(Trigger.isAfter && Trigger.isUpdate)
    {   
        accntTriggerHandler.lstNewRecordsMap= (Map<Id, Account>)(Trigger.newMap);
        accntTriggerHandler.lstOldRecordsMap= (Map<Id, Account>)(Trigger.oldMap);
        accntTriggerHandler.triggerEvent = 'Update';
        accntTriggerHandler.sObjectType = 'Account';
        accntTriggerHandler.processRecords(Trigger.new);
    }       
}