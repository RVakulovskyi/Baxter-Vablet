//Jagan 10/14/2016
//Description - This class will be used to handle records invoked as part of the trigger from Account, Contact, AccountContactRelation and Account_Account_Relation__c objects
//Modified - 1. Made the logic to determine admin profiles to be dynamic
//           2. Made the logic to determine admin roles to be dynamic
//           3. Removed the seperate if block for Related Contact and Related Account and combined to one for all sObject
//           4. Added the logic to update the country of AccountContact Relationship because of validaion rule limitation 
// 11-May-17 5. Added logic to check if there are any Baxter only records present in AccountAccountRelation/AccountContactRelation 
// 17-Aug-17 6. Added logic to implement JIRA BOOS-576
public class ClsIMSFieldAuditTriggerHandler
{

    public Map<Id, SObject> lstNewRecordsMap = new Map<Id, SObject>();//Holds new map from the object trigger
    public Map<Id, SObject> lstOldRecordsMap = new Map<Id, SObject>();//Holds oldmap from the object trigger
    public String triggerEvent;//Holds the event being Create or Update
    public String sObjectType;//Holds the SObject type

    private Map<String, List<String>> imsFieldValuesMap = new Map<String, List<String>>();//Holds the ims updated fields and their values. Key in map will be Field API and the list will have 3 items, first item is field label, second item is field new value and third item is field old value
    private Boolean  imsAuditFieldCheck = false; //Flag to check if any IMS Fields are updated
    private Boolean  isActionPerformedByAdmin = false;//Flag to check if the action executed by admin
    private String recordTypeId;//Retrieves the record type, which is of interest for IMS
    private List<User> approverLst;//Stores the approvers for the current country who will be the Business admin and have a particular role
    private Map<Id, INTEGRATION_LOG__c> recordsWithActiveIntLogsMap = new Map<Id, INTEGRATION_LOG__c>();//Map to track records with active integration logs
    private Set<String> countryAdminProfileSet;//Set to store the possible admin profile names for a given country
    private Set<String> countryAdminRoleSet;//Set to store the possible admin role names for a given country
    private Id parentObjId;//Id will be used for chatter post for AccountContactRelation object
    private List<IMS_Audit_Fields__mdt> recType = new List<IMS_Audit_Fields__mdt>();//List of String to store the recordtype name for Account and Contact for a given country
    private List<Sobject> sObjLstToBeInactivated = new List<Sobject>();// List used to gather SObjects to be inactivated
    private Map<Id, String> relNameMap = new Map<Id, String>();//Map will store the Id to Account>Contact name or Account>Account name
    private LIst<User> usr = new List<User>();
    public List<Sobject> Acc = new List<Sobject>();
    private Boolean  baxterOnlyRecordCheck = false; //Flag to check if AccConRelation or AccAccRelation Consists of Baxter only record
    private List<User> countryAdmin = new List<User>(); //List to store the Country Admin users 
    private Map<String, User> countryUserMap = new Map <String, User>(); //Map to store Admin users with their country
    public String adminUserId; //Variable to store  Id of Country Admin
    private Set <String> localAdmin = new Set<String>() ; //Stores the set of Roles for Admin
    
    //Method to process all triggered records
    public void processRecords(List<SObject> recList)
    {   
         //Changes start on 11-May-2017
        for(BST_Country_Admin__mdt mdt:[SELECT BST_Role__c FROM BST_Country_Admin__mdt]){
            localAdmin.add(mdt.BST_Role__c);
        }
        countryAdmin = [SELECT BST_COUNTRY__c,Id,IsActive,Name,Username, UserRole.Name FROM User where UserRole.DeveloperName IN :localAdmin and IsActive =: true];
        for (User usr : countryAdmin){
              countryUserMap.put(usr.BST_COUNTRY__c, usr);
        }
        //Changes End on 11-May-2017
        //Check if the Create/Update action performed by admin
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('The Value of Profile is :' +profileName +'Label is : ' +System.Label.BST_Admin);
        //Code for Country Validation Starts
        if(!profileName.contains(System.Label.BST_Admin))
        {
            usr = [SELECT BST_COUNTRY__c,BST_MAIN_BAXTER_TEAM__c,BST_OTHER_BAXTER_TEAM__c,BST_SECONDARY_COUNTRY__c,Id FROM User where 
                              Id = : UserInfo.getUserId()]; //22/11/2016 Changes 
            system.debug('The vaule of user is : ' +usr);
        }
        for(Id sObjectId : lstNewRecordsMap.keySet())
        { 
           sObject sObj1 = lstNewRecordsMap.get(sObjectId);//Get current sObject 
           String sObjCountry = (String)sObj1.get('BST_COUNTRY__c'); //Added on 11-May-2017
           adminUserId = (String)countryUserMap.get(sObjCountry).Id;  //Added on 11-May-2017 
           if(!usr.isEmpty())
           {
               for(User usr1 : usr)
               {
                  ClsApexUtil.countryAndTeamCheck(usr1.BST_COUNTRY__c, (String)sObj1.get('BST_COUNTRY__c'), usr1.BST_SECONDARY_COUNTRY__c, recList);
               }
           }  
        }
        //Code for Country Validation Ends
        //Retrieve the admin profiles for the user's country and check against the current user's profile
        List <User> userCountry = new List<User>();
        userCountry = [Select Id,BST_COUNTRY__c, BST_SECONDARY_COUNTRY__c from User where Id=:Userinfo.getUserID()]; //22/11/2016 Changes
        if(!userCountry.isEmpty())
        {           
            countryAdminProfileSet = ClsIMSIntegrationLogUtil.getAdminProfiles(userCountry.get(0).BST_COUNTRY__c);
            if(countryAdminProfileSet.contains(profileName))
            isActionPerformedByAdmin = true;
    
            /*Retrieve the recordtype only for Account and Contacts*/
            if(sObjectType == System.Label.BST_Account || sObjectType == System.Label.BST_Contact) //Check the type of record
            {
                recType = [SELECT Record_Type__c FROM IMS_Audit_Fields__mdt WHERE Country__c = : userCountry.get(0).BST_COUNTRY__c AND Object_Name__c = :sObjectType];  
                //Get Recordtype, which we need to send to IMS
                if(!recType.isEmpty())
                {
                    recordTypeId = recType.get(0).Record_Type__c;//ClsApexUtil.getRecordTypeId(sObjectType, recType.get(0).Record_Type__c); //Changed by Arpit
                }
            }
        }
        system.debug('@@@@@isActionPerformedByAdmin '+isActionPerformedByAdmin );
        
        //Handle Create flow for all objects except Contact (Change made on 10-Feb by Arpit)
        if(triggerEvent == 'Create' && sObjectType != System.Label.BST_Contact)
        {
            if(!isActionPerformedByAdmin)
            {
                //This method will populate the map relNameMap
                populateRelationName();
                for(Id sObjectId : lstNewRecordsMap.keySet())
                {
                    sObject sObj = lstNewRecordsMap.get(sObjectId);//Get current sObject 
                    //Get all the changed IMS Audit field values
                    imsFieldValuesMap = ClsIMSIntegrationLogUtil.getChangedFieldDetails (sObj.Id, sObjectType, triggerEvent, sObj, sObj);
                    
                    //system.debug('Value of BST_IMS_PROCESS_FLAG__c is '+ (Boolean)sObj.get('BST_IMS_PROCESS_FLAG__c') );
                    system.debug('Value of BST_BAXTER_ONLY__c is '+ !(Boolean)sObj.get('BST_BAXTER_ONLY__c') );
                    system.debug('Size of imsFieldValuesMap is '+imsFieldValuesMap.size() );
                    //Condition to check
                    //For Account, Contact : RecordType matches IMS Account, Any one of IMS Audit field is included in record creation, Account should not be Baxter Only 
                    //For AccountContactRelation, Account_Account_Relation__c : Both associated records have IMS Flag checked, Record nor marked for Baxter Only and Any one of IMS Audit field is included in record creation
                    if(
                        ((sObjectType == System.Label.BST_Account || sObjectType == System.Label.BST_Contact) && sObj.get('RecordTypeId') == recordTypeId && !imsFieldValuesMap.isEmpty() && !(Boolean)sObj.get('BST_BAXTER_ONLY__c')) ||
                        ((sObjectType == System.Label.BST_RelatedAccount || sObjectType == System.Label.BST_AccountContactRelation) && (Boolean)sObj.get('BST_IMS_PROCESS_FLAG__c') && !(Boolean)sObj.get('BST_BAXTER_ONLY__c') && !imsFieldValuesMap.isEmpty())
                    )
                    {
                        system.debug('Entered the process of execution');
                        if(sObjectType == System.Label.BST_AccountContactRelation)
                            parentObjId = (Id)sObj.get('AccountId');
                        system.debug('Parent Id is ' + parentObjId);
                        if((sObjectType == System.Label.BST_AccountContactRelation || sObjectType == System.Label.BST_RelatedAccount) && (Boolean)sObj.get('BST_HAS_BAXTER_ONLY_RECORD__c')){
                            baxterOnlyRecordCheck = true;
                        }
                        processNewRecord(sObjectId, parentObjId, relNameMap.get(sObjectId), (String)sObj.get('BST_COUNTRY__c')); //For account and contact we dont have Parent Id
                    }
                } 
                                   
            }
        }
        
        if(triggerEvent == 'Update')
        {
           system.debug('@@@@@in update');
            //This method will populate the map relNameMap
            populateRelationName();
            Boolean recordExist;
            //Retrieves SObjectIds, which have active Integration log records
            recordsWithActiveIntLogsMap = ClsIMSIntegrationLogUtil.getSObjectsWithActiveIntegrationLogs(); 

            for(Id sObjectId : lstNewRecordsMap.keySet())
            {

                system.debug('Enter first for loop with sobjectid' + sObjectId);
                sObject newSObj = lstNewRecordsMap.get(sObjectId);//Get sObject with new values
                sObject oldSObj = lstOldRecordsMap.get(sObjectId);//Get current sObject with old values
                    
                string sObjValue = (string)newSObj.get('BST_STATUS__c');
                imsFieldValuesMap = ClsIMSIntegrationLogUtil.getChangedFieldDetails (newSObj.Id, sObjectType, triggerEvent, newSObj, oldSObj);//Get all the changed IMS Audit field values
                if(!imsFieldValuesMap.isEmpty())//Check if any IMS Audit fields are updated
                {
                    if(recordsWithActiveIntLogsMap.containsKey(sObjectId) == true && ((newSObj.get('BST_STATUS__c') != oldSObj.get('BST_STATUS__c')) && (!sObjValue.contains('Review'))))//Check if active Integration log record exists
                    {
                        system.debug('Enter process of recordsWithActiveIntLogsMap');   
                       if(!recordsWithActiveIntLogsMap.get(sObjectId).BST_STATUS__c.startsWith(System.Label.BST_IMS) && profileName.contains(System.Label.BST_Integration_Administrator)) //Check if the approval steps is not with IMS
                            {
                                ClsApexUtil.rejectRecord(recordsWithActiveIntLogsMap.get(sObjectId), System.Label.IMSRejectReason);
                                //<Mark note for admin review>
                                ClsApexUtil.addFeedItemToRecord(sObjectId, System.Label.StatusOfChatter + ' '+  System.Label.BST_Baxter_Rejected);
                                ClsApexUtil.addFeedItemToRecord(sObjectId, System.Label.IMSRejectReason);
                            }
                            /*else{
                            if(!isActionPerformedByAdmin){
                               system.debug('Enter admin update check');
                               lstNewRecordsMap.get(sObjectId).addError(System.Label.BST_Pending_Approval_Error);
                            
                             }
                          }*/
                       
                    } else if(sObjValue!= null && sObjValue.contains('Review')){
                      system.debug('Enter admin update check');
                      lstNewRecordsMap.get(sObjectId).addError(System.Label.BST_Pending_Approval_Error);
                    }  
                    else
                    {
                    system.debug('@@@in elseisActionPerformedByAdmin'+isActionPerformedByAdmin);

                        if(!isActionPerformedByAdmin)
                        {
                            //system.debug('Value of BST_IMS_PROCESS_FLAG__c is '+ (Boolean)newSObj.get('BST_IMS_PROCESS_FLAG__c') );
                            system.debug('Value of BST_BAXTER_ONLY__c is '+ !(Boolean)newSObj.get('BST_BAXTER_ONLY__c') );
                            system.debug('Size of imsFieldValuesMap is '+imsFieldValuesMap.size() );
                            //Condition to check
                            //For Account, Contact : RecordType matches IMS Account, Any one of IMS Audit field is included in record creation, Account should not be Baxter Only 
                            //For AccountContactRelation, Account_Account_Relation__c : Both associated records have IMS Flag checked, Record nor marked for Baxter Only and Any one of IMS Audit field is included in record creation
                            if(
                                ((sObjectType == System.Label.BST_Account || sObjectType == System.Label.BST_Contact) && newSObj.get('RecordTypeId') == recordTypeId && !imsFieldValuesMap.isEmpty() && !(Boolean)newSObj.get('BST_BAXTER_ONLY__c')) ||
                                (((sObjectType == System.Label.BST_RelatedAccount && ((Date)newSObj.get('DP_END_DATE__c') != (Date)oldSObj.get('DP_END_DATE__c') && (Date)newSObj.get('DP_END_DATE__c') < System.TODAY() && newSObj.get('DP_END_DATE__c') != null)) || 
                                sObjectType == System.Label.BST_AccountContactRelation) && (Boolean)newSObj.get('BST_IMS_PROCESS_FLAG__c') && !(Boolean)newSObj.get('BST_BAXTER_ONLY__c') && !imsFieldValuesMap.isEmpty())
                            )
                            {
                                if(sObjectType == System.Label.BST_AccountContactRelation)
                                    parentObjId = (Id)newSObj.get('AccountId');
                                system.debug('ParentObjId value is '+parentObjId);
                                if((sObjectType == System.Label.BST_AccountContactRelation || sObjectType == System.Label.BST_RelatedAccount) && (Boolean)newSObj.get('BST_HAS_BAXTER_ONLY_RECORD__c')){
                                    baxterOnlyRecordCheck = true;
                                }   

                                processNewRecord(sObjectId, parentObjId, relNameMap.get(sObjectId), (String)newSObj.get('BST_COUNTRY__c')); //For account and contact we dont have Parent Id
                            }
                        }
                    }
                }
            }
        }
    }
    private void processNewRecord(Id sObjectId, Id parentObjId, String relName, String country)
    {
        //Create Integration Log record
        String integrationLogId = ClsIMSIntegrationLogUtil.createIMSIntegrationLog (sObjectId, parentObjId, relName, sObjectType, country, triggerEvent, imsFieldValuesMap, baxterOnlyRecordCheck, adminUserId);//Creates IMS Integration Log Record

        //Get the country's approver and if there isn't no approver
        countryAdminRoleSet = ClsIMSIntegrationLogUtil.getAdminRoles(country);
        system.debug('AdminRoleSet size is ' + countryAdminRoleSet.size());
        approverLst = [SELECT ID FROM USER WHERE UserRole.Name IN : countryAdminRoleSet and isActive=true];//Though this will issue a SOQL call for every transaction, that is fine as the SOQL is against Custom metadatatype, which is not counted against governer limits
        if(approverLst.isEmpty())
            approverLst = [SELECT ID FROM USER WHERE Profile.Name =: System.Label.BST_System_Administrator  and isActive=true];
          // system.debug('Approver is ' + approverLst[0].Id);
        if(!approverLst.isEmpty()){  
        //Submit the created Integration log record for approval
          ClsApexUtil.submitForApproval(integrationLogId, System.Label.BST_ApprovalReq, approverLst);
        }
    }
    public void processInvalidRecords(List<SObject> recList)
    {
        /*Logic to update the record owner when it has been inactivated*/
        if(sObjectType == System.Label.BST_Account || sObjectType == System.Label.BST_Contact) //Check the type of record
        {
            for(sObject sObjct : recList)
            {
                if((sObjectType == System.Label.BST_Account && sObjct.get('DP_WKP_STATUS__c') == System.Label.BST_Invalid) ||
                        (sObjectType == System.Label.BST_Contact && sObjct.get('DP_IND_STATUS__c') == System.Label.BST_Invalid) //Changed State to Status post field changes 6-Feb-2017 
                    )   
                {
                    sObjct.put('OwnerId', Userinfo.getUserID()); //Update the Owner of the record to current owner
                }
            }
        }
    }
   //Update state and status field on Account, Contact and AccountContactRelation and Start & End Date on RelatedAccount 
   //(Change made on 17-April by Rashmi)- start
    public void processStatusUpdate(List<Sobject> recList)
    {
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;

        /*Logic to update the state and status field*/
      /*  if(sObjectType == System.Label.BST_Account) //Check the type of record
        {
            for(Sobject sObjct : recList)
            {
               sObjct.put('DP_WKP_STATUS__c',System.Label.BST_Valid);
               sObjct.put('DP_WKP_STATE__c',System.Label.BST_Open);
            }
        }
       else if(sObjectType == System.Label.BST_Contact) //Check the type of record
        {
            for(Sobject sObjct : recList)
            {
               sObjct.put('DP_IND_STATUS__c',System.Label.BST_Valid);
               sObjct.put('DP_IND_STATE__c',System.Label.BST_Active);
            }
            
        }*/
        if(sObjectType == System.Label.BST_AccountContactRelation && !profileName.contains(System.Label.BST_Integration_Administrator))//Check the type of record
        {
            date mydate = Date.ValueOf(System.Label.BST_Date);
            for(Sobject sObjct : recList)
            {
               sObjct.put('DP_ACT_STATUS__c',System.Label.BST_Valid);
               sObjct.put('DP_ACT_STATE__c',System.Label.BST_Active);
               sObjct.put('StartDate',Date.today());
               sObjct.put('EndDate',mydate ); 
            }   
        }
        else if(sObjectType == System.Label.BST_RelatedAccount && !profileName.contains(System.Label.BST_Integration_Administrator))//Check the type of record
        {
            date mydate = Date.ValueOf(System.Label.BST_Date);
            for(Sobject sObjct : recList)
            {
               sObjct.put('DP_ISACTIVE__c',true);  //Added 17-Aug-17 for JIRA-576
               sObjct.put('DP_START_DATE__c',Date.today());
               sObjct.put('DP_END_DATE__c',mydate );       
            }
        }
        
    }
    
    //(Change made on 17-April by Rashmi)- End
    
    //(Change made on 27-April by Rashmi)- Start
    /*
    public void processActiveUpdate(List<Sobject> recList)
    {
     if(sObjectType == System.Label.BST_RelatedAccount)//Check the type of record
        {
            for(Sobject sObjct : recList)
            {
                   if(Date.ValueOf(sObjct.get('DP_END_DATE__c')) > Date.today() || Date.ValueOf(sObjct.get('DP_END_DATE__c')) == Null)
                   {
                    sObjct.put('DP_ISACTIVE__c',Boolean.ValueOf('TRUE'));
                   }
              else if(Date.ValueOf(sObjct.get('DP_END_DATE__c')) < Date.today())
                   {
                    sObjct.put('DP_ISACTIVE__c',Boolean.ValueOf('FALSE'));
                   }
            }
        }
    }*/
    //(Change made on 27-April by Rashmi)- End
    
    //Method will populate the relation name, which will be used in the formula field for hyperlink in the UI
    private void populateRelationName()
    {
        if(sObjectType == System.Label.BST_AccountContactRelation)
        {
            for(AccountContactRelation accRel : [SELECT Id, Account.Name, Contact.Name FROM AccountContactRelation WHERE Id IN : lstNewRecordsMap.keySet()])
            {
                relNameMap.put(accRel.Id, accRel.Account.Name + ' > ' + accRel.Contact.Name);
            }
        }
        if(sObjectType == System.Label.BST_RelatedAccount)
        {
            for(Account_Account_Relation__c accRel : [SELECT Id, DP_PARENT_ACCOUNT_ID__r.Name, DP_CHILD_ACCOUNT_ID__r.Name FROM Account_Account_Relation__c WHERE Id IN : lstNewRecordsMap.keySet()])
            {
                relNameMap.put(accRel.Id, accRel.DP_PARENT_ACCOUNT_ID__r.Name + ' > ' + accRel.DP_CHILD_ACCOUNT_ID__r.Name);
            }
        }
        
    }
    
    
    //Method will populate the relation name, which will be used in the formula field for hyperlink in the UI
    public void populateAccountContactRelationCountry(list<AccountContactRelation> lstNewValues)
    {
        set<id> setAccountid = new set<id>();
        map<id,string> mapAccountid2Country= new map<id,string>();
        if(sObjectType == System.Label.BST_AccountContactRelation)
        {
            for(AccountContactRelation accRel :lstNewValues)
            {
                
                setAccountid.add(accRel.Accountid);
            }
        } 
        if(!setAccountid.isEmpty()){       
            for(account acc :[select id,BST_COUNTRY__c from account where id in:setAccountid]){
                mapAccountid2Country.put(acc.id,acc.BST_COUNTRY__c);
            }
            
            if(!mapAccountid2Country.isEmpty()){
                for(AccountContactRelation accRel :lstNewValues)
                {
                    if(mapAccountid2Country.get(accRel.accountid)!=null){
                       accRel.BST_COUNTRY__c=mapAccountid2Country.get(accRel.accountid);     
                     }
                }
                    
            }
            
        }
                    
 
    }
    
    
    //Method will populate the Country
    public void populateAccountAccountRelationCountry(list<ACCOUNT_ACCOUNT_RELATION__c> lstNewValues)
    {
        set<id> setAccountid = new set<id>();
        map<id,string> mapAccountid2Country= new map<id,string>();
        if(sObjectType == System.Label.BST_RelatedAccount)
        {
            for(ACCOUNT_ACCOUNT_RELATION__c accRel :lstNewValues)
            {
                if(accRel.DP_PARENT_ACCOUNT_ID__c!=null){
                  setAccountid.add(accRel.DP_PARENT_ACCOUNT_ID__c);
                }
            }
        } 
        if(!setAccountid.isEmpty()){       
            for(account acc :[select id,BST_COUNTRY__c from account where id in:setAccountid]){
                mapAccountid2Country.put(acc.id,acc.BST_COUNTRY__c);
            }
            
            if(!mapAccountid2Country.isEmpty()){
                for(ACCOUNT_ACCOUNT_RELATION__c  accRel :lstNewValues)
                {
                    if(mapAccountid2Country.get(accRel.DP_PARENT_ACCOUNT_ID__c)!=null){
                       accRel.BST_COUNTRY__c=mapAccountid2Country.get(accRel.DP_PARENT_ACCOUNT_ID__c);     
                     }
                }
                    
            }
            
        }
                    
 
    }
}