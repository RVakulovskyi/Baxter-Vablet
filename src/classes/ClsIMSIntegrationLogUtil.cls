public class ClsIMSIntegrationLogUtil
{
//Jagan 10/14/2016
//Description - This class will hold methods used for IMS Integration process. Serves as a utility class.
//Change Log - 08/16/2017 - ARPIT for JIRA 599
//BOOS-1032 -- code updated to include new text area fields in metadata query and concatenate. This will overcome the 101 soql error on metadata query    
    //Method gets all the IMS Audit fields from custom metadatatype for a given Country and SFDCObject
    public static Set<String> getIMSAuditFields (String country, String sObjectName)
    {
        system.debug('country value is '+country);
        system.debug('sObjectName value is '+sObjectName);
        //Get custom metadata type for a given Country and SObject
        List<IMS_Audit_Fields__mdt> imsAuditFieldsList = [SELECT Country__c, Object_Name__c,Audit_Fields__c,Audit_Fields_2__c,Audit_Fields_3__c FROM IMS_Audit_Fields__mdt WHERE Country__c = :country AND Object_Name__c = :sObjectName];
        Set<String> imsAuditFieldsSet = new Set<String>();
        for(IMS_Audit_Fields__mdt auditField : imsAuditFieldsList)
        {
            string auditFieldsNew = auditField.Audit_Fields__c;//concatenate all audit field values
            if(!string.isblank(auditField.Audit_Fields_2__c))auditFieldsNew = auditFieldsNew+auditField.Audit_Fields_2__c;
            if(!string.isblank(auditField.Audit_Fields_3__c))auditFieldsNew = auditFieldsNew+auditField.Audit_Fields_3__c;
            
            //if(auditField.Audit_Fields_New__c != null && auditField.Audit_Fields_New__c.split(';').size() > 1)
            if(!string.isblank(auditFieldsNew) && auditFieldsNew.split(';').size() > 0)//update condition to use concatenated value
            {
                //for(String field : auditField.Audit_Fields_New__c.split(';'))
                for(string field : auditFieldsNew.split(';'))//updated for loop to use concatenated value
                {
                    if(field != '' )
                        imsAuditFieldsSet.add(field);
                }
            }
        }
        system.debug('size of imsAuditFieldsSet is ' + imsAuditFieldsSet.size());
        return imsAuditFieldsSet;
    }
    //Method gets all the Admin Profile Names from custom metadatatype for a given Country
    public static Set<String> getAdminProfiles (String country)
    {
        //Get admin profiles responsible for a given country
        List<IMS_Audit_Fields__mdt> imsAuditFieldsList = [SELECT Admin_Profile_Name__c FROM IMS_Audit_Fields__mdt WHERE Country__c = :country AND Admin_Profile_Name__c != null];
        Set<String> countryAdminProfileSet = new Set<String>();
        for(IMS_Audit_Fields__mdt auditField : imsAuditFieldsList)
        {
            if(auditField.Admin_Profile_Name__c != null && auditField.Admin_Profile_Name__c.split(';').size() > 1)
            {
                for(String profile : auditField.Admin_Profile_Name__c.split(';'))
                {
                    if(profile != '' )
                        countryAdminProfileSet.add(profile);
                }
            }
        }
        return countryAdminProfileSet;
    }
    //Method gets all the Admin Role Names from custom metadatatype for a given Country
    public static Set<String> getAdminRoles (String country)
    {
        //Get admin profiles responsible for a given country
        List<IMS_Audit_Fields__mdt> imsAuditFieldsList = [SELECT Admin_Role_Name__c FROM IMS_Audit_Fields__mdt WHERE Country__c = :country AND Admin_Role_Name__c != null];
        Set<String> countryAdminRoleSet = new Set<String>();
        for(IMS_Audit_Fields__mdt auditField : imsAuditFieldsList)
        {
            if(auditField.Admin_Role_Name__c != null && auditField.Admin_Role_Name__c.split(';').size() > 1)
            {
                for(String role : auditField.Admin_Role_Name__c.split(';'))
                {
                    if(role != '' )
                        countryAdminRoleSet.add(role);
                }
            }
        }
        return countryAdminRoleSet;
    }
    //Method retrieves all active Integration Log records
    public static Map<Id, INTEGRATION_LOG__c> getSObjectsWithActiveIntegrationLogs ()
    {
        Map<Id, INTEGRATION_LOG__c> activeIntLogMap = new Map<Id, INTEGRATION_LOG__c>();
        string rejectedLabel = '%'+system.label.BST_Rejected+'%';
        List<INTEGRATION_LOG__c> activeIntLogList = [SELECT Id, BST_ACCOUNT_ID__c, BST_CONTACT_ID__c, BST_RELATED_ACCOUNT_ID__c,BST_ACCOUNT_CONTACT_RELATION_ID__c ,BST_STATUS__c  
        FROM INTEGRATION_LOG__c WHERE BST_STATUS__c !=:system.label.BST_IMS_Accepted AND BST_STATUS__c != null AND (BST_STATUS__c LIKE:rejectedLabel ) AND (BST_ACCOUNT_ID__c != null OR BST_CONTACT_ID__c != null OR BST_RELATED_ACCOUNT_ID__c != null OR BST_ACCOUNT_CONTACT_RELATION_ID__c != null)];
        system.debug('@@@@@@@@@activeIntLogList@@'+activeIntLogList);
        for(INTEGRATION_LOG__c intLog : activeIntLogList)
        {
                system.debug('@@@@@@@@@intLog.id @@'+intLog.id);

            String sObjId;
            //Get Account/Contact/Related Contact/Related Account Id
            sObjId = (intLog.BST_ACCOUNT_ID__c != null ? intLog.BST_ACCOUNT_ID__c : (intLog.BST_CONTACT_ID__c != null ? intLog.BST_CONTACT_ID__c : (intLog.BST_RELATED_ACCOUNT_ID__c != null ? intLog.BST_RELATED_ACCOUNT_ID__c : (intLog.BST_ACCOUNT_CONTACT_RELATION_ID__c != null ? intLog.BST_ACCOUNT_CONTACT_RELATION_ID__c : null))));
            if(intLog.BST_ACCOUNT_ID__c != null)
            {
                sObjId = intLog.BST_ACCOUNT_ID__c;
                activeIntLogMap.put(intLog.Id, intLog);
            }
            else if(intLog.BST_CONTACT_ID__c != null) //Changes by Arpit Start
            {
                sObjId = intLog.BST_CONTACT_ID__c;
                activeIntLogMap.put(intLog.Id, intLog);
            }
            else if(intLog.BST_RELATED_ACCOUNT_ID__c != null) 
            {
                sObjId = intLog.BST_RELATED_ACCOUNT_ID__c;
                activeIntLogMap.put(intLog.Id, intLog);
            } 
            else if(intLog.BST_ACCOUNT_CONTACT_RELATION_ID__c != null) 
            {
                sObjId = intLog.BST_ACCOUNT_CONTACT_RELATION_ID__c;
                activeIntLogMap.put(intLog.Id, intLog);
            } 
                                                   //Changes by Arpit Stop
            activeIntLogMap.put(sObjId, intLog);
        }
        return activeIntLogMap;
    }
    //Method used to evaluate new and old values of sObject record and return the changed values a a Map, which include field api > field label, field new val and field old val
    public static Map<String, List<String>> getChangedFieldDetails (Id sObjectId, String sObjectType, String triggerEvent, SObject newRecord, SObject oldRecord)
    {
        
        Map<String, List<String>> imsFieldValuesMap = new Map<String, List<String>>();//Holds the ims updated fields and their values. Key in map will be Field API and the list will have 3 items, first item is field label, second item is field new value and third item is field old value (only for Update operation)
        
        Set<String> imsAuditFields = getIMSAuditFields((String)newRecord.get('BST_COUNTRY__c'), sObjectType);//get all IMS Audit fields
        Map<String, Schema.SObjectField> fieldSetMap = ClsApexUtil.getFieldsSetMap(sObjectType);//get all field map from Schema for the given sObject, we want this to get the field label name

        Map<String, Object> fieldsToValueMap = newRecord.getPopulatedFieldsAsMap(); //get all populated fields in an SObject
        system.debug('fieldsToValueMap size is '+fieldsToValueMap.size());    
        for(String fieldName : imsAuditFields)
        {
            system.debug('Field name in audit set is '+ fieldName);
            system.debug('FieldSetMap is ' + fieldsToValueMap.keySet().contains(fieldName));
            if(
                (triggerEvent == 'Create' && (fieldsToValueMap.keySet().contains(fieldName))) ||
                (triggerEvent == 'Update' && (String.valueof(newRecord.get(fieldName)) != String.valueof(oldRecord.get(fieldName))))
            )
            {
                List<String> fieldValLst = new List<String>();//List stores values for Field label, Field new value, Field old value (only for Update operation)
                fieldValLst.add(fieldSetMap.get(fieldName).getDescribe().getLabel());//First item in List = Field Label
                if(triggerEvent == 'Create')
                    fieldValLst.add(String.valueof(fieldsToValueMap.get(fieldName)));//Second item in List = Field New Value
                else
                if(triggerEvent == 'Update')
                {       
                    fieldValLst.add(String.valueof(newRecord.get(fieldName)));//Second item in List = Field New Value
                    fieldValLst.add(String.valueof(oldRecord.get(fieldName)));//Second item in List = Field Old Value
                }
                imsFieldValuesMap.put(fieldName, fieldValLst);//map to be returned
            }
        }
            
        return imsFieldValuesMap;
    }

    //Method used to create an IMS Integration Log record   
    public static String createIMSIntegrationLog (String sObjectId, Id parentObjId, String relName, String sObjectType, String country, String triggerEvent, Map<String, List<String>>imsFieldValuesMap, Boolean baxterOnlyCheck, String adminUserId)
    {

        INTEGRATION_LOG__c newIntegrationLog = new INTEGRATION_LOG__c();
        String commentsValue = 'IMS Audit field values are' + '\r\n';
        
        //Populate field values for the Integration Log record
        newIntegrationLog.BST_ACCOUNT_ID__c = (sObjectType == System.Label.BST_Account ? sObjectId : null);
        newIntegrationLog.BST_CONTACT_ID__c = (sObjectType == System.Label.BST_Contact ? sObjectId : null); //Added by Arpit
        newIntegrationLog.BST_RELATED_ACCOUNT_ID__c = (sObjectType == System.Label.BST_RelatedAccount ? sObjectId : null);  //Added by Arpit
        newIntegrationLog.BST_ACCOUNT_CONTACT_RELATION_ID__c = (sObjectType == System.Label.BST_AccountContactRelation ? sObjectId : null);
        
        //JIRA-599 START
        if(sObjectType == System.Label.BST_AccountContactRelation){
        Set<String> fieldNames = imsFieldValuesMap.keySet();
        List<String> conFieldValLst = new List<String>();
            if(fieldNames.contains('ContactId')){           
                conFieldValLst.addAll(imsFieldValuesMap.get('ContactId'));
                List<INTEGRATION_LOG__c> activeConId = [Select Id from INTEGRATION_LOG__c where BST_CONTACT_ID__c in: conFieldValLst 
                                                        and BST_TYPE__c= 'AccountContactRelation Create'];
                if(triggerEvent == 'Create' && activeConId.isEmpty()){
                    newIntegrationLog.BST_CONTACT_ID__c =  conFieldValLst[1] ;
                }   
 
            }
        
        }
        //JIRA-599 END
        
        newIntegrationLog.BST_COUNTRY__c = country;
        newIntegrationLog.BST_RELATION_NAME__c = ((sObjectType == System.Label.BST_AccountContactRelation || sObjectType == System.Label.BST_RelatedAccount) ? relName : null);
        newIntegrationLog.BST_STATUS__c = System.Label.InitialIMSStatus;
        if(baxterOnlyCheck){
            newIntegrationLog.BST_HAS_BAXTER_ONLY_RECORD__c = true;
        }
        if(sObjectType == System.Label.BST_RelatedAccount)
        {
          newIntegrationLog.BST_TYPE__c = 'AccountAccountRelation' + ' ' + triggerEvent;
        }
        else
        {
          newIntegrationLog.BST_TYPE__c = sObjectType + ' ' + triggerEvent;
        }
        system.debug('*****The values are : ' +newIntegrationLog);
        for(String fieldName : imsFieldValuesMap.keySet())
        {
            List<String> fieldValLst = new List<String>();//List stores values for Field label, Field new value, Field old value (only for Update operation)
            fieldValLst.addAll(imsFieldValuesMap.get(fieldName));
            if(triggerEvent == 'Create')
                commentsValue = commentsValue + fieldValLst[0] + ' : ' + fieldValLst[1] + '\r\n';
            else if(triggerEvent == 'Update')
            {
                commentsValue = fieldValLst[2] == null ? commentsValue + fieldValLst[0] + ' : ' + 'Value changed to \'' + fieldValLst[1] + '\'\r\n' : commentsValue + fieldValLst[0] + ' : ' + 'Value changed from \'' + fieldValLst[2] + '\' to \'' + fieldValLst[1] + '\'\r\n';
            }   
        }   
        newIntegrationLog.BST_COMMENTS__c = commentsValue;
        try
        {
            insert newIntegrationLog;
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        //Call Method to populate IMSIntegrationLogAudit records
        createIMSIntegrationLogAudit(newIntegrationLog.Id, triggerEvent, imsFieldValuesMap);//Call method to record field details on a record by record basis, so it can be used for reporting purpose
        
        //Call method to post to chatter based on the sObject type
        Id chatterObjId = (sObjectType == System.Label.BST_AccountContactRelation ? parentObjId : sObjectId); //Only for AccountContactRelation we should get the Parent Account Id to post the feed, this is because of the product limitation
       if(baxterOnlyCheck){ 
        ClsApexUtil.addFeedItemToRecord(chatterObjId, commentsValue, adminUserId);//Post to chatter with the comments values
       }
       else{ 
        ClsApexUtil.addFeedItemToRecord(chatterObjId, commentsValue);//Post to chatter with the comments values
       } 
        //ClsApexUtil.addFeedItemToRecord(chatterObjId, System.Label.StatusOfChatter + ' \'Baxter Pending Review\' ' + System.Label.Topic);//Post to chatter with the comments values
        
        //Changes to add Recent Integration Log as Hyperlink Start

        if(sObjectType == System.Label.BST_AccountContactRelation)
        {
            List<AccountContactRelation> AccConRel = [select Id, BST_RELATED_INTEGRATION_LOG_ID__c, Account.Name, Contact.Name from AccountContactRelation where Id = : sObjectId];
            String Comments;
            for(AccountContactRelation ACRel : AccConRel)
            {
                ACRel.BST_RELATED_INTEGRATION_LOG_ID__c = newIntegrationLog.Id;
                //ACRel.BST_RELATED_INTEGRATION_LOG_NAME__c = newIntegrationLog.Name;
                Comments = ACRel.Contact.Name + ' is associated with ' + ACRel.Account.Name + ' ' +System.Label.Topic;
            }
            if(!AccConRel.isEmpty())
            {
                update AccConRel;
            } 
             ClsApexUtil.addFeedItemToRecord(chatterObjId, Comments);
        }
        //Changes to add Recent Integration Log as Hyperlink Stop
        
        return newIntegrationLog.Id;
    }
    
    //Method used to create an IMS Integration Log Audit records
    private static void createIMSIntegrationLogAudit (Id integrationLogId, String triggerEvent, Map<String, List<String>>imsFieldValuesMap)
    {
        List<INTEGRATION_LOG_AUDIT__c> newIntegrationLogAuditLst = new List<INTEGRATION_LOG_AUDIT__c>();
            
        //Go through the imsFieldValuesMap and create the audit records, which will be used for update operation later
        for(String fieldName : imsFieldValuesMap.keySet())
        {
            List<String> fieldValLst = new List<String>();
            fieldValLst.addAll(imsFieldValuesMap.get(fieldName));
            INTEGRATION_LOG_AUDIT__c newIntegrationLogAudit = new INTEGRATION_LOG_AUDIT__c();
            newIntegrationLogAudit.BST_IMS_INTEGRATION_LOG__c = integrationLogId;
            newIntegrationLogAudit.BST_FIELD_API_NAME__c = fieldName;
            newIntegrationLogAudit.BST_FIELD_LABEL__c = fieldValLst[0];
            newIntegrationLogAudit.BST_FIELD_NEW_VALUE__c = fieldValLst[1];
            if(triggerEvent == 'Update')
                newIntegrationLogAudit.BST_FIELD_OLD_VALUE__c = fieldValLst[2];
            newIntegrationLogAuditLst.add(newIntegrationLogAudit);
        }
        
        if(!newIntegrationLogAuditLst.isEmpty())
        {
            try
            {
                insert newIntegrationLogAuditLst;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }
}