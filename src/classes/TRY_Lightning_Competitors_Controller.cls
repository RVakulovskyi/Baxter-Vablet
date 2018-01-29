public with sharing class TRY_Lightning_Competitors_Controller {

@AuraEnabled    
      public static List<Account> getCompetitors() {
      
      try{
      Record_Types__mdt AccountCompetitorRT_MDT =  [SELECT Id, MasterLabel, Developer_Name__c
                 FROM Record_Types__mdt
                 where MasterLabel = 'Competitor'];
      
      if(AccountCompetitorRT_MDT !=null){    
      system.debug('##################################################### YB AccountCompetitorRT_MDT' + AccountCompetitorRT_MDT);    
      }         
      
      RecordType accountCompetitorRT =  [SELECT Id, Name
                 FROM RecordType
                 where DeveloperName =: AccountCompetitorRT_MDT.Developer_Name__c];
      
      if(accountCompetitorRT !=null){    
      system.debug('##################################################### YB accountCompetitorRT' + accountCompetitorRT);    
      }         
                 
      List<Account> competitors = 
                [SELECT Id, Name, RecordTypeId
                 FROM Account
                 where RecordTypeId =: accountCompetitorRT.Id];
      
      if(competitors !=null){    
      system.debug('##################################################### YB competitors' + competitors);    
      }         
                
                 //AND 
                 //ADD SPECIFIC CRITERIA HERE
                
        //Add isAccessible() check
        return competitors;
      }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
            + e.getMessage());    
        }
        
    }

@AuraEnabled    
    public static List<Account> serverGetCompetitorsByCountry(string serverCountryNameValue) {
      
      List<Account> competitors = new List<Account>();
      system.debug('##################################################### YB getCompetitors(country)');    
      
      try{
      Record_Types__mdt AccountCompetitorRT_MDT =  [SELECT Id, MasterLabel, Developer_Name__c
                 FROM Record_Types__mdt
                 where MasterLabel = 'Competitor'];
      
      if(AccountCompetitorRT_MDT !=null){    
      system.debug('##################################################### YB AccountCompetitorRT_MDT' + AccountCompetitorRT_MDT);    
      }         
      
      RecordType accountCompetitorRT =  [SELECT Id, Name
                 FROM RecordType
                 where DeveloperName =: AccountCompetitorRT_MDT.Developer_Name__c];
      
      if(accountCompetitorRT !=null && serverCountryNameValue !=null){
      system.debug('##################################################### YB accountCompetitorRT' + accountCompetitorRT);    
      system.debug('##################################################### YB serverCountryNameValue' + serverCountryNameValue);    
               
      competitors = 
                [SELECT Id, Name, RecordTypeId, BST_COUNTRY__c
                 FROM Account
                 where RecordTypeId =: accountCompetitorRT.Id and BST_COUNTRY__c =: serverCountryNameValue];
      
      if(competitors !=null){    
      system.debug('##################################################### YB competitors' + competitors);    
      }         
                
                 //AND 
                 //ADD SPECIFIC CRITERIA HERE
                
        //Add isAccessible() check
        
      }
      return competitors;
      }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
            + e.getMessage());    
        }
        
    }
}