public with sharing class TRY_Lightning_Questions_Controller {
@AuraEnabled
            
      public static List<Question__c> getQuestions() {
        
      try{
        
      Record_Types__mdt CompetitorsQuestionRT_MDT =  [SELECT Id, MasterLabel, Developer_Name__c
                 FROM Record_Types__mdt
                 where MasterLabel = 'Competitor Question'];
      
      if(CompetitorsQuestionRT_MDT !=null){    
      system.debug('##################################################### YB CompetitorsQuestionRT_MDT' + CompetitorsQuestionRT_MDT);    
      }         
      
      RecordType CompetitorQuestionRT =  [SELECT Id, Name
                 FROM RecordType
                 where DeveloperName =: CompetitorsQuestionRT_MDT.Developer_Name__c];
      
      if(CompetitorQuestionRT !=null){    
      system.debug('##################################################### YB CompetitorQuestionRT' + CompetitorQuestionRT);    
      }         
        
      List<Question__c > questions = 
                [SELECT Id, Name, BST_STATUS__c, BST_QUESTION_STATEMENT__c, RecordTypeId, BST_PARENT_QUESTION__c
                 FROM Question__c
                 WHERE RecordTypeId =: CompetitorQuestionRT.Id 
                 AND BST_PARENT_QUESTION__c = null];

      if(questions !=null){    
      system.debug('##################################################### YB questions' + questions);    
      }         
     
        //Add isAccessible() check
        return questions;
        }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
        + e.getMessage());    
        }       
    }
    
      @AuraEnabled
      public static List<Question__c> getSecondQuestion(id parentQuestionId) {
      
      //public static List<Question__c> getSecondQuestion() {
       
      system.debug('##################################################### YB getSecondQuestion !');    
        
      try{
        
      List<Question__c> questions = new List<Question__c>();
      
      Record_Types__mdt CompetitorsQuestionRT_MDT =  [SELECT Id, MasterLabel, Developer_Name__c
                 FROM Record_Types__mdt
                 where MasterLabel = 'Competitor Question'];
      
      if(CompetitorsQuestionRT_MDT !=null){    
      system.debug('##################################################### YB CompetitorsQuestionRT_MDT' + CompetitorsQuestionRT_MDT);    
      }         
      
      RecordType CompetitorQuestionRT =  [SELECT Id, Name
                 FROM RecordType
                 where DeveloperName =: CompetitorsQuestionRT_MDT.Developer_Name__c];
      
      if(CompetitorQuestionRT !=null){    
      system.debug('##################################################### YB CompetitorQuestionRT' + CompetitorQuestionRT);    
      }         
      
      if(parentQuestionId != null){
      questions = 
                [SELECT Id, Name, BST_STATUS__c, BST_QUESTION_STATEMENT__c, RecordTypeId, BST_PARENT_QUESTION__c
                 FROM Question__c
                 WHERE RecordTypeId =: CompetitorQuestionRT.Id 
                 AND BST_PARENT_QUESTION__c =: parentQuestionId];
      }

      if(questions !=null){    
      system.debug('##################################################### YB questions' + questions);    
      }         
     
      //Add isAccessible() check
      return questions;
      }
        
        catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
        + e.getMessage());    
        }       
    }
    
    /*public static boolean saveAnswer(Id accountId, Id questionId, string answerValue) {
      
    boolean result = TRY_Lightning_Answer_Controller.saveAnswer(accountId, questionId, answerValue);
    return result;
    
    }*/
    
    @AuraEnabled
    public static boolean saveAnswer(Id accountId, Id questionId, string answerValue) {
      
      system.debug('##################################################### YB saveAnswer');    
      
      Answer__c a = new Answer__c();
      a.account__c = accountId;
      a.question__c = questionId;
      a.Answer_Statement__c = answerValue;
      //a.=;
      
      try{
      system.debug('##################################################### YB a ' + a);    
      insert a;
      }
      
      catch (Exception e) {
        // "Convert" the exception into an AuraHandledException
        throw new AuraHandledException('Something went wrong: '
            + e.getMessage());    
        
      }
        
      return true;
      } 
    
}