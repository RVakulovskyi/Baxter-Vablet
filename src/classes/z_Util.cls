public with sharing class z_Util {

    public static void log(String str) {
        System.debug(logginglevel.INFO, str);
    }

    public static void addSuccessMessage(String message){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
    }

    public static void addErrorMessage(String message){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }

    public static void logException(Exception e, String source){
        System.debug('--- Exception Source : ' + source);
        System.debug(logginglevel.INFO, '--- Message : ' + e.getMessage());
        System.debug(logginglevel.INFO, '--- Cause : ' + e.getCause());
        System.debug(logginglevel.INFO, '--- Type : ' + e.getTypeName());
        System.debug(logginglevel.INFO, '--- Line number : ' + e.getLineNumber());
        System.debug(logginglevel.INFO, '--- Stack trace : ' + e.getStackTraceString());
    }

    // Seconds  Minutes  Hours  Day_of_month  Month  Day_of_week  optional_year
    public static String convertToStringForScheduler(Datetime dt) {
        return dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ' + '?' + ' ' + dt.year();
    }

    /**
    * Calls z_BatchableMetadataDump1 batch job and gets the queue Id of the job to be able to monitor it.
    * @param executeDump2 - flag to enable/disable the chained execution of z_BatchableMetadataDump2 batch job.
    * @return id of the queued z_BatchableMetadataDump1 batch job run.
    */
    public static Id executeBatchableMetadataDump1(boolean executeDump2) {
        return Database.executeBatch(new z_BatchableMetadataDump1(executeDump2), 2000);
    }

    /**
    * Calls z_BatchableMetadataDump2 batch job and gets the queue Id of the job to be able to monitor it.
    * @param executeDump3 - flag to enable/disable the chained execution of z_BatchableMetadataDump3 batch job.
    * @return id of the queued z_BatchableMetadataDump2 batch job run.
    */
    public static Id executeBatchableMetadataDump2(boolean executeDump3) {
        return Database.executeBatch(new z_BatchableMetadataDump2(executeDump3), 200);
    }

    /**
    * Calls z_BatchableMetadataDump3 batch job and gets the queue Id of the job to be able to monitor it.
    * @return id of the queued z_BatchableMetadataDump3 batch job run.
    */
    public static Id executeBatchableMetadataDump3() {
        return Database.executeBatch(new z_BatchableMetadataDump3(), 2000);
    }

    /**
    * Method to clean up z_MetaDumpSetting__c records,
    * usually called before generating new z_MetaDumpSetting__c records.
    */
    public static void deleteAllSettings() {
        List<SObject> records = [Select id From z_MetaDumpSetting__c Limit 10000];

        if(records.size() > 0) {
            try {
                delete records;
            } catch (DmlException e) {
                logException(e, 'z_Util.deleteAllSettings');
            }
        }

    }

    /**
    * Does a global describe, removes unwanted system objects and inserts z_MetaDumpSetting__c
    * @return boolean
    */
    public static Boolean loadMetadataSettings() {
        Boolean bResult = false;
        // Clean existing Setting records.
        deleteAllSettings();

        List<z_MetaDumpSetting__c> mdSettings = new List<z_MetaDumpSetting__c>();

        // Do a global describe and insert only valid object names.
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(String objName : gd.keySet()) {
            Schema.DescribeSObjectResult obj = gd.get(objName).getDescribe();

            if ((!obj.isMruEnabled() && !obj.isCustom() && !obj.isCustomSetting() && !isWhitelistedObject(objName)) || isIgnoredObject(objName)) {
                continue;
            }

            mdSettings.add(new z_MetaDumpSetting__c(name__c = obj.getName()));
        }

        try {
            insert mdSettings;
            bResult = true;
        } catch (DmlException e) {
            logException(e, 'z_Util.loadMetadataSettings');
        }

        return bResult;
    }

    /**
    * Checks the object currently being processed against the list of objects that need to be ignored
    * @param objectName Name of the object that needs to be checked against the list of ignored objects
    * @return boolean
    */
    private static Boolean isIgnoredObject(String objectName) {
        Set<String> ignoredObj = new Set<String>();
        ignoredObj.add('ActionLinkGroupTemplate');
        ignoredObj.add('ApexClass');
        ignoredObj.add('ApexComponent');
        ignoredObj.add('ApexPage');
        ignoredObj.add('ApexTrigger');
        ignoredObj.add('CollaborationGroup');
        ignoredObj.add('ContentDocument');
        ignoredObj.add('Dashboard');
        ignoredObj.add('Document');
        ignoredObj.add('DuplicateRecordSet');
        ignoredObj.add('DuplicateRule');
        ignoredObj.add('EmailTemplate');
        ignoredObj.add('ExternalDataSource');
        ignoredObj.add('ListView');
        ignoredObj.add('Macro');
        ignoredObj.add('MatchingRule');
        ignoredObj.add('Metric');
        ignoredObj.add('NamedCredential');
        ignoredObj.add('PermissionSet');
        ignoredObj.add('ProcessDefinition');
        ignoredObj.add('Profile');
        ignoredObj.add('RecordType');
        ignoredObj.add('Report');
        ignoredObj.add('SecureAgent');
        ignoredObj.add('SecureAgentsCluster');
        ignoredObj.add('StaticResource');
        ignoredObj.add('StreamingChannel');
        ignoredObj.add('Topic');
        ignoredObj.add('UserAppMenuItem');
        ignoredObj.add('WorkCoaching');
        ignoredObj.add('WorkFeedbackRequest');
        ignoredObj.add('WorkFeedbackTemplate');
        ignoredObj.add('WorkPerformanceCycle');

        for (String iobj : ignoredObj) {
            if(objectName.equalsIgnoreCase(iobj)) {
                return true;
            }
        }

        return false;
    }

    /**
    * Checks the object currently being processed against the list of objects that are whitelisted
    * @param objectName Name of the object that needs to be checked against the list of whitelisted objects
    * @return boolean
    */
    private static Boolean isWhitelistedObject(String objectName) {
        Set<String> whitelistObjs = new Set<String>();
        whitelistObjs.add('AccountCleanInfo');
        whitelistObjs.add('AccountContactRole');
        whitelistObjs.add('ContactCleanInfo');
        whitelistObjs.add('BusinessHours');
        whitelistObjs.add('BusinessProcess');
        whitelistObjs.add('CallCenter');
        whitelistObjs.add('CampaignMember');
        whitelistObjs.add('CaseComment');
        whitelistObjs.add('CaseContactRole');
        whitelistObjs.add('CaseTeamMember');
        whitelistObjs.add('ContractContactRole');
        whitelistObjs.add('Event');
        whitelistObjs.add('IdeaComment');
        whitelistObjs.add('LeadCleanInfo');
        whitelistObjs.add('OpportunityCompetitor');
        whitelistObjs.add('OpportunityContactRole');
        whitelistObjs.add('OpportunityLineItem');
        whitelistObjs.add('OpportunityPartner');
        whitelistObjs.add('OpportunityStage');
        whitelistObjs.add('OrderItem');
        whitelistObjs.add('Solution');
        whitelistObjs.add('Task');

        for (String iobj : whitelistObjs) {
            if(objectName.equalsIgnoreCase(iobj)) {
                return true;
            }
        }

        return false;
    }

}