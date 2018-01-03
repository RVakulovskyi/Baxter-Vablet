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
       // change background color on response change for BUProfiling
        if(cmp.get('v.isForBUProfiling') === true){
            var cmpTarget = cmp.find('lookup-pill');
            $A.util.addClass(cmpTarget, 'responsebackcolor');
		 }
    },
     
    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
        helper.clearSelection(cmp);    
      // change background color on response change for BUProfiling
        if(cmp.get('v.isForBUProfiling') === true){
            var cmpTarget = cmp.find('lookup');
            $A.util.addClass(cmpTarget, 'responsebackcolor');
		 }
    },
    
    hideResutls: function(cmp, event, helper) {
    	console.log('###hide');
    	var lookupList = cmp.find('lookuplist');
 		var lookupmenu = cmp.find('lookupmenu');
    	$A.util.addClass(lookupList, 'slds-hide');
        $A.util.addClass(lookupmenu, 'slds-hide');
    }
})