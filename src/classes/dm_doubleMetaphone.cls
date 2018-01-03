public class dm_doubleMetaphone {
/*
	Copyright [2010] [Chris DeGour <Modification to Apex code only. Algorithm license below.>]
     * Licensed to the Apache Software Foundation (ASF) under one or more
     * contributor license agreements.  See the NOTICE file distributed with
     * this work for additional information regarding copyright ownership.
     * The ASF licenses this file to You under the Apache License, Version 2.0
     * (the "License"); you may not use this file except in compliance with
     * the License.  You may obtain a copy of the License at
     * 
     *      http://www.apache.org/licenses/LICENSE-2.0
     * 
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS,
     * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     * See the License for the specific language governing permissions and
     * limitations under the License.
     */
     
     /**
     * Encodes a string into a double metaphone value.
     * This Implementation is based on the algorithm by <CITE>Lawrence Philips</CITE>.
     * <ul>
     * <li>Original Article: <a 
     * href="http://www.cuj.com/documents/s=8038/cuj0006philips/">
     * http://www.cuj.com/documents/s=8038/cuj0006philips/</a></li>
     * <li>Original Source Code: <a href="ftp://ftp.cuj.com/pub/2000/1806/philips.zip">
     * ftp://ftp.cuj.com/pub/2000/1806/philips.zip</a></li>
     * </ul>
     * 
     * @author Apache Software Foundation
     * @version $Id: DoubleMetaphone.java 800153 2009-08-02 22:45:30Z ggregory $
     * MODIFIED BY CHRIS DEGOUR TO WORK WITHIN THE APEX LANGUAGE FOR SALESFORCE.COM USAGE
     */
     
     
     
     /* 
     * "Vowels" to test for
     */
     private static final List<string> VOWELS = new List<string>{'A','E','I','O','U','Y'};
     
     /*
     * Prefixes when present which are not pronounced
     */ 
     private static final List<String> SILENT_START = new List<String> {'GN', 'KN', 'PN', 'WR', 'PS'};
     private static final List<String> L_R_N_M_B_H_F_V_W_SPACE  = new List<string>
     { 'L', 'R', 'N', 'M', 'B', 'H', 'F', 'V', 'W', ' ' };
     private static final List<string> ES_EP_EB_EL_EY_IB_IL_IN_IE_EI_ER  = new List<string>
     { 'ES', 'EP', 'EB', 'EL', 'EY', 'IB', 'IL', 'IN', 'IE', 'EI', 'ER' };
     private static final List<string> L_T_K_S_N_M_B_Z  = new List<string>
     { 'L', 'T', 'K', 'S', 'N', 'M', 'B', 'Z' };
     
     /*
     * Maximum length of an encoding, default is 4
     */
     public static integer maxCodeLen = 4;
     
     /*
     * Creates instance of encoder
     */
     public dm_doubleMetaphone() {
     	
     }
       
     /*
     * Encode a value with Double Metaphone
     *
     * @param value String to encode
     * @return an encoded string
     */
     public static String doubleMetaphone(string value){
     	return doubleMetaphone(value, false);
     }
     
     /**
     * Encode a value with Double Metaphone, optionally using the alternate encoding
     * 
     * @param value String to encode
     * @param alternate use alternate encode
     * @return an encoded string
     */

     public static string doubleMetaphone(string value, boolean alternate)
     {
     	value = cleanInput(value);
     	if(value == null)
     	{
     		return null;
     	}
     	
     	boolean slavoGermanic = isSlavoGermanic(value);
     	integer index = isSilentStart(value) ? 1 : 0;
     	
     	DoubleMetaphoneResult result = new DoubleMetaphoneResult(maxCodeLen);
     	
     	while ((!result.isComplete()) && (index <= value.length() - 1)) //parse through string
     	{
     		// Possible screwup found:if((value.substring(index, index+1) == 'A') && (value.substring(index, index+1) == 'E') && (value.substring(index, index+1) == 'I') && (value.substring(index, index+1) == 'O') && (value.substring(index, index+1) == 'U') && (value.substring(index, index+1) == 'Y'))
     		if((value.substring(index, index+1) == 'A') || (value.substring(index, index+1) == 'E') || (value.substring(index, index+1) == 'I') || (value.substring(index, index+1) == 'O') || (value.substring(index, index+1) == 'U') || (value.substring(index, index+1) == 'Y'))
     		{//If it's a vowel
     			index = handleAEIOUY(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'B')
     		{
     			result.append('P');
     			index = charAt(value, index+1) == 'B' ? index + 2 : index + 1;
     		}
     		/*else if(value.substring(index, index+1) == 'u00C7')
     		{
     			//C with a cedilla
     			result.append('S');
     			index++;
     		}*/
     		else if(value.substring(index, index+1) == 'C')
     		{
     			index = handleC(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'D')
     		{
     			index = handleD(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'G')
     		{
     			index = handleG(value, result, index, slavoGermanic);
     		}
     		else if(value.substring(index, index+1) == 'H')
     		{
     			index = handleH(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'J')
     		{
     			index = handleJ(value, result, index, slavoGermanic);
     		}
     		else if(value.substring(index, index+1) == 'K')
     		{
     			result.append('K');
     			index = charAt(value, index+1) == 'K' ? index+2 : index+1;
     		}
     		else if(value.substring(index, index+1) == 'L')
     		{
     			index = handleL(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'M')
     		{
     			result.append('M');
     			index = conditionM0(value, index) ? index+2 : index+1;
     		}
     		else if(value.substring(index, index+1) == 'N')
     		{
     			result.append('N');
     			index = charAt(value, index+1) == 'N' ? index+2:index+1;
     		}
     		/*else if(value.substring(index, index+1) == 'u00D1')//n with tilde
     		{
     			result.append('N');
     			index++;
     		}*/
     		else if(value.substring(index, index+1) == 'P')
     		{
     			index = handleP(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'Q')
     		{
     			result.append('K');
     			index = charAt(value, index+1) == 'Q' ? index+2 : index+1;
     		}
     		else if(value.substring(index, index+1) == 'R')
     		{
     			index = handleR(value, result, index, slavoGermanic);
     		}
     		else if(value.substring(index, index+1) == 'S')
     		{
     			index = handleS(value, result, index, slavoGermanic);
     		}
     		else if(value.substring(index, index+1) == 'T')
     		{
     			index = handleT(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'V')
     		{
     			result.append('F');
     			index = charAt(value, index+1) == 'V' ? index+2:index+1;
     		}
     		else if(value.substring(index, index+1) == 'W')
     		{
     			index = handleW(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'X')
     		{
     			index = handleX(value, result, index);
     		}
     		else if(value.substring(index, index+1) == 'Z')
     		{
     			index = handleZ(value, result, index, slavoGermanic);
     		}
     		else{
     			index++;
     		}
     		
     	}
     	
     	
     	return alternate ? result.getAlternate() : result.getPrimary();
     }
     
      /**   COMMENTED OUT, SHOULD NOT BE NECESSARY IN SFDC ENVIRONMENT
         * Encode the value using DoubleMetaphone.  It will only work if 
         * <code>obj</code> is a <code>String</code> (like <code>Metaphone</code>).
         *
         * @param obj Object to encode (should be of type String)
         * @return An encoded Object (will be of type String)
         * @throws EncoderException encode parameter is not of type String
         */
/*        public Object encode(Object obj) throws EncoderException {
            if (!(obj instanceof String)) {
                throw new EncoderException("DoubleMetaphone encode parameter is not of type String"); 
            } 
            return doubleMetaphone((String) obj);
        }
        
        
  */  
        /**
         * Encode the value using DoubleMetaphone.
         *
         * @param value String to encode
         * @return An encoded String
         */
        public static String encode(String value) {
        	
            return doubleMetaphone(value);   
        }
    
        /** COMMENTED OUT - ALL ENCODING WILL HAPPPEN UP FRONT, SEARCH WILL COMPARE DIRECTLY.
         * Check if the Double Metaphone values of two <code>String</code> values
         * are equal.
         * 
         * @param value1 The left-hand side of the encoded {@link String#equals(Object)}.
         * @param value2 The right-hand side of the encoded {@link String#equals(Object)}.
         * @return <code>true</code> if the encoded <code>String</code>s are equal;
         *          <code>false</code> otherwise.
         * @see #isDoubleMetaphoneEqual(String,String,boolean)
         *
        public boolean isDoubleMetaphoneEqual(String value1, String value2) {
            return isDoubleMetaphoneEqual(value1, value2, false);
        }
        
        /** COMMENTED OUT
         * Check if the Double Metaphone values of two <code>String</code> values
         * are equal, optionally using the alternate value.
         * 
         * @param value1 The left-hand side of the encoded {@link String#equals(Object)}.
         * @param value2 The right-hand side of the encoded {@link String#equals(Object)}.
         * @param alternate use the alternate value if <code>true</code>.
         * @return <code>true</code> if the encoded <code>String</code>s are equal;
         *          <code>false</code> otherwise.
         *
        public boolean isDoubleMetaphoneEqual(String value1, 
                                              String value2, 
                                              boolean alternate) {
            return doubleMetaphone(value1, alternate).equals(doubleMetaphone
                                                             (value2, alternate));
        }
     */
    //-BEGIN HANDLERS-//
    private static integer handleAEIOUY(String value, DoubleMetaphoneResult result, integer index)
    {
    	if(index == 0)
    	{
    		result.append('A');
    	}
    	return index + 1;
    }
    
    private static integer handleC(String value, doubleMetaphoneResult result, integer index)
    {
    	if(ConditionC0(value, index))
    	{
    		result.append('K');
    		index +=2;
    	}
    	else if (index ==0 && contains(value, index, 6, 'CAESAR')){
    		result.append('S');
    		index += 2;
    	}
    	else if (contains(value, index, 2, 'CH')){
    		index = handleCH(value, result, index);
    	}
    	else if(contains(value, index, 2, 'CZ') && !contains(value, index -2, 4, 'WICZ'))
    	{
    		//czerny//
    		result.append('S', 'X');
    		index += 2;
    	}
    	else if(contains(value, index+1, 3, 'CIA')){
    		//focaccia//
    		result.append('X');
    		index += 3;
    	}
    	else if(contains(value, index, 2, 'CC') && !(index==1 && charAt(value, 0) == 'M')){
    		//double cc but not mcclelland
    		return handleCC(value, result, index);
    	}
    	else if(contains(value, index,2,'CK','CG','CQ')) {
    		result.append('K');
    		index += 2;
    	}
    	else if(contains(value, index, 2, 'CI', 'CE', 'CY')){
    		//italian vs english
    		if(contains(value, index, 3, 'CIO', 'CIE', 'CIA')){
    			result.append('S', 'X');
    		}
    		else{
    			result.append('S');
    		}
    		index+=2;
    	}
    	else{
    		result.append('K');
    		if(contains(value, index+1, 2, ' C', ' Q', ' G')){
    			//mac caffrey, mac gregor
    			index += 3;
    		}
    		else if(contains(value, index+1, 1, 'C', 'K', 'Q') && !contains(value, index+1, 2, 'CE', 'CI')){
    			index += 2;
    		}
    		else{
    			index++;
    		}
    	}
    	return index;
    }
    
    private static integer handleCC(string value, doubleMetaphoneResult result, integer index)
    {
    	if(contains(value, index+2, 1, 'I', 'E', 'H') && !contains(value, index+2, 2, 'HU')){
    		//bellocchio but not bacchus
    		if((index==1 && charAt(value, index-1) == 'A') || contains(value, index-1, 5, 'UCCEE', 'UCCES')) {
    			//accident, accede, succeed
    			result.append('KS');
    		}
    		else{
    			//bacci, bertucci, other italian
    			result.append('X');
    		}
    		index += 3;
    	}
    	else{ //Pierce's rule
    		result.append('K');
    		index += 2;
    	}
    	return index;
    }
    
    private static integer handleCH(string value, doubleMetaphoneResult result, integer index)
    { 
    	if(index > 0 && contains(value, index, 4, 'CHAE')) {
    		result.append('K', 'X');
    		return index + 2;
    	}
    	else if (conditionCH0(value, index)){
    		result.append('K');
    		return index + 2;
    	}
    	else if (conditionCH1(value, index)){
    		result.append('K');
    		return index+2;
    	}
    	else{
    		if(index > 0){
    			if(contains(value,0,2,'MC')){
    				result.append('K');
    			}
    			else{
    				result.append('X', 'K');
    			}
    		}
    		else{
    			result.append('X');
    		}
    	}
    	return index +2;
    }
    
    private static integer handleD(string value, doubleMetaphoneResult result, integer index)
    {
    	if(contains(value, index, 2, 'DG')){
    		//edge
    		if(contains(value, index+2, 1, 'I', 'E', 'Y')){
    			result.append('J');
    			index+= 3;
    			//edgar
    		}
    		else{
    			result.append('TK');
    			index+=2;
    		}
    	}
    	else if(contains(value, index, 2, 'DT', 'DD')){
    		result.append('T');
    		index += 2;  		
    	}
    	else{
    		result.append('T');
    		index++;
    	}
    	return index;
    }
    
    private static integer handleG(string value, doubleMetaphoneResult result, integer index, boolean slavoGermanic)
    {
    	
    	if(charAt(value, index+1) == 'H') {
    		
    		index = handleGH(value, result, index);
    	}
    	else if (charAt(value, index+1) == 'N'){
    		if(index == 1 & isVowel(charAt(value, 0)) && !slavoGermanic){
    			result.append('KN', 'N');
    		}
    		else if(!contains(value, index+2, 2, 'EY') && charAt(value, index+1) != 'Y' && !SlavoGermanic){
    			result.append('N', 'KN');
    		}
    		else{
    			result.append('KN');
    		}
    		index = index +2;
    	}
    	else if(contains(value, index + 1, 2, 'LI') && !slavoGermanic){
    		result.append('KL', 'L');
    		index += 2;
    	}
    	else if(index == 0 && (charAt(value, index+1) == 'Y') || contains(value, index+1, 2, ES_EP_EB_EL_EY_IB_IL_IN_IE_EI_ER)){
    		// ges, gep, gel, gie at beginning
    		result.append('K', 'J');
    		index += 2;
    	}
    	else if((contains(value, index+1, 2, 'ER') || charAt(value, index+1) == 'Y') && !contains(value, 0, 6, 'DANGER', 'RANGER', 'MANGER') && !contains(value, index-1, 1, 'E', 'I') && !contains(value, index-1, 3, 'RGY', 'OGY')){
    		//ger, gy
    		result.append('K', 'J');
    		index += 2;
    	}
    	else if(contains(value, index+1, 1, 'E', 'I', 'Y') || contains(value, index-1, 4, 'AGGI', 'OGGI')){
    		//italian biaggi
    		if((contains(value, 0, 4, 'VAN ', 'VON ') || contains(value, 0, 3, 'SCH')) || contains(value, index+1, 2, 'ET')){
    			//obvious germanic
    			result.append('K');
    		}
    		else if(contains(value, index+1, 3, 'IER')){
    			result.append('J');
    		}
    		else {
    			result.append('J', 'K');
    		}
    		index += 2;
    	}
    	else if(charAt(value, index+1) == 'G'){
    		index += 2;
    		result.append('K');
   		}
		else{
			index++;
			result.append('K');
		}
		return index;
    }
    
    private static integer handleGH(string value, doubleMetaphoneResult result, integer index){
    	
    	if(index>0 && !isVowel(charAt(value, index-1))){
    		
    		result.append('K');
    		index+= 2;
    	}
    	else if(index ==0){
    		
    		if(charAt(value, index+2) == 'I') {
    			result.append('J');
    		}
    		else{
    			result.append('K');
    		}
    		index += 2;
    	}
    	else if((index > 1 && contains(value, index-2, 1, 'B', 'H', 'D')) ||
    			(index > 2 && contains(value, index-3, 1, 'B', 'H', 'D')) ||
    			(index > 3 && contains(value, index-4, 1, 'B', 'H'))){
    				//Parker's rule
    				
    				index+= 2;
    	}
    	else{
    		if(index>2 && charAt(value, index-1) == 'U' && contains(value, index-3, 1, 'C', 'G', 'L', 'R', 'T')) {
    			//laugh, mclaughlin, cough, gough, rough, tough
    			result.append('F');
    		}
    		else if(index > 0 && charAt(value, index-1) != 'I') {
    			result.append('K');
    		}
    		index += 2;
    	}
    	return index;
    }
    
    private static integer handleH(String value, doubleMetaphoneResult result, integer index){ 
    	//only keep if first and before vowel or between 2 vowels
    	if ((index == 0 || (isVowel(charAt(value, index-1))) && isVowel(charAt(value, index+1)))){
    		result.append('H');
    		index+=2;
    		//also takes care of 'hh'
    	}
    	else{
    		index++;
    	}
    	return index;
    }
    
    private static integer handleJ(String value, doubleMetaphoneResult result, integer index, boolean slavoGermanic){
    	if(contains(value, index, 4, 'JOSE') || contains(value, 0, 4, 'SAN ')){
    		//obvious spanish, jose, san jacitnto
    		if((index == 0 && (charAt(value,index+4) == ' ') || value.length() == 4) || contains(value, 0, 4, 'SAN ' )){
    			result.append('H');
    		}
    		else{
    			result.append('J', 'H');
    		}
    		index++;
    	}
    	else{
    		if(index==0 && !contains(value, index, 4, 'JOSE')) {
    			result.append('J', 'A');
    		}
    		else if(isVowel(charAt(value, index-1)) && !slavoGermanic && (charAt(value,index+1) == 'A' || charAt(value, index+1) == 'O')){
    			result.append('J', 'H');
    		}
    		else if(index == value.length() -1) {
    			result.append('J', ' ');
    		}
    		else if(!contains(value, index+1, 1, L_T_K_S_N_M_B_Z) && !contains(value, index-1, 1, 'S', 'K', 'L')){
    			result.append('J');
    		}
    		
    		if(charAt(value, index+1) == 'J'){
    			index+= 2;
    		}
    		else{
    			index++;
    		}
    	}
    	return index;
    }
    
    private static integer handleL(String value, doubleMetaphoneResult result, integer index){
    	if(charAt(value, index+1) == 'L'){
    		if(conditionL0(value, index)) {
    			result.appendPrimary('L');
    		}
    		else{
    			result.append('L');
    		}
    		index+=2;
    	}
    	else{
    		index++;
    		result.append('L');
    	}
    	return index;
    }
    
    private static integer handleP(String value, doubleMetaphoneResult result, integer index){
    	if(charAt(value, index+1) == 'H'){
    		result.append('F');
    		index+=2;
    	}
    	else{
    		result.append('P');
    		index = contains(value, index+1, 1, 'P', 'B') ? index+2 : index+1;
    	}
    	return index;
    }
    
    
    private static integer handleR(String value, doubleMetaphoneResult result, integer index, boolean slavoGermanic){
    	if(index==value.length() - 1 && !slavoGermanic && contains(value, index-2, 2, 'IE') && !contains(value, index-4, 2, 'ME', 'MA')){
    		result.appendAlternate('R');
    	}
    	else{
    		result.append('R');
    	}
    	return charAt(value, index+1) == 'R' ? index+2 : index+1;
    }
    
    
    private static integer handleS(String value, doubleMetaphoneResult result, integer index, boolean slavoGermanic){
    	if(contains(value, index-1, 3, 'ISL', 'YSL')){
    		//special cases, island, isle, carlisle, carlysle
    		index++;
    	}
    	else if(index == 0 && contains(value, index, 5, 'SUGAR')){
    		//special case 'sugar-'
    		result.append('X', 'S');
    		index++;
    	}
    	else if(contains(value, index, 2, 'SH')) {
    		if(contains(value, index+1, 4, 'HEIM', 'HOEK', 'HOLM', 'HOLZ')) {
    			//germanic
    			result.append('S');
    		}
    		else
    		{
    			result.append('X');
    		}
    		index +=2;
    	}
    	else if(contains(value, index, 3, 'SIO', 'SIA') || contains(value, index, 4, 'SIAN')){
    		//italian/armenian
    		if(slavoGermanic){
    			result.append('S');
    		}
    		else{
    			result.append('S', 'X');
    		}
    		index += 3;
    	}
    	else if((index == 0 && contains(value, index+1, 1, 'M', 'N', 'L', 'W')) || contains(value, index + 1, 1, 'Z')){
    		//german and anglicisations ''smith match schmidt'
    		//snider match schneider
    		//also sz in slavic although in hungarian it is s
    		result.append('S', 'X');
    		index = contains(value, index+1, 1, 'Z') ? index +2 : index +1;
    	}
    	else if(contains(value, index, 2, 'SC')){
    		index = handleSC(value, result, index);
    	}
    	else {
    		if(index == value.length() -1 && contains(value, index-2, 2, 'AI', 'OI')){
    			//french resnais, artois
    			result.appendAlternate('S');
    		}
    		else{
    			result.append('S');
    		}
    		index = contains(value, index+1, 1, 'S', 'Z') ? index +2 : index +1;
    	}
    	return index;
    }
    private static integer handleSC(String value, 
                             DoubleMetaphoneResult result, 
                             integer index) {
            if (charAt(value, index + 2) == 'H') {
                //-- Schlesinger's rule --//
                if (contains(value, index + 3, 
                             2, 'OO', 'ER', 'EN', 'UY', 'ED', 'EM')) {
                    //-- Dutch origin, e.g. 'school', 'schooner' --//
                    if (contains(value, index + 3, 2, 'ER', 'EN')) {
                        //-- 'schermerhorn', 'schenker' --//
                        result.append('X', 'SK');
                    } else {
                        result.append('SK');
                    }
                } else {
                    if (index == 0 && !isVowel(charAt(value, 3)) && charAt(value, 3) != 'W') {
                        result.append('X', 'S');
                    } else {
                        result.append('X');
                    }
                }
            } else if (contains(value, index + 2, 1, 'I', 'E', 'Y')) {
                result.append('S');
            } else {
                result.append('SK');
            }
            return index + 3;
      }
    
        /**
         * Handles 'T' cases
         */
        private static integer handleT(String value, 
                            DoubleMetaphoneResult result, 
                            integer index) {
            if (contains(value, index, 4, 'TION')) {
                result.append('X');
                index += 3;
            } else if (contains(value, index, 3, 'TIA', 'TCH')) {
                result.append('X');
                index += 3;
            } else if (contains(value, index, 2, 'TH') || contains(value, index, 
                                                                   3, 'TTH')) {
                if (contains(value, index + 2, 2, 'OM', 'AM') || 
                    //-- special case 'thomas', 'thames' or germanic --//
                    contains(value, 0, 4, 'VAN ', 'VON ') || 
                    contains(value, 0, 3, 'SCH')) {
                    result.append('T');
                } else {
                    result.append('0', 'T');
                }
                index += 2;
            } else {
                result.append('T');
                index = contains(value, index + 1, 1, 'T', 'D') ? index + 2 : index + 1;
            }
            return index;
        }
    
        /**
         * Handles 'W' cases
        */
        private static integer handleW(String value, 
                            DoubleMetaphoneResult result, 
                            integer index) {
            if (contains(value, index, 2, 'WR')) {
                //-- can also be in middle of word --//
                result.append('R');
                index += 2;
            } else {
                if (index == 0 && (isVowel(charAt(value, index + 1)) || 
                                   contains(value, index, 2, 'WH'))) {
                    if (isVowel(charAt(value, index + 1))) {
                        //-- Wasserman should match Vasserman --//
                        result.append('A', 'F');
                    } else {
                        //-- need Uomo to match Womo --//
                        result.append('A');
                    }
                    index++;
                } else if ((index == value.length() - 1 && isVowel(charAt(value, index - 1))) ||
                           contains(value, index - 1, 
                                    5, 'EWSKI', 'EWSKY', 'OWSKI', 'OWSKY') ||
                           contains(value, 0, 3, 'SCH')) {
                    //-- Arnow should match Arnoff --//
                    result.appendAlternate('F');
                    index++;
                } else if (contains(value, index, 4, 'WICZ', 'WITZ')) {
                    //-- Polish e.g. 'filipowicz' --//
                    result.append('TS', 'FX');
                    index += 4;
                } else {
                    index++;
                }
            }
            return index;
        }
        
        /**
         * Handles 'X' cases
         */
        private static integer handleX(String value, 
                            DoubleMetaphoneResult result, 
                            integer index) {
            if (index == 0) {
                result.append('S');
                index++;
            } else {
                if (!((index == value.length() - 1) && 
                      (contains(value, index - 3, 3, 'IAU', 'EAU') || 
                       contains(value, index - 2, 2, 'AU', 'OU')))) {
                    //-- French e.g. breaux --//
                    result.append('KS');
                }
                index = contains(value, index + 1, 1, 'C', 'X') ? index + 2 : index + 1;
            }
            return index;
        }
    
        /**
         * Handles 'Z' cases
         */
        private static integer handleZ(String value, DoubleMetaphoneResult result, integer index, 
                            boolean slavoGermanic) {
            if (charAt(value, index + 1) == 'H') {
                //-- Chinese pinyin e.g. 'zhao' or Angelina 'Zhang' --//
                result.append('J');
                index += 2;
            } else {
                if (contains(value, index + 1, 2, 'ZO', 'ZI', 'ZA') || (slavoGermanic && (index > 0 && charAt(value, index - 1) != 'T'))) {
                    result.append('S', 'TS');
                } else {
                    result.append('S');
                }
                index = charAt(value, index + 1) == 'Z' ? index + 2 : index + 1;
            }
            return index;
        }
    
    	
    
    
    //-BEGIN CONDITIONS-//
    
     /**
         * Complex condition 0 for 'L'
         */
        private static boolean conditionL0(String value, integer index) {
            if (index == value.length() - 3 && 
                contains(value, index - 1, 4, 'ILLO', 'ILLA', 'ALLE')) {
                return true;
            } else if ((contains(value, value.length() - 2, 2, 'AS', 'OS') || 
                        contains(value, value.length() - 1, 1, 'A', 'O')) &&
                       contains(value, index - 1, 4, 'ALLE')) {
                return true;
            } else {
                return false;
            }
        }
        
        /**
         * Complex condition 0 for 'M'
         */
        private static boolean conditionM0(String value, integer index) {
            if (charAt(value, index + 1) == 'M') {
                return true;
            }
            return contains(value, index - 1, 3, 'UMB') &&
                    ((index + 1) == value.length() - 1 || contains(value,
                            index + 2, 2, 'ER'));
        }
    
    private static boolean conditionCH1(string value, integer index)
    {
    	return ((contains(value, 0, 4, 'VAN ', 'VON ') || contains(value, 0, 3, 'SCH')	)	||	contains(value, index-2, 6, 'ORCHES', 'ARCHIT','ORCHID')	||	contains(value, index+2, 1, 'T', 'S')	||	(		(			contains(value,index-1, 1, 'A', 'O', 'U', 'E')			||			index == 0		)		&&		(			contains(value,index+2, 1, L_R_N_M_B_H_F_V_W_SPACE) 			||			index+1 == value.length()-1		)	));
    	
    }
    
    private static boolean conditionCH0(string value, integer index)
    {
    	if(index != 0)
    	{
    		return false;
    	}
    	else if (!contains(value, index +1, 5, 'HARAC', 'HARIS') && !contains(value, index+1, 3, 'HOR', 'HYM', 'HIA', 'HEM'))
    	{
    		return false;	
    	}
    	else if (contains(value, 0, 5, 'CHORE')){
    		return false;
    	}
    	else{
    		return true;
    	}
    }
    
    private static boolean conditionC0(String value, integer index) //that's a zero, not an O
    { 
    	if(contains(value, index, 4, 'CHIA'))
    	{
    		return true;
    	}
    	else if (index  <= 1)
    	{
    		return false;
    	}
    	else if (isVowel(charAt(value, index-2))){
    		return false;
    	}
    	else if (!contains(value, index-1,3,'ACH')){
    		return false;
    	}
    	else{
    		string c = charAt(value, index+2);
    		return (((c != 'I') && (c!= 'E')) || (contains(value, index-2, 6, 'BACHER', 'MACHER')));
    	}
    	return false;
    }
    
	//-BEGIN HELPER FUNCTIONS-//
	
	private static boolean isVowel(string value)
	{
		boolean result = false;
		for(string v : VOWELS)
		{
			if(value == v)
			{
				result = true;
				break;
			}
		}
		return result;
	}
	
	private static boolean contains(string value, integer start, integer length, string s1)
	{
		return contains(value, start, length, new list<string>{s1});
	}
	private static boolean contains(string value, integer start, integer length, string s1, string s2)
	{
		return contains(value, start, length, new list<string>{s1, s2});
	}
	private static boolean contains(string value, integer start, integer length, string s1, string s2, string s3)
	{
		return contains(value, start, length, new list<string>{s1, s2, s3});
	}
	private static boolean contains(string value, integer start, integer length, string s1, string s2, string s3, string s4)
	{
		return contains(value, start, length, new list<string>{s1, s2, s3, s4});
	}
	private static boolean contains(string value, integer start, integer length, string s1, string s2, string s3, string s4, string s5)
	{
		return contains(value, start, length, new list<string>{s1, s2, s3, s4, s5});
	}
	private static boolean contains(string value, integer start, integer length, string s1, string s2, string s3, string s4, string s5, string s6)
	{
		return contains(value, start, length, new list<string>{s1, s2, s3, s4, s5, s6});
	}
	
	/*
		Determines if value contains any of criteria starting at index and ending at index + length
	*/
	private static boolean contains(string value, integer start, integer length, List<string> criteria)
	{	
		boolean result = false;
		if(start >= 0 && start + length<=value.length()) //not first character and not through end character
		{
			string target = value.substring(start, start + length);
			for(string c : criteria)
			{	
				if(target == c)
				{
					result = true;
					break;
				}
			}
		}
				
		return result;
	}
	
	private static string charAt(string value, integer index)
	{
		if(index < 0 || index >= value.length()){
			return '*';
		}
		return value.substring(index, index+1);
	}
	
	/*
		Determines if value starts with silent letter.
		Defined as starting with GN, KN, PN, WR, PS.
	*/
	
	private static boolean isSilentStart(string value)
	{
		boolean result = false;
		for(string s : SILENT_START)
		{
			if(value.startsWith(s))
			{
				result = true;
				break;
			}
		}
		return result;
	}
	
	/*
		Slavo Germanic is defined as containing W, K, CZ, or WITZ. Returns if that's true.
	*/
	private static boolean isSlavoGermanic(string value)
	{
		return value.indexOf('W') > -1 || value.indexOf('K') > -1 || value.indexOf('CZ') > -1 || value.indexOf('WITZ') > -1;
	}
	
	/*
		Cleans input string
	*/
	private static string cleanInput(string input)
	{
		if(input == null){
			return null;
		}
		input = input.trim();
		if (input.length() == 0){
			return null;
		}
		return input.toUpperCase();
	}
	
	//-BEGIN INNER CLASS-//
	public class DoubleMetaphoneResult{
		private string primary = '';
		private string alternate = '';
		private integer maxLength;
		
		public DoubleMetaPhoneResult(integer maxLength){
			this.maxLength = maxLength;
		}
		
		public void append(string value)
		{
			appendPrimary(value);
			appendAlternate(value);
		}
		
		public void append(string primary, string alternate)
		{
			appendPrimary(primary);
			appendAlternate(alternate);
		}
		
		public void appendPrimary(string value){
			if(this.primary.length() < this.maxLength)
			{
				this.primary += value;
			}
		}
		
		public void appendAlternate(string value)
		{
			if(this.alternate.length() < this.maxLength)
			{
				this.alternate += value;
			}
		}
		
		public string getPrimary(){
			return primary;
		}
		
		public string getAlternate(){
			return alternate;
		}
		
		public boolean isComplete(){
			return ((this.primary.length() >= this.maxLength) && (this.alternate.length() >= this.maxLength));
		}
	}
 
 
 
 
 
}