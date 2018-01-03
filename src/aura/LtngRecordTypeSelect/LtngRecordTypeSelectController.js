({
    doInit : function(component,event,helper){
        helper.loadRecordTypes(component, event, helper);
    },
     
    onChange : function(component, event, helper) {
		var value = event.getSource().get("v.text");
        component.set('v.selectedRecordType', value);
	},
    defaultCloseAction : function (component, event, helper) {
    	var homeEvent = $A.get("e.force:navigateToObjectHome");
    	homeEvent.setParams({
        "scope": "Question__c"
    	});
    	homeEvent.fire();
    },
    onconfirm : function(component, event, helper) {
        var valChk = component.get("v.selectedRecordType");
		if($A.util.isEmpty(valChk)){
			var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
                    "type": "error",
					"message": $A.get("$Label.c.BST_RecTypeError")
				});
			resultsToast.fire();
        }
        else{ 
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:LtngCompQuestion",
            componentAttributes: {
                quesRecordType : component.get("v.selectedRecordType")
            }
        });
        evt.fire();
        }
    }
})