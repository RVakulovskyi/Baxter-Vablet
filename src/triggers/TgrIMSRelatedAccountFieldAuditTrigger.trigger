trigger TgrIMSRelatedAccountFieldAuditTrigger on ACCOUNT_ACCOUNT_RELATION__c (before insert,after insert, before update, after update)
{
//Arpit 10/20/2016
//Description - Trigger to handle records for IMS Audit    
    //Class handles all the logic required for IMS Audit process
    ClsIMSFieldAuditTriggerHandler relAccntTriggerHandler = new ClsIMSFieldAuditTriggerHandler();

    if(Trigger.isInsert && trigger.isAfter)
    {
        relAccntTriggerHandler.lstNewRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.newMap);
        relAccntTriggerHandler.triggerEvent = 'Create';
        relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
        relAccntTriggerHandler.processRecords(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate)
    {   
        relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
        relAccntTriggerHandler.processInvalidRecords(Trigger.new);
    } 
    if(Trigger.isAfter && Trigger.isUpdate)
    { 
        relAccntTriggerHandler.lstNewRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.newMap);
        relAccntTriggerHandler.lstOldRecordsMap= (Map<Id, ACCOUNT_ACCOUNT_RELATION__c>)(Trigger.oldMap);
        relAccntTriggerHandler.triggerEvent = 'Update';
        relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
        relAccntTriggerHandler.processRecords(Trigger.new);
    } 
    
          if(Trigger.isInsert && Trigger.isBefore)
    {
            relAccntTriggerHandler.sObjectType = 'Account_Account_Relation__c';
            relAccntTriggerHandler.populateAccountAccountRelationCountry(trigger.new);
    }
 
      
}