({
    
    onResponseChangeHelper : function(component, event, helper) {
        if(component.get("v.qPreview.isNumber") === true){
            var cmpTarget = component.find('numberfield');
            $A.util.addClass(cmpTarget, 'responsebackcolor');
            
		 }
        
        if(component.get("v.qPreview.isDate") === true){
            var cmpTarget = component.find('datefield');
            $A.util.addClass(cmpTarget, 'responsebackcolor');
		 }
        
        if(component.get("v.qPreview.isText") === true){
            var cmpTarget = component.find('textfield');
            $A.util.addClass(cmpTarget, 'responsetextbackcolor');
		 }
        
        if(component.get("v.qPreview.isPicklist") === true){
            var cmpTarget = component.find('answerOptionsString');
            $A.util.addClass(cmpTarget, 'responsebackcolor');
		 }                      
        
    },
    
    onMultiPicklistChangeHelper : function(component, event, helper){
        var clickedID = event.currentTarget.id;
        $("#"+clickedID).addClass("responsebackcolor"); 
    }, 
    
    onChangeValueHelper : function(component, event, helper){
        if(component.find("isSameValueApplies").get("v.value") === true)
            {               
             component.set("v.qPreview.isSameValueApplies",true);
            } 
    
    },
    
    setSelectedAccount : function(component, event, helper){
        if(component.get("v.qPreview.proxyObj.BST_Selected_Account__c") !== undefined && component.get("v.qPreview.isAccountLookup") === true)
        { 
            component.set('v.isEdit', true);
            var searchstring = component.get("v.qPreview.selectedaccountname");
            component.set('v.searchString',searchstring);
        }
    }
    
   
          		
})