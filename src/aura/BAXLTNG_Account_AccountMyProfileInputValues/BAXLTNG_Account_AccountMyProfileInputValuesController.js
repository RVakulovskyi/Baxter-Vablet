({
	doInit : function(component, event, helper) {
       helper.setSelectedAccount(component, event, helper);		
	},
    
    onResponseChange : function(component, event, helper) {
        helper.onResponseChangeHelper(component, event, helper);
        
    },
    
    onMultiPicklistChange : function(component, event, helper){
        helper.onMultiPicklistChangeHelper(component, event, helper);        
    }, 
    
    onChangeValue : function(component, event, helper){
        helper.onChangeValueHelper(component, event, helper);
    },
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var Id = event.getParam("sObjectId");
        var attName = event.getParam("attributeName");
        if(Id != null){
            if(attName === 'AccountId'){
               component.set("v.qPreview.proxyObj.BST_Selected_Account__c",Id); 
            }
            if(attName === 'ContactId'){
               component.set("v.qPreview.proxyObj.BST_Selected_Account__c",Id); 
            }        
        }
    },
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleIdClear : function(component, event, helper) {
        // Clear the Id bound to the View
        var attName = event.getParam("attributeName");
        if(attName === 'AccountId')
        {
        	component.set('v.qPreview.proxyObj.BST_Selected_Account__c', undefined);
        }
        if(attName === 'ContactId')
        {
        	component.set('v.qPreview.proxyObj.BST_Selected_Account__c', null);
        }
    },
   
          		
})