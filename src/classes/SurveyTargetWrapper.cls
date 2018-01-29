/********************************************************************************
Apex Class Name - SurveyTargetWrapper
Version - 1.0
Created Date - Oct 09, 2017
Function - 

Modification Log :
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* <DeveloperName          Oct 09, 2017           Original Version
********************************************************************************/
public class SurveyTargetWrapper {
	 public Id account {get; set;}
	 public Id contact {get; set;}
	 public String contactEmail {get; set;}
	 public String surveyType {get; set;}
	 public Id ownerId {get; set;}
	 public String territoryTBM {get; set;}
	 public String territoryRBM {get; set;}
	 public String territoryAVP {get; set;}
	 public Id userTBM {get; set;}
	 public Id userRBM {get; set;}
	 public Id userAVP {get; set;}
	 public String salesGroup {get; set;}
	 public Id recordType {get; set;}
	 public Id territoryIdTBM {get; set;}
	 public Id territoryIdRBM {get; set;}
	 public Id territoryIdAVP {get; set;}
     public String sourceRecordId {get; set;}
     public String eventType {get; set;}
     public String eventOwnerBaxterAlias {get; set;} 
     public Datetime eventCreatedDate {get; set;}
}