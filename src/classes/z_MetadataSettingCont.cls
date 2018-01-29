public with sharing class z_MetadataSettingCont {

    private PageReference rPage;

    ApexPages.StandardSetController setCon;

    public z_MetadataSettingCont(ApexPages.StandardSetController controller) {
        setCon = controller;
        try {
            rPage = new PageReference(ApexPages.currentPage().getParameters().get('retUrl'));
            if(rPage.getUrl() == '')
                rPage = null;
        } catch (Exception e) {
            rPage = null;
        }
    }

    public PageReference deleteAll() {
        z_Util.deleteAllSettings();
        return rPage;
    }

}