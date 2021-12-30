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

package org.uci.opus.college.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;

/**
 * @author stelio2
 *
 */
public interface AcademicYearManagerInterface {

    AcademicYear findAcademicYear(int id);

    /**
     * Find the academic year for the current date
     */
    AcademicYear getCurrentAcademicYear();

    /**
     * Find the academic year for the current date if within the given academic years.
     */
    AcademicYear getCurrentAcademicYear(List <AcademicYear> allAcademicYears);

    /**
     * Find the academic year of admission for the current date (next academic year)
     */
    AcademicYear getCurrentAcademicYearOfAdmission();

    List<AcademicYear> findAllAcademicYears();

    /**
     * Find the academicYears sorted by description
     */
    List<AcademicYear> findAllAcademicYearsSorted();

    List<AcademicYear> findAcademicYears(final Map<String, Object> map);

    /**
     * Find the academicYears equal or older than the given year.
     * @param year maximum academicYear to find 
     * @return list of academicYears
     */
    List<AcademicYear> findAcademicYears(String year);

    int addAcademicYear(AcademicYear academicYear);

    void updateAcademicYear(AcademicYear academicYear);

    void deleteAcademicYear(int id);

    /**
     * Find the next academicYear based on the sort by description
     * @param currentAcademicYearId
     * @return nextAcademicYearId
     */
    //	int findNextAcademicYearId(int academicYearId);

    /**
     * Find numberOfSubjectsToGrade for admission from appConfig.
     * @param date current date
     * @return numberOfSubjectsToGrade
     */
    Integer findRequestAdmissionNumberOfSubjectsToGrade(Date date);

    /**
     * Find the last academic year, e.g. for a particular study plan.
     * @param map
     * @return
     */
    AcademicYear findLastAcademicYear(Map<String, Object> map);

    /**
     * Get the difference in days between the start dates of two academic years.
     * @param academicYearId1
     * @param academicYearId2
     * @return
     */
    int getIntervalInDaysBetweenAcademicYears(int academicYearId1, int academicYearId2);

    /**
     * Finds tables that depend on the academic year 
     * 
     * @param map - Parameters to filter academic years
     * @return A map containing table names as key and the number of dependecies on said table as values
     */
    Map<String,Object> findDependencies(Map<String,Object> map);

    Map<String,Object> findDependencies(int academicYearId);

    AcademicYear getPreviousAcademicYear(int academicYearId);

}
