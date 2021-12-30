/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/
package org.uci.opus.util;

import java.math.BigDecimal;
import java.security.InvalidParameterException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class supplying String manipulation needed in Opus.
 * <P>
 * All methods are static.
 * 
 * @author jaap/move UCI
 * 
 */
public class StringUtil {

    public static final String DATEONLY    = "yyyy-MM-dd";
    public static final String DATETIME    = "yyyy-MM-dd HH:mm";
    public static final String DATETIMESQL = "YYYY-MM-DD HH24:MI";
    
    private static final Pattern JAVASCRIPT_CHARACTERS = Pattern.compile("(\"|\')");


    private static Logger log = LoggerFactory.getLogger(StringUtil.class);

    /**
     * On input String null, an empty String is returned, otherwise the String
     * itself.
     * @param stringIn a String
     * @return the input String or "" (empty String)
     */
    public static String emptyStringIfNull(final String stringIn) {
        // Personal Metis guideline 2006-10-10: return empty string when null
       return emptyStringIfNull(stringIn, false);
    }

    /**
     * On input String null, an empty String is returned, otherwise the String
     * itself, trimmed if parameter "strip" is true, untrimmed otherwise.
     * 
     * @param stringIn String, may be null
     * @param trim true if the String must be trimmed
     * @return "" or the input string (trimmed or not depending on value of trim)
     */
    public static String emptyStringIfNull(final String stringIn, final boolean trim) {
        if (stringIn == null) {
            return "";
        } else if (trim) {
            return stringIn.trim();
        } else {
            return stringIn;            
        }        
    }

    /**
     * On input String null, empty String or spaces, null is returned, otherwise
     * the trimmed String.
     * 
     * @param stringIn String
     * @return String: the trimmed input string or null
     */
    public static String nullIfEmpty(final String stringIn) {
        /* Personal Metis guideline 2006-10-10 for service-layer: 
         * when receiving an empty String or space(s), make this
         * a null for the data-layer */
        if (isNullOrEmpty(stringIn, true)) {
            return null;
        } else {
            return stringIn.trim();
        }
    }

    /**
     * @param s String
     * @return 1 if it is a valid int, 0 if the String was null or (stripped)
     *         empty string, -1 if it is no valid int
     */
    public static int checkValidInt(final String s) {
        // If there are no numeric characters, zero (not null) is returned as
        // default
        if (isNullOrEmpty(s, true)) {
            return 0;
        } else {
            try {
                int intS = Integer.parseInt(s);
                return 1;
            } catch (Exception e) {
                return -1;
            }
        }
    }

    /**
     * @param s String
     * @return 1 if it is a valid double, 0 if the String was null or (stripped)
     *         empty string, -1 if it is no valid double
     */
    public static int checkValidDouble(final String s) {
        // If there are no numeric characters, zero (not null) is returned as
        // default
        if (isNullOrEmpty(s, true)) {
            return 0;
        } else {
            String n = convertCommaSeparator(s);
            try {
                Double.parseDouble(n);
                return 1;
            } catch (Exception e) {
                return -1;
            }
        }
    }

    /**
     * @param s String to check
     * @return true if the String is empty String;
     * false otherwise (also if null or if there are only spaces).
     */
    public static boolean isEmpty(final String s) {
        return isEmpty(s, false);
    }

    /**
     * @param s String to check
     * @param compareTrimmed 
     *            true: first trim the string (remove spaces)
     *            false: compare String without trimming.
     * @return true if the String is empty String.
     * Also true if parameter compareTrimmed is true and s contains only space(s).
     * False in all othe cases.
     */
    public static boolean isEmpty(final String s, final boolean compareTrimmed) {
        if (s == null) {
            return false; 
        } else if (compareTrimmed) {
            return ("".equals(s.trim()));
        } else {
            return ("".equals(s));
        }
    }
    
    public static boolean isNull(final String s) {
        if (s == null) {
            return true; 
        } else {
            return false;
        }
    }
    
    /**
     * @param s String
     * @return true if the String is null or empty String;
     * false otherwise (also if there are only spaces).
     */
    public static boolean isNullOrEmpty(final String s) {
        return isNullOrEmpty(s, false);
    }

    /**
     * @param s String to be compared
     * @param compareTrimmed
     *            true: first trim the string and then compare it to empty
     *            string 
     *            false: compare String without trimming.
     * @return true if the String is null or empty String.
     * Also true if parameter compareTrimmed is true and s contains only space(s).
     * False in all othe cases.
     */
    public static boolean isNullOrEmpty(final String s, final boolean compareTrimmed) {
        if (compareTrimmed) {
            return (s == null || "".equals(s.trim()));
        } else {
            return (s == null || "".equals(s));
        }
    }

    /**
     * @param stripme the String to strip.
     * @return empty String if null, otherwise stripme stripped
     * from the characters specified in JAVASCRIPT_CHARACTERS.
     */
    public static String stripForJavascript(final String stripme) {

        if (stripme == null) {
            return "";
        }

        Matcher m = JAVASCRIPT_CHARACTERS.matcher(stripme);
        if (m.find()) {
            return m.replaceAll("");
        } else {
        return stripme;
        }
    }

    /**
     * various strip spaces variants:
    */
    /* remove leading whitespace */
    public static String lTrim(String source) {
        return source.replaceAll("^\\s+", "");
    }

    /* remove trailing whitespace */
    public static String rTrim(String source) {
        return source.replaceAll("\\s+$", "");
    }

    /* replace single whitespaces between words with single blank */
    public static String strTrim(String source) {
        return source.replaceAll("\\b\\s\\b", "");
    }

    /* replace multiple whitespaces between words with single blank */
    public static String strMTrim(String source) {
        return source.replaceAll("\\b\\s{2,}\\b", " ");
    }

    /* remove all superfluous whitespaces in source string */
    public static String fullTrim(String source) {
        return strMTrim(strTrim(lTrim(rTrim(source))));
    }

    public static String lrtrim(String source){
        return lTrim(rTrim(source));
    }

    /**
     * Test if the string contains enough characters.
     * @author nist
     * @param s String to test
     * @param level 1 = restricted search, 2 = wider search, 3 = full search
     * @param minLengthRequired ignored in level 1 and 2: overridden with 0; 
     * in other levels the parameter is used).
     * @return true if there are minLength or more characters present in s after
     *         removing wildchar characters. False if there are less characters
     *         then the min required specified in minLength.        
     */
    public static boolean testSearchString(final String newString,
            final int minLengthRequired, final int level) {

        if (newString == null) {
            throw new InvalidParameterException(
                    "testSearchString called with null parameter String expected");
        }
        
        boolean isEnoughCharacters = false;
        int minLength = minLengthRequired;

        switch (level) {
        case 1:            // e.g. Co-Authors
            minLength = 0;
            break;
        case 2:            // e.g. Colleagues
            minLength = 0;
            break;
        case 3:            // Others (search all limited)
            minLength = minLengthRequired; // was 3 until 2007-02-10
            break;
        default:
            minLength = minLengthRequired; // was 4 until 2007-02-10
            break;
        }

        // verwijder wildchars zoals % en _ en spaties.
        String wildcardChars = "\\%|\\_| ";
        String[] nonWildcardchars = newString.split(wildcardChars);
        StringBuffer sB = new StringBuffer("");

        for (int i = 0; i < nonWildcardchars.length && !isEnoughCharacters; i++) {
             sB.append(nonWildcardchars[i]);
            if (sB.length() >= minLength) {
                isEnoughCharacters = true;
            }
        }

        return isEnoughCharacters;
    }

    /**
     * Tests the searchString for authors (the "like"-search).
     * @author jaap
     * @param s String to test
     * @return true if 
     * - the string is null
     * - OR starts with the wildcard % and is followed by no other characters
     * - OR is empty String
     * - OR contains only space(s)
     */
    public static boolean isSearchStringWildcard(final String s) {

        boolean returnvalue;
        if (isNullOrEmpty(s, true)) {
            returnvalue = true; 
            /* the string is null OR is empty String OR contains only space(s) */
        } else if ("%".equals(s)) { 
            returnvalue = true; 
            /* the string starts with the wildcard % and is followed by no other characters */
        } else {
            returnvalue = false;
        }
        return returnvalue;
    }

    /**
     * @param inDate a Date. 
     * @return date as a String in default Metis format as a date without time
     * empty String when null.
     */
    public static String formatDateOnly(final Date inDate) {
        String date;
        if (inDate == null) {
            date = "";
        } else {
            SimpleDateFormat sdate = new SimpleDateFormat(StringUtil.DATEONLY);
            date = sdate.format(inDate);
        }
        return  date;
    }
    
    /**
     * @param stringParam the String to display )for debug)
     * @return the String "null" if null, otherwise the String embedded in single quotes. 
     * This shows the distinction between a null and a String that contains the text "null".
     * Usefull to check a String that may be made by a javascript-function. 
     */
    public static String displayStringAsNullIfNull(final String stringParam) {
        String returnString = null;
        if (stringParam == null) {
            returnString = "NULL";   
        } else {
            returnString = "'" + stringParam + "'";
        }
        return returnString;
    }
    
    /**
     * Used in unit-testing.
     * @param s1 a String
     * @param s2 another String
     * @return true if they are both null OR if they are both not null and equal.
     * This method circumvents the problem that the "normal" equals does not allow
     * nulls;
     */
    public static boolean equalsTakingNullIntoAccount(final String s1, final String s2) {
        return ((s1 == null & s2 == null)    // if they are both null they are equal
                || (s1 != null && s2 != null // otherwise, both are not null, the can be compared
                        && s1.equals(s2)));  // and if they are equal, they are !!
    }
    
    
    /**
     * Used in unit-testing.
     * @param d1 a Date
     * @param d2 another Date
     * @return true if they are both null OR if they are both not null and equal.
     * This method circumvents the problem that the "normal" equals does not allow
     * nulls;
     */
    public static boolean equalsTakingNullIntoAccount(final Date d1, final Date d2) {
        return ((d1 == null & d2 == null)    // if they are both null they are equal
                || (d1 != null && d2 != null // otherwise, both are not null, the can be compared
                        && d1.equals(d2)));  // and if they are equal, they are !!
    }
    
    /**
     * @param codeType e.g. P for personCode, C for contractCode, A for addressCode.
     * @param locationCode String to be added to the code; e.g. a random string for branch or the 
     *               organizationalUnitCode for contract
     * @return String uniqueCode
     * This method builds a unique personCode/contractcode/addresscode and so on, 
     *      based on organization, codeType and the current datetime
     */
    public static String createUniqueCode(final String codeType, final String locationCode) {
        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("ddMMyyyyHmmss");
        String dateString = dtc.getJavaDateFormatted();
        String personCode = codeType + locationCode + dateString;
        dtc = null;
        return personCode;
    }
    
    /**
     * @param  codeType e.g. U for userName.
     * @param  locationCode String to be added to the code; e.g. surName for userName. 
     * @return String uniqueCode
     * This method builds a unique code that can be added to and so on, 
     *      based on organization, codeType and the current datetime
     */
    public static String createSimpleUniqueCode(final String codeType, final String locationCode) {
    	DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("ddMMyyyyHmmss");
        String dateString = dtc.getJavaDateFormatted().substring(9);
        // add extra value because of batch entrance dbconversion (same timestamp):
        RandomString randomString = new RandomString(6);
        String uniqueCode = locationCode + codeType + dateString + randomString.nextString();
        dtc = null;
        return uniqueCode;
    }
    

    /**
     * Given a string, add leading characters until the target length is reached.
     * Example: given String s = "12", target length = 5, leadChar = '0'.
     * Then the result will be the string "00012".
     * @param s
     * @param targetLength
     * @param ch
     * @return
     */
    public static String prefixChars(String s, int targetLength, char ch) {
    	StringBuilder buf = new StringBuilder(targetLength);
    	int toAdd = targetLength - s.length();
    	for (int i = 0; i < toAdd; i++) {
    		buf.append(ch);
    	}
    	buf.append(s);
    	return buf.toString();
    }
    
    /**
     * Given a locale, set the max number of digits for a double value in a numberformat
     * @param locale
     * @return numberformat itself
     */
    @Deprecated
    public static double formatDoubleMark(double dbl) {
        
        //http://stackoverflow.com/questions/153724/how-to-round-a-number-to-n-decimal-prices-in-java
        //Assuming value is a double, you can do:
        //(double)Math.round(value * 100000) / 100000
        //That's for 5 digits precision. The number of zeros indicate the number of decimals.
        dbl = (double)Math.round(dbl * 10) / 10;
        return dbl;
    }

    /**
     * Convert s to an int, given the s is not null nor empty.
     * @param s
     * @return the converted int value, or 0 if conversion failed.
     */
    public static int intValue(String s) {
        int intValue = 0;
        if (!isNullOrEmpty(s, true)) {
            intValue = Integer.parseInt(s);
        }
        return intValue;
    }

    /**
     * Create a comma separated list from the given collection.
     * E.g. from list with "1", "2" and "3", the String "1, 2, 3" is returned.
     * @param c
     * @return
     */
    public static String commaSeparatedList(Collection<?> c) {
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (Iterator<?> it = c.iterator(); it.hasNext(); ) {
            Object o = it.next();
            if (first) first = false;
            else sb.append(", ");
            sb.append(o);
        }
        return sb.toString();
    }

    /**
     * Convert the given mark from String to BigDecimal if it is valid.
     * @param mark
     * @return
     */
    public static BigDecimal toBigDecimalMark(String mark) {
        BigDecimal markDecimal = null;

        mark = convertCommaSeparator(mark);

        if (checkValidDouble(mark) == 1) {
            markDecimal = new BigDecimal(mark);
        }

        return markDecimal;
    }

	private static String convertCommaSeparator(String mark) {
		if (mark != null) {
        	// Java needs a dot as comma separator
        	mark = mark.replace(',', '.');
        }
		return mark;
	}

    public static String listToString(List list, String delimiter){

    	StringBuilder sb = new StringBuilder();
    	
    	for (Object n : list) { 
    		if (sb.length() > 0) sb.append(delimiter);
    		sb.append("'").append(n.toString()).append("'");
    	}
    	
    	if(sb.length() > 0)
    		sb.deleteCharAt(sb.length()-1);
    	
    	return sb.toString();

    }
    
    public static String arrayToString(Object[] list, String delimiter){

    	StringBuilder sb = new StringBuilder();
    	
    	for (Object n : list) { 
    		if (sb.length() > 0) sb.append(delimiter);
    		sb.append("'").append(n.toString()).append("'");
    	}
    	
    	if(sb.length() > 0)
    		sb.deleteCharAt(sb.length()-1);
    	
    	return sb.toString();

    }

    /**
     * Convert a "Y"/"N" String flag into a Boolean.
     * 
     * @param yesNoFlag
     * @return {@link Boolean#TRUE}, {@link Boolean#FALSE} or null
     */
    public static Boolean toBoolean(String yesNoFlag) {
        return yesNoFlag == null ? null : "Y".equalsIgnoreCase(yesNoFlag) ? true : false;
    }

}

