({
    loadUserDetails : function(component) {
		var recId = component.get("v.recordId");
		var action = component.get("c.getUserCountry");
		action.setCallback(this, function(response){
				var state = response.getState();
				if(component.isValid() && state === "SUCCESS") {
					component.set("v.userCountry", response.getReturnValue());
                //    component.set("v.newQuestion.BST_COUNTRY__c", response.getReturnValue());

				} else {
					console.log('Problem getting account, response state: ' + state);
				}
			});
		$A.enqueueAction(action);
	},
	loadUserCountryDetails : function(component, event, helper) {
		var recId = component.get("v.recordId");
		var action = component.get("c.getUserInfo");
		action.setCallback(this, function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				component.set("v.isSecondaryCountryEmpty", response.getReturnValue());
				
			} else {
				console.log('Problem getting user Country, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
	},
	loadCountryValues : function(component, event, helper){
		var action = component.get("c.getCountryValues");
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if($A.util.isUndefined(component.get("v.recordId")) || $A.util.isEmpty(component.get("v.recordId"))) {
                    component.set("v.country", response.getReturnValue()[0]);
                    this.loadMajorCategories(component, event, helper);
                    this.loadSalesforceGroup(component, event, helper);
                }
             /*else{
                    component.set("v.country", null);
             }*/
            	var secondaryEmpty = component.get("v.isSecondaryCountryEmpty");
            	if(secondaryEmpty == false) {
	                for(var i=0;i< response.getReturnValue().length;i++){
	                    if(component.get("v.userCountry") == response.getReturnValue()[i]) {
	                        options.push({"class": "optionClass", "selected" : "true", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
	                    }
	                    else
	                        options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
	                }
	                component.find("questionCountry").set("v.options", options);
	            }
                else {
                	for(var i=0;i< response.getReturnValue().length;i++){
                		if(component.get("v.userCountry") == response.getReturnValue()[i]) {
                			options.push({"class": "optionClass", "selected" : "true", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                            
                		}
                        component.find("questionCountry").set("v.options", options);
                	}
                }
                
            } else {
                console.log('Problem getting country values, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    //Get the Major Category Picklist values based on Coutry Field
    loadMajorCategories : function(component, event, helper){
		var action = component.get("c.getMajorCategory");
        var countryVal = component.get("v.country");
        action.setParams({
            "country" : countryVal
        });
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("questionMajorCategory").set("v.options", options);
            } else {
                console.log('Problem getting Major Categories values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
	//Get the Category Picklist values based on Major Category Field
	loadCategories : function(component, event, helper){
		var action = component.get("c.getCategory");
        var majCtgry = component.get("v.majorCatType");  
        action.setParams({
            "majCategory" : majCtgry
        });
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("questionCategory").set("v.options", options);
            } else {
                console.log('Problem getting Categories values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    //Get the Question Type picklist fields only for Global Question
    loadQuestionType : function(component, event, helper){
		var action = component.get("c.getQuestionType")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("questionType").set("v.options", options);
            } else {
                console.log('Problem getting Question Type values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    //Get the Profile Type picklist fields only for Global Question
    loadProfileType : function(component, event, helper){
		var action = component.get("c.getProfileType")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("profileType").set("v.options", options);
            } else {
                console.log('Problem getting Profile Type values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
    //Fetches the Response type values using Describe
	loadResponseType : function(component, event, helper){
		var action = component.get("c.getResponseType")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("responseType").set("v.options", options);
            } else {
                console.log('Problem getting Response type values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},	
	//Get the Baxter User Group values
	loadSalesforceGroup : function(component, event, helper){
		var action = component.get("c.getSalesforceGroup");
        var cntryVal = component.get("v.country");
        action.setParams({
            "country" : cntryVal 
        });
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("salesforceGroup").set("v.options", options);
            } else {
                console.log('Problem getting Sales Group values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},

	/*loadSalesProcess : function(component){
		var action = component.get("c.getSalesProcess")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("salesProcess").set("v.options", options);
            } else {
                console.log('Problem getting Sales Process values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	}, */ //Hidden for Opportunity	
	//Loading the Status picklist field
	loadStatus : function(component, event, helper){
		var action = component.get("c.getStatus")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){                  
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("status").set("v.options", options);
                //Set the Status as Active for New record
               if($A.util.isUndefined(component.get("v.recordId")) || $A.util.isEmpty(component.get("v.recordId"))){ 
                component.find("status").set("v.value", response.getReturnValue()[1]);
               }    
            } else {
                console.log('Problem getting Status values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},
	//Get the record type values to display as a Picklist
	loadRecordTypes : function(component, event, helper){
		var action = component.get("c.getQuestionRecordTypes")
        action.setCallback(this, function(response){
            var options = [];
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                for(var i=0;i< response.getReturnValue().length;i++){
                    options.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
                component.find("questionRecordType").set("v.options", options);
            } else {
                console.log('Problem getting recordtype values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	},	
	    
    loadRecordTypeId : function(component, event, helper){

        var action = component.get("c.getRecordTypeId");
        action.setParams({
			"objApiName": "Question__c",
            "recordTypeLabel": component.get("v.quesRecordType")
		});
        action.setCallback(this, function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				component.set("v.newQuestion.RecordTypeId", response.getReturnValue());
			
			} else {
				console.log('Problem getting recordtypeid value, response state: ' + state);
			}
		});
		$A.enqueueAction(action);
    },
    //Handler method to Set the values and Insert/Update the Question object record
    saveQuestion: function(component, event, helper){
        var iserror = component.get("v.iserror");
        if(iserror === false)
        {
		component.set("v.newQuestion.BST_RESPONSE_VALID_TIME__c", component.get("v.responseDays"));
        component.set("v.newQuestion.BST_COUNTRY__c", component.get("v.country"));
		component.set("v.newQuestion.BST_MAJOR_CATEGORY__c", component.get("v.majorCatType"));
        component.set("v.hasErrors", false);
		// Prepare the action to create the new Question
		var saveQuestionAction = component.get("c.saveQuestion");
		saveQuestionAction.setParams({
			"que": component.get("v.newQuestion"),
		});

		// Configure the response handler for the action
		saveQuestionAction.setCallback(this, function(response) {	
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {
				
                if(component.get("v.recordId") != null){
                    var resultsToast = $A.get("e.force:showToast");
					resultsToast.setParams({
					"title": "Question Saved",
					"message": "The Question was edited successfully."
				 });
                    
               } 
                else{
                // Prepare a toast UI message
				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Question Saved",
					"message": "The new Question was created."
				});
				}
				// Update the UI: close panel, show toast, refresh page
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
            // Send the request to create the new question
            $A.enqueueAction(saveQuestionAction);
        }
        },
    //Handler method to handle the Edit functionality
    loadQuestionDetails : function(component, event, helper) {
        var LocalisedField=component.find('queslocal');
        var LocalRecord=component.find('localques');
        var action = component.get("c.getQuestionDetails");
        var sourceAnswer=component.find('answerOpt');
        //Prepare the action to edit the question
        action.setParams({
            "questionId": component.get("v.recordId")
        });
		action.setCallback(this, function(response) {
            var state = response.getState();  
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.newQuestion", response.getReturnValue());
                //component.set("v.newQuestion.BST_PROFILE_TYPE__c", response.getReturnValue().BST_PROFILE_TYPE__c);
                //component.set("v.newQuestion.BST_QUESTION_TYPE__c", response.getReturnValue().BST_QUESTION_TYPE__c);
                component.set("v.quesRecordType", response.getReturnValue().RecordType.Name);
                component.set("v.country", response.getReturnValue().BST_COUNTRY__c);
                component.set("v.majorCatType", response.getReturnValue().BST_MAJOR_CATEGORY__c);
                var searchStringid = response.getReturnValue().BST_PARENT_QUESTION__c;
                if (typeof searchStringid === 'undefined' || searchStringid.length < 1){
                    
                    component.set("v.searchString", ''); 
                } else {
                	component.set("v.searchString",response.getReturnValue().BST_PARENT_QUESTION__r.Name);
                }
                //Handles the visibility of Answer Options
                if (response.getReturnValue().BST_RESPONSE_TYPE__c == $A.get("$Label.c.BST_Picklist") || 
                    response.getReturnValue().BST_RESPONSE_TYPE__c == $A.get("$Label.c.BST_MultiPicklist")){       
                    $A.util.removeClass(sourceAnswer, 'slds-hide');
                }
                else
                {
                    $A.util.addClass(sourceAnswer, 'slds-hide');
                }
                //Handles the Visibility of fields related to Global/Local question
                if(response.getReturnValue().RecordType.Name != $A.get("$Label.c.BST_Global_Question")) {
                    $A.util.removeClass(LocalisedField, 'slds-hide');
                	$A.util.removeClass(LocalRecord, 'slds-hide');
                    //this.loadUserCountryDetails(component);
                    this.loadCountryValues(component, event, helper);
                    if(!$A.util.isUndefined(response.getReturnValue().BST_COUNTRY__c) && !$A.util.isEmpty(response.getReturnValue().BST_COUNTRY__c)) {
                        this.loadMajorCategories(component, event, helper);
                        this.loadSalesforceGroup(component, event, helper);
                    }
                    if(!$A.util.isUndefined(response.getReturnValue().BST_MAJOR_CATEGORY__c) && !$A.util.isEmpty(response.getReturnValue().BST_MAJOR_CATEGORY__c)){
                        this.loadCategories(component, event, helper); 
                    }
                }
                else{
                    this.loadQuestionType(component, event, helper);
            		this.loadProfileType(component, event, helper);
                }
                component.set("v.responseDays", response.getReturnValue().BST_RESPONSE_VALID_TIME__c);
            } else {
                console.log('Problem getting question, response state: ' + state);
            }
        });
        $A.enqueueAction(action);	
	},
    loadHelptext: function(component, event, helper) {
        //call apex class method 
        var action = component.get('c.getHelptextMap');
        action.setCallback(this, function(response) {
            //store response state 
            var state = response.getState();
            if (state === "SUCCESS") {
                // store the response of apex controller (return map)     
                var helpTextResponse = response.getReturnValue();
                // set the store response[map] to component attribute, which name is map and type is map.   
                component.set('v.helpTextMap', helpTextResponse);
                var i =1;
                for (var key in helpTextResponse) {
                    var idValue = $('#' + i);
                    if(typeof idValue != 'undefined'){
                        idValue.attr('title',helpTextResponse[key]);
                    }
                    i = i + 1;
                }
            }
        });
        // enqueue the Action   
        $A.enqueueAction(action);
    },
    
    	//Helper to display the tooltip.Modify code.
    	Displaytext: function(component,event,helper) 
    {
        	 var popover = component.find("popover1");
         $A.util.removeClass(popover,'slds-hide');
          	//   var toggleText2 = component.find("popover2");    
        	//   	$A.util.removeClass(popover2,'slds-hide');    
	              
  	},
   		 //Helper to display the tooltip.Modify code.	
   		 RRemovetext:function(component,event,helper)
   		 {
   			 var popover =component.find("popover1");
             $A.util.addClass(popover,'slds-hide');
          	  // var removeText2 =component.find("popover2");
    	 	   	   	
        	//    $A.util.addClass(popover2,'slds-hide');
	},

    
    checkerror : function(component, event) {
      component.set("v.iserror", false);
        
    if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_QUESTION_STATEMENT__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_QUESTION_STATEMENT__c")))
    {  
       component.find("statwarnings").set("v.value", 'Please enter Question Statement');
       component.set("v.iserror", true);
    }else
    {
        component.find("statwarnings").set("v.value", '');
    }

        if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_START_DATE__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_START_DATE__c")))
    {  
       component.find("startwarnings").set("v.value", 'Please Select Start Date');
        component.set("v.iserror", true);
    } else
    {
        component.find("startwarnings").set("v.value", '');
    }

          
        if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_END_DATE__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_END_DATE__c")))
    {  
        component.find("endwarnings").set("v.value", 'Please Select End Date');
        component.set("v.iserror", true);
    } else
    {
        component.find("endwarnings").set("v.value", '');
    }  
        
        
       if($A.util.isUndefinedOrNull(component.get("v.responseDays")) || $A.util.isEmpty(component.get("v.responseDays")))
	{ 
		component.find("responsevalidwarnings").set("v.value", 'Please enter the Response Valid Time (in days)');
        component.set("v.iserror", true);
	}else
    {
        component.find("responsevalidwarnings").set("v.value", '');
    }
	     
        if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_STATUS__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_STATUS__c")))
	{
		component.find("statuswarnings").set("v.value", 'Please Select a Valid Status');
        component.set("v.iserror", true);
	}
        else
        {
            component.find("statuswarnings").set("v.value", '');
        }
        
     if(component.get("v.newQuestion.BST_RESPONSE_TYPE__c") === 'Picklist' || component.get("v.newQuestion.BST_RESPONSE_TYPE__c") === 'Multi Picklist')
     {
      	   if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_ANSWER_OPTIONS__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_ANSWER_OPTIONS__c")))
	{
		component.find("Answeroptionwarnings").set("v.value", 'Please Select a Valid Answer Options');
        component.set("v.iserror", true);
            
	}else
    {
        component.find("Answeroptionwarnings").set("v.value", '');
    }

    }
        
    if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_RESPONSE_TYPE__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_RESPONSE_TYPE__c")))
	{
		component.find("responsetypewarnings").set("v.value", 'Please enter the Valid Response Type');
        component.set("v.iserror", true);
        
	}else
    {
        component.find("responsetypewarnings").set("v.value", '');
    }
    
     if(component.get("v.quesRecordType") !== 'Global Question')
     {     if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_SALESFORCE_GROUP__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_SALESFORCE_GROUP__c")))
            {
                component.find("salesgrpwarnings").set("v.value", 'Please Select a Baxter User Group');
                component.set("v.iserror", true);
            }
                else
                {
                    component.find("salesgrpwarnings").set("v.value", '');
                }
                
                 if($A.util.isUndefinedOrNull(component.get("v.majorCatType")) || $A.util.isEmpty(component.get("v.majorCatType")))
            {
                component.find("majorcatwarnings").set("v.value", 'Please Select a Major Category');
                component.set("v.iserror", true);
            }
                else
                {
                    component.find("majorcatwarnings").set("v.value", '');
                }
      
                if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_ORDER__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_ORDER__c")))
                {
                    component.find("quesorder").set("v.value", 'Please Select Order');
                    component.set("v.iserror", true);
                }
                else
                {
                    component.find("quesorder").set("v.value", '');
                }  
    } 
        
      	if(component.get("v.quesRecordType") === 'Global Question')
         {
         if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_QUESTION_TYPE__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_QUESTION_TYPE__c")))
                {
                    component.find("questypewarnings").set("v.value", 'Please Select a Question Type');
                    component.set("v.iserror", true);
                }
                else
                {
                    component.find("questypewarnings").set("v.value", '');
                }
        
         if($A.util.isUndefinedOrNull(component.get("v.newQuestion.BST_PROFILE_TYPE__c")) || $A.util.isEmpty(component.get("v.newQuestion.BST_PROFILE_TYPE__c")))
                {
                    component.find("profiletypewarnings").set("v.value", 'Please Select a Profile Type');
                    component.set("v.iserror", true);
                }
                else
                {
                    component.find("profiletypewarnings").set("v.value", '');
                }
         
         }
        
    }
    
})