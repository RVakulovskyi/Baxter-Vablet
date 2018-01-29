({
	doinit : function(cmp, event, helper){
     //  helper = cmp.getConcreteComponent().getDef().getHelper();
        helper.getAccountInformation(cmp, event, helper);
    },
    
    returnToAccount : function(cmp, event, helper){
       //helper = cmp.getConcreteComponent().getDef().getHelper();
        helper.returnToAccount(cmp, event, helper);
    }
})