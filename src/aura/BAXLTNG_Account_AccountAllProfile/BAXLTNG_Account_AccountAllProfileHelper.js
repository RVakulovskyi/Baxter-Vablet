({
    getBaxterGroupOptions : function(cmp, event, helper) {
		var action = cmp.get("c.getGroupOptionList");//Add group function from LTNG
       
	var selectedBaxtergroup = cmp.find("baxtergroup").get("v.value") == undefined ? 'All':cmp.find("baxtergroup").get("v.value") ; // to fetch the value selected in the picklist
	    action.setParams({
            "recordId" : cmp.get("v.recordId"),
            "sObjectApiName" : 'Account',
			"selectedBaxtergroup" :selectedBaxtergroup
           
       });
			action.setCallback(this, function(a) {
            if (cmp.isValid() && a.getState() === "SUCCESS") {
               this.getCurrentTheme(cmp, event, helper);
                var response = a.getReturnValue();
				console.log('value of response in 14 is' , response );
                 var inputsel = cmp.find("baxtergroup"); 
                var opts=[];     //Array to store the group values to display
               
                opts.push({"class": "optionClass", label: 'All', value:'All'})
                
               for (var i = 0; i < response.length; i++) {
                    opts.push({"class": "optionClass", label: response[i], value: response[i]});  // To display Group Picklist on the component
                } 
        	    inputsel.set("v.options", opts);
                
                
                cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")-1);
            } else if (a.getState() === "ERROR") {
            	$A.log("ERROR", a.getError());
        	}
        });
        
      cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")+1);  
        
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
    
	getCategoryOptions : function(cmp, event, helper) {
		var action	= cmp.get("c.getCategoryOptionList");
    	var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
   		var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value") == undefined ? 'All': cmp.find("Subcategories").get("v.value");
    //	var selectedBaxtergroup = cmp.find("baxtergroup").get("v.value") == undefined ? 'All':cmp.find("baxtergroup").get("v.value") ;
	    action.setParams({
            "recordId" : cmp.get("v.recordId"),
            "sObjectApiName" : 'Account',
            "selectedactiverecords": true,
            "selectedCategory" : selectedCategoryValue,
            "selectedSubCategory" : selectedSubCategoryValue
       });
        action.setCallback(this, function(a) {
            if (cmp.isValid() && a.getState() === "SUCCESS") {
               this.getCurrentTheme(cmp, event, helper);
                var response = a.getReturnValue();
                console.log('value of response in 123 is' , response );
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
				cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")-1);
            } else if (a.getState() === "ERROR") {
            	$A.log("ERROR", a.getError());
        	}
        });
        
      cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")+1);  
        
        $A.enqueueAction(action);
	},
    
   getSubCategoryOptions : function(cmp, event, helper) {
        var action	= cmp.get("c.getSubCategoryOptionList");
        var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
        cmp.find("Subcategories").set("v.value","ALL");
        var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value");
        action.setParams({
            "recordId" : cmp.get("v.recordId"),
            "sObjectApiName" : 'Account',
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
        
    getAccountProfileWrapperList : function(cmp, event, helper){
        var selectedCategoryValue = cmp.find("categories").get("v.value") == undefined ? 'All': cmp.find("categories").get("v.value");
		var selectedSubCategoryValue = cmp.find("Subcategories").get("v.value") == undefined ? 'All': cmp.find("Subcategories").get("v.value");       
        var selectedExpiredResponse = cmp.find("selectedExpiredResponse").get("v.value");
        var selectedBaxtergroup = cmp.find("baxtergroup").get("v.value") == undefined ? 'All':cmp.find("baxtergroup").get("v.value") ;
        //$A.util.undefined for undefined
        if(selectedCategoryValue !== 'All'){
            cmp.set("v.subcategorysummary", true);
        }else{
            cmp.set("v.subcategorysummary", false);
        }
            
        cmp.set("v.selectedCategory",  selectedCategoryValue);
        cmp.set("v.selectedSubCategory",  selectedSubCategoryValue);
        cmp.set("v.baxterGroupAttribute",selectedBaxtergroup );
        var action	= cmp.get("c.getAccountIncrementCounter");
        
        action.setParams({
            "accountId" : cmp.get("v.recordId"),
            "selectedCategory" : selectedCategoryValue,
            "selectedSubCategory" : selectedSubCategoryValue,
            "selectedactiverecords": true,
            "selectedActiveResponse": selectedExpiredResponse,
            "baxterGroupAttribute"  :  selectedBaxtergroup,
        });       
        
        action.setCallback(this, function(a) {
           
            if (a.getState() === "SUCCESS") {
				var response = a.getReturnValue();
                cmp.set("v.responseWrpList", response);
                cmp.set("v.metadataLoading", cmp.get("v.metadataLoading")-1);
                            
             	// Code to get major category summary ***starts***************
                // Code to add summary section::
                
                var majorarr = cmp.get("v.majorcategoryoptlist"); //store major category from getCategoryOptions function    
                var resmajorarr = []; //array from response list, extracting to get major category
                var expmajorarr = []; // array to store expired major category
                var unansmajorarr = []; // array to store unanswered major category
                var occurcount =[];//array to store count of major category
                var expoccurcount = [];//array to store expired major category
                var unansoccurcount = [];//array to store unanswered major category

				var inputsel = cmp.find("baxtergroup"); 
                // Extracting user"group" to display
               	var opts=[];     //Array to store the group values to display
                
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
    
     onBaxterGroupChangeReset : function(cmp, event, helper)
        {
        cmp.find("categories").set("v.value","All");
        cmp.find("Subcategories").set("v.value","All");
        cmp.set("v.selectedCategory", 'All');
        cmp.set("v.selectedSubCategory",'All');
        cmp.find("selectedExpiredResponse").set("v.value",false); 
    },
    
        onCategoryChangeReset : function(cmp, event, helper)
    {
        cmp.find("baxtergroup").set("v.value","ALL");
        cmp.set("v.baxterGroupAttribute",'All' );
    },
        
    onSubCategoryChangeReset: function(cmp, event, helper)
    {
        cmp.find("baxtergroup").set("v.value","ALL");
    },	
        
    onResponseStatusChangeReset: function(cmp, event, helper)
    {
        cmp.find("baxtergroup").set("v.value","ALL");
        cmp.set("v.baxterGroupAttribute",'All' );
    }
})