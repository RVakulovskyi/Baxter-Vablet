({
   loadProducts : function(cmp) {
        // Load all product data
        var action = cmp.get("c.getProducts");
        action.setParams({
            "accountId": cmp.get("v.recordId")
        });
       
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.products", response.getReturnValue());
                cmp.set("v.productList", response.getReturnValue());
                //this.updateTotal(cmp);
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your products have been loaded successfully."
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
         $A.enqueueAction(action);
    },
     
    /*updateTotal: function(cmp) {
      var products = cmp.get("v.products");
      cmp.set("v.totalproducts", products.length);
    }*/
})