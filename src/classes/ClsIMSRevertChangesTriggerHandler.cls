public class ClsIMSRevertChangesTriggerHandler 
{
    //Arpit 10/18/2016
    //Description - This class will be used to post the status of Integration log on Corresponding record and also to revert the values in case the record is rejected
    //Change Log : 24-Jan-2017 by Arpit to Add logic for posting rejection reason on chatter
    //Change Log : 12-Apr-2017 by Arpit to Add logic for @mention the Country admin users in Chatter post
    
    public Map<Id, INTEGRATION_LOG__c> lstNewRecordsMap = new Map<Id, INTEGRATION_LOG__c>();//Holds new map from the object trigger
    public Map<Id, INTEGRATION_LOG__c> lstOldRecordsMap = new Map<Id, INTEGRATION_LOG__c>();//Holds oldmap from the object trigger

    private List<INTEGRATION_LOG__c> rejectedList = new List<INTEGRATION_LOG__c>();//List to work on the actual Baxter Rejected records
    private Set<Id> listOfRejLogId = new Set<Id>(); //Set for holding the Values of Int Log Id values to be changed
    private String sObjectType;//Used to get the sobject of the record for which the Integration log is created
    private Map<Id, Map<String, String>> intAuditMap = new Map<Id, Map<String, String>>();//Map of Integration log to its old field name/field value
    private List<SObject> sObjListToBeUpdated = new List<SObject>();//List of SObjects, which needs to be updated with old values
    private Map<Id, INTEGRATION_LOG__c> rejectedStatements = new Map<Id, INTEGRATION_LOG__c>{};//Map to store records where Rejection reason is not filled 
    private String IntegrationUserId;//Id used to check for Integration user
    private Set<Id> accConIds = new Set<Id>();//List will be used to prepare the AccountContactRelation set
    private Map<String, String> accConRelIdToParentIdMap = new Map<String, String>();//Map stores the Id to Parent Id for AccountContactRelation object
    private List<User> countryAdmin = new List<User>(); //List to store the Country Admin users 
    private Map<String, User> countryUserMap = new Map <String, User>(); //Map to store Admin users with their country
    public String adminUserId; //Variable to store  Id of Country Admin
    private Set <String> localAdmin = new Set<String>() ; //Stores the set of Roles for Admin
    
    private Set<ID> conAccIds = new Set<Id>(); //List will be used to prepare the Contacts in AccountContactRelation set
    private List <Contact> conListToUpdate = new List<Contact>(); //List consisting of Contacts to be updated
    
    //Method invoked from the trigger with Trigger.New list
    public void processRecords (List<INTEGRATION_LOG__c> logList)
    {
        //Changes start on 12-Apr-2017
        for(BST_Country_Admin__mdt mdt:[SELECT BST_Role__c FROM BST_Country_Admin__mdt]){
            localAdmin.add(mdt.BST_Role__c);
        }
        countryAdmin = [SELECT BST_COUNTRY__c,Id,IsActive,Name,Username, UserRole.Name FROM User where UserRole.DeveloperName IN :localAdmin and IsActive =: true];
        for (User usr : countryAdmin){
              countryUserMap.put(usr.BST_COUNTRY__c, usr);
        }
        //Changes End on 12-Apr-2017
        //Get Integration User Id
        IntegrationUserId = (String)[SELECT ID FROM USER WHERE Profile.Name =: system.label.BST_Integration_Administrator].Id;
        
        //Go over the integration logs and find the ones, which needs to be reverted*/
        for(INTEGRATION_LOG__c intLog : logList)
        {     
            adminUserId = (String)countryUserMap.get(intLog.BST_COUNTRY__c).Id;  //Added on 12-Apr-2017
            //Check if the current and previous status is Rejected
            //Check if the Rejection reason has been provided or not by checking status of record in old and new map     
            if(lstOldRecordsMap != null && !lstOldRecordsMap.get(intLog.Id).BST_STATUS__c.containsIgnoreCase(system.label.BST_Baxter_Rejected) 
                && lstNewRecordsMap.get(intLog.Id).BST_STATUS__c.containsIgnoreCase(system.label.BST_Baxter_Rejected))
            {
                rejectedStatements.put(intLog.Id, intLog);
            }
            //Check if the type of record is Update and it has been rejected
            //and to check if the rejection is not done by Integration user
            if(lstNewRecordsMap.get(intLog.Id).BST_STATUS__c.containsIgnoreCase(system.label.BST_Rejected) && 
                 lstNewRecordsMap.get(intLog.Id).BST_TYPE__c.containsIgnoreCase(system.label.BST_Update) &&
                 lstNewRecordsMap.get(intLog.Id).Lastmodifiedbyid != IntegrationUserId
              )
            {
                rejectedList.add(intLog);
                listOfRejLogId.add(intLog.Id);
            }
            else
            {
                rejectedList.add(intLog);
                system.debug('*****The List value is :' +rejectedList);
            }       
        }
        //Block to create a map of Id to ParentId for AccountContactRelation, which will be used for Chatter
        for(INTEGRATION_LOG__c accConIntLog : rejectedList)
        {
            if(accConIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c != null){
                accConIds.add(accConIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c);
            }
            
            if(accConIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c != null && accConIntLog.BST_CONTACT_ID__c != null){ //Added for BOOS-703
                conAccIds.add(accConIntLog.BST_CONTACT_ID__c);
            }           
        }
        if(accConIds.size() > 0)
        {
            for(AccountContactRelation accRel : [SELECT Id, AccountId FROM AccountContactRelation WHERE Id IN:accConIds])
            {
                accConRelIdToParentIdMap.put(accRel.Id, accRel.AccountId);
            }
        }
        
        List <Contact> newConList = [SELECT Id, BST_STATUS__c FROM Contact WHERE Id IN:conAccIds];
        //Populate the map of Integration log to its old field name/field value
        for(INTEGRATION_LOG_AUDIT__c rejIntLog : [SELECT BST_IMS_INTEGRATION_LOG__c, BST_FIELD_API_NAME__c, BST_FIELD_OLD_VALUE__c FROM INTEGRATION_LOG_AUDIT__c WHERE   BST_IMS_INTEGRATION_LOG__c in :listOfRejLogId])
        {
            if(intAuditMap.containsKey(rejIntLog.BST_IMS_INTEGRATION_LOG__c)) //Logic to revert the values
            {
                intAuditMap.get(rejIntLog.BST_IMS_INTEGRATION_LOG__c).put(rejIntLog.BST_FIELD_API_NAME__c, rejIntLog.BST_FIELD_OLD_VALUE__c);
            }
            else
            {
                Map<String, String> oldFieldValueMap = new Map<String, String>();//Field API Name, Field Value
                oldFieldValueMap.put(rejIntLog.BST_FIELD_API_NAME__c, rejIntLog.BST_FIELD_OLD_VALUE__c);
                intAuditMap.put(rejIntLog.BST_IMS_INTEGRATION_LOG__c, oldFieldValueMap);
            }
        }   
            
        //Go through the records, which needs to be updated and then prepare the sObject list
        for(INTEGRATION_LOG__c rejIntLog : rejectedList)
        {
            Id sObjId;
            
            //Get Account/Contact/Related Contact/Related Account Id
            //Added for BOOS-703 - Start
            if(rejIntLog.BST_TYPE__c == 'AccountContactRelation Create' && rejIntLog.BST_CONTACT_ID__c != null){
                
                for(Contact cntct : newConList)         
                {   
                    cntct.BST_STATUS__c = rejIntLog.BST_STATUS__c;      
                    conListToUpdate.add(cntct);
                }
                
                sObjId = rejIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c;              
                
            }
            //Added for BOOS-703 - End
            else{
                sObjId = (rejIntLog.BST_ACCOUNT_ID__c != null ? rejIntLog.BST_ACCOUNT_ID__c : (rejIntLog.BST_CONTACT_ID__c != null ? rejIntLog.BST_CONTACT_ID__c : (rejIntLog.BST_RELATED_ACCOUNT_ID__c != null ? rejIntLog.BST_RELATED_ACCOUNT_ID__c : (rejIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c != null ? rejIntLog.BST_ACCOUNT_CONTACT_RELATION_ID__c : null))));
                system.debug('#######The value of sObject is :' +sObjId);
            }
            //Instantiating sObject
            Schema.SObjectType token = sObjId.getSObjectType();
            Schema.DescribeSObjectResult descRes = token.getDescribe();
            String sObjectType = descRes.getName();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectType);
            sObject newSobj = targetType.newSObject();
            Map<String, Schema.SObjectField> fieldsMap= descRes.fields.getMap();
            newSobj.put('Id', sObjId);
            newSobj.put('BST_STATUS__c', rejIntLog.BST_STATUS__c);
            system.debug('#######The value of BST_STATUS__c is :' +rejIntLog.BST_STATUS__c);
            Map<String, String> oldFieldNameToValueMap = intAuditMap.get(rejIntLog.Id);
            if(oldFieldNameToValueMap != null)
            {
                system.debug('#######The value of sObject is :' +sObjId);
                for(String fieldName : oldFieldNameToValueMap.keySet())
                {
                    if((fieldName.equalsIgnoreCase('DP_END_DATE__c') || fieldName.equalsIgnoreCase('DP_START_DATE__c')) && oldFieldNameToValueMap.get(fieldName) != null )
                       newSobj.put(fieldName,Date.valueOf(oldFieldNameToValueMap.get(fieldName)));//Typecasting for Date fields
                    else if((fieldName.equalsIgnoreCase('DP_ACT_SEQ_NUM__c') && oldFieldNameToValueMap.get(fieldName) != null ))
                       newSobj.put(fieldName,Decimal.valueOf(oldFieldNameToValueMap.get(fieldName)));    
                    else
                     if(fieldsMap.get(fieldName).getDescribe().isUpdateable()) {
                         newSobj.put(fieldName,oldFieldNameToValueMap.get(fieldName));
                      }
                    
                } 
            }   
        String RejReason;   
        if (!rejectedStatements.isEmpty())  
        {
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
        for (INTEGRATION_LOG__c ints : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                      FROM INTEGRATION_LOG__c WHERE ID IN :rejectedStatements.keySet()])
        {
            processInstanceIds.add(ints.ProcessInstances[0].Id);
        }
      
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
         for (ProcessInstance pi : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1 )
                               FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])   
            {
                 RejReason = pi.Steps[0].Comments;
            }                  
        }   
            
            //Chatter post on Related sObject
            Id chatterObjId = (sObjectType == 'AccountContactRelation' ? accConRelIdToParentIdMap.get(sObjId) : sObjId); //Only for AccountContactRelation we should get the Parent Account Id to post the feed, this is because of the product limitation
            
           if(rejIntLog.BST_STATUS__c.contains(System.Label.BST_Rejected)){
               if(RejReason!= null){     
                ClsApexUtil.addFeedItemToRecord(chatterObjId, System.Label.StatusOfChatter + ' ' +newSobj.get('BST_STATUS__c') + ' ' +System.Label.Topic + ' ' +RejReason, adminUserId); 
               } 
               else{
                ClsApexUtil.addFeedItemToRecord(chatterObjId, System.Label.StatusOfChatter + ' ' +newSobj.get('BST_STATUS__c') + ' ' +System.Label.Topic, adminUserId);
            }
           }
            else{
            if(RejReason!= null){
            ClsApexUtil.addFeedItemToRecord(chatterObjId, System.Label.StatusOfChatter + ' ' +newSobj.get('BST_STATUS__c') + ' ' +System.Label.Topic + ' ' +RejReason);//Post to chatter with the comments values
            }
            else{
            ClsApexUtil.addFeedItemToRecord(chatterObjId, System.Label.StatusOfChatter + ' ' +newSobj.get('BST_STATUS__c') + ' ' +System.Label.Topic);//Post to chatter without the comments values
            }
           } 
            sObjListToBeUpdated.add(newSobj);
               
        }
        
        //Added for BOOS-703- START
        //Update Contact Records attached in AccountContactRelation
        if(!conListToUpdate.isEmpty()){
            try
            {
                update conListToUpdate;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }       
        }
        //Added for BOOS-703- END
        
        //Update sObject Records
        if(!sObjListToBeUpdated.isEmpty()){
            try
            {
                system.debug('******I AM HERE FINALLY*****');
                update sObjListToBeUpdated;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }       
        }
     /* if (!rejectedStatements.isEmpty())  
      {
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
        for (INTEGRATION_LOG__c ints : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                      FROM INTEGRATION_LOG__c WHERE ID IN :rejectedStatements.keySet()])
        {
            processInstanceIds.add(ints.ProcessInstances[0].Id);
        }
      
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
        for (ProcessInstance pi : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1 )
                               FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])   
        {                   
              if ((pi.Steps[0].Comments == null || 
                   pi.Steps[0].Comments.trim().length() == 0))
              {
                rejectedStatements.get(pi.TargetObjectId).addError(System.Label.Rejection_Reason); //Add the error if rejection reason not provided
              }         
        }           
      } */
    }
    
}