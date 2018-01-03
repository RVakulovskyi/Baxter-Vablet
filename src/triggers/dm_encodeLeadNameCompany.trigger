trigger dm_encodeLeadNameCompany on Lead (before insert, before update) {
	if(trigger.isInsert)
		for(Lead c : trigger.new)
		{
			c.firstMeta__c = dm_doubleMetaphone.encode(c.firstName);
			c.lastMeta__c = dm_doubleMetaphone.encode(c.lastName);
			c.companyMeta__c = dm_doubleMetaphone.encode(c.company);
		}
	else
	{
		Map<ID, Lead> oLeadMap = trigger.oldMap;
		Lead old;
		for(Lead c : trigger.new)
		{
			old = oleadMap.get(c.id);
			if(old.firstName != c.firstName)
				c.firstmeta__c = dm_doubleMetaphone.encode(c.firstName);
			if(old.lastName != c.lastName)
				c.lastmeta__c = dm_doubleMetaphone.encode(c.lastName);
			if(old.company != c.company)
				c.companymeta__c = dm_doubleMetaphone.encode(c.company);
		}
	}
}