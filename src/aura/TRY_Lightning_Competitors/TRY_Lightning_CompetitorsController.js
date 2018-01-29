({
    doInit : function(component, event, helper) {
        // Retrieve competitors during component initialization
        helper.loadcompetitors(component);
        
        //var action = component.get("c.getcompetitors");
        //action.setParams({
          //  "accountId": component.get("v.recordId")
        //});
    },
    
    handleSelect : function(component, event, helper) {
        var competitors = component.get("v.competitors");
        //var competitorList = component.get("v.competitorList");

        //Get the selected option: "Referral", "Social Media", or "All"
        var selected = event.getSource().get("v.value");
    
        var filter = [];
        var k = 0;
        for (var i=0; i<competitorList.length; i++){
            var c = competitorList[i];
            if (selected != "All"){
                if(c.LeadSource == selected) {
                    filter[k] = c;
                    k++; 
                }
            }
            else {
                   filter = competitorList;
            }       
        }
        //Set the filtered list of competitors based on the selected option
        component.set("v.competitors", filter);
        helper.updateTotal(component);
    },
    
    getCompetitorsByCountry : function(component, event, helper) {
        
        helper.getCompetitorsByCountry(component);
        
    }
    
})