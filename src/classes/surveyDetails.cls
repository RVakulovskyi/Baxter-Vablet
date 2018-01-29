public class surveyDetails {
    
    public Id surveyTargetId{get; set;}    
    public Survey_Target__c surveyTarget;
    public Survey_Response__c surveyResponceReason;
    public Survey_Response__c surveyResponceImprovement;
	public map<string, string> responses{get; set;}
     
    
    public Survey_Target__c getSurvey()
    {       
        surveyTarget = [SELECT Id,Account__r.Name,Contact__r.Name,Contact__r.Phone,Detractor__c,NPS_Value__c,Survey_Completed_Date__c,Survey_Sent_Date__c ,
                        Territory_Business_Manager__r.Name
                          FROM Survey_Target__c
                         WHERE Id = :surveyTargetId];
        return surveyTarget;
    }
    
    public Survey_Response__c getReason()
    {
        
        surveyResponceReason = [SELECT Id,Question_Identifier__c,Text_Value__c 
                            FROM Survey_Response__c
                           WHERE Survey_Target__c = :surveyTargetId and Question_Identifier__c = 'Score Reason'];
        
        
        /*if(surveyResponce.size() > 0){
            for(Survey_Response__c responce:surveyResponce){
                responces.put(responce.Question_Identifier__c, responce.Text_Value__c) ;
            }
        }
        system.debug('responces' +responces);*/
        //reason = responces.get('Score Reason');
        //improvement = responces.get('Better Partner');
        return surveyResponceReason;
    }
    
    public Survey_Response__c getImprovement()
    {
        system.debug('surveyTargetId' +surveyTargetId);
        surveyResponceImprovement = [SELECT Id,Question_Identifier__c,Text_Value__c 
                            FROM Survey_Response__c
                           WHERE Survey_Target__c = :surveyTargetId and Question_Identifier__c = 'Better Partner'];
        
        
        return surveyResponceImprovement;
    }
    
    public map<string,string> getresponseMap(){
        
        list<Survey_Response__c> surveyResponse = [SELECT Id,Question_Identifier__c,Text_Value__c 
                            FROM Survey_Response__c
                           WHERE Survey_Target__c = :surveyTargetId ];
        responses.put('T1', 'T2') ;
        /*if(surveyResponse.size() > 0){
            for(Survey_Response__c response:surveyResponse){
                responses.put(response.Question_Identifier__c, response.Text_Value__c) ;
            }
        }*/
        return responses;
    }
    
    

}