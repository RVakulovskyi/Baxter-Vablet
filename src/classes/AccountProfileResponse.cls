/********************************************************************************
Apex Class Name - AccountProfileResponse
Version - 1.0
Created Date - Sept 3, 2014
Function - Apex Class to get the Account Profile responses against the questions   

Modification Log :  
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/03/2014           Original Version
* Dharani   Pothula       11/02/2016           Updated GetResponse method, if multiselect is selected, 
                                               it clears the existing list of selectedAnswersMultiselect and updates it with selected answers
                                               from answerOptionCheckboxes wrappper class
* Gaurav Jain		      03/02/2016		   Removed the updated code in GetResponse for lightning
* Shikhar Srivastava	  06/06/2017           Boost-Sprint1/Squad1           
* Niharika Modi     	  07/20/2017           Jira   470         
* Niharika Modi           08/16/2017           Boost-R1/Sprint1/Squad1 JIRA 
********************************************************************************/

//@RestResource(urlMapping='/AccountProfileSave/*')
global class AccountProfileResponse{

/*  code commented for Boost Squad 1 changes, because of no need of it for now.
    global class RequestAccountProfileUpsertClass{
                               
        global String accountID;
        global List<AccountProfileClass> accountProfileList;
        
    }
    
    global class AccountProfileClass{

        global String questionID;       
        global Date selectedDate;
        global Decimal selectedNumber;
        global String selectedAnswerPicklist;
        global List<String> selectedAnswersMultiselect;
    }

  */  
    /**
    * Method Name: upsertAccountProfiles
    * Description: Method to upsert Account Profiles and it returns the success/failure message 
    * Parameter:   RequestAccountProfileUpsertClass
    * Return Type: String 
    */
   /* 
    @HttpPatch 
    global static String upsertAccountProfiles(RequestAccountProfileUpsertClass accountProfilesToSave){  
                
        Map<String, String> questionRespTypeMap = new Map<String, String>();
        Map<String, String> questionAcctProfIdMap = new Map<String, String>();
        Set<String> questionIdSet = new Set<String>();
        
        
        
        if(accountProfilesToSave != null && accountProfilesToSave.accountID != null && accountProfilesToSave.accountID != '' && accountProfilesToSave.accountProfileList != null && !accountProfilesToSave.accountProfileList.isEmpty()){
            
            
            String accountID = accountProfilesToSave.accountID;
            
            List<Account> acctList = new List<Account>();                       
            acctList = [SELECT ID FROM Account WHERE ID = :accountID];
            
            if(acctList.isEmpty()){
            
                return System.Label.BST_ACCOUNT_PROFILE_REST_API_ERROR_MSG_INVALID_ACCOUNT_ID;
            }
            
            accountID = AccountProfileQuestions.getParentMIIAccount(accountID);
            
            for(AccountProfileClass acctPrfObj : accountProfilesToSave.accountProfileList){
            
                questionIdSet.add(acctPrfObj.questionID);
            }
            
            if(questionIdSet != null && !questionIdSet.isEmpty()){
                
                List<Question__c> questList = new List<Question__c>();
                List<Account_Profile__c> acctPrfList = new List<Account_Profile__c>();
                
                questList = [SELECT ID, 
                                    BST_RESPONSE_TYPE__c 
                                    
                                    FROM Question__c
                                    
                                    WHERE ID IN :questionIdSet
                                    ];
                
                if(questList != null && !questList.isEmpty()){
                
                    for(Question__c ques : questList){
                        
                        questionRespTypeMap.put(ques.ID, ques.BST_RESPONSE_TYPE__c);
                        
                    }
                    
                    
                    acctPrfList = [SELECT ID,
                                          BST_Account__c,
                                          BST_Question__c
                                          
                                          FROM Account_Profile__c
                                          
                                          WHERE BST_Account__c = :accountID
                                          AND BST_Question__c IN :questionRespTypeMap.keySet()
                                          ];
                    
                    if(acctPrfList != null && !acctPrfList.isEmpty()){
                    
                        for(Account_Profile__c acctPrfl : acctPrfList){
                            
                            questionAcctProfIdMap.put(acctPrfl.BST_Question__c, acctPrfl.ID);
                            
                        }
                    
                    }
                    
                    List<AccountProfileWrapper> acctPrfWrpList = new List<AccountProfileWrapper>();
                    
                    for(AccountProfileClass acctPrfObj : accountProfilesToSave.accountProfileList){
                        
                        if(questionRespTypeMap.containsKey(acctPrfObj.questionID)){
                            
                            AccountProfileWrapper acctPrfWrpObj = new AccountProfileWrapper();
                            
                            acctPrfWrpObj.accountID = accountID;
                            acctPrfWrpObj.QuestionID = acctPrfObj.questionID;
                            acctPrfWrpObj.ResponseType = questionRespTypeMap.get(acctPrfObj.questionID);
                            if(acctPrfObj.selectedDate != null){
                                acctPrfWrpObj.proxyObj = new Account_Profile__c();
                                acctPrfWrpObj.proxyObj.BST_Selected_Date__c = acctPrfObj.selectedDate;
                            }
                            if(acctPrfObj.selectedNumber != null){
                                acctPrfWrpObj.proxyObj = new Account_Profile__c();
                                acctPrfWrpObj.proxyObj.BST_Selected_Number__c = acctPrfObj.selectedNumber;
                                
                            }                           
                            acctPrfWrpObj.SelectedAnswerPicklist = acctPrfObj.selectedAnswerPicklist;
                            acctPrfWrpObj.SelectedAnswersMultiselect = acctPrfObj.selectedAnswersMultiselect;
                            
                            if(questionAcctProfIdMap.containsKey(acctPrfObj.questionID)){
                                
                                acctPrfWrpObj.ResponseID = questionAcctProfIdMap.get(acctPrfObj.questionID);
                            }
                            
                            acctPrfWrpList.add(acctPrfWrpObj);
                        }
                        
                    }
                    
                    if(!acctPrfWrpList.isEmpty()){
                        
                        List<Account_Profile__c> accountProfileUpsertList = new List<Account_Profile__c>();
                        accountProfileUpsertList = getResponses(acctPrfWrpList);
                        
                        return saveAccountProfiles(accountProfileUpsertList);
                        
                    }else{
                    
                        return System.Label.BST_ACCOUNT_PROFILE_REST_API_ERROR_MSG_EMPTY_ACCOUNT_PROFILE_LIST;
                    }
                    
                
                }else{
                
                    return System.Label.BST_ACCOUNT_PROFILE_REST_API_ERROR_MSG_INVALID_QUESTION_ID;
                }
                
                                    
                
            
            
            }else{
            
                return System.Label.BST_ACCOUNT_PROFILE_REST_API_ERROR_MSG_NO_QUESTION_ID;
            }
            
        }else{
        
            return System.Label.BST_ACCOUNT_PROFILE_REST_API_ERROR_MSG_INVALID_INPUT;
        
        }
        
        
        
    }
    */
    
    /**
    *   Method Name: getResponses
    *   Description: Method to return Account Profile records that are answered in the current page   
    *   Parameter: List<AccountProfileWrapper>                             
    *   Return Type: List<Account_Profile__c>
    */
    
    public static List<Account_Profile__c> getResponses(List<AccountProfileWrapper> responseWrpList){
        List<Account_Profile__c> responseList = new List<Account_Profile__c>();
        final String DELIMITER = '~##~'; 
        final String RESPONSE_TYPE_DATE = 'Date';
        final String RESPONSE_TYPE_NUMBER = 'Number';
        final String RESPONSE_TYPE_PICKLIST = 'Picklist';
        final String RESPONSE_TYPE_MULTI_PICKLIST = 'Multi Picklist';
        final String RESPONSE_TYPE_TEXT = 'Text';
        final String RESPONSE_TYPE_ACCOUNT_LOOKUP = 'Account';
    	
        for(AccountProfileWrapper respWrp : responseWrpList){
         
                   Account_Profile__c resp = new Account_Profile__c();
                   if(respWrp.isExpired != null){
                       respWrp.isExpired = false;
                       resp.BST_EXPIRED__c = respWrp.isExpired;
                   }
                  
                   resp.BST_Account__c = respWrp.AccountID ;
                   resp.BST_Question__c = respWrp.QuestionID;
                   if(respWrp.ResponseType == RESPONSE_TYPE_DATE){
                       resp.BST_Selected_Date__c = respWrp.proxyObj.BST_Selected_Date__c;
                       
                   }else if(respWrp.ResponseType == RESPONSE_TYPE_NUMBER){
                       resp.BST_Selected_Number__c	=	respWrp.sValues.selectedNumber;
                       resp.BST_Selected_Number__c = respWrp.proxyObj.BST_Selected_Number__c;
                       
                   }else if(respWrp.ResponseType == RESPONSE_TYPE_PICKLIST){
                       
                       resp.BST_Selected_Picklist_Answer__c = respWrp.SelectedAnswerPicklist;
                       
                   }else if(respWrp.ResponseType == RESPONSE_TYPE_MULTI_PICKLIST){
                       
                       String Multi_answer = '';                  
                       
                       for(String selectedAns : respWrp.SelectedAnswersMultiselect){
                           
                           if(Multi_answer == ''){
                               
                               Multi_answer = selectedAns;
                           }else{
                               
                               Multi_answer = Multi_answer + DELIMITER + selectedAns;
                           }
                           
                       }
                       
                       resp.BST_Selected_Multi_Answers__c = Multi_answer;
                   }else if(respWrp.ResponseType == RESPONSE_TYPE_TEXT){
                       resp.BST_Selected_TextArea__c = respWrp.proxyObj.BST_Selected_TextArea__c;
                       
                   }else if(respWrp.ResponseType == RESPONSE_TYPE_ACCOUNT_LOOKUP){ 
                       resp.BST_Selected_Account__c = respWrp.proxyObj.BST_Selected_Account__c;
                   }
                   
                   if(respWrp.ResponseID != null && respWrp.ResponseID != ''){
                       
                       resp.ID = respWrp.ResponseID;
                       responseList.add(resp);
                       
                   }else{
                       
                       responseList.add(resp);
                       
                   }
        }
        
        return responseList;
    }
    
    
    /**
    * Method Name: saveAccountProfiles
    * Description: upserting the incoming List of Account Profile and returning 
    *              success message or failure message based on the outcome.                            
    * Parameter: List<Account_Profile__c>                             
    * Return Type: String
    */
    public static String saveAccountProfiles(List<Account_Profile__c> accountProfileList){
    
        if(accountProfileList != null && !accountProfileList.isEmpty()){
            
            try{
                
                upsert accountProfileList;
                return System.Label.BST_ACCOUNT_PROFILE_SAVE_SUCCESS_MESSAGE ;
                
            }catch(Exception ex){
                          
                return ''+ex;
                
            }
        }else
        
            return System.Label.BST_ACCOUNT_PROFILE_NO_RESPONSE;
    }
    
}