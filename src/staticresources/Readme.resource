Phonetic Search-

a) Introduction
	Hello, if you're reading this, you've installed the phonetic search add-on for salesforce.com. This tool was designed to improve the searching capabilities of the force.com platform to bring you top quality phonetic based searching that is both easy to use and easy to expand upon. 
	This documentation is split up into three main areas. First we'll cover the installation and setup, to ensure minimal problems getting up and running. Next, we'll cover what exactly is prebuilt in this package, so you can better understand the impact upon API calls, etc, as well as know what's running under the hood. Finally, we'll review the utility classes provided for developers to expand upon the usage of phonetic encoding/search in their own salesforce.com organization, allowing for mapping to custom fields and custom objects.
	This application was built using Apex and Visualforce, and as such, is not available to anyone running salesforce.com editions other than Developer, Enterprise, or Unlimited.
	
b) Installation + Setup
	Current version downloads of this package can be found in only one official place, and that's the salesforce.com appExchange. Any packages found anywhere else on the wide world are not necessarily correct, nor tested, etc. 
	Begin by installing via the standard appExchange install link found on the app's page. You'll note the package contains the following:
	
	Apex Classes:
		dm_doubleMetaphone
		dm_pSearchController
		dm_encodeBig3
		dm_batchEncoder(Batch Class)
		dm_batchEncoderTest(Test Class)
		dm_encodeTriggersTest(Test Class)
		dm_pSearchTest(Test Class)
		dm_doubleMetaphoneTest(Test Class)
		dm_encodeBig3Test(Test Class)
		
	Apex Triggers:
		dm_encodeAccountName
		dm_encodeLeadNameCompany
		dm_encodeContactName
		
	Fields:
		Lead Table-
			lastMeta
			companyMeta
			firstMeta
		Account Table-
			nameMeta
		Contact Table-
			firstMeta
			lastMeta
			accountMeta
	
	VF Pages:
		dm_encodeBig3
		dm_pSearchPage
	
	Resources:
		Phonetic Search - Homepage Component
		
	Once installation has completed, you will need to run the batch encoding process to ensure all of your current lead, contact, and account records now have accurate phonetic codes for searching. To do this, simply point your browser to '/apex/encodeBig3' This will fire a set of three concurrent batch processes in order to encode everything for you. At any point if you feel a need to refresh all records, this is your tool to do so. There are triggers built into the package that should keep all records up to date automatically for you, however.
	
	Now that you've successfully encoded all of your records, we need to add the search sidebar component to your homepage layout. Click Setup, then Customize, and under 'Home', select 'Home Page Layouts'. Pick the layout you wish to add the search to, and add the sidebar component 'Phonetic Search'. You now will have a search on your sidebar. 
	Additionally, if you notice this does not come across any custom Visualforce pages in your salesforce organization, you need to go into Setup->Customize->User Interface, and make sure the checkbox for 'Show Custom Sidebar Components on All Pages' is selected.


	
c) Details on standard use
	
	The prebuilt use cases for phonetic search in this package are as follows:
		Account: Name only (nameMeta__c).
		Lead: First, Last and Company names(firstMeta__c, lastMeta__c, and companyMeta__c respectively).
		Contact: First, Last, and associated Account names(firstmeta__c, lastMeta__c, and accountMeta__c respectively).
		
	All classes save for the extended utility classes touched on in the final chapter relate only to these fields only on these objects. 
	
	The batch callouts from encodeBig3 will encode all of these fields using batch processes. The triggers included will beforeUpdate and beforeInsert encode the appropriate fields for triggering records.
	No existing data is edited or affected by any code in this package. All updates and changes are within the packaged fields for those objects.
	
d) Details on expansive use
	Search Page Functionality:
		To create your own mashups with the search results page, the html parameter passed to provide the search bar's criteria is called 'criteria'. If provided, it will initiate a search upon pageload.

	Utility Classes:
	In addition to the standard object functionality included out of box, this package also includes a few utility classes for more advanced development support.
	
		public static string dm_doubleMetaphone.encode(string toEncode)
			This class will return the phonetic code that results from the string provided.
		
		Batch Class- dm_batchEncoder
			This class processes 1 object/table at a time, and up to three separate fields in that object. Proper construction is:
				dm_batchEncoder(string objectTable, string sourceField1, string targetField1, [string sourceField2], [string targetField2], [string sourceField3], [string targetField3])
				
		