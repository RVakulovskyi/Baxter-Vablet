/********************************************************************************
Apex Class Name - TerritoryHierarchyHelper
Version - n.n
Created Date - Jul 19, 2017
Function - 

Modification Log :
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* <DeveloperName           Jul 19, 2017           Original Version
* L Anil Kumar Reddy (AKR) Nov 11, 2018          Added method "getUserTerritoryGroupid".
********************************************************************************/

global class TerritoryHierarchyHelper {
    
    /*
    * Static variable to hold the Territory representation
    */     
    public static Map<String,Territory> TerritoryList{
        get{ 
            if(TerritoryList == null) {
                TerritoryList = new Map<String,Territory>();
                for(Territory  terr : [SELECT ID, Name, Description, ParentTerritoryID FROM Territory ]){
                    TerritoryList.put(terr.ID, terr);
                }
                system.debug('TerritoryList::'+TerritoryList);            
                return TerritoryList;
            }else{
                return TerritoryList;
            }
        }
        private set{}
    }   

     /*
     * Static variable to hold the UserTerritory representation
     */
    static Map<String,UserTerritory> TerritoryToUser = NULL;
    static Map<Id, Set<Id>> UserTerritoryMap;

    public static Map<String,UserTerritory> TerritoryToUserList{
        get{
            system.debug('fillUserTerritory::::' + TerritoryToUser);
            if(TerritoryToUser == NULL){
                fillUserTerritory();                            
            }
            return TerritoryToUser;
        }
        private set;
    }
       
    private static void fillUserTerritory(){   
        TerritoryToUser = new Map<String,UserTerritory>();
        UserTerritoryMap =  new Map<Id, Set<Id>>();
        
        /*
         * Assumes one terrtiroy to one user and one user to one terrtitory active assignment. 
         * If there is 1 to many exist, it takes random 1st of many in either case. 
        */
        for(UserTerritory  ut : [SELECT Id , TerritoryId , UserId FROM UserTerritory 
                                    WHERE IsActive=true 
                                    AND userid in (SELECT id FROM User 
                                                    WHERE isactive = TRUE 
                                                    AND (user.profile.name LIKE 'Baxter Area%' 
                                                        OR user.profile.name LIKE 'Baxter Regional%' 
                                                        OR user.profile.name like 'Baxter Territory%'))]){
            
            if(!TerritoryToUser.containsKey(ut.TerritoryId)) 
                TerritoryToUser.put(ut.TerritoryId, ut);
                
            if(!UserTerritoryMap.containsKey(ut.UserId)) 
                UserTerritoryMap.put(ut.UserId,new Set<Id>{ut.TerritoryId});
            else
                UserTerritoryMap.get(ut.UserId).add(ut.TerritoryId);                
        }
    }
    
    /*
    * Static variable to hold Profile Name
    */     
    public static Map<String,String> ProfileList{
        get{ 
            if(ProfileList == null) {
                ProfileList = new Map<String,String>();
                for(Global_Setting__mdt  globalSetting : [SELECT developername, value__c 
                                                            FROM Global_Setting__mdt
                                                            WHERE developername in ('AVP_Profile','TBM_Profile','RBM_Profile')]){
                    ProfileList.put(globalSetting.developername, globalSetting.value__c);
                }
            }
            return ProfileList;
        }
        private set{}
    } 
    
    
     /**
     * Method Name: getUserHierarchy
     * Description: Method to get User hierarchy using user id
     * Parameter:  
     * salesgroup (string) : Sales group code. like CR, OS, DS etc
     * accountId (sting) : Account ID. like 001F000001L5aVuIAJ
     * Return Type: Map<String,UserTerritory>
     * will have {TBM => Userterritory, RBM=> UserTerritory, AVP=> UserTerritory}
     */
    public static Map<Id, TerritoryHierarchy> getUserHierarchy(Map<Id,String> objectCreatorMap){
        
        Map<Id, Id> objTerritoryMap =  new Map<Id, Id>();
        Map<Id, TerritoryHierarchy> objHierarchyMap = new Map<Id, TerritoryHierarchy>();
        Map<Id,User> userProfileMap ;
        string profileName;        
        
        System.debug('objectCreatorMap:::::' + objectCreatorMap);
        if(UserTerritoryMap == NULL)
            fillUserTerritory();
            
        if(objectCreatorMap != NULL){           
            for(Id objId: objectCreatorMap.keySet()){
                if(UserTerritoryMap.get(objectCreatorMap.get(objId).split('~')[0]) != NULL)
                    objTerritoryMap.put(objId, getUserGroupTerritory(objectCreatorMap.get(objId)));
            }
        }        
        
        for(Id objId : objTerritoryMap.keySet()){
            TerritoryHierarchy retVal = new TerritoryHierarchy();            
            //setting TBM Id            
            retVal.TBMID = objTerritoryMap.get(objId);            
            //profileName = userProfileNameMap.get(objectCreatorMap.get(objId));
            profileName = objectCreatorMap.get(objId).split('~')[2];
            if(profileName.contains(ProfileList.get('TBM_Profile'))){  
                //setting RBM Id 
                retVal.RBMID = (TerritoryList.get(retVal.TBMID) != NULL?TerritoryList.get(retVal.TBMID).ParentTerritoryID: NULL);                
                //setting AVP Id 
                retVal.AVPID = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).ParentTerritoryID: NULL);                                
            }
            else if(profileName.contains(ProfileList.get('RBM_Profile'))){ 
                //setting RBM Id 
                retVal.RBMID = objTerritoryMap.get(objId);                 
                //setting AVP Id 
                retVal.AVPID = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).ParentTerritoryID:NULL);            
            }
            else if(profileName.contains(ProfileList.get('AVP_Profile'))){
                //setting RBM Id 
                retVal.RBMID = objTerritoryMap.get(objId);                 
                //setting AVP Id 
                retVal.AVPID = objTerritoryMap.get(objId);                
            }            
           
            retVal.TBMcode = (TerritoryList.get(retVal.TBMID) != NULL?TerritoryList.get(retVal.TBMID).Name:NULL);    
            retVal.TBMdesc = (TerritoryList.get(retVal.TBMID) != NULL?TerritoryList.get(retVal.TBMID).Description:NULL);
            retVal.TBMuser = (TerritoryToUserList.get(retVal.TBMID) != NULL?TerritoryToUserList.get(retVal.TBMID).UserId:NULL);
            
            retVal.RBMuser = (TerritoryToUserList.get(retVal.RBMID) != NULL?TerritoryToUserList.get(retVal.RBMID).UserId:NULL);    
            retVal.RBMcode = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).Name:NULL); 
            retVal.RBMdesc = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).Description:NULL);

            retVal.AVPuser = (TerritoryToUserList.get(retVal.AVPID) != NULL?TerritoryToUserList.get(retVal.AVPID).UserId:NULL); 
            retVal.AVPcode = (TerritoryList.get(retVal.AVPID) != NULL?TerritoryList.get(retVal.AVPID).Name:NULL); 
            retVal.AVPdesc = (TerritoryList.get(retVal.AVPID) != NULL?TerritoryList.get(retVal.AVPID).Description:NULL);
            
            objHierarchyMap.put(objId, retVal);
            System.debug('retVal: ---'+retVal);
        }  
        
        System.debug('objHierarchyMap:----'+objHierarchyMap);
        return objHierarchyMap;
    } 
     
        
     /**
     * Method Name: getAccountHierarchy
     * Description: Method to get account hierarchy using Sales group
     * Parameter:  
     * salesgroup (string) : Sales group code. like CR, OS, DS etc
     * accountId (sting) : Account ID. like 001F000001L5aVuIAJ
     * Return Type: Map<String,UserTerritory>
     * will have {TBM => Userterritory, RBM=> UserTerritory, AVP=> UserTerritory}
     */
      public static Map<Id, TerritoryHierarchy> getAccountHierarchy(set<Id> accountId, map<Id, String> objectAccountMap){

        list<Id> groupIdList = new list<Id>();
        map<Id,list<Id>> accountGroupMap = new map<Id,list<Id>>();
        map<Id,String> groupTerritoryMap = new map<Id,String>();
        map<Id,list<String>> accountTerritoryMap = new map<Id,list<String>>(); 
        map<Id,Id> objectTerritoryMap = new map<Id,Id>(); 
        map<Id, TerritoryHierarchy> objectHierarchyMap = new Map<Id, TerritoryHierarchy>();
        system.debug('objectAccountMap::::' + objectAccountMap);
        system.debug('accountId::::' + accountId);
        
                
        list<AccountShare> accountShare = [SELECT AccountId, UserOrGroupId FROM AccountShare 
                                            WHERE AccountId IN : accountId AND RowCause = 'TerritoryManual'];
        for(AccountShare share : accountShare){
            groupIdList.add(share.UserOrGroupId);
            if(accountGroupMap.containsKey(share.AccountId))
                accountGroupMap.get(share.AccountId).add(share.UserOrGroupId);
            else
                accountGroupMap.put(share.AccountId, new List<Id>{share.UserOrGroupId});
        }        
        
        
        list<Group> groupList = [SELECT id, relatedid, developername FROM Group 
                                    WHERE type ='Territory' AND id in : groupIdList];
        for(Group grp : groupList){
            groupTerritoryMap.put(grp.id, grp.relatedid + '~' + grp.developername);
        }
        
        
        for(Id acctId : accountGroupMap.keySet()){
            for(Id groupId : accountGroupMap.get(acctId)){
                if(accountTerritoryMap.containsKey(acctId))
                    accountTerritoryMap.get(acctId).add(groupTerritoryMap.get(groupId));
                else
                    accountTerritoryMap.put(acctId, new List<String>{groupTerritoryMap.get(groupId)});
            }
        }
                
        
        for(Id objId : objectAccountMap.keySet()){
            list<string> values = objectAccountMap.get(objId).split('~');
            if(accountTerritoryMap.containsKey(values[0])){
                for(string territoryValue : accountTerritoryMap.get(values[0])){
                    list<string> territoryInfo = territoryValue.split('~');
                    if(values[1].equalsIgnoreCase(territoryInfo[1].mid(0, 2))){
                        objectTerritoryMap.put(objId, territoryInfo[0]);
                    }   
                }  
            }         
        }
        
        
        for(Id objId : objectTerritoryMap.keySet()){
            TerritoryHierarchy retVal = new TerritoryHierarchy();
            
            //setting TBM data
            retVal.TBMID = objectTerritoryMap.get(objId);
            retVal.TBMcode = TerritoryList.get(retVal.TBMID).Name;          
            retVal.TBMdesc = TerritoryList.get(retVal.TBMID).Description;
            retVal.TBMuser = (TerritoryToUserList.get(retVal.TBMID) != NULL?TerritoryToUserList.get(retVal.TBMID).UserId:NULL);
            
            //setting RBM data 
            retVal.RBMID = TerritoryList.get(retVal.TBMID).ParentTerritoryID;
            retVal.RBMuser = (TerritoryToUserList.get(retVal.RBMID) != NULL?TerritoryToUserList.get(retVal.RBMID).UserId:NULL);    
            retVal.RBMcode = TerritoryList.get(retVal.RBMID).Name;
            retVal.RBMdesc = TerritoryList.get(retVal.RBMID).Description;
            
            //setting AVP data 
            retVal.AVPID = TerritoryList.get(retVal.RBMID).ParentTerritoryID;
            retVal.AVPuser = (TerritoryToUserList.get(retVal.AVPID) != NULL?TerritoryToUserList.get(retVal.AVPID).UserId:NULL);   
            retVal.AVPcode = TerritoryList.get(retVal.AVPID).Name;
            retVal.AVPdesc = TerritoryList.get(retVal.AVPID).Description;
            
            objectHierarchyMap.put(objId, retVal);
        }   
        return objectHierarchyMap;
      }
      
     /**
     * Method Name: getUserGroupTerritory
     * Description: Method to get User territory using user id and sales group
     * Parameter:  userid~salesgrooup~profilename
     * Return Type: TerritoryId
     */
    public static Id getUserGroupTerritory(String userGroup){
        Id userTerritory = NULL;
        List<String> userGroupList = userGroup.split('~');
        Set<Id> terrIdList = UserTerritoryMap.get(userGroupList[0]);
        for(Id terrId : terrIdList){
            if(userTerritory == NULL && TerritoryList.containsKey(terrId) && TerritoryList.get(terrId).Name.contains(userGroupList[1])){
                userTerritory = terrId;
            }
        }
        return userTerritory;
    }
     
     /**AKR - Start - 13-11-2018 : Created method to fetch territories*/
     /**
     * Method Name: getUserTerritoryGroupid
     * Description: Method to get territory Groupid for user 
     * Parameter:  
     * userIds (Set<id>) : Sales force id of users
     * Return Type: Map<Id,Id>
     * 
     */
      public static Map<Id,Id> getUserTerritoryGroupid(set<Id> userIds){
          Map<Id,Id> userIdTerritoryMap = new Map<Id,Id>();
          Map<Id,Id> TerritoryGroupMap = new Map<Id,Id>();
          Map<Id,Id> userIdTerritoryGroupIdMap = new Map<Id,Id>();
          if(userIds.size()>0){
              for(UserTerritory ust  : [SELECT IsActive,TerritoryId,UserId FROM UserTerritory WHERE IsActive = true and UserId IN :userIds]){
                  if(!userIdTerritoryMap.containsKey(ust.UserId)){
                      userIdTerritoryMap.put(ust.UserId , ust.TerritoryId);
                  }
              }
              if(!userIdTerritoryMap.isEmpty()){
                  for(Group gp : [SELECT id,RelatedId,Type FROM Group WHERE RelatedId IN :userIdTerritoryMap.values() and type =:'Territory']){
                      if(!TerritoryGroupMap.containsKey(gp.RelatedId)){
                        TerritoryGroupMap.put(gp.RelatedId,gp.id);
                      }
                  }
              }
              for(Id usdid : userIds){
                  if(userIdTerritoryMap.get(usdid) != null && TerritoryGroupMap.get(userIdTerritoryMap.get(usdid)) != null){
                      userIdTerritoryGroupIdMap.put(usdid,TerritoryGroupMap.get(userIdTerritoryMap.get(usdid)));
                  }
              } 
          }
          return userIdTerritoryGroupIdMap;
      }
      /**AKR - End - 13-11-2018 : Created method to fetch territories*/
    
    
    /**
     * Method Name: getAccountTerritoryHierarchy
     * Description: Method to get account hierarchy using primary territory
     * Parameter:  set<Id>,map<Id, String>
     * salesgroup (string) : Sales group code. like CR, OS, DS etc
     * accountId (sting) : Account ID. like 001F000001L5aVuIAJ
     * Return Type: Map<String,UserTerritory>
     * will have {TBM => Userterritory, RBM=> UserTerritory, AVP=> UserTerritory}
     */
     public static Map<Id, TerritoryHierarchy> getAccountTerritoryHierarchy(set<Id> accountId, map<Id, String> objectAccountMap){

        list<Id> groupIdList = new list<Id>();
        map<Id,list<Id>> accountGroupMap = new map<Id,list<Id>>();
        map<Id,String> groupTerritoryMap = new map<Id,String>();
        map<Id,list<String>> accountTerritoryMap = new map<Id,list<String>>(); 
        map<Id,Id> objectTerritoryMap = new map<Id,Id>(); 
        map<Id, TerritoryHierarchy> objectHierarchyMap = new Map<Id, TerritoryHierarchy>();
        system.debug('objectAccountMap::::' + objectAccountMap);
        system.debug('accountId::::' + accountId);
        Set<Id> OwnerIdList = new Set<Id>();
         map<Id,List<String>> userTerritoryNameMap =  new map<Id,List<String>>();
        
         For(String AccUserString:objectAccountMap.values()) {             
             OwnerIdList.add(AccUserString.split('~')[1]);
         }
         
         
         if(UserTerritoryMap == NULL)
            fillUserTerritory();
         
         for(Id userId: OwnerIdList){
             List<String> territoryNameSet = new List<String>() ;
             if(UserTerritoryMap.containsKey(userId)){
                 For(Id territoryId:UserTerritoryMap.get(userId) ){
                 territoryNameSet.add(territoryId + '~'+ (TerritoryList.get(territoryId).Name).Left(2));
             }             
             userTerritoryNameMap.put(userId, territoryNameSet);
             }
             
         }
                
         
        list<AccountShare> accountShare = [SELECT AccountId, UserOrGroupId FROM AccountShare 
                                            WHERE AccountId IN : accountId AND RowCause = 'TerritoryManual'];
        for(AccountShare share : accountShare){
            groupIdList.add(share.UserOrGroupId);
            if(accountGroupMap.containsKey(share.AccountId))
                accountGroupMap.get(share.AccountId).add(share.UserOrGroupId);
            else
                accountGroupMap.put(share.AccountId, new List<Id>{share.UserOrGroupId});
        }        
        
        
        list<Group> groupList = [SELECT id, relatedid, developername FROM Group 
                                    WHERE type ='Territory' AND id in : groupIdList];
        for(Group grp : groupList){
            groupTerritoryMap.put(grp.id, grp.relatedid + '~' + grp.developername);
        }
        
        
        for(Id acctId : accountGroupMap.keySet()){
            for(Id groupId : accountGroupMap.get(acctId)){
                if(accountTerritoryMap.containsKey(acctId))
                    accountTerritoryMap.get(acctId).add(groupTerritoryMap.get(groupId));
                else
                    accountTerritoryMap.put(acctId, new List<String>{groupTerritoryMap.get(groupId)});
            }
        }
              
        
        for(Id objId : objectAccountMap.keySet()){
            list<string> values = objectAccountMap.get(objId).split('~');
            Id UserId = objectAccountMap.get(objId).split('~')[1];
            Id territoryId;
            if(accountTerritoryMap.containsKey(values[0]) && userTerritoryNameMap.get(UserId) != Null){
                for(string territoryValue : accountTerritoryMap.get(values[0])){
                    list<string> territoryInfo = territoryValue.split('~');
                    for(String userTerritoryValue:userTerritoryNameMap.get(UserId)){
                        
                        if((userTerritoryValue.split('~')[1]).equalsIgnoreCase(territoryInfo[1].mid(0, 2)))                        
                           territoryId =  territoryInfo[0];                 
                        
                        if(territoryId != Null && (values[2]).equalsIgnoreCase(territoryInfo[1].mid(0, 2))){                            
                            break ;                             
                        }                                 
                    }
                    if(territoryId != Null && (values[2]).equalsIgnoreCase(territoryInfo[1].mid(0, 2)))                         
                            break ;
                    
                }                 
            }
            if(territoryId != Null){
                objectTerritoryMap.put(objId, territoryId);
            }
            
        }        
        
         for(Id objId : objectTerritoryMap.keySet()){
             TerritoryHierarchy retVal = new TerritoryHierarchy();
             if(objectTerritoryMap.get(objId) != Null){
                 //setting TBM data
                 retVal.TBMID = objectTerritoryMap.get(objId);
                 retVal.TBMcode = TerritoryList.get(retVal.TBMID).Name;          
                 retVal.TBMdesc = TerritoryList.get(retVal.TBMID).Description;
                 retVal.TBMuser = (TerritoryToUserList.get(retVal.TBMID) != NULL?TerritoryToUserList.get(retVal.TBMID).UserId:NULL);
                 
                 //setting RBM data 
                 retVal.RBMID = TerritoryList.get(retVal.TBMID).ParentTerritoryID;
                 retVal.RBMuser = (TerritoryToUserList.get(retVal.RBMID) != NULL?TerritoryToUserList.get(retVal.RBMID).UserId:NULL);    
                 retVal.RBMcode = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).Name:NULL);
                 retVal.RBMdesc = (TerritoryList.get(retVal.RBMID) != NULL?TerritoryList.get(retVal.RBMID).Description: NULL);
                 
                 //setting AVP data 
                 retVal.AVPID = TerritoryList.get(retVal.RBMID).ParentTerritoryID;
                 retVal.AVPuser = (TerritoryToUserList.get(retVal.AVPID) != NULL?TerritoryToUserList.get(retVal.AVPID).UserId:NULL);   
                 retVal.AVPcode = (TerritoryList.get(retVal.AVPID) != NULL?TerritoryList.get(retVal.AVPID).Name:NULL);
                 retVal.AVPdesc = (TerritoryList.get(retVal.AVPID) != NULL?TerritoryList.get(retVal.AVPID).Description:NULL);
             }
             objectHierarchyMap.put(objId, retVal);
         }   
         return objectHierarchyMap; 
     }
}