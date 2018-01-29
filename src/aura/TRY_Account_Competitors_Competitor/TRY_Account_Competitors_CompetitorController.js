({
    
    doInit : function(component, event, helper) {
        // Retrieve products during component initialization
        helper.loadProducts(component);
        
        //var action = component.get("c.getProducts");
        //action.setParams({
          //  "accountId": component.get("v.recordId")
        //});
    },
    
    goToRecord : function(component, event, helper) {
        // Fire the event to navigate to the contact record
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": component.get("v.competitor.Id")
        })
        sObjectEvent.fire();
    }
})