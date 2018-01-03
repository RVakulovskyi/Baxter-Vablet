/********************************************************************************
Apex Class Name - AccountProfileWrapper
Version - 1.0
Created Date - Sept 3, 2014
Function - Wrapper Class for keeping Questions and Account Profiles for an Account
           in one place

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/03/2014           Original Version
* Dharani   Pothula       11/02/2016           Added a sub class answerOptionCheckboxes , 
                                               to use options on BAXLTNG_Account_AccountMyProfile 
                                               and BAXLTNG_Account_AccountAllProfile
* Shikhar Srivastava      06/06/2017           Boost-Sprint1/Squad1
*Shashank Mehra           06/19/2017           Boost-Sprint2/Squad1 JIRA 104
* Niharika Modi           06/16/2017           Boost-Sprint2/Squad1 JIRA BOOS 102
* Niharika Modi           08/16/2017           Boost-R1/Sprint1/Squad1 JIRA 
********************************************************************************/

global class AccountProfileWrapper implements Comparable{
    
    /** questionStatement --> value will come from Question_Statement__c Field of Question__c Object **/
    @AuraEnabled
    public String questionStatement{get;set;}
    
     /** questionlocale --> value will come from Question_LOCALE__c Field of Question__c Object **/
    @AuraEnabled
    public String questionlocale{get;set;}
    
    /** questionID --> value will come from ID Field of Question__c Object **/
    @AuraEnabled
    public String questionID{get;set;}
    
    /** status --> value will come from Status__c Field of Question__c Object **/
    @AuraEnabled
    public String status{get;set;}
    
    /** category --> value will come from BST_MAJOR_CATEGORY__c Field of Question__c Object **/
    @AuraEnabled
    public String category{get;set;}
    
    /** category --> value will come from BST_CATEGORY__c Field of Question__c Object **/
    @AuraEnabled
    public String subcategory{get;set;}
    
    /** responseType --> value will come from Response_Type__c Field of Question__c Object **/
    @AuraEnabled
    public String responseType{get;set;}
    
    /** isDate --> value will True for Question__c record with Response Type 'Date' **/
    @AuraEnabled
    public Boolean isDate{get;set;}
    
    /** isNumber --> value will True for Question__c record with Response Type 'Number' **/
    @AuraEnabled
    public Boolean isNumber{get;set;}  

    /** isPicklist --> value will True for Question__c record with Response Type 'Picklist' **/
    @AuraEnabled
    public Boolean isPicklist{get;set;}
    

    /** isMultiselect --> value will True for Question__c record with Response Type 'Multi Picklist' **/
    @AuraEnabled
    public Boolean isMultiselect{get;set;}
    
     /** isAccountLookup --> value will True for Question__c record with Response Type 'Account Lookup' **/
    @AuraEnabled
    public Boolean isAccountLookup{get;set;}
    
     /** isContactLookup --> value will True for Question__c record with Response Type 'Contact Lookup' **/
    @AuraEnabled
    public Boolean isContactLookup{get;set;}
    
     /** isText --> value will True for Question__c record with Response Type 'Text' **/
    @AuraEnabled
    public Boolean isText{get;set;}
    
    @AuraEnabled
    public Boolean isselectedactiverecords{get;set;}
    
    /** salesforceGroup --> value will come from Salesforce_Group__c Field of Question__c Object **/
    @AuraEnabled
    public String salesforceGroup{get;set;}
    
    /** order --> value will come from Order__c Field of Question__c Object **/
    @AuraEnabled
    public Integer order{get;set;}
    
    /** accountID --> value will come from ID Field of current Account Record **/
    @AuraEnabled
    public String accountID{get;set;}
    
    /** isExpired --> value will come from BST_EXPIRED__c Field of Account_Profile__c Object **/
    @AuraEnabled
    public Boolean isExpired{get;set;}
    
    @AuraEnabled
    public Boolean isSameValueApplies{get;set;}
    
  
    /** answerOptions --> value will come from Answer_Options__c Field of Question__c Object for Response Type 'Picklist'
    *   and then the value is formated to SelectOption to display in the visualforce page
    **/
    
    public List<SelectOption> answerOptions{get;set;}
    
    /** 
    *   SelectedAnswerPicklist --> for previously saved responses for Response Type 'Picklist',
    *   values will come from Selected_Picklist_Answer__c Field of Account_Profile__c Object 
    **/
    @AuraEnabled
    public String SelectedAnswerPicklist{get;set;}
    
    /** responseID --> for previously saved responses, value will come from ID Field of Account_Profile__c Object **/
    @AuraEnabled
    public String responseID{get;set;}
    
    /** 
    *   proxyObj --> This proxy instance of Account_Profile__c object is being used to show the previously saved responses 
    *   for Response Type 'Date' or 'Number'. Previously saved response is coming from either Selected_Date__c or Selected_Number__c
    *   field of Account_Profile__c object
    **/
    @AuraEnabled
    public Account_Profile__c proxyObj{get;set;}
    
    /** answerOptionsStringList --> value will come from Answer_Options__c Field of Question__c Object 
    *   and then the value is formated to List<String>
    **/    
    @AuraEnabled
    public List<String> answerOptionsStringList{get;set;}
    
    @AuraEnabled
    
    public List<SelectOptionWrapper> answerOptionCheckboxes {get; set;}
    
    /** answerOptionsMultiselect --> value will come from Answer_Options__c Field of Question__c Object for Response Type 'Multi Picklist' 
    *   and then the value is formated to SelectOption to display in the visualforce page
    **/
    
    public List<SelectOption> answerOptionsMultiselect{get;set;}
    
    /** 
    *   selectedAnswersMultiselect --> for previously saved responses for Response Type 'Multi Picklist',
    *   values will come from Selected_Multi_Answers__c Field of Account_Profile__c Object 
    **/
    @AuraEnabled
    public List<String> selectedAnswersMultiselect{get;set;}
    
    /* Field to store account name selected in field BST_Selected_Account__c */
    @AuraEnabled
    public String selectedaccountname{get;set;}
    /** Counter for Question number **/
    @AuraEnabled
    public Integer questionNumber{get;set;}
    
    @AuraEnabled
    public SelectedValues sValues {get; set;}
    
    public AccountProfileWrapper(){
    
        this.answerOptions = new List<SelectOption>();
        this.answerOptionsStringList = new List<String>();
        this.selectedAnswerPicklist = '';
        this.answerOptionsMultiselect =  new List<SelectOption>();        
        this.selectedAnswersMultiselect = new List<String>();  
        this.selectedaccountname = '';
        this.isDate = false;
        this.isNumber = false;
        this.isPicklist = false;
        this.isMultiselect = false;
        this.isAccountLookup = false;
        this.isContactLookup = false;
        this.isText = false;
        this.ResponseID = '';
        this.isSameValueApplies = false;
        this.proxyObj = new Account_Profile__c();
        this.answerOptionCheckboxes =   new List<SelectOptionWrapper>();
        this.sValues    =   new SelectedValues(null, null);
    }
    
    public Class SelectedValues {
        @AuraEnabled
        public Decimal selectedNumber;
        @AuraEnabled
        public date selectedDate;
        
        public SelectedValues(decimal selectedNumber, date selectedDate){
            this.selectedNumber = selectedNumber;
            this.selectedDate = selectedDate;
        }
    }
    
    public class SelectOptionWrapper{
        @auraEnabled
        public string answerOption;
        @AuraEnabled
        public boolean selected;
        
        public SelectOptionWrapper(string answerOption, boolean selected){
            this.answerOption = answerOption;
            this.selected     = selected;
        }
    }
    
    global Integer compareTo(Object compareTo) {
      
        AccountProfileWrapper compareToWrapper = (AccountProfileWrapper)compareTo;
          if (category > compareToWrapper.category) {
                return -1;
          } else if (category < compareToWrapper.category) {
                return 1;
          } else {
                // First value the same, consider second value
                if (subcategory > compareToWrapper.subcategory) {
                    return -1;
                } else if (subcategory < compareToWrapper.subcategory) {
                    return 1;
                } else {
                // 2nd value is same, consider third value
                        if (order > compareToWrapper.order) {
                            return 1;
                        } else if (order < compareToWrapper.order) {
                            return -1;
                        } else {
                            return 0;
                        } 
                }          
         } 
    }
    
}