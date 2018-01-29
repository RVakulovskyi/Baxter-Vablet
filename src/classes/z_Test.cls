@isTest
private class z_Test {
    /**
    * @NOTE: old test, need to re-evaluate its use/value
    */
    static testMethod void testDumpFrontPageCont() {
        // Create test data.
        z_MetaDumpSetting__c setting = new z_MetaDumpSetting__c(name__c = 'Account');
        insert setting;

        z_DumpFrontPageCont cont = new z_DumpFrontPageCont();

        Test.StartTest();
            cont.executeDump();
            cont.getJobs();
            cont.updateProgress();

            cont.batch1Status = cont.PROCESSING;
            cont.batch2Status = cont.PROCESSING;
            cont.batch3Status = cont.PROCESSING;

            System.assert(cont.getDisableDumpBtn());
            System.assert(cont.getShowProgressBar());
            System.assert(cont.getShowStatusBlock());

            cont.batch1Status = cont.NOT_START;
            cont.batch2Status = cont.NOT_START;
            cont.batch3Status = cont.NOT_START;

            System.assert(!cont.getDisableDumpBtn());
            System.assert(!cont.getShowProgressBar());
            System.assert(!cont.getShowStatusBlock());
        Test.StopTest();
    }

    /**
    * @NOTE: old test, need to re-evaluate its use/value
    */
    static testMethod void testMetadataSettingCont() {
        z_MetaDumpSetting__c record = new z_MetaDumpSetting__c(name__c='test');
        insert record;

        List<z_MetaDumpSetting__c> records = [SELECT name FROM z_MetaDumpSetting__c LIMIT 20];
        System.assert(records.size()!=0);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(records);

        z_MetadataSettingCont cont = new z_MetadataSettingCont(ssc);
        Test.StartTest();
            //cont.loadMetadata();
            //cont.deleteSelected();
            cont.deleteAll();
        Test.stopTest();
    }

    /**
    * Tests running batch z_BatchableMetadataDump1
    */
    static testMethod void testBatchMetadataDump1() {
        // Create test data.
        List<z_SObjectDescription__c> lSObjDesc = z_TestDataUtil.createSObjectDescription(100);

        Test.StartTest();
            Id id = Database.executeBatch(new z_BatchableMetadataDump1(), 2000);
            System.assert(id != null);
        Test.StopTest();

        List<z_SObjectDescription__c> lSObjDescResult = [select Id from z_SObjectDescription__c];

        System.assert(lSObjDescResult.size() == 0, 'Number of z_SObjectDescription__c records should be 0.');
    }

    /*static testMethod void testScheduledBatchMetadataDump1() {
        // Create test data.
        List<z_SObjectDescription__c> lSObjDesc = z_TestDataUtil.createSObjectDescription(100);

        Test.StartTest();
            System.schedule('Test BatchableMetadataDump1', '0 0 23 * * ?', new z_SchedulableBatchableMetadataDump1());
        Test.StopTest();

        List<z_SObjectDescription__c> lSObjDescResult = [select Id from z_SObjectDescription__c];

        System.assert(lSObjDescResult.size() == 0, 'Number of z_SObjectDescription__c records should be 0.');
    }*/

    static testMethod void testBatchMetadataDump2() {
        // Create Setting data.
        z_MetaDumpSetting__c setting = new z_MetaDumpSetting__c(name__c = 'Account');
        insert setting;

        Test.StartTest();
            Id id = Database.executeBatch(new z_BatchableMetadataDump2(), 200);
            System.assert(id != null);
        Test.StopTest();

        List<z_SObjectDescription__c> lSObjDesc = [select Id,
                                                        keyPrefix__c,
                                                        label__c,
                                                        labelPlural__c,
                                                        localName__c,
                                                        name,
                                                        isAccessible__c,
                                                        isCreateable__c,
                                                        isCustom__c,
                                                        isCustomSetting__c,
                                                        isDeltable__c,
                                                        isDeprecatedAndHidden__c,
                                                        isFeedEnabled__c,
                                                        isMergeable__c,
                                                        isQueryable__c,
                                                        isSearchable__c,
                                                        isUndeletable__c,
                                                        isUpdateable__c
                                                        from z_SObjectDescription__c];

        System.assert(lSObjDesc.size() == 1, 'Number of z_SObjectDescription__c records should be 1.');
        System.assert(lSObjDesc.get(0).keyPrefix__c == '001', 'Account keyprefix is not 001.');
        System.assert(lSObjDesc.get(0).isCustom__c == false, 'Account was describe as custom object.');
        System.assert(lSObjDesc.get(0).isCustomSetting__c == false, 'Account was described as custom setting.');

        List<z_ChildRelationship__c> lChildRel = [select Id,
                                                        z_ParentSObjectDescription__c
                                                        from z_ChildRelationship__c
                                                        where z_ParentSObjectDescription__c =: lSObjDesc.get(0).Id];

        System.assert(lChildRel.size() > 0, 'No z_ChildRelationship__c records were created for z_SObjectDescription__c');

        List<z_FieldDescription__c> lFieldDescriptions = [select Id,
                                                z_SObjectDescription__c
                                                from z_FieldDescription__c
                                                where z_SObjectDescription__c =: lSObjDesc.get(0).Id];

        System.assert(lFieldDescriptions.size() > 0, 'No z_FieldDescription__c records were created for z_SObjectDescription__c.');
    }

    static testMethod void testBatchMetadataDump2_withoutSettings() {
        // Run batch job without setting records.
        Test.StartTest();
            Id id = Database.executeBatch(new z_BatchableMetadataDump2(), 200);
            System.assert(id != null);
        Test.StopTest();

        List<z_SObjectDescription__c> lSObjDesc = [select Id from z_SObjectDescription__c];
        System.assert(lSObjDesc.size() == 0, 'Number of z_SObjectDescription__c records should be 0.');

        List<z_ChildRelationship__c> lChildRel = [select Id from z_ChildRelationship__c];
        System.assert(lChildRel.size() == 0, 'z_ChildRelationship__c records should be 0.');

        List<z_FieldDescription__c> lFieldDescriptions = [select Id from z_FieldDescription__c];
        System.assert(lFieldDescriptions.size() == 0, 'z_FieldDescription__c records should be 0.');
    }

    static testMethod void testBatchMetadataDump3() {
        //Create dummy test data.
        List<z_SObjectDescription__c> lSObjDesc = z_TestDataUtil.createSObjectDescription(100);
        List<z_ChildRelationship__c> lChildRelationships = z_TestDataUtil.createChildRelationship(lSObjDesc, 10);

        //Create test data that will have to be linked by the end of the batch execution.
        z_SObjectDescription__c oSObjectDescription = new z_SObjectDescription__c();
        oSObjectDescription.keyPrefix__c = '001';
        oSObjectDescription.Name = 'Account';
        oSObjectDescription.label__c = 'Account';
        oSObjectDescription.labelPlural__c = 'Accounts';
        oSObjectDescription.localName__c = 'Accounts';
        oSObjectDescription.isCustom__c = false;
        insert oSObjectDescription;

        z_ChildRelationship__c oChildRelationship = new z_ChildRelationship__c();
        oChildRelationship.fieldname__c = 'ParentId';
        oChildRelationship.childobjectname__c = 'Account';
        oChildRelationship.z_ParentSObjectDescription__c = oSObjectDescription.Id;
        insert oChildRelationship;

        // Run batch job.
        Test.StartTest();
            Id id = Database.executeBatch(new z_BatchableMetadataDump3(), 2000);
            System.assert(id != null);
        Test.StopTest();

        List<z_ChildRelationship__c> lChildRel = [select Id,
                                                        z_ParentSObjectDescription__c,
                                                        z_ChildSObjectDescription__c
                                                        from z_ChildRelationship__c
                                                        where z_ParentSObjectDescription__c =: oSObjectDescription.Id];
        System.assert(lChildRel.size() == 1, 'z_ChildRelationship__c records should be 1.');
        System.assert(lChildRel.get(0).z_ChildSObjectDescription__c == oSObjectDescription.Id, 'z_ChildRelationship__c record was not properly related to SObjectDescription');
    }

    static testMethod void testGenerateMDSettingsViaVFPage() {
        // Go to z_DumpFrontPage page
        PageReference pageRef = Page.z_DumpFrontPage;
        Test.setCurrentPage(pageRef);
        // controller
        z_DumpFrontPageCont controller = new z_DumpFrontPageCont();
        controller.generateMDSettings();

        List<z_MetaDumpSetting__c> records = [SELECT name FROM z_MetaDumpSetting__c LIMIT 20];
        System.assert(records.size() != 0);

    }

}