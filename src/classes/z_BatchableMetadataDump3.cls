global with sharing class z_BatchableMetadataDump3 implements Database.Batchable<SObject>, Database.Stateful {
    /**
    * Batch job that relates SObjectDescription and ChildRelation by updating
    * z_ChildSObjectDescription__c lookup on z_ChildRelationship__c.
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select z_ChildSObjectDescription__c, childobjectname__c From z_ChildRelationship__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, z_ChildRelationship__c[] scope){

        Set<String> setSObjectName = new Set<String>();
        for (z_ChildRelationship__c child : scope) {
            setSObjectName.add(child.childobjectname__c);
        }

        Map<String, Id> mapSObject = new Map<String, Id>();
        for(z_SObjectDescription__c sObjDesc : [select Id, name From z_SObjectDescription__c Where name in :setSObjectName]) {
            mapSObject.put(sObjDesc.name, sObjDesc.Id);
        }

        List<z_ChildRelationship__c> lUpdateChilds = new List<z_ChildRelationship__c>();
        for (z_ChildRelationship__c oChild : scope) {
            if (mapSObject.containsKey(oChild.childobjectname__c)) {
                oChild.z_ChildSObjectDescription__c = mapSObject.get(oChild.childobjectname__c);
                lUpdateChilds.add(oChild);
            }
        }

        if (lUpdateChilds.size() > 0) {
            Database.update(lUpdateChilds, false);
        }

    }

    global void finish(Database.BatchableContext BC){
    }

}