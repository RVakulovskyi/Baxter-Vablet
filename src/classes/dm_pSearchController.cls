public with sharing class dm_pSearchController {

    Integer myVarValue; //Added by Arpit Agarwal
    public string criteria{get;set;}
    public List<Contact> Cnct_IRL{get;set;}
    public List<Contact> Cnct_DRL{get;set;}
    
    public List<Lead> Lead_IRL{get;set;}
    public List<Lead> Lead_DRL{get;set;}
    
    public List<Account> Acct_IRL{get;set;}
    public List<Account> Acct_DRL{get;set;}
    public boolean showResults{get;set;}
    
    public boolean cnct_show{get;set;}
    public boolean lead_show{get;set;}
    public boolean acct_show{get;set;}
    
    public dm_pSearchController(){
    
        
    RestrictPhoneticRecords__c cs = RestrictPhoneticRecords__c.getOrgDefaults();  //Added by Arpit Agarwal
    myVarValue=(Integer)cs.NumOfRecords__c ;  //Added by Arpit Agarwal
    
        cnct_show = false;
        lead_show = false;
        acct_show = false;      
        
        cnct_IRL = new List<Contact>();
        cnct_DRL = new List<Contact>();
        Lead_IRL = new List<Lead>();
        Lead_DRL = new List<Lead>();
        Acct_IRL = new List<Account>();
        Acct_DRL = new List<Account>();
        if(ApexPages.CurrentPage().getParameters().get('criteria') == null)
            {
                criteria = '';
                showResults = false;
            }
        else
        {
                criteria = Apexpages.currentPage().getParameters().get('criteria');
                superSearch();
        }
    }
    
    public void superSearch(){
        //Changes by Arpit Start
        if(myVarValue > 1000){
           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, System.Label.Phonetic_Error));
           return;
    
        } //Changes by Arpit End
        if(criteria.trim().length() == 0)
        {
            showResults = false;
            return;
        }
        cnct_show = false;
        lead_show=false;
        acct_show = false;
        
        string critCode = dm_doubleMetaphone.encode(criteria);
        showResults = false;
        acct_SuperSearch(critcode);
        cnct_SuperSearch(critcode);
        //lead_SuperSearch(critcode);
    }
    
    public void acct_SuperSearch(string critcode){
        string criteriaStatic = '%' + criteria + '%';
        //acct_DRL = database.query('select name, id from Account where name like \'%' + criteria + '%\'');
        acct_DRL = [select name, id from Account where name like :criteriaStatic LIMIT : myVarValue]; //Prevent SOQL injection 
        
        string dResultIDs = '';
        if(Acct_DRL.size() > 0)
            {
                acct_show = true;
                for(Account c : Acct_DRL)
                {
                    dResultIDs += c.id + '\',\'';
                }
                dResultIds = dResultIDs.substring(0,dResultIDs.length()-3);
            }
            string query = 'select name, id from Account where id not in (\'' + dResultIDs + '\') and nameMeta__c like \'%' + critCode + '%\' LIMIT : myVarValue';
            acct_IRL = database.query(query);
            if(acct_IRL.size() > 0)
                acct_show=true;
        
        showResults = true;
    
    }
    
   /* public void lead_SuperSearch(string critcode){
        string criteriaStatic = '%' + criteria + '%';   
        //lead_DRL = database.query('select name, id, company from Lead where name like \'%' + criteria + '%\' or company like \'%' + criteria + '%\'');
        lead_DRL = [select name, id, company from Lead where name like :criteriaStatic or company like :criteriaStatic];
            string dResultIDs = '';
            if(lead_DRL.size() > 0)
            {
                lead_show = true;
                for(Lead c : lead_DRL)
                {
                    dResultIDs += c.id + '\',\'';
                }
                dResultIds = dResultIDs.substring(0,dResultIDs.length()-3);
            }
            string query = 'select name, company, id from Lead where id not in (\'' + dResultIDs + '\') and (firstMeta__c like \'%' + critCode + '%\' or firstMeta__c like \'%' + critCode + '%\' or companyMeta__c like \'%' + critCode + '%\')';
            lead_IRL = database.query(query);
            if(lead_IRL.size() > 0)
                lead_show = true;
        
        showResults = true;
    }*/
    
    public void cnct_SuperSearch(string critcode){
        string criteriaStatic = '%' + criteria + '%';
        //cnct_DRL = database.query('select name, id, accountID, account.name from Contact where name like \'%' + criteria + '%\' or account.name like \'%' + criteria + '%\'');
        cnct_DRL = [select name, id, AccountID, account.name, Account.ParentId, Account.Parent.Name from Contact where name like :criteriaStatic or account.name like :criteriaStatic LIMIT : myVarValue]; //Modified by Arpit Agarwal to restrict records
            string dResultIDs = '';
            if(cnct_DRL.size() > 0)
            {
                cnct_show = true;
                for(Contact c : cnct_DRL)
                {
                    dResultIDs += c.id + '\',\'';
                }
                dResultIds = dResultIDs.substring(0,dResultIDs.length()-3);
            }
            //string query = 'select name, AccountID, id from Contact where id not in (\'' + dResultIDs + '\') and (metaphone1__c = \'' + critCode + '\' or metaphone2__c = \'' + critCode + '\')';
            string query = 'select name, AccountID, accountMeta__c, id, Account.ParentId, Account.Parent.Name from Contact where id not in (\'' + dResultIDs + '\') and (firstMeta__c like \'%' + critCode + '%\' or lastMeta__c like \'%' + critCode + '%\' or accountMeta__c like \'%' + critCode + '%\') LIMIT : myVarValue'; //Modified by Arpit Agarwal
            cnct_IRL = database.query(query);
            if(cnct_irl.size() > 0)
                cnct_show = true;
        
        showResults = true;     
    }
    
    
    
}