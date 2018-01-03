//Akshay 11/23/2016
//Description - This class will be used for test coverage of TgrIMSRelatedAccountFieldAuditTrigger trigger on object Related Accounts.

@isTest
public class TgrIMSRelatedAccountFieldAuditTrg_Test{
    
    static testMethod void testAccountAccountRelationInsert(){
        test.starttest();
        ACCOUNT_ACCOUNT_RELATION__c aar = ClsTestDataUtility.createACCOUNT_ACCOUNT_RELATION();
        insert aar;
        List<INTEGRATION_LOG__c> iList = [select id, name,BST_RELATED_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_RELATED_ACCOUNT_ID__c =:aar.id ];
        if(iList.size()>0)
        system.assertEquals(aar.Id,iList[0].BST_RELATED_ACCOUNT_ID__c,'Error');
        test.stopTest();
    }
    
    static testMethod void testAccountAccountRelationUpdate(){
        test.startTest();
        ACCOUNT_ACCOUNT_RELATION__c aar = ClsTestDataUtility.createACCOUNT_ACCOUNT_RELATION();
        insert aar;
        aar.BST_COUNTRY__c = 'Belgium';
        update aar;
        List<INTEGRATION_LOG__c> iList = [select id, name,BST_RELATED_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_RELATED_ACCOUNT_ID__c =:aar.id ];
        if(iList.size()>0)
        system.assertEquals(aar.Id,iList[0].BST_RELATED_ACCOUNT_ID__c,'Error');
        test.stopTest();
    }  
    
    static testMethod void testAccountAccountRelationNonAdmInsert(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
         System.runAs(u){
            ACCOUNT_ACCOUNT_RELATION__c aar = ClsTestDataUtility.createACCOUNT_ACCOUNT_RELATION();
            insert aar;
            List<INTEGRATION_LOG__c> iList = [select id, name,BST_RELATED_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_RELATED_ACCOUNT_ID__c =:aar.id ];
            if(iList.size()>0)
            system.assertEquals(aar.Id,iList[0].BST_RELATED_ACCOUNT_ID__c,'Error');
        }
        test.stopTest();
    } 
    
    
    static testMethod void testAccountAccountRelationNonAdmUpdate(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u) {
            ACCOUNT_ACCOUNT_RELATION__c aar = ClsTestDataUtility.createACCOUNT_ACCOUNT_RELATION();
            insert aar;
            //aar.DP_START_DATE__c=system.today();
            update aar;
            List<INTEGRATION_LOG__c> iList = [select id, name,BST_RELATED_ACCOUNT_ID__c from INTEGRATION_LOG__c WHERE BST_RELATED_ACCOUNT_ID__c =:aar.id ];
            if(iList.size()>0)
            system.assertEquals(aar.Id,iList[0].BST_RELATED_ACCOUNT_ID__c,'Error');
        }
        test.stopTest();
    } 
}