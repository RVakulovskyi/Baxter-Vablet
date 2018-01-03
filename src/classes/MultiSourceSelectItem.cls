public with sharing class MultiSourceSelectItem {
    public String sourceName;
    public VabletFieldMapItem mapItemForSource;
    
    public MultiSourceSelectItem (String inSourceName,VabletFieldMapItem inMapItemForSource)
    {
        sourceName=inSourceName;
        mapItemForSource=inMapItemForSource;
    }
}