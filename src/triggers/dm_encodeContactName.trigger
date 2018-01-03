trigger dm_encodeContactName on Contact (before insert, before update) {
	if(trigger.isInsert)
		for(Contact c : trigger.new)
		{
			c.firstMeta__c = dm_doubleMetaphone.encode(c.firstname);
			c.lastMeta__c = dm_doubleMetaphone.encode(c.lastname);
			
		}
	else
	{
		MAP<ID, Contact> oCnctMap = trigger.oldMap;
		Contact old;
		for(Contact c : trigger.new)
		{
			old =oCnctMap.get(c.id);
			if(old.firstName != c.firstName)
				c.firstMeta__c = dm_doubleMetaphone.encode(c.firstName);
			if(old.lastName != c.lastName)
				c.lastmeta__c = dm_doubleMetaphone.encode(c.lastName);	
		}
	}
}