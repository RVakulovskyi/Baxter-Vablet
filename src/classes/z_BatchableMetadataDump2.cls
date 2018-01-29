global with sharing class z_BatchableMetadataDump2 implements Database.Batchable<SObject>, Database.Stateful {
    /**
    * Batch job that creates SObjectDescription, ChildRelation and FieldDescription records.
    */
    global Boolean executeBatch3;

    global z_BatchableMetadataDump2() {
        // flag if z_BatchableMetadataDump2 is executed after this class is completed.
        this(false);
    }

    global z_BatchableMetadataDump2(Boolean executeBatch3) {
        this.executeBatch3 = executeBatch3;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('select Id, name__c From z_MetaDumpSetting__c');
    }

    global void execute(Database.BatchableContext BC, z_MetaDumpSetting__c[] scope){
        // caching.
        Map<String, z_SObjectDescription__c> mapSObjectDesc = new Map<String, z_SObjectDescription__c>();
        Map<String, List<z_ChildRelationship__c>> mapSObjChildRelationship = new Map<String, List<z_ChildRelationship__c>>();

        // Get z_SObjectDescription__c & z_ChildRelationship__c records.
        for (z_MetaDumpSetting__c setting : scope) {
            Schema.DescribeSObjectResult objDescribe = z_DescribeHelper.getObjectDescribe(setting.name__c);

            // SObject description.
            z_SObjectDescription__c oSObjectDescription = z_DescribeHelper.createSObjectDescription(objDescribe);
            mapSObjectDesc.put(setting.name__c, oSObjectDescription);

            // Child Relationships.
            List<z_ChildRelationship__c> lChildRelations = z_DescribeHelper.createChildRelationship(objDescribe);

            if (lChildRelations.size() > 0) {
                mapSObjChildRelationship.put(setting.name__c, lChildRelations);
            }
        }

        // Create z_SObjectDescription__c records
        Database.insert(mapSObjectDesc.values(), false);

        // Iterate over child records and relate them to newly saved SObjectDescription
        List<z_ChildRelationship__c> lSObjectChilds = new List<z_ChildRelationship__c>();
        for (String objName : mapSObjectDesc.keySet()) {
            if (mapSObjChildRelationship.containsKey(objName)) {
                for (z_ChildRelationship__c childRel : mapSObjChildRelationship.get(objName)) {
                    childRel.z_ParentSObjectDescription__c = mapSObjectDesc.get(objName).Id;

                    lSObjectChilds.add(childRel);
                }
            }
        }

        Database.insert(lSObjectChilds, false);

        // create z_FieldDescription__c records for every object.
        List<z_FieldDescription__c> lFieldDescriptionPerSObject = new List<z_FieldDescription__c>();
        for (String objName : mapSObjectDesc.keySet()) {
            lFieldDescriptionPerSObject.addAll(z_DescribeHelper.createFieldDescriptionRecords(mapSObjectDesc.get(objName).Id, objName));
        }

        if (lFieldDescriptionPerSObject.size() > 0) {
            Database.insert(lFieldDescriptionPerSObject, false);
        }
    }

    global void finish(Database.BatchableContext BC){
        if(!executeBatch3)
            return;

        Datetime dt = System.now();
        String coreExpression = z_Util.convertToStringForScheduler(dt.addMinutes(2));
        System.schedule('z_BatchableMetadataDump3', coreExpression, new z_SchedulableBatchableMetadataDump3());
    }
}