public class ClsApexUtil 
{
//Jagan 10/14/2016
//Description - This class will be the Utility class with methods used by various apex classes in application
//Change Log : Arpit Agarwal 5/30/2017 - Wave 2
    
    //One comment - Satty Cha Comment
    //Gets all record types by SObject
    public static Map<String, Schema.RecordTypeInfo> getRecordTypeBySObject(String apiName)
    {
        return Schema.getGlobalDescribe().get(apiName).getDescribe().getRecordTypeInfosByName();
    }
    //Gets a specific RecordType by SObject name/Label
    public static Id getRecordTypeId(String objApiName, String recordTypeLabel)
    {
        return getRecordTypeBySObject(objApiName).get(recordTypeLabel).getRecordTypeId();
    }
    //Method to get the definition of the Fields for a given SObjectType
    public static Map<String, Schema.SObjectField> getFieldsSetMap (String objectType)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectSchema = schemaMap.get(objectType);
        Map<String, Schema.SObjectField> fieldsSetMap = sObjectSchema.getDescribe().fields.getMap();
        return fieldsSetMap;
    }  
    //Method used to submit the record for approval
    public static void submitForApproval(String sObjectId, String comments, List<User> approvers)
    {
        // Create an approval request for the sObject
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(sObjectId);
        req1.setNextApproverIds(new Id[] {approvers[0].Id});
        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);
    
    }
    //Method used to get ProcessInstanceWorkItemId using SOQL
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
            retVal  =  workItem.Id;
        return retVal;
    }
    //Method used to get ProcessInstanceWorkItemId using SOQL
    public static void rejectRecord(SObject sObj, String comments)
    {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(comments);
        req.setAction('Reject');
        Id workItemId = getWorkItemId(sObj.id);   
    
        if(workItemId != null)
        {   
            req.setWorkitemId(workItemId);
            // Reject the record, which is in approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    //Method will insert a chatter feed for a given Salesforce record
    public static void addFeedItemToRecord (Id sObjectId, String comments)
    {
        FeedItem post = new FeedItem();
        post.ParentId = sObjectId;
        post.Body = comments;
        insert post;
    }
     
     
        //Method will insert a chatter feed only for rejection for a given Salesforce record also @mention the country Admin
    public static void addFeedItemToRecord(Id sObjectId, String comments, String CountryAdminId){
        FeedItem post = new FeedItem();
        post.ParentId = sObjectId;
        post.Body = comments;
        insert post;
       if(!Test.isRunningTest()){
        ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();        
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();        
        mentionSegmentInput.id = CountryAdminId;// this will be ID of country admin 
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        
        commentInput.body = messageBodyInput;
        
        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement(null, post.id, commentInput,null);// this yellow will be id of feeditem
      }
    } 
    //Method returning the label to value combination for Event object
    public static Map<String, String> picklistLableValueMap (String fieldName)
    {
        Schema.DescribeFieldResult fieldResult;
        Map<String, String> pickListLabelValueMap = new Map<String, String>();
        //Schema.DescribeFieldResult fieldResult = Event.fieldName.getDescribe();
        // Get the describe result for the Type field on the Account object
        if(fieldName == 'BST_CALL_TYPE__C')
            fieldResult = Event.BST_CALL_TYPE__C.getDescribe();
        else if(fieldName == 'BST_BAX_SALES_TEAM__C')
            fieldResult = Event.BST_BAX_SALES_TEAM__C.getDescribe();
        else if(fieldName == 'BST_MAIN_TOPIC__C')
            fieldResult = Event.BST_MAIN_TOPIC__C.getDescribe();
        
        List<Schema.PicklistEntry> pickListEntry = fieldResult.getPicklistValues();
        for(Integer contrIndex=0; contrIndex<pickListEntry.size(); contrIndex++)
        {            
            Schema.PicklistEntry ctrlentry = pickListEntry[contrIndex];
            pickListLabelValueMap.put(ctrlentry.getLabel(), ctrlentry.getValue());
        }   
        return pickListLabelValueMap;
    }
    //Method gets all possible picklist values for the Event recordtype
    public static Set<String> getPossibleLOVs (String recordTypeName, String fieldName)
    {
        List<Event_Details__mdt> evtDetailsListForRecdType = new List<Event_Details__mdt>();
        If(fieldName == 'BST_BAX_SALES_TEAM__c')
            evtDetailsListForRecdType = [SELECT RecordTypeName__c, BST_BAX_SALES_TEAM__c FROM Event_Details__mdt WHERE MasterLabel = : recordTypeName];
        else If(fieldName == 'BST_MAIN_TOPIC__c')
            evtDetailsListForRecdType = [SELECT RecordTypeName__c, BST_MAIN_TOPIC__c FROM Event_Details__mdt WHERE MasterLabel = : recordTypeName];
        else If(fieldName == 'BST_CALL_TYPE__c')
            evtDetailsListForRecdType = [SELECT RecordTypeName__c, BST_CALL_TYPE__c FROM Event_Details__mdt WHERE MasterLabel = : recordTypeName];
        
        
        Set<String> eventFieldSet = new Set<String>();
        for(Event_Details__mdt evtFields : evtDetailsListForRecdType)
        {
            String possibleValues;
            If(fieldName == 'BST_BAX_SALES_TEAM__c')
                possibleValues = evtFields.BST_BAX_SALES_TEAM__c;
            else If(fieldName == 'BST_MAIN_TOPIC__c')
                possibleValues = evtFields.BST_MAIN_TOPIC__c;
            else If(fieldName == 'BST_CALL_TYPE__c')
                possibleValues = evtFields.BST_CALL_TYPE__c;
            
            if(possibleValues!= null && possibleValues.split(';').size() > 1)
            {
                for(String value : possibleValues.split(';'))
                {
                    if(value != '' )
                        eventFieldSet.add(value);
                }
            }
        }
        system.debug('Possible size of getPossibleLOVs is ' + eventFieldSet.size());
        return eventFieldSet;
    }
  public static void countryAndTeamCheck (String userCountry, String primCountry, String usrSecCountry, List<sObject> sObjList)
  {
   for(sObject sObj : sObjList)
   {
       if(usrSecCountry==null)
       {
           if (userCountry != primCountry)
            {
               sObj.addError(System.Label.BST_Country_Validation);       
            }
       }
        else
        {
            if(userCountry != primCountry && !usrSecCountry.contains(primCountry))    
            {
               sObj.addError(System.Label.BST_Country_Validation);             
            }
        }    
   }
  }
  
  public static Map<String, String> picklistMap (String fieldName)
    {
        Schema.DescribeFieldResult fieldResult;
        Map<String, String> pickListLabelValueMap = new Map<String, String>();
        //Schema.DescribeFieldResult fieldResult = Question__c.fieldName.getDescribe();
        // Get the describe result for the Picklist fields on the Question object
        if(fieldName == 'BST_CATEGORY__c')
            fieldResult = Question__c.BST_CATEGORY__c.getDescribe();
        else if(fieldName == 'BST_MAJOR_CATEGORY__c')
            fieldResult = Question__c.BST_MAJOR_CATEGORY__c.getDescribe();
        else if(fieldName == 'BST_QUESTION_TYPE__c')
            fieldResult = Question__c.BST_QUESTION_TYPE__c.getDescribe();
        else if(fieldName == 'BST_RESPONSE_TYPE__c')
            fieldResult = Question__c.BST_RESPONSE_TYPE__c.getDescribe();
        else if(fieldName == 'BST_SALESFORCE_GROUP__c')
            fieldResult = Question__c.BST_SALESFORCE_GROUP__c.getDescribe();
        else if(fieldName == 'BST_SALES_PROCESS__c')
            fieldResult = Question__c.BST_SALES_PROCESS__c.getDescribe();
        else if(fieldName == 'BST_STATUS__c')
            fieldResult = Question__c.BST_STATUS__c.getDescribe();
            
        List<Schema.PicklistEntry> pickListEntry = fieldResult.getPicklistValues();
        for(Integer contrIndex=0; contrIndex<pickListEntry.size(); contrIndex++)
        {            
            Schema.PicklistEntry ctrlentry = pickListEntry[contrIndex];
            pickListLabelValueMap.put(ctrlentry.getLabel(), ctrlentry.getValue());
        }   
        system.debug('pickListLabelValueMap' + pickListLabelValueMap);
        return pickListLabelValueMap;
    }
}