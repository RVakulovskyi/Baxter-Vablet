public with sharing class dm_encodeBig3 {
	
	public static pageReference encodeACL(){
		database.executeBatch(new dm_batchEncoder('contact', 'firstname', 'firstMeta__c', 'lastname', 'lastMeta__c'));
		database.executeBatch(new dm_batchEncoder('account', 'name', 'nameMeta__c'));
		database.executeBatch(new dm_batchEncoder('lead', 'firstname', 'firstMeta__c', 'lastname', 'lastMeta__c', 'company', 'companyMeta__c'));
		return new pageReference('/home/home.jsp'); 
	} 
	  
	
}