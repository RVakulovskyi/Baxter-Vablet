{
    pressok: function(cmp, event) {
        var profilecontinue = $A.get("e.c:BAXLTNG_QuesResponsesavecheck");
        profilecontinue.setParams({
            "Nochangecontinue" : false,
            "alertmodalbox" : false });
        profilecontinue.fire();
        var cmpTarget = cmp.find('alertmodalbox');
        $A.util.addClass(cmpTarget, 'hidediv');
    },
    
    presscancel: function(cmp, event) {
        var profilecontinue = $A.get("e.c:BAXLTNG_QuesResponsesavecheck");
        profilecontinue.setParams({
            "Nochangecontinue" : true,
        	"alertmodalbox" : false	});
        profilecontinue.fire();
        var cmpTarget = cmp.find('alertmodalbox');
        $A.util.addClass(cmpTarget, 'hidediv');
    }
}