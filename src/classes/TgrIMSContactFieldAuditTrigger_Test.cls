//Akshay 11/23/2016
//Description - This class will be used for test coverage of TgrIMSContactFieldAuditTrigger trigger on contact

@isTest
public class TgrIMSContactFieldAuditTrigger_Test{
    
    static testMethod void testContactInsert(){
        test.startTest();
        Contact con = ClsTestDataUtility.createContact();
        insert con;
        test.StopTest();
    }  
 
    static testMethod void testContactUpdate(){
        test.startTest();
        Contact con = ClsTestDataUtility.createContact();
        insert con;
        con.firstName = 'Test Test First';
        update con;
        test.stopTest();
    }
    
    static testMethod void testContactNonAdminInsert(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u){
            Contact con = ClsTestDataUtility.createContact(); 
            insert con;
            //List<INTEGRATION_LOG__c> iList = [select id, name,BST_CONTACT_ID__c from INTEGRATION_LOG__c WHERE BST_CONTACT_ID__c =:con.id ];
            //system.assertEquals(con.Id,iList[0].BST_CONTACT_ID__c,'Error');
            test.stopTest();
       }
   }
   
   static testMethod void testContactNonAdminUpdate(){
        test.startTest();
        user u = ClsTestDataUtility.createUser('Belgium','Belgium');
        System.runAs(u){
            Contact con = ClsTestDataUtility.createContact(); 
            insert con;
            con.firstName = 'Test Test First';
            update con;
            system.AssertEquals('Test Test First',con.FirstName,'Error');
            test.stopTest();
       }
   }   
}