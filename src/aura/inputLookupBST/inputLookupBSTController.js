({
    /**
     * Search an SObject for a match
     */
    search : function(cmp, event, helper) {
        helper.doSearch(cmp);        
    },
 
    /**
     * Select an SObject from a list
     */
    select: function(cmp, event, helper) {
        helper.handleSelection(cmp, event);
    },
     
    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
        helper.clearSelection(cmp);    
    },
    
    hideResutls: function(cmp, event, helper) {
    	console.log('###hide');
    	var lookupList = cmp.find('lookuplist');
 		var lookupmenu = cmp.find('lookupmenu');
    	$A.util.addClass(lookupList, 'slds-hide');
        $A.util.addClass(lookupmenu, 'slds-hide');
    }
})