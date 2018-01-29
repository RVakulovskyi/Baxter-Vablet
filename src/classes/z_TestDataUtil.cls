@isTest
public class z_TestDataUtil {

    /**
    * Create a list of z_SObjectDescripton__c records for test purposes.
    * @param iNum
    * @result list of z_SObjectDescription__c records
    */
    public static List<z_SObjectDescription__c> createSObjectDescription(Integer iNum) {
        List<z_SObjectDescription__c> lResult = new List<z_SObjectDescription__c>();

        for (Integer i = 0; i < iNum; i++) {
            z_SObjectDescription__c oSObjDesc = new z_SObjectDescription__c();
            Integer prefix = 000 + i;
            oSObjDesc.keyPrefix__c = String.valueOf(prefix);
            oSObjDesc.Name = 'CustomObj' + i + 'Test__c';
            oSObjDesc.label__c = 'CustomObj' + i + 'Test';
            oSObjDesc.labelPlural__c = 'CustomObj' + i + 'Tests';
            oSObjDesc.localName__c = 'CustomObj' + i + 'Test';
            oSObjDesc.isCustom__c = true;

            lResult.add(oSObjDesc);
        }

        insert lResult;
        return lResult;
    }

    /**
    * Create a list of z_ChildRelationship__c records, associated with z_SObjectDescription__c records for test purposes.
    * @param lSObjects list of z_SObjectDescription__c records
    * @param iNum
    * @result list of z_ChildRelationship__c records
    */
    public static List<z_ChildRelationship__c> createChildRelationship(List<z_SObjectDescription__c> lSObjects, Integer iNum) {
        List<z_ChildRelationship__c> lResult = new List<z_ChildRelationship__c>();

        for (z_SObjectDescription__c oSObject : lSObjects) {
            for (Integer i = 0; i < iNum; i++) {
                z_ChildRelationship__c oChildRelationship = new z_ChildRelationship__c();
                oChildRelationship.fieldname__c = 'CustomField' + i;
                oChildRelationship.z_ParentSObjectDescription__c = oSObject.Id;

                lResult.add(oChildRelationship);
            }
        }

        insert lResult;
        return lResult;
    }
}