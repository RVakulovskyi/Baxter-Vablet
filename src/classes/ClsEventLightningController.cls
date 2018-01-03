public with sharing class ClsEventLightningController {

    @AuraEnabled
    public static Contact getContact(Id contactId) {
        // Perform isAccessible() checks here
        return [SELECT FirstName, LastName FROM Contact WHERE Id = :contactId];
    } 
    @AuraEnabled
    public static dateTime getEndDateTime(dateTime startDate) {
        // To add one hour to start date - 13/10/17(KP)
        startDate = startDate.addHours(1);
        system.debug('startDate' +startDate);
        return startDate;
    } 
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        // Perform isAccessible() checks here
        return [SELECT Name FROM Account WHERE Id = :accountId];
    }
    @AuraEnabled
    public static AccountContactRelation getAccConRel(Id relationId){
        return [SELECT AccountId, ContactId, BST_Account_Name__c, BST_Contact_Name__c FROM AccountContactRelation WHERE Id =:relationId];
    }
    @AuraEnabled
    public static String getUserCountry()
    {
        String Country = [Select Id, BST_COUNTRY__c FROM User where Id = :UserInfo.getUserId()].BST_COUNTRY__c;
        
        return Country;
    }
    
    @AuraEnabled
    public static String getProfileId() 
    {
        return userinfo.getProfileId();
    }
    
    @AuraEnabled
    public static Id getRecordTypeId(String objApiName, String recordTypeLabel)
    {
        return ClsApexUtil.getRecordTypeBySObject(objApiName).get(recordTypeLabel).getRecordTypeId();
    }

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
    @AuraEnabled
    public static String getUserMPC()
    {
        List<User> country = [Select Id, BST_MAIN_BAXTER_TEAM__c FROM User where Id = :UserInfo.getUserId()];
        if(country[0].BST_MAIN_BAXTER_TEAM__c == null) {
            return '';
        }   
        else
            return country[0].BST_MAIN_BAXTER_TEAM__c;
    }
    @AuraEnabled
    public static List<String> getCountryValues(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.BST_COUNTRY__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        options.sort();
        return options;
    }
    @AuraEnabled
    public static Event saveEventWithContact(Event evt, Id contactId, Id accountId,id BSTAssociatedCriticalMetricsID) {
        // Perform isAccessible() and isUpdateable() checks here
        //system.debug('entered the server side controller');
        Event newEvt = evt;
        newEvt.whatId = accountId;
        newEvt.whoId = contactId;
        newEvt.BST_Associated_Critical_Metrics__c =BSTAssociatedCriticalMetricsID;
        //Below lines of code will convert the translated value
        evt.BST_CALL_TYPE__C = ClsApexUtil.picklistLableValueMap('BST_CALL_TYPE__C').get(evt.BST_CALL_TYPE__C);
        evt.BST_BAX_SALES_TEAM__C = ClsApexUtil.picklistLableValueMap('BST_BAX_SALES_TEAM__C').get(evt.BST_BAX_SALES_TEAM__C);
        evt.BST_MAIN_TOPIC__C = ClsApexUtil.picklistLableValueMap('BST_MAIN_TOPIC__C').get(evt.BST_MAIN_TOPIC__C);
        try
        {
            insert newEvt;
        }catch(DmlException e){
            String errMsg = e.getDmlMessage(0);
            if (errMsg.equalsIgnoreCase('Related To Is Required'))
                errMsg = 'Account Name is Required';
            else if (errMsg.equalsIgnoreCase('Name Is Required'))
                errMsg = 'Contact Name is Required';
            throw new AuraHandledException(errMsg);
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }    
        return newEvt;
    } 

    @AuraEnabled
    public static List<String> getEventTypeValues(String recdType)
    {
       
        List<String> possibleEventTypeValues = new List<String>();
        possibleEventTypeValues.add('');
        Schema.DescribeFieldResult fieldResult = Event.BST_CALL_TYPE__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> checkRecdTypePossibleValues = ClsApexUtil.getPossibleLOVs(recdType, 'BST_CALL_TYPE__c');
            
        for( Schema.PicklistEntry field : ple)
        {
            if(checkRecdTypePossibleValues.contains(field.getLabel())) 
            {
                   possibleEventTypeValues.add(field.getLabel());
            }
        }  
        possibleEventTypeValues.sort();    
        return possibleEventTypeValues;
    }   
        
    @AuraEnabled
    public static List<String> getMainProductCategoryValues(String recdType, String country)
    {
       List<String> possibleProductCategoryValues = new List<String>();
       possibleProductCategoryValues.add('');
       PicklistFieldController controller = new PicklistFieldController();
       Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Event','BST_COUNTRY__c','BST_BAX_SALES_TEAM__c');
       //Set<String> checkRecdTypePossibleValues = ClsApexUtil.getPossibleLOVs(recdType, 'BST_BAX_SALES_TEAM__c');
       if(!valueMap.get(country).isEmpty())
       {
           for(String val : valueMap.get(country))
           {
               //if(checkRecdTypePossibleValues.contains(val)) {
                   possibleProductCategoryValues.add(val);
               //}
           }
       }
       possibleProductCategoryValues.sort(); 
       return  possibleProductCategoryValues;
    }
    
    @AuraEnabled
    public static List<String> getMainTopicValues(String recdType, String mainProductCategory)
    {
       List<String> possibleTopicValues = new List<String>();
       possibleTopicValues.add('');
       PicklistFieldController controller = new PicklistFieldController();
       Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Event','BST_BAX_SALES_TEAM__c','BST_MAIN_TOPIC__c');
       //Set<String> checkRecdTypePossibleValues = ClsApexUtil.getPossibleLOVs(recdType, 'BST_MAIN_TOPIC__c');
       if(!valueMap.get(mainProductCategory).isEmpty())
       {
           for(String val : valueMap.get(mainProductCategory))
           {
               //if(checkRecdTypePossibleValues.contains(val)) {
                   possibleTopicValues.add(val);
               //}
           }
       }
       possibleTopicValues.sort();
       return  possibleTopicValues;
    }
    
    @AuraEnabled
    public static List<String> getEventRecordTypes(){
        List<String> retRecordTypeList = new List<String>();
        retRecordTypeList.add('');
        List<Schema.RecordTypeInfo> recdTypeInfoList = Event.SObjectType.getDescribe().getRecordTypeInfos();
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
    @AuraEnabled
    public static List<Contact> getAssociatedContacts(Id contactId)
    {
        Set<Id> conIds = new Set<Id>();
        List<AccountContactRelation> acccRelLst = [SELECT ContactId FROM AccountContactRelation WHERE ContactId = : contactId];
        for(AccountContactRelation accRel : acccRelLst)
            conIds.add(accRel.ContactId);
        List<Contact> conLst = [SELECT Id, Name FROM Contact where Id IN : conIds];
        return conLst;
    }

    @AuraEnabled
    public static Profile getUserProfile() 
    {
    Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
    return p; 
    }

    @AuraEnabled
    public static String getDefaultEventTypeValue (String recdType)
    {
        String defaultValue;
        Set<String> valSet = new Set<String>();
        valSet = ClsAPexUtil.getPossibleLOVs(recdType, 'BST_BAX_SALES_TEAM__c');
        if (!valSet.isEmpty())
            defaultValue = (new list<string>(valSet) )[0] ;
        else
            defaultValue = 'NODEFAULTVALUE';    
        return defaultValue;
    }
 
//Invocable method to be used in flow to check if object has feed  tracking enabled-13/10/17(KP)
    @InvocableMethod
   public static list<boolean> getChatterUpdate(list<id> currId) {
       list<Boolean> isChatter = new list<Boolean>();
       id selId = currId[0];
       String sObjName = selId.getSObjectType().getDescribe().getName();
       Schema.SObjectType objToken = Schema.getGlobalDescribe().get(sObjName);
       Schema.DescribeSObjectResult drSObj = objToken.getDescribe();
       boolean hasChatter = drSObj.isFeedEnabled(); 
       isChatter.add(hasChatter);
       return isChatter;
   }
    
}