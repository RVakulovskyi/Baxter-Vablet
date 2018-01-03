public class VabletFieldMapItem{
    public String databaseColumnName;
    public String displayName;
    public String prefilledDefaultValue;
    public String fieldType;//datetime,string,picklist,contact
    public Object selectableValuesIfApplicable;
    
    public VabletFieldMapItem(String inDatabaseColumnName,String inDisplayName,String inFieldType, Object inSelectableValuesIfApplicable, String inPrefilledDefaultValue)
    {
        databaseColumnName = inDatabaseColumnName;
        displayName = inDisplayName;
        fieldType= inFieldType;
        prefilledDefaultValue= inPrefilledDefaultValue;
        selectableValuesIfApplicable = inSelectableValuesIfApplicable;       
    }
}