/********************************************************************************
Apex Class Name - SurveyTargetHelper 
Version - 1.0
Created Date - September 09, 2017
Description - Trigger Handler class for Survey Target.

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     07/21/2017           Original Version
********************************************************************************/
public class SurveyTargetHelper {
    
    /*
    * Static variable to hold the Survey Configuration
    */ 
    public static Map<String, String> getSurveyConfiguration{ 
        get{ 
            if(getSurveyConfiguration == NULL) {
                Map<String, String> surveyConfigMap = new Map<String, String>();     
                List<Survey_Configuration__mdt> surveyConfigs = [SELECT value__c, developerName, category__c
                                                                FROM Survey_Configuration__mdt];
        
                for(Survey_Configuration__mdt sc : surveyConfigs){                  
                    surveyConfigMap.put(sc.developerName, sc.value__c);
                }
                return surveyConfigMap;
            }else{
                return getSurveyConfiguration;
            }
        }
        private set{}
    }

    /**
    * Method Name: createNPSSurvey
    * Description: Create NPS Survey from Event
    * Parameter:   List<SurveyTargetWrapper>
    * Return Type: void
    */ 
    public static void createNPSSurvey(list<SurveyTargetWrapper> stwList){
        
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB SurveyTargetHelper/createNPSSurvey');
        
        list<Survey_Target__c> surveyInsertList = new list<Survey_Target__c>();
        map<Id, Id> surveyTerritoryMap = new map<Id, Id>();  
        map<String, Id> territoryIdNameMap = new map<String, Id>(); 
        
        for(SurveyTargetWrapper swt : stwList){             
            Survey_Target__c survey = new Survey_Target__c();
            survey.Account__c = swt.account;
            survey.Contact__c = swt.contact;
            survey.Contact_Email__c = swt.contactEmail;
            survey.Survey_Type__c = swt.surveyType;
            survey.OwnerId = swt.ownerId;
            survey.Territory__c  = swt.territoryTBM;
            survey.Territory_Up_Level1__c = swt.territoryRBM;
            survey.Territory_Up_Level2__c = swt.territoryAVP;
            survey.Territory_Business_Manager__c = swt.userTBM;
            survey.Regional_Business_Manager__c = swt.userRBM;
            survey.Area_Vice_President__c = swt.userAVP;
            survey.Sales_Group__c = swt.salesGroup;
            survey.RecordTypeId = swt.recordType;
            survey.Source_Record_Id__c = swt.sourceRecordId;
            survey.Event_Type__c = swt.eventType;
            survey.Event_Created_by_Alias__c = swt.eventOwnerBaxterAlias;
            survey.Event_Created_Date__c = swt.eventCreatedDate;  
            territoryIdNameMap.put(swt.territoryTBM, swt.territoryIdTBM);
            surveyInsertList.add(survey);
        }
        system.debug('territoryIdNameMap::::' + territoryIdNameMap);
        if(surveyInsertList.size() >0){
            insert surveyInsertList;
            system.debug('surveyInsertList::::' + surveyInsertList);
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB SurveyTargetHelper/createNPSSurvey -> Insert survey(s)');
            for(survey_Target__c st : surveyInsertList){
                surveyTerritoryMap.put(st.Id, territoryIdNameMap.get(st.Territory__c));             
            }
            if(surveyTerritoryMap.size() > 0)
                shareSurveyTBMTerritory(surveyTerritoryMap);
        }
    }

    /**
    * Method Name: filterNonEligibleContacts
    * Description: Filter out Non eligible contacts
    * Parameter:   Map<Id,String>
    * Return Type: void
    */ 
    public static Map<Id,String> filterNonEligibleContacts(set<Id> contactIdList){
        
        map<Id,String> contactEmailMap = new map<Id,String>();      
        set<String> contactEmailRemove = new set<String>(); 
        
        //for contacts related to event, get contact email ids
        List<Contact> contactList = [SELECT id, email 
                                     FROM Contact 
                                     WHERE id IN :contactIdList
                                     AND email != NULL AND HasOptedOutOfEmail = false];
        for(Contact con : contactList){
            contactEmailMap.put(con.id, con.email.toLowerCase());
        }    
        System.debug('contactListt--: '+contactList);
        //get already sent surveys data for contact email; to filter out OptOuts & survey sent in last 120 days         
        List<Survey_Target__c> stList = [SELECT id,contact__c, contact_email__c, opt_out__c, days_since_survey_sent__c 
                                        FROM Survey_Target__c
                                        WHERE Contact_Email__c IN :  contactEmailMap.values()
                                        Order By Survey_Sent_Date__c DESC]; 
        for(Survey_Target__c st : stList){
            set<String> contactEmail = new set<String>();           
            if((!contactEmail.contains(st.contact_email__c)) && (st.days_since_survey_sent__c < Integer.valueof(getSurveyConfiguration.get('NPS_Cooling_Period')) 
                || st.opt_out__c == TRUE)){
                    contactEmailRemove.add(st.contact_email__c);
            }           
            contactEmail.add(st.contact_email__c);
        }
        if(contactEmailRemove.size() > 0){
            for(Id contactId : contactEmailMap.keySet()){
                if(contactEmailRemove.contains(contactEmailMap.get(contactId))){
                    contactEmailMap.remove(contactId);
                }
            }
        }
        System.debug('contactEmailMap--: '+contactEmailMap);
        return contactEmailMap;
    }

    /**
    * Method Name: shareSurveyTBMTerritory
    * Description: Share survey with TBM Territory
    * Parameter:   Map<Id,String>
    * Return Type: void
    */ 
    public static void shareSurveyTBMTerritory(Map<Id,Id> surveyTerritoryMap){    
        
        system.debug('surveyTerritoryMap::::' + surveyTerritoryMap);
        delete [SELECT id FROM Survey_Target__share 
                WHERE parentid IN : surveyTerritoryMap.keySet()
                AND RowCause ='Manual'];        
        
        list<Survey_Target__share> shareList = new list<Survey_Target__share>();
        map<id,id> groupTerrMap = new map<id,id>();
        List<Group> groupList = [SELECT id, relatedid FROM Group
                                WHERE relatedid IN :  surveyTerritoryMap.values()
                                AND type ='Territory']; 
        for(Group grp : groupList){         
            groupTerrMap.put(grp.relatedid, grp.id);
        }
        system.debug('groupTerrMap::::' + groupTerrMap);
        for(Id surveyId : surveyTerritoryMap.keySet()){     
            if(surveyTerritoryMap.get(surveyId) != NULL){   
                Survey_Target__share surveyShare = new Survey_Target__share();
                surveyShare.ParentId = surveyId;
                surveyShare.UserorGroupId = groupTerrMap.get(surveyTerritoryMap.get(surveyId));
                surveyShare.AccessLevel = 'Edit';
                shareList.add(surveyShare);
            }
        }   
        if(shareList.size() >0){
            insert shareList;   
        }
    
    }

    /**
    * Method Name: getRecordType
    * Description: get survey record type using salesgroup
    * Parameter:   String SalesGrouo
    * Return Type: Id
    */ 
    public static Id getRecordType(String salesGroup){  
        Id recordTypeId;
        if(Label.Group_ACC.contains(salesGroup) || Label.Group_USMD.contains(salesGroup)){
            recordTypeId = Schema.SObjectType.Survey_Target__c.getRecordTypeInfosByName().get('USHP').getRecordTypeId();
        }
        else if(Label.Group_Renal.contains(salesGroup)){
            recordTypeId = Schema.SObjectType.Survey_Target__c.getRecordTypeInfosByName().get('Renal').getRecordTypeId();
        } 
        else if(Label.Group_BioSurgery.contains(salesGroup)){
            recordTypeId = Schema.SObjectType.Survey_Target__c.getRecordTypeInfosByName().get('Advanced Surgery').getRecordTypeId();
        }
        system.debug('recordTypeId---Ruchika'+recordTypeId);
        return recordTypeId;
    }
    
    /**
    * Method Name: closeDetractorTask
    * Description: On root cause update on Survey, Close the Detractor Task
    * Parameter:   List<Id> surveyTargetIds
    * Return Type: void
    */ 
    public static void closeDetractorTask(list<Id> surveyTargetIds){
        List<Task> listTask = new List<Task>();
        for(Task updateTask: [SELECT id, status FROM Task 
                                WHERE Status != 'Completed' 
                                AND Type = 'NPS Detractor Management'
                                AND survey_target__c IN :surveyTargetIds]){
            updateTask.status ='Completed';
            listTask.add(updateTask);
        }
        if(listTask.size() >0)
            update listTask;
    }
    
    /**
    * Method Name: updateDetractorTaskStatus
    * Description: On comment update on Survey, update status of Detractor Task
    * Parameter:   List<Id> surveyTargetIds
    * Return Type: void
    */ 
    public static void updateDetractorTaskStatus(list<Id> surveyTargetIds){
        List<Task> listTask = new List<Task>();
        for(Task updateTask: [SELECT id, status FROM Task 
                                WHERE Status = 'Not Started' 
                                AND Type = 'NPS Detractor Management'
                                AND survey_target__c IN :surveyTargetIds]){
            updateTask.status ='In Progress';
            listTask.add(updateTask);
        }
        if(listTask.size() >0)
            update listTask;
    }

    /**
    * Method Name: optoutInQualtrics
    * Description: To optout recipient in Qualtrics
    * Parameter:   List<String> recipientIds
    * Return Type: void
    */ 
    @future(callout=true)
    public static void optoutInQualtrics(map<String,String> recipientIds){
        List<String> errorList = new List<String>();        
        for(string recipientId : recipientIds.keySet()){            
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(SurveyTargetHelper.getSurveyConfiguration.get('Endpoint_Contact_Update') + recipientId);
                request.setMethod(SurveyTargetHelper.getSurveyConfiguration.get('Method_Contact_Update'));
                List<String> headerList = SurveyTargetHelper.getSurveyConfiguration.get('Header_Contact_Update').split(';');
                for(String headerInfo : headerList){
                    List<String> header = headerInfo.split(':');
                    request.setHeader(header[0], header[1]);
                }
                // Set the body as a JSON object
                request.setBody(SurveyTargetHelper.getSurveyConfiguration.get('Body_Contact_Update'));
            try{
                HttpResponse response = http.send(request);
                if (response.getStatusCode() != 200 ) {
                    throw new CustomException('<tr><td>' + recipientId + '</td><td>' + recipientIds.get(recipientId) + '</td><td>' + response.getStatusCode() + ' ' + response.getStatus() + ' ' + response.getBody() +'</td><tr>');
                } 
            }
            catch(CalloutException ex){
                throw new CustomException('<tr><td>' + recipientId + '</td><td>Recipient Email: ' + recipientIds.get(recipientId) + '</td><td>' + ex.getMessage() + ' ' + ex.getStackTraceString() +'</td><tr>');
            }
            catch(Exception ex){
                errorList.add(ex.getMessage());
            }           
        }
        if(errorList.size() > 0){
            string emailBody = '<table border="0"><tr><th>Recipient Id</th><th>Recipient Email</th><th>Error Messsage</th></tr>';
            OrgWideEmailAddress owa =  [SELECT id, Address, DisplayName 
                                        FROM OrgWideEmailAddress 
                                        WHERE DisplayName =: Notification_settings__c.getValues('Renal_settings').FromAddressLable__c 
                                        LIMIT 1];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                   
            mail.setOrgWideEmailAddressId(owa.id);  
            mail.setToAddresses(new String[] {owa.address});   
            mail.saveAsActivity = false;
            mail.setSubject('Survey OptOut Callout Failed : ' + System.now());
            for(String error : errorList){
                emailBody = emailBody + error;
            }
            emailBody = emailBody + '</table>';
            emailBody = emailBody + '<br>Please contact SFA Team to optout these recipients in Qualtrics.'; 
            mail.setHtmlBody(emailBody); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    
    }
}