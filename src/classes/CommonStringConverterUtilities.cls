/********************************************************************************
Apex Class Name - CommonStringConverterUtilities
Version - 1.0
Created Date - Sept 3, 2014
Function - Apex Class containing three methods: two methods to convert String to List of 
           SelectOption(with and without '--None--' value) and another to convert 
           String to List of String based on specified delimiter

Modification Log : 
--------------------------------------------------------------------------------

* Developer               Date                 Description
* -------------------     ------------         -----------------------
* Cognizant Developer     09/03/2014           Original Version
********************************************************************************/

global class CommonStringConverterUtilities{

    private static final String delimiter = '~##~'; 
    
    /**
    *   Method Name: convertStringToListSelectOptions
    *   Description: Method to convert String to List of SelectOption with '--None--' value for picklist
    *   Parameter: String                             
    *   Return Type: List<SelectOption>
    */

    public static List<SelectOption> convertStringToListSelectOptions(String str){

        if (str == '' && str == null){
        
            return new List<SelectOption>();
        }
        
        List<String> strList = new List<String>();        
        strList = str.split(delimiter);
        List<SelectOption> returnVal = new List<SelectOption>();
        returnVal.add(new SelectOption('','--None--'));
        for(String strng: strList){
        
            if (strng !=''){
                
                if (strng != 'null' && strng != null) {
                    
                    strng = strng.trim();                    
                    returnVal.add(new SelectOption(strng,strng));
                }
            }
        }
        
        return returnVal;
    }
    
    /**
    *   Method Name: convertStringToListSelectOptionsMultiSelect
    *   Description: Method to convert String to List of SelectOption without '--None--' value for multiselect 
    *   Parameter: String                             
    *   Return Type: List<SelectOption>
    */

    public static List<SelectOption> convertStringToListSelectOptionsMultiSelect(String str){

        if (str == '' && str == null){
        
            return new List<SelectOption>();
        }
        
        List<String> strList = new List<String>();        
        strList = str.split(delimiter);
        List<SelectOption> returnVal = new List<SelectOption>();        
        for(String strng: strList){
        
            if (strng !=''){
                
                if (strng != 'null' && strng != null) {
                    
                    strng = strng.trim();                    
                    returnVal.add(new SelectOption(strng,strng));
                }
            }
        }
        
        return returnVal;
    }

    /**
    *   Method Name: convertStringToListString
    *   Description: Method to convert String to List of String   
    *   Parameter: String                             
    *   Return Type: List<String>
    */
    
    public static List<String> convertStringToListString(String str){
    
        if (str == '' && str == null){
        
            return new List<String>();
        }
    
        List<String> strList = new List<String>();
        strList = str.split(delimiter);
        List<String> returnVal = new List<String>();
        returnVal.add('--None--');
        for(String strng: strList){
            
            if (strng !=''){

                if(strng != 'null' && strng != null){

                    strng = strng.trim();
                    returnVal.add(strng);
                }
            }
        }

        return returnVal;
    }
    
   /**
    * Method Name: convertStringToDate
    * Description: Convert String to date
    * Parameter: String - to be converted            
    * Parameter: String - date format                      
    * Return Type: Date 
    */
    public static Date convertStringToDate(String stringDate, String format){
    	Date retVal;
    	try{
	    	if(format == 'YYYY-MM-DDThh:mm:ss.mmm' && (stringDate != null && stringDate != '')){
	    		retVal = Date.valueOf(stringDate);	
	    	}
    	}catch(Exception e){
    		retVal = null;
    	}
    	return retval;
    }
    
   /**
    * Method Name: convertStringToNumber
    * Description: Convert String to Number
    * Parameter: String - to be converted            
    * Parameter: String - number format                      
    * Return Type: Decimal 
    */
    public static Decimal convertStringToNumber(String stringNumber, String format){
    	Decimal retVal;
    	try{
	    	if(format == '.####' && (stringNumber != null && stringNumber != '')){
	    		retVal = decimal.valueOf(stringNumber).setScale(2);
	    	}
    	}catch(Exception e){
    		retVal = null;
    	}
    	return retval;
    }

}