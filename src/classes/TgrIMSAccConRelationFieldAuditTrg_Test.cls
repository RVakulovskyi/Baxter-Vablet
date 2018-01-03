//Akshay 11/23/2016
//Description - This class will be used for test coverage of TgrIMSAccConRelationFieldAuditTrigger trigger.

@isTest
public class TgrIMSAccConRelationFieldAuditTrg_Test{

    static testMethod void testAccConRelationInsert(){
        test.startTest();    
        AccountContactRelation acr = ClsTestDataUtility.createAccountContactRelation();
        //insert acr;
        acr.BST_COUNTRY__c = 'Belgium';
        update acr;
          try
            {
                delete acr;
            }
            catch(Exception e)
            {
                system.assertNotEquals('Account Contact Relationship Deleted', e.getMessage());
            }
        test.stopTest();
    }
    
   /* static testMethod void testAccConRelationUpdate(){
        test.startTest();
        AccountContactRelation acr = ClsTestDataUtility.createAccountContactRelation();
        insert acr;
        acr.BST_COUNTRY__c = 'Belgium';
        update acr;
        test.stopTest();
    } */

    static testMethod void testAccConRelationNonAdminInsert(){
        test.startTest();   
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u){ 
            AccountContactRelation acr = ClsTestDataUtility.createAccountContactRelation();
            //insert acr;
            system.assert(acr.Id!=Null);
            acr.BST_COUNTRY__c = 'Belgium';
            update acr;
        }
        test.stopTest();
    } 
    
    /*static testMethod void testAccConRelationNonAdminUpdate(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u){
            AccountContactRelation acr = ClsTestDataUtility.createAccountContactRelation();
            insert acr;
            acr.BST_COUNTRY__c = 'Belgium';
            update acr;
        }
        test.stopTest();
    }*/
    
    /*static testMethod void testPreventAccConRelDeletion()
    {
		test.startTest();
            Account acc = ClsTestDataUtility.createAccount('Belgium');
            Contact con = ClsTestDataUtility.createContact();
            AccountContactRelation acr = ClsTestDataUtility.createAccountContactRelation();
            insert acr;
            
            try
            {
                delete acr;
            }
            catch(Exception e)
            {
                system.assertNotEquals('Account Contact Relationship Deleted', e.getMessage());
            }
        test.stopTest();        
    }*/
}