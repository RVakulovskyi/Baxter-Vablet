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
        
        String whereClauseIfNeeded = '';
        DateTime contactsAfterDate = null;
       
       if (contactsAfterDateString != null) {
            contactsAfterDate = (DateTime) JSON.deserialize(contactsAfterDateString, DateTime.class);
        }
        
        List < Contact > contactDatabaseData = Database.query('SELECT Account.ID,Account.Account_Number__c,Account.Name,IsDeleted,Id,FirstName,LastName, Name,Email,MailingCity,MailingState,MailingCountry,MailingPostalCode,Phone FROM Contact WHERE Status__c = \'Active\' limit 9999 ALL ROWS');
         
        List < CustomContact > contactList = new List < CustomContact > ();
        
            for (Contact contactData: contactDatabaseData) {
                
                CustomContact newContact = new CustomContact();
                newContact.AccountId = contactData.Account.ID;
                if (contactData.Account.Account_Number__c == '1111111111'){
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