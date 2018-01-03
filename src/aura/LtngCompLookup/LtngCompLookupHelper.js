({
    /**
     * Perform the SObject search via an Apex Controller
     */
    doSearch : function(cmp) {
        // Get the search string, input element and the selection container
        var searchString = cmp.get('v.searchString');
        var inputElement = cmp.find('lookup');
        var fieldsToDisplay = cmp.get('v.fieldsToDisplay');
        var lookupList = cmp.find('lookuplist');
 		var lookupmenu = cmp.find('lookupmenu');
 		var currentRecord = cmp.get('v.currRecord');
        var isForBUProfiling = cmp.get('v.isForBUProfiling');
 		console.log('###currentRecord: ' + currentRecord);
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        
        // We need at least 3 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            $A.util.addClass(lookupmenu, 'slds-hide');
            
            return;
        }
        // Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
 		$A.util.removeClass(lookupmenu, 'slds-hide');
        $A.util.addClass(lookupmenu, 'slds-show');
        // Get the API Name
        var sObjectAPIName = cmp.get('v.sObjectAPIName');
 		
        var recordTypeName = cmp.get('v.recordTypeName'); //Added by Arpit
        
        // Create an Apex action
        var action = cmp.get('c.lookup');
 
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
 
        // Set the parameters
        //action.setParams({ "searchString" : searchString, "sObjectAPIName" : sObjectAPIName, "fieldsToDisplay" : fieldsToDisplay, "currRecord": currentRecord});
         
		action.setParams({
            "searchString" : searchString, 
            "sObjectAPIName" : sObjectAPIName, 
            "recordTypeName" : recordTypeName, 
            "fieldsToDisplay" : fieldsToDisplay, 
            "currRecord": currentRecord,
             "isForBUProfiling": isForBUProfiling
                         });

        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches = response.getReturnValue();
 				console.log('result' + JSON.stringify(matches));
                // If we have no matches, return nothing
                if (matches.length == 0)
                {
                    cmp.set('v.matches', null);
                    return;
                }
                 
                // Store the results
                cmp.set('v.matches', matches);
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                 
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        this.displayToast('Error', errors[0].message);
                    }
                }
                else
                {
                    this.displayToast('Error', 'Unknown error.');
                }
            }
        });
         
        // Enqueue the action                  
        $A.enqueueAction(action);                
    },
 
    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(cmp, event) {
        
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);
 
        // The Object label is the inner text)
        var objectLabel = event.currentTarget.textContent;
 
        // Log the Object Id and Label to the console
               
        // Create the UpdateLookupId event
        var updateEvent = cmp.getEvent("updateLookupIdEvent");
        var attName = cmp.get("v.idAttToPopulate");
        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "sObjectId" : objectId,
            "attributeName" : attName
        });
 
        // Fire the event
        updateEvent.fire();
 
        // Update the Searchstring with the Label
        cmp.set("v.searchString", objectLabel);
 
        // Hide the Lookup List
        var lookupList = cmp.find("lookuplist");
        var lookupmenu = cmp.find("lookupmenu");
        
        $A.util.addClass(lookupList, 'slds-hide');
 		$A.util.addClass(lookupmenu, 'slds-hide');
        
        //Show the disable Record Field
        var lookupPill = cmp.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');
 
        // Hide the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide'); 
 
    },
 
    /**
     * Clear the Selection
     */
    clearSelection : function(cmp) {
        // Create the ClearLookupId event
        var clearEvent = cmp.getEvent("clearLookupIdEvent");
        var attName = cmp.get("v.idAttToPopulate");
        cmp.set("v.isEdit",false);
     	clearEvent.setParams({
            "attributeName" : attName
        });
        
        // Fire the event
        clearEvent.fire();
 
        // Clear the Searchstring
        cmp.set("v.searchString", '');
 
        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');
 
        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide'); 

    },
 
    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId : function(elmId)
    {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
 
    /**
     * Display a message
     */
    displayToast : function (title, message) 
    {
        var toast = $A.get("e.force:showToast");
 
        // For lightning1 show the toast
        if (toast)
        {
            //fire the toast event in Salesforce1
            toast.setParams({
                "title": title,
                "message": message
            });
 
            toast.fire();
        }
        else // otherwise throw an alert
        {
            alert(title + ': ' + message);
        }
    }
})