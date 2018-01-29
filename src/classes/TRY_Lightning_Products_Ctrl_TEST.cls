@isTest

private class TRY_Lightning_Products_Ctrl_TEST
{
    @isTest
    static void MainTest()
    {
        String accid;
        List<BXGO_Competitor_Product__c> products = TRY_Lightning_Products_Controller.getProducts(accid);
        //System.assertNotEquals(null, products);
        
    }
}