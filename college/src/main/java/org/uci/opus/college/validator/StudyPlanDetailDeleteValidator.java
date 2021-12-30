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

package org.uci.opus.college.validator;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;

@Service
public class StudyPlanDetailDeleteValidator {

    private static Logger log = LoggerFactory.getLogger(StudyPlanDetailDeleteValidator.class);

    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;

    public StudyPlanDetailDeleteValidator() {
        super();
    }

    public void validate(StudyPlanDetail studyPlanDetail, Errors errors) {

        if (studyPlanDetail != null) {

            int studyPlanDetailId = studyPlanDetail.getId();
            if (studyPlanDetail.getSubjectId() != 0) {
                // LOOSE SUBJECT
                validateSubject(errors, studyPlanDetailId, studyPlanDetail.getSubjectId());
            } else {
                if (studyPlanDetail.getSubjectBlockId() != 0) {
                    // SUBJECT - SUBJECTBLOCK
                    List < ? extends Subject > subjectSubjectBlockList = null;
                    subjectSubjectBlockList = (List<? extends Subject>) subjectBlockMapper.findSubjectsForSubjectBlockInStudyPlainDetail(studyPlanDetail.getSubjectBlockId());
                    for (int x = 0; x < subjectSubjectBlockList.size(); x++) {
                        validateSubject(errors, studyPlanDetailId, subjectSubjectBlockList.get(x).getId());
                    }
                }
            }
        }

    }

    private void validateSubject(Errors errors, int studyPlanDetailId, int subjectId) {
        
        Map<String, Object> resultListMap = new HashMap<>();
        resultListMap.put("studyPlanDetailId", studyPlanDetailId);
        resultListMap.put("subjectId", subjectId);
        List<SubjectResult> subjectResultsForStudyPlanDetail = resultManager.findSubjectResultsByParams(resultListMap);

        if (subjectResultsForStudyPlanDetail != null && subjectResultsForStudyPlanDetail.size() != 0) {
            // show error for linked results
            Subject subject = subjectManager.findSubject(subjectId);
            errors.reject("jsp.error.general.delete.linked.subjectresult", new Object[] { subject.getSubjectDescription() }, "subject result exists");
        } else {
            // examination cannot be deleted if examination results are present
            List<ExaminationResult> examinationResultListForStudyPlanDetail = resultManager.findExaminationResultsForStudyPlanDetail(resultListMap);

            if (examinationResultListForStudyPlanDetail.size() != 0) {
                // show error for linked results
                Subject s = subjectManager.findSubject(subjectId);
                Examination e = examinationManager.findExamination(examinationResultListForStudyPlanDetail.get(0).getExaminationId());
                errors.reject("jsp.error.general.delete.linked.examinationresult", new Object[] { s.getSubjectDescription() + " / " +  e.getExaminationDescription() }, "examination result exists");
            }
        }
    }
    
}
