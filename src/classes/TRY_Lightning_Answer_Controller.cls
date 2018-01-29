public with sharing class TRY_Lightning_Answer_Controller {
@AuraEnabled
    
      public static boolean saveAnswer(Id accountId, Id questionId, string answerValue) {
      
      system.debug('##################################################### YB saveAnswer');    
      
      Answer__c a = new Answer__c();
      a.account__c = accountId;
      a.question__c = questionId;
      a.Answer_Statement__c = answerValue;
      //a.=;
      
      //try{
      
      system.debug('##################################################### YB a ' + a);    
      insert a;
      //}
      
      /*catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
            + e.getMessage());    
        
      }*/
        
      return true;
      } 
      
        
      public static List<Answer__c> getAnswers() {
      
      try{
      /*Record_Types__mdt AccountCompetitorRT_MDT =  [SELECT Id, MasterLabel, Developer_Name__c
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
      }      */   
                 
      List<Answer__c> answers = 
                [SELECT Id, Name
                 FROM Answer__c];
                 //where RecordTypeId =: accountCompetitorRT.Id];
      
      /*if(competitors !=null){    
      system.debug('##################################################### YB competitors' + competitors);    
      }  */       
                
                 //AND 
                 //ADD SPECIFIC CRITERIA HERE
                
        //Add isAccessible() check
        return answers;
      }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
            + e.getMessage());    
        }
        
    
    } 
}