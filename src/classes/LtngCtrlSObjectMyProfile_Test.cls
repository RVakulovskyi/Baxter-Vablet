/********************************************************************************
Apex Class Name - LtngCtrlSObjectMyProfile_Test
Version - 1.0
Created Date - Nov 3rd, 2016
Function - Test class for  LtngCtrlSObjectMyProfile 
* Added test class fix 
Modification Log : 
--------------------------------------------------------------------------------
* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Dharani Pothula         11/03/2016           Original Version
* Gaurav Jain             11/15/2016           To Include Test Method for Contact Profiling Method    
********************************************************************************/

@isTest
public class LtngCtrlSObjectMyProfile_Test {
    
    public static List<Question__c> quesList;
    public static List<Question__c> quesList1;
    
    public static testMethod void testGetCategoryOptions_ReturnStringList(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        
        //creating  Accounts
       TestClassHelper.creatBulkAccount(1);
      
      //creating  Contacts
        //TestClassHelper.creatBulkContact(10);
        
      //  Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
      //  TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,'All','All');
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
        TestClassHelper.creatBulkAccount(1);
      //  Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
       // TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        //creating  Questions records without category
        List<Question__c> accques1 = TestClassHelper.createQuestionRecsWOCat();
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques1[0].BST_MAJOR_CATEGORY__c,accques1[0].BST_CATEGORY__c);
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE );
        }
    }
    
    public static testMethod void testGetCategoryOptions_returnStringOfCategory_questionswithCategories(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(1);
        //   Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
        // TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        //creating  Questions records with category
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
        //creating  Account Profile records
        List<Account_Profile__c> accproff = TestClassHelper.CreateAccProfile(TestClassHelper.accSList[0].id,accques);
        LtngCtrlSObjectMyProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,'Advanced Surgery','Baxter Data',true,true);
        
        /**
*    Checking AccountProfileMyController if there is no Question in the system
*   
*/
        System.RunAs(SysAdminUser){
            Test.startTest();
            List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            List<String> subcategoryList = LtngCtrlSObjectMyProfile.getSubCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
            
            system.assert(categoryList.size() == 2);
            system.assertEquals('Advanced Surgery', categoryList[1]);
            
            //List<AccountProfileWrapper> accProfWrp = LtngCtrlSObjectMyProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,categoryList[1],subcategoryList[1],true);
            
            //system.assert(accProfWrp.size() > 0);
            
        }
    }
    
    public static testMethod void testSaveResponse_returnString(){
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        
        //creating Bulk Accounts
        TestClassHelper.creatBulkAccount(1);
        //creating  Questions records with category
        List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
     //   Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
        //Creating Account With Billing Type
        Account newAccountBillType =TestClassHelper.createAccountWithBillingType('Belgium','487');
        


        //Creating Account
        Account newAccount=TestClassHelper.creatAccount();  
        
        
      //  TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        System.RunAs(SysAdminUser){
            Test.startTest();
            
            String json = '[{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[],"answerOptionsStringList":[],"category":"PD","isDate":true,"isMultiselect":false,"isNumber":false,"isPicklist":false,"proxyObj":{"BST_Selected_Date__c":"2017-06-14"},"questionID":"' +accques[0].id + '"' + ',"questionNumber":1,"questionStatement":"RBL_Question Statement2_What the End date of this Question?","responseID":"","responseType":"Date","salesforceGroup":"AC","SelectedAnswerPicklist":"","selectedAnswersMultiselect":[],"status":"Active","subcategory":"BioSurgery","isExpired":true,"sValues":{}},';           
            json += '{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[],"answerOptionsStringList":[],"category":"PD","isDate":false,"isMultiselect":false,"isNumber":true,"isPicklist":false,"proxyObj":{"BST_Selected_Number__c":23},"questionID":"' +accques[2].id + '"' + ',"questionNumber":2,"questionStatement":"RBl_Question_Story89_Q2","responseID":"","responseType":"Number","salesforceGroup":"AC","SelectedAnswerPicklist":"","selectedAnswersMultiselect":[],"status":"Active","subcategory":"Drug Delivery","sValues":{}},';
            json += '{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[{"answerOption":"Rubel","selected":true},{"answerOption":"Sunder","selected":true}],"answerOptionsStringList":["--None--","Rubel","Sunder"],"category":"HD","isDate":false,"isMultiselect":true,"isNumber":false,"isPicklist":false,"order":3,"proxyObj":{},"questionID":"' +accques[1].id + '"' + ',"questionNumber":10,"questionStatement":"RBL_Acc Qstn Statement1_613_Who all are in Baxter Testing Team","responseID":"","responseType":"Multi Picklist","salesforceGroup":"AC","SelectedAnswerPicklist":"--None--","selectedAnswersMultiselect":[],"status":"Active","subcategory":"Account","sValues":{}},';
            json += '{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[],"answerOptionsStringList":["--None--","Test1","Test2"],"category":"PD","isDate":false,"isMultiselect":false,"isNumber":false,"isPicklist":true,"order":2,"proxyObj":{},"questionID":"' +accques[3].id + '"' + ',"questionNumber":8,"questionStatement":"RBL_QSTN1_USRstry89_Child","responseID":"","responseType":"Picklist","salesforceGroup":"AC;DS","SelectedAnswerPicklist":"Test1","selectedAnswersMultiselect":[],"status":"Active","subcategory":"Drug Delivery","sValues":{}}]';           
            
            
            
            //string json = '[{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[{"answerOption":"Bariatric","selected":false}]}]';
            system.debug('JSON'+json);
            string resMessage = LtngCtrlSObjectMyProfile.saveResponse(json, 'Account');
         //   AccountProfileResponse.RequestAccountProfileUpsertClass innserclsobj = new AccountProfileResponse.RequestAccountProfileUpsertClass();
         //   AccountProfileResponse.upsertAccountProfiles(innserclsobj);
            system.assert(resMessage == System.Label.BST_ACCOUNT_PROFILE_SAVE_SUCCESS_MESSAGE);
        }
    }
    
    public static testMethod void testSaveResponseAndReturn_returnString(){
        system.debug('JSON');
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        //creating  Custom Settings
        List<sObject> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Accounts
        TestClassHelper.creatBulkAccount(1);
         List<Question__c> accques = TestClassHelper.CreateQuestionRecs();
     //   Related_Account__c relAcc = TestClassHelper.CreateRelatedAccount(TestClassHelper.accSList[1].id,TestClassHelper.accSList[0].id,'JDE - MII Facility');
        
      //  TestClassHelper.updateAccountWithMII(TestClassHelper.accSList[0], TestClassHelper.accSList[1]);
        
        /**
        *    Checking AccountProfileMyController if there is no Question in the system
        *   
        */
        
        System.RunAs(SysAdminUser){
            Test.startTest();
            String json = '[{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[],"answerOptionsStringList":[],"category":"HD","isDate":false,"isMultiselect":false,"isNumber":true,"isPicklist":false,"order":1,"proxyObj":{"BST_Selected_Number__c":10},"questionID":"' +accques[0].id + '"' + ',"questionNumber":1,"questionStatement":"How many bed are there","responseID":"","responseType":"Number","salesforceGroup":"AC;DS","SelectedAnswerPicklist":"","selectedAnswersMultiselect":[],"status":"Active","subcategory":"150 mL Customer Information","sValues":{}}]';
           // string json = '[{"accountID":"' +TestClassHelper.accSList[0].id + '"' + ',"answerOptionCheckboxes":[{"answerOption":"Bariatric","selected":false}]}]';
            system.debug('JSON'+json);
            string resMessage = LtngCtrlSObjectMyProfile.saveResponseIntermediately(json, 'Account');
            system.assert(resMessage == System.Label.BST_ACCOUNT_PROFILE_SAVE_SUCCESS_MESSAGE);
            Test.stopTest();
       }
    }
    /**
    * Method Name: createGlobalSettings
    * Description: Create Global Settings custom setting helper data
    */ 
        public static testMethod void createglobalsettings_ReturnString (){
        Test.startTest();
        TestClassHelper.createGlobalSettings('testname1','testvalue1') ;
        Test.stopTest ();
        }
    /** 
    * Method Name: getUIThemeDescription_ReturnString
    * Description: Checks for the current Theme 
    * Parameter: None                             
    * Return Type: String
    */
    public static testMethod void getUIThemeDescription_ReturnString(){
     
        String theme = LtngCtrlSObjectMyProfile.getUIThemeDescription();
        
        system.assert(!string.isBlank(theme));
        
    }
    
    
    public static testMethod void createQuestions(){
        quesList = TestClassHelper.createBioSurgQuestionRecs('BST_CONTACT_PROFILE_QUESTION');
        quesList1 = TestClassHelper.createBioSurgQuestionRecsWOCat('BST_CONTACT_PROFILE_QUESTION');
    }    
    
    public static testMethod void getuserlanguage_test()    
    {
         
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'HD');
        System.RunAs(SysAdminUser){
             Test.startTest();                 
                 TestClassHelper.creatBulkAccount(1);
                 system.assert(TestClassHelper.accSList.size()>0);
                 List<Question__c> accques = TestClassHelper.createQuestionRecsWOCat();
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,'All','All');
                List<String> subcategoryList = LtngCtrlSObjectMyProfile.getSubCategoryOptionList(TestClassHelper.accSList[0].id, 'Account',true,accques[0].BST_MAJOR_CATEGORY__c,accques[0].BST_CATEGORY__c);
             LtngCtrlSObjectMyProfile.getuserlanguage();
            LtngCtrlSObjectMyProfile.getAccountIncrementCounter(TestClassHelper.accSList[0].id,'HD','Access',true,true);
            LtngCtrlSObjectMyProfile.getAvailableReports();
            Test.stopTest();
           
           //LtngCtrlSObjectMyProfile.getAccountIncrementCounter();
        }
    }
    
    
    /*
    public static testMethod void testGetContactCategoryOptions_ReturnStringList(){
        
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
        //creating  Custom Settings
        List<BST_Global_Settings__c> ls = Test.loadData(BST_Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Contacts
        TestClassHelper.creatBulkContact(10);
        
  */
        /**
        *    Checking if there is no Question in the system
        *   
        */
    /*
        System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.contSList[0].id, 'Contact');
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
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.contSList[0].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_ALL);
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
        List<Contact_Profile__c> contproff2 = TestClassHelper.CreateContProfile(TestClassHelper.contSList[2].id,quesList1);
        
        
        */
        /**
        *    Checking if there is no Question in the system
        *   
        */
        /*
      System.RunAs(SysAdminUser){
            Test.startTest();
                List<String> categoryList = LtngCtrlSObjectMyProfile.getCategoryOptionList(TestClassHelper.contSList[1].id, 'Contact');
            Test.stopTest();
            
            system.assert(categoryList[0] == System.Label.CONTACT_PROFILE_PICKLIST_ALL);
            
            List<ContactProfileWrapper> conProfWrp = LtngCtrlSObjectMyProfile.getContactIncrementCounter(TestClassHelper.contSList[1].id,categoryList[0]);
            
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
        List<Contact_Profile__c> contproff2 = TestClassHelper.CreateContProfile(TestClassHelper.contSList[2].id,quesList1);
        
        
        
        /**
        *    Save Responses
        *   
        */
        /*
      System.RunAs(SysAdminUser){
            Test.startTest();
                string json = '[{"contactID":"' +TestClassHelper.contSList[1].id + '"' + ',"answerOptionCheckboxes":[{"answerOption":"Bariatric","selected":false}]}]';
            system.debug(json);
            string resMessage = LtngCtrlSObjectMyProfile.saveResponse(json, 'Contact');
            system.assert(resMessage == System.Label.CONTACT_PROFILE_SAVE_SUCCESS_MESSAGE);
            Test.stopTest();
        }
    }
    */
        /*
    public static testMethod void testContactSaveResponseAndReturn_returnString(){
        //creating  Questions records
        createQuestions();
        Profile profSysAdm = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'];
        User SysAdminUser = TestClassHelper.CreatUser(profSysAdm.id,'SysAdm', 'OS');        
        //creating  Custom Settings
        List<Global_Settings__c> ls = Test.loadData(Global_Settings__c.sObjectType, 'ApexTestClassDataLoad_Global_Settings');
        //creating  Contacts
        TestClassHelper.creatBulkContact(10);
        
        //creating  Contact Profile records
        List<Contact_Profile__c> contproff2 = TestClassHelper.CreateContProfile(TestClassHelper.contSList[2].id,quesList1);
        
        
        
        /**
        *    save response immediatly
        *   
        */
        /*
      System.RunAs(SysAdminUser){
            Test.startTest();
                string json = '[{"contactID":"' +TestClassHelper.contSList[1].id + '"' + ',"answerOptionCheckboxes":[{"answerOption":"Bariatric","selected":false}]}]';
                system.debug(json);
                string resMessage = LtngCtrlSObjectMyProfile.saveResponseIntermediately(json, 'Contact');
                system.assert(resMessage == System.Label.CONTACT_PROFILE_SAVE_SUCCESS_MESSAGE);
            Test.stopTest();
            
        }
        
    }
   */
   
}