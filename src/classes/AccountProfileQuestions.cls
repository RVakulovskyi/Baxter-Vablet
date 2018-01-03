/********************************************************************************
Apex Class Name - AccountProfileQuestions
Version - 1.0
Created Date - Sept 3, 2014
Function - Apex Class to get Account Profile Questions with Responses(for previously 
           saved responses)

Modification Log : 
--------------------------------------------------------------------------------

* Developer 
              Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/03/2014           Original Version
* Cognizant Developer     09/23/2015           Changes related to NAM
* Dharani Pothula         11/1/2016            Changed the getQuestion Method to detect Theme
                                               Holds multiselect options into answerOptionsCheckboxes wrapper class , to hold boolean selected
* Gaurav Jain           3/2 /2017              updated the getQuesRespGroup method by removing the condition based on theme
* Shikhar Srivastava    06/06/2017             Boost-Sprint1/Squad1
* Shashank Mehra         16/06/2017             Boost-Sprint2/Squad 1 
* Niharika Modi          21/06/2017             Boost-Sprint2/Squad 1  JIRA 111
* Niharika Modi           08/16/2017           Boost-R1/Sprint1/Squad1 JIRA 
* Shashank Mehra         17/08/2017            BOOST/Sprint 3/Squad 1
********************************************************************************/

//@RestResource(urlMapping='/QuestionsWithSavedAccountProfiles/*')
global class AccountProfileQuestions{

 /* code commented for Boost Squad 1 changes, because of no need of it for now.
  ***********
    global class QuestionsAndSavedResponsesClass{
        @AuraEnabled
        global String questionStatement;   
        @AuraEnabled
        global String questionlocale;    
        @AuraEnabled
        global String questionID;
        @AuraEnabled
        global String status;
        @AuraEnabled
        global String category;
        @AuraEnabled
        global String responseType; 
        @AuraEnabled
        global Boolean isDate;
        @AuraEnabled
        global Boolean isNumber;
        @AuraEnabled
        global Boolean isPicklist;
        @AuraEnabled
        global Boolean isMultiselect;
        @AuraEnabled
        global String salesforceGroup;
        @AuraEnabled
        global Integer order;
        @AuraEnabled
        global String accountID;
    @AuraEnabled        
        global String selectedAnswerPicklist;
        @AuraEnabled
        global String responseID;       
        @AuraEnabled
        global Date selectedDate;
        @AuraEnabled
        global Decimal selectedNumber;
        @AuraEnabled
        global List<String> answerOptionsStringList;
    @AuraEnabled        
        global List<String> selectedAnswersMultiselect;
        global QuestionsAndSavedResponsesClass(){}

    }
   */ 
    /**
    * Method Name: getQuestionsWithSavedResponses
    * Description: Method to get Questions with previously saved Account Profiles i.e. Responses
    * Parameter:   None
    * Return Type: List<QuestionsAndSavedResponsesClass>
    */
  /*
    @HttpGet
    global static List<QuestionsAndSavedResponsesClass> getQuestionsWithSavedResponses(){
        
        List<QuestionsAndSavedResponsesClass> quesSavedRespList = new List<QuestionsAndSavedResponsesClass>();
        String accountID = RestContext.request.params.get('accountID');
        String isFilterOnSFGroupString = RestContext.request.params.get('isFilterOnSFGroup');
        Boolean isFilterOnSFGroup = Boolean.valueOf(isFilterOnSFGroupString);
        
        List<Account> acctList = new List<Account>();                       
        acctList = [SELECT ID FROM Account WHERE ID = :accountID];
        
        if(acctList.isEmpty()){
            return quesSavedRespList; 
        }           
        
        accountID = AccountProfileQuestions.getParentMIIAccount(accountID);
        List<AccountProfileWrapper> acctProfWrpClassList = getQuesRespGroup(accountID, isFilterOnSFGroup,true,null,null);
   */
        /* passing true as third paramenter for Boost BU profile changes */
    /*    
        for(AccountProfileWrapper acctProfWrp  :acctProfWrpClassList){
            
            QuestionsAndSavedResponsesClass questSavedresp = new QuestionsAndSavedResponsesClass();
            
            questSavedresp.questionStatement = acctProfWrp.questionStatement;
            questSavedresp.questionlocale = acctProfWrp.questionlocale;  
            questSavedresp.questionID = acctProfWrp.questionID;
            questSavedresp.status = acctProfWrp.status;
            questSavedresp.category = acctProfWrp.category; 
            questSavedresp.responseType = acctProfWrp.responseType;    
            questSavedresp.isDate = acctProfWrp.isDate;
            questSavedresp.isNumber = acctProfWrp.isNumber;  
            questSavedresp.isPicklist = acctProfWrp.isPicklist;
            questSavedresp.isMultiselect = acctProfWrp.isMultiselect;
            questSavedresp.salesforceGroup = acctProfWrp.salesforceGroup;
            questSavedresp.order = acctProfWrp.order;
            questSavedresp.accountID = acctProfWrp.accountID;           
            questSavedresp.answerOptionsStringList = acctProfWrp.answerOptionsStringList;
            questSavedresp.SelectedAnswerPicklist = acctProfWrp.SelectedAnswerPicklist;
            questSavedresp.responseID = acctProfWrp.responseID;
            questSavedresp.selectedDate = acctProfWrp.proxyObj.BST_Selected_Date__c;
            questSavedresp.selectedNumber = acctProfWrp.proxyObj.BST_Selected_Number__c;            
            questSavedresp.selectedAnswersMultiselect = acctProfWrp.selectedAnswersMultiselect;
            
            
            quesSavedRespList.add(questSavedresp);
        }
        
        return quesSavedRespList;        
    }
    */

    /**
    * Method Name: getQuesRespGroup
    * Description: Method to return Questions and Account Profile records(for previously 
    *              saved responses) for an Account(the Account ID shared in the parameter).
    *              Another parameter needs to be passed as Boolean which will indicate whether filtering on groups
    *              will be applicable or not i.e. for All Account profile view
    * Parameter: String, Boolean                             
    * Return Type: List<AccountProfileWrapper>
    */
    @AuraEnabled
    public static List<AccountProfileWrapper> getQuesRespGroup(String accountID, Boolean isFilterOnSFGroup, Boolean selectedactiverecords, String selectedCategory, String selectedSubCategory,String baxterGroupAttribute){      
        final String RESPONSE_TYPE_DATE = 'Date';
        final String RESPONSE_TYPE_NUMBER = 'Number';
        final String RESPONSE_TYPE_PICKLIST = 'Picklist';
        final String RESPONSE_TYPE_MULTI_PICKLIST = 'Multi Picklist';
        final String RESPONSE_TYPE_TEXT = 'Text';
        final String RESPONSE_TYPE_ACCOUNT_LOOKUP = 'Account';
        final String RESPONSE_TYPE_CONTACT_LOOKUP = 'Contact';
        final String recordTypeId;
        final String STATUS;
        if(selectedactiverecords == false)
        {
            STATUS = 'Inactive';
        }else{
            STATUS = 'Active';
        }        
        String salesforceGroup = '';        
        List<Question__c> questionsList = new List<Question__c>();
        List<Question__c> updatedQuestionsList = new List<Question__c>();
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        
        String SELECTEDCOUNTRY = [SELECT ID, BST_COUNTRY__c FROM ACCOUNT WHERE ID = :accountID].BST_COUNTRY__c;
        
        /*** Getting current user's salesforce group from Group__c field of the User object **/
        List<String> salesforceGroupList = new List<String>();
      //  if(isFilterOnSFGroup){
      
      //Code to be commented for deployment---Start
      String userGroup = [SELECT ID,
                            BST_GroupOfUser__c
                            FROM User 
                            WHERE ID = :UserInfo.getUserId()].BST_GroupOfUser__c; 
      //Code to be commented for deployment---End  
     
      
        //Changes related to NAM
       
      //Code to be commented for deployment---Start 
      String allGroups = ('USMD'.equals(userGroup) || 'ACC'.equals(userGroup)) ?  
            BST_Global_Settings__c.getValues('Franchise ' + userGroup).BST_value__c : userGroup; 
     //Code to be commented for deployment---End  
         //salesforceGroupList = allGroups.split(';');
        
        //code to be commented for deployment---Start
        if(allGroups != null && allGroups.split(';').size() > 1){
            //Add all values, replacing ';' with ','
            salesforceGroup += allGroups.replace(';','\',\'');
            salesforceGroup = salesforceGroup.trim();
        }else if(allGroups != null){
            salesforceGroup = allGroups;
        }  
        //Code to be commented for deployment---End
        
        /*salesforceGroup = [SELECT ID,     
        Group__c 
        FROM User 
        WHERE ID = :UserInfo.getUserId()].Group__c;*/
       
            
       // }
        questionsList = new List<Question__c>();
        recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'BST_ACCOUNT_PROFILE_QUESTION'].Id;

        if(accountID != null && accountID != ''){
            
            
            
            /*** Getting questions list for the current user. Filter on salesforce group will be applied based on the parameter passed **/
            if(isFilterOnSFGroup){
                
                if(salesforceGroup != null && salesforceGroup != ''){
                    
                   String queryForMyProfileQuestions = 'SELECT BST_QUESTION_STATEMENT__c, BST_QUESTION_LOCALE__c,ID,BST_STATUS__c,BST_SALESFORCE_GROUP__c,BST_MAJOR_CATEGORY__c,BST_CATEGORY__c,BST_RESPONSE_TYPE__c,BST_ORDER__c,BST_ANSWER_OPTIONS__c, ';
                    queryForMyProfileQuestions += '(SELECT ID,BST_Account__c,BST_Selected_Picklist_Answer__c,BST_Selected_Date__c,BST_Selected_Number__c,BST_EXPIRED__c,BST_Selected_Multi_Answers__c,BST_Selected_TextArea__c,BST_Selected_Account__c,BST_Selected_Account__r.name FROM Account_Profiles__r WHERE BST_Account__c = \'' + accountID + '\' LIMIT 1)'; 
                    queryForMyProfileQuestions += ' FROM Question__c WHERE BST_SALESFORCE_GROUP__c INCLUDES (\'' + salesforceGroup +'\' ) AND BST_STATUS__c = \'' + STATUS + '\' AND BST_COUNTRY__c = \'' + SELECTEDCOUNTRY + '\' AND ';
                    queryForMyProfileQuestions += 'BST_RESPONSE_TYPE__c IN (\'' + RESPONSE_TYPE_DATE + '\', \'' + RESPONSE_TYPE_NUMBER + '\', \'' + RESPONSE_TYPE_PICKLIST + '\', \'' + RESPONSE_TYPE_MULTI_PICKLIST + '\', \'' + RESPONSE_TYPE_TEXT + '\', \'' + RESPONSE_TYPE_ACCOUNT_LOOKUP + '\' )';
                    if(selectedcategory == 'All' && selectedSubCategory == 'All'){
                        queryForMyProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' ORDER BY BST_ORDER__c';
                    }                      
                    else if(selectedcategory == 'All' && selectedSubCategory != 'All'){
                      queryForMyProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_CATEGORY__c = \'' + SELECTEDSUBCATEGORY + '\' ORDER BY BST_ORDER__c';
                    }
                    else if(selectedcategory != 'All' && selectedSubCategory == 'All'){
                      queryForMyProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_MAJOR_CATEGORY__c = \'' + SELECTEDCATEGORY + '\' ORDER BY BST_ORDER__c';
                    }
          else if(selectedcategory != 'All' && selectedSubCategory != 'All'){
                      queryForMyProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_MAJOR_CATEGORY__c = \'' + SELECTEDCATEGORY + '\' AND BST_CATEGORY__c = \'' + SELECTEDSUBCATEGORY + '\' ORDER BY BST_ORDER__c';
                    }
                    
                    /*questionsList = [SELECT 
                                        Question_Statement__c,
                                        ID,
                                        Status__c,
                                        Category__c,
                                        Response_Type__c,
                                        Salesforce_Group__c,
                                        Order__c,
                                        Answer_Options__c,
                                        (
                                            SELECT 
                                                    ID,
                                                    Account__c,                                                    
                                                    Selected_Picklist_Answer__c,
                                                    Selected_Date__c,
                                                    Selected_Number__c,
                                                    Selected_Multi_Answers__c
                                                    
                                                    FROM Account_Profiles__r
                                                    
                                                    WHERE Account__c =: accountID
                                                    
                                                    LIMIT 1
                                                     
                                        )
                                        
                                        FROM Question__c 
                                        
                                        WHERE 
                                                //Salesforce_Group__c INCLUDES ('PH','IV','EI','IN','RI','PI','NS','AC','DS','IC','OE')
                                                Salesforce_Group__c INCLUDES (:salesforceGroup)                                
                                                AND Status__c = :STATUS_ACTIVE
                                                AND Response_Type__c IN (:RESPONSE_TYPE_DATE, :RESPONSE_TYPE_NUMBER, :RESPONSE_TYPE_PICKLIST, :RESPONSE_TYPE_MULTI_PICKLIST) 
                                                AND RecordTypeId =: recordTypeId
                                        
                                        ORDER BY Order__c];*/
                        try{
                            questionsList = Database.query(queryForMyProfileQuestions);                            
                        }catch(DmlException dmlEx){
                            System.debug('DML EXCEPTION : ' + dmlEx.getMessage());
                        }
                        
                }
            }else{  // Filter for salesforce group has been added 
                               
                String queryForAllProfileQuestions = 'SELECT BST_QUESTION_STATEMENT__c,ID,BST_SALESFORCE_GROUP__c,BST_QUESTION_LOCALE__c,BST_STATUS__c,BST_MAJOR_CATEGORY__c,BST_CATEGORY__c, BST_RESPONSE_TYPE__c, BST_ORDER__c,BST_PRIVATE__c,BST_ANSWER_OPTIONS__c,';
                queryForAllProfileQuestions  += '(SELECT ID,BST_Account__c,BST_EXPIRED__c,BST_Selected_Picklist_Answer__c,BST_Selected_Date__c,BST_Selected_Number__c,BST_Selected_Multi_Answers__c,BST_Selected_TextArea__c,BST_Selected_Account__c,BST_Selected_Account__r.name FROM Account_Profiles__r WHERE BST_Account__c =: accountID LIMIT 1) FROM ';
                queryForAllProfileQuestions  += ' Question__c WHERE BST_STATUS__c = \'' + STATUS + '\' AND BST_COUNTRY__c = \'' + SELECTEDCOUNTRY + '\' AND ';
                queryForAllProfileQuestions += 'BST_RESPONSE_TYPE__c IN (\'' + RESPONSE_TYPE_DATE + '\', \'' + RESPONSE_TYPE_NUMBER + '\', \'' + RESPONSE_TYPE_PICKLIST + '\', \'' + RESPONSE_TYPE_MULTI_PICKLIST + '\', \'' + RESPONSE_TYPE_TEXT + '\', \'' + RESPONSE_TYPE_ACCOUNT_LOOKUP + '\')';
                //   questionsList = [
                
                if(selectedcategory == 'All' && selectedSubCategory == 'All' && baxterGroupAttribute =='All' && salesforceGroup != '' ){
                    //selectedcategory = '';
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_SALESFORCE_GROUP__c INCLUDES (\'' + salesforceGroup +  '\' ) ORDER BY BST_ORDER__c';
                }
                else if(selectedcategory == 'All' && selectedSubCategory == 'All' && baxterGroupAttribute =='All')
                {
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\'  ORDER BY BST_ORDER__c';
                }
                else if(selectedcategory == 'All' && selectedSubCategory == 'All' && baxterGroupAttribute !='All'){
                    //selectedcategory = '';
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_SALESFORCE_GROUP__c INCLUDES ( \'' + baxterGroupAttribute +  '\')  ORDER BY BST_ORDER__c';
                }else if(selectedcategory == 'All' && selectedSubCategory != 'All'){
                   // selectedcategory = '';
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId +'\' AND BST_SALESFORCE_GROUP__c INCLUDES (\'' + salesforceGroup +  '\' ) AND BST_CATEGORY__c = \'' + SELECTEDSUBCATEGORY + '\' ORDER BY BST_ORDER__c';
                }
                else if(selectedcategory != 'All' && selectedSubCategory == 'All'){
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_MAJOR_CATEGORY__c = \'' + SELECTEDCATEGORY + '\' AND BST_SALESFORCE_GROUP__c INCLUDES (\'' + salesforceGroup +  '\' ) ORDER BY BST_ORDER__c';
                }
                else if(selectedcategory != 'All' && selectedSubCategory != 'All'){
                    queryForAllProfileQuestions += ' AND RecordTypeId = \'' + recordTypeId + '\' AND BST_MAJOR_CATEGORY__c = \'' + SELECTEDCATEGORY + '\' AND BST_CATEGORY__c = \'' + SELECTEDSUBCATEGORY + '\' AND BST_SALESFORCE_GROUP__c INCLUDES (\'' + salesforceGroup +  '\' ) ORDER BY BST_ORDER__c';
                }
                
               questionsList = Database.query(queryForAllProfileQuestions);
              
               if(userGroup != null && userGroup.length() > 0){
                //Code to be commented for deployment ---Start
                    updatedQuestionsList = filterOnPrivateFlag(questionsList,userGroup); 
                    questionsList = updatedQuestionsList; 
                //Code to be commented for deployment ---End
                }
                
               
            }
                                                        
        }
        
        responseWrpList = new List<AccountProfileWrapper>();
        Integer quesNum = 1;
        
        for(Question__c ques: questionsList){
        
            AccountProfileWrapper res = new AccountProfileWrapper();

            res.questionStatement = ques.BST_QUESTION_STATEMENT__c;
            res.questionlocale =ques.BST_QUESTION_LOCALE__c;   
            res.questionID = ques.ID;
            res.status = ques.BST_STATUS__c;
            res.category = ques.BST_MAJOR_CATEGORY__c;
            res.subcategory = ques.BST_CATEGORY__c;
            res.responseType = ques.BST_RESPONSE_TYPE__c;
            res.salesforceGroup = ques.BST_SALESFORCE_GROUP__c;
            res.order = Integer.valueOf(ques.BST_ORDER__c);
            res.accountID = accountID;
            res.proxyObj = new Account_Profile__c();
            
            if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_DATE){
                
                res.isDate = true;
            }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_NUMBER){
            
                res.isNumber = true;
            }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_PICKLIST){
            
                res.isPicklist = true;
            }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_MULTI_PICKLIST){
            
                res.isMultiselect = true;
            }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_TEXT){
            
                res.isText = true;
            }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_ACCOUNT_LOOKUP){
            
                res.isAccountLookup = true;
            }
           
            
            /**
            *   Passing the Answer_Options__c field of Question__c object to convertStringToListSelectOptions method 
            *   to get the SelectOption(with '--None--' value added) for the Picklist Response Type
            *
            */
            if(ques.BST_ANSWER_OPTIONS__c != null && ques.BST_ANSWER_OPTIONS__c != '' && res.isPicklist){
                res.answerOptions = CommonStringConverterUtilities.convertStringToListSelectOptions(ques.BST_ANSWER_OPTIONS__c);
                //List is used in lightning
                res.answerOptionsStringList = CommonStringConverterUtilities.convertStringToListString(ques.BST_ANSWER_OPTIONS__c);
              
            }
            
            
            /**
            *   if the current question has a previously saved response, 
            *   the next block will fetch the that saved response according to the Response Type of the question
            *
            */
            if(!ques.Account_Profiles__r.isEmpty()){
                res.responseID = ques.Account_Profiles__r[0].ID;
                res.proxyObj.BST_EXPIRED__c = ques.Account_Profiles__r[0].BST_EXPIRED__c;
                res.isExpired = ques.Account_Profiles__r[0].BST_EXPIRED__c;
                
                if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_DATE){
                    
                    if(ques.Account_Profiles__r[0].BST_Selected_Date__c != null){
                        
                        res.proxyObj.BST_Selected_Date__c = ques.Account_Profiles__r[0].BST_Selected_Date__c;
                    }
                    
                }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_NUMBER ){
                
                    if(ques.Account_Profiles__r[0].BST_Selected_Number__c != null){
                    
                        res.proxyObj.BST_Selected_Number__c = ques.Account_Profiles__r[0].BST_Selected_Number__c;                    
                    }
                    
                }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_PICKLIST){
                    
                   if(ques.Account_Profiles__r[0].BST_Selected_Picklist_Answer__c != null && ques.Account_Profiles__r[0].BST_Selected_Picklist_Answer__c != ''){
                    
                        res.selectedAnswerPicklist = ques.Account_Profiles__r[0].BST_Selected_Picklist_Answer__c; 
                   }
                }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_MULTI_PICKLIST){
                
                    if(ques.Account_Profiles__r[0].BST_Selected_Multi_Answers__c != null && ques.Account_Profiles__r[0].BST_Selected_Multi_Answers__c != ''){
                                            
                        res.selectedAnswersMultiselect = CommonStringConverterUtilities.convertStringToListString(ques.Account_Profiles__r[0].BST_Selected_Multi_Answers__c);
                    }
                }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_TEXT ){
                
                    if(ques.Account_Profiles__r[0].BST_Selected_TextArea__c != null){
                    
                        res.proxyObj.BST_Selected_TextArea__c = ques.Account_Profiles__r[0].BST_Selected_TextArea__c;                    
                    }
                    
                }else if(ques.BST_RESPONSE_TYPE__c == RESPONSE_TYPE_ACCOUNT_LOOKUP ){
                    
                    if(ques.Account_Profiles__r[0].BST_Selected_Account__c != null){
                        res.proxyObj.BST_Selected_Account__c = ques.Account_Profiles__r[0].BST_Selected_Account__c; 
                        if(ques.Account_Profiles__r[0].BST_Selected_Account__r.name != null){
                           res.selectedaccountname = ques.Account_Profiles__r[0].BST_Selected_Account__r.name;
                        }
                        
                    }
                }
            }
            
            /**
            *   Passing the Answer_Options__c field of Question__c object to convertStringToListSelectOptionsMultiSelect method 
            *   to get the SelectOption(without '--None--' value) for the Multi Picklist Response Type
            *
            */
            if(ques.BST_ANSWER_OPTIONS__c != null && ques.BST_ANSWER_OPTIONS__c != '' && res.isMultiselect){
                res.answerOptionsMultiselect = CommonStringConverterUtilities.convertStringToListSelectOptionsMultiSelect(ques.BST_ANSWER_OPTIONS__c);
                
                //adds options list into the wrapper class to hold boolean,//List is used in lightning 
                res.answerOptionsStringList = CommonStringConverterUtilities.convertStringToListString(ques.BST_ANSWER_OPTIONS__c);
                set<string> selectedAnswersSet = new set<String>();
                selectedAnswersSet.addAll(res.selectedAnswersMultiselect);
                for(String answer : res.answerOptionsStringList){
                    if(answer != '--None--')
                        res.answerOptionCheckboxes.add(new AccountProfileWrapper.SelectOptionWrapper(answer, selectedAnswersSet.contains(answer)));
                }
            }
                        
            res.questionNumber = quesNum;
            quesNum++;
            responseWrpList.add(res);
        }
        
        return responseWrpList;
    
    }
    
  
   /*   Method Name: filterOnPrivateFlag
    *   Description: Method to update wrapper list based on Private flag  
    *   Parameter: List<Question__c>  ,salesforceGroup                           
    *   Return Type: List<Question__c>
    */ 
    @AuraEnabled
    public static List<Question__c> filterOnPrivateFlag(List<Question__c> questionList,String salesforceGroup){
    
        List<Question__c> updatedQuestionList = new List<Question__c>();
        Set<String> salesforceGroupSet = new Set<String>();
        for(String groupName : salesforceGroup.split(';')){
            salesforceGroupSet.add(groupName.trim());
        }
      //  salesforceGroupSet.addAll(salesforceGroup.split(';'));
        
        for(Question__c question : questionList){
            if(question.BST_PRIVATE__c){
                if(salesforceGroupSet.contains(question.BST_SALESFORCE_GROUP__c)){
                    updatedQuestionList.add(question);
                }
            }else{
                updatedQuestionList.add(question);
            }
             
        }
        return updatedQuestionList;
    } 
    
    /**
    * Method Name: getParentMIIAccount
    * Description: Searching if the JDE account has parent MII to
    *              associate the account profile records. If it's a JDE 
    *              account with no MII record then associating the account profile records with JDE.              
    * Parameter: String                             
    * Return Type: String
    */
    @AuraEnabled    
    public static String getParentMIIAccount(String accountID){
    
        /*String acctHierarchyToFilter = Global_Settings__c.getValues('ACCOUNT_PROFILE_ACCOUNT_HIERARCHY_TYPE').value__c;    
        List<Related_Account__c> relAcct = new List<Related_Account__c>();
        
        relAcct = [SELECT ID, 
                          Child_Account__c, 
                          Parent_Account__c 
                          
                          FROM Related_Account__c
                           
                          WHERE Child_Account__c = :accountID 
                          AND Hierarchy_Type__c = :acctHierarchyToFilter                          
                          
                          ];
                          
        if(!relAcct.isEmpty()){
            
            accountID = relAcct[0].Parent_Account__c;            
        
        }*/
        //Updated on 3/May/2015 for bug-656
        /*Account accMII = [SELECT id,IDN_MII_Facility__c from Account where id = :accountID];
        if( accMII.IDN_MII_Facility__c != null){
            accountID = accMII.IDN_MII_Facility__c;
        }*/
        
        return accountID;
    
    }

}