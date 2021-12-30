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
 * The Original Code is Opus-College cbu module code.
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
package org.uci.opus.cbu.service.extension;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.cbu.data.DimensionsDao;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.config.OpusConstants;

/**
 * Evaluation of studentbalance per student for CBU:
 * 
 * <pre>
 * Balance > 0 means there are oustanding fees.
 * Balance = 0 means paid 100%.
 * Balance < 0 means student has paid more than invoiced.
 * </pre>
 * 
 * The student balance indicates the outstanding amount that has yet to be paid by the student.
 * If the balance is 0 or negative, all or even more has been paid.
 * If the balance is positive, there are indeed outstanding amounts to be paid by the student.
 * The sponsorship does not need to be taken into account, since the invoice is reduced by the scholarship amount
 * and the rules say that students have to pay a certain percentage of the oustanding amount.
 * 
 * The rules from 15. April 2013 state that:
 * Full time students need to pay 50% of outstanding fees to be allowed to register for courses.
 * Others (Evening/semester and distance learning students) need to pay 25% to register.
 * 
 * (Additionally, but not relevant at the moment for Opus, because exam registration is done in Opus:
 *  All fees shall be paid before exam registration.)
 * 
 */
public class StudentBalanceEvaluationForCBU implements StudentBalanceEvaluation {

    private static Logger log = LoggerFactory.getLogger(StudentBalanceEvaluationForCBU.class);
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private DimensionsDao dimensionsDao;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;

    @Override
    public StudentBalanceInformation getStudentBalanceInformation(int studentId) {

        String studentCode = studentManager.findStudentCodeForStudentId(studentId);
        StudentBalanceInformation studentBalanceInformation = getStudentBalanceInformation(studentCode);
        studentBalanceInformation.setStudentId(studentId);
        return studentBalanceInformation;
    }

    public StudentBalanceInformation getStudentBalanceInformation(String studentCode) {
        StudentBalanceInformation studentBalanceInformation = dimensionsDao.findBalanceInformationDimensions(studentCode);

        return studentBalanceInformation;
    }

    @Override
    public boolean hasMadeSufficientPaymentsForAdmission(int studyPlanId) {
        
        String identificationNumber = studentManager.findIdentificationNumberByStudyPlanId(studyPlanId);
        String applicationType = dimensionsDao.findAdmissionPaymentInformation(identificationNumber);
        boolean sufficient = applicationType != null && !applicationType.isEmpty();
        
        return sufficient;
    }

    @Override
    public boolean hasMadeSufficientPaymentsForRegistration(StudentBalanceInformation studentBalanceInformation) {
        if (log.isDebugEnabled()) {
            log.debug("StudentBalanceEvaluationForCBU.studentBalanceMeetsScholarshipRules entered");
        }

        String studentCode = studentBalanceInformation.getStudentCode();
        BigDecimal balance = studentBalanceInformation.getBalance();
        BigDecimal paidPercentage = studentBalanceInformation.getPaidPercentage();

        // if no balance is known, the student status shall not progress automatically
        if (balance == null) {
            return false;
        }

        boolean sufficient = false;

        // Find out what the student is studying at the moment - assume that student only studies one study
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("studentCode", studentCode);
        map.put("currentAcademicYearId", academicYearManager.getCurrentAcademicYear().getId());
        List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(map);
        if (studyPlanCardinalTimeUnits == null || studyPlanCardinalTimeUnits.isEmpty()) {
            // if nothing in current academic year, take the last one
            map.clear();
            map.put("studentCode", studentCode);
            map.put("limit", 1);
            map.put("orderBy", "studyPlanCardinalTimeUnit.id desc");
            studyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(map);
        }
        if (studyPlanCardinalTimeUnits != null && !studyPlanCardinalTimeUnits.isEmpty()) {
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnits.get(0);    // we only need the studygradetypeId
            int studyGradeTypeId = studyPlanCardinalTimeUnit.getStudyGradeTypeId();
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
            sufficient = isSufficient(paidPercentage, studyGradeType);
        }

        return sufficient;
    }

    boolean isSufficient(BigDecimal paidPercentage, StudyGradeType studyGradeType) {

        BigDecimal requiredPercentage;
        if (OpusConstants.STUDY_FORM_DISTANT.equals(studyGradeType.getStudyFormCode())
                || OpusConstants.STUDY_TIME_EVENING.equals(studyGradeType.getStudyTimeCode())) {
            requiredPercentage = new BigDecimal(25);    // special groups only need to pay 25%
        } else {
            requiredPercentage = new BigDecimal(50);    // Everybody else (should all be fulltime) pays 50%
        }

        boolean sufficient = (paidPercentage.compareTo(requiredPercentage) >= 0);

        return sufficient;
    }

}
