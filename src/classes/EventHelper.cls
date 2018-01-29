//YB 250118:

/********************************************************************************
Apex Class Name - EventHelper
Version - 1.0
Created Date - March 21, 2017
Function - This class is used to for handle Event related functionality.

Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer       03/29/2017           Original Version
* Cognizant Developer       11/24/2017           Added getEventHierarchy method
********************************************************************************/

public class EventHelper {

    /**
    * Method Name: qualifySurveyEvent
    * Description: Qualify Events for NPS Survey
    * Parameter:   Map<Id, Event>, Map<Id, Event>
    * Return Type: Void
    */ 

    @future
    public static void qualifySurveyEvent(List<Id> eventIds){
        
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent');
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent eventIds ' + eventIds);
        
        list<Event> eventList = new list<Event>();
        map<Id, Event> qualifiedEvents = new map<Id, Event>();
        set<Id> eventContactList = new set<Id>();
        set<Id> qualifiedContacts = new set<Id>();
        map<Id,String> contactEmailMap = new map<Id,String>();
        set<Id> accountList = new set<Id>();
        map<Id,String> eventAccountMap = new map<Id,String>();
        map<Id, TerritoryHierarchy> eventHierarchyMap = new map<Id, TerritoryHierarchy>();
        map<Id,String> eventOwnerMap = new map<Id,String>();
        set<String> processedEmails = new set<String>();
        
        
        //get all related contacts from event
        List<EventRelation> erList = [SELECT id, eventid, relationid, event.whatid, 
                                            event.owner_business_unit__c, event.owner_group__c, 
                                            event.owner.profile.name, event.OwnerId, 
                                            event.Owner_Baxter_Alias__c, event.CreatedDate, event.Type
                                        FROM EventRelation 
                                        WHERE iswhat = false 
                                        AND eventid IN :eventIds
                                        AND event.owner_group__c != NULL];
                                        
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList ' + erList);
                                        
        for(EventRelation er : erList){
        	system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList loop 1 ' + erList);
        
            String businessUnit = er.event.owner_business_unit__c;
            if(businessUnit != NULL 
               && SurveyTargetHelper.getSurveyConfiguration.get('NPS_Enabled_Franchisee').contains(businessUnit.toUpperCase())){
                   eventContactList.add(er.relationid);
                   accountList.add(er.event.whatId);            
                   eventAccountMap.put(er.eventid, er.event.whatId + '~' + er.event.owner_group__c);    
                   if(!eventOwnerMap.containsKey(er.eventid))
                       eventOwnerMap.put(er.eventid, er.event.OwnerId + '~' + er.event.owner_group__c + '~' + er.event.owner.profile.name); 
               }        
        }   
           
        system.debug('eventOwnerMap::::' + eventOwnerMap);
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent  eventOwnerMap::::' + eventOwnerMap);
        eventHierarchyMap = TerritoryHierarchyHelper.getUserHierarchy(eventOwnerMap);
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent  eventHierarchyMap::::' + eventHierarchyMap);
        
        //get already sent surveys data for contact email; to filter out OptOuts & survey sent in last XXX days
        contactEmailMap = SurveyTargetHelper.filterNonEligibleContacts(eventContactList);       
        system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent  contactEmailMap::::' + contactEmailMap);
        
        List<SurveyTargetWrapper> stwList = new List<SurveyTargetWrapper>();
        
        for(EventRelation er : erList){
        	system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList loop 2 ' + erList);
        
            string contactEmail = contactEmailMap.get(er.relationid); 
            
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList loop 2 contactEmail ' + contactEmail);
                
            //YB 29/01/18: TODO: As Territories are managed differently in Boost, this part must be modified:           
            /*                
            if(
				eventHierarchyMap.get(er.event.Id) != NULL 
                && (!processedEmails.contains(contactEmail))
                && eventHierarchyMap.get(er.event.Id).TBMcode != NULL
                && contactEmailMap.containsKey(er.relationid)
                )
                */
                
                if(true)
                //YB 29/01/18: TODO: END
                {
                Id recordTypeId = SurveyTargetHelper.getRecordType(er.event.owner_group__c);
                 system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList loop 2 recordTypeId ' + recordTypeId);
           
                if(recordTypeId != NULL){
                	
                	system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent erList loop 2 recordTypeId 2 ' + recordTypeId);
           
                    SurveyTargetWrapper stw = new SurveyTargetWrapper();
                    stw.recordType = recordTypeId;
                    stw.account = er.event.whatid;
                    stw.contact = er.relationid;
                    stw.contactEmail = contactEmailMap.get(er.relationid);
                    stw.surveyType = SurveyTargetHelper.getSurveyConfiguration.get('NPS_Survey_Type');
                    stw.ownerId = SurveyTargetHelper.getSurveyConfiguration.get('NPS_Survey_Owner');
                    //YB 29/01/18
                    /*stw.territoryTBM = eventHierarchyMap.get(er.event.Id).TBMcode;
                    stw.territoryRBM = eventHierarchyMap.get(er.event.Id).RBMcode;
                    stw.territoryAVP = eventHierarchyMap.get(er.event.Id).AVPcode;
                    stw.userTBM = (eventHierarchyMap.get(er.event.Id).TBMuser != NULL?eventHierarchyMap.get(er.event.Id).TBMuser:NULL);
                    stw.userRBM = (eventHierarchyMap.get(er.event.Id).RBMuser != NULL?eventHierarchyMap.get(er.event.Id).RBMuser:NULL);
                    stw.userAVP = (eventHierarchyMap.get(er.event.Id).AVPuser != NULL?eventHierarchyMap.get(er.event.Id).AVPuser:NULL);
                    stw.territoryIdTBM  = eventHierarchyMap.get(er.event.Id).TBMID;
                    stw.territoryIdRBM  = eventHierarchyMap.get(er.event.Id).RBMID;
                    stw.territoryIdAVP  = eventHierarchyMap.get(er.event.Id).AVPID;*/
                    //YB 29/01/18: END
                    stw.salesGroup = er.event.owner_group__c;   
                    stw.sourceRecordId = er.event.Id;
                    stw.eventType = er.event.Type;
                    stw.eventOwnerBaxterAlias = er.event.Owner_Baxter_Alias__c;
                    stw.eventCreatedDate = er.event.createddate;
                    stwList.add(stw);
                    processedEmails.add(contactEmail);
                }
            }       
            
        }
        
        system.debug('stwList::::' + stwList);
        if(stwList.size() > 0){
            SurveyTargetHelper.createNPSSurvey(stwList);
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent -> calling SurveyTargetHelper.createNPSSurvey()');
            system.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB EventHelper/qualifySurveyEvent -> calling SurveyTargetHelper.createNPSSurvey() stwList ' + stwList);
        }
    }
}

//YB 250118: END