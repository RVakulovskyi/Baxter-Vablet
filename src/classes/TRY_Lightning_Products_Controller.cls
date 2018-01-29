public with sharing class TRY_Lightning_Products_Controller {

@AuraEnabled
public static List<BXGO_Competitor_Product__c> getProducts(id accountId) {
        
        try{
        
        List<BXGO_Competitor_Product__c> products = new List<BXGO_Competitor_Product__c>();
        
        if(accountId!=null)
            {
        system.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB compS list -> comp accountId : ' + accountId);
        
        products = [SELECT Id, Name, BXGO_Competitor__c, BXGO_List_Price__c, Count__c  
                    FROM BXGO_Competitor_Product__c
                    WHERE BXGO_Competitor__c =: accountId];

        //Add isAccessible() check
        system.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB compS list -> comp products : ' + products);
        }
        
             else {
             system.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ YB WARNING : Class TRY_Lightning_Products_Controller: accountId is null!');
             }    

        return products;
        }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
        + e.getMessage());    
        }
              
    }
    
}