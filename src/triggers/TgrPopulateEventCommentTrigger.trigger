trigger TgrPopulateEventCommentTrigger on Event (before insert, after insert, before update, before delete,after update) 
{
  //Arpit 01/31/2017
  //Description - Trigger to stamp Notes from Previous call field on the same contact  
  //Modified By Arpit
  //1.) Added the logic for multicountry check and product category check
    ClsEventTriggerHandler eventTriggerHandler = new ClsEventTriggerHandler();

     if(trigger.isInsert){ 
         if(trigger.isBefore){
             eventTriggerHandler.validateValues(trigger.new);
         } 
         if(trigger.isAfter){ 
             eventTriggerHandler.insertComment(trigger.new);   
         }   
     }
      if(trigger.isUpdate){
              if(trigger.isBefore){
               eventTriggerHandler.validateValues(trigger.new);
              }
              if(trigger.isAfter){
               eventTriggerHandler.updateCallNotes(trigger.new,trigger.oldmap); //Arpit Agarwal 02/06/2017
              }
      }
              
    //Nuno Fonseca 01/04/2016
    if(Trigger.isDelete)
    {
      eventTriggerHandler.preventCompletedEventDeletion(trigger.old);
    }
}