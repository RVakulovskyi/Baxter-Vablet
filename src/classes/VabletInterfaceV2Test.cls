@isTest
public class VabletInterfaceV2Test {
    static testMethod void VabletInterfaceV2() {
        VabletTestUtility.createCustomSettings();
        //Load Trigger Settings from Static Resource
        //List<sObject> ls = Test.loadData(Trigger_Settings__c.sObjectType, 'ApexTestClassDataLoad_TriggerSettings');
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/VabletInterfaceV2/getEvents'; //Request URL
        req.httpMethod = 'GET'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;

        VabletInterfaceV2.handleGet();

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('events'));

        req.requestURI = '/services/apexrest/VabletInterfaceV2/getSalesForceDisplayMapping'; //Request URL
        req.httpMethod = 'GET'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        VabletInterfaceV2.handleGet();

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('mappingValuesInOrder'));

        req.requestURI = '/services/apexrest/VabletInterfaceV2/getMediaViews'; //Request URL
        req.httpMethod = 'GET'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        VabletInterfaceV2.handleGet();

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('mediaViews'));
        
        Account dummyAcc = new Account(name = 'dummy Account',Account_Number__c = '1111111111');
        database.insert(dummyAcc,false);
        System.debug(dummyAcc);
        Contact insContact = new Contact();
        insContact.FirstName = 'ContactFName';
        insContact.LastName = 'ContactLName';
        insContact.Department__c = 'CCU';
        insContact.Job_Title__c = 'Buyer';
        insContact.Phone = '0123456975';
        insContact.status__c = 'Active';
		insContact.BST_COUNTRY__c = 'Belgium';
		insContact.Salutation = 'Mr.';
        //contSList.add(insContact);
        insert insContact;
        Case testRecord = new Case();
		insert testRecord;
        
        req.requestURI = '/services/apexrest/VabletInterfaceV2/getContacts'; //Request URL
        req.httpMethod = 'GET'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        VabletInterfaceV2.handleGet();

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('contacts'));

        req.requestURI = '/services/apexrest/VabletInterfaceV2/getContactFormatString'; //Request URL
        req.httpMethod = 'GET'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        VabletInterfaceV2.handleGet();

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('contactFormatString'));  
        
        req.requestURI = '/services/apexrest/VabletInterfaceV2/createEvent'; //Request URL
        req.httpMethod = 'Post'; //HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;
        VabletInterfaceV2.handlePost('{"Subject":"No Subject","StartDateTime":"2014-06-02T19:28:00.000Z","Location":"","EndDateTime":"2014-06-02T19:28:00.000Z","ShowAs":"Busy","Description":"", "BST_BEST_OUTCOME__c" : "Test", "BST_CALL_OBJ__c" : "Test", "BST_BAX_SALES_TEAM__c" : "Bax Company/Services", "BST_MAIN_TOPIC__c" : "Advanced Logistics Services", "BST_COUNTRY__c" : "Belgium", "BST_MIN_OUTCOME__c" : "Test", "WhoId" : "'+insContact.Id+'", "WhatId" : "'+testRecord.Id+'"}"');

        List<Event> listOfEvents = [SELECT Id FROM Event];
		Integer size = listOfEvents.size();
		System.assertEquals(size, 1,'Only one event should be created');
        

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('createdEvent'));  

    }
    
    static testMethod void VabletInterfaceV4() {
        VabletTestUtility.createCustomSettings(); 
        List<VabletPicklistMapItem> testList = new List<VabletPicklistMapItem>();
        VabletPicklistMapItem vm = new VabletPicklistMapItem('test', 'test1', testList );
        VabletPicklistMapItem vm2 = new VabletPicklistMapItem('test', 'test1');
        
    }
    
   
}