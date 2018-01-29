/***********************************************************************************************
Apex Class Name - EventDefaultValidations 
* Rodion Vakulovskyi	  04/01/2018		   modifying class
* Rodion Vakulovskyi	  19/01/2018		   modifying class
************************************************************************************************/
public class EventDefaultValidations {
	public static Boolean flagForProcessing = true;
	static DefaultEventValues__c eventValue = DefaultEventValues__c.getInstance();

	public static void validateFields(List<Event> inputList, Map<Id, Event> oldMap) {
		System.debug(flagForProcessing);
		if(flagForProcessing){
			SObjectType eventType = Schema.getGlobalDescribe().get('Event');
			Map<String, Schema.SObjectField> eventFields = eventType.getDescribe().fields.getMap();
			for(sObject item : inputList) {
				for(String itemString : eventFields.keySet()) {
					if(item.get(itemString) == eventValue.DefaultValue__c) {
						item.addError(Label.BXT_Default_value_error);
					}
				}
			}
		}
	}
}