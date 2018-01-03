@RestResource(urlMapping = '/VabletInterfaceV2/*')
global with sharing class VabletInterfaceV2 {


    global static void getSalesForceDisplayMapping(Map < String, String > params) {
        List < Object > returnData = new List < Object > ();

        //first argument is database key, second display name, third is type, fourth is value list if applicable
        //will be displayed in the app in order
        returnData.add(new VabletFieldMapItem('WhoId', 'Primary Contact', 'contact', new List < VabletPicklistMapItem > (), '')); //Default contact not supported, Special field
        if (params.get('supportsSecondaryContacts') != null && params.get('supportsSecondaryContacts') == 'true') {
            returnData.add(new VabletFieldMapItem('SecondaryContacts', 'Secondary Contacts', 'contacts', new List < VabletPicklistMapItem > (), '')); //Secondary contacts, Special field
        }
        returnData.add(new VabletFieldMapItem('StartDateTime', 'Start Date', 'datetime', new List < VabletPicklistMapItem > (), '')); //On new events, times are generated default is ignored
        returnData.add(new VabletFieldMapItem('EndDateTime', 'End Date', 'datetime', new List < VabletPicklistMapItem > (), '')); //On new events, times are generated default is ignored
        returnData.add(new VabletFieldMapItem('Subject', 'Subject', 'string', new List < VabletPicklistMapItem > (), ''));
        returnData.add(new VabletFieldMapItem('Description', 'Description', 'string', new List < VabletPicklistMapItem > (), ''));
        returnData.add(new VabletFieldMapItem('Location', 'Location', 'string', new List < VabletPicklistMapItem > (), ''));

        list < VabletPicklistMapItem > showAsPicklistValues = VabletInterfaceV2.getVabletPicklistValuesFromString('Event', 'ShowAs');

        //picklist example, note that first picklist item is default for new event creation for invalid defaults or no set default
        /* returnData.add(new VabletFieldMapItem ('ShowAs','Show Time As','picklist',
                                              new List<VabletPicklistMapItem> {
                                                  new VabletPicklistMapItem('Busy','Busy'),
                                                  new VabletPicklistMapItem('Out Of Office','OutOfOffice'),
                                                  new VabletPicklistMapItem('Free Time','Free')
                                                      },''));*/

        returnData.add(new VabletFieldMapItem('ShowAs', 'Show Time As', 'picklist',
        showAsPicklistValues, ''));

        list < VabletPicklistMapItem > whatIdAccountSource = new list < VabletPicklistMapItem > ();

        List < Account > sampleAccounts = [SELECT Id, Name FROM Account where Name != null limit 25999];

        for (Account currentAccount: sampleAccounts) {
            whatIdAccountSource.add(new VabletPicklistMapItem(currentAccount.Name, currentAccount.Id));
        }
    
        
        list < VabletPicklistMapItem > whatIdOpportunitySource = new list < VabletPicklistMapItem > ();

        List < Opportunity > sampleOpportunities = [SELECT Id, Name FROM Opportunity where Name != null limit 25999];

        for (Opportunity currentOpportunity: sampleOpportunities) {
            whatIdOpportunitySource.add(new VabletPicklistMapItem(currentOpportunity.Name, currentOpportunity.Id));
        }
        
        MultiSourceSelect sourceSelectExample= new MultiSourceSelect('Account Or Opportunity');
        sourceSelectExample.addSource(new MultiSourceSelectItem('Account',new VabletFieldMapItem('WhatId', 'ExternalEvent', 'picklist',
        whatIdAccountSource, '')));
        sourceSelectExample.addSource(new MultiSourceSelectItem('Opportunity',new VabletFieldMapItem('WhatId', 'Opportunity', 'picklist',
        whatIdOpportunitySource, '')));
        
        
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
        generator.writeFieldName('mappingValuesInOrder');
        generator.writeObject(returnData);
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    public static List < VabletPicklistMapItem > getVabletPicklistValuesFromString(String ObjectApi_name, String Field_name) {

        List < VabletPicklistMapItem > lstPickvals = new List < VabletPicklistMapItem > ();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name); //From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List < Schema.PicklistEntry > pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
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
        String[] uriComponents = URI.split('\\/');
        String actionString = '';

        if (uriComponents.size() >= 3) {
            actionString = uriComponents[2];
        }

        if (actionString == 'apexrest') {
            actionString = uriComponents[4];
        }

        if (actionString == null) {
            actionString = '';
        }


        //System.Type mapClass= (Map <String,Object>).class;
        if (actionString.compareTo('createEvent') == 0 || actionString.compareTo('updateEvent') == 0) {
            createOrModifyEvent((Map < String, Object > ) JSON.deserializeUntyped(jsonData));
        }

    }

    global static void createOrModifyEvent(Map < String, Object > parameters) {
        sObject sObj = Schema.getGlobalDescribe().get('Event').newSObject();
        DescribeSObjectResult sObjectResult = sObj.getSObjectType().getDescribe();

        Map < String, SObjectField > fieldMap = sObjectResult.fields.getMap();

        String debugString = '';

        String nonBlockingErrorMessage = null;

        for (String parameterName: parameters.keySet()) {

            if (parameterName == 'SecondaryContacts') {
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
        List < Object > contactIds = (List < Object > ) parameters.get('SecondaryContacts');

        if (parameters.get('Id') != null) {
            update sObj;


            if (contactIds != null) {

                String eventId = (String) parameters.get('Id');

                List < EventRelation > relations = [Select Id from EventRelation where EventId = : eventId];

                for (EventRelation relation: relations) {
                    delete relation;
                }
            }

        } else {
            insert sObj;
        }

        if (contactIds != null) {
            for (Object contactId: contactIds) {
                EventRelation relation = new EventRelation();
                relation.EventId = (Id) sObj.get('Id');
                relation.RelationId = (Id) contactId;
                relation.Status = 'Accepted';
                if (relation.EventId != null && relation.RelationId != null) {
                    try {
                        insert relation;
                    } catch (Exception e) {
                        nonBlockingErrorMessage = e.getMessage();
                    }
                }
            }
        }

        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName('createdEvent');
        generator.writeObject(sObj);

        if (nonBlockingErrorMessage != null) {
            generator.writeFieldName('nonBlockingErrorMessage');
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

        String[] uriComponents = URI.split('\\/');
        String actionString = '';
        if (uriComponents.size() >= 3) {
            actionString = uriComponents[2];
        }

        if (actionString == 'apexrest') {
            actionString = uriComponents[4];
        }

        if (actionString == null) {
            actionString = '';
        }

        if (actionString.compareTo('getEvents') == 0) {
            getEvents(req.params);
        }

        if (actionString.compareTo('getMediaViews') == 0) {
            getMediaViews(req.params);
        }

        if (actionString.compareTo('getContacts') == 0) {
            getContacts(req.params);
        }

        if (actionString.compareTo('getContactFormatString') == 0) {
            getContactFormatString();
        }

        if (actionString.compareTo('getSalesForceDisplayMapping') == 0) {
            getSalesForceDisplayMapping(req.params);
        }
    }

    global static void getContacts(Map < String, String > params) {
        List < CustomContact > ContactData = CustomContact.getContacts(params.get('contactsAfterDate'));

        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName('contacts');
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
        String contactFormatString = '<LastName>, <FirstName> \n<email> \n<Phone>';

        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName('contactFormatString');
        generator.writeObject(contactFormatString);
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    global static void getEvents(Map < String, String > params) {
        List < Event > events = null;

        String whereClauseIfNeeded = '';
        String eventsAfterDateString = params.get('modificationDateAfter');
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

        events = Database.query('SELECT Id, WhatId,WhoId,ShowAs, AccountId, Subject, StartDateTime, ReminderDateTime, Description, EndDateTime, Location,(SELECT EventId,Status, RelationId  FROM EventRelations) FROM Event ' + whereClauseIfNeeded);


        List < Map < String, Object >> eventsWithMeta = new List < Map < String, Object >> ();

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
        generator.writeFieldName('events');
        generator.writeObject(eventsWithMeta);
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }

    global static void getMediaViews(Map < String, String > params) {
        List < Media_View__c > mediaViews = null;

        if (params.get('eventId') != null) {
            String eventId = params.get('eventId');
            mediaViews = [SELECT Name, Contact__c, Duration__c, Event_ID__c, Event_Link__c, File_ID__c, File_Name__c, PageNumber__c, Start_Time__c from Media_View__c where Event_ID__c = : eventId];
        } else {
            mediaViews = [SELECT Name, Contact__c, Duration__c, Event_ID__c, Event_Link__c, File_ID__c, File_Name__c, PageNumber__c, Start_Time__c from Media_View__c];
        }

        JSONGenerator generator = JSON.createGenerator(true); //instantiation of the generator
        generator.writeStartObject(); // Writes the starting marker of a JSON object '{'
        generator.writeFieldName('mediaViews');
        generator.writeObject(mediaViews);
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonString);
    }
}