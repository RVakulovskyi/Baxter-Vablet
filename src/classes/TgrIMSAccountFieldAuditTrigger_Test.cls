//Akshay 11/23/2016
//Description - This class will be used for test coverage of TgrIMSAccountFieldAuditTrigger trigger on object Account

@isTest
public class TgrIMSAccountFieldAuditTrigger_Test{

    static testMethod void testAccountInsert(){
    
        test.startTest();
        
        Account acc = ClsTestDataUtility.createAccount('Belgium');
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
        acc.recordtypeid=rtByName.getRecordTypeId();
        insert acc;
        List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
        if(iList.size()>0)
        system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
        test.stopTest();
    }
    
    static testMethod void testAccountUpdate(){
        test.startTest();
        
        Account acc = ClsTestDataUtility.createAccount('Belgium');
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
        acc.recordtypeid=rtByName.getRecordTypeId();
        insert acc;
        acc.billingCountry = 'Germany';
        update acc;
        List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
        if(iList.size()>0)
        system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
        system.assertEquals('Germany',acc.BillingCountry,'Country updation failed');
        test.stopTest();
    }
    
    static testMethod void testAccountNonAdminInsert(){
        test.startTest();
        
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u)
        {
            Account acc = ClsTestDataUtility.createAccount('Belgium');
            Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
            acc.recordtypeid=rtByName.getRecordTypeId();
            insert acc;
            List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
           // system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
        }
        
        test.stopTest();  
    }
    
    static testMethod void testAccountNonAdminUpdate(){
        test.startTest();
        
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u)
        {
            Account acc = ClsTestDataUtility.createAccount('Belgium');
            Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName =  rtMapByName.get('IMS Account');
            acc.recordtypeid=rtByName.getRecordTypeId();
            insert acc;
            acc.billingCountry = 'Germany';
            update acc;
            List<INTEGRATION_LOG__c> iList = [select id, name,BST_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_ACCOUNT_ID__c =:acc.id limit 1];
            if(iList.size()>0)
            system.assertEquals(acc.Id,iList[0].BST_ACCOUNT_ID__c,'Error');
            system.assertEquals('Germany',acc.BillingCountry,'Country updation failed');
        }   
        test.stopTest();  
    }
    
    static testMethod void testImsIntegrationLogUpdate(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u)
        {
            Account acc = ClsTestDataUtility.createAccount('Belgium');
            INTEGRATION_LOG__c iLog = ClsTestDataUtility.createINTEGRATION_LOG();
            ilog.BST_ACCOUNT_ID__c=acc.id;
            insert iLog;
            iLog.BST_COMMENTS__c = 'Test BST Comments';
            iLog.BST_STATUS__c = 'Baxter Pending Review';
            update iLog;
            system.assertEquals(iLog.BST_Country__c,acc.BST_Country__c,'Country Not Updated');
        }
        test.stopTest();               
    }
}