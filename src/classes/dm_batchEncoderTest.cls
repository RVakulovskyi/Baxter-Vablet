/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class dm_batchEncoderTest {

    static testMethod void myUnitTest() {
      
       Test.StartTest();
       dm_batchEncoder be1 = new dm_batchEncoder('contact', 'firstname', 'firstMeta__c', 'lastname', 'lastMeta__c');
       dm_batchEncoder be2 = new dm_batchEncoder('account', 'name', 'nameMeta__c');
       dm_batchEncoder be3 = new dm_batchEncoder('lead', 'firstname', 'firstMeta__c', 'lastname', 'lastMeta__c', 'company', 'companyMeta__c');
       
       ID be1Id  = database.executeBatch(be1);
       system.assert(be1ID != null, 'error executing contact batch');
       ID be2ID = database.executeBatch(be2);
       system.assert(be2ID != null, 'error executing account batch');
       id be3ID = database.executeBatch(be3);
       system.assert(be3id != null, 'error executing lead batch');
       
       Test.StopTest();
       
    }
}