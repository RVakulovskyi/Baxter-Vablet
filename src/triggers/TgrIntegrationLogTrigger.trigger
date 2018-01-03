trigger TgrIntegrationLogTrigger on INTEGRATION_LOG__c (after insert, after update) {
    //Arpit 10/18/2016
    //Description - Trigger to revert the changes on Corresponding records
    //Class handles all the logic required for IMS Audit process
    ClsIMSRevertChangesTriggerHandler intLogTriggerHandler = new ClsIMSRevertChangesTriggerHandler();
    
    intLogTriggerHandler.lstOldRecordsMap= (Map<Id, INTEGRATION_LOG__c>)(Trigger.oldMap);
    intLogTriggerHandler.lstNewRecordsMap= (Map<Id, INTEGRATION_LOG__c>)(Trigger.newMap);
    intLogTriggerHandler.processRecords(trigger.new); 
            
 }