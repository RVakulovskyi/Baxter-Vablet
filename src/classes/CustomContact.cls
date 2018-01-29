/********************************************************************************
Apex Class Name - CustomContact 
Version - 1.0
Supplied by Vablet for loading the contacts in mobile app.

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/23/2015           Updates Where clause along with generic Account Number
* Rodion Vakulovskyi	  04/01/2018		   modifying class
* Rodion Vakulovskyi	  05/01/2018		   modifying class
* Rodion Vakulovskyi	  12/01/2018		   modifying class
* Rodion Vakulovskyi	  19/01/2018		   modifying class
* Rodion Vakulovskyi	  24/01/2018		   modifying class
********************************************************************************/

public class CustomContact {
	static final String SETTINGSNAME = 'CustomContact';
    public String FirstName;
    public String LastName;
    public String AccountId;
    public String Id;
    public String Name;
    public String Email;
    public String MailingCity;
    public String MailingState;
    public String MailingCountry;
    public String MailingPostalCode;
    public String Phone;
    public String CompanyName;
    public Boolean IsDeleted;

    public static List < CustomContact > getContacts(String contactsAfterDateString) {     
		VabletFieldSetting__mdt vabletSettings = queryCustomMetadataType(SETTINGSNAME);
        DateTime contactsAfterDate = null;
       if (contactsAfterDateString != null) {
            contactsAfterDate = (DateTime) JSON.deserialize(contactsAfterDateString, DateTime.class);
        }
		String formedQuery = vabletSettings.Query1__c;
        List < Contact > contactDatabaseData = Database.query(formedQuery);
		System.debug(contactDatabaseData);
        List < CustomContact > contactList = new List < CustomContact > ();
            for (Contact contactData: contactDatabaseData) {
                CustomContact newContact = new CustomContact();
                newContact.AccountId = contactData.Account.ID;
                newContact.CompanyName = contactData.Account.Name;
                newContact.Name = contactData.Name;
                newContact.Id = contactData.Id;
                newContact.FirstName = contactData.FirstName;
                newContact.LastName = contactData.LastName;
                newContact.Email = contactData.Email;
                newContact.MailingCity = ContactData.MailingCity;
                newContact.MailingState = ContactData.MailingState;
                newContact.MailingCountry = ContactData.MailingCountry;
                newContact.MailingPostalCode = ContactData.MailingPostalCode;
                newContact.Phone = ContactData.Phone;
                newContact.IsDeleted = ContactData.IsDeleted;
                contactList.add(newContact);
            }
        return contactList;
    }

	private static VabletFieldSetting__mdt queryCustomMetadataType(String nameOFObject) {
		String queryString = 'SELECT ';
		SObjectType customMetaType = Schema.getGlobalDescribe().get('VabletFieldSetting__mdt');
		Map<String,Schema.SObjectField> mfields = customMetaType.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
		queryString = queryString.substring(0, queryString.length() - 1) + ' FROM VabletFieldSetting__mdt WHERE QualifiedApiName = :nameOFObject';
		return Database.query(queryString);
	}
}