/*******************************************************************************
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
 * The Original Code is Opus-College mulungushi module code.
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
 ******************************************************************************/
package org.uci.opus.mulungushi.web.extension;

import java.math.BigDecimal;

import org.apache.commons.lang3.StringUtils;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;

public class CbuCtuResultFormatter extends CtuResultFormatter {

//    @Autowired private ResultManagerInterface resultManager;
//    @Autowired private StudentManagerInterface studentManager;
//    @Autowired private StudyManagerInterface studyManager;

    @Override
    public String get(Object obj) {
        CardinalTimeUnitResult ctuResult = (CardinalTimeUnitResult) obj;
        StringBuilder s = new StringBuilder();

        String mark = ctuResult.getMark();
        if (!StringUtils.isEmpty(mark)) {
            s.append(mark);
        }

        BigDecimal gradePoint = ctuResult.getGradePoint();
        if (gradePoint != null) {
            s.append(" (");
            s.append(gradePoint);
            s.append(")");
        }
        return s.toString();
    }

//    @Override
//    public void loadAdditionalInfo(CardinalTimeUnitResult ctuResult,
//            String endGradeTypeCode, String preferredLanguage) {
//
//        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(
//                ctuResult.getStudyPlanCardinalTimeUnitId());
//        StudyGradeType studyGradeType = studyManager.findStudyGradeType(
//                studyPlanCardinalTimeUnit.getStudyGradeTypeId());
//
//        BigDecimal gradePoint = resultManager.calculateGradePointForMark(
//                ctuResult.getMark(), endGradeTypeCode, preferredLanguage,
//                studyGradeType.getCurrentAcademicYearId());
//        ctuResult.setGradePoint(gradePoint);
//
//        // the following should not be necessary since it's stored in the DB
////        if (ctuResult.getEndGradeComment() == null || "".equals(ctuResult.getEndGradeComment())) {
////            String endGradeComment = resultManager.calculateEndGradeForMark(
////                    ctuResult.getMark(), endGradeTypeCode, preferredLanguage,
////                    studyGradeType.getCurrentAcademicYearId());
////            ctuResult.setEndGradeComment(endGradeComment);
////        }   
//    }

}
