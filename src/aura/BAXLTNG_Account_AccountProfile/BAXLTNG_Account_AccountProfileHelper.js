({
	/*
     * @Desc -- Fetches current Account Record 
     */ 
    getAccountInformation : function(cmp, event, helper){
       
        var action = cmp.get("c.getAccount");
        action.setParams({
            "accountId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(a) {
           
            if (a.getState() == 'SUCCESS') {
                cmp.set("v.account", a.getReturnValue()); 
                cmp.set("v.accountId", cmp.get("v.recordId"));
                this.getCurrentTheme(cmp, event, helper);
                this.checkPermission(cmp, event, helper);
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
    
    showErrorMessage: function(cmp, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": message,
            "type": "error"
        });
        toastEvent.fire();
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
    
     checkPermission : function (cmp, event, helper){
		var action = cmp.get("c.checkPermission");
        
        action.setCallback(this, function(a) {
           
            if (a.getState() == 'SUCCESS') {
                console.log('result for checkpermission::'+ a.getReturnValue());
                cmp.set("v.isRenderMyProfile", a.getReturnValue()); 
                //cmp.set("v.isRenderMyProfile", true); 
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
    returnToAccount : function (cmp, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
    	dismissActionPanel.fire();
	}
})