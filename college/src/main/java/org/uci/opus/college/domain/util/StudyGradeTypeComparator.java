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
 * Center for Information Services, Radboud University Nijmegen
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

package org.uci.opus.college.domain.util;

import java.util.Comparator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.util.AcademicYearComparator;
import org.uci.opus.util.AcademicYearUtil;
import org.uci.opus.util.lookup.LookupUtil;

/**
 * Compare studyGradeTypes.
 * First criteria: grade type.
 * Second criteria: academic year.
 * Other criteria can be added as required.
 * @author markus
 *
 */
public class StudyGradeTypeComparator implements Comparator<StudyGradeType> {

    private static Logger log = LoggerFactory.getLogger(StudyGradeTypeComparator.class);
    private boolean ascendingAcademicYear = true;
    private boolean ascendingGradeType = true;
    private List<AcademicYear> allAcademicYears;
    private List<? extends Lookup9> allGradeTypes;
    private AcademicYearComparator academicYearComparator = new AcademicYearComparator();

    
    public StudyGradeTypeComparator(List<AcademicYear> allAcademicYears, List<? extends Lookup9> allGradeTypes) {
        this.allAcademicYears = allAcademicYears;
        this.allGradeTypes = allGradeTypes;
    }
    
    @Override
    public int compare(StudyGradeType o1, StudyGradeType o2) {
        int compare;

        // first criteria: grade type
        Lookup gradeType1 = LookupUtil.getLookupByCode(allGradeTypes, o1.getGradeTypeCode());
        Lookup gradeType2 = LookupUtil.getLookupByCode(allGradeTypes, o2.getGradeTypeCode());
        if (gradeType1 == null || gradeType2 == null) {
            log.warn("Don't know about grade type " + (gradeType1 == null ? o1.getGradeTypeCode() : o2.getGradeTypeCode()) + ". This should be corrected");
            compare = 0;
        } else {
            if (ascendingGradeType) {
                compare = gradeType1.getDescription().compareToIgnoreCase(gradeType2.getDescription());
            } else {
                compare = gradeType2.getDescription().compareToIgnoreCase(gradeType1.getDescription());
            }
        }
        
        // if both have same grade type, next criteria is the academic year
        if (compare == 0) {
            AcademicYear academicYear1 = AcademicYearUtil.getAcademicYearById(allAcademicYears, o1.getCurrentAcademicYearId());
            AcademicYear academicYear2 = AcademicYearUtil.getAcademicYearById(allAcademicYears, o2.getCurrentAcademicYearId());
            if (ascendingAcademicYear) {
                compare = academicYearComparator.compare(academicYear1, academicYear2);
            } else {
                compare = academicYearComparator.compare(academicYear2, academicYear1);
            }
        }
        
        return compare;
    }

    public boolean isAscendingAcademicYear() {
        return ascendingAcademicYear;
    }

    public void setAscendingAcademicYear(boolean ascendingAcademicYear) {
        this.ascendingAcademicYear = ascendingAcademicYear;
    }

    public boolean isAscendingGradeType() {
        return ascendingGradeType;
    }

    public void setAscendingGradeType(boolean ascendingGradeType) {
        this.ascendingGradeType = ascendingGradeType;
    }

}
