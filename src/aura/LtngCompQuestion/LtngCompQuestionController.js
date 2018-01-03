({
    doInit : function(component, event, helper) {
        helper.loadUserDetails(component);
        helper.loadResponseType(component, event, helper);	
        //helper.loadRecordTypes(component, event, helper);
        //helper.loadSalesProcess(component);
        helper.loadStatus(component, event, helper);
		helper.loadHelptext(component, event, helper);
        
        if($A.util.isEmpty(component.get("v.recordId"))){
			var recType = component.get("v.quesRecordType");
            var options = [];
            var RecordTypeValue=component.find('questionRecordType').get("v.value");
            var LocalisedField=component.find('queslocal');
            var LocalRecord=component.find('localques');
            var types=component.find('type');
            options.push({"class": "optionClass", label: recType, value: recType});
            //component.set("v.quesRecordType", recType);              
            component.find("questionRecordType").set("v.options", options);
            component.find("questionRecordType").set("v.value", recType);
            helper.loadRecordTypeId(component, event, helper);
			//helper.loadRecordTypes(component, event, helper);
			if (RecordTypeValue=== $A.get("$Label.c.BST_Global_Question"))
			{
                component.find("questionCountry").set("v.options", []);
                $A.util.removeClass(types, 'slds-hide') ;
                $A.util.addClass(LocalisedField, 'slds-hide');
                $A.util.addClass(LocalRecord, 'slds-hide');
                helper.loadQuestionType(component, event, helper);	
                helper.loadProfileType(component, event, helper);	
				
			}//Renders fields that are specific for Global question
			else
			{
                $A.util.addClass (types, 'slds-hide');
                $A.util.removeClass(LocalisedField , 'slds-hide') ;
                $A.util.removeClass(LocalRecord, 'slds-hide');
                helper.loadUserCountryDetails(component, event, helper);
            	helper.loadCountryValues(component, event, helper);
        		helper.loadMajorCategories(component, event, helper);
            	helper.loadSalesforceGroup(component, event, helper);	
			}
		}
        if(!$A.util.isUndefined(component.get("v.recordId")) && !$A.util.isEmpty(component.get("v.recordId"))){
			//Loaded only in the case of Edit
			component.set("v.isEdit",true);
			helper.loadQuestionDetails(component, event, helper);
			helper.loadRecordTypes(component, event, helper);
		} 
	},
	
    handleSaveQuestion: function(component, event, helper) {
     	//Calls the method After Save Question button is clicked
     	helper.checkerror(component, event, helper);
        helper.saveQuestion(component, event, helper);
    
    },
    //Custom Lookup Method
	handleCancel: function (component, event, helper) {
    	var homeEvent = $A.get("e.force:navigateToObjectHome");
    	homeEvent.setParams({
        "scope": "Question__c"
    });
    	homeEvent.fire();
},
    
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var Id = event.getParam("sObjectId");
        //var attName = event.getParam("attributeName");
       // var fullName = 'v.' + attName;
        // Set the Id bound to the View
        if(Id != null){
        
            component.set("v.newQuestion.BST_PARENT_QUESTION__c",Id);
        }
    },
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleIdClear : function(component, event, helper) {
        // Clear the Id bound to the View
        component.set('v.newQuestion.BST_PARENT_QUESTION__c', null);
    },
    //Method created to populate the dependent picklist
    onMajorCategoryChange : function(component, event, helper){
        var majCatType = component.get("v.majorCatType");
        component.set("v.newQuestion.BST_MAJOR_CATEGORY__c", majCatType);
        helper.loadCategories(component, event, helper);

    },
    //Method created to populate the dependent picklist
    onCountryChange : function(component, event, helper){
        var country = component.get("v.country");
        component.set("v.newQuestion.BST_COUNTRY__c", country);
        component.set("v.newQuestion.BST_CATEGORY__c", '');
        helper.loadMajorCategories(component, event, helper);
        helper.loadSalesforceGroup(component, event, helper);

    },
    //Controller method to handle the event triggered after Record Type is changed
    onSelectRecordTypeChange : function(component, event, helper){
		var RecordTypeValue=component.find('questionRecordType').get("v.value");
		var LocalisedField=component.find('queslocal');
        var LocalRecord=component.find('localques');
        var types=component.find('type');
        //component.set("v.newQuestion.RecordType.Name", RecordTypeValue);
        helper.loadRecordTypeId(component, event, helper);
        	//Renders fields that are specific for Local question
			if (RecordTypeValue=== $A.get("$Label.c.BST_Global_Question"))
			{
                component.find("questionCountry").set("v.options", []);
                $A.util.removeClass(types, 'slds-hide') ;
                $A.util.addClass(LocalisedField, 'slds-hide');
                $A.util.addClass(LocalRecord, 'slds-hide');
                helper.loadQuestionType(component, event, helper);	
                helper.loadProfileType(component, event, helper);	
				
			}//Renders fields that are specific for Global question
			else
			{
                $A.util.addClass (types, 'slds-hide');
                $A.util.removeClass(LocalisedField , 'slds-hide') ;
                $A.util.removeClass(LocalRecord, 'slds-hide');
                helper.loadUserCountryDetails(component, event, helper);
            	helper.loadCountryValues(component, event, helper);
        		helper.loadMajorCategories(component, event, helper);
            	helper.loadSalesforceGroup(component, event, helper);	
			}  
    },
    
   
    
    onControllerFieldChange  : function(component, event, helper) {
        
         var picklistValue = component.find('responseType').get("v.value");
         var sourceAnswer = component.find('answerOpt');     
                                
        if (picklistValue == $A.get("$Label.c.BST_Picklist") || picklistValue == $A.get("$Label.c.BST_MultiPicklist")){
                     
            $A.util.removeClass(sourceAnswer, 'slds-hide');
        
        }
        else
        {
            $A.util.addClass(sourceAnswer, 'slds-hide');
            component.find("answerOptions").set("v.value", "");
        }
    },
    
     // This is to display the tooltip1
   	 display : function(component, event, helper) {
   	 helper.Displaytext(component, event);
  	},
	// This is to display the tooltip2
  	displayOut : function(component, event, helper) {
   	helper.RRemovetext(component, event);
 	 }

})