({
	loadContactDetails : function(component) {
		var action = component.get("c.getContact");
        action.setParams({"contactId": component.get("v.recordId")});

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
            	console.log('###contact: ' + response.getReturnValue().Id)
                component.set("v.contact", response.getReturnValue());
            	component.set("v.contactId", response.getReturnValue().Id);
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
	loadUserDetails : function(component) {
		var recId = component.get("v.recordId");
		var action = component.get("c.getUserCountry");
		action.setCallback(this, function(response){
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					component.set("v.userCountry", response.getReturnValue());
                    component.set("v.newEvent.BST_COUNTRY__c", response.getReturnValue());

				} else {
					console.log('Problem getting account, response state: ' + state);
				}
			});
		$A.enqueueAction(action);
	},
	loadUserCountryDetails : function(component) {
		var recId = component.get("v.recordId");
		var action = component.get("c.getUserInfo");
		action.setCallback(this, function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				component.set("v.isSecondaryCountryEmpty", response.getReturnValue());
				console.log('###secondaryEmpty: ' +  response.getReturnValue());
				
			} else {
				console.log('Problem getting account, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
	},
	loadDefaultMPC : function(component) {
		var action = component.get("c.getUserMPC");
		action.setCallback(this, function(response){
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					component.set("v.userMPC", response.getReturnValue());
				} else {
					console.log('Problem getting default MPC, response state: ' + state);
				}
			});
		$A.enqueueAction(action);
	},
	loadCountryValues : function(component){
		var action = component.get("c.getCountryValues");
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
            	var secondaryEmpty = component.get("v.isSecondaryCountryEmpty");
            	if(secondaryEmpty == false) {
	                for(var i=0;i< response.getReturnValue().length;i++){
	                    if(component.get("v.userCountry") == response.getReturnValue()[i]) {
	                        options.push({"class": "optionClass", "selected" : "true", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
	                    }
	                    else
	                        options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
	                }
	                component.find("eventCountry").set("v.options", options);
	            }
                else {
                	for(var i=0;i< response.getReturnValue().length;i++){
                		if(component.get("v.userCountry") == response.getReturnValue()[i]) {
                			options.push({"class": "optionClass", "selected" : "true", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                			component.find("eventCountry").set("v.options", options);
                		}
                	}
                }
                
            } else {
                console.log('Problem getting country values, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    loadMainProductCategoryValues : function(component){
		var action = component.get("c.getMainProductCategoryValues");
        action.setParams({
            "recdType": component.find("eventRecordType").get("v.value"),
            "country": component.find("eventCountry").get("v.value")
        });
        
        action.setCallback(this, function(response){
            var options = [];
            var defaultMPC = '';
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                	if(response.getReturnValue()[i] == component.get("v.userMPC"))
                		defaultMPC = response.getReturnValue()[i];
                		
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("eventMainProdCat").set("v.options", options);
                component.set("v.newEvent.BST_BAX_SALES_TEAM__c", defaultMPC);
                
                var grabEvent = component.get("v.newEvent.BST_BAX_SALES_TEAM__c");
                if(defaultMPC != '')
                	this.loadMainTopicValuesOver(component, defaultMPC);
                	
                else {
                	component.set("v.newEvent.BST_MAIN_TOPIC__c", '');
                	var options = [''];
                	component.find("eventMainTopic").set("v.options", options);
                }
                	
            } else {
                console.log('Problem getting main product category values, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
	
	loadMainTopicFinal : function(component, mpc){
		var action = component.get("c.getMainTopicValues");
		action.setParams({
			"recdType": component.find("eventRecordType").get("v.value"),
            "mainProductCategory": mpc
		});
		
		action.setCallback(this, function(response){
			var options = [];
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				for(var i=0;i< response.getReturnValue().length;i++){
					
					options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
				}
				component.find("eventMainTopic").set("v.options", options);
			} else {
				console.log('Problem getting main topic values, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
	},
	loadMainTopicValuesOver : function(component, mpc){
		this.loadMainTopicFinal(component, mpc);
	},
	loadMainTopicValues : function(component){
		var bst = component.get("v.newEvent.BST_BAX_SALES_TEAM__c");
		this.loadMainTopicFinal(component, bst);
	},
	
    loadRecordTypes : function(component){
		var action = component.get("c.getEventRecordTypes")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("eventRecordType").set("v.options", options);
            } else {
                console.log('Problem getting recordtype values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    loadRecordTypeId : function(component){
        var action = component.get("c.getRecordTypeId");
        action.setParams({
			"objApiName": "Event",
            "recordTypeLabel": component.get("v.evtRecordType")
		});
        action.setCallback(this, function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				component.set("v.newEvent.RecordTypeId", response.getReturnValue());
			
			} else {
				console.log('Problem getting recordtypeid value, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
    },
    loadDefaultEventType : function(component){
        var action = component.get("c.getDefaultEventTypeValue");
        action.setParams({
            "recdType": component.get("v.evtRecordType")
		});
        action.setCallback(this, function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				if(response.getReturnValue() != 'NODEFAULTVALUE')
					component.set("v.defaultEventTypeVal", response.getReturnValue());
				else
					component.set("v.defaultEventTypeVal", "");
			
			} else {
				console.log('Problem getting recordtypeid value, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
    },
    loadEventTypes : function(component){
		var action = component.get("c.getEventTypeValues");
        action.setParams({"recdType": component.find("eventRecordType").get("v.value")});
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("eventType").set("v.options", options);
                component.set("v.newEvent.BST_CALL_TYPE__c", component.get("v.defaultEventTypeVal"));
            } else {
                console.log('Problem getting recordtype values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
	validateEventForm: function(component) {

		var validEvent = true;
       
        // Recordtype is required
        var recordTypeField = component.find("eventRecordType");
        if($A.util.isEmpty(recordTypeField.get("v.value"))) {
            validEvent = false;
            component.set("v.errorMessage", "Record Type Is Required");
        }
        else {
            recordTypeField.set("v.errors", null);
        }
   
        // Verify we have an contact to attach it to
        var contact = component.get("v.contact");
        if($A.util.isEmpty(contact)) {
            validEvent = false;
            console.log("Quick action context doesn't have a valid contact.");
        }
		
		console.log('###validEvent: ' + validEvent);
        return(validEvent);
    },
	saveEvent: function(component){
		var accId = component.get("v.accountId");
		var conId = component.get("v.contact.Id");
		console.log('###conId: ' + conId);
		
		component.set("v.hasErrors", false);
		// Prepare the action to create the new contact
		var saveEventAction = component.get("c.saveEventWithContact");
		saveEventAction.setParams({
			"evt": component.get("v.newEvent"),
			"contactId": component.get("v.contact.Id"),
			"accountId": component.get("v.accountId"),
            "BSTAssociatedCriticalMetricsID": component.get("v.BSTAssociatedCriticalMetricsID")
		});

		// Configure the response handler for the action
		saveEventAction.setCallback(this, function(response) {	
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {
				
				// Prepare a toast UI message
				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Event Saved",
					"message": "The new Event was created."
				});

				// Update the UI: close panel, show toast, refresh account page
				$A.get("e.force:closeQuickAction").fire();
				resultsToast.fire();
				//$A.get("e.force:refreshView").fire();
    
				var navEvt = $A.get("e.force:navigateToSObject");
			    navEvt.setParams({
			      "recordId": response.getReturnValue().Id
			    });
			    navEvt.fire();
			}
			if (state === "INCOMPLETE") {
            }
			
			if (state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                                 
                        component.set('v.errorMessage', errors[0].message);
                        component.set('v.hasErrors', true);
                    }
                    
                    else if (errors[0] && errors[0].pageErrors) {
                    	component.set("v.errorMessage", errors[0].pageErrors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set('v.hasErrors', true);
            }

		});
            // Send the request to create the new event
            $A.enqueueAction(saveEventAction);
        },
    loadContacts : function(component) {
        var action = component.get("c.getAssociatedContacts");
        action.setParams({"contactId": component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
                
            } else {
                console.log('Problem getting contacts, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    loadProfiles: function(component) {
        var action = component.get("c.getUserProfile"); // method in the apex class
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(component.isValid() && state === "SUCCESS") {
            
                component.set("v.profileName", a.getReturnValue()); // variable in the component
            
            } else {
                console.log('Problem getting Profiles, response state: ' + state);
            }   
        });
        $A.enqueueAction(action);
    },
    
     setEndDateHelper : function(component) {
        var startDateTime = component.get("v.newEvent.StartDateTime");
        var action = component.get("c.getEndDateTime");
        action.setParams({
            "startDate": startDateTime
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){                 
                component.set("v.newEvent.EndDateTime", response.getReturnValue());
            }else{
                console.log('error in set End Date: ' + state);
            }
        });
        $A.enqueueAction(action);   
        console.log('endDate' +startDateTime);
    },
})