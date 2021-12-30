package org.uci.opus.ucm.util;

import java.util.List;
import java.util.Map;

import org.uci.opus.util.StringUtil;

/**
 * Compilation of utilities that do not fit anywhere else
 * @author stelio2
 *
 */
public class Utils {

	  public static  String toXml( List<Map<String, Object>>  items, String[] fields){
		  
		  //String line = System.getProperty("line.separator");
		  char line = '\n';
		  StringBuffer xml = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		  
		  xml.append(line);
		  xml.append("<items>");
		  
		  for (Map<String, Object> item : items) {
			  
			  xml.append("<item>");
			 xml.append(line);
			  
			  for(String field: fields){
				  if(!StringUtil.isNullOrEmpty(field, true)){
				xml.append("<").append(field).append(">")
				.append(item.get(field) + "")
				.append("</").append(field).append(">")
				.append(line);
				
				  }
			  }
			  xml.append("</item>");
			  xml.append(line);
		}
		  
		  xml.append("</items>");
		  
		  return xml.toString();
	  }
	  
		public static  String toCsv(List<Map<String, Object>> items, String[] fields) {

			StringBuffer csv = new StringBuffer();
			String line = System.getProperty("line.separator");

			for (Map<String, Object> item : items) {

				for (String field : fields) {
					if (!StringUtil.isNullOrEmpty(field, true)) {
						csv.append(item.get(field) + "").append(",");
					}
				}

				// remove last comma
				csv.deleteCharAt(csv.length() - 1);
				csv.append('\n');
			}
			return csv.toString();

		}

		public static  int[] toIntArray(String[] strs) {

			int[] ints = new int[strs.length];

			for (int i = 0; i < ints.length; i++) {
				ints[i] = Integer.parseInt(strs[i]);
			}
			return ints;
		}

		public static boolean isNullOrEmpty(String[] array){
			boolean isNullOrEmpty = true;
			
			if(array != null && array.length > 0){
				for(String s : array){
					if(!StringUtil.isNullOrEmpty(s, true)){
						isNullOrEmpty = false;
						break;
					}
						
				}
			}
			
			return isNullOrEmpty;
		}
}
