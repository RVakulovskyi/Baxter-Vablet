public class VabletPicklistMapItem{
    public String displayName;
    public String databaseValue;
    public List<VabletPicklistMapItem> dependentItems;
    
    public VabletPicklistMapItem (String inDisplayName,String inDatabaseValue)
    {
        displayName=inDisplayName;
        databaseValue=inDatabaseValue;
    }
    
        public VabletPicklistMapItem (String inDisplayName,String inDatabaseValue, List<VabletPicklistMapItem> inDependentItems)
    {
        displayName=inDisplayName;
        databaseValue=inDatabaseValue;
        dependentItems=inDependentItems;
    }
}