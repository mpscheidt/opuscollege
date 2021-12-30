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

import java.text.DateFormat;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author nist Java Programmer of the UCI of the Raboud University
 *  
 */
public class DateUtil {

    private String javaPattern;

    private Date universalDate;

    private Locale locale;

    private SimpleDateFormat datumformat;

    private static Logger log = LoggerFactory.getLogger(DateUtil.class);
    
    /**
     * G   Era designator       Text    AD
     * y   Year                 Year    1996; 96
     * M   Month in year        Month   July; Jul; 07
     * w   Week in year         Number  27
     * W   Week in month        Number  2
     * D   Day in year          Number  189
     * d   Day in month         Number  10
     * F   Day of week in month Number  2
     * E   Day in week          Text    Tuesday; Tue
     * a   Am/pm marker         Text    PM
     * H   Hour in day (0-23)   Number  0
     * k   Hour in day (1-24)   Number  24
     * K   Hour in am/pm (0-11) Number  0
     * h   Hour in am/pm (1-12) Number  12
     * m   Minute in hour       Number  30
     * s   Second in minute     Number  55
     * S   Millisecond          Number  978
     * z   Time zone            General time zone   Pacific Standard Time; PST; GMT-08:00
     * Z   Time zone            RFC 822 time zone   -0800    public DateUtil()
    **/
    {
        // Stel de default waarden in
        setJavaPattern("EEEE dd MMMM yyyy");
        setLocale("nl", "NL");
        setDatumformat(new SimpleDateFormat(getJavaPattern(),getLocale()));
       
    }

    /**
     * @return Returns the javaPattern.
     */
    public String getJavaPattern()
    {
        return javaPattern;
    }

    /**
     * @param javaPattern
     *            The javaPattern to set.
     */
    public void setJavaPattern(String javaPattern)
    {
        this.javaPattern = javaPattern;
    }

    /**
     * @param dateTime
     *            defaults to current date when null
     */
    public void setDateFromJava(Date dateTime)
    {
        if (dateTime == null)
        {
            dateTime = new Date();
        } else
        {
            universalDate = dateTime;
        }

    }

    /**
     *  @param dateTime
     * 	string with date which complies with the default pattern.     
     */
    public void setDateFromJava(String dateTime)
    {
        setDateFromJava(dateTime, getJavaPattern());
        
    }

    /**
     *  @param dateTime
     * 	string with date which complies with the given
     * 	@param pattern
     *     
     */
    public void setDateFromJava(String dateTime, String pattern)
    {
        Date d;

        setDatumformat(new SimpleDateFormat(pattern, getLocale()));

        //uitzoeken of dit weg kan
        datumformat.setCalendar(Calendar.getInstance(getLocale()));

        setUniversalDate(datumformat.parse(dateTime, new ParsePosition(0)));

    }

    /**
     * @param javaDate
     * 
     * setUniversalDate fills an instanciated  javadate for further use
     */
    protected void setUniversalDate(Date javaDate)
    {
        this.universalDate = javaDate;
    }

    Date getJavaDate()
    {
        return universalDate;
    }

    public String getJavaDateFormatted()
    {
        String s;

        Calendar cal = Calendar.getInstance(getLocale());
        SimpleDateFormat sdf = getDatumFormat();
        sdf.setCalendar(cal);

        sdf.applyPattern(getJavaPattern());

        s = sdf.format(getJavaDate());

        return s;
    }
     
    /**
     * @return Returns the locale.
     */
    Locale getLocale()
    {
        return locale;
    }

    
    /**
     * @param locale
     */
    private void setLocale(Locale locale)
    {
        this.locale = locale;
    }

    /**
     * @param language
     * @param country
     */
    private void setLocale(String language, String country)

    {
        Locale[] availableLocales;
        Locale lcl;
        lcl = Locale.getDefault(); // initializeer naar de default Locale

        // haal de ge?nstalleerde Locales op
        availableLocales = Locale.getAvailableLocales();
        // Test of de gevraagde Locales geinstalleerd zijn, indien zo return
        // deze dan.
        for (int i = 0; i < availableLocales.length; i++)
        {
            if (availableLocales[i].getLanguage().equals(language)
                    && availableLocales[i].getCountry().equals(country))
            {
                lcl = availableLocales[i];
            }
        }
        setLocale(lcl);
    }

    /**
     * @return Returns the datumformat.
     */
    public SimpleDateFormat getDatumFormat()
    {
        return datumformat;
    }

    /**
     * @param datumformat
     *            The datumformat to set.
     */
    public void setDatumformat(SimpleDateFormat datumformat)
    {
        this.datumformat = datumformat;
    }

	public Date parseSimpleDate(String dateString, String dateformat) {

        DateFormat df = new SimpleDateFormat(dateformat);
		Date dt = new Date();
		
		try {
			dt = df.parse(dateString);
		} catch (ParseException e) {
	        log.error("DateUtil.parseSimpleDate dit not succeed with following string: " + dateString + " and following dateformat: " + dateformat);
		}
		
		return dt;
	}
    
	public Date parseSimpleDateFormatted(String dateString) {

        Date dt = new Date();
		
		try {
			dt = datumformat.parse(dateString);
		} catch (ParseException e) {
	        log.error("DateUtil.parseSimpleDateFormatted dit not succeed with following string: " + dateString);
		}
		
		return dt;
	}

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the valid format yyyy-MM-dd
     * MoVe: not necessary anymore in spring 2.5 -> validation is now type-specific
     */
    public boolean isValidDate(Date dt) {

        SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

        boolean isDate = false;

        df.format(dt);
        isDate = true;

        return isDate;
        
    }

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the valid format yyyy-MM-dd
     */
    public boolean isValidDateString(String dateString) {

        SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

        boolean isDate = true;
        Date dateToCheck = new Date();
        
        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("yyyy-MM-dd");
        
        try {
			dateToCheck = df.parse(dateString);
		} catch (ParseException e) {
			isDate = false;
		}
		return isDate;
    }

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the past
     */
    public boolean isPastDate(Date dt) {

    	SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

    	boolean isPastDate = false;
        //Date dateToCheck = new Date();
    	Date dateToCheck = dt;
        Date dateNow = new Date();

        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("yyyy-MM-dd");
        String strDateNow = dtc.getJavaDateFormatted();
        
        try {
			dateNow = df.parse(strDateNow);
		} catch (ParseException e) {
			isPastDate = false;
		}
        
        int dtCompInt = dateNow.compareTo(dateToCheck);
        
        if (dtCompInt > 0) {
        	isPastDate = true;
        } else {
        	isPastDate = false;
        }
        
        return isPastDate;
        
    }

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the past
     */
    public boolean isPastDateString(String dateString) {

    	SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

    	boolean isPastDate = false;
        Date dateToCheck = new Date();
        Date dateNow = new Date();

        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("yyyy-MM-dd");
        String strDateNow = dtc.getJavaDateFormatted();
        
        try {
			dateToCheck = df.parse(dateString);
		} catch (ParseException e) {
			isPastDate = false;
		}
        
        try {
			dateNow = df.parse(strDateNow);
		} catch (ParseException e) {
			isPastDate = false;
		}
        
        int dtCompInt = dateNow.compareTo(dateToCheck);
        
        if (dtCompInt > 0) {
        	isPastDate = true;
        } else {
        	isPastDate = false;
        }
        
        return isPastDate;
        
    }

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the past
     */
    public boolean isFutureDate(Date dt) {

    	SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

    	boolean isFutureDate = false;
        Date dateToCheck = dt;
        Date dateNow = new Date();

        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("yyyy-MM-dd");
        String strDateNow = dtc.getJavaDateFormatted();
        
       
        try {
			dateNow = df.parse(strDateNow);
		} catch (ParseException e) {
			isFutureDate = false;
		}
        
        int dtCompInt = dateNow.compareTo(dateToCheck);
        
        if (dtCompInt < 0) {
        	isFutureDate = true;
        } else {
        	isFutureDate = false;
        }
        
        return isFutureDate;
        
    }

    /**
     * @param date to be validated.
     * @return boolean false/true
     * This method returns whether a date is in the past
     */
    public boolean isFutureDateString(String dateString) {

    	SimpleDateFormat df = new SimpleDateFormat(StringUtil.DATEONLY);

    	boolean isFutureDate = false;

    	Date dateToCheck = new Date();
        //Date dateToCheck = dt;
        Date dateNow = new Date();

        DateUtil dtc = new DateUtil();
        dtc.setDateFromJava(new Date());
        dtc.setJavaPattern("yyyy-MM-dd");
        String strDateNow = dtc.getJavaDateFormatted();
        
        try {
			dateToCheck = df.parse(dateString);
		} catch (ParseException e) {
			isFutureDate = false;
		}
        
        try {
			dateNow = df.parse(strDateNow);
		} catch (ParseException e) {
			isFutureDate = false;
		}
        
        int dtCompInt = dateNow.compareTo(dateToCheck);
        
        if (dtCompInt < 0) {
        	isFutureDate = true;
        } else {
        	isFutureDate = false;
        }
        
        return isFutureDate;
        
    }

    /**
     * Get a date object from an ISO date formatted string,
     * for example: 2011-09-30
     * @param date
     * @return
     * @throws ParseException
     */
    public static Date parseIsoDate(String date) throws ParseException {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        return df.parse(date);
    }

    /**
     * Same as {@link #parseIsoDate(String)}, but handles the {@link ParseException} by simply logging it and returning null.
     * @param dateString
     * @return the Date object or null if an exception occurred.
     */
    public static Date parseIsoDateNoExc(String dateString) {
        Date date = null;
        try {
            date = parseIsoDate(dateString);
        } catch (ParseException e) {
            log.error("Unexpected parsing date error", e);
        }
        return date;
    }

}
