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
********************************************************************************/
public without sharing class VabletTriggerHandler {
    static final String SETTINGSNAME = 'VabletTriggerHandler';
	static final String COMMASEPARATOR = ',';
	static final String DOTSEPARATOR = '.';
	static final String SIGNCONSTANT = '">';

    public static void handleafterInsert(List<Task> tasks){
		VabletFieldSettings__c vabletSettings = VabletFieldSettings__c.getInstance(SETTINGSNAME);
		try{
			List<Media_View__c> mediaList = new List<Media_View__c>();
			for (Task t: tasks){
				String taskfileid = t.File_ID__c;
				String taskDesc = t.Description;
				List<String> Fileids = new List<String>();
				if(taskfileid.contains(COMMASEPARATOR)){
					Fileids = taskfileid.split(COMMASEPARATOR);
				}else{
					Fileids.add(taskfileid);
				}
				List<String> filenmlist= new List<String>();
				List<String> filextnlst= new List<String>();
				if(taskDesc.contains(vabletSettings.FileNameAttached__c)){
					String Filename=null;
					String FileExtension=null;
					List<String> attachmentList = taskDesc.split(vabletSettings.FileNameAttachedSl__c);
					System.debug(' attachmentList :'+attachmentList );
					attachmentList.remove(0);
					for(String str: attachmentList){
						String TotalFilename = str.substringBefore(vabletSettings.SubstringValueBefore1__c);
						System.debug('TotalFilename is '+TotalFilename );
						if(TotalFilename.contains(DOTSEPARATOR)){
							Filename = TotalFilename.substringBeforeLast(DOTSEPARATOR);
							FileExtension = TotalFilename.substringAfterLast(DOTSEPARATOR);
						}
						if (!String.isBlank(Filename)){
							filenmlist.add(Filename);
							filextnlst.add(FileExtension);
                        }
					}
				}else if(taskDesc.contains(vabletSettings.FileName__c)){
					String Filename=null;
					String FileExtension=null;
					List<String> attachmentList = taskDesc.split(vabletSettings.FileName__c);
					System.debug(' attachmentList :'+attachmentList );
					attachmentList.remove(0);                
					Map<String,String> mediaMapExt= new Map<String,String>();
					for(Media_View__c m:[SELECT File_Extension__c,File_Name__c FROM Media_View__c WHERE File_ID__c IN: Fileids and File_Extension__c != null] ){
						mediaMapExt.put(m.File_Name__c,m.File_Extension__c);
					}
					for(String str: attachmentList){                    
						String TotalFilename = str.substringBefore(vabletSettings.SubstringValueBefore2__c);
						Filename =TotalFilename.substringAfter(SIGNCONSTANT);                 
						if(mediaMapExt.containsKey(Filename)) {                 
							FileExtension = mediaMapExt.get(Filename);
						}else{
							FileExtension = vabletSettings.FileExtension__c;
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
			System.debug(vabletSettings.ExceptionText__c + e.getMessage());
		}          
	}
}