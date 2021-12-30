/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 
 * 1.1 (the "License"), you may not use this file except in compliance with 
 * the License. You may obtain a copy of the License at 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College accommodationfee module code.
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

package org.uci.opus.accommodationfee.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.extpoint.FeeAdvisorApplicability;
import org.uci.opus.fee.service.extpoint.FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit;

/**
 * Check if a given fee is an accommodation fee (in the supports() method),
 * and if yes, check if the fee is applicable to the student in
 * the given studyPlanCardinalTimeUnit (in the applies() method.
 * 
 * @author markus
 *
 */
@Service
public class AccommodationFeeApplicabilityAdvisorSpctu implements
        FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit {

    @Autowired private AccommodationFeeManagerInterface accommodationFeeManager;
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    
    @Override
    public FeeAdvisorApplicability applies(Fee fee,
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {

        FeeAdvisorApplicability applies;

        // get accommodationFee
        AccommodationFee accommodationFee = accommodationFeeManager.findAccommodationFeeByFeeId(fee.getId());
        if (accommodationFee == null) {
            applies = FeeAdvisorApplicability.UNSUPPORTED; // if this is not an accommodation fee, no further processing
        } else {
        
            // get academicYearId
            int studyGradeTypeId = studyPlanCardinalTimeUnit.getStudyGradeTypeId();
            int academicYearId = studyManager.findAcademicYearIdForStudyGradeTypeId(studyGradeTypeId);

            // get studentId
            int studentId = studentManager.findStudentIdForStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());

            // is the student assigned to a room for this time unit?
            Map<String, Object> criteria = new HashMap<String, Object>();
            criteria.put("studentId", studentId);
            criteria.put("academicYearId", academicYearId);
            criteria.put("approved", "Y");
            StudentAccommodation studentAccommodation = accommodationManager.findStudentAccommodationByParams(criteria);

            if (studentAccommodation != null
                    && studentAccommodation.getRoom().getRoomTypeCode().equals(accommodationFee.getRoomTypeCode())
                    && studentAccommodation.getRoom().getHostel().getHostelTypeCode().equals(accommodationFee.getHostelTypeCode())) {
                applies = FeeAdvisorApplicability.FEE_APPROVED;
            } else {
                applies = FeeAdvisorApplicability.FEE_REJECTED;
            }
        }

        return applies;
    }

}
