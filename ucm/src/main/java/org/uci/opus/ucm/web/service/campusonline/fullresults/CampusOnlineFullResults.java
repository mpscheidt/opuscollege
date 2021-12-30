package org.uci.opus.ucm.web.service.campusonline.fullresults;

import java.util.ArrayList;
import java.util.Collection;
import java.util.TreeSet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.ucm.web.service.JsonResponseFactory;

@Controller
public class CampusOnlineFullResults {

    /**
     * Language to be used to resolve student status code.
     */
    private static final String LANGUAGE = "pt";

    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private FullResultDTOFactory fullResultDTOFactory;
    
    @Autowired
    private JsonResponseFactory jsonResponseFactory;
    
    @Autowired
    private LatestTimeUnitFullResultDTOFactory latestTimeUnitFullResultDTOFactory;
    
    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private SubjectMapper subjectMapper;

    /**
     * Generate the full list of results for the student with the given studentCode, "full" meaning that lower level (test/examination) results are included even if there is no result for the related subject yet.
     * @return if hash does not match, an error is returned
     */
    @RequestMapping(value = "/campusOnline/getFullResultsByStudentCode/{studentCode}/{hash}", produces = "application/json; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
    public JsonResponse getFullResultsByStudentCode(@PathVariable String studentCode, @PathVariable String hash) {
        
        log.debug("getFullResultsByStudentCode for student code " + studentCode);

        // Verify hash
        JsonResponse jsonResponse = jsonResponseFactory.fromMD5Hash(studentCode, hash);

        // If hash invalid, return without reading from database
        if (!jsonResponse.isSuccessful()) {
            log.info("wrong hash given for studentCode " + studentCode);
            return jsonResponse;
        }

        // Verify studentCode
        Student student = studentManager.findStudentByCode(studentCode);
        if (student == null) {
            jsonResponse = jsonResponseFactory.fromInvalidStudentCode();
        }
        if (!jsonResponse.isSuccessful()) {
            return jsonResponse;
        }

        String studentStatus = studentManager.getStudentStatus(student, LANGUAGE);
        Collection<LatestTimeUniFullResultDTO> latestTimeUnits = getLatestTimeUnitsFullResult(student);
        jsonResponse.setResult(new CampusOnlineFullResult(student.getSurnameFull(), student.getFirstnamesFull(), studentStatus, latestTimeUnits));
        return jsonResponse;
    }

    /**
     * Get latest time units with timeUnitNumber, progress status, etc.
     */
    private Collection<LatestTimeUniFullResultDTO> getLatestTimeUnitsFullResult(Student student) {
        Collection<LatestTimeUniFullResultDTO> timeUnits = new ArrayList<>();

        for (StudyPlan studyPlan : student.getStudyPlans()) {
            LatestTimeUniFullResultDTO latestTimeUnit = latestTimeUnitFullResultDTOFactory.forStudyPlan(studyPlan);
            timeUnits.add(latestTimeUnit);
            latestTimeUnit.setSubjects(buildSubjectsWithResults(studyPlan));
        }

        return timeUnits;
    }
    
    /**
     * Create a list of {@link SubjectDTO} elements for the given study plan.
     * @return list of results or empty list if there are no results for the given study plan.
     */
    private Collection<SubjectDTO> buildSubjectsWithResults(StudyPlan studyPlan) {
        Collection<SubjectDTO> subExTests = new TreeSet<>(new SubExTestDTOComparator());

        int studyPlanId = studyPlan.getId();
        for (Subject subject : subjectMapper.findSubjectsForStudyPlan(studyPlanId)) {

            // one SubjectDTO entry per subject, all results (sub/ex/text results) directly under the subjectDTO
            SubjectDTO subjectDTO = new SubjectDTO(subject);
            subExTests.add(subjectDTO);

            // add results for this subject if exist
            for (SubjectResult sr : resultManager.findSubjectResultsBySubjectIdAndStudyplanId(subject.getId(), studyPlanId)) {
                subjectDTO.addResult(fullResultDTOFactory.fromSubjectResult(subject, sr, LANGUAGE));
            }

            // Examinations for this subject
            for (Examination examination : subject.getExaminations()) {
                for (ExaminationResult er : resultManager.findExaminationResultsByExaminationIdAndStudyPlanId(examination.getId(), studyPlanId)) {
                    subjectDTO.addResult(fullResultDTOFactory.fromExaminationResult(examination, er));
                }

                // Tests for this examination
                for (Test test : examination.getTests()) {
                    for (TestResult tr : resultManager.findTestResultsByTestIdAndStudyPlanId(test.getId(), studyPlanId)) {
                        subjectDTO.addResult(fullResultDTOFactory.fromTestResult(test, tr));
                    }
                }
            }
            
        }
        
        return subExTests;
    }

}
