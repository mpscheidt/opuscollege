package org.uci.opus.ucm.web.service.campusonline;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.TreeSet;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.ucm.web.service.JsonResponseFactory;

@Controller
@RequestMapping("/campusOnline")
public class CampusOnline {
    
    /**
     * Language to be used to resolve lookups (student status code, subject result comment).
     */
    private static final String LANGUAGE = "pt";
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private LatestTimeUnitDTOFactory latestTimeUnitDTOFactory;
    
    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private ResultDTOFactory resultDTOFactory;
    
    @Autowired
    private JsonResponseFactory jsonResponseFactory;
    
    /**
     * Generate the list of results for the student with the given studentCode.
     * @return if hash does not match, an error is returned
     */
    @RequestMapping(value = "/getResultsByStudentCode/{studentCode}/{hash}", produces = "application/json; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
    public JsonResponse getResultsByStudentCode(@PathVariable String studentCode, @PathVariable String hash) {

        log.debug("getResultsByStudentCode for student code " + studentCode);

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
        Collection<LatestTimeUnitDTO> latestTimeUnits = getLatestTimeUnits(student);
        jsonResponse.setResult(new CampusOnlineResult(student.getSurnameFull(), student.getFirstnamesFull(), studentStatus, latestTimeUnits));
        return jsonResponse;
    }

    /**
     * Create a list of {@link ResultDTO} elements for the given study plan.
     * @return list of results or empty list if there are no results for the given study plan.
     */
    private Collection<ResultDTO> buildResults(StudyPlan studyPlan) {
        Collection<ResultDTO> results = new TreeSet<>(new ResultDTOComparator());

            List<SubjectResult> subjectResults = resultManager.findSubjectResultsForStudyPlan(studyPlan.getId());
            for (SubjectResult subjectResult : subjectResults) {
                ResultDTO subjectResultDTO = resultDTOFactory.fromSubjectResult(subjectResult, LANGUAGE);
                results.add(subjectResultDTO);
                List<ExaminationResult> examinationResults = resultManager.findExaminationResultsForSubject(subjectResult.getSubjectId(), subjectResult.getStudyPlanDetailId());
                for (ExaminationResult examinationResult : examinationResults) {
                    ResultDTO examinationResultDTO = resultDTOFactory.fromExaminationResult(examinationResult);
                    subjectResultDTO.addSubResult(examinationResultDTO);
                    List<TestResult> testResults = resultManager.findTestResultsForExamination(examinationResult.getExaminationId(), examinationResult.getStudyPlanDetailId());
                    for (TestResult testResult : testResults) {
                        examinationResultDTO.addSubResult(resultDTOFactory.fromTestResult(testResult));
                    }
                }
            }

        return results;
    }

    /**
     * Get latest time units with timeUnitNumber, progress status, etc.
     * @param student
     * @return
     */
    private Collection<LatestTimeUnitDTO> getLatestTimeUnits(Student student) {
        Collection<LatestTimeUnitDTO> timeUnits = new ArrayList<>();

        for (StudyPlan studyPlan : student.getStudyPlans()) {
            LatestTimeUnitDTO latestTimeUnit = latestTimeUnitDTOFactory.forStudyPlan(studyPlan);
            timeUnits.add(latestTimeUnit);
            latestTimeUnit.setResults(buildResults(studyPlan));
        }

        return timeUnits;
    }

    /**
     * Return the student's photograph if it exists.
     * @param studentCode
     * @param hash
     * @return the photograph. If hash does not match, nothing is returned.
     */
    @RequestMapping(value = "/getPhotographByStudentCode/{studentCode}/{hash}", method = RequestMethod.GET)
    public void getPhotographByStudentCode(HttpServletResponse response, @PathVariable String studentCode, @PathVariable String hash) {

        // Verify hash
        JsonResponse jsonResponse = jsonResponseFactory.fromMD5Hash(studentCode, hash);

        // If hash invalid, return without reading from database
        if (!jsonResponse.isSuccessful()) {
            log.warn("Cannot produce image for student with code " + studentCode + ": " + jsonResponse.getResult());
            return;
        }

        Student student = studentManager.findStudentByCode(studentCode);

        if (student.getPhotograph() != null) {

            try {
                log.info("returning image data for student with studentCode " + studentCode);
                response.setContentType(student.getPhotographMimeType());
                FileCopyUtils.copy(student.getPhotograph(), response.getOutputStream());
            } catch (IOException e) {
                log.error("Problem copying photograph bytes to HTTPServletResponse", e);
                return;
            }
        }
    }

}
