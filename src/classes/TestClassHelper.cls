/********************************************************************************
Apex Class Name - TestClassHelper
Version - 1.0
Created Date - Oct 8, 2014
Function - Class to create test data.
Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     10/08/2014           Original Version
* Cognizant Developer     12/30/2014           Added following methods: createEntitlementRec,createTerritory,
*                                              createaccountShare, createAgreement, createAccountEntitlement
*                                              and createNotificationSetting
********************************************************************************/
public class TestClassHelper{    
    public static List<Account> accSList = new List<Account>();
    public static List<Contact> contSList = new List<Contact>();
    
    public static List<Event> eventSList = new List<Event>();
    public static List<User> userSList = new List<User>();
    public static List<EventRelation> eventRelSList = new List<EventRelation>();
  //  public static List<Related_Account__c> relAccSList = new List<Related_Account__c>();
  //  public static List<Related_Contact__c> relContSList = new List<Related_Contact__c>();
    public static List<Question__c> quesSList = new List<Question__c>();
    public static List<Account_Profile__c> accProfSList = new List<Account_Profile__c>();
 //   public static List<Contact_Profile__c> contProfSList = new List<Contact_Profile__c>();
  //  public static List<Baxter_Asset__c > BaxAssetSList = new List<Baxter_Asset__c >();
    /**
    * Method Name: creatAccount
    * Description: Create an Account
    * Parameter: None                             
    * Return Type: Account
    */
    public static Account creatAccount(){  
        Account insAcc = new Account();
        insAcc.name = 'aName';
        insAcc.BST_COUNTRY__c = 'Belgium';
        insAcc.BST_Account_Number__c = 'aNum1234';
        insAcc.billingStreet = '123 w fake';
        insAcc.BillingCity = 'fake';
        insAcc.BillingCountry = 'Belgium';
        insAcc.BillingState = 'fk';
        insAcc.BillingPostalCode = '22000';
        accSList.add(insAcc);
        insert insAcc;
        return insAcc;  
    }

    /**
    * Method Name: creatAccount
    * Description: Create an Account
    * Parameter: None                             
    * Return Type: Account
    */
    public static Account createAccountWithBillingType(String billingType,string accNum){  
        Account insAcc = new Account();
        insAcc.name = billingType + '_Account_Test';
        insAcc.BST_Account_Number__c = accNum;
        insAcc.BST_COUNTRY__c = 'Belgium';
     // insAcc.BST_Billing_Type__c=billingType;
        insAcc.billingStreet = '123 w fake';
        insAcc.BillingCity = 'fake';
        insAcc.BillingCountry = 'Belgium';
        insAcc.BillingState = 'fk';
        insAcc.BillingPostalCode = '22000';
        //insAcc.VGC_Code__c='123456';
        accSList.add(insAcc);
        insert insAcc;
        return insAcc;  
    }
    
    /**
    * Method Name: creatAccount
    * Description: Create an Account
    * Parameter: None                             
    * Return Type: Contact
    */
    /*
    public static Contact creatContact(){  
        Account dummyAcc = new Account(name = 'dummy Account',Account_Number__c = '1111111111');
        database.insert(dummyAcc,false);
        
        Contact insContact = new Contact();
        insContact.FirstName = 'ContactFName';
        insContact.LastName = 'ContactLName';
        insContact.Department__c = 'CCU';
        insContact.Job_Title__c = 'Buyer';
        insContact.Phone = '0123456975';
        contSList.add(insContact);
        insert insContact;
        return insContact;  
    }
*/
    // Code change for Test code coverage improvement by Govind
    /** 
    * Method Name: creatContactSurgeonSpecialty
    * Description: Create contact with Suregeon Speciality
    * Parameter: None                             
    * Return Type: Contact
    */
    /*
    public static Contact creatContactSurgeonSpecialty(){  
        Account dummyAcc = new Account(name = 'dummy Account',Account_Number__c = '1111111111');
        database.insert(dummyAcc,false);
        
        Contact insContact = new Contact();
        insContact.FirstName = 'ContactFName';
        insContact.LastName = 'ContactLName';
        insContact.Department__c = 'CCU';
        insContact.Job_Title__c = 'Buyer';
        insContact.Phone = '0123456975';
        insContact.Surgeon_Specialty__c = 'Bariatric-Bariatric';
        contSList.add(insContact);
        insert insContact;
        return insContact;  
    }   
*/
    /**
    * Method Name: creatBulkAccount
    * Description: Create Bulk Accounts
    * Parameter: integer                             
    * Return Type: void
    */
    public static void creatBulkAccount(integer count){  
     
        for(integer i=0; i<count ; i++){
            Account insAcc = new Account();
            insAcc.name = 'aName' + string.valueof(i);
            insAcc.BST_COUNTRY__c = 'Belgium';
                    insAcc.billingStreet = '123 w fake';
        insAcc.BillingCity = 'fake';
        insAcc.BillingCountry = 'Belgium';
        insAcc.BillingState = 'fk';
        insAcc.BillingPostalCode = '22000';
            insAcc.BST_Account_Number__c = 'aNum' + string.valueof(i);
            accSList.add(insAcc );
        }
        insert accSList; 
    }
    /**
    * Method Name: creatBulkContact
    * Description: Create bulk contacts
    * Parameter: integer                             
    * Return Type: Void
    */
    public static void creatBulkContact(integer count){
        Account dummyAcc = new Account(name = 'dummy Account',BST_Account_Number__c = '1111111111');
        //database.insert(dummyAcc,false);
        
        for(integer i=0; i<count ; i++){
            Contact insCont = new Contact();
            insCont.FirstName = 'fNAme' + string.valueof(i);
            insCont.LastName = 'lName' + string.valueof(i);
            insCont.Salutation= 'Ms' ;
            insCont.BST_COUNTRY__c = 'Belgium';   // added as this is mandate field
            if(!accSList.isEmpty()){
                insCont.Accountid = accSList[0].id;
            }
            else{
                insCont.Accountid = creatAccount().id;
            }
            contSList.add(insCont);
        }
        insert contSList;     
    }
    
    /**
    * Method Name: createOpportunity
    * Description: Create an Opportunity
    * Parameter: None                             
    * Return Type: Opportunity
    */
    /*
    public static Opportunity createOpportunity(){  
        
        RecordType recordType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Infusion'];
        Account insAcc = creatAccount();
        Opportunity insOpp = new Opportunity();
        insOpp.Name = 'TestOpportunity';
        insOpp.recordTypeId = recordType.Id;
        insOpp.Account = insAcc;
        insOpp.CloseDate = System.today();
        insOpp.StageName = 'Closed Won'; 
        insOpp.Reason_Lost_No_Deal__c = ' Hospital Closed';//Change made by Parmita for REQ-MD-JULY16-005
        insert insOpp;
        return insOpp;  
    }
    */
    /**
    * Method Name: creatEvent
    * Description: Create an event
    * Parameter: AccountID,ContactId                             
    * Return Type: Event
    */
    public static Event creatEvent(id accid,id conid){
        Event insEvent = new Event();
        insEvent.Subject = 'call';
        insEvent.whatid = accid;
        insEvent.DurationInMinutes = 60; 
        insEvent.ActivityDateTime = datetime.now();
        insEvent.whoid = conid;
        insert insEvent;
        eventSList.add(insEvent);
        return insEvent;     
    }
    /**
    * Method Name: creatUser
    * Description: Create User
    * Parameter: ProfileID , Username                            
    * Return Type: User
    */
    
   
   public static User creatUser(id profid, string usertype, String userGroup){
        User insUser = new User();
        insUser.alias = 'u1';
        insUser.email='u1CRM@baxter.com';
        insUser.emailencodingkey='UTF-8';
        insUser.FirstName ='User' + '_' + userGroup;
        insUser.lastname='Testing';
        insUser.languagelocalekey='en_US';
        insUser.localesidkey='en_US';
        insUser.profileid = profid;
        insUser.country='United States';
        insUser.timezonesidkey='America/Los_Angeles';
        insUser.username=usertype + userGroup + '_u1CRM@baxter.com';
        //Code to be commented for deployment ---Start
        insUser.BST_GroupOfUser__c= userGroup;
        //Code to be commented for deployment ---End
        insert insUser;
        userSList.add(insUser); 
        return insUser ;  
    } 
    
    
    /**
    * Method Name: createEventRelation
    * Description: Create Event Relation record.
    * Parameter: EventID, RealtedID                          
    * Return Type: EventRelation
    */
    Public static EventRelation createEventRelation(id eventID,id relId){
        EventRelation eRelation = new EventRelation();            
        eRelation.EventId = eventID;            
        eRelation.IsInvitee = true;            
        eRelation.IsParent = false;            
        eRelation.IsWhat = false;            
        eRelation.RelationId = relId; 
        insert eRelation;
        eventRelSList.add(eRelation);
        return eRelation;
    }
    /**
    * Method Name: createRelatedAccount
    * Description: Create Related Account record.
    * Parameter: Parent Account ID, Child Account ID, Hierarchy Type                          
    * Return Type: Related Account
    */
  /*
    Public static Related_Account__c createRelatedAccount(id pAccID,id cAccID,string HierType){
        Related_Account__c relAcc = new Related_Account__c();            
        relAcc.Parent_Account__c = pAccID;
        relAcc.Child_Account__c = cAccID;
        relAcc.Hierarchy_Type__c = HierType;
        relAcc.Legacy_CRM_Id__c = '' + pAccID + cAccID + HierType;
        insert relAcc ;
        relAccSList.add(relAcc);
        return relAcc;
    }

     */
    
    /**
    * Method Name: createRelatedContact
    * Description: Create Related Contact record.
    * Parameter: Account ID, Contact ID                          
    * Return Type: Related Contact
    */
   /*
    Public static Related_Contact__c createRelatedContact(Id accID, Id contID){
        Related_Contact__c relCont = new Related_Contact__c();            
        relCont.Account__c = accID;
        relCont.Contact__c = contID;
        insert relCont;
        relContSList.add(relCont);
        return relCont;
    }
    */
    
    /**
    * Method Name: createAllProfileHierarchySettings
    * Description: Create record in custom hierarchy setting.
    * Parameter: None                             
    * Return Type: None
    */     
    /*
    public static void createAllProfileHierarchySettings(Id profileId){
        List<BST_Profile_User_Settings__c> wSRecList = new List<BST_Profile_User_Settings__c>();
        wSRecList.add(new BST_Profile_User_Settings__c(SetupOwnerId = profileId , canUpdateRequest__c = true, updatePendingClosureRequest__c = true));
        insert wSRecList;
    }
    */
    /**
    * Method Name: createQuestionRecs
    * Description: Create Question Records. 
    * Parameter: None                             
    * Return Type: List<Question__c>
    */
    Public static List<Question__c> createQuestionRecs(){
        
        Id questionRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Question__c'  AND DeveloperName = 'BST_Account_Profile_Question'].Id;
        List<Question__c> quesList = new List<Question__c>();
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 1,RecordTypeId =questionRecordTypeId,   
                    BST_Question_Statement__c = 'Qusetion Statement1',BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 2,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement2',BST_Response_Type__c = 'Multi Picklist',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = '',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 3, RecordTypeId =questionRecordTypeId,  
                    BST_Question_Statement__c = 'Qusetion Statement3',BST_Response_Type__c = 'Date',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = '',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 4, RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement4',BST_Response_Type__c = 'Number',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 5, RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement5',BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data',BST_Order__c = 6,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement6',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Inactive',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_Order__c = 7,RecordTypeId =questionRecordTypeId,BST_MAJOR_CATEGORY__c = 'Advanced Surgery',BST_Category__c = 'Baxter Data', 
                    BST_Question_Statement__c = 'Qusetion Statement7',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'HD;PD;AS;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        insert quesList ;
        return quesList ; 
    }
    /**
    * Method Name: createQuestionRecsWOCat
    * Description: Create Question Records without Category Type.
    * Parameter: None                             
    * Return Type: List<Question__c>
    */
    Public static List<Question__c> createQuestionRecsWOCat(){
        
        Id questionRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Question__c'  AND DeveloperName = 'BST_Account_Profile_Question'].Id;
        
        List<Question__c> quesList = new List<Question__c>();
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_Order__c = 1,RecordTypeId =questionRecordTypeId,
                BST_Question_Statement__c = 'Qusetion Statement11',BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'NS;PH;AC',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_Order__c = 2,RecordTypeId =questionRecordTypeId,
                BST_Question_Statement__c = 'Qusetion Statement12',BST_Response_Type__c = 'Multi Picklist',BST_Salesforce_Group__c = 'NS;PH;AC',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = '',BST_COUNTRY__c = 'Belgium',BST_START_DATE__c = date.today(),BST_END_DATE__c = date.today(),BST_Order__c = 3,RecordTypeId =questionRecordTypeId,
                BST_Question_Statement__c = 'Qusetion Statement13',BST_Response_Type__c = 'Date',BST_Salesforce_Group__c = 'NS;PH;AC',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        insert quesList ;
        return quesList ; 
    }
    /**
    * Method Name: createAdvancedSurgQuestionRecs
    * Description: Create Advanced Surgery Question Records. 
    * Parameter: None                             
    * Return Type: List<Question__c>
    */
    public static List<Question__c> createBioSurgQuestionRecs(String recordTypeName){
        Id questionRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Question__c'  AND DeveloperName =: recordTypeName].Id;
        List<Question__c> quesList = new List<Question__c>();
        quesList = new List<Question__c>();
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Category__c = 'Renal',BST_Order__c = 1,RecordTypeId =questionRecordTypeId,   
                    BST_Question_Statement__c = 'Qusetion Statement1',BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Category__c = 'Renal',BST_Order__c = 2,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement2',BST_Response_Type__c = 'Multi Picklist',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Category__c = 'Renal',BST_Order__c = 3,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement3',BST_Response_Type__c = 'Number',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Category__c = 'Renal',BST_Order__c = 4,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement4',BST_Response_Type__c = 'Date',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        System.debug ('Value of List in 370 is ' +quesList );
        insert quesList ;
        
        return quesList ; 
    }
    /**
    * Method Name: createBioSurgQuestionRecsWOCat
    * Description: Create Question Records without Category Type.
    * Parameter: None                             
    * Return Type: List<Question__c>
    */
    public static List<Question__c> createBioSurgQuestionRecsWOCat(String recordTypeName){
        Id questionRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Question__c'  AND DeveloperName =: recordTypeName].Id;
        List<Question__c> quesList = new List<Question__c>();
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Order__c = 5,RecordTypeId =questionRecordTypeId,   
                    BST_Question_Statement__c = 'Qusetion Statement7',BST_Response_Type__c = 'Picklist',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Order__c = 6,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement8',BST_Response_Type__c = 'Multi Picklist',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Order__c = 7,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement9',BST_Response_Type__c = 'Number',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        quesList.add(new Question__c(BST_Answer_Options__c = 'No~##~Yes',BST_Order__c = 8,RecordTypeId =questionRecordTypeId, 
                    BST_Question_Statement__c = 'Qusetion Statement10',BST_Response_Type__c = 'Date',BST_Salesforce_Group__c = 'AS;HD;PD;MSL',BST_Status__c = 'Active',BST_RESPONSE_VALID_TIME__c=130));
        System.debug ('Value of List in 390 is ' +quesList );
        insert quesList ;
        
        return quesList ; 
    }
    /**
    * Method Name: creatAileronSurgeon
    * Description: Create an Aileron Surgeon
    * Parameter: None                             
    * Return Type: Aileron_Surgeon__c
    */
    /*
    public static Aileron_Surgeon__c creatAileronSurgeon(){  
        Aileron_Surgeon__c ailSurg = new Aileron_Surgeon__c();
        ailSurg.First_Name__c = 'fName';
        ailSurg.Last_Name__c = 'lName';
        ailSurg.Name=ailSurg.First_Name__c + ' '+ailSurg.Last_Name__c;
        ailSurg.NPI__c = 'test';
        ailSurg.Skin_Grafting__c= 60;
        ailSurg.Work_Phone_Number__c = '12345';
        insert ailSurg;
        return ailSurg;  
    }
    */
    /**
    * Method Name: creatAileronRelatedSurgeon
    * Description: Create an Aileron Related Surgeon
    * Parameter: accountId, ailSurgId                           
    * Return Type: Aileron_Related_Surgeon__c
    */
    /*
    public static Aileron_Related_Surgeon__c creatAileronRelatedSurgeon(Id accountId,Id ailSurgId){  
        Aileron_Related_Surgeon__c ailRelatedSurg = new Aileron_Related_Surgeon__c();
        ailRelatedSurg.Account__c=accountId;
        ailRelatedSurg.Aileron_Surgeon__c=ailSurgId;
        ailRelatedSurg.External_Id__c = 'test'+ailSurgId;
        ailRelatedSurg.Name='test surgeon related';
        ailRelatedSurg.Skin_Grafting__c= 60;
        insert ailRelatedSurg;
        return ailRelatedSurg;  
    }
    */
    /**
    * Method Name: updateAccountWithMII
    * Description: Update JDE Account with MII info.
    * Parameter: Account,Account                         
    * Return Type: void
    */
    /*
    public static void updateAccountWithMII(Account jdeAcc, Account miiAcc){
        
        jdeAcc.IDN_MII_Facility__c = miiAcc.Id;
        update jdeAcc;
    }
    */
    
    /**
    * Method Name: createAccProfile
    * Description: Create Account Profile records.
    * Parameter: Account ID, List<Question__c>                         
    * Return Type: List<Account_Profile__c>
    */
    public static List<Account_Profile__c> createAccProfile(id accId, List<Question__c> quesList){
        List<Account_Profile__c> accProfList = new List<Account_Profile__c>();
        Integer i = 0;
        for(Question__c qs:quesList){
            Account_Profile__c accProf = new Account_Profile__c();
            accProf.BST_Account__c = accId;
            if(i==0){
                accProf.BST_EXPIRED__c = true;
                i++;
            }
            accProf.BST_Question__c = qs.id;
            if(qs.BST_Response_Type__c == 'Picklist'){
                accProf.BST_Selected_Picklist_Answer__c = 'Yes';
            }
            else if(qs.BST_Response_Type__c == 'Multi Picklist'){
                accProf.BST_Selected_Multi_Answers__c = qs.BST_Answer_Options__c;
            }
            else if(qs.BST_Response_Type__c == 'Date'){
                accProf.BST_Selected_Date__c = Date.today();           
            }
            else if(qs.BST_Response_Type__c == 'Number'){
                accProf.BST_Selected_Number__c = 1;
            }
            accProfList.add(accProf);
            accProfSList.add(accProf);
        }

        insert accProfList ;
        return accProfList ; 
    }
     /**
    * Method Name: createContProfile
    * Description: Create Contact Profile records.
    * Parameter: Contact ID, List<Question__c>                         
    * Return Type: List<Contact_Profile__c>
    */
   /*
    public static List<Contact_Profile__c> createContProfile(id ContId, List<Question__c> quesList){
        List<Contact_Profile__c> contProfList = new List<Contact_Profile__c>();
        for(Question__c qs:quesList){
            Contact_Profile__c contProf = new Contact_Profile__c();
            contProf.Contact__c = contId;
            contProf.Question__c = qs.id;
            if(qs.Response_Type__c == 'Picklist'){
                contProf.Selected_Picklist_Answer__c = 'Yes';
            }
            else if(qs.Response_Type__c == 'Multi Picklist'){
                contProf.Selected_Multi_Answers__c = qs.Answer_Options__c;
            }
            else if(qs.Response_Type__c == 'Date'){
                contProf.Selected_Date__c = Date.today();           
            }
            else if(qs.Response_Type__c == 'Number'){
                contProf.Selected_Number__c = 1;
            }
            contProfList.add(contProf);
            contProfSList.add(contProf);
        }

        insert contProfList;
        return contProfList; 
    }
*/
    /**
    * Method Name: createTask
    * Description: Create Task without whatid
    * Parameter: Integer noofTask,Contact contactId                         
    * Return Type: List<Task>
    */
    public static List<Task> createTask(Integer noofTask,Contact contactId,Account accountid){        
        List<Task> lstTask = new List<Task>();
        for(Integer i=0;i<noofTask;i++){
                lstTask.add(new Task(
                ActivityDate = Date.today().addDays(7),
                Subject='Sample Task'+i,                    
                whoID = contactId.Id,
                whatId=accountid.Id,
                OwnerId = UserInfo.getUserId(),
                Status='In Progress')); 
        }       
                           
        insert lstTask;
        return lstTask;
    }
   /**
    * Method Name: creatContactAccountId
    * Description: Create contact with the account ID
    * Parameter: String ids                         
    * Return Type: Contact
    */ 
    /*
   public static Contact creatContactAccountId(String ids){  
        Contact insContact = new Contact();
        insContact.FirstName = 'ContactFName';
        insContact.LastName = 'ContactLName';
        insContact.Department__c = 'CCU';
        insContact.Job_Title__c = 'Buyer';
        insContact.Phone = '0123456975';
        insContact.ACCOUNTID =ids; 
        contSList.add(insContact);
        insert insContact;
        return insContact;  
    } 
    */
     /**
    * Method Name: creatVgcAccountBulk
    * Description: Create Account with VGC utilisation details in account.
    * Parameter: N/A                        
    * Return Type: List<Account>
    */ 
    /*
   public static List<Account> creatVgcAccountBulk(){  
        List<Account> accVGCList = new List<Account>();
        for(Integer i=0;i<20;i++){
            Account insAcc = new Account();
            insAcc.name = 'aName'+i;
            insAcc.BST_Account_Number__c='vgc'+i;
            insAcc.Sevoflurane_Count__c=i;
            insAcc.Sevoflurane_Utilization__c=i;
            insAcc.Suprane_Count__c=i;
            insAcc.Suprane_Utilization__c=i;
            if(i==0)
            insAcc.VGC_Code__c='B70';
            else 
            insAcc.VGC_Code__c='B70'+i;         
            accVGCList.add(insAcc);
        }
        insert accVGCList;
        return accVGCList;    
    }
    */
     /**
    * Method Name: creatVgcAccountBulk
    * Description: Create Account with VGC utilisation details in account.
    * Parameter: N/A                        
    * Return Type: List<Account>
    */ 
   /*
    public static List<Vape_Request__c> creatVapeRequestBulk(){  
        List<Vape_Request__c> accVapeRequestList = new List<Vape_Request__c>();
        for(Integer i=0;i<20;i++){
            Vape_Request__c insVapeReq = new Vape_Request__c();
            insVapeReq.Reason_Code__c = 'NWB - New Business / No IGP';
            accVapeRequestList.add(insVapeReq);
        }
        insert accVapeRequestList;
        return accVapeRequestList;    
    }
    */
    
    /**
    * Method Name: createVapeRequest
    * Description: Create Vape Request Object 
    * Parameter: N/A                      
    * Return Type: Vape_Request__c
    */ 
    /*
    public static Vape_Request__c createVapeRequest(){
        Vape_Request__c vapeRequest = new Vape_Request__c();
        Account newAccount = createAccountWithBillingType('Bill-To/Ship-To','999999');
        Contact newContact = creatContact();
        vapeRequest.Bill_To_Account__c = newAccount.Id;
        vapeRequest.Ship_To_Account__c = newAccount.Id;
        vapeRequest.Contact_Name__c = newContact.Id;        
        vapeRequest.Status__c = 'Submitted' ;  
        vapeRequest.Reason_Code__c = 'NWB - New Business / No IGP';     
        insert vapeRequest;
        return vapeRequest;
    }
    */
    
    /**
    * Method Name: createVapeRequest
    * Description: Create Vape Request Object 
    * Parameter: Account, Contact, Id, String                       
    * Return Type: Vape_Request__c
    */ 
    /*
    public static Vape_Request__c createVapeRequest(Account newAccount, Contact newContact, ID recordTypeId, String reasonCode){
        Vape_Request__c vapeRequest = new Vape_Request__c();

        vapeRequest.RecordTypeId = recordTypeId;
        vapeRequest.Bill_To_Account__c = newAccount.Id;
        vapeRequest.Ship_To_Account__c = newAccount.Id;
        vapeRequest.Contact_Name__c = newContact.Id;        
        vapeRequest.Reason_Code__c = reasonCode;//'NWB - New Business / No IGP';     
        insert vapeRequest;
        return vapeRequest;
    }
    */
    
    /**
    * Method Name: createVapeRequestLineItemOrder
    * Description: Create Vape Request Line Item Object 
    * Parameter: Vape_Request__c, Product2                       
    * Return Type: Vape_Request_Line_Item__c
    */ 
    /*
    public static Vape_Request_Line_Item__c createVapeRequestLineItemOrder(Vape_Request__c vReq, Product2 prod){
        Vape_Request_Line_Item__c vReqLI = new Vape_Request_Line_Item__c();
        
        vReqLI.Vape_Request__c = vReq.Id;
        vReqLI.Product__c = prod.Id;
        vReqLI.Product_Quantity__c = 10;
        vReqLI.Anesthesia_Machine_Type__c = 'Other';
        insert vReqLI;
        return vReqLI;
    }
    */
    /**
    * Method Name: createVapeRequestLineItemReturn
    * Description: Create Vape Request Line Item Object 
    * Parameter: Vape_Request__c                       
    * Return Type: Vape_Request_Line_Item__c
    */ 
    /*
    public static Vape_Request_Line_Item__c createVapeRequestLineItemReturn(Vape_Request__c vReq){
        Vape_Request_Line_Item__c vReqLI = new Vape_Request_Line_Item__c();
        
        vReqLI.Vape_Request__c = vReq.Id;
        vReqLI.Asset_Serial_Number__c = 'Asset';
        insert vReqLI;
        return vReqLI;
    }
    */
    /**
    * Method Name: createOrder
    * Description: Create Order Record 
    * Parameter: N/A                        
    * Return Type: Order__c
    */ 
    /*
    public static Order__c createOrder(){
        Order__c ord = new Order__c();
        ord.Name = '581547A1CO';
        ord.Baxter_Order_Number__c = '581547A1CO';
        Account newAccount = createAccountWithBillingType('Bill-To/Ship-To','Ord999');
        ord.Bill_To_Account__c = newAccount.Id;   
        insert ord;
        return ord;
    }

    */
    /**
    * Method Name: createProduct
    * Description: Create Product Record 
    * Parameter:   Product Source,Parent Product,Sales Group,Product,Name                    
    * Return Type: Product2
    */
    /*
    Public static Product2 createProduct(string pSource,String prodCode,string salesGrp,String pName){
        Product2 insProd = new Product2();            
        insProd.Product_Source__c  = pSource;            
        insProd.Sales_Group__c  = salesGrp;   
        insProd.Name = pName;
        insProd.ProductCode = prodCode ;
        insProd.IsAsset__c = true;
        insProd.IsActive = True;
        if(pSource == 'JDE'){
            insProd.Type__c = 'Product';
            insProd.List_Price__c = 350.40;
            insProd.IsAsset__c = True;
        }
        else{
            insProd.Type__c = 'Detail';
            insProd.List_Price__c = null;
        }
        insert insProd; 
        return insProd;
    }
    */
    
    /**
    * Method Name: createProduct
    * Description: Create Product Record 
    * Parameter:   Product Source,Parent Product,Sales Group,Product,Name                    
    * Return Type: Product2
    */
    /*
    Public static Product2 createProduct(string pSource,id perProd,string salesGup,string pName, Boolean isAsset){
        Product2 insProd = new Product2();            
        insProd.Product_Source__c  = pSource;            
        insProd.Sales_Group__c  = salesGup;            
        insProd.Parent_Product__c = perProd;            
        insProd.Name = pName;
        insProd.ProductCode = pName ;
        insProd.IsActive = True;
        if(pSource == 'JDE'){
            insProd.Type__c = 'Product';
            insProd.List_Price__c = 350.40;
            insProd.IsAsset__c = True;
        }
        else{
            insProd.Type__c = 'Detail';
            insProd.List_Price__c = null;
            insProd.IsAsset__c = False;
        }
        insert insProd; 
        return insProd;
    }
    
    */
    
    /**
    * Method Name: createPriceBook
    * Description: Create Pricebook records 
    * Parameter: N/A                        
    * Return Type: Void
    */  
    /*
    Public static void createPriceBook(){
        List<Pricebook2> insPriceBooks = new List<Pricebook2>();            
        insPriceBooks.add(new Pricebook2(Name = 'HM' , IsActive = True));           
        insPriceBooks.add(new Pricebook2(Name = 'IA' , IsActive = True));            
        insert insPriceBooks; 
    }
    */
    /**
    * Method Name: createPriceBook
    * Description: Create Pricebook records 
    * Parameter: Yes                       
    * Return Type: PriceBook2
    */ 
    /*
    Public static PriceBook2 createPriceBook(string Name,Boolean IsActive){
        Pricebook2 insPriceBooks = new Pricebook2();                    
        insPriceBooks.Name = Name;
        insPriceBooks.IsActive = IsActive;     
        insert insPriceBooks;
        return  insPriceBooks;
    }
    */
    
   /**
    * Method Name: createPriceBookEntry
    * Description: Create PriceBookEntry records 
    * Parameter: Yes                       
    * Return Type: PriceBookEntry
    */  
    /*
    Public static PriceBookEntry createPriceBookEntry(id prodId,Id priceBookid,Boolean IsActive){
        PriceBookEntry insPriceBookEntry = new PriceBookEntry();                    
        insPriceBookEntry.product2Id= prodId;
        insPriceBookEntry.IsActive = IsActive;
        insPriceBookEntry.priceBook2Id=priceBookid;
        insPriceBookEntry.UnitPrice=1;     
        insert insPriceBookEntry;
        return  insPriceBookEntry;
    } 
    
    
    */
    /**
    * Method Name: createBaxterAsset
    * Description: Create Baxter Asset record 
    * Parameter: string BilltoAccID,string ShiptoAccID,string assetNumber                        
    * Return Type: Void
    */  
    /*
    Public static Baxter_Asset__c createBaxterAsset(string BilltoAccID,string ShiptoAccID,string assetNumber,string prodID){
        Baxter_Asset__c insBaxterAsset = new Baxter_Asset__c();  
        insBaxterAsset.As_Of_Bill_To_Account__c= BilltoAccID;
        insBaxterAsset.Ship_To_Account__c= ShiptoAccID;
        insBaxterAsset.Name = assetNumber;
        insBaxterAsset.Asset_Key__c = assetNumber;
        insBaxterAsset.Product__c = prodID;
        insBaxterAsset.Operating_Status__c = 'CLS';
        insert insBaxterAsset;
        system.debug('6666666666666666'+insBaxterAsset.Ship_To_Account_Number__c );
        system.debug('6666666666666666'+insBaxterAsset.Current_Bill_To_Account_Number__c );
        BaxAssetSList.add(insBaxterAsset);
        return insBaxterAsset;
    }
*/
    /**
    * Method Name: createRMA
    * Description: Create Baxter RMA record 
    * Parameter:  Number of RMA records need to create                       
    * Return Type: List<RMA__c>
    */  
    /*
    Public static List<RMA__c> createRMA(integer RMACount){
        list<RMA__c> RMAList = new list<RMA__c>();
        //Create Bill To Account
        Account BillToAcc = createAccountWithBillingType('Bill-To/Ship-To','999999');
        //Search Territory group id
        Group terrGroup = [SELECT Id FROM Group WHERE DeveloperName = 'IA_551D' AND Type = 'Territory'];
        //Create Account Share Record
        AccountShare accShareRec = new AccountShare();
        accShareRec.AccountId = BillToAcc.id;
        accShareRec.UserOrGroupId = terrGroup.id;
        insert accShareRec;
        for(integer count = 0;count < RMACount;count++){
            RMA__c insRMA = new RMA__c();  
            insRMA.Baxter_RMA_Number__c = 'RMA-'+count ;
            insRMA.Name = 'RMA-'+count ;
            insRMA.RMA_Date__c = Date.today();
            insRMA.Bill_To_Account__c = BillToAcc.id;
            RMAList.add(insRMA);
        }
        return RMAList;
    }
    */
    /**
    * Method Name: createshipCompMapRecs
    * Description: Create Shipping_Company_Mapping record 
    * Parameter:  void                       
    * Return Type: void
    */ 
    /*
    Public static void createshipCompMapRecs(){
        List<Shipping_Company_Mapping__c> shipCompMapReclist = new List<Shipping_Company_Mapping__c>();
        shipCompMapReclist.add(new Shipping_Company_Mapping__c(name = 'UPSA' , Code__c = 'UPSA',Tracking_URL__c = 'http://www.aaacooper.com/ProTrackResults.aspx?ProNum=$REFN$'));
        insert shipCompMapReclist;
    }
*/
    /**
    * Method Name: createOpptyRec
    * Description: Create Opportunity record 
    * Parameter: string recTypeId,string opptyName,string stageName,string accId                        
    * Return Type: Opportunity
    */  
    /*
    Public static Opportunity createOpptyRec(string recTypeId,string opptyName,string stageName,string accId){
        Opportunity oppty = new Opportunity();  
        oppty.CloseDate= Date.Today() + 30;
        oppty.Name= opptyName;
        oppty.StageName= 'Closed Won';
        oppty.Reason_Lost_No_Deal__c = 'Contract Compliance';
        oppty.AccountId= accId;
        oppty.RecordTypeId = recTypeId;
        insert oppty;
        return oppty;
    }
*/
    /**
    * Method Name: createQuoteRec
    * Description: Create Quote record 
    * Parameter: string recTypeId,string opptyName,string stageName,string accId                        
    * Return Type: Opportunity
    */  
    /*
    Public static Quote createQuoteRec(string opptyId,Decimal targetAGP,Decimal pricing,string quoteName){
        Quote qt = new Quote();  
        qt.Opportunityid = opptyId;
        qt.Name= quoteName;
        qt.Deal_Type__c= 'New';
        qt.Target_AGP__c= targetAGP;
        qt.Pricing__c= pricing;
        qt.Software_Version__c= '8';
        qt.Terms_Conditions_Needed__c= 'Yes';
        qt.Purchase_Options__c = 'Lease';
        qt.Lease_Purchase_Term__c = '10';
        qt.Status = 'Quote Request Generated';
        insert qt;
        return qt;
    }
*/
    /**
    * Method Name: createAgreementRec
    * Description: Create Agreement record 
    * Parameter: RecordType recId,string status ,Id opId, Datetime dt, string reason
    * Return Type: Agreement
    */  
    /*
    Public static  Agreement__c  createAgreementRec(id recId,string status ,Id opId, Datetime dt, string reason){
        Agreement__c agree = new Agreement__c();  
        agree.Name  = 'Unit Test Agreement';
        agree.RecordTypeid = recId;
        agree.Agreement_Status__c= status ;
        agree.Opportunity__c= opId;
        agree.Last_Resource_Onsite_Date__c= dt;
        agree.Cancelled_Reason_Code__c = reason ;
        
        insert agree;
        return agree;
    }
*/
    
    /**
    * Method Name: createAgreementLinItemRec
    * Description: Create Agreement Line Item record 
    * Parameter: Id  agrId                
    * Return Type: Agreement_Line_Item__c  
    */  
    /*
    Public static Agreement_Line_Item__c   createAgreementLinItemRec(Id  agrId){
        Agreement_Line_Item__c  agrLine = new Agreement_Line_Item__c ();  
        agrLine.Agreement__c = agrId;
        
        insert  agrLine;
        return  agrLine;
    }
*/
    /**
    * Method Name: createNonPumpAgreementRec
    * Description: Create Non Pump Agreement record 
    * Parameter: Id  accId,id recTypeid              
    * Return Type: Agreement__c  
    */  
    /*
    Public static Agreement__c  createNonPumpAgreementRec(Id  accId,id recTypeid){
        Agreement__c agree = new Agreement__c();  
        agree.Name  = 'Unit Test non pump Agreement';
        agree.RecordTypeid = recTypeid;
        agree.Agreement_Owner__c = accId;
        insert agree;
        return agree;
    }
*/
    /**
    * Method Name: createEntitlementRec
    * Description: Create Entitlement record 
    * Parameter: Id  agrId                
    * Return Type: Entitlement__c  
    */  
    /*
    Public static Entitlement__c   createEntitlementRec(Id  agrId){
        Entitlement__c ent = new Entitlement__c();
        ent.Agreement_Id__c = agrId;
        ent.Entitlement_Id__c = 'P - AA3R5 - AA';
        insert ent;
        return ent;
    }
    */
    /*
     * Method Name: createGlobalSettings
     * Description: Create Global Settings custom setting
     * Parameter: name, value              
     * Return Type: Global_Settings__c  
     */ 
    public static BST_Global_Settings__c createGlobalSettings(string name, string value){
        BST_Global_Settings__c globSet = new BST_Global_Settings__c();
        globSet.Name = name;
        globSet.BST_value__c = value;
        insert globSet;
        
        return globSet;
    }
    
    /* 
     * Method Name: createEntitlementRec
     * Description: Create Territory record
     * Parameter: agrId, entitlement           
     * Return Type: Entitlement__c  
     */ 
    /*
    Public static Entitlement__c   createEntitlementRec(Id  agrId, string entitlement){
        Entitlement__c ent = new Entitlement__c();
        ent.Agreement_Id__c = agrId;
        ent.Entitlement_Id__c = entitlement;
        insert ent;
        return ent;
    }
    
    */
    
    /* 
     * Method Name: createTerritory
     * Description: Create Territory record
     * Parameter: name, accountAccessLevel              
     * Return Type: Territory  
     */ 
    /*
    public static Territory createTerritory(string name,string accountAccessLevel){
        Territory territory = new Territory();
        territory.Name = name;
        territory.AccountAccessLevel = accountAccessLevel;
        insert territory;
        return territory;
    }
*/
    
    /* 
     * Method Name: createaccountShare
     * Description: Create AccountShare record
     * Parameter: accountId, accountAccessLevel, OppAccessLevel, caseAccessLevel, contactAccessLevel, userGroupID               
     * Return Type: AccountShare  
     */
    /*
    public static AccountShare createAccountShare(Id accountId,string accountAccessLevel, string OppAccessLevel,
                                                 string caseAccessLevel, string contactAccessLevel,Id userGroupID){
        Accountshare accountShare =  new Accountshare();
        accountShare.AccountId = accountId ;        
        accountShare.AccountAccessLevel = accountAccessLevel;
        accountShare.OpportunityAccessLevel = OppAccessLevel;
        accountShare.CaseAccessLevel = caseAccessLevel;
        accountShare.ContactAccessLevel = contactAccessLevel;
        accountShare.UserOrGroupId = userGroupID;
        insert accountShare ;
        return accountShare ;                                                    
    }
    */
     /* 
     * Method Name: createAgreement
     * Description: Create Agreement record
     * Parameter: recordTypeId, startDate, endDate, BusinessUnit             
     * Return Type: Agreement__c  
     */
    /*
    public static Agreement__c createAgreement(Id recordTypeId, date startDate,date endDate, string BusinessUnit){
        Agreement__c testagreement = new Agreement__c();
        testagreement.RecordTypeId  = recordTypeId;
        testagreement.Name = 'TestAgreement';
        testagreement.Effective_Date__c = startDate;
        testagreement.End_Date__c = endDate ;
        testagreement.Business_Unit_Code__c = BusinessUnit;
        insert(testagreement);
        return testagreement;
    }
    */
    /* 
     * Method Name: createAccountEntitlement
     * Description: Create Account Entitlement record
     * Parameter: entitlementId, customerId, startDate, endDate           
     * Return Type: Account_Entitlement__c  
     */
    /*
    public static Account_Entitlement__c createAccountEntitlement(Id entitlementId, Id customerId, Date startDate,Date endDate){
        Account_Entitlement__c notifierConnection = new Account_Entitlement__c();
        notifierConnection.Entitlement__c = entitlementId ;
        notifierConnection.Customer_Id__c = customerId ;
        notifierConnection.Conn_Effective_Date__c = startDate;
        notifierConnection.Conn_Expirtn_Date__c = endDate ;
        insert notifierConnection;
        return notifierConnection;
    }
    */
    /* 
     * Method Name: createNotificationSetting
     * Description: Create Notification settings record
     * Parameter: name,businessUnit, territory1,territory2, territory3,territory4,offset,address
     * Return Type: Notification_settings__c  
     */
    /*
    public static Notification_settings__c createNotificationSetting(string name,string businessUnit, string territory1,
                                                                    string territory2, string territory3,string territory4,
                                                                    Integer offset,string address, string statusAddress){
        Notification_settings__c setting = new Notification_settings__c( 
                Name = name,
                Business_Unit__c = businessUnit, 
                Territory1__c = territory1,
                Territory2__c = territory2,
                Territory3__c = territory3,
                Territory4__c = territory4,
                Day_180_Offset__c = offset ,
                Day_90_Offset__c = offset ,
                Day_60_Offset__c = offset ,
                Day_30_Offset__c = offset ,
                FromAddressLable__c = address,
                Batch_Status_Address__c = statusAddress
            );
        insert setting;
        return setting;
    }
    */
    /**
    * Method Name: creatEvent
    * Description: Create an event
    * Parameter: AccountID,ContactId                             
    * Return Type: Event
    */
    /*
    public static Event creatExtranealTrainingEvent(id accid,id conid){
        Event insEvent = new Event();
        insEvent.Subject = 'call';
        insEvent.whatid = accid;
        insEvent.DurationInMinutes = 60; 
        insEvent.ActivityDateTime = datetime.now();
        insEvent.whoid = conid;
        insEvent.Type = 'Extraneal Compliance Training';
        insert insEvent;
        eventSList.add(insEvent);
        return insEvent;     
    }*/
}