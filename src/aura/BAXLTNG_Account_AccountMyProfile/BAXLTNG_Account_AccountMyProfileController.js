({
	doinit : function(cmp, event, helper) {
       // helper = cmp.getConcreteComponent().getDef().getHelper();
		helper.getCategoryOptions(cmp, event, helper);
        helper.getSubCategoryOptions(cmp, event, helper);
        helper.getAccountProfileWrapperList(cmp, event, helper);
        helper.getuserlang(cmp,event,helper); // added by Shashank 16-06-2017
	},
    
    onCategoryChange : function(cmp, event, helper){
       // helper = cmp.getConcreteComponent().getDef().getHelper();  

       helper.getSubCategoryOptions(cmp, event, helper);
       helper.getAccountProfileWrapperList(cmp, event, helper);   
    },
    
    onSubCategoryChange : function(cmp, event, helper){
        //helper = cmp.getConcreteComponent().getDef().getHelper();
        helper.getAccountProfileWrapperList(cmp, event, helper);  
    },
    
    onStatusChange : function(cmp, event, helper){
        //helper = cmp.getConcreteComponent().getDef().getHelper();
        
    	helper.getAccountProfileWrapperList(cmp, event, helper);    
    },
    onResponseStatusChange : function(cmp, event, helper){
        var savewrplist = cmp.get("v.savereslist");
        if(savewrplist.length == 0){
            helper.getAccountProfileWrapperList(cmp, event, helper);  }
    },
    
    metadataLoaded : function(cmp, event, helper) {
        console.log("metadataLoading");
        if (cmp.get("v.metadataLoading") > 0) {
            return;
        }
        
        console.log("metadataLoaded");

    },
    
    saveResponses : function(cmp, event, helper){
      //  helper = cmp.getConcreteComponent().getDef().getHelper();
        helper.responseCheck(cmp, event, helper);
        helper.saveResponses(cmp, event, helper);
        helper.getAccountProfileWrapperList(cmp, event, helper);
    },
    
    saveAndReturn : function(cmp, event, helper){
      //  helper = cmp.getConcreteComponent().getDef().getHelper();
        helper.saveAndReturn(cmp, event, helper);
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
    
    continueProfileCheck : function(component, event, helper) { 
        var Nochangecontinue = event.getParam("Nochangecontinue");
        var alertmodalbox = event.getParam("alertmodalbox");
        component.set("v.alertmodalbox",alertmodalbox);
        component.find("categories").set("v.disabled",false);
        component.find("Subcategories").set("v.disabled",false);
        if(Nochangecontinue === true){
            helper.getAccountProfileWrapperList(component, event, helper);
        }
    },
    
    onClickFilter : function(cmp, event, helper) {
		helper.responseCheck(cmp, event, helper);
        var savewrplist = cmp.get("v.savereslist");
        if(savewrplist.length !== 0)
        {   cmp.find("categories").set("v.disabled",true);
         	cmp.find("Subcategories").set("v.disabled",true);
    		cmp.set("v.alertmodalbox",true);
    	}
    } ,
    
    onClickExpiredFilter : function(cmp, event, helper) {
        helper.onClickExpiredFilterHelper(cmp, event, helper);
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