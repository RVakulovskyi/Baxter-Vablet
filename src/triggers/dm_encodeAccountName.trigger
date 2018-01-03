trigger dm_encodeAccountName on Account (before insert, before update) {
	if(trigger.isInsert)
	{
		for(Account a : trigger.new)
		{
			a.nameMeta__c = dm_doubleMetaphone.encode(a.name);
		}
	}
	else
	{
		MAP<ID, Account> oAcctMap = trigger.oldMap;
		Account old;
		for(Account a : trigger.new)
		{
			old = oAcctMap.get(a.id);
			if(old.name != a.name)
				a.nameMeta__c = dm_doubleMetaphone.encode(a.name);
		}
	}
}