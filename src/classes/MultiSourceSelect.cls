public with sharing class MultiSourceSelect {
        public String name;
        private List <MultiSourceSelectItem> sources = new List <MultiSourceSelectItem>();
        
        public MultiSourceSelect(String inName)
        {
            name=inName;
        }
        
        public void addSource(MultiSourceSelectItem newSource)
        {
            sources.add(newSource);
        }
        
        public VabletFieldMapItem getVabletFieldMapItem()
        {
            return new VabletFieldMapItem('multiSourceSelect', name, 'multiSourceSelect',sources, '');
        }
}