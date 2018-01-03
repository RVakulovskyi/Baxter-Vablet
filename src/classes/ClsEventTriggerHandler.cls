public class ClsEventTriggerHandler{

    public Map<ID,Schema.RecordTypeInfo> rt_Map = Event.sObjectType.getDescribe().getRecordTypeInfosById();//Map to populate Record Type info
    //public String RecTypeName = System.Label.BST_Field_Sales_Call_RecordType; //Fetching the value from custom Label
    //Changes as per Assembla #307 Start
    RecordType rt1 = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType='Event' AND DeveloperName='BST_Pre_Planned_Visit' LIMIT 1];
    Id recTypeId1 = rt1.id;
    RecordType rt2 = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType='Event' AND DeveloperName='BST_Field_Training_Activity' LIMIT 1];
    Id recTypeId2 = rt2.id;
    //Changes as per Assembla #307 End
    
    public List<Event> evtList = new List<Event>();   //Creating a List for saving the Id of record being created
    List<Event> eventList = new List<Event>();
    String recId; //Variable to save RecordTypeId
    Set<Id> evtSet = new Set<Id>(); //Set declared for all the WhoIds
    Map<Id, List<Event>> evntsMap = new Map<Id, List<Event>>();
    private List<User> usr = new List<User>();
  
  //Logic for fetching the Follow up for Next call and populating Notes from Previous call - Added 02/06/2017
    public void updateCallNotes(list<Event> evntList,map<id,Event> oldMap){
       list<Event> lstEvents2Update= new list<Event>();
       list<Event> lstEvents2UpdateNotes= new list<Event>(); //List to store Event Notes
       //Check if the Create/Update action performed by BOOST USER
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;           
        if(profileName.contains(System.Label.BST_BOOST)){
        
         for(Event evnt: evntList){
           if(oldMap.get(evnt.id).whoid!=evnt.whoid){  //Check if the Previous contact is not same as current Contact
               lstEvents2Update.add(evnt);
           }
         }
         if(!lstEvents2Update.isEmpty()){
            for(Event evnt: lstEvents2Update)
              {
            
                if(rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId1 && evnt.WhoId!=null) //Check if the RecordType is correct and ContactId is not null
                {
                
                evtList.add(evnt); //Creating List of Events
                evtSet.Add(evnt.WhoId);
                recId = evnt.recordTypeID;
                }
                
              }  //Query to fetch event details corresponding to ContactId and Recordtype
                 List<Event> newEvnt = [Select Id, BST_FWP_NXT_CALL__c ,WhoId from Event where WhoId in : evtSet and RecordTypeId =: recId ORDER BY LastModifiedDate DESC];
                 List <Event> allEvnt = new List<Event>();    
                     for(Event evt1 : newEvnt) 
                     {          
                        allEvnt.add(evt1);
                        evntsMap.put(evt1.WhoId, allEvnt); //Populate the map with key as ContactId and List of events as Value
                        system.debug('******Value of Map is :******' +evntsMap);
                      }
               
               for(Event evt: lstEvents2Update)
               {
                   system.debug('The size of map is :' +evntsMap.size());
                   if(evntsMap.containsKey(evt.WhoId) && evntsMap.size() > 0)
                   {
                       if(allEvnt.size() > 0){
                           event ev = new event(id=evt.id);
                           if(evntsMap.get(evt.WhoId).size()>1){// We only update the notes from previous call if we have more than one even available for that contact else do nothing
                               ev.BST_NOTS_PREV_CALL__c =evntsMap.get(evt.WhoId)[1].BST_FWP_NXT_CALL__c;//Update the value of Notes from Previous call field
                               lstEvents2UpdateNotes.add(ev);
                           }
                           
                       }
                   }
               }        
               
              if(!lstEvents2UpdateNotes.isEmpty()){
                  //update lstEvents2UpdateNotes;
                  updateEventPrimaryContact(evntList,oldMap,lstEvents2UpdateNotes);
              }    
             else{
                  updateEventPrimaryContact(evntList,oldMap,lstEvents2UpdateNotes);
             }
         }
         
        } 
    }
  //Change End 02/06/2017
    public void insertComment (list<Event> evntList){  //Method used when Event is created
     //Check if the Create/Update action performed by BOOST USER
     Id profileId = userinfo.getProfileId();
     String profileName = [Select Id,Name from Profile where Id=:profileId].Name;          
     if(profileName.contains(System.Label.BST_BOOST)){
     system.debug('The Profile of User is :' +profileName); 
     List<Event> evntToInsert = [Select Id, WhoId, BST_NOTS_PREV_CALL__c, BST_FWP_NXT_CALL__c, RecordTypeID from Event where Id IN: evntList];
      for(Event evnt: evntToInsert)
      {
        system.debug('The value of Contact is :'+evnt.WhoId);
        if(rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId1 && evnt.WhoId!=null) //Check if the RecordType is correct and ContactId is not null
        {
        
        evtList.add(evnt); //Creating List of Events
        evtSet.Add(evnt.WhoId);
        recId = evnt.recordTypeID;
        system.debug('******Value of evtList is :******' +evtList);
        }
        
      }  //Query to fetch event details corresponding to ContactId and Recordtype
         List<Event> newEvnt = [Select Id, BST_FWP_NXT_CALL__c ,WhoId from Event where WhoId in : evtSet and RecordTypeId =: recId ORDER BY LastModifiedDate DESC];
         List <Event> allEvnt = new List<Event>();    
             for(Event evt1 : newEvnt) 
             {          
                allEvnt.add(evt1);
                evntsMap.put(evt1.WhoId, allEvnt); //Populate the map with key as ContactId and List of events as Value
                system.debug('******Value of Map is :******' +evntsMap);
              }
       
       for(Event evt: evtList)
       {
           system.debug('The size of map is :' +evntsMap.size());
           if(evntsMap.containsKey(evt.WhoId) && evntsMap.size() > 0)
           {
               if(allEvnt.size() > 1){
                system.debug('VALUE HERE IS :' +evntsMap.get(evt.WhoId)[1].BST_FWP_NXT_CALL__c);
                evt.BST_NOTS_PREV_CALL__c = evntsMap.get(evt.WhoId)[1].BST_FWP_NXT_CALL__c; //Update the value of Notes from Previous call field
               }            
           }
       } 
       update evntToInsert;
       
     }          
         
   }    
   
    //Change to add Contact name to Event card in calender - 10/12/17(KP)
    public void insertEventPrimaryContact(list<Event> evntListNew){
        list<string> splitEventContact = new list<string>();
        list<Event> currEventNewList = new list<Event>(); 
        map<id,id> newWhoIdMap = new map<id,id>();
        Id  objId;
        string sObjName;
        //Query EventRelation object to get related Contacts - When event is created from Calender.
        for(EventRelation er: [SELECT EventId,Id,RelationId FROM EventRelation where IsWhat = false and EventId in :evntListNew order by LastModifiedDate limit 1]){
            newWhoIdMap.put(er.EventId,er.RelationId);                   
        } 
        for(Event currEvent : evntListNew){
            Event currEventNew = new Event(); 
            currEventNew.Id = currEvent.Id;
            string newWhoId = currEvent.WhoId;  
            if(newWhoId != null){
                if(newWhoId.contains(';')){
                    splitEventContact = newWhoId.split(';');    //Split WhoId if there are multiple contacts for event
                }
                else{
                    splitEventContact.add(currEvent.WhoId);
                }
                objId = splitEventContact[0];                   //Get objectId to check if its related to contact or not
            }
            else{
                objId = newWhoIdMap.get(currEvent.Id);
                splitEventContact.add( newWhoIdMap.get(currEvent.Id));   //If whoId is null get related contatcs from EventRelation map
            }
            if(objId != null){
             	sObjName = objId.getSObjectType().getDescribe().getName();   //Get objectId to check if its related to contact or not
            }	
            if(currEvent.BST_Primary_Contact__c == null && currEvent.WhoId  != null && sObjName == 'Contact'){   //If related WhoId is contact update primary contact field
                currEventNew.BST_Primary_Contact__c = splitEventContact[0];
                system.debug('Primmary Contact' +splitEventContact);
                currEventNewList.add(currEventNew);
            }
        }
        update currEventNewList; 
    }
     //Change to add Contact name to Event card in calender handling update scenario- 10/12/17(KP)
    public void updateEventPrimaryContact(list<Event> evntListNew,Map<Id,Event> evntMapOld,List<Event> CallNotesList){
        list<string> splitOldEventContact = new list<string>();
        list<string> splitEventContact = new list<string>();
        List<Event> currEventNewList = new List<Event>();   
        Set<Id> eventIdSet = new Set<Id>(); 
        Id  newObjId;
        string sObjName;
        
        map<id,id> newWhoIdMap = new map<id,id>();
        //Query EventRelation object to get related Contacts - When event is created from Calender.
        for(EventRelation er: [SELECT EventId,Id,RelationId FROM EventRelation where IsWhat = false and EventId in :evntListNew order by LastModifiedDate limit 1]){
            newWhoIdMap.put(er.EventId,er.RelationId);
        }
        for(Event evtId: CallNotesList) {
            eventIdSet.add(evtId.id);
        }
        for(Event currEvent : evntListNew){
           // system.debug('evntMapOld' +evntMapOld.get(currEvent.Id));
            Event currEventNew = new Event();
            currEventNew.Id = currEvent.Id;
            string oldWhoId = evntMapOld.get(currEvent.Id).WhoId;
            string newWhoId = currEvent.WhoId;
          //  system.debug('currEvent' +currEvent.EventWhoIds);
            if(oldWhoId != null){
                if(oldWhoId.contains(';')){
                    splitOldEventContact = oldWhoId.split(';');     //Split WhoId if there are multiple contacts for event
                }
                else{
                    splitOldEventContact.add(oldWhoId);
                }
            }
            else{
                splitOldEventContact.add(oldWhoId);             
            }
            splitEventContact.add(newWhoIdMap.get(currEvent.Id));       //If whoId is null get related contatcs from EventRelation map
            newObjId = splitEventContact[0];
            if(newObjId != null){
            	sObjName = newObjId.getSObjectType().getDescribe().getName();       //Get objectId to check if its related to contact or not
            }
            
           // system.debug('splitOldEventContact' +splitOldEventContact);
           // system.debug('splitEventContact' +splitEventContact);
            if(splitEventContact[0] != splitOldEventContact[0] && sObjName == 'Contact'){       //If related WhoId is contact update primary contact field and old contact is not equal to new contact
                
                if(eventIdSet.contains(currEvent.id)){
                    for(Event updateEvent:CallNotesList){
                        if(updateEvent.id == currEventNew.id){
                            updateEvent.BST_Primary_Contact__c = splitEventContact[0];  
                        }	
                    }
                }
                else{
                    currEventNew.BST_Primary_Contact__c = splitEventContact[0];
                    CallNotesList.add(currEventNew);
                }
               // system.debug('Primmary Contact' +splitEventContact);
            }
        }
        if(!CallNotesList.isEmpty()){
            update CallNotesList;	
        }
    }
    public void validateValues(list<Event> evntList){
      //Code for Secondary Country and Product category Starts
        //Check if the Create/Update action performed by admin
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        if(!profileName.contains(System.Label.BST_Admin))
        {  
           usr = [SELECT BST_COUNTRY__c,BST_MAIN_BAXTER_TEAM__c,BST_OTHER_BAXTER_TEAM__c,BST_SECONDARY_COUNTRY__c,Id FROM User where Id = : UserInfo.getUserId()];
        }     
    for(Event evnt : evntList){
         if(!usr.isEmpty())
         {
           for(User usr1 : usr)
           {
               ClsApexUtil.countryAndTeamCheck(usr1.BST_COUNTRY__c, evnt.BST_COUNTRY__c, usr1.BST_SECONDARY_COUNTRY__c, evntList);
            
            if(rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId1 || rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId2) 
            //
                if((rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId1 && (((evnt.BST_CALL_TYPE__c == System.Label.BST_Pre_planned_call || evnt.BST_CALL_TYPE__c == System.Label.BST_In_Service) && evnt.BST_STATUS__c == System.Label.BST_Scheduled)  
                 || ((evnt.BST_CALL_TYPE__c == System.Label.BST_Unplanned_call || evnt.BST_CALL_TYPE__c == System.Label.BST_Therapy_Assistance) && evnt.BST_STATUS__c == System.Label.BST_Completed))) 
                 || (rt_map.get(evnt.recordTypeID).getRecordTypeId() == recTypeId2)){
                     if((checkBaxterTeams(usr1,evnt.BST_BAX_SALES_TEAM__c,null)==false) || (checkBaxterTeams(usr1,null,evnt.BST_SEC_PROD_CATH__c)==false)){
                         evnt.addError(System.Label.BST_Baxter_Team_Validation);       
                     }           
                 }
            //
           }
         } 
        }     
    }
    
    public boolean checkBaxterTeams(User currentUser, String eventMainbaxTeam, String eventSecBaxTeam){
        boolean isValid;
        
      if(eventMainbaxTeam!='' && eventMainbaxTeam!=null){
            if(currentUser.BST_MAIN_BAXTER_TEAM__c!=null && eventMainbaxTeam!=null){
                if(currentUser.BST_MAIN_BAXTER_TEAM__c!=eventMainbaxTeam){
                    isValid=false;
                }else{
                     isValid=true;
                   
                }
            }
          if(currentUser.BST_OTHER_BAXTER_TEAM__c!=null && eventMainbaxTeam!=null && isValid==false){
                if(!currentUser.BST_OTHER_BAXTER_TEAM__c.contains(eventMainbaxTeam)){
                    isValid=false;
                }else{
                     isValid=true;
                   
                }
            }
        }
        
        if(eventSecBaxTeam!='' && eventSecBaxTeam!=null){
        if(currentUser.BST_OTHER_BAXTER_TEAM__c!=null && eventSecBaxTeam!=null){
            if(!currentUser.BST_OTHER_BAXTER_TEAM__c.contains(eventSecBaxTeam)){
                isValid=false;
            }else{
                 isValid=true;
               
            }
        }
        if(currentUser.BST_MAIN_BAXTER_TEAM__c!=null && eventSecBaxTeam!=null && isValid==false){
                if(currentUser.BST_MAIN_BAXTER_TEAM__c!=eventSecBaxTeam){
                    isValid=false;
                }else{
                     isValid=true;
                   
                }
            }
        }
        
        
        return isValid;
    }//Code for Secondary Country and Product category Ends
    
    /*
    @params: List<Event> - getting trigger.old and verifying the logged in user details with custom settings
    Description: This methods prevents the unauthorised deletion of events
    LastModifiedDate : Sumitha 17/10/2017
    */
    public void preventCompletedEventDeletion(List<Event> listOfEvents)
    {
        String userCountry = getUserPrimaryCountry();
        String profileName = getCurrentUserProfileName();
        String EventsLbl = Label.BST_No_Delete_Events;
        
        // Allowing Event Deletion as per custom metadata type configuration  - Sumitha (BOOS-873)
        List<BST_Event_Del_Criteria__mdt> eventDelCriteriaList = new List<BST_Event_Del_Criteria__mdt>();
        Set<String> filteredConfigStatus = new Set<String>();
        if(userCountry != '' && userCountry != null){
            // Filtering based on logged in user primary country
            eventDelCriteriaList = [SELECT Id,BST_Event_Status__c,BST_User_Country__c,BST_User_Profile__c FROM BST_Event_Del_Criteria__mdt
                                    where BST_User_Country__c =: userCountry AND BST_User_Profile__c=: profileName AND Allow_Delete__c=: true];
                                    
            if(eventDelCriteriaList != null && !eventDelCriteriaList.isEmpty()){
                for(BST_Event_Del_Criteria__mdt criteriaRec : eventDelCriteriaList){
                    // Logged in user related event status for which deletion is allowed
                    filteredConfigStatus.add(criteriaRec.BST_Event_Status__c); 
                }
            }else{
                // No Matching criteria found related to logged in user
                for(Event evt:listOfEvents){
                    // No provision to delete Events
                    evt.adderror(EventsLbl); 
                }
            }                     
        }else{
            // If there is no primary country for logged in user
            for(Event evt:listOfEvents){
                // No provision to delete Events
                evt.adderror(EventsLbl); 
            }
        }
        if(filteredConfigStatus != null && !filteredConfigStatus.isEmpty()){
            for(Event evt:listOfEvents){
                //If logged in user Custom metadata status doesn't matches with event status - No provision to delete event
                // If logged in user primary country doesnt match with event country - No provision to delete event
                if(!filteredConfigStatus.contains(evt.BST_STATUS__c) || userCountry != evt.BST_COUNTRY__c){
                    evt.adderror(EventsLbl);
                    
                }
            }
        }

    }
    
    public String getCurrentUserProfileName()
    {
        Id profId = UserInfo.getProfileId();
        Profile prof = new Profile();
        String profName = '';
        
        prof = [SELECT Id, Name FROM Profile WHERE Id=:profId LIMIT 1];
        profName = prof.Name;
        
        return profName;
    }
    
    /*
    Method Desc:  This method is used to get logged in user primary country
    Return value: Logged in user primary country is returned in form of string
    */
    public String getUserPrimaryCountry()
    {
        Id currUserId = UserInfo.getUserId();
        User userRec = new User();
        String userCountry = '';
        try{
            userRec = [SELECT Id, Name, BST_COUNTRY__c from User where id=:currUserId LIMIT 1];
            userCountry = userRec.BST_COUNTRY__c;
            return userCountry;
        }catch(exception e){
            system.debug('Exception ++ '+e.getLineNumber());
            return userCountry;
        }
        
    }
    
    /*
    public void eventNotifyBaxterContacts(List<Event> listOfEvents, Boolean eventCanceled, Boolean eventScheduled, Boolean newContactsAdded)
    {
        Set<Id> setOfEvents = new Set<Id>();
        List<Contact> listOfBaxterContacts = new List<Contact>();
        Set<Id> eventContactIds = new Set<Id>();
        String baxterOnly = 'Baxter_Only';
        String targetObjectId = '';
        String eventId = '';
        RecordType recTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =:baxterOnly LIMIT 1];
        
        for(Event evt:listOfEvents)
        {   
            targetObjectId = evt.OwnerId;
            eventId = evt.Id;
            setOfEvents.add(evt.Id);
        }
        List<EventRelation> listOfEventRelation = [SELECT RelationId, EventId, IsWhat FROM EventRelation WHERE IsWhat = false AND EventId IN:setOfEvents];
        
        for(EventRelation evtRel:listOfEventRelation)
        {   
            eventContactIds.add(evtRel.RelationId);
        } 
        listOfBaxterContacts = [SELECT Id, Email, RecordTypeId FROM Contact WHERE Id IN:eventContactIds AND RecordTypeId =:recTypeId.Id];

            
        //Send First email when event is created
        if(!eventCanceled && !eventScheduled && !newContactsAdded)
        {
            String emailSubject = 'Meeting invite';
            String emailBody = 'You have been invited an event';
            EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName='BST_English_New_Event_Notification' LIMIT 1];
                   
            if(!listOfBaxterContacts.isEmpty())
                sendEmails(listOfBaxterContacts, emailSubject, emailBody, emailTemp.Id,targetObjectId,eventId);
        }
        //SEND EMAIL WITH EVENT CANCELATION
        if(eventCanceled)
        {
            String emailSubject = 'Meeting Cancelation';
            String emailBody = 'The Event as been canceled';
            EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName='BST_English_Event_Cancelation' LIMIT 1];
                   
            if(!listOfBaxterContacts.isEmpty())
                sendEmails(listOfBaxterContacts, emailSubject, emailBody, emailTemp.Id,targetObjectId,eventId);
        }
        //SEND EMAIL WITH SCHEDULED EVENT
        if(eventScheduled)
        {
            String emailSubject = 'Meeting Start/End Date was updated';
            String emailBody = 'The Event Start/End Date has been changed. Please check the update!';
            EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName='BST_English_Event_Cancelation' LIMIT 1];
                   
            if(!listOfBaxterContacts.isEmpty())
                sendEmails(listOfBaxterContacts, emailSubject, emailBody, emailTemp.Id,targetObjectId,eventId);
        }
        //SEND EMAIL TO NEW ADDED CONTACTS
        if(newContactsAdded)
        {
            
        }
    }
    
    public void isEventChanged(List<Event> listOfOldEvents, List<Event> listOfNewEvents)
    {
        List<Event> listOfCanceledEvents = new List<Event>();
        List<Event> listOfScheduleUpdateEvents = new List<Event>();
        String eventCanceled = Label.BST_Canceled;
        
        //######## Event Cancelation ########
        for(Event evt:listOfNewEvents)
        {
            if(evt.BST_STATUS__c==eventCanceled)
                listOfCanceledEvents.add(evt);
        }
        
        if(!listOfCanceledEvents.isEmpty())
            eventNotifyBaxterContacts(listOfCanceledEvents, true, false, false);
        //###################################
        
        //######## Event Schedule Update ########
        for(Event evtOld:listOfOldEvents)
        {
            for(Event evtNew:listOfNewEvents)
            {
                if((evtOld.Id == evtNew.Id) && (evtOld.StartDateTime!= evtNew.StartDateTime))
                    listOfScheduleUpdateEvents.add(evtNew);
            }
        }
        
        if(!listOfScheduleUpdateEvents.isEmpty())
            eventNotifyBaxterContacts(listOfScheduleUpdateEvents, false, true, false);
        //########################################
    
    }
    
    public void sendEmails(List<Contact> sendToAddresses, String emailSubject, String emailBody, String templateId, String targetObjId, String whatId)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        
        for(Contact con:sendToAddresses)
        {
            sendTo.add(con.Email);
            mail.setTargetObjectId(targetObjId);
            //mail.setWhatId(whatId);
            mail.setTemplateID(templateId);
            mail.setToAddresses(sendTo);
            mail.setSaveAsActivity(false);
            //mail.setSubject(emailSubject);            
            //mail.setHtmlBody(emailBody);
            mails.add(mail);
            
        }
        Messaging.sendEmail(mails);
        System.debug('###EMAIL SENT!!!###');
        
    }
    */
}