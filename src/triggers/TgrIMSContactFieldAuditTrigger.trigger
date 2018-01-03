trigger TgrIMSContactFieldAuditTrigger on Contact (after insert, before update, after update)
{
//Arpit 10/19/2016
//Description - Trigger to handle records for IMS Audit    
    //Class handles all the logic required for IMS Audit process
    ClsIMSFieldAuditTriggerHandler cntctTriggerHandler = new ClsIMSFieldAuditTriggerHandler();

    if(Trigger.isInsert)
    {
        cntctTriggerHandler.lstNewRecordsMap= (Map<Id, Contact>)(Trigger.newMap);
        cntctTriggerHandler.triggerEvent = 'Create';
        cntctTriggerHandler.sObjectType = 'Contact';
        cntctTriggerHandler.processRecords(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate)
    {   
        cntctTriggerHandler.sObjectType = 'Contact';
        cntctTriggerHandler.processInvalidRecords(Trigger.new);
    } 
    if(Trigger.isAfter && Trigger.isUpdate)
    { 
        cntctTriggerHandler.lstNewRecordsMap= (Map<Id, Contact>)(Trigger.newMap);
        cntctTriggerHandler.lstOldRecordsMap= (Map<Id, Contact>)(Trigger.oldMap);
        cntctTriggerHandler.triggerEvent = 'Update';
        cntctTriggerHandler.sObjectType = 'Contact';
        cntctTriggerHandler.processRecords(Trigger.new);
    }       
}