({
    doInit : function(component, event, helper) {
		helper.loadProfiles(component);
        helper.loadContactDetails(component);
		helper.loadUserDetails(component);
		helper.loadUserCountryDetails(component);
		helper.loadDefaultMPC(component);
		//helper.loadMainTopicValues(component);
		helper.loadCountryValues(component);
        //helper.loadMainProductCategoryValues(component, "New");
       	helper.loadRecordTypes(component);
        helper.loadContacts(component);
        //helper.getContracts(component);
	},
     setEndDate : function(component, event, helper) {
         helper.setEndDateHelper(component);
    },
    handleSaveEvent: function(component, event, helper) {
        if(helper.validateEventForm(component)) 
		{
            helper.saveEvent(component);
        }
        else {
            // New event form failed validation, show a message to review errors
            component.set("v.hasErrors", true);
        }
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    },
	
	onSelectCountryChange : function(component, event, helper){
        var recType = component.get("v.evtRecordType");
        
        if(recType != '') 
        	helper.loadMainProductCategoryValues(component);
    },
    onSelectRecordTypeChange : function(component, event, helper){
        var recType = component.get("v.evtRecordType");
        component.set("v.newEvent.BST_MAIN_TOPIC__c", "");
        component.set("v.newEvent.BSTP_COACH_VISIT__c", "");
        component.set("v.newEvent.BST_CALL_OBJ__c", "");
        component.set("v.newEvent.BST_BEST_OUTCOME__c", "");
        component.set("v.newEvent.BST_MIN_OUTCOME__c", "");
        //component.set("v.newEvent.BST_CALL_NOTES__c", "");
        component.set("v.newEvent.Description", "");//JIRA NO:709
        helper.loadRecordTypeId(component);
        helper.loadDefaultEventType(component);
        helper.loadEventTypes(component);
        if(recType == $A.get("$Label.c.BST_Field_Sales_Call_RecordType") || recType == $A.get("$Label.c.BST_Non_Field_Sales_Activity_RecordType") || recType == $A.get("$Label.c.BST_Training_Provided_RecordType")) {
        	helper.loadMainProductCategoryValues(component);
        }
    },

   	onSelectMPCChange : function(component, event, helper){
        var recType = component.get("v.evtRecordType");
        var mpc = component.get("v.newEvent.BST_BAX_SALES_TEAM__c");
        component.set("v.newEvent.BST_MAIN_TOPIC__c", "");
        component.find("eventMainTopic").set("v.options", "");
        if((recType == $A.get("$Label.c.BST_Field_Sales_Call_RecordType") || recType == $A.get("$Label.c.BST_Non_Field_Sales_Activity_RecordType") || recType == $A.get("$Label.c.BST_Training_Provided_RecordType")) && mpc != '') {
        	helper.loadMainTopicValues(component);
        }
    },
    
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleIdUpdate : function(cmp, event, helper) {
        // Get the Id from the Event
        var Id = event.getParam("sObjectId");
        var attName = event.getParam("attributeName");
        var fullName = 'v.' + attName;
        // Set the Id bound to the View
        if(Id != null){
        
            cmp.set(fullName,Id);
        }
    },
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleIdClear : function(cmp, event, helper) {
        // Clear the Id bound to the View
        cmp.set('v.sObjectId', null);
    },
    coachVisitCheckboxChange : function(cmp, event, helper){
        cmp.set("v.newEvent.BSTP_COACH_VISIT__c", cmp.find("eventCoachingVisit").get("v.value"));    } 
    
})