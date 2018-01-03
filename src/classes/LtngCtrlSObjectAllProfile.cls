/********************************************************************************
Apex Class Name - LtngCtrlSObjectAllProfile
Version - 1.0
Created Date - Nov 10, 2016
Function - Apex Class for the Questionnaire Page to show All Questions and sObject Profiles 
           for an sObject


Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Gaurav Jain         11/10/2016           Original Version
* Shikhar Srivastava      06/06/2017           Boost-Sprint1/Squad1
* Shashank Mehra          14/08/2017           BOOST -Sprint3/Squad1
********************************************************************************/


public without sharing class LtngCtrlSObjectAllProfile{
    

    /**
    *   Method Name: getAccountIncrementCounter
    *   Description: Method to populate the question number for selected Category  
    *   Parameter: None                             
    *   Return Type: List<AccountProfileWrapper>
    */    
    @AuraEnabled
    public static List<AccountProfileWrapper> getAccountIncrementCounter(Id accountId, string selectedCategory, string selectedSubCategory, boolean selectedactiverecords,boolean selectedActiveResponse,String baxterGroupAttribute) {
        
        /**
        *    Searching if the JDE account has parent MII to
        *   associate the account profile records. If it's a JDE 
        *   account with no MII record then associating the account profile records with JDE.
        *   
        */
        try
        {
              
            string acctID = AccountProfileQuestions.getParentMIIAccount(accountId);
               
            List<AccountProfileWrapper> responseWrpList = new List<AccountProfileWrapper>();
            List<AccountProfileWrapper> updatedResponseWrpList = new List<AccountProfileWrapper>();
            List<AccountProfileWrapper> responseWrpAllList = new List<AccountProfileWrapper>();
            List<SelectOption> categoryOptionList = new List<SelectOption>();
            Set<String> categorySet = new Set<String>();
            
            /**
            *   Passing Account Id and a Boolean value as False to getQuesRespGroup method for 
            *   getting all questions filtered without any Salesforce Group and 
            *   also getting the previously saved responses in the AccountProfileWrapper
            *   
            */
            responseWrpAllList = AccountProfileQuestions.getQuesRespGroup(acctID, selectedActiveResponse,selectedactiverecords,selectedCategory,selectedSubCategory,baxterGroupAttribute);
                if(!responseWrpAllList.isEmpty())
                {
                    
                    Integer questionCounter = 1;
                    categoryOptionList = new List<SelectOption>();
                    if(selectedActiveResponse)
                    {
                        for(AccountProfileWrapper acPrfWC :responseWrpAllList)
                        {
                            if(acPrfWC.responseID != null && acPrfWC.responseID !='' && 
                               (acPrfWC.proxyObj.BST_Selected_Date__c != null ||
                                acPrfWC.proxyObj.BST_Selected_Number__c != null ||
                                acPrfWC.proxyObj.BST_Selected_TextArea__c != null ||
                                acPrfWC.proxyObj.BST_Selected_Account__c != null ||
                                (acPrfWC.selectedAnswerPicklist != null && acPrfWC.selectedAnswerPicklist !='') ||
                                (acPrfWC.selectedAnswersMultiselect != null && !acPrfWC.selectedAnswersMultiselect.isEmpty())) &&
                               (acPrfWC.isExpired))
                            {
                                acPrfWC.questionNumber = questionCounter ;
                                updatedResponseWrpList.add(acPrfWC);
                                questionCounter ++;
                            }
                            
                        }
                   //     return responseWrpAllList;     
                    }
                    else
                    {
                        for(AccountProfileWrapper acPrfWC : responseWrpAllList){
                            if(acPrfWC.responseID != null && acPrfWC.responseID !='' && 
                               (acPrfWC.proxyObj.BST_Selected_Date__c != null ||
                                acPrfWC.proxyObj.BST_Selected_Number__c != null ||
                                acPrfWC.proxyObj.BST_Selected_TextArea__c != null ||
                                acPrfWC.proxyObj.BST_Selected_Account__c != null ||
                                (acPrfWC.selectedAnswerPicklist != null && acPrfWC.selectedAnswerPicklist !='') ||
                                (acPrfWC.selectedAnswersMultiselect != null && !acPrfWC.selectedAnswersMultiselect.isEmpty())))
                                
                            {
                                acPrfWC.questionNumber = questionCounter ;
                                
                                updatedResponseWrpList.add(acPrfWC);
                                questionCounter ++;
                            }
                            
                        } 
                  //      return responseWrpAllList;
                    }
                }
                  return updatedResponseWrpList;
            }
            Catch (Exception ex)
            {
                System.debug ('Incrementcounter----------------' + ex);
                return null ;
            }
            
           /* Integer questionCounter=1;
            for(AccountProfileWrapper ap : responseWrpList){
                
                if(selectedCategory==ap.category || selectedCategory==System.Label.BST_ACCOUNT_PROFILE_PICKLIST_ALL){
                    ap.questionNumber=questionCounter;
                    questionCounter++;
                }
                
                updatedResponseWrpList.add(ap);
                
            }  */      
                
           // return responseWrpList;
           
        }
        
        //Added for BOOS-630 - Start
        
        /**
        *   Method Name: getAvailableReports
        *   Description: Method to populate the Report Types
        *   Parameter: NA                             
        *   Return Type: List<Report>
        */
        
        @AuraEnabled
        public static List<Report> getAvailableReports(){
            List<Report> reprt = [Select Id, Name from Report where DeveloperName like 'BU_Profile%'];
            reprt.sort();
            return reprt;
        }
        
        //Added for BOOS-630 - End
        
        /**
        *   Method Name: getCategoryOptionList
        *   Description: Method to populate the CategoryOptions  
        *   Parameter: AccountId                             
        *   Return Type: List<String>
        */ 
        @AuraEnabled
        public static List<String> getCategoryOptionList(Id recordId, String sObjectApiName,Boolean selectedactiverecords,String selectedCategory,String selectedSubCategory){
            List<String> categoryOptionList = new List<String>();
            
            
            
            if(String.isEmpty(sObjectApiName)){
            
            
                //Do Nothing
            } else if(sObjectApiName.equalsIgnoreCase('Account')){
                categoryOptionList = ClsAccountDetailsUtility.getAccountAllProfileCategoryOptionList(recordId,selectedactiverecords,selectedCategory,selectedSubCategory);
                        
            } 
            /*
            else if(sObjectApiName.equalsIgnoreCase('Contact')) {
                categoryOptionList = ClsContactDetailsUtility.getContactAllProfileCategoryOptionList(recordId);
            }
    
            */
            
            return categoryOptionList;
        }
        
        
     /**
    *   Method Name: getGroupOptionList
    *   Description: Method to populate the CategoryOptions.This is displaying the sub category.  
    *   Parameter: Id
    *   Parameter: String                             
    *   Return Type: List<String>
    */
        @AuraEnabled
        public static List<String> getGroupOptionList(Id recordId, String sObjectApiName,String selectedBaxtergroup)
        {
            List<String> GroupOptionList = new List<String>();
            if(String.isEmpty(sObjectApiName))
            {
                
            } 
            else if(sObjectApiName.equalsIgnoreCase('Account'))
            {
                GroupOptionList = ClsAccountDetailsUtility.getAccountAllProfileGroupOptionList(recordId,selectedBaxtergroup);
               
            } 
            
            
            return GroupOptionList;
        } 
    
     
     /**
    *   Method Name: getSubCategoryOptionList
    *   Description: Method to populate the CategoryOptions.This is displaying the sub category.  
    *   Parameter: Id
    *   Parameter: String                             
    *   Return Type: List<String>
    */ 
        
        @AuraEnabled
        public static List<String> getSubCategoryOptionList(Id recordId, String sObjectApiName,Boolean selectedactiverecords,String selectedCategory,String selectedSubCategory){
            List<String> SubcategoryOptionList = new List<String>();
            if(String.isEmpty(sObjectApiName)){
                //Do Nothing
            } else if(sObjectApiName.equalsIgnoreCase('Account')){
            //Added by Shashank to display Sub-category in the All profile tab
                SubcategoryOptionList = ClsAccountDetailsUtility.getAccountAllProfileSubCategoryOptionList(recordId,selectedactiverecords,selectedCategory,selectedSubCategory);
            } 
            /*
    else if(sObjectApiName.equalsIgnoreCase('Contact')) {
    categoryOptionList = ClsContactDetailsUtility.getContactMyProfileCategoryOptionList(recordId);
    }
    */
          
            return SubcategoryOptionList;
            
        }
        
        
            /**
    * Method Name: getUIThemeDescription()
    * Description: Method to get the account of the recordId .
    * Parameter:   AccountId                             
    * Return Type: sObject
    */
        @AuraEnabled
        public static String getUIThemeDescription() {
            return ClsAccountDetailsUtility.getUIThemeDescription();
        } 
        
        
        
        /**
        *   Method Name: getContactIncrementCounter
        *   Description: Method to populate the question number for selected Category  
        *   Parameter: None                             
        *   Return Type: List<ContactProfileWrapper>
        */    
        
        /*
        @AuraEnabled
        public static List<ContactProfileWrapper> getContactIncrementCounter(Id contactId, string selectedCategory) {
            contactId = ContactProfileQuestions.getContact(contactId);
                
                
            List<ContactProfileWrapper> responseWrpList = new List<ContactProfileWrapper>();
            List<ContactProfileWrapper> updatedResponseWrpList = new List<ContactProfileWrapper>();
            List<ContactProfileWrapper> responseWrpAllList = new List<ContactProfileWrapper>();
            List<String> categoryOptionList = new List<String>();
            Set<String> categorySet = new Set<String>();
            
            /**
            *   Passing Contact Id and a Boolean value as False to getQuesRespGroup method for 
            *   getting all questions filtered without any Salesforce Group and 
            *   also getting the previously saved responses in the ContactProfileWrapper
            *   
            */
        
            /*
            responseWrpAllList = ContactProfileQuestions.getQuesRespGroup(contactId, false);
            
            if(!responseWrpAllList.isEmpty()){
                
                Integer questionCounter = 1;
                categoryOptionList = new List<String>();
                
                /**
                *   Questions that have previously saved responses are being displayed and
                *   the category picklist is being populated with distinct categories
                */
                /*
                for(ContactProfileWrapper coPrfWC :responseWrpAllList){
                
                    if(coPrfWC.responseID != null && coPrfWC.responseID !='' && 
                       (coPrfWC.proxyObj.Selected_Date__c != null ||
                        coPrfWC.proxyObj.Selected_Number__c != null ||
                        (coPrfWC.selectedAnswerPicklist != null && coPrfWC.selectedAnswerPicklist !='') ||
                        (coPrfWC.selectedAnswersMultiselect != null && !coPrfWC.selectedAnswersMultiselect.isEmpty())))
                    {
                        coPrfWC.questionNumber = questionCounter ;
                        responseWrpList.add(coPrfWC);
                        if(coPrfWC.category != null && coPrfWC.category != ''){
                            if(categorySet.add(coPrfWC.category))
                                categoryOptionList.add(coPrfWC.category);
                        }
                        questionCounter ++;
                    }
                }
                        
            }
            if(!responseWrpList.isEmpty()){
                Integer questionCounter=1;
                for(ContactProfileWrapper ap : responseWrpList){
                    
                    if(selectedCategory==ap.category || selectedCategory==System.Label.CONTACT_PROFILE_PICKLIST_ALL){
                        ap.questionNumber=questionCounter;
                        questionCounter++;
                    }
                    updatedResponseWrpList.add(ap);
                }      
                    
                                    
            }
          
           
            return updatedResponseWrpList;
           
        } 
        */
}