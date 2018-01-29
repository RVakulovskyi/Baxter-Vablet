/***********************************************************************************************
Apex Class Name - EventDefaultValidationsTest 
* Rodion Vakulovskyi	  19/01/2018		   modifying class
************************************************************************************************/
@isTest
public class EventDefaultValidationsTest {
	
	public static testmethod void testEventDefaultCreation() {
		Event testEvent = createTestData();
		insert testEvent;
		Integer sizeOfRecords = [SELECT Id FROM Event].size();
		System.assertEquals(1, sizeOfRecords, 'Size of list should be : '+sizeOfRecords);
	}

	public static testmethod void testEventDefaultCreationException() {
		Event testEvent = createTestData();
		String exceptionText = '';
		insert testEvent;
		try{
			EventDefaultValidations.flagForProcessing = true;
			testEvent.Description = 'Default';
			update testEvent;
		} catch (Exception ex) {
			exceptionText = ex.getMessage();
		}
		System.assert(exceptionText.contains(Label.BXT_Default_value_error), 'Exception should contain defaulting error');
	}

	private static Event createTestData() {
		Case testRecord = new Case();
		insert testRecord;
		Contact testContact = new Contact(LastName = 'testLastName', BST_COUNTRY__c = 'Belgium', FirstName = 'testFirstName', Salutation = 'Mr.');
		insert testContact;
		Event testEvent = new Event(
									DurationInMinutes = 1, 
									ActivityDateTime = Datetime.now(),
									BST_BAX_SALES_TEAM__c='Bax Company/Services', 
									BST_MAIN_TOPIC__c = 'Advanced Logistics Services', 
									WhoId = testContact.Id, 
									BST_COUNTRY__c = 'Belgium', 
									WhatId = testRecord.Id, 
									BST_BEST_OUTCOME__c = 'sssss', 
									BST_CALL_OBJ__c = 'Test', 
									BST_MIN_OUTCOME__c = 'Test'
									);
		return testEvent;
	}
}