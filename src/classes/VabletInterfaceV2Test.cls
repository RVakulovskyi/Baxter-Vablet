/***********************************************************************************************
Apex Class Name - VabletInterfaceV2Test 
* Rodion Vakulovskyi      04/01/2018           modifying class
* Rodion Vakulovskyi      19/01/2018           modifying class
* Rodion Vakulovskyi      24/01/2018           modifying class
************************************************************************************************/
@isTest
public class VabletInterfaceV2Test {
    
    static testmethod void testBelgium() {
        User testUser = createUsersForCountry('Belgium');
        createContact('Belgium');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('Belgium');
        }
    }

    static testmethod void testFrance() {
        User testUser = createUsersForCountry('France');
        createContact('France');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('France');
        }
    }

    static testmethod void testCanada() {
        User testUser = createUsersForCountry('Canada');
        createContact('Canada');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('Canada');
        }
    }

    static testmethod void testDomCom() {
        User testUser = createUsersForCountry('Dom Com');
        createContact('Dom Com');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('Dom Com');
        }
    }

    static testmethod void testNetherlands() {
        User testUser = createUsersForCountry('Netherlands');
        createContact('Netherlands');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('Netherlands');
        }
    }

    static testmethod void testTurkey() {
        User testUser = createUsersForCountry('Turkey');
        createContact('Turkey');
        System.runAs(testUser){
            VabletInterfaceV2Mainmethod('Turkey');
        }
    }
    static testMethod void VabletInterfaceV4() {
        VabletTestUtility.createCustomSettings(); 
        List<VabletPicklistMapItem> testList = new List<VabletPicklistMapItem>();
        VabletPicklistMapItem vm = new VabletPicklistMapItem('test', 'test1', testList );
        VabletPicklistMapItem vm2 = new VabletPicklistMapItem('test', 'test1');
        
    }

    private static void VabletInterfaceV2Mainmethod(String country) {
        VabletTestUtility.createCustomSettings();

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
        insContact.FirstName = 'ContactFName'+country;
        insContact.LastName = 'ContactLName'+country;
        insContact.Department__c = 'CCU';
        insContact.Job_Title__c = 'Buyer';
        insContact.Phone = '0123456975';
        insContact.BST_COUNTRY__c = country;
        insContact.Salutation = 'Mr.';
        //contSList.add(insContact);
        insert insContact;
        Contact insContact2 = [SELECT Id FROM Contact WHERE BST_COUNTRY__c = :country];
        
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
        VabletInterfaceV2.handlePost('{"Subject":"No Subject","StartDateTime":"2014-06-02T19:28:00.000Z","Location":"","EndDateTime":"2014-06-02T19:28:00.000Z","ShowAs":"Busy","Description":"ewrwewer", "BST_BEST_OUTCOME__c" : "Test", "BST_CALL_OBJ__c" : "Test", "BST_BAX_SALES_TEAM__c" : "Bax Company/Services", "BST_MAIN_TOPIC__c" : "Advanced Logistics Services", "BST_COUNTRY__c" : "'+country+'", "BST_MIN_OUTCOME__c" : "Test", "WhoId" : "'+insContact.Id+'", "WhatId" : "'+testRecord.Id+'", "BST_CALL_NOTES__c" : "asdsad", "SecondaryContacts" : ["'+insContact2.Id+'"]}"');        

        System.debug(RestContext.response.responseBody.toString());
        System.assertEquals(true, RestContext.response.responseBody.toString().containsIgnoreCase('createdEvent'));  

    }

    private static User createUsersForCountry(String country) {
            Profile testProfile = [SELECT Id FROM Profile WHERE Name='BOOST – Sales Representative']; 
            User testUser = new User(Alias = 'standt', Email='standarduser'+country.deleteWhitespace()+'@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = testProfile.Id, BST_MAIN_BAXTER_TEAM__c = 'Bax Company/Services',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+country.deleteWhitespace()+'@testorg.com', BST_COUNTRY__c = country);
        return testUser;
    }
    
    private static void createContact(String country) {
        Contact insContact = new Contact();
        insContact.FirstName = country;
        insContact.LastName = country;
        insContact.Department__c = country;
        insContact.Job_Title__c = country;
        insContact.Phone = '01234569751';
        insContact.BST_COUNTRY__c = country;
        insContact.Salutation = 'Mr.';
        insert insContact;
    }
    
   
}