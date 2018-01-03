/*************************************************************************************************
Apex Class Name : ClsAuditLogUtil                                                                *
Version : 1.0                                                                                    *
Created Date : 21/06/2017                                                                        *  
Function :  Utility class for creating Audit records when a new Question/Answer is created       *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Arpit Agarwal            21/06/2017         Utility class for creating Audit records when a    *
*                                             new Question/Answer is created. Fetches data from  *
*                                             custom metadata type                               *
*                                                                                                *    
*************************************************************************************************/
public class ClsAuditLogUtil
{

/**
    * Method Name: getAuditFields
    * Description: Method to get fields to be tracked from custom metadata based on Sobject
    * Parameter: String                             
    * Return Type: Set
    */

    public static Set<String> getAuditFields (String sObjectName)
    {
        system.debug('sObjectName value is '+sObjectName);
        //Get custom metadata type for a given SObject
        List<BST_Audit_Log_Fields__mdt> auditFieldsList = [SELECT BST_Object_Name__c, BST_Audit_Fields__c FROM BST_Audit_Log_Fields__mdt WHERE BST_Object_Name__c = :sObjectName];
        Set<String> auditFieldsSet = new Set<String>();
        for(BST_Audit_Log_Fields__mdt auditField : auditFieldsList)
        {
            if(auditField.BST_Audit_Fields__c != null && auditField.BST_Audit_Fields__c.split(';').size() > 1)
            {
                for(String field : auditField.BST_Audit_Fields__c.split(';'))
                {
                    if(field != '')
                        auditFieldsSet.add(field);
                }
            }
        }
        system.debug('size of auditFieldsSet is ' + auditFieldsSet.size());
        return auditFieldsSet;
    }   

/**
    * Method Name: getChangedFieldDetails
    * Description: Method to get fields from the record that are tracked and has been changed
    * Parameter: Id, String, String, Sobject, Sobject                             
    * Return Type: Map
    */

    public static Map<String, List<String>> getChangedFieldDetails (Id sObjectId, String sObjectType, String triggerEvent, SObject newRecord, SObject oldRecord)
    {
        
        Map<String, List<String>> auditFieldValuesMap = new Map<String, List<String>>();//Holds the ims updated fields and their values. Key in map will be Field API and the list will have 3 items, first item is field label, second item is field new value and third item is field old value (only for Update operation)
        
        Set<String> imsAuditFields = getAuditFields(sObjectType);//get all IMS Audit fields
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
                auditFieldValuesMap.put(fieldName, fieldValLst);//map to be returned
            }
        }
            
        return auditFieldValuesMap;
    }
}