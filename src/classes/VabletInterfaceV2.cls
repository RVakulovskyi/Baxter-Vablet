@RestResource(urlMapping = '/VabletInterfaceV2/*')
global with sharing class VabletInterfaceV2 {
	static final String SETTINGSNAME = 'VabletInterfaceV2';
	static VabletFieldSettings__c vabletSettings = VabletFieldSettings__c.getInstance(SETTINGSNAME);

    global static void getSalesForceDisplayMapping(Map <String, String> params) {
        List <Object> returnData = new List <Object> ();
        //first argument is database key, second display name, third is type, fourth is value list if applicable
        //will be displayed in the app in order
        returnData.add(new VabletFieldMapItem('WhoId', 'Primary Contact', 'contact', new List < VabletPicklistMapItem > (), '')); //Default contact not supported, Special field
        if (params.get(vabletSettings.TextConstant1__c) != null && params.get(vabletSettings.TextConstant1__c) == 'true') {
            returnData.add(new VabletFieldMapItem(vabletSettings.TextFormat1__c, vabletSettings.TextFormat2__c, vabletSettings.TextConstant14__c, new List < VabletPicklistMapItem > (), '')); //Secondary contacts, Special field
        }
        returnData.add(new VabletFieldMapItem('StartDateTime', 'Start Date', vabletSettings.Type1__c, new List < VabletPicklistMapItem > (), '')); //On new events, times are generated default is ignored
        returnData.add(new VabletFieldMapItem('EndDateTime', 'End Date', vabletSettings.Type1__c, new List < VabletPicklistMapItem > (), '')); //On new events, times are generated default is ignored
        returnData.add(new VabletFieldMapItem('Subject', 'Subject', vabletSettings.Type2__c, new List < VabletPicklistMapItem > (), ''));
        returnData.add(new VabletFieldMapItem('Description', 'Description', vabletSettings.Type2__c, new List < VabletPicklistMapItem > (), ''));
        returnData.add(new VabletFieldMapItem('Location', 'Location', vabletSettings.Type2__c, new List < VabletPicklistMapItem > (), ''));
        List < VabletPicklistMapItem > showAsPicklistValues = VabletInterfaceV2.getVabletPicklistValuesFromString('Event', 'ShowAs');
        //picklist example, note that first picklist item is default for new event creation for invalid defaults or no set default
        /* returnData.add(new VabletFieldMapItem ('ShowAs','Show Time As','picklist',
                                              new List<VabletPicklistMapItem> {
                                                  new VabletPicklistMapItem('Busy','Busy'),
                                                  new VabletPicklistMapItem('Out Of Office','OutOfOffice'),
                                                  new VabletPicklistMapItem('Free Time','Free')
                                                      },''));*/
        returnData.add(new VabletFieldMapItem('ShowAs', 'Show Time As', vabletSettings.Type3__c, showAsPicklistValues, ''));
        List <VabletPicklistMapItem> whatIdAccountSource = new List <VabletPicklistMapItem> ();
        List <Account> sampleAccounts = [SELECT Id, Name FROM Account WHERE Name != null LIMIT 25999];
        for (Account currentAccount: sampleAccounts) {
            whatIdAccountSource.add(new VabletPicklistMapItem(currentAccount.Name, currentAccount.Id));
        }
        List <VabletPicklistMapItem> whatIdOpportunitySource = new List <VabletPicklistMapItem> ();
        List < Opportunity > sampleOpportunities = [SELECT Id, Name FROM Opportunity WHERE Name != null LIMIT 25999];
        for (Opportunity currentOpportunity: sampleOpportunities) {
            whatIdOpportunitySource.add(new VabletPicklistMapItem(currentOpportunity.Name, currentOpportunity.Id));
        } 
        MultiSourceSelect sourceSelectExample= new MultiSourceSelect('Account Or Opportunity');
        sourceSelectExample.addSource(new MultiSourceSelectItem('Account',new VabletFieldMapItem('WhatId', 'ExternalEvent', vabletSettings.Type3__c, whatIdAccountSource, '')));
        sourceSelectExample.addSource(new MultiSourceSelectItem('Opportunity',new VabletFieldMapItem('WhatId', 'Opportunity', vabletSettings.Type3__c, whatIdOpportunitySource, '')));
        returnData.add(sourceSelectExample.getVabletFieldMapItem());
        //returnData.add(new VabletFieldMapItem('WhatId', 'ExternalEvent', 'picklist',
        //whatIdExample, ''));
       /* MultiLevelPicklist multiLevelExample = new MultiLevelPicklist();
        //Start from the top picklist arguments are title, object name, field name
        multiLevelExample.addPickListLevel('Topic Discussed 1','Event', 'Topic_Discussed_1__c');
        multiLevelExample.addPickListLevel('Message 1', 'Event', 'Message_1__c');
        multiLevelExample.addPickListLevel('Resource 1', 'Event', 'Resource_1__c');
        returnData.add(multiLevelExample.getVabletFieldMapItem());*/
        /*Default must be a picklist item for picklists, otherwise 
         * the first object is used */
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant2__c);
        generator.writeObject(returnData);
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    public static List <VabletPicklistMapItem> getVabletPicklistValuesFromString(String ObjectApi_name, String Field_name) {
        List <VabletPicklistMapItem> lstPickvals = new List <VabletPicklistMapItem> ();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name); //From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map <String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List <Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a: pick_list_values) { //for all values in the picklist list
            lstPickvals.add(new VabletPicklistMapItem(a.getLabel(), a.getValue()));
        }
        return lstPickvals;
    }

    @HttpPost
    global static void handlePost(String jsonData) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String URI = req.requestURI;
		System.debug(URI);
        String[] uriComponents = URI.split(vabletSettings.Separator1__c);
        String actionString = '';
        if (uriComponents.size() >= 3) {
            actionString = uriComponents[2];
        }
        if (actionString == vabletSettings.TextFormat3__c) {
            actionString = uriComponents[4];
        }
        if (actionString == null) {
            actionString = '';
        }
        //System.Type mapClass= (Map <String,Object>).class;
        if (actionString.compareTo(vabletSettings.TextFormat4__c) == 0 || actionString.compareTo(vabletSettings.TextFormat5__c) == 0) {
            createOrModifyEvent((Map <String, Object> ) JSON.deserializeUntyped(jsonData));
        }
    }

    global static void createOrModifyEvent(Map <String, Object> parameters) {
        sObject sObj = Schema.getGlobalDescribe().get('Event').newSObject();
        DescribeSObjectResult sObjectResult = sObj.getSObjectType().getDescribe();
        Map <String, SObjectField> fieldMap = sObjectResult.fields.getMap();
        String debugString = '';
        String nonBlockingErrorMessage = null;
        for (String parameterName: parameters.keySet()) {
            if (parameterName == vabletSettings.TextFormat1__c) {
                continue;
            }
            /* if (parameterName=='RecordType')
            {
                String recordTypeName=(String)parameters.get(parameterName);
                
                List<RecordType> recordTypesWithName=[Select Id from RecordType where Name=:recordTypeName order by LastModifiedDate DESC];
                
                if (recordTypesWithName!=null && recordTypesWithName.size()>0)
                {
                    RecordType typeForName=recordTypesWithName.get(0);                              
                    sObj.put('RecordTypeId' , typeForName.Id);    
                }
                
                continue;
            }*/
            if (fieldMap.get(parameterName) == null) {
                continue;
            }
            if (fieldMap.get(parameterName).getDescribe() == null) {
                sObj.put(parameterName, parameters.get(parameterName));
                continue;
            }
            if (fieldMap.get(parameterName).getDescribe().getType() == null) {
                sObj.put(parameterName, parameters.get(parameterName));
                continue;
            }
            if (fieldMap.get(parameterName).getDescribe().getType() == Schema.DisplayType.DATETIME) {
                String dateString = (String) parameters.get(parameterName);
                DateTime dateArgument = (DateTime) JSON.deserialize('"' + dateString + '"', DateTime.class);
                sObj.put(parameterName, (DateTime) dateArgument);
            } else {
                sObj.put(parameterName, parameters.get(parameterName));
            }
            System.debug('field name is ' + parameterName);
        }
		System.debug(parameters);
        List <Object> contactIds = (List <Object> ) parameters.get(vabletSettings.TextFormat1__c);
        if (parameters.get('Id') != null) {
            update sObj;
            if (contactIds != null) {
                String eventId = (String) parameters.get('Id');
                List <EventRelation> relations = [SELECT Id FROM EventRelation WHERE EventId = :eventId];
                for (EventRelation relation: relations) {
                    delete relation;
                }
            }
        } else {
            upsert sObj;
        }
        if (contactIds != null) {
            for (Object contactId: contactIds) {
                EventRelation relation = new EventRelation();
                relation.EventId = (Id) sObj.get('Id');
                relation.RelationId = (Id) contactId;
                relation.Status = vabletSettings.TextConstant11__c;
                if (relation.EventId != null && relation.RelationId != null) {
                    try {
                        upsert relation;
                    } catch (Exception e) {
                        nonBlockingErrorMessage = e.getMessage();
                    }
                }
            }
        }
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant13__c);
        generator.writeObject(sObj);
        if (nonBlockingErrorMessage != null) {
            generator.writeFieldName(vabletSettings.TextConstant3__c);
            generator.writeObject(nonBlockingErrorMessage);
        }
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    @HttpGet
    global static void handleGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String URI = req.requestURI;
        String[] uriComponents = URI.split(vabletSettings.Separator1__c);
        String actionString = '';
        if (uriComponents.size() >= 3) {
            actionString = uriComponents[2];
        }
        if (actionString == vabletSettings.TextFormat3__c) {
            actionString = uriComponents[4];
        }
        if (actionString == null) {
            actionString = '';
        }
        if (actionString.compareTo(vabletSettings.TextConstant4__c) == 0) {
            getEvents(req.params);
        }
        if (actionString.compareTo(vabletSettings.TextConstant5__c) == 0) {
            getMediaViews(req.params);
        }
        if (actionString.compareTo(vabletSettings.TextConstant6__c) == 0) {
            getContacts(req.params);
        }
        if (actionString.compareTo(vabletSettings.TextConstant7__c) == 0) {
            getContactFormatString();
        }
        if (actionString.compareTo(vabletSettings.TextConstant8__c) == 0) {
            getSalesForceDisplayMapping(req.params);
        }
    }

    global static void getContacts(Map <String, String> params) {
        List <CustomContact> ContactData = CustomContact.getContacts(params.get(vabletSettings.TextConstant12__c));
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant14__c);
        generator.writeObject(ContactData);
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
        //Minimal records for return are Id, Phone,Email,FirstName,LastName,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet, and CompanyName
    }

    global static void getContactFormatString() {
        /*
         * Format <x> where x equals attribute name in getContacts call
         *  << and >> escape < and > respectivly.
         */

        //String contactFormatString = '<LastName>, <FirstName> \n <<<email>>> <CompanyName> <MajorSpecialty>';
        String contactFormatString = vabletSettings.TextFormat6__c;
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant9__c);
        generator.writeObject(contactFormatString);
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    global static void getEvents(Map < String, String > params) {
        List <Event> events = null;
        String whereClauseIfNeeded = '';
        String eventsAfterDateString = params.get(vabletSettings.TextConstant10__c);
        DateTime eventsAfterDate = null;
        if (eventsAfterDateString != null) {
            try {
                eventsAfterDate = DateTime.parse(eventsAfterDateString); // (DateTime) JSON.deserialize(eventsAfterDateString, DateTime.class);   
            } catch (Exception e) {
                eventsAfterDate = null;
            }
            if (eventsAfterDate == null) {
                try {
                    eventsAfterDate = (DateTime) JSON.deserialize(eventsAfterDateString, DateTime.class);
                } catch (Exception e) {

                }
            }
        }
        whereClauseIfNeeded = ' where ';
        //' OwnerId = \'' + UserInfo.getUserId() + '\'
        if (eventsAfterDate != null) {
            whereClauseIfNeeded = whereClauseIfNeeded + 'LastModifiedDate > :eventsAfterDate and ';
        }
        whereClauseIfNeeded = whereClauseIfNeeded + ' OwnerId = \'' + UserInfo.getUserId() + '\'  order by LastModifiedDate DESC  limit 49999  ';
        if (params.get('eventId') != null) {
            String eventId = params.get('eventId');
            //where Id = : eventId
        }
/*
        multiLevelExample.addPickListLevel('Topic Discussed 1','Event', 'Topic_Discussed_1__c');
        multiLevelExample.addPickListLevel('Message 1', 'Event', 'Message_1__c');
        multiLevelExample.addPickListLevel('Resource 1', 'Event', 'Resource_1__c');

*/
        events = Database.query(vabletSettings.Query1__c + whereClauseIfNeeded);
        List <Map <String, Object>> eventsWithMeta = new List <Map <String, Object>> ();
        for (Event currentEvent: events) {
            //In subobject in case meta is needed later
            Map < String, Object > eventWithMeta = new Map < String, Object > ();
            Map < String, Object > eventAsMap = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(currentEvent));
            /*   if (currentEvent.RecordType!=null&&currentEvent.RecordType.Name!=null)
            {
                eventAsMap.put('RecordType' , currentEvent.RecordType.Name);  
            }*/
            eventWithMeta.put('eventObject', eventAsMap);
            eventWithMeta.put('Debug', eventsAfterDateString);
            eventsWithMeta.add(eventWithMeta);
        }
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant16__c);
        generator.writeObject(eventsWithMeta);
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    global static void getMediaViews(Map < String, String > params) {
        List <Media_View__c> mediaViews = null;
        if (params.get('eventId') != null) {
            String eventId = params.get('eventId');
            mediaViews = [SELECT Name, Contact__c, Duration__c, Event_ID__c, Event_Link__c, File_ID__c, File_Name__c, PageNumber__c, Start_Time__c FROM Media_View__c WHERE Event_ID__c = :eventId];
        } else {
            mediaViews = [SELECT Name, Contact__c, Duration__c, Event_ID__c, Event_Link__c, File_ID__c, File_Name__c, PageNumber__c, Start_Time__c FROM Media_View__c];
        }
        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName(vabletSettings.TextConstant15__c);
        generator.writeObject(mediaViews);
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }
}