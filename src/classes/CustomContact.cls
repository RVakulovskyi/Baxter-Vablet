/********************************************************************************
Apex Class Name - CustomContact 
Version - 1.0
Supplied by Vablet for loading the contacts in mobile app.

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/23/2015           Updates Where clause along with generic Account Number
* 
********************************************************************************/

public class CustomContact {
	static final String SETTINGSNAME = 'VabletTriggerHandler';
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
		VabletFieldSettings__c vabletSettings = VabletFieldSettings__c.getInstance(SETTINGSNAME);
        String whereClauseIfNeeded = '';
        DateTime contactsAfterDate = null;
       if (contactsAfterDateString != null) {
            contactsAfterDate = (DateTime) JSON.deserialize(contactsAfterDateString, DateTime.class);
        }
        List < Contact > contactDatabaseData = Database.query(vabletSettings.Query1__c);
        List < CustomContact > contactList = new List < CustomContact > ();
            for (Contact contactData: contactDatabaseData) {
                CustomContact newContact = new CustomContact();
                newContact.AccountId = contactData.Account.ID;
                if (contactData.Account.Account_Number__c == vabletSettings.TextConstant1__c){
                    newContact.CompanyName =' ';
                }else{
                    newContact.CompanyName = contactData.Account.Name;
                }
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
}