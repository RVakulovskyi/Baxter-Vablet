({
	doinit : function(cmp, event, helper) {
       //helper = cmp.getConcreteComponent().getDef().getHelper();
		helper.getCategoryOptions(cmp, event, helper);
        helper.getSubCategoryOptions(cmp, event, helper);
   		helper.getBaxterGroupOptions(cmp,event,helper);  
        helper.getAccountProfileWrapperList(cmp, event, helper);
        
	},
    
    onBaxterGroupChange : function(cmp,event,helper)
    {                                    
      	helper.onBaxterGroupChangeReset(cmp, event, helper);
        helper.getAccountProfileWrapperList(cmp, event, helper);  
    },
    
    onCategoryChange : function(cmp, event, helper){
        //helper = cmp.getConcreteComponent().getDef().getHelper();
       	helper.onCategoryChangeReset(cmp, event, helper);
        helper.getSubCategoryOptions(cmp, event, helper);
    	helper.getAccountProfileWrapperList(cmp, event, helper);    
    },
    
    onSubCategoryChange : function(cmp, event, helper){
      // cmp.find("baxtergroup").set("v.value","ALL");
      	helper.onSubCategoryChangeReset(cmp, event, helper);
        helper.getAccountProfileWrapperList(cmp, event, helper);    
    },
    
    onResponseStatusChange : function(cmp, event, helper){
        helper.onResponseStatusChangeReset(cmp,event,helper);
        helper.getAccountProfileWrapperList(cmp, event, helper);    
    },
    
    metadataLoaded : function(cmp, event, helper) {
        console.log("metadataLoading");
        if (cmp.get("v.metadataLoading") > 0) {
            return;}
    },
        
    ToggleCollapse : function(component, event, helper) { 
		helper.ToggleCollapseHandler(component, event);   
	},
    
    ToggleReportCollapse : function(component, event, helper) { 
		helper.ToggleReportCollapseHandler(component, event)
        if(component.get("v.showReport") === true){
        	helper.getReports(component, event, helper); // Added for BOOS-630
        }    
	},

	onReportChange : function(cmp, event, helper){
       	var address = cmp.find("reports").get("v.value");
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({
            "url": '/' + address
      });
       	evt.fire();
	}    
  
})