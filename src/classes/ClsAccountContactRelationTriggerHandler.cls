//Nuno Fonseca 01/04/2016
//Alok 10/116/2017 -- code updated to allow deletion for certain profiles.

public class ClsAccountContactRelationTriggerHandler {

    public void preventAcountContactRelationDeletion(List<AccountContactRelation> listOfAccConRel)
    {
        Set<Id> accSet = new Set<Id>();
        Set<Id> conSet = new Set<Id>();
        List<Account> accIMSlst = new List<Account>();
        List<Contact> conIMSlst = new List<Contact>();
        String accRecTypeName = 'BST_IMS_Account';
        String conRecTypeName = 'BST_IMS_Contact';
        String bstNoDeleteRelationship = Label.BST_No_Delete_Relationship; //This relationship cannot be deleted!
        
        for(AccountContactRelation acr:listOfAccConRel)
        {
            accSet.add(acr.AccountId);
            conSet.add(acr.ContactId);
        }
        
        RecordType accRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName=:accRecTypeName LIMIT 1];
        RecordType conRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName=:conRecTypeName LIMIT 1];
        
        for(Account acc:[SELECT Id,RecordTypeId FROM Account WHERE Id IN:accSet AND RecordTypeId=:accRecType.Id])
        {
            accIMSlst.add(acc);
        }
        
        for(Contact con:[SELECT Id,RecordTypeId FROM Contact WHERE Id IN:conSet AND RecordTypeId=:conRecType.Id])
        {
            conIMSlst.add(con);
        }
        
        //BOOS-935 -- start
        profile currentUserProfile = [Select Name from Profile where Id = :userinfo.getProfileid()];
        string profileName = currentUserProfile.Name;
        boolean allowDeletion = false;
        set<string> excludedProfiles =new set<string>();
        excludedProfiles.addall(system.label.BST_Profiles_Excluded.split(','));
        if(excludedProfiles.contains(profileName))allowDeletion = true;
        
        for(AccountContactRelation accConRel:listOfAccConRel)
        {
            for(Account acc:accIMSlst)
            {
                if(!accConRel.IsDirect && (accConRel.AccountId==acc.Id) && !allowDeletion)
                    accConRel.adderror(bstNoDeleteRelationship);
            }
            for(Contact con:conIMSlst)
            {
                if(!accConRel.IsDirect && (accConRel.ContactId==con.Id) && !allowDeletion)
                    accConRel.adderror(bstNoDeleteRelationship);
            }
        }
    }
}