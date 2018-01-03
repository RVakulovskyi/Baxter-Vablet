/********************************************************************************
Apex Class Name - LtngCtrlSObjectMyProfile
Version - 1.0
Created Date - Nov 10, 2016
Function - Apex Class for the Questionnaire Page to show Questions and sObject Profiles 
for an sObjectt based on the current user's salesforce group

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Gaurav Jain             11/10/2016           Original Version
* Shikhar Srivastava      06/06/2017           Boost-Sprint1/Squad1
* Niharika Modi           16/06/2017           Boost-Sprint2/Squad1 JIRA BOOS 102
*Shashank Mehra           16/06/2017           Boost-Sprint2/Squad1 JIRA BOOS 104
* Niharika Modi           19/06/2017           Boost-Sprint2/Squad1 JIRA BOOS 110
********************************************************************************/

public without sharing class LtngCtrlSObjectMyProfile {
    
    
    /**
*   Method Name: saveResponse
*   Description: Method to save Account Profiles for an Account and go to the account detail page 
*   Parameter: None                             
*   Return Type: Boolean
*/
    @AuraEnabled
    public  static string saveResponse(string  responseJson, string sObjectApiName){
        
        string message;
        if(String.isEmpty(sObjectApiName)){
            message = '';
        } else if(sObjectApiName.equalsIgnoreCase('Account')){
            message = ClsAccountDetailsUtility.saveAccountMyProfileResponse(responseJson);
        } 
        /*
else if(sObjectApiName.equalsIgnoreCase('Contact')) {
message = ClsContactDetailsUtility.saveContactMyProfileResponse(responseJson);
}
*/
        
        return message;
    }
    
    /**
*   Method Name: saveResponseIntermediately
*   Description: Method to save Account Profiles for an Account and stay on the same page 
*   Parameter: None                             
*   Return Type: PageReference
*/
    @AuraEnabled
    public static String saveResponseIntermediately(string responseJson, string sObjectApiName){
        
        string message;
        if(String.isEmpty(sObjectApiName)){
            message = '';
        } else if(sObjectApiName.equalsIgnoreCase('Account')){
            message = ClsAccountDetailsUtility.saveAccountMyProfileResponseIntermediately(responseJson);
        } 
        /*
else if(sObjectApiName.equalsIgnoreCase('Contact')) {
message = ClsContactDetailsUtility.saveContactMyProfileResponseIntermediately(responseJson);
}

*/
        
        return message;
    }
    
    
    /**
*   Method Name: getAccountIncrementCounter
*   Description: Method to populate the question number for selected Category  
*   Parameter: None                             
*   Return Type: List<AccountProfileWrapper>
*/    
    @AuraEnabled
    public static List<AccountProfileWrapper> getAccountIncrementCounter(Id accountId, string selectedCategory, string selectedSubCategory, boolean selectedactiverecords, boolean selectedActiveResponse) {
        string acctID = AccountProfileQuestions.getParentMIIAccount(accountID);
        List<AccountProfileWrapper> updatedResponseWrpList = new List<AccountProfileWrapper>();
        /**
*   Passing Account Id and a Boolean value as true to getQuesRespGroup method for 
*   getting all questions filtered by Salesforce Group of the current user and 
*   also getting the previously saved responses in the AccountProfileWrapper
*   
*/
        List<AccountProfileWrapper> responseWrpList = AccountProfileQuestions.getQuesRespGroup(acctID, True,selectedactiverecords,selectedCategory,selectedSubCategory,'');
        responseWrpList.sort();
        Integer quesNum = 1;
        if(selectedActiveResponse){
            
            for(AccountProfileWrapper response: responseWrpList){
                if(response.isExpired != null && response.isExpired){
                    response.questionNumber = quesNum;
                    updatedResponseWrpList.add(response);
                    quesNum++;
                }
            }
            return updatedResponseWrpList;
        }else{
            for(AccountProfileWrapper response: responseWrpList){
                response.questionNumber = quesNum;
                quesNum++;
            }
            return responseWrpList;
        } 
        
        
    }
    
    /**
*   Method Name: getCategoryOptionList
*   Description: Method to populate the CategoryOptions  
*   Parameter: Id
*   Parameter: String                             
*   Return Type: List<String>
*/ 
    @AuraEnabled
    public static List<String> getCategoryOptionList(Id recordId, String sObjectApiName,Boolean selectedactiverecords,String selectedCategory,String selectedSubCategory){
        List<String> categoryOptionList = new List<String>();
        if(String.isEmpty(sObjectApiName)){
            //Do Nothing
        } else if(sObjectApiName.equalsIgnoreCase('Account')){
            categoryOptionList = ClsAccountDetailsUtility.getAccountMyProfileCategoryOptionList(recordId,selectedactiverecords,selectedCategory,selectedSubCategory);
        } 
        /*
else if(sObjectApiName.equalsIgnoreCase('Contact')) {
categoryOptionList = ClsContactDetailsUtility.getContactMyProfileCategoryOptionList(recordId);
}
*/
        return categoryOptionList;
    }
    
    /**
*   Method Name: getCategoryOptionList
*   Description: Method to populate the CategoryOptions  
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
            SubcategoryOptionList = ClsAccountDetailsUtility.getAccountMyProfileSubCategoryOptionList(recordId,selectedactiverecords,selectedCategory,selectedSubCategory);
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
*added by :- Shashank Mehra
* Method Name: getuserlanguage1()
* Description: Method to get language of the user .
* Parameter:   getuserlanguage 
* Return Type: Boolean
*/
    @AuraEnabled
    public static Boolean getuserlanguage()
    {
        try{
        Boolean getuserlanguage=false;
        list<string> userlang = new list<string>();
        String language = [Select LanguageLocaleKey FROM User where Id=:userinfo.getUserId()].languageLocaleKey;
        
        for(BST_Profiles__mdt obj1: [SELECT Id,Label FROM BST_Profiles__mdt]){
            userlang.add(obj1.Label);
        }
        list<User> objuser = [SELECT Profile.Name FROM User where  Profile.Name=:userlang AND Id=:userinfo.getUserId()];        
        if(objuser.size()>0){
            if (language == System.Label.BST_Language)
            {
                getuserlanguage=True ;
            }
            else
            {
                getUserLanguage=false ;
            }
        }else{
            getuserlanguage=True ;
        }
        return getuserlanguage ;
        }
        catch(exception ex){
            system.debug('ex============='+ex);
            return false;            
        }
        return false;
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
*   Method Name: getContactIncrementCounter
*   Description: Method to populate the question number for selected Category  
*   Parameter: Id
*   Parameter: String
*   Return Type: List<ContactProfileWrapper>
*/    
    /*
@AuraEnabled
public static List<ContactProfileWrapper> getContactIncrementCounter(Id contactId, String selectedCategory) {

List<ContactProfileWrapper> updatedResponseWrpList = new List<ContactProfileWrapper>();
/**
*   Passing Contact Id and a Boolean value as true to getQuesRespGroup method for 
*   getting all questions filtered by Salesforce Group of the current user and 
*   also getting the previously saved responses in the ContactProfileWrapper
*   
*/
    
    /*
List<ContactProfileWrapper> responseWrpList = ContactProfileQuestions.getQuesRespGroup(contactId, True);

Integer questionCounter=1;
for(ContactProfileWrapper ap : responseWrpList){

if(selectedCategory==ap.category || selectedCategory==System.Label.CONTACT_PROFILE_PICKLIST_ALL){
ap.questionNumber=questionCounter;
questionCounter++;
}

updatedResponseWrpList.add(ap);
}        
system.debug('*********response wrap******'+updatedResponseWrpList);

return updatedResponseWrpList;

}*/
    
}