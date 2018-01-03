/********************************************************************************
Apex Class Name - ClsQuestionLightningController  
Version - 1.0
Created Date - Jun 2, 2017
Function - Apex Class for getting the picklist values 
           and handling Save records functionality 
           
           

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Arpit Agarwal           06/02/2017           Original Version
* Niharika Modi			  06/22/2017           BOOST/Sprint 2 / JIRA 127
********************************************************************************/
public with sharing class ClsQuestionLightningController {

  /**
    * Method Name: getRecordTypeId
    * Description: Method to get Record type Id from Utility class
    * Parameter: String, String
    * Return Type: ID
    */   
    
    @AuraEnabled
    public static Id getRecordTypeId(String objApiName, String recordTypeLabel)
    {
        return ClsApexUtil.getRecordTypeBySObject(objApiName).get(recordTypeLabel).getRecordTypeId();
    }
 /**
    * Method Name: getQuestionRecordTypes
    * Description: Method to get Record type available for user in context
    * Parameter: None
    * Return Type: List
    */   
       
    
    @AuraEnabled
    public static List<String> getQuestionRecordTypes(){
        List<String> retRecordTypeList = new List<String>();
        retRecordTypeList.add('');
        List<Schema.RecordTypeInfo> recdTypeInfoList = Question__c.SObjectType.getDescribe().getRecordTypeInfos();
        if (recdTypeInfoList.size() > 1)
        {
            for (RecordTypeInfo recdType : recdTypeInfoList) 
            {
                if (recdType.isAvailable() && !String.valueOf(recdType.getRecordTypeId()).endsWith('AAA'))
                   retRecordTypeList.add(recdType.getName());
            }        
        }
        return retRecordTypeList;
    }
    
 /**
    * Method Name: getUserInfo
    * Description: Method to check if the Secondary country for user is populated or not
    * Parameter: None
    * Return Type: Boolean
    */  
    
    @AuraEnabled
    public static Boolean getUserInfo()
    {
        Boolean isSecondaryEmpty = false;
        
        String Country = [Select Id, BST_COUNTRY__c, BST_SECONDARY_COUNTRY__c FROM User where Id = :UserInfo.getUserId()].BST_SECONDARY_COUNTRY__c;
        System.debug('###country: ' + country);
        if (Country == null)
            isSecondaryEmpty = true;
        
        return isSecondaryEmpty;
    }
 
 /**
    * Method Name: getCountryValues
    * Description: Method to populate country field on component from the user profile
    * Parameter: None
    * Return Type: List
    */
    
     @AuraEnabled
    public static List<String> getCountryValues(){
        List<String> options = new List<String>();
        List<User> usr = new List<User>();
        usr = [SELECT BST_COUNTRY__c,BST_SECONDARY_COUNTRY__c FROM User where Id = : UserInfo.getUserId()]; 
        for (User u: usr) {
            options.add(u.BST_COUNTRY__c);
             if(u.BST_SECONDARY_COUNTRY__c != null){
                options.addall(u.BST_SECONDARY_COUNTRY__c.split(';'));
            }
        }
        options.sort();
        return options;
    }
 
 /**
    * Method Name: getMajorCategory
    * Description: Method to get major category values based on Country
    * Parameter: String
    * Return Type: List
    */
    
    @AuraEnabled
    public static List<String> getMajorCategory(String country)
    {
       
        List<String> possibleMajorCategories = new List<String>();
        possibleMajorCategories.add('');
        PicklistFieldController controller = new PicklistFieldController();
        Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Question__c','BST_COUNTRY__c','BST_MAJOR_CATEGORY__c');
       system.debug('***###The country value is : ' +country);         
       if(country != null){     
        if(!valueMap.get(country).isEmpty())
        {
           for(String val : valueMap.get(country))
           {    
                possibleMajorCategories.add(val);  
           }   
        }
      }
        possibleMajorCategories.sort();    
        return possibleMajorCategories;
    }     
 
 /**
    * Method Name: getCategory
    * Description: Method to get secondary category values based on major category
    * Parameter: String
    * Return Type: List
    */
    
    @AuraEnabled
    public static List<String> getCategory(String majCategory)
    {
       
        List<String> possibleCategories = new List<String>();
        possibleCategories.add('');
        PicklistFieldController controller = new PicklistFieldController();
        Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Question__c','BST_MAJOR_CATEGORY__c','BST_CATEGORY__c');
       if(majCategory != null){    
        if(!valueMap.get(majCategory).isEmpty())
        {
            for(String val : valueMap.get(majCategory))
            {    
                possibleCategories.add(val);  
            }   
        }
       }  
        possibleCategories.sort();    
        return possibleCategories;
    }   

/**
    * Method Name: getQuestionType
    * Description: Method to get Question Type value for Global Question
    * Parameter: None
    * Return Type: List
    */
    
    @AuraEnabled
    public static List<String> getQuestionType()
    {
       
        List<String> possibleQuestionType = new List<String>();
        possibleQuestionType.add('');
        Schema.DescribeFieldResult fieldResult = Question__c.BST_QUESTION_TYPE__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry field : pickListVal)
            {    
                possibleQuestionType.add(field.getLabel());  
            }   
        
        possibleQuestionType.sort();    
        return possibleQuestionType;
    } 
        
/**
    * Method Name: getResponseType
    * Description: Method to get Response Type values
    * Parameter: None
    * Return Type: List
    */

    @AuraEnabled
    public static List<String> getResponseType()
    {
       
        List<String> responseType = new List<String>();
        responseType.add('');
        Schema.DescribeFieldResult fieldResult = Question__c.BST_RESPONSE_TYPE__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry field : pickListVal)
            {    
                responseType.add(field.getLabel());  
            }   
        
        responseType.sort();    
        return responseType;
    }   

/**
    * Method Name: getSalesforceGroup
    * Description: Method to get Baxter User Group values based on Country field
    * Parameter: String
    * Return Type: List
    */

    @AuraEnabled
    public static List<String> getSalesforceGroup(String country)
    {
       
        List<String> salesforceGroup = new List<String>();
        salesforceGroup.add('');
        PicklistFieldController controller = new PicklistFieldController();
        Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Question__c','BST_COUNTRY__c','BST_SALESFORCE_GROUP__c');
       if(country != null){    
        if(!valueMap.get(country).isEmpty())
        {
           for(String val : valueMap.get(country))
           {
                salesforceGroup.add(val);  
           }   
        } 
       } 
        salesforceGroup.sort();    
        return salesforceGroup;
    }

/**
    * Method Name: getSalesProcess
    * Description: Method to get Sales Process values
    * Parameter: None
    * Return Type: List
    */
    
    @AuraEnabled
    public static List<String> getSalesProcess()
    {
       
        List<String> salesProcess = new List<String>();
        salesProcess.add('');
        Schema.DescribeFieldResult fieldResult = Question__c.BST_SALES_PROCESS__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry field : pickListVal)
            {    
                salesProcess.add(field.getLabel());  
            }   
        
        salesProcess.sort();    
        return salesProcess;
    }   

/**
    * Method Name: getStatus
    * Description: Method to get Status values
    * Parameter: None
    * Return Type: List
    */

    @AuraEnabled
    public static List<String> getStatus()
    {
       
        List<String> status = new List<String>();
        status.add('');
        Schema.DescribeFieldResult fieldResult = Question__c.BST_STATUS__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry field : pickListVal)
            {    
                status.add(field.getLabel());  
            }   
        
        status.sort();    
        return status;
    }

/**
    * Method Name: getProfileType
    * Description: Method to get Profile Type values for Global Question
    * Parameter: None
    * Return Type: List
    */
    
    @AuraEnabled
    public static List<String> getProfileType()
    {
       
        List<String> profileType = new List<String>();
        profileType.add('');
        Schema.DescribeFieldResult fieldResult = Question__c.BST_PROFILE_TYPE__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry field : pickListVal)
            {    
                profileType.add(field.getLabel());  
            }   
        
        profileType.sort();    
        return profileType;
    }

/**
    * Method Name: saveQuestion
    * Description: Method invoked to Insert/Update Question
    * Parameter: Question__c
    * Return Type: Question__c
    */
    
    @AuraEnabled
    public static Question__c saveQuestion(Question__c que) {
        
        Question__c newQue = que;
        //Below lines of code will convert the translated value
        que.BST_CATEGORY__c = ClsApexUtil.picklistMap('BST_CATEGORY__c').get(que.BST_CATEGORY__c);
        que.BST_MAJOR_CATEGORY__c = ClsApexUtil.picklistMap('BST_MAJOR_CATEGORY__c').get(que.BST_MAJOR_CATEGORY__c);
        que.BST_QUESTION_TYPE__c = ClsApexUtil.picklistMap('BST_QUESTION_TYPE__c').get(que.BST_QUESTION_TYPE__c);
        que.BST_RESPONSE_TYPE__c = ClsApexUtil.picklistMap('BST_RESPONSE_TYPE__c').get(que.BST_RESPONSE_TYPE__c);
        //Changes done to save API name of multi picklist Salesforce Group
        List<String> salesforceGroupLabelList = new List<String>();
        String salesforceGroupAPIList ='' ;
        salesforceGroupLabelList = que.BST_SALESFORCE_GROUP__c.split(';');
        for(String groupName : salesforceGroupLabelList){
             salesforceGroupAPIList += ClsApexUtil.picklistMap('BST_SALESFORCE_GROUP__c').get(groupName);
             salesforceGroupAPIList +=';' ;
        }
        que.BST_SALESFORCE_GROUP__c  = salesforceGroupAPIList;
        
        //que.BST_SALESFORCE_GROUP__c = ClsApexUtil.picklistMap('BST_SALESFORCE_GROUP__c').get(que.BST_SALESFORCE_GROUP__c);
        que.BST_SALES_PROCESS__c = ClsApexUtil.picklistMap('BST_SALES_PROCESS__c').get(que.BST_SALES_PROCESS__c);
        que.BST_STATUS__c = ClsApexUtil.picklistMap('BST_STATUS__c').get(que.BST_STATUS__c);
        try
        {
            upsert newQue;
        }catch(DmlException e){
            String errMsg = e.getDmlMessage(0);
           /* if (errMsg.equalsIgnoreCase('Related To Is Required'))
                errMsg = 'Account Name is Required';
            else if (errMsg.equalsIgnoreCase('Name Is Required'))
                errMsg = 'Contact Name is Required'; */
            throw new AuraHandledException(errMsg);
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }    
        return newQue;
    }

/**
    * Method Name: getQuestionDetails
    * Description: Method invoked when existing question is updated
    * Parameter: Id
    * Return Type: Question__c
    */
   
   @AuraEnabled
   public static Question__c getQuestionDetails(Id questionId) {
       Question__C que = [SELECT BST_ANSWER_OPTIONS__c,BST_CATEGORY__c,BST_COUNTRY__c,BST_END_DATE__c,BST_INITIATIVE__c,
                          BST_MAJOR_CATEGORY__c,BST_ORDER__c,BST_PARENT_QUESTION__c,BST_PARENT_QUESTION__r.name,BST_PRIVATE__c,BST_QUESTION_LOCALE__c,
                          BST_QUESTION_STATEMENT__c,BST_QUESTION_TYPE__c,BST_PROFILE_TYPE__c,BST_RESPONSE_TYPE__c,BST_RESPONSE_VALID_TIME__c,
                          BST_SALESFORCE_GROUP__c,BST_SALES_PROCESS__c,BST_STAGE_NAME__c,BST_START_DATE__c,BST_STATUS__c,
                          BST_TYPE__c,RecordTypeId,RecordType.Name, Id FROM Question__c WHERE Id = :questionId];
      //Changes done to Retrieve API name and get their labels for multi picklist Salesforce Group
       if(que.BST_SALESFORCE_GROUP__c != null){ 
           List<String> salesforceGroupAPIList = new List<String>();
           String salesforceGroupLabelList ='' ;
           
           salesforceGroupAPIList = que.BST_SALESFORCE_GROUP__c.split(';');
           for(String groupName : salesforceGroupAPIList){
               for(String label : ClsApexUtil.picklistMap('BST_SALESFORCE_GROUP__c').keySet()){
                   if(groupName.equals(ClsApexUtil.picklistMap('BST_SALESFORCE_GROUP__c').get(label))){
                       salesforceGroupLabelList += label;
                       salesforceGroupLabelList +=';' ;
                   }
               }
           }
           que.BST_SALESFORCE_GROUP__c = salesforceGroupLabelList;
       }
       // Return existing record details here
       return que;
   }

/**
    * Method Name: getUserCountry
    * Description: Method invoked to get the country of user in context
    * Parameter: None
    * Return Type: String
    */
    
     @AuraEnabled
    public static String getUserCountry()
    {
        String Country = [Select Id, BST_COUNTRY__c FROM User where Id = :UserInfo.getUserId()].BST_COUNTRY__c;
        
        return Country;
    }
    
    /**
    * Method Name: getHelptextMap
    * Description: Method invoked to get the helptext of fields for Question
    * Parameter: None
    * Return Type: Map<Integer,String>
    */
    
    @AuraEnabled
    public static Map<Integer,String> getHelptextMap(){
        Map<Integer,String> helptextMap = new Map<Integer,String>();
        List<String> helptextFields = new List<String>();
        Integer i = 1;
        Schema.FieldSet fs1 = Schema.SObjectType.Question__c.fieldSets.getMap().get('BST_Question_HelpText');
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Question__c.fields.getMap();
        for(Schema.FieldSetMember fm : fs1.getFields()){
            if(M.keySet().Contains(fm.getFieldPath().toLowerCase())){
                    if(M.get(fm.getFieldPath().toLowerCase()).getDescribe().getinlinehelptext() != null)
                	    helptextMap.put(i,M.get(fm.getFieldPath().toLowerCase()).getDescribe().getinlinehelptext());
                	else
                        helptextMap.put(i,'');
                
                	i++;
            }
        }
     return helptextMap;
      }
    
}