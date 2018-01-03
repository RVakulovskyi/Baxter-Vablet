global class dm_batchEncoder implements Database.Batchable<sObject>{

	global final string query;
	
	global final string target1;
	global final string target2;
	global final string target3;
	global final string source1;
	global final string source2;
	global final string source3;
	global final string processedTable;
	global  string currentID;
	
	


	global dm_batchEncoder(string objectTable, string isource1, string itarget1){
		query = 'select id,' + isource1 + ' from ' + objectTable + ' where ' +isource1+ ' != null';
		
		
		target1 = itarget1;
		source1 = isource1;
		processedTable = objectTable;
		target2 = target3 = source2 = source3 = null;
	}
	
	global dm_batchEncoder(string objectTable, string isource1, string itarget1, string isource2, string itarget2)
	{
		query = 'select id,' + isource1 + ', ' + isource2 +' from ' + objectTable + ' where ' +isource1+ ' != null and ' + isource2 + ' != null';
		target1 = itarget1;
		source1 = isource1;
		target2 = itarget2;
		source2 = isource2;
		processedTable = objectTable;
		target3 = source3 = null;
	}
	 
	global dm_batchEncoder(string objectTable, string isource1, string itarget1, string isource2, string itarget2, string isource3, string itarget3)
	{
		query = 'select id,' + isource1 + ', ' + isource2 + ',' + isource3 + ' from ' + objectTable + ' where ' +isource1+ ' != null and ' + isource2 +' != null and ' + isource3 + ' != null';
		target1 = itarget1;
		source1 = isource1;
		target2 = itarget2;
		source2 = isource2;
		target3 = itarget3;
		source3 = isource3;
		processedTable = objectTable;
		
	}
	
	global database.Querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		for(sobject s : scope)
		{
			if(target1 != null && source1 != null)
			{
				s.put(target1, dm_doubleMetaphone.encode((string)s.get(source1)));
				
			}
				
			if(target2 != null && source2 != null)
			{
				s.put(target2, dm_doubleMetaphone.encode((string)s.get(source2)));
				
			}
			if(target3 != null && source3 != null)
			{
				
					s.put(target3, dm_doubleMetaphone.encode((string)s.get(source3)));
				
			}
			
		}
		update scope;
	}
	
	global void finish(Database.BatchableContext BC){
		AsyncApexJob a = [select id, status, numberoferrors, jobitemsprocessed, totaljobitems, createdBy.email from AsyncApexJob where id = :BC.getJobId()];
		
		messaging.Singleemailmessage mail = new Messaging.singleEmailMessage();
		
		string[] toAddresses = new String[] {a.createdBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject(processedTable + ' Phonetic Encoding ' + a.status);
		mail.setPlainTextBody('The batch apex job processed ' + a.jobItemsProcessed + ' batches with ' + a.numberOfErrors + ' failures. Final id was: ' + currentID);
		
		messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}
}