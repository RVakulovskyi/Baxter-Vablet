({
	loadRecordTypes : function(component, event, helper){
		var action = component.get("c.getQuestionRecordTypes")
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {

                component.set('v.recordTypeList', response.getReturnValue());           
               
            } else {
                console.log('Problem getting recordtype values response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	}
 
})