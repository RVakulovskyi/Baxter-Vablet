/********************************************************************************
Apex Class Name - ClsAccountDetailsUtility
Version - 1.0
Created Date - Oct 31st, 2016
Function - Utility Class used to hold or pull generic account details , this can be reused in other classes

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Dharani Pothula         10/31/2016           Original Version
* Gaurav Jain             12/1/2016            getAccountFromOpp to get account details
* Gaurav Jain             3/2 /2017           updated the method for saving the profile question/answers
* Shikhar Srivastava      06/06/2017           Boost-Sprint1/Squad1
* Shashank Mehra          14/08/2017           BOOST -Sprint3/Squad1
********************************************************************************/

public class ClsAccountDetailsUtility {
    
     /**
    * Method Name: getAccount
    * Description: Method to get Current Account
    * Parameter: None                             
    * Return Type: Account
    */
    public static Account getAccount(Id accountId){
        return [Select  Id, 
                        Name, 
                        BST_Account_Number__c, 
                        BST_Bill_To_Account_Number__c, 
                        BST_Class_Code__c, 
                        BST_Billing_Type__c, 
                        Type,
                        ShippingStreet ,
                        ShippingCity, 
                        ShippingState,
                        ParentId,
                        BST_PROFILING_REQUIRED__c
                from    Account 
                where   Id =: accountId];
    }
    
    /**
    * Method Name: getAccountFromOpp
    * Description: Method to get Current Account
    * Parameter: None                             
    * Return Type: Account
    */
    public static Account getAccountFromOpp(Id oppId){
        Opportunity opp =  [Select Id, 
                                   accountId, 
                                   account.Name, 
                                   account.BST_Account_Number__c 
                            From opportunity 
                            where   Id =: oppId];
        if(opp != null && opp.accountId != null)
            return opp.Account;
        else
            return null;
    }
    
    /**
    * Method Name: getUIThemeDescription
    * Description: Method to get Current Theme
    * Parameter: None                             
    * Return Type: String
    */
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }    
    
    /**
    *   Method Name: saveAccountMyProfileResponse
    *   Description: Method to save Account Profiles for an Account and go to the account detail page 
    *   Parameter: None                             
    *   Return Type: string
    */
    @AuraEnabled
    public  static string saveAccountMyProfileResponse(string  responseJson){
        string message;
        final String RESPONSE_TYPE_MULTI_PICKLIST = 'Multi Picklist';
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<Account_Profile__c> responseList = new List<Account_Profile__c>();
       
        responseWrpList = getAccountParsedJson(responseJson);
        
        /**
        *   Passing the questions and the responses in the AccountProfileWrapper and getting
        *   Account_Profile__c list to be upserted
        *   
        */
        try{
            system.debug('****response wrap ***'+responseWrpList);
            for(AccountProfileWrapper respWrp : responseWrpList){
                if(respWrp.ResponseType == RESPONSE_TYPE_MULTI_PICKLIST){
                    //clear the list and add selected options  
                    respWrp.SelectedAnswersMultiselect.clear();
                    //lightning component , to move the selected option list to original list
                    for(AccountProfileWrapper.SelectOptionWrapper option : respWrp.answerOptionCheckboxes){
                        if(option.selected){
                            respWrp.SelectedAnswersMultiselect.add(option.answerOption);
                        }
                        
                    }
                }
            }
            responseList = AccountProfileResponse.getResponses(responseWrpList);
        
        }catch(exception ex){
           
           throw new CustomException('Review the error message :'+ ex.getMessage());
        }
        
        try{
        
        message = AccountProfileResponse.saveAccountProfiles(responseList); 
        
            if(message == System.Label.BST_ACCOUNT_PROFILE_SAVE_SUCCESS_MESSAGE){ 
           
                return message;
            }
        }catch(Exception ex){
            throw new CustomException('Review the error message :'+ ex.getMessage());
        }
        
        return message;
    }
    
    /**
    *   Method Name: saveAccountMyProfileResponseIntermediately
    *   Description: Method to save Account Profiles for an Account and stay on the same page 
    *   Parameter: string                             
    *   Return Type: Stringk
    */
    @AuraEnabled
    public static String saveAccountMyProfileResponseIntermediately(string responseJson){
        string message;
        final String RESPONSE_TYPE_MULTI_PICKLIST = 'Multi Picklist';
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<Account_Profile__c> responseList = new List<Account_Profile__c>();
      
        responseWrpList = getAccountParsedJson(responseJson);
        
        /**
        *   Passing the questions and the responses in the AccountProfileWrapper and getting
        *   Account_Profile__c list to be upserted
        *   
        */
        try{
            for(AccountProfileWrapper respWrp : responseWrpList){
                if(respWrp.ResponseType == RESPONSE_TYPE_MULTI_PICKLIST){
                    //clear the list and add selected options  
                    respWrp.SelectedAnswersMultiselect.clear();
                   //lightning component , to move the selected option list to original list
                    for(AccountProfileWrapper.SelectOptionWrapper option : respWrp.answerOptionCheckboxes){
                        if(option.selected){
                            respWrp.SelectedAnswersMultiselect.add(option.answerOption);
                        }
                        
                    }
                }
            }
            responseList = AccountProfileResponse.getResponses(responseWrpList);
            
        }catch(exception ex){
        
            throw new CustomException('Review the error message :'+ ex.getMessage());
        }
        
        try{
        message = AccountProfileResponse.saveAccountProfiles(responseList); 
        
            if(message == System.Label.BST_ACCOUNT_PROFILE_SAVE_SUCCESS_MESSAGE){ 
    
                return message;
            }
        }catch(exception ex){
            throw new CustomException('Review the error message :'+ ex.getMessage());
        }
        
        return message;
    }
    
    /**
    *   Method Name: getAccountMyProfileCategoryOptionList
    *   Description: Method to populate the CategoryOptions  
    *   Parameter: AccountId                             
    *   Return Type: List<String>
    */ 
    @AuraEnabled
    public static List<String> getAccountMyProfileCategoryOptionList(Id accountId, Boolean selectedactiverecords, String selectedCategory, String selectedSubCategory){
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<String> categoryOptionList = new List<String>();
        Set<String> categorySet = new Set<String>();
        
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
        
        /**
        *   Passing Account Id and a Boolean value as true to getQuesRespGroup method for 
        *   getting all questions filtered by Salesforce Group of the current user and 
        *   also getting the previously saved responses in the AccountProfileWrapper
        *   
        */
        responseWrpList = AccountProfileQuestions.getQuesRespGroup(acctID,True,selectedactiverecords,selectedCategory,selectedSubCategory,'');
        
        /** 
        *   if there is no questions assigned for the current user's group, 
        *   the button will not appear on the page
        *
        */
        if(!responseWrpList.isEmpty()){
            
            for(AccountProfileWrapper respWrp: responseWrpList){
            
                if(respWrp.category != null && respWrp.category != ''){
                    
                    categorySet.add(respWrp.category);
                     
                }
                
            
            }
            
            if(!categorySet.isEmpty()){
                
                categoryOptionList = new List<String>();
                categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                for(String category : categorySet){
                
                    categoryOptionList.add(category);
                
                }
              
              //  selectedCategory = picklistAll;
            }else{
            
                categoryOptionList = new List<String>();
                categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                 
             //   selectedCategory = picklistAll;
            }
            
        }else{
            
            categoryOptionList = new List<String>();
            categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
             
          //  selectedCategory = picklistNone;
        }
        
        return categoryOptionList;
    }
    
    
        @AuraEnabled
    public static List<String> getAccountMyProfileSubCategoryOptionList(Id accountId, Boolean selectedactiverecords,String selectedCategory, String selectedSubCategory){
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<String> SubcategoryOptionList = new List<String>();
        Set<String> SubcategorySet = new Set<String>();
        
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
        
        /**
        *   Passing Account Id and a Boolean value as true to getQuesRespGroup method for 
        *   getting all questions filtered by Salesforce Group of the current user and 
        *   also getting the previously saved responses in the AccountProfileWrapper
        *   
        */
        responseWrpList = AccountProfileQuestions.getQuesRespGroup(acctID, True,selectedactiverecords,selectedCategory,selectedSubCategory,'');
        
        /** 
        *   if there is no questions assigned for the current user's group, 
        *   the button will not appear on the page
        *
        */
        
        if(!responseWrpList.isEmpty()){
            
            for(AccountProfileWrapper respWrp: responseWrpList){
        
                if(respWrp.Subcategory != null && respWrp.Subcategory != ''){
                    
                    SubcategorySet.add(respWrp.Subcategory);
                }
                
            
            }
            
            if(!SubcategorySet.isEmpty()){
                
                SubcategoryOptionList = new List<String>();
                SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                for(String Subcategory : SubcategorySet){
                
                    SubcategoryOptionList.add(Subcategory);
                
                }
                
              //  selectedCategory = picklistAll;
            }else{
            
                SubcategoryOptionList = new List<String>();
                SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                
             //   selectedCategory = picklistAll;
            }
            
        }else{
            
            SubcategoryOptionList = new List<String>();
            SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
          //  selectedCategory = picklistNone;
        }
        
        return SubcategoryOptionList;
    }
    
     /**
    * Method Name: getAccountAllProfileSubCategoryOptionList
    * Description: Method to populate Sub categories in All Profile tab.
    * Parameter:   AccountId                            
    * Return Type: List<String>
    * Added by : Shashank Mehra (17-Aug-2017)
    */
    
    
    @AuraEnabled
        public static List<String> getAccountAllProfileSubCategoryOptionList(Id accountId, Boolean selectedactiverecords,String selectedCategory, String selectedSubCategory)
        {
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<String> SubcategoryOptionList = new List<String>();
        Set<String> SubcategorySet = new Set<String>();
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
        responseWrpList = AccountProfileQuestions.getQuesRespGroup(acctID, True,selectedactiverecords,selectedCategory,selectedSubCategory,'All');
            if(!responseWrpList.isEmpty())
            {
                Integer questionCounter = 1;
                System.debug('responseWrpList='+responseWrpList);
                for(AccountProfileWrapper respWrp: responseWrpList)
                {
                    if(respWrp.responseID != null && respWrp.responseID !='' && 
                   (respWrp.proxyObj.BST_Selected_Date__c != null ||
                    respWrp.proxyObj.BST_Selected_Number__c != null ||
                    respWrp.proxyObj.BST_Selected_TextArea__c != null ||
                    respWrp.proxyObj.BST_Selected_Account__c != null ||
                    (respWrp.selectedAnswerPicklist != null && respWrp.selectedAnswerPicklist !='') ||
                    (respWrp.selectedAnswersMultiselect != null && !respWrp.selectedAnswersMultiselect.isEmpty())))
                    {
                    respWrp.questionNumber =questionCounter;
                    SubcategorySet.add(respWrp.Subcategory); 
                    }
                    }
                if(!SubcategorySet.isEmpty()){
                    SubcategoryOptionList = new List<String>();
                    SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                    for(String Subcategory : SubcategorySet)
                    {
                        SubcategoryOptionList.add(Subcategory);
                    }
                }else
                {
                    SubcategoryOptionList = new List<String>();
                    SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
                }
            }
            else
            {
                SubcategoryOptionList = new List<String>();
                SubcategoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
            }
            
            return SubcategoryOptionList;
    }
    
    /**
    * Method Name: getAccountParsedJson
    * Description: Method to parse the JSON Response.
    * Parameter:   String                            
    * Return Type: List<AccountProfileWrapper>
    */
    public static List<AccountProfileWrapper> getAccountParsedJson(string responseJson){
        
        List<AccountProfileWrapper> responseWrpList =   new List<AccountProfileWrapper>();
        
        JSONParser parser = JSON.createParser(responseJson);
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        AccountProfileWrapper accProfWrp = (AccountProfileWrapper)parser.readValueAs(AccountProfileWrapper.class);
                        responseWrpList.add(accProfWrp); 

                        parser.skipChildren();
                    }
                }
            }
        }
        
        return responseWrpList;
    }
    
    /**
    *   Method Name: getAccountAllProfileCategoryOptionList
    *   Description: Method to populate the CategoryOptions  
    *   Parameter: AccountId                             
    *   Return Type: List<String>
    */ 
    @AuraEnabled
    public static List<String> getAccountAllProfileCategoryOptionList(Id accountId,Boolean selectedactiverecords,String selectedCategory,String selectedSubCategory){
        /**
        *    Searching if the JDE account has parent MII to
        *   associate the account profile records. If it's a JDE 
        *   account with no MII record then associating the account profile records with JDE.
        *   
        */
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
                        
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<AccountProfileWrapper> responseWrpAllList = new List<AccountProfileWrapper>();
        List<String> categoryOptionList = new List<String>();
        Set<String> categorySet = new Set<String>();
        
        /**
        *   Passing Account Id and a Boolean value as False to getQuesRespGroup method for 
        *   getting all questions filtered without any Salesforce Group and 
        *   also getting the previously saved responses in the AccountProfileWrapper
        *   
        */
        
        responseWrpAllList = AccountProfileQuestions.getQuesRespGroup(acctID, false,true,selectedCategory,selectedSubCategory,'All');/* passing true for now for all profile*/
        if(!responseWrpAllList.isEmpty()){
            Integer questionCounter = 1;
            categoryOptionList = new List<String>();
            
            /**
            *   Questions that have previously saved responses are being displayed and
            *   the category picklist is being populated with distinct categories
            */
            
            for(AccountProfileWrapper acPrfWC :responseWrpAllList){
            
                if(acPrfWC.responseID != null && acPrfWC.responseID !='' && 
                   (acPrfWC.proxyObj.BST_Selected_Date__c != null ||
                    acPrfWC.proxyObj.BST_Selected_Number__c != null ||
                    acPrfWC.proxyObj.BST_Selected_TextArea__c != null ||
                    acPrfWC.proxyObj.BST_Selected_Account__c != null ||
                    (acPrfWC.selectedAnswerPicklist != null && acPrfWC.selectedAnswerPicklist !='') ||
                    (acPrfWC.selectedAnswersMultiselect != null && !acPrfWC.selectedAnswersMultiselect.isEmpty())))
                {
                    acPrfWC.questionNumber = questionCounter ;
                    
                    responseWrpList.add(acPrfWC);
                    if(acPrfWC.category != null && acPrfWC.category != ''){
                        if(categorySet.add(acPrfWC.category))
                            categoryOptionList.add(acPrfWC.category);
                    }
                    questionCounter ++;
                }
            }
            
            if(!responseWrpList.isEmpty()){
                
                if(!categoryOptionList.isEmpty()){
                    
                    categoryOptionList.add(0, System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                
                }else{
                    categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                    
                }
                                
            }else{              
                categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);             
            }
                    
        }else{
            categoryOptionList = new List<String>();                    
            categoryOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);             
            
        }
        return categoryOptionList;
    } 
    
   
    /**
    *   Method Name: getAccountAllProfileGroupOptionList
    *   Description: Method to populate the GroupOptions  
    *   Parameter: AccountId                             
    *   Return Type: List<String>
    *   Added by :- Shashank For Group Filter
    * 
    * 
    */ 
    
    @AuraEnabled
    public static List<String> getAccountAllProfileGroupOptionList(Id accountId,String baxterGroupAttribute){
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
        List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
        List<AccountProfileWrapper> responseWrpAllList = new List<AccountProfileWrapper>();
        List<String> groupOptionList = new List<String>();
        Set<String> groupSet = new Set<String>();
       responseWrpAllList = AccountProfileQuestions.getQuesRespGroup(acctID,true,true,'ALL','ALL',baxterGroupAttribute ); /* passing true for now for all profile*/
        if(!responseWrpAllList.isEmpty()){
            Integer questionCounter = 1;
            groupOptionList = new List<String>();
            for(AccountProfileWrapper acPrfWC :responseWrpAllList){
                 if(acPrfWC.responseID != null && acPrfWC.responseID !='' && 
                   (acPrfWC.proxyObj.BST_Selected_Date__c != null ||
                    acPrfWC.proxyObj.BST_Selected_Number__c != null ||
                    acPrfWC.proxyObj.BST_Selected_TextArea__c != null ||
                    acPrfWC.proxyObj.BST_Selected_Account__c != null ||
                    (acPrfWC.selectedAnswerPicklist != null && acPrfWC.selectedAnswerPicklist !='') ||
                    (acPrfWC.selectedAnswersMultiselect != null && !acPrfWC.selectedAnswersMultiselect.isEmpty())))
                {
                    acPrfWC.questionNumber = questionCounter ;
                    
                    responseWrpList.add(acPrfWC);
                    if(acPrfWC.salesforceGroup != null && acPrfWC.salesforceGroup != ''){
                       if(acPrfWC.salesforceGroup.indexOf(';') == -1){
                            GroupSet.add(acPrfWC.salesforceGroup);
                        }else{
                               groupOptionList = acPrfWC.salesforceGroup.split(';');
                               GroupSet.addAll(groupOptionList);
                        }
                           // GroupOptionList.addAll(acPrfWC.salesforceGroup.split(';'));
                    }
                    questionCounter ++;
                }
            }
            
           if(!responseWrpList.isEmpty()){
                
                if(!groupOptionList.isEmpty()){
                    
                    groupOptionList.add(0, System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                
                }else{
                    groupOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL);
                    
                }
                                
            }else{              
                
                groupOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);             
                }
                    
        }else{
            groupOptionList = new List<String>();                    
            groupOptionList.add(System.Label.BST_ACCOUNT_PROFILE_PICKLIST_NONE);
             
        }
        List<String> finalGroupList = new List<String>();
        finalGroupList.addAll(GroupSet);
       
        return finalGroupList;
    } 
    
    
}