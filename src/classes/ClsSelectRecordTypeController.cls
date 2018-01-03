/********************************************************************************
Apex Class Name - ClsSelectRecordTypeController
Version - 1.0
Created Date- 14-June-2017 by - Arpit
Function - This class will be used for fetching Record Type details 
available for user in context.
********************************************************************************/

public with sharing class ClsSelectRecordTypeController{

/**
    * Method Name: getQuestionRecordTypes
    * Description: Method to get Record types for Question Object
    * Parameter: None                             
    * Return Type: List of Wrapper type
    */
 
   @AuraEnabled
    public static List<RecordTypeWrapper> getQuestionRecordTypes(){
        List<RecordType> rt = [SELECT Id, Name, Description FROM RecordType WHERE SobjectType='Question__c'];
        List<Schema.RecordTypeInfo> recdTypeInfoList = Question__c.SObjectType.getDescribe().getRecordTypeInfos();
        //List<String> recDesc = new List<String>();
        List<RecordTypeWrapper> wrapperList=new List<RecordTypeWrapper>();
        for (RecordTypeInfo recdType : recdTypeInfoList){
            RecordTypeWrapper rw=new RecordTypeWrapper();

            for(RecordType recType : rt) {
    
                if (recdType.isAvailable() && !String.valueOf(recdType.getRecordTypeId()).endsWith('AAA') && recdType.getRecordTypeId() == recType.Id){         
                    
                    rw.recordTypeLabel=string.valueof(recType.get('Name'));
                    rw.recordTypeDesc=string.valueof(recType.get('Description'));
                    wrapperList.add(rw);

                }
            }
        }   
            system.debug('Value in the description list :' +wrapperList);
            return wrapperList;
    }
    
/**
    * Class : RecordTypeWrapper
    * Description: Wrapper Class for saving the name, description and Id of Record types
    * Parameter: None                             
    * Return Type: NA
    */    
    
    public class RecordTypeWrapper{
        @AuraEnabled
        public string recordTypeLabel{get;set;}
        @AuraEnabled
        public string recordTypeDesc{get;set;}
        @AuraEnabled
        public string recordTypeId{get;set;}
    }
 }