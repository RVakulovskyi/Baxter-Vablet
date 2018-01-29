(
	{
        
    doInit : function(component, event, helper) {
        // Retrieve products during component initialization
        helper.loadQuestions(component);
    },
        
    manageQuestion1 : function(component, event, helper) {
        
        component.set("v.question2",true);
        var question1Selected = component.find("Question1Select").get("v.value");
		component.set("v.selectedIDValueOK","OK!");
        component.set("v.question1Id", question1Selected);
        
        helper.loadQuestions2(component);
        
    },
      
 	manageQuestion2 : function(component) {
        
        //component.set("v.question2",true);
        var question2Selected = component.find("QuestionSelect2").get("v.value");
		//component.set("v.selectedIDValueOK","OK!");
        component.set("v.question2Id", question2Selected);
        
        //helper.loadQuestions3(component);
         
    },
     
    //handleSave : function(component, event, helper) {
    //helper.createAnswer(component);
    //({
   
    handleClick : function(cmp, event, helper) {
                
        helper.createAnswer(cmp);
                
        var attributeValue = cmp.get("v.text");
        console.log("current text: " + attributeValue);

        var target = event.getSource();
        cmp.set("v.text", target.get("v.label"));
    },

    handleClick2 : function(cmp, event, helper) {
                
        helper.createAnswer2(cmp);
                
        var attributeValue = cmp.get("v.text");
        console.log("current text: " + attributeValue);

        var target = event.getSource();
        cmp.set("v.text", target.get("v.label"));
    }
        
    }
)