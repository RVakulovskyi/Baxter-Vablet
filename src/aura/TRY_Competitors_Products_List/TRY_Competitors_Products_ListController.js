({
    doInit : function(component, event, helper) {
        // Retrieve products during component initialization
        helper.loadProducts(component);
        
        //var action = component.get("c.getProducts");
        //action.setParams({
          //  "accountId": component.get("v.recordId")
        //});
    },
    
    handleSelect : function(component, event, helper) {
        var products = component.get("v.products");
        var productList = component.get("v.productList");

        //Get the selected option: "Referral", "Social Media", or "All"
        var selected = event.getSource().get("v.value");
    
        var filter = [];
        var k = 0;
        for (var i=0; i<productList.length; i++){
            var c = productList[i];
            if (selected != "All"){
                if(c.LeadSource == selected) {
                    filter[k] = c;
                    k++; 
                }
            }
            else {
                   filter = productList;
            }       
        }
        //Set the filtered list of products based on the selected option
        component.set("v.products", filter);
        //helper.updateTotal(component);
    }
})