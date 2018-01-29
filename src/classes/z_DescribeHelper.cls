public with sharing class z_DescribeHelper {

    public static Map<String, Schema.SObjectType> mapGlobalDescribe = new Map<String, Schema.SObjectType>();

    /**
    * Cache schema global describe if possible.
    */
    public static Schema.DescribeSObjectResult getObjectDescribe(String objName) {
        if (mapGlobalDescribe.isEmpty()) {
            // Get the Global Describe which contains details for all objects
            mapGlobalDescribe = Schema.getGlobalDescribe();
        }
        return Schema.getGlobalDescribe().get(objName).getDescribe();
    }

    /**
    * Method that creates a z_SObjectDescription__c record out of Schema.DescribeSObjectResult.
    *
    * @param objDescribe
    * @return z_SObjectDescription__c record.
    */
    public static z_SObjectDescription__c createSObjectDescription(Schema.DescribeSObjectResult objDescribe) {
        z_SObjectDescription__c sobj = new z_SObjectDescription__c();

        sobj.keyPrefix__c = objDescribe.getKeyPrefix();
        sobj.label__c = objDescribe.getLabel();
        sobj.labelPlural__c = objDescribe.getLabelPlural();
        sobj.localName__c = objDescribe.getLocalName();
        sobj.name = objDescribe.getName();
        sobj.isAccessible__c = objDescribe.isAccessible();
        sobj.isCreateable__c = objDescribe.isCreateable();
        sobj.isCustom__c = objDescribe.isCustom();
        sobj.isCustomSetting__c = objDescribe.isCustomSetting();
        sobj.isDeltable__c = objDescribe.isDeletable();
        sobj.isDeprecatedAndHidden__c = objDescribe.isDeprecatedAndHidden();
        sobj.isFeedEnabled__c = objDescribe.isFeedEnabled();
        sobj.isMergeable__c = objDescribe.isMergeable();
        sobj.isQueryable__c = objDescribe.isQueryable();
        sobj.isSearchable__c = objDescribe.isSearchable();
        sobj.isUndeletable__c = objDescribe.isUndeletable();
        sobj.isUpdateable__c = objDescribe.isUpdateable();

        return sobj;
    }

    /**
    * Method that creates z_ChildRelationship__c records of the child relationships for the object being processed.
    * @param objDescribe
    * @return a list of z_ChildRelationship__c records
    */
    public static List<z_ChildRelationship__c> createChildRelationship(Schema.DescribeSObjectResult objDescribe) {
        List<z_ChildRelationship__c> lChildRelations = new List<z_ChildRelationship__c>();

        for(Schema.ChildRelationship childRelation : objDescribe.getChildRelationships()) {
            z_ChildRelationship__c record = new z_ChildRelationship__c();
            record.isCascadeDelete__c = childRelation.isCascadeDelete();
            record.fieldname__c = childRelation.getField().getDescribe().getName();
            record.childobjectname__c = childRelation.getChildSObject().getDescribe().getName();

            lChildRelations.add(record);
        }

        return lChildRelations;
    }

    /**
    * Method that creates a list of z_FieldDescription__c per object name.
    * @param objId
    * @param objName
    * @return a list of z_FieldDescription__c records.
    */
    public static List<z_FieldDescription__c> createFieldDescriptionRecords(Id objId, String objName) {
        Map<String, Schema.SObjectField> mapFields = getObjectDescribe(objName).fields.getMap();
        List<z_FieldDescription__c> lFieldDescription = new List<z_FieldDescription__c>();

        for (Schema.SObjectField ofield : mapFields.values()) {
            Schema.DescribeFieldResult field = ofield.getDescribe();

            z_FieldDescription__c fd = new z_FieldDescription__c();
            fd.z_SObjectDescription__c = objid;
            fd.type__c = field.getType().name();
            fd.soaptype__c = field.getSoapType().name();
            fd.byteLength__c = field.getByteLength();
            fd.calculatedFormula__c = field.getCalculatedFormula();
            fd.defaultValueFormula__c = field.getDefaultValueFormula();
            fd.digits__c = field.getDigits();
            fd.inlineHelpText__c = field.getInlineHelpText();
            fd.label__c = field.getLabel();
            fd.length__c = field.getLength();
            fd.localName__c = field.getLocalName();
            fd.name = field.getName();
            fd.precision__c = field.getPrecision();
            fd.relationshipName__c = field.getRelationshipName();
            fd.relationshipOrder__c = field.getRelationshipOrder();
            fd.scale__c = field.getScale();
            fd.isAccessible__c = field.isAccessible();
            fd.isAutoNumer__c = field.isAutoNumber();
            fd.isCalculated__c = field.isCalculated();
            fd.isCaseSensitive__c = field.isCaseSensitive();
            fd.isCreateable__c = field.isCreateable();
            fd.isCustom__c = field.isCustom();
            fd.isDefaultedOnCreate__c = field.isDefaultedOnCreate();
            fd.isDependentPicklist__c = field.isDependentPicklist();
            fd.isDeprecatedAndHidden__c = field.isDeprecatedAndHidden();
            fd.isExternalID__c = field.isExternalId();
            fd.isFilterable__c = field.isFilterable();
            fd.isGroupable__c = field.isGroupable();
            fd.isHtmlFormatted__c = field.isHtmlFormatted();
            fd.isIdLookup__c = field.isIdLookup();
            fd.isNameField__c = field.isNameField();
            fd.isNamePointing__c = field.isNamePointing();
            fd.isNillable__c = field.isNillable();
            fd.isRestrictedPicklist__c = field.isRestrictedPicklist();
            fd.isSortable__c = field.isSortable();
            fd.isUnique__c = field.isUnique();
            fd.isUpdateable__c = field.isUpdateable();
            fd.isWriteRequiredMasterRead__c = field.isWriteRequiresMasterRead();
            fd.picklistentries__c = getPicklistEntry(field);

            lFieldDescription.add(fd);
        }

        return lFieldDescription;
    }

    /**
    * Method that describes picklist fields and returns a string with all possible values.
    * @param field
    * @return string value that contains all picklist options.
    */
    private static String getPicklistEntry(Schema.DescribeFieldResult field) {
        String picklistentries = '';
        Integer i = 0;
        for(Schema.PicklistEntry entry : field.getPicklistValues()) {
            if(i++ != 0) {
                picklistentries += '\n';
            }

            String label = entry.getLabel();
            String value = entry.getValue();
            Boolean isActive = entry.isActive();
            Boolean isDefaultValue = entry.isDefaultValue();
            String line = '' + label + ' : ' + value;
            picklistentries += line;
        }

        return picklistentries;
    }

}