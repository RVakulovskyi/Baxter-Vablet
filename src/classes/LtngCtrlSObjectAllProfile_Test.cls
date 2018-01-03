/********************************************************************************
Apex Class Name - LtngCtrlSObjectAllProfile_Test
Version - 1.0
Created Date - Nov 3rd, 2016
Function - Test class for  LtngCtrlSObjectAllProfile 
 
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Dharani Pothula         11/03/2016           Original Version
* Gaurav Jain             11/15/2016           To Include the test Coverage for the Contact Related Profiling
*Shashank Mehra           25/08/2017           To add methods to cover LtngCtrlSobjectAllProfile    
********************************************************************************/

@isTest
public class LtngCtrlSObjectAllProfile_Test {
    public static List<Question__c> quesList;
    public static List<Question__c> quesList1;
        
    public static testMethod void testGetCategoryOptions_ReturnStringList(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
        //Creating Questions
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
                       
     //   Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
    //    TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
                CommonStringConverterUtilities.convertStringToDate(string.valueof(date.today()),'YYYY-MM-DDThh:mm:ss.mmm');
                CommonStringConverterUtilities.convertStringToNumber( '123' , '.####');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
        }
    }
    
    public static testMethod void testGetCategoryOptions_ReturnStringListWithQuestions(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
  //      Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
    //    TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
            //creating  Questions records without category
        List<Question__c> accques1 = TestClassHelper.createQuestionRecsWOCat();
        List<Question__c> accques11 = TestClassHelper.CreateQuestionRecs();
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
            List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques11[0].BST_MAJOR_CATEGORY__c,accques11[0].BST_CATEGORY__c );
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
        }
    }
    
    public static testMethod void testGetCategoryOptions_returnStringOfCategory_questionswithCategories(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
    //    Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
     //   TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);

        //creating  Questions records with category
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
        
        //creating  Account Profile records
     //   List<Account_Profile__c> accproff = TestClassHelper.CreateAccProfile(TestClassHelper.accSList[1].id,accques);
    //    update accproff;
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
            List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            List<String> subcategoryList = LtngCtrlSObjectMyProfile.getSubCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);   
            //  system.assert(categoryList.size() == 2);
            //    system.assertEquals('HD', categoryList[1]);
            
            List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,categoryList[1],subcategoryList[1],true,true,'HD');
           accProfWrp.sort();
            Test.stopTest();
            system.assert(accProfWrp.size() == 0);
          
            
            //  AccountProfileQuestions.getQuestionsWithSavedResponses();
            
        }
    }
    
    public static testMethod void testSaveResponse_returnString(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
    //    Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
     //   TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);

        //creating  Questions records with category
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
        //creating  Account Profile records
        List<Account_Profile__c> accproff = TestClassHelper.CreateAccProfile(TestClassHelper.accSList[0].id,accques);     
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();     
            List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            List<String> catlist = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            //system.assert(categoryList.size() == 2);
            //system.assertEquals('All', categoryList[0]);
                
            List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,categoryList[0],'All',true,true ,'HD');
            List<AccountProfileWrapper> accProfWrp1 = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,catlist[0],'All',true,false,'HD');
            accProfWrp.sort();
            accProfWrp1.sort();
            Test.stopTest();
            system.assert(accProfWrp1.size()>0);   
            system.assert(accProfWrp.size() > 0);
            
           }
    }
    
    public static testMethod void testgetGroupOptionList ()
    {
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
        //Creating Questions
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
         //creating  Account Profile records
        List<Account_Profile__c> accproff = TestClassHelper.CreateAccProfile(TestClassHelper.accSList[0].id,accques);
        update accproff;
        System.RunAs(SysAdminUser){
            test.startTest(); 
            List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            List<String> groupList = LtngCtrlSObjectAllProfile.getGroupOptionList(TestClassHelper.accSList[0].id, 'Account',accques[0].BST_SALESFORCE_GROUP__c);
            List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,categoryList[0],'All',true,true ,accques[0].BST_SALESFORCE_GROUP__c);
               
            accProfWrp.sort();
            test.stopTest();
            system.assert(accProfWrp.size() > 0);
        }
    }
    
    public static testMethod void testgetSubCategoryOptionList()
    {
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
        //Creating Questions
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
          //creating  Account Profile records
        List<Account_Profile__c> accproff = TestClassHelper.CreateAccProfile(TestClassHelper.accSList[0].id,accques);
        update accproff;
        System.RunAs(SysAdminUser)
        {
            List<String> subcategoryList = LtngCtrlSObjectAllProfile.getSubCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,subcategoryList[0],'All',true,true ,'HD');
            accProfWrp.sort();
            system.assert(accProfWrp.size() > 0);  
        }
    }
    
     public static testMethod void testgetSubCategoryOptionListElseloop()
    {
        test.startTest();
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(10);
        //Creating Questions
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
        System.RunAs(SysAdminUser)
        {
            List<String> subcategoryList = LtngCtrlSObjectAllProfile.getSubCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            
            List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectAllProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,'All',subcategoryList[0],true,false,'HD');
            accProfWrp.sort();
            system.assert(accProfWrp.size()==0);
            
                
        }
        
        test.stopTest();
    }
    
    public static testMethod void createQuestions(){
        
        quesList = TestClassHelper.createBioSurgQuestionRecs('BST_ACCOUNT_PROFILE_QUESTION');
        quesList1 = TestClassHelper.createBioSurgQuestionRecsWOCat('BST_ACCOUNT_PROFILE_QUESTION');
    }    

    
    public static testMethod void testgetAvailableReports(){
        
        List<Report> reportslist = LtngCtrlSObjectAllProfile.getAvailableReports();
        LtngCtrlSObjectAllProfile.getUIThemeDescription();
    }    
    /*
public static testMethod void testGetContactCategoryOptions_ReturnStringList(){

Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
//creating  Custom Settings
List<Global_Settings__c> ls = Test.loadData(Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
//creating  Contacts
TestClassHelper.creatBulkContact(10);


        /**
        *    Checking if there is no Question in the system
        *   
        */
    /*
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.contSList[0].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_NONE);
        }
    }
    */
    /*
   public static testMethod void testGetContactCategoryOptions_ReturnStringListWithQuestions(){
       //creating  Questions records
        createQuestions();
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
        //creating  Custom Settings
        List<Global_Settings__c> ls = Test.loadData(Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Contacts
        TestClassHelper.creatBulkContact(10);

        
        /**
        *    Checking if there is no Question in the system
        *   
        */
    /*  
    System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.contSList[0].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_NONE);
        }
    }
    */
    /*
    public static testMethod void testGetContactCategoryOptions_returnStringOfCategory_questionswithCategories(){
       //creating  Questions records
        createQuestions();
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
        //creating  Custom Settings
        List<Global_Settings__c> ls = Test.loadData(Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Contacts
        TestClassHelper.creatBulkContact(10);
        
        //creating  Contact Profile records
        List<Contact_Profile__c> contproff2 = TestClassHelper.CreateContProfile(TestClassHelper.contSList[2].id,quesList);
        
        
        
        /**
        *    Checking if there is no Question in the system
        *   
        */
        /*
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.contSList[2].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_ALL);
            
            List<ContactProfileWrapper> conProfWrp = LtngCtrlSObjectAllProfile.getContactIncrementCounter(TestClassHelper.contSList[2].id,categoryList[0]);
            
            system.assert(conProfWrp.size() > 0);
        }
        
     
    }
    */
    /*
    public static testMethod void testContactSaveResponse_returnString(){
       //creating  Questions records
        createQuestions();
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
        //creating  Custom Settings
        List<Global_Settings__c> ls = Test.loadData(Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Contacts
        TestClassHelper.creatBulkContact(10);
        
        //creating  Contact Profile records
        List<Contact_Profile__c> contproff2 = TestClassHelper.CreateContProfile(TestClassHelper.contSList[1].id,quesList1);
        
        
        
        /**
        *    Checking  if there is no Question in the system
        *   
        */
        /*
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectAllProfile.getCategoryOptionList(TestClassHelper.contSList[1].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_ALL);
            
            List<ContactProfileWrapper> conProfWrp = LtngCtrlSObjectAllProfile.getContactIncrementCounter(TestClassHelper.contSList[1].id,categoryList[0]);
            
            system.assert(conProfWrp.size() > 0);
        }
    }
    */
    /*
     static testmethod void method1(){
        account acc = new account();
        acc.name= 'nas';
        acc.BST_COUNTRY__c = 'Belgium';
        //acc.RecordType.Name = 'IMS Account';
        acc.BillingStreet = 'test street';
        acc.BillingCity = 'test city';
        acc.BillingPostalCode = '200110';
        acc.BillingCountry = 'test country';
        
        insert acc;
        RestRequest req = new RestRequest();                
        req.params.put('accountID', acc.Id);
        req.params.put('isFilterOnSFGroup', 'True');
        RestResponse res = new RestResponse();    
        RestContext.request = req;
        RestContext.response = res;
        
        AccountProfileQuestions.getQuestionsWithSavedResponses();
        AccountProfileQuestions.getQuesRespGroup(acc.Id,True,true,'HD','Access');
    }*/
}