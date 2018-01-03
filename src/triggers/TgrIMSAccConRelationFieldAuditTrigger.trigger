trigger TgrIMSAccConRelationFieldAuditTrigger on AccountContactRelation (before insert,after insert, before update, after update, before delete)
{
//Arpit 10/21/2016
//Description - Trigger to handle records for IMS Audit    
    //Class handles all the logic required for IMS Audit process
    ClsIMSFieldAuditTriggerHandler accCntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();
    
    ClsAccountContactRelationTriggerHandler accConRelTriggerHandler = new ClsAccountContactRelationTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        accCntTriggerHandler.lstNewRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.newMap);
        accCntTriggerHandler.triggerEvent = 'Create';
        accCntTriggerHandler.sObjectType = 'AccountContactRelation';
        accCntTriggerHandler.processRecords(Trigger.new);
    }
    
      if(Trigger.isInsert && Trigger.isBefore)
    {
            accCntTriggerHandler.sObjectType = 'AccountContactRelation';
            accCntTriggerHandler.populateAccountContactRelationCountry(trigger.new);
    }
 
 
    if(Trigger.isBefore && Trigger.isUpdate)
    {   
        accCntTriggerHandler.sObjectType = 'AccountContactRelation';
        accCntTriggerHandler.processInvalidRecords(Trigger.new);
    } 
    if(Trigger.isAfter && Trigger.isUpdate)
    { 
        accCntTriggerHandler.lstNewRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.newMap);
        accCntTriggerHandler.lstOldRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.oldMap);
        accCntTriggerHandler.triggerEvent = 'Update';
        accCntTriggerHandler.sObjectType = 'AccountContactRelation';
        accCntTriggerHandler.processRecords(Trigger.new);
    }
    
    //Nuno Fonseca 01/04/2016
    if(Trigger.isDelete)
    {
        accConRelTriggerHandler.preventAcountContactRelationDeletion(Trigger.old);
    }
}