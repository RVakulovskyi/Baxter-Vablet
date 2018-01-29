({
   loadcompetitors : function(cmp) {
        // Load all competitor data
        var action = cmp.get("c.getCompetitors");
        //action.setParams({
          //  "accountId": cmp.get("v.recordId")
        //})
        ;
       
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.competitors", response.getReturnValue());
                //cmp.set("v.competitorList", response.getReturnValue());
                this.updateTotal(cmp);
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your competitors have been loaded successfully."
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
     
    updateTotal: function(cmp) {
      var competitors = cmp.get("v.competitors");
      cmp.set("v.totalcompetitors", competitors.length);
    }, 
    
    getCompetitorsByCountry : function(cmp) {
        // Load all product data
        var action = cmp.get("c.serverGetCompetitorsByCountry");
        action.setParams({
            "serverCountryNameValue": cmp.get("v.countryInputValue")
        });
       
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.competitors", response.getReturnValue());
                //cmp.set("v.competitorsList", response.getReturnValue());
                //this.updateTotal(cmp);
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Competitors for this country have been loaded successfully."
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
    }
})