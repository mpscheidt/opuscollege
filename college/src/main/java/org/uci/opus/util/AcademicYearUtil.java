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

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;

@Component
public class AcademicYearUtil {

    private static Logger log = LoggerFactory.getLogger(AcademicYearUtil.class);
    
//    @Autowired private LookupManager lookupManager;
    @Autowired private StudyManagerInterface studyManager;
    
    /**
     * Get the academic year with the given id from the given list of academic years.
     * @param allAcademicYears
     * @param academicYearId
     * @return
     */
    public static AcademicYear getAcademicYearById(
            List<? extends AcademicYear> allAcademicYears, int academicYearId) {
        AcademicYear academicYear = null;
        if (allAcademicYears != null && allAcademicYears.size() != 0) {
        	for (AcademicYear ay: allAcademicYears) {
                if (academicYearId == ay.getId()) {
                    academicYear = ay;
                    break;
                }
            }
        }
        return academicYear;
    }

//    public static List<AcademicYear> getLaterAcademicYears(
//            List<AcademicYear> allAcademicYears, AcademicYear givenAcademicYear) {
//        List<AcademicYear> laterAcademicYears = new ArrayList<AcademicYear>();
//
//        // first, get subsequent academic years via the nextAcademicYear property
//        getNextAcademicYears(allAcademicYears, givenAcademicYear);
//        
//        // TODO: also check for dates: academic years with later start and end dates
//        
//        return laterAcademicYears;
//    }

    /**
     * Get all academic years subsequent to the given one as defined in the <code>nextAcademicYear</code> property.
     * @param allAcademicYears the list of academic years to be searched
     * @param givenAcademicYear the academic year for which subsequent academic years shall be returned
     * @return
     */
    public static List<AcademicYear> getNextAcademicYears(List<? extends AcademicYear> allAcademicYears,
            AcademicYear givenAcademicYear) {

        List<AcademicYear> nextAcademicYears = new ArrayList<>();

        if (givenAcademicYear != null) {
            AcademicYear nextAY = givenAcademicYear;
            
            while (nextAY != null) {
                nextAY = getAcademicYearById(allAcademicYears, nextAY.getNextAcademicYearId()); 
                if (nextAY != null) {
                    nextAcademicYears.add(nextAY);
                } else {
                    break;
                }
            }
        }
        return nextAcademicYears;
    }

    /**
     * Get the academic year subsequent to the given academic year.
     * @param allAcademicYears
     * @param academicYearId
     * @return
     */
    public static AcademicYear getNextAcademicYear(
            List<AcademicYear> allAcademicYears, int academicYearId) {

        AcademicYear academicYear = getAcademicYearById(allAcademicYears, academicYearId);
        return getAcademicYearById(allAcademicYears, academicYear.getNextAcademicYearId());
    }

    /**
     * Get the id of the subsequent academic year.
     * @param allAcademicYears
     * @param academicYearId
     * @return 0 in case there is no subsequent academic year
     */
    public static int getNextAcademicYearId(
            List<AcademicYear> allAcademicYears, int academicYearId) {

        int nextAcademicYearId = 0;
        AcademicYear nextAcademicYear = getNextAcademicYear(allAcademicYears, academicYearId);
        if (nextAcademicYear != null) {
            nextAcademicYearId = nextAcademicYear.getId();
        }
        return nextAcademicYearId;
    }
    /**
     * Get the academic year subsequent to the given academic year.
     * @param allAcademicYears
     * @param academicYearId
     * @return
     */
    public static AcademicYear getPreviousAcademicYear(
            List<AcademicYear> allAcademicYears, int academicYearId) {

        AcademicYear previousAcademicYear = null;
        for (int i = 0; i < allAcademicYears.size(); i++) {
            if (allAcademicYears.get(i).getNextAcademicYearId() == academicYearId) {
                previousAcademicYear = allAcademicYears.get(i);
                break;
            }
        }
        return previousAcademicYear;
    }

    /**
     * Get the id of the preceding academic year.
     * @param allAcademicYears
     * @param academicYearId
     * @return 0 in case there is no preceding academic year
     */
    public static int getPreviousAcademicYearId(
            List<AcademicYear> allAcademicYears, int academicYearId) {

        int previousAcademicYearId = 0;
        AcademicYear previousAcademicYear = getPreviousAcademicYear(allAcademicYears, academicYearId);
        if (previousAcademicYear != null) {
            previousAcademicYearId = previousAcademicYear.getId();
        }
        return previousAcademicYearId;
    }
    
    public boolean isIncrementAcademicYearAfterCTUnr(Lookup8 cardinalTimeUnit, int cardinalTimeUnitNumber) {
//        boolean newAcademicYear;
//        newAcademicYear = cardinalTimeUnitNumber % cardinalTimeUnit.getNrOfUnitsPerYear() == 0;
//        return newAcademicYear;
        return isIncrementAcademicYearAfterCTUnr(cardinalTimeUnit.getNrOfUnitsPerYear(), cardinalTimeUnitNumber);
    }
    
    public boolean isIncrementAcademicYearAtCTUnrForStudyGradeType(int studyGradeTypeId, int cardinalTimeUnitNumber) {
        
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        int nrOfUnitsPerYear = studyManager.findNrOfUnitsPerYearForCardinalTimeUnitCode(studyGradeType.getCardinalTimeUnitCode());
        return isIncrementAcademicYearAtCTUnr(nrOfUnitsPerYear, cardinalTimeUnitNumber);
    }

    /**
     * Indicate if (per default) at the given cardinal time unit number a new academic year starts.
     * @param nrOfUnitsPerYear
     * @param cardinalTimeUnitNumber
     * @return
     */
    public boolean isIncrementAcademicYearAtCTUnr(int nrOfUnitsPerYear, int cardinalTimeUnitNumber) {
        return isIncrementAcademicYearAfterCTUnr(nrOfUnitsPerYear - 1, cardinalTimeUnitNumber);
    }
    
    /**
     * Indicate if (per default) after the given cardinal time unit number a new academic year starts.
     * For example, after 2nd semester starts a new academic year, whereas after 1st semester doesn't.
     * After 3rd trimester starts a new academic year, but not after 1st or 2nd trimester.
     * @param nrOfUnitsPerYear
     * @param cardinalTimeUnitNumber
     * @return true if new academic year
     */
    public boolean isIncrementAcademicYearAfterCTUnr(int nrOfUnitsPerYear, int cardinalTimeUnitNumber) {

        boolean newAcademicYear;
        newAcademicYear = cardinalTimeUnitNumber % nrOfUnitsPerYear == 0;

        return newAcademicYear;
    }
    
    
    /** Check if a string can be parsed to an integer. If yes, return true, if not, return false
     *  @param input the string to be parsed to an Integer
     */
    public static boolean isInteger( String input )  {  
        try { 
            Integer.parseInt( input );  
            return true;  
        }  
        catch(NumberFormatException nfe)  
        {  
            return false;  
        }  
    }
    
    /** Choose between two given academic years either the oldest or the newest, depending on the
     *  parameter oldOrNewYear.
     *  Two checks are being performed:
     *  1. where the academic year is a string which can be parsed to an integer, e.g. 2011
     *  2. where the last 4 characters of the academic year are a string which can be parsed to an integer
     *  , e.g. 2011-2012
     *  If neither of these scenarios are true, null is return
     *  @param academicYear1 one academicYearDescription to compare
     *  @param academicYear2 the other academicYearDescription to compare
     *  @param oldOrNewYear if "new" than return the newest academicYear, otherwise the oldest
     *  @return an academicYear as a string or null
     */
    public static String chooseAcademicYear(final String academicYear1, final String academicYear2, final String oldOrNewYear) {
        String year1= "";
        String year2= "";
        int year1Length = 0;
        int year2Length = 0;
        if (isInteger(academicYear1) && isInteger(academicYear2)) {
            if (Integer.parseInt(academicYear1) > Integer.parseInt(academicYear2)) {
                if (oldOrNewYear == "new") {
                    return academicYear1;
                } else {
                    return academicYear2;
                }
            } else {
                if (oldOrNewYear == "new") {
                    return academicYear2;
                } else {
                    return academicYear1;
                }
            }
        } else {
            year1Length = academicYear1.length();
            year2Length = academicYear2.length();
            year1 = academicYear1.substring(year1Length-4);
            year2 = academicYear2.substring(year2Length-4);
            if (isInteger(year1) && isInteger(year2)) {
                if (Integer.parseInt(year1) > Integer.parseInt(year2)) {
                    if (oldOrNewYear == "new") {
                        return academicYear1;
                    } else {
                        return academicYear2;
                    }
                } else {
                    if (oldOrNewYear == "new") {
                        return academicYear2;
                    } else {
                        return academicYear1;
                    }
                }    
            } else {
                return null;
            }
        }
    }

    /**
     * Get the id of the preceding academic year.
     * @param allAcademicYears
     * @param academicYearId
     * @param currentAcademicYearId
     * @return true in case this is an academic year from the past
     */
    public static boolean isPastAcademicYear(
            List<AcademicYear> allAcademicYears, int academicYearId, int currentAcademicYearId) {

        Collections.sort(allAcademicYears, new AcademicYearComparator());
        
        boolean academicYearIdFound = false;
        boolean currentAcademicYearIdFound = false;
        
        for (int i = 0; i < allAcademicYears.size(); i++) {
            if (allAcademicYears.get(i).getId() == academicYearId) {
                academicYearIdFound = true;
            }
            if (allAcademicYears.get(i).getId() == currentAcademicYearId) {
                currentAcademicYearIdFound = true;
            }
            if (academicYearIdFound == true && currentAcademicYearIdFound == false) {
                return true;
            }
        }
        return false;
    }
    
}
