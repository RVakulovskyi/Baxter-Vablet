/*************************************************************************************************
Apex Trigger Name : TgrEventTrigger                                                              *
Version : 1.0                                                                                    *
Created Date : 18/04/2017                                                                        *  
Function :  Trigger created to manage all actions for Event object                               *
                                                                                                 *
Modification Log:                                                                                *
-------------------------------------------------------------------------------------------------*
* Developer                 Date                Description                                      *
* -----------------------------------------------------------------------------------------------*
* Nuno Fonseca              18/04/2017          New trigger framework to follow best practices   *    
* Arpit Agarwal             04/24/2017          Trigger to stamp Notes from Previous call field  *
                                                on the same contact, Validate Country/Baxter Team *
                                                Values and Deny Deletion                         *
*************************************************************************************************/
trigger TgrEventTrigger on Event (before insert, before update, before delete, after insert, after update, after delete) 
{
    ClsEventTriggerHandler eventTriggerHandler = new ClsEventTriggerHandler();
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            eventTriggerHandler.validateValues(trigger.new);
        }
        if(Trigger.isUpdate)
        {
            eventTriggerHandler.validateValues(trigger.new);
        }
        if(Trigger.isDelete)
        {
            eventTriggerHandler.preventCompletedEventDeletion(trigger.old);
        }
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            eventTriggerHandler.insertComment(trigger.new); 
            eventTriggerHandler.insertEventPrimaryContact(trigger.new);            
        }
        if(Trigger.isUpdate)
        {
            eventTriggerHandler.updateCallNotes(trigger.new,trigger.oldmap);
        }
    }
}