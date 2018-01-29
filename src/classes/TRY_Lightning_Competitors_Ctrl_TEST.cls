@isTest

private class TRY_Lightning_Competitors_Ctrl_TEST
{
    @isTest
    static void MainTest()
    {
        List<Account> accs = TRY_Lightning_Competitors_Controller.getCompetitors();
        //System.assertNotEquals(null, accs);
    }
}