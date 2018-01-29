/***********************************************************************************************
Version - 1.0
Created Date - January 5, 2018
Function - Test util for Vablet project

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* Rodion Vakulovskyi	  09/01/2018		   modifying class
************************************************************************************************/
public class VabletTestUtility {

	//general method for custom settings creation
	public static void createCustomSettings() {
		DefaultEventValues__c testSettings4 = new DefaultEventValues__c();
			testSettings4.SetupOwnerId = UserInfo.getOrganizationId();
			testSettings4.BST_BAX_SALES_TEAM__c = 'Bax Company/Services';
			testSettings4.Description__c = 'Information Required';
			insert testSettings4;
	}
}