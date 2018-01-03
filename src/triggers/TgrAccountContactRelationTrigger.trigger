/*************************************************************************************************
Apex Trigger Name : TgrAccountContactRelationTrigger                                             *
Version : 1.0                                                                                    *
Created Date : 18/04/2017                                                                        *  
Function :  Trigger created to manage all actions for AccountContactRelation object              *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Nuno Fonseca              18/04/2017          New trigger framework to follow best practices   *    
* Arpit Agarwal             26/04/2017          Trigger Logic to handle records for IMS Audit    *
                                                Process                                          * 
*************************************************************************************************/
trigger TgrAccountContactRelationTrigger on AccountContactRelation (before insert, before update, before delete, after insert, after update, after delete) 
{
    //Class handles all the logic required for IMS Audit process
    ClsIMSFieldAuditTriggerHandler accCntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();
    ClsAccountContactRelationTriggerHandler accConRelTriggerHandler = new ClsAccountContactRelationTriggerHandler();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            accCntTriggerHandler.sObjectType = 'AccountContactRelation';
            accCntTriggerHandler.populateAccountContactRelationCountry(trigger.new);
            accCntTriggerHandler.processStatusUpdate(trigger.new);
        }
        if(Trigger.isUpdate)
        {
            accCntTriggerHandler.sObjectType = 'AccountContactRelation';
            accCntTriggerHandler.processInvalidRecords(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            accConRelTriggerHandler.preventAcountContactRelationDeletion(Trigger.old);
        }
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            accCntTriggerHandler.lstNewRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.newMap);
            accCntTriggerHandler.triggerEvent = 'Create';
            accCntTriggerHandler.sObjectType = 'AccountContactRelation';
            accCntTriggerHandler.processRecords(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            accCntTriggerHandler.lstNewRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.newMap);
            accCntTriggerHandler.lstOldRecordsMap= (Map<Id, AccountContactRelation>)(Trigger.oldMap);
            accCntTriggerHandler.triggerEvent = 'Update';
            accCntTriggerHandler.sObjectType = 'AccountContactRelation';
            accCntTriggerHandler.processRecords(Trigger.new);
        }
    }
    
}