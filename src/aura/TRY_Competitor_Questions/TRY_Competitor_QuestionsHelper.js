({
		//console.log(error);
		//$A.log("callback error", response.getError());

    loadQuestions : function(cmp) {
        //YB: Load all question data
        var action = cmp.get("c.getQuestions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.questions", response.getReturnValue());
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your questions have been loaded successfully."
                });
            }
            else {
                toastEvent.setParams({
                        "title": "Error!",
                        "message": "Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
    },
    
    loadQuestions2 : function(cmp) {
        
        //YB: Load all question data
        var action = cmp.get("c.getSecondQuestion");
        action.setParams({
            //"parentQuestionId": cmp.get("v.question1Id")
            "parentQuestionId": cmp.get("v.selectedValue")
        });
        
       action.setCallback(this, function(response) {
	        
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.questions2", response.getReturnValue());
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your questions have been loaded successfully."
                });
            }
            else {
                toastEvent.setParams({
                        "title": "Error!",
                        "message": "Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
    
    },
        
    createAnswer : function(cmp) {
        //debugger;
        //YB:Create a new Answer record and save it with the answer value provided by the user on the page.
          var action1 = cmp.get("c.saveAnswer");
          action1.setParams({
          "accountId": cmp.get("v.recordId"),
          "questionId": cmp.get("v.question1Id"),
          "answerValue": cmp.get("v.answer1")
        });
        
            action1.setCallback(this, function(response) {
             
            var state = response.getState();
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            
            if (state === 'SUCCESS'){
                	cmp.set("v.SaveAnswerTEST", response.getReturnValue());
            		toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your answer has been saved successfully."
                });
            }
            else {
                toastEvent.setParams({
                        "title": "Error!",
                        "message": " Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        
         $A.enqueueAction(action1);
    },
    
    createAnswer2 : function(cmp) {
        //debugger;
        //YB:Create a new Answer record and save it with the answer value provided by the user on the page.
          var action1 = cmp.get("c.saveAnswer");
          action1.setParams({
          "accountId": cmp.get("v.recordId"),
          "questionId": cmp.get("v.question2Id"),
          "answerValue": cmp.get("v.answer2")
        });
        
            action1.setCallback(this, function(response) {
             
            var state = response.getState();
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            
            if (state === 'SUCCESS'){
                	//cmp.set("v.SaveAnswerTEST", response.getReturnValue());
            		toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your answer has been saved successfully."
                });
            }
            else {
                toastEvent.setParams({
                        "title": "Error!",
                        "message": " Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        
         $A.enqueueAction(action1);
    }
     
})