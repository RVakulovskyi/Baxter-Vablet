/********************************************************************************
Apex Class Name - VabletTriggerHandler 
Version - 1.0
Created Date - Jun 6, 2015
Function - Create Media view reocrds.

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     06/11/2015           Original Version
* Rodion Vakulovskyi	  02/01/2018		   modifying class with custom settings
* Rodion Vakulovskyi	  05/01/2018		   modifying class
* Rodion Vakulovskyi	  12/01/2018		   modifying class
* Rodion Vakulovskyi	  19/01/2018		   modifying class
********************************************************************************/
Public without sharing class VabletTriggerHandler {
    static final String SETTINGSNAME = 'VabletTriggerHandler';
      
    public static void handleafterInsert(List<Task> tasks){
		VabletFieldSetting__mdt vabletSettings = queryCustomMetadataType(SETTINGSNAME);
		try{
			List<Media_View__c> mediaList = new List<Media_View__c>();
			for (Task t: tasks){
				String taskfileid = t.File_ID__c;
				String taskDesc = t.Description;
				List<String> Fileids = new List<String>();
				if(taskfileid.contains(vabletSettings.Separator1__c)){
					Fileids = taskfileid.split(vabletSettings.Separator1__c);
				}else{
					Fileids.add(taskfileid);
				}
				List<String> filenmlist= new List<String>();
				List<String> filextnlst= new List<String>();
				
				if(taskDesc.contains(vabletSettings.TextFormat1__c)){
					String Filename=null;
					String FileExtension=null;
					List<String> attachmentList = taskDesc.split(vabletSettings.TextFormat2__c);
					System.debug(' attachmentList :'+attachmentList );
					attachmentList.remove(0);
					for(String str: attachmentList){
						String TotalFilename = str.substringBefore(vabletSettings.TextFormat3__c);
						System.debug('TotalFilename is '+TotalFilename );
						if(TotalFilename.contains(vabletSettings.Separator2__c)){
							Filename = TotalFilename.substringBeforeLast(vabletSettings.Separator2__c);
							FileExtension = TotalFilename.substringAfterLast(vabletSettings.Separator2__c);
						}
						if (!String.isBlank(Filename)){
							filenmlist.add(Filename);
							filextnlst.add(FileExtension);
                        }
					}
				}else if(taskDesc.contains(vabletSettings.TextFormat5__c)){
					String Filename=null;
					String FileExtension=null;
					List<String> attachmentList = taskDesc.split(vabletSettings.TextFormat5__c);
					System.debug(' attachmentList :'+attachmentList );
					attachmentList.remove(0);                
					Map<String,String> mediaMapExt= new Map<String,String>();
					for(Media_View__c m:[SELECT File_Extension__c,File_Name__c FROM Media_View__c WHERE File_ID__c IN: Fileids and File_Extension__c != null] ){
						mediaMapExt.put(m.File_Name__c,m.File_Extension__c);
					}
					for(String str: attachmentList){                    
						String TotalFilename = str.substringBefore(vabletSettings.TextFormat4__c);
						Filename =TotalFilename.substringAfter(vabletSettings.TextConstant2__c);                 
						if(mediaMapExt.containsKey(Filename)) {                 
							FileExtension = mediaMapExt.get(Filename);
						}else{
							FileExtension = vabletSettings.TextConstant1__c;
						}
						if (Filename != null && Filename != ''){
							filenmlist.add(Filename);
							filextnlst.add(FileExtension);
						}                    
					}
				}//if taskDesc.contains  added
				Integer fileNameListSize = filenmlist.size(); 
				Integer fileIdListSize = Fileids.size(); 
				if(fileNameListSize == fileIdListSize ){
					for(Integer i=0; i < fileNameListSize ;i++){
						Media_View__c m = new Media_View__c();
						m.File_ID__c = Fileids[i];
						m.File_Name__c = filenmlist[i];
						m.File_Extension__c = filextnlst[i];
						m.Event_Id__c = t.Id;
						m.Contact__c = t.whoID;
						mediaList.add(m);
					}
				}
		}//for loop
		if(mediaList != null){   
			insert mediaList;
			system.debug('mediaList here >>>>:'+mediaList);
		}
	} catch(Exception e) {
		System.debug(vabletSettings.ExceptionText__c + e.getMessage());}          
    }

	private static VabletFieldSetting__mdt queryCustomMetadataType(String nameOFObject) {
		String queryString = 'SELECT ';
		SObjectType customMetaType = Schema.getGlobalDescribe().get('VabletFieldSetting__mdt');
		Map<String,Schema.SObjectField> mfields = customMetaType.getDescribe().fields.getMap();
		for(String itemString : mfields.keySet()) {
			queryString+= itemString + ',';
		}
		queryString = queryString.substring(0, queryString.length() - 1) + ' FROM VabletFieldSetting__mdt WHERE QualifiedApiName = :nameOFObject';
		return Database.query(queryString);
	}
}