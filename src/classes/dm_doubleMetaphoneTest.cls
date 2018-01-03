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
private class dm_doubleMetaphoneTest {

    static testMethod void myUnitTest() {
    	dm_doubleMetaphone.doubleMetaphone('champ');
    	dm_doubleMetaphone.doubleMetaphone('çoñga', false);
    	dm_doubleMetaphone.doubleMetaphone('çoñga', true);
    	dm_doubleMetaphone.DoubleMetaphoneResult dmr = new dm_doubleMetaphone.DoubleMetaphoneResult(4);
    	dmr.append('champ', 'champ');
    	dmr.append('champ');
    	dmr.getPrimary();
    	dmr.getAlternate();
    	dmr.isComplete();
    	dm_doubleMetaphone.encode('ç');
    	dm_doubleMetaphone.encode('ñ');
    	dm_doubleMetaphone.encode('achio');
    	dm_doubleMetaphone.encode('champ');
    	dm_doubleMetaphone.encode('ogn');
    	dm_doubleMetaphone.encode('agnoble');
    	dm_doubleMetaphone.encode('damgnoble');
    	dm_doubleMetaphone.encode('chore');
    	dm_doubleMetaphone.encode('morchae');
    	dm_doubleMetaphone.encode('daccor');
    	dm_doubleMetaphone.encode('charac');
    	dm_doubleMetaphone.encode('damclid');
    	dm_doubleMetaphone.encode('charis');
    	dm_doubleMetaphone.encode('vanChris');
    	dm_doubleMetaphone.encode('machia');
    	dm_doubleMetaphone.encode(' Wright ');
    	dm_doubleMetaphone.encode('  ');
    	system.assert(dm_doubleMetaphone.encode(null) == null, 'null error');
        dm_doubleMetaphone.encode('babçd');
        dm_doubleMetaphone.encode('befgh');
        dm_doubleMetaphone.encode('bijkl');
        dm_doubleMetaphone.encode('bmnop');
        dm_doubleMetaphone.encode('bqrst'); 
        dm_doubleMetaphone.encode('buvwx');
        dm_doubleMetaphone.encode('byñch');
        dm_doubleMetaphone.encode('bfzch');
        dm_doubleMetaphone.encode('bgclh');
        dm_doubleMetaphone.encode('bltcrh');
        dm_doubleMetaphone.encode('bsbah');
        dm_doubleMetaphone dm = new dm_doubleMetaphone();
        dm_doubleMetaphone.doubleMetaphone('value', true);
        
        dm_doubleMetaphone.encode('accghsc');
        dm_doubleMetaphone.encode('bghgngeygligyger');
        dm_doubleMetaphone.encode('asadf');
        dm_doubleMetaphone.encode('bdask');
        dm_doubleMetaphone.encode('cdafl');
        dm_doubleMetaphone.encode('bczcscr');
        dm_doubleMetaphone.encode('t');
        dm_doubleMetaphone.encode('qqu');
        //begin solid tests
        system.assert(dm_doubleMetaphone.encode('brosef') == 'PRS', 'Error, Brosef should = PRS');
        system.assert(dm_doubleMetaphone.encode('aegis') == 'AJS', 'Error, aegis should = AJS');
        system.assert(dm_doubleMetaphone.encode('caesar') == 'SSR', 'Error, caesar should = SSR');
        system.assert(dm_doubleMetaphone.encode('focaccia') == 'KX', 'Error, focaccia should = KX');
        system.assert(dm_doubleMetaphone.encode('czerny') == 'SRN', 'Error, czerny should = SRN');
        system.assert(dm_doubleMetaphone.encode('cclmnop') == 'KLMN', 'Error, cclmnop should = KLMN');
        system.assert(dm_doubleMetaphone.encode('ckcioci') == 'KSS', 'Error, ckcioci should = KSS');
        system.assert(dm_doubleMetaphone.encode('macgregor') == 'MKRK', 'Error, macgregor should = MKRK');
        system.assert(dm_doubleMetaphone.encode('bellochio') == 'PLX', 'Error, bellochio should = PLX');
        system.assert(dm_doubleMetaphone.encode('bacchus') == 'PKS', 'Error, bacchus should = PKS');
  		dm_doubleMetaphone.encode('accident');
  		dm_doubleMetaphone.encode('bacci');
  		dm_doubleMetaphone.encode('chaef');
  		dm_doubleMetaphone.encode('mccheeseburger');
  		dm_doubleMetaphone.encode('edge');
  		dm_doubleMetaphone.encode('edgar');
  		dm_doubleMetaphone.encode('dedtjimdd');
  		dm_doubleMetaphone.encode('high');
  		dm_doubleMetaphone.encode('caign');
  		dm_doubleMetaphone.encode('ghey');
  		dm_doubleMetaphone.encode('gepmain');
  		dm_doublemetaphone.encode('folger');
  		dm_doubleMetaphone.encode('biaggi');
  		dm_doubleMetaphone.encode('vangerman');
  		dm_doubleMetaphone.encode('laugh');
  		dm_doubleMetaphone.encode('jose');
  		dm_doubleMEtaphone.encode('san jacinto');
  		dm_doubleMEtaphone.encode('pher');
  		dm_doublemetaphone.encode('island');
  		dm_doubleMetaphone.encode('sugar');
  		dm_doubleMEtaphone.encode('hoenheim');
  		dm_doublemetaphone.encode('iglasio');
  		
  		
  		
    }
}