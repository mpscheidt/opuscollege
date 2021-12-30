package org.uci.opus.cbu.util;

public class StringUtil {
	
	/**
	 * Formats a by by Capitalization every first letter except for [and,to,from]
	 * It also capitalizes words such as [i,ii,ii]
	 * 
	 * @param data The data to be formatted
	 * @return A formated String
	 */
	public static String prettyFormat(String data){
    	String[] words= data.trim().split(" ");
    	String finalWord="";
    	
    	for(String word: words){
    		if(word.trim().toLowerCase().equals("to") || word.trim().toLowerCase().equals("and") || word.trim().toLowerCase().equals("of"))
    			finalWord+=" " + word.toLowerCase();
    		else if(word.trim().toLowerCase().equals("i") || word.trim().toLowerCase().equals("ii") || word.trim().toLowerCase().equals("iii"))
    			finalWord+=" " + word.trim().toUpperCase();
    		else 
    			finalWord+=" " + word.trim().substring(0,1).toUpperCase() + word.trim().substring(1).toLowerCase();
    	}
    	
    	return finalWord.trim();
    }

}
