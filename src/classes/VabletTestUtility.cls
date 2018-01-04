public class VabletTestUtility {

	public static void createCustomSettings() {
		VabletFieldSettings__c testSettings1 = new VabletFieldSettings__c();
			testSettings1.Name = 'CustomContact';
			testSettings1.TextConstant1__c = '1111111111';
			testSettings1.Query1__c = 'SELECT Account.ID,Account.Account_Number__c,Account.Name,IsDeleted,Id,FirstName,LastName, Name,Email,MailingCity,MailingState,MailingCountry,MailingPostalCode,Phone FROM Contact WHERE Status__c = \'Active\' limit 9999 ALL ROWS';
			insert testSettings1;
		VabletFieldSettings__c testSettings2 = new VabletFieldSettings__c();
			testSettings2.Name = 'VabletTriggerHandler';
			testSettings2.TextConstant1__c = 'PDF';
			testSettings2.TextConstant2__c = '">';
			testSettings2.TextFormat1__c = '<br />File name (attached): <br />';
			testSettings2.TextFormat2__c = '<br />File name \\(attached\\): <br />';
			testSettings2.TextFormat3__c = '<br />';
			testSettings2.TextFormat4__c = '</a>';
			testSettings2.TextFormat5__c = '<br />File name: <br />';
			testSettings2.Separator1__c = ',';
			testSettings2.Separator2__c = '.';
			testSettings2.ExceptionText__c = '';
			insert testSettings2;
		VabletFieldSettings__c testSettings3 = new VabletFieldSettings__c();
			testSettings3.Name = 'VabletInterfaceV2';
			testSettings3.TextConstant1__c = 'supportsSecondaryContacts';
			testSettings3.TextConstant2__c = 'mappingValuesInOrder';
			testSettings3.TextConstant3__c = 'nonBlockingErrorMessage';
			testSettings3.TextConstant4__c = 'getEvents';
			testSettings3.TextConstant5__c = 'getMediaViews';
			testSettings3.TextConstant6__c = 'getContacts';
			testSettings3.TextConstant7__c = 'getContactFormatString';
			testSettings3.TextConstant8__c = 'getSalesForceDisplayMapping';
			testSettings3.TextConstant9__c = 'contactFormatString';
			testSettings3.TextConstant10__c = 'modificationDateAfter';
			testSettings3.TextConstant11__c = 'Accepted';
			testSettings3.TextConstant12__c = 'contactsAfterDate';
			testSettings3.TextConstant13__c = 'createdEvent';
			testSettings3.TextConstant14__c = 'contacts';
			testSettings3.TextConstant15__c = 'mediaViews';
			testSettings3.TextConstant16__c = 'events';
			testSettings3.TextFormat1__c = 'SecondaryContacts';
			testSettings3.TextFormat2__c = 'Secondary Contacts';
			testSettings3.TextFormat3__c = 'apexrest';
			testSettings3.TextFormat4__c = 'createEvent';
			testSettings3.TextFormat5__c = 'updateEvent';
			testSettings3.TextFormat6__c = '<LastName>, <FirstName> \n<email> \n<Phone>';
			testSettings3.Separator1__c = '\\/';
			testSettings3.Type1__c = 'datetime';
			testSettings3.Type2__c = 'string';
			testSettings3.Type3__c = 'picklist';
			testSettings3.Query1__c = 'SELECT Id, WhatId,WhoId,ShowAs, AccountId, Subject, StartDateTime, ReminderDateTime, Description, EndDateTime, Location,(SELECT EventId,Status, RelationId FROM EventRelations) FROM Event';
			insert testSettings3;
	}
}