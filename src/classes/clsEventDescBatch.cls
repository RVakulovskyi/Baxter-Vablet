global class clsEventDescBatch implements Database.Batchable<sObject>{
    global final String query;
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, 
         List<sObject> scope){
            list<Event> eveList = new list<Event>(); 
         	for(Sobject s : scope){
                Event eve = (Event)s;
                if(eve.BST_CALL_NOTES__c != '' && eve.BST_CALL_NOTES__c != null){
                    eve.Description = eve.BST_CALL_NOTES__c;
                    eveList.add(eve);
                }
              }      
         update eveList;   
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}