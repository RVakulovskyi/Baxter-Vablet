global with sharing class z_BatchableMetadataDump1 implements Database.Batchable<SObject>, Database.Stateful {
    /**
    * Batch job that does some cleanup by deleting all previously created SObjectDescription,
    * ChildRelation & FieldDescription records.
    */
    global Boolean executeBatch2;

    global z_BatchableMetadataDump1() {
        // flag if z_BatchableMetadataDump2 is executed after this class is completed
        this(false);
    }

    global z_BatchableMetadataDump1(Boolean executeBatch2) {
        this.executeBatch2 = executeBatch2;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('select Id from z_SObjectDescription__c');
    }

    global void execute(Database.BatchableContext BC, z_SObjectDescription__c[] scope){
        if (scope.size() > 0) {
            Database.delete(scope, false);
        }
    }

    global void finish(Database.BatchableContext BC){
        if(!executeBatch2 || Test.isRunningTest()) {
            return;
        }

        // after 2mins, z_BatchableMetadataDump2 class will be executed
        Datetime dt = System.now();
        String coreExpression = z_Util.convertToStringForScheduler(dt.addMinutes(2));
        System.schedule('z_BatchableMetadataDump2', coreExpression, new z_SchedulableBatchableMetadataDump2());
    }
}