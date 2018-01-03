({
	getCategoryOptions : function(cmp, event, helper) {
		var action	= cmp.get("c.getCategoryOptionList");
   //     var selectedactiverecords = cmp.find("selectedactiverecords").get("v.value");
     var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
    var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value") == undefined ? 'All': cmp.find("Subcategories").get("v.value");
      console.log('majorcategorii::'+selectedCategoryValue+'::'+selectedSubCategoryValue);
        action.setParams({
            "recordId" : cmp.get("v.recordId"),
            "sObjectApiName" : 'Account',
         //   "selectedactiverecords": selectedactiverecords,
            "selectedactiverecords": true, 
            "selectedCategory" : selectedCategoryValue,
            "selectedSubCategory" : selectedSubCategoryValue
            
        });
        action.setCallback(this, function(a) {
            if (cmp.isValid() && a.getState() === "SUCCESS") {
                this.getCurrentTheme(cmp, event, helper);
                var response = a.getReturnValue();
                var total = [];                
                for (var i = 0; i < response.length; i++) {
                    if(i==0){
                        continue;
                    }                   
				total.push(response[i]);
                }                
                cmp.set("v.majorcategoryoptlist", total);
                
                var opts = [];
                
               // opts.push({"class": "optionClass", label: '--none--', value:''});
                for (var i = 0; i < response.length; i++) {
                    opts.push({"class": "optionClass", label: response[i], value: response[i]});
                }
                
                cmp.find("categories").set("v.options", opts);
            } else if (a.getState() === "ERROR") {
            	$A.log("ERROR", a.getError());
        	}
        });

     
        $A.enqueueAction(action);
	},
    
    //Added for BOOS-630 - Start
    
    getReports : function(cmp, event, helper) {
		var action	= cmp.get("c.getAvailableReports");
        action.setCallback(this, function(a) {
            if (cmp.isValid() && a.getState() === "SUCCESS") {     
                var response = a.getReturnValue();
                var opts = [];
                opts.push({"class": "optionClass", label: '--None--'});
                for (var i = 0; i < response.length; i++) {
                    opts.push({"class": "optionClass", label: response[i].Name, value: response[i].Id});
                }                
                cmp.find("reports").set("v.options", opts);
            } else {
                console.log('Problem getting recordtype values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
   }, //Added for BOOS-630 - End
    
    getSubCategoryOptions : function(cmp, event, helper) {
		var action	= cmp.get("c.getSubCategoryOptionList");
    //    var selectedactiverecords = cmp.find("selectedactiverecords").get("v.value");
        var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
        cmp.find("Subcategories").set("v.value","ALL");
        var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value");
        console.log('subcategorii::'+selectedCategoryValue+'::'+selectedSubCategoryValue);
        action.setParams({
            "recordId" : cmp.get("v.recordId"),
            "sObjectApiName" : 'Account',
       //     "selectedactiverecords": selectedactiverecords,
            "selectedactiverecords": true,
            "selectedCategory" : selectedCategoryValue,
            "selectedSubCategory" : selectedSubCategoryValue
        });
        action.setCallback(this, function(a) {
            if (cmp.isValid() && a.getState() === "SUCCESS") {
                this.getCurrentTheme(cmp, event, helper);
                var response = a.getReturnValue();
                var total = [];                
                for (var i = 0; i < response.length; i++) {
                    if(i==0){
                        continue;
                    }                   
				total.push(response[i]);
                }                
                cmp.set("v.subcategoryoptlist", total);
                
                var opts = [];
                
               // opts.push({"class": "optionClass", label: '--none--', value:''});
                for (var i = 0; i < response.length; i++) {
                    opts.push({"class": "optionClass", label: response[i], value: response[i]});
                }
                
                cmp.find("Subcategories").set("v.options", opts);
            } else if (a.getState() === "ERROR") {
            	$A.log("ERROR", a.getError());
        	}
        });

     
        $A.enqueueAction(action);
	},
  
    getAccountProfileWrapperList : function(cmp, event, helper){

        var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
        var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value") == undefined ? 'All': cmp.find("Subcategories").get("v.value");
    //    var selectedactiverecords = cmp.find("selectedactiverecords").get("v.value");
        var selectedExpiredResponse = cmp.find("selectedExpiredResponse").get("v.value");
        console.log('response::'+selectedCategoryValue+'::'+selectedSubCategoryValue);
        if(selectedCategoryValue !== 'All'){
            cmp.set("v.subcategorysummary", true);
        }else{
            cmp.set("v.subcategorysummary", false);
        }
        cmp.set("v.selectedCategory",  selectedCategoryValue);
        cmp.set("v.selectedSubCategory",  selectedSubCategoryValue);

        var action	= cmp.get("c.getAccountIncrementCounter");

        action.setParams({
            "accountId" : cmp.get("v.recordId"),
            "selectedCategory" : selectedCategoryValue,
            "selectedSubCategory" : selectedSubCategoryValue,
            "selectedactiverecords": true,
         //   "selectedactiverecords": selectedactiverecords
            "selectedActiveResponse": selectedExpiredResponse,
        });
        

        action.setCallback(this, function(a) {

            if (a.getState() === "SUCCESS") {

                var response = a.getReturnValue();

           	    cmp.set("v.responseWrpList", response);
                var tempwrplist = JSON.parse(JSON.stringify(response));
                cmp.set("v.tempresponseWrpList", tempwrplist);
                cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")-1);

                // Code to get major category summary ***starts***************
                //code to add summary section::
                var majorarr = cmp.get("v.majorcategoryoptlist"); //store major category from getCategoryOptions function    
                var resmajorarr = []; //array from response list, extracting to get major category
                var expmajorarr = []; // array to store expired major category
                var unansmajorarr = []; // array to store unanswered major category
                var occurcount =[];//array to store count of major category
                var expoccurcount = [];//array to store expired major category
                var unansoccurcount = [];//array to store unanswered major category
                
                //extracting response list to get major category
                for(var i =0; i< response.length; i++)
                {
                    resmajorarr[i] = response[i].category;
                 if(response[i].isExpired === true)
                 {
                    expmajorarr[i] = response[i].category; 
                 }
                 if(response[i].responseID === undefined || response[i].responseID === null || response[i].responseID === '')
                 {
                    unansmajorarr[i] = response[i].category; 
                 }
                }
               
                //getting count of major category
                for(var j = 0; j< majorarr.length; j++)
                {
                	var target = majorarr[j];                    
                    var numOccurences = $.grep(resmajorarr, function (elem) {
                            return elem === target;
                        }).length;
                    occurcount.push(numOccurences);
                        
                    var ExpnumOccurences = $.grep(expmajorarr, function (elem) {
                            return elem === target;
                        }).length;
                    expoccurcount.push(ExpnumOccurences);                
                    
                    var UnansnumOccurences = $.grep(unansmajorarr, function (elem) {
                            return elem === target;
                        }).length;
                    unansoccurcount.push(UnansnumOccurences);     
                }
                
                cmp.set("v.occurancecount", occurcount);
            	cmp.set("v.expoccurancecount", expoccurcount);
                cmp.set("v.unansoccurancecount", unansoccurcount);
                
                // Code to get major category summary ***ends**************
                //*********************************************************************************
                // Code to get Sub category summary ***Starts******
    
                var subarr = cmp.get("v.subcategoryoptlist");////store Sub category from getSubCategoryOptions function
                var ressubarr = []; //array from response list, extracting to get sub category
                var expsubarr = []; // array to store expired sub category
                var unanssubarr = []; // array to store unanswered sub category
                var suboccurcount =[];//array to store count of sub category
                var subexpoccurcount = [];//array to store expired sub category
                var subunansoccurcount = [];//array to store unanswered sub category
                
                //extracting response list to get major category
                for(var i =0; i< response.length; i++)
                { 
                    ressubarr[i] = response[i].subcategory;
                 if(response[i].isExpired === true)
                 {
                    expsubarr[i] = response[i].subcategory; 
                 }
                 if(response[i].responseID === undefined || response[i].responseID === null || response[i].responseID === '')
                 {
                    unanssubarr[i] = response[i].subcategory; 
                 }
                }
               
                //getting count of major category
                for(var j = 0; j< subarr.length; j++)
                {
                	var target = subarr[j];                    
                    var subnumOccurences = $.grep(ressubarr, function (elem) {
                            return elem === target;
                        }).length;
                    suboccurcount.push(subnumOccurences);
                        
                    var subExpnumOccurences = $.grep(expsubarr, function (elem) {
                            return elem === target;
                        }).length;
                    subexpoccurcount.push(subExpnumOccurences);                
                    
                    var subUnansnumOccurences = $.grep(unanssubarr, function (elem) {
                            return elem === target;
                        }).length;
                    subunansoccurcount.push(subUnansnumOccurences);     
                }
                
                cmp.set("v.suboccurancecount", suboccurcount);
            	cmp.set("v.subexpoccurancecount", subexpoccurcount);
                cmp.set("v.subunansoccurancecount", subunansoccurcount);
                
                // Code to get sub category summary ***ends**************
                
                cmp.set("v.questioncount", response.length);
                
             // end of code to add summary section
                
            } else if (a.getState() === "ERROR") {
               
            	$A.log("ERROR", a.getError());
               
        	}
        });

        cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")+1);
        $A.enqueueAction(action);
    },
    
    
    saveResponses : function(cmp, event, helper){
     	console.log(cmp.get("v.savereslist"));
      //  debugger;
  		//console.log($A.util.json.encode(cmp.get("v.responseWrpList")));
        var action	= cmp.get("c.saveResponse");
        
        var responseWrpList = cmp.get("v.savereslist");
        if(!$A.util.isEmpty(responseWrpList) && !$A.util.isUndefined(responseWrpList)){
            for(var i =0; i<responseWrpList.length;i++){
                if(responseWrpList[i].isPicklist && responseWrpList[i].SelectedAnswerPicklist == '--None--'){
                    responseWrpList[i].SelectedAnswerPicklist = '';
                }
            }
        }
        action.setParams({
            "responseJson" : JSON.stringify(responseWrpList),
            "sObjectApiName" : 'Account'
        });
        
        
        action.setCallback(this, function(a) {
            console.log(a.getState());
            if (a.getState() === "SUCCESS") {
                var response = a.getReturnValue();
             //   var tempwrplist = JSON.parse(JSON.stringify(responseWrpList));
            //    cmp.set("v.tempresponseWrpList", tempwrplist);
                if(cmp.get("v.currentTheme") == 'Theme4t'){
                    this.createMessage(cmp, response, 'Information','info');
                }else{
                    this.showSaveSuccessful(cmp, response);
                }
            	
             //   
             //   var dismissActionPanel = $A.get("e.force:closeQuickAction");
        	//	dismissActionPanel.fire();
 
                var profileUpdated = $A.get("e.c:BAXLTNG_ProfileEventOnSave");
            
                profileUpdated.fire();
                
            } else if (a.getState() === "ERROR") {
               var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // System Error
                        if(cmp.get("v.currentTheme") == 'Theme4t'){
                            this.createMessage(cmp,errors[0].message , 'Error','error');
                        }else{
                            this.showErrorMessage(cmp, errors[0].message);
                        }
                         
                    } else if (errors[0] && errors[0].pageErrors) {
                        // DML Error
                        if(cmp.get("v.currentTheme") == 'Theme4t'){
                            this.createMessage(cmp,errors[0].message , 'Error','error');
                        }else{
                            this.showErrorMessage(cmp, errors[0].pageErrors[0].message);
                        }
                         
                    }
               
        		}
            }
        });

     
        $A.enqueueAction(action);
    },
    
    saveAndReturn : function(cmp, event, helper){
     	console.log(cmp.get("v.responseWrpList"));
      //  debugger;
  		console.log($A.util.json.encode(cmp.get("v.responseWrpList")));
        var action	= cmp.get("c.saveResponseIntermediately");
        
        action.setParams({
            "responseJson" : $A.util.json.encode(cmp.get("v.responseWrpList")),
            "sObjectApiName" : 'Account'
        });
        
        
        action.setCallback(this, function(a) {
            console.log(a.getState());
            if (a.getState() === "SUCCESS") {
               // this.showSaveSuccessful(cmp, response);
                var response = a.getReturnValue();                
                
                this.navigateToRecord(cmp, event, helper);
                
                this.createMessage(cmp, response, 'Information', 'info');
            } else if (a.getState() === "ERROR") {
               var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // System Error
                        //this.showErrorMessage(cmp, errors[0].message);
                        this.createMessage(cmp,errors[0].message , 'Error' ,'error');
                    } else if (errors[0] && errors[0].pageErrors) {
                        // DML Error
                       // this.showErrorMessage(cmp, errors[0].pageErrors[0].message);
                        this.createMessage(cmp,errors[0].message , 'Error', 'error');
                    }
               
        		}	
        	}
        });

     
        $A.enqueueAction(action);
    },
    
    showSaveSuccessful: function(cmp, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": message,
            "type": "Success"
        });
        toastEvent.fire();
	},
    
	showErrorMessage: function(cmp, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": message,
            "type": "error"
        });
        toastEvent.fire();
	},
    
    navigateToRecord : function (cmp, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": cmp.get("v.recordId"),
          "slideDevName": "detail"
        });
    	navEvt.fire();
	},
    
    getCurrentTheme : function (cmp, event, helper){
		var action = cmp.get("c.getUIThemeDescription");
        
        action.setCallback(this, function(a) {
           
            if (a.getState() == 'SUCCESS') {
                cmp.set("v.currentTheme", a.getReturnValue()); 
            }else if(a.getState() === "ERROR"){
                var errors = a.getError();
                 if (errors) {
                    if (errors[0] && errors[0].message) {
                       this.showErrorMessage(cmp, message);
                    }
                }
            }
            
        });
        $A.enqueueAction(action);        
    },
    
    getuserlang :function(component){    
        var action = component.get("c.getuserlanguage");
        action.setCallback(this, function(response)
    {   
        var state = response.getState();
        if(state==="SUCCESS" )
     {
    	component.set("v.userLanguage", response.getReturnValue());
                
      }
        else
        {
            console.log('Problem getting recordtypeid value, response state: ' + state);            
        }
                                                               
    });
	$A.enqueueAction(action);
	},  
    
    createMessage : function(cmp, message, title, severity){
        $A.createComponents([
                            ["ui:message",{
                                "title" : title,
                                "severity" : severity,
                                "closable" : true
                            }],
                            ["ui:outputText",{
                                "value" : message
                            }]
                            ],
                            function(components, status, errorMessage){
                               
                                    var msg = components[0];
                                    var outputText = components[1];
                                    // set the body of the ui:message to be the ui:outputText
                                    msg.set("v.body", outputText);
                                   
                                    var divMessage = cmp.find("message");
                                    // Replace div body with the dynamic component
                                    divMessage.set("v.body", msg);
                                
                            }
         );
    },
    
    ToggleCollapseHandler : function(component, event) {  
        var existingText = component.get("v.collpaseText"); 
        var container = component.find("containerCollapsable") ;
        
        if(existingText === "[ + ]"){
             component.set("v.collpaseText","[ - ]");
             component.set("v.showsummary",true);
        }else{
            component.set("v.collpaseText","[ + ]");
            component.set("v.showsummary",false); 
        }  
	},
    
    ToggleReportCollapseHandler : function(component, event) {  
        var existingText = component.get("v.collpaseReport"); 
        
        if(existingText === "[ + ]"){
             component.set("v.collpaseReport","[ - ]");
             component.set("v.showReport",true);
        }else{
            component.set("v.collpaseReport","[ + ]");
            component.set("v.showReport",false); 
        }  
	},
	
    responseCheck :function(cmp, event, helper) 
    {
        var reslist = cmp.get("v.responseWrpList");
        var tempreslist = cmp.get("v.tempresponseWrpList");
        var savereslist = [];
        for(var m =0;m<tempreslist.length;m++)
        {
            for(var n=0;n<reslist.length;n++)
            {
                
                if(tempreslist[m].questionID == reslist[n].questionID)
                { 
                  // for number respose type  
                   if(tempreslist[m].isNumber == true && reslist[n].isNumber == true) 
                    {
                       if(tempreslist[m].proxyObj.BST_Selected_Number__c !== reslist[n].proxyObj.BST_Selected_Number__c || reslist[n].isSameValueApplies === true)
                       {   
                           savereslist.push(reslist[n]);
                       }
                    }
                    
                  // for date response type
                   if(tempreslist[m].isDate == true && reslist[n].isDate == true) 
                    {
                       if(tempreslist[m].proxyObj.BST_Selected_Date__c !== reslist[n].proxyObj.BST_Selected_Date__c || reslist[n].isSameValueApplies === true)
                       {
                           savereslist.push(reslist[n]);
                       }
                    }  
                    
                  // for text response type
                   if(tempreslist[m].isText == true && reslist[n].isText == true) 
                   { if(reslist[n].proxyObj.BST_Selected_TextArea__c == ''){
                       reslist[n].proxyObj.BST_Selected_TextArea__c = undefined;
                   }
                       if(tempreslist[m].proxyObj.BST_Selected_TextArea__c !== reslist[n].proxyObj.BST_Selected_TextArea__c || reslist[n].isSameValueApplies === true)
                       {
                           savereslist.push(reslist[n]);
                       }
                    }
                 // for picklist response type
                  if(tempreslist[m].isPicklist == true && reslist[n].isPicklist == true) 
                  {   
                      if(tempreslist[m].SelectedAnswerPicklist !== reslist[n].SelectedAnswerPicklist || reslist[n].isSameValueApplies === true)
                      {
                           savereslist.push(reslist[n]); 
                      }    
                  }
                 
                 // for multi-picklist response type
                  if(tempreslist[m].isMultiselect == true && reslist[n].isMultiselect == true)
                  {   var tempmultiarr = [];
                      var resmultiarr = [];
                      for(var q=0; q<tempreslist[m].answerOptionCheckboxes.length;q++)
                  		{
                            if(tempreslist[m].answerOptionCheckboxes[q].selected === true){
                                tempmultiarr.push(tempreslist[m].answerOptionCheckboxes[q].answerOption);
                            }
                  		}
                   
                      for(var w=0; w<reslist[n].answerOptionCheckboxes.length;w++)
                  		{
                            if(reslist[n].answerOptionCheckboxes[w].selected === true){
                                resmultiarr.push(reslist[n].answerOptionCheckboxes[w].answerOption);
                            }
                  		}
					if(JSON.stringify(tempmultiarr) !== JSON.stringify(resmultiarr) || reslist[n].isSameValueApplies === true)
                    	{
    					savereslist.push(reslist[n]);
						}							

                  }
                    
                  // for Account response type
                  if(tempreslist[m].isAccountLookup == true && reslist[n].isAccountLookup == true)
                  { 
                   
                      if(tempreslist[m].proxyObj.BST_Selected_Account__c !== reslist[n].proxyObj.BST_Selected_Account__c)
                      { 
                       savereslist.push(reslist[n]);
                      }
                  }
                }
            }

        }
        console.log('savelist'+JSON.stringify(savereslist));
        cmp.set("v.savereslist",savereslist);
    },
    onClickExpiredFilterHelper :function(cmp, event, helper){
        var checkvalue = cmp.find("selectedExpiredResponse").get("v.value");
        console.log('currentvalue'+checkvalue);
		this.responseCheck(cmp, event, helper);
        var savewrplist = cmp.get("v.savereslist");
        if(savewrplist.length !== 0)
        { if(checkvalue === false)
        {
            checkvalue = true;
        } else {
            checkvalue = false;
        }
           cmp.find("selectedExpiredResponse").set("v.value", checkvalue);
           cmp.set("v.alertmodalbox",true);
        }
    }
})