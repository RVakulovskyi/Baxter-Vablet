/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class dm_encodeTriggersTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Lead newLead = new Lead();
        newLead.FirstName = 'Mal';
        newLead.lastName = 'Reynolds';
        newLead.Company = 'Serenity Inc';
        insert newLead;
        system.assert(newLead.id != null, 'Insert didnt take, no id found');
        newLead.firstName = 'Captain Mal';
        newLead.Lastname = 'Freakin Reynolds';
        newLead.company = 'Firefly';
        update newLead;
        
        
        Account newAcct = new Account(); // Modified by - Akshay 12/02/2016
        newAcct.name = 'Serenity Inc';
        newAcct.BST_Country__c = 'Belgium';
        newAcct.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IMS Account').getRecordTypeId(); 
        newAcct.billingStreet = 'Test 123'; 
        newAcct.billingState = 'Test State';
        newAcct.billingCountry = 'Test Country';
        newAcct.billingCity = 'Test City';
        newAcct.billingPostalCode = '1111';
        insert newAcct;
        system.assert(newLead.id != null, 'Insert didnt take, no id found');
        newAcct.name = 'Firefly';
        update newAcct;
        
        
        Contact newCnct = new Contact();  // Modified by - Akshay 12/02/2016
        newCnct.Salutation = 'Mr.';
        newCnct.FirstName = 'Mal';
        newCnct.lastName = 'Reynolds';
        newCnct.accountid = newAcct.id;
        newCnct.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IMS Contact').getRecordTypeId();
        newCnct.DP_IND_GENDER__c = 'Male';
        newCnct.DP_IND_STATUS__c = 'Valid';
        newCnct.DP_IND_STATE__c = 'Active';
        newCnct.DP_IND_PROFESSIONAL_TYPE__c = 'Nurse'; 
        newCnct.DP_IND_SPEC_1__c = 'Student';
        newCnct.BST_COUNTRY__c = 'Belgium';
        insert newCnct;
        system.assert(newLead.id != null, 'Insert didnt take, no id found');
        newCnct.Firstname = 'Captain Mal';
        newCnct.Lastname = 'Freakin Reynolds';
        update newCnct;
        
    }
}