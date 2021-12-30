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

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Authorization;
import org.uci.opus.college.domain.AuthorizationMap;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.domain.result.ExaminationResultPrivilegeFlags;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.domain.result.IResultAttempt;
import org.uci.opus.college.domain.result.ResultPrivilegeFlags;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.SubjectResultPrivilegeFlags;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.result.TestResultComment;
import org.uci.opus.college.domain.result.TestResultPrivilegeFlags;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.persistence.AcademicYearMapper;
import org.uci.opus.college.persistence.CardinaltimeunitResultMapper;
import org.uci.opus.college.persistence.ExaminationResultCommentMapper;
import org.uci.opus.college.persistence.ExaminationResultMapper;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.persistence.StudyplanResultMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.persistence.SubjectResultMapper;
import org.uci.opus.college.persistence.TestResultCommentMapper;
import org.uci.opus.college.persistence.TestResultMapper;
import org.uci.opus.college.persistence.ThesisResultMapper;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.ProgressCalculation;
import org.uci.opus.college.service.extpoint.ResultsCalculations;
import org.uci.opus.college.service.factory.ResultGeneratorFactory;
import org.uci.opus.college.service.result.ExaminationResultGenerator;
import org.uci.opus.college.service.result.ExaminationResultRounder;
import org.uci.opus.college.service.result.ResultPrivilegeFlagsFactory;
import org.uci.opus.college.service.result.ResultUtil;
import org.uci.opus.college.service.result.SubjectResultGenerator;
import org.uci.opus.college.web.user.OpusSecurityException;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.DomainObjectMapCreator;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.SubjectResultDateComparator;

/**
 * @author move
 * @author markus
 *
 */
public class ResultManager implements ResultManagerInterface {

    private static Logger log = LoggerFactory.getLogger(ResultManager.class);
    private static Logger securityLog = LoggerFactory.getLogger("SECURITY." + ResultManager.class);

    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private TestManagerInterface testManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private ResultUtil resultUtil;
    @Autowired private ResultPrivilegeFlagsFactory resultPrivilegeFlagsFactory;
    @Autowired private ExaminationResultRounder examinationResultRounder;

    @Autowired private AcademicYearMapper academicYearMapper;
    @Autowired private CardinaltimeunitResultMapper cardinaltimeunitResultMapper;
    @Autowired private ExaminationResultMapper examinationResultMapper;
    @Autowired private ExaminationResultCommentMapper examinationResultCommentMapper;
    @Autowired private StudyplanResultMapper studyplanResultMapper;
    @Autowired private StudyMapper studyMapper;
    @Autowired private SubjectMapper subjectMapper;
    @Autowired private SubjectResultMapper subjectResultMapper;
    @Autowired private TestResultCommentMapper testResultCommentMapper;
    @Autowired private TestResultMapper testResultMapper;
    @Autowired private ThesisResultMapper thesisResultMapper;

    @Autowired
    private ResultGeneratorFactory resultGeneratorFactory;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public ResultManager() {
        super();
    }
    
    @Override
    public SubjectResult findSubjectResult(int subjectResultId) {
        return subjectResultMapper.findSubjectResult(subjectResultId);
    }

    @Override
    public SubjectResult findSubjectResultByParams(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultByParams(map);
    }

    @Override
    public List < SubjectResult > findSubjectResultsByParams(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultsByParams(map);
    }

    @Override
    public List<SubjectResult> findSubjectResultsBySubjectIdAndStudyplanId(int subjectId, int studyPlanId) {
        Map<String, Object> map = new HashMap<>();
        map.put("subjectId", subjectId);
        map.put("studyPlanId", studyPlanId);
        return subjectResultMapper.findSubjectResultsByParams(map);
    }
    
    
    @Override
    public SubjectResult findLatestSubjectResult(int studyPlanDetailId, int subjectId) {

        Map<String, Object> subjectResultMap = new HashMap<>();
        subjectResultMap.put("studyPlanDetailId", studyPlanDetailId);
        subjectResultMap.put("subjectId", subjectId);
        subjectResultMap.put("orderBy", "subjectResult.subjectResultDate DESC");
        subjectResultMap.put("limit", 1);
        List<SubjectResult> subjectResults = findSubjectResultsByParams(subjectResultMap);

        return subjectResults.isEmpty() ? null : subjectResults.get(0);
    }

    @Override
    public List < SubjectResult > findSubjectResults(int subjectId) {
        return subjectResultMapper.findSubjectResults(subjectId);
    }

    @Override
    public List < SubjectResult > findSubjectResultsForStudent(int studentId) {

    	List < SubjectResult > allSubjectResultsForStudent = null;

    	Map<String, Object> map = new HashMap<>();
    	map.put("studentId", studentId);
    	allSubjectResultsForStudent = subjectResultMapper.findSubjectResultsForStudent(map);

    	return allSubjectResultsForStudent;
    	
    }

    @Override
    public List <SubjectResult> findSubjectResultsForStudent(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultsForStudent(map);
    }

    @Override
    public List < SubjectResult > findSubjectResultsForSubjectStudyGradeType(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultsForSubjectStudyGradeType(map);
    }

    @Override
    public List < SubjectResult > findSubjectResultsForSubjectBlockStudyGradeType(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultsForSubjectBlockStudyGradeType(map);
    }

    @Override
    public List<Subject> findPassedSubjects(int studyPlanId, Collection<Integer> subjectIds, Integer cardinalTimeUnitIdLessThan) {

        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("subjectIds", subjectIds);
        map.put("cardinalTimeUnitIdLessThan", cardinalTimeUnitIdLessThan);
        return subjectMapper.findPassedSubjects(map);
    } 
    
    @Override
    public List < ExaminationResult > findExaminationResultsForSubjectStudyGradeType(
            Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsForSubjectStudyGradeType(map);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsForSubjectBlockStudyGradeType(
            Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsForSubjectBlockStudyGradeType(map);
    }

    @Override
    public List < TestResult > findTestResultsForSubjectStudyGradeType(Map<String, Object> map) {
        return testResultMapper.findTestResultsForSubjectStudyGradeType(map);
    }

    @Override
    public List < TestResult > findTestResultsForSubjectBlockStudyGradeType(Map<String, Object> map) {
        return testResultMapper.findTestResultsForSubjectBlockStudyGradeType(map);
    }

    @Override
    @Transactional
    public void saveSubjectResultIfModified(HttpServletRequest request, SubjectResult subjectResult, SubjectResult subjectResultInDB, int academicYearId, SubjectResultGenerator subjectResultGenerator) {
        int subjectResultId = subjectResult.getId();

        boolean modified = true; // only mark or staffmemberId can be modified here
        boolean markHasChanged = true;
        if (subjectResultId != 0) {

            BigDecimal markDecimal = StringUtil.toBigDecimalMark(subjectResult.getMark());
            BigDecimal markInDbDecimal = StringUtil.toBigDecimalMark(subjectResultInDB.getMark());

            markHasChanged = markDecimal == null ? markInDbDecimal != null : !markDecimal.equals(markInDbDecimal);
            modified = markHasChanged || subjectResult.getStaffMemberId() != subjectResultInDB.getStaffMemberId()
                    || !StringUtils.equals(subjectResult.getEndGradeComment(), subjectResultInDB.getEndGradeComment());
        }

        if (markHasChanged) {
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            String gradeTypeCode = studyManager.findGradeTypeCodeForStudyPlanDetail(subjectResult.getStudyPlanDetailId());
            String passed = isPassedSubjectResult(subjectResult, subjectResult.getMark(), preferredLanguage, gradeTypeCode, subjectResultGenerator);
            EndGrade endGrade = calculateEndGradeForMark(subjectResult.getMark(), gradeTypeCode, preferredLanguage, academicYearId);
            if (endGrade != null) {
                subjectResult.setEndGradeComment(endGrade.getCode());
            }
            subjectResult.setPassed(passed);
        }

        if (modified) {
            if (subjectResult.getId() == 0) {
                addSubjectResult(subjectResult, request);
            } else {
                updateSubjectResult(subjectResult, request);
            }
        }
    }

    @Override
    public void saveResultIfModified(HttpServletRequest request, IResult result, IResult resultInDB) {

        // only mark or staffmemberId can be modified here
        boolean modified = true;
        
        // markHasChanged shall be true for new records
        boolean markHasChanged = true;

        if (result.getId() != 0) {

            BigDecimal markDecimal = StringUtil.toBigDecimalMark(result.getMark());
            BigDecimal markInDbDecimal = StringUtil.toBigDecimalMark(resultInDB.getMark());

            markHasChanged = markDecimal == null ? markInDbDecimal != null : !markDecimal.equals(markInDbDecimal);
            modified = !result.unmodified(resultInDB);
        }

        if (markHasChanged) {
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            String passed = isPassedResult(result, result.getMark(), preferredLanguage);
            result.setPassed(passed);
        }

        if (modified) {
            if (result.getId() == 0) {
                addResult(result, request);
            } else {
                updateResult(result, request);
            }
        }
    }

    @Override
    public void addResult(IResult result, HttpServletRequest request) {

        // TODO think of something better to avoid if/else chain

        if (result instanceof SubjectResult) {
            addSubjectResult((SubjectResult) result, request);
        } else if (result instanceof ExaminationResult) {
            addExaminationResult((ExaminationResult) result, request);
        } else  if (result instanceof TestResult) {
            addTestResult((TestResult) result, request);
        } else {
            throw new RuntimeException("Invalid type of result: " + result);
        }
    }

    @Override
    public void updateResult(IResult result, HttpServletRequest request) {

        // TODO think of something better to avoid if/else chain

        if (result instanceof SubjectResult) {
            updateSubjectResult((SubjectResult) result, request);
        } else if (result instanceof ExaminationResult) {
            updateExaminationResult((ExaminationResult) result, request);
        } else  if (result instanceof TestResult) {
            updateTestResult((TestResult) result, request);
        } else {
            throw new RuntimeException("Invalid type of result: " + result);
        }
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('CREATE_SUBJECTS_RESULTS', 'CREATE_RESULTS_ASSIGNED_SUBJECTS')")
    public void addSubjectResult(SubjectResult subjectResult, HttpServletRequest request) {

        subjectResult.setWriteWho(opusMethods.getWriteWho(request));
        subjectResultMapper.addSubjectResult(subjectResult);
    	subjectResultMapper.addSubjectResultHistory(subjectResult);
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('UPDATE_SUBJECTS_RESULTS', 'UPDATE_RESULTS_ASSIGNED_SUBJECTS')")
    public void updateSubjectResult(SubjectResult subjectResult, HttpServletRequest request) {

        subjectResult.setWriteWho(opusMethods.getWriteWho(request));
        subjectResultMapper.updateSubjectResult(subjectResult);
        subjectResultMapper.updateSubjectResultHistory(subjectResult);
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('DELETE_SUBJECTS_RESULTS', 'DELETE_RESULTS_ASSIGNED_SUBJECTS')")
    public void deleteSubjectResult(int subjectResultId, String writeWho) {
        
        SubjectResult subjectResult = findSubjectResult(subjectResultId);
        subjectResultMapper.deleteSubjectResult(subjectResultId);
        
        subjectResult.setWriteWho(writeWho);
        subjectResultMapper.deleteSubjectResultHistory(subjectResult);
    }

    @Override
    public ExaminationResult findExaminationResult(int id) {
    	return examinationResultMapper.findExaminationResult(id);
    }

    @Override
    public ExaminationResult findExaminationResultByParams(Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultByParams(map);
    }

    @Override
    public List < ExaminationResult > findExaminationResults(int examinationId) {
        return examinationResultMapper.findExaminationResults(examinationId);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsByParams(Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsByParams(map);
    }

    @Override
    public List<ExaminationResult> findExaminationResultsByExaminationIdAndStudyPlanId(int examinationId, int studyPlanId) {
        
        Map<String, Object> map = new HashMap<>();
        map.put("examinationId", examinationId);
        map.put("studyPlanId", studyPlanId);
        return examinationResultMapper.findExaminationResultsByParams(map);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsForAcademicYear(Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsForAcademicYear(map);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsForSubject(int subjectId) {
        return examinationResultMapper.findExaminationResultsForSubject(subjectId);
    }

    @Override
    public TestResult findTestResult(int testResultId) {
        return testResultMapper.findTestResult(testResultId);
    }

    @Override
    public List < TestResult > findTestResults(int testId) {
        return testResultMapper.findTestResults(testId);
    }

    @Override
    public List < TestResult > findTestResultsByParams(Map<String, Object> map) {
        return testResultMapper.findTestResultsByParams(map);
    }

    @Override
    public List<TestResult> findTestResultsByTestIdAndStudyPlanId(int testId, int studyPlanId) {
        Map<String, Object> map = new HashMap<>();
        map.put("testId", testId);
        map.put("studyPlanId", studyPlanId);
        return testResultMapper.findTestResultsByParams(map);
    }

    @Override
    public List<TestResult> findTestResultsForExamination(int examinationId, int studyPlanDetailId) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanDetailId", studyPlanDetailId);
        map.put("examinationId", examinationId);
        return testResultMapper.findTestResultsByParams(map);
    }

    @Override
    public void addTestResult(TestResult testResult, HttpServletRequest request) {

        testResult.setWriteWho(opusMethods.getWriteWho(request));
        testResultMapper.addTestResult(testResult);
        testResultMapper.addTestResultHistory(testResult);
    }

    @Override
    public void updateTestResult(TestResult testResult, HttpServletRequest request) {

        testResult.setWriteWho(opusMethods.getWriteWho(request));
        testResultMapper.updateTestResult(testResult);
        testResultMapper.updateTestResultHistory(testResult);
    }

    @Override
    public void deleteTestResult(int testResultId, String writeWho) {

        TestResult testResult = findTestResult(testResultId);
        log.info("deleting test result " + testResult);
        testResultMapper.deleteTestResult(testResultId);

        testResult.setWriteWho(writeWho);
        testResultMapper.deleteTestResultHistory(testResult);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsForStudyPlan(int studyPlanId) {

        return examinationResultMapper.findExaminationResultsForStudyPlan(studyPlanId);
    }

    @Override
    public List < ExaminationResult > findExaminationResultsForStudyPlanDetail(
    			Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsForStudyPlanDetail(map);
    }
    
    @Override
    public List<ExaminationResult> findExaminationResultsForSubject(int subjectId, int studyPlanDetailId) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanDetailId", studyPlanDetailId);
        map.put("subjectId", subjectId);
        return examinationResultMapper.findExaminationResultsByParams(map);
    }

    @Override
    public List < ExaminationResult > findActiveExaminationResultsForSubjectResult(
                Map<String, Object> map) {
        return examinationResultMapper.findActiveExaminationResultsForSubjectResult(map);
    }

    @Override
    public List < TestResult > findTestResultsForStudyPlanDetail(
                Map<String, Object> map) {
        return testResultMapper.findTestResultsForStudyPlanDetail(map);
    }

    @Override
    public List < TestResult > findActiveTestResultsForExaminationResult(
                Map<String, Object> map) {
        return testResultMapper.findActiveTestResultsForExaminationResult(map);
    }

    @Override
    @Transactional
    public void addExaminationResult(ExaminationResult examinationResult, HttpServletRequest request) {

        examinationResult.setWriteWho(opusMethods.getWriteWho(request));
        examinationResultMapper.addExaminationResult(examinationResult);
        examinationResultMapper.addExaminationResultHistory(examinationResult);

        autoGenerateSubjectResult(examinationResult, request);
    }

    /**
     * Automatically calculate the subject result if desired and possible
     */
    private void autoGenerateSubjectResult(ExaminationResult examinationResult, HttpServletRequest request) {

        if (!appConfigManager.getAutoGenerateSubjectResult()) {
            return;
        }

        int studyPlanDetailId = examinationResult.getStudyPlanDetailId();
        SubjectResult subjectResultInDB = null;
        SubjectResult subjectResult = findLatestSubjectResult(studyPlanDetailId, examinationResult.getSubjectId());
        if (subjectResult == null) {
            subjectResult = new SubjectResult(examinationResult.getSubjectId(), studyPlanDetailId, examinationResult.getStaffMemberId(), examinationResult.getExaminationResultDate());
        } else {
            // need to have a different Java instance so that changes in subjectResult.mark are not done in subjectResultInDB
            subjectResultInDB = findSubjectResult(subjectResult.getId());
        }

        BindingResult bindingResult = new BeanPropertyBindingResult(subjectResult, "subjectResult");
        SubjectResultGenerator subjectResultGenerator = generateSubjectResultMark(subjectResult, OpusMethods.getPreferredLanguage(request), bindingResult);

        if (bindingResult.hasErrors()) {
            log.info("Subject result not auto-generated because: " + bindingResult.getAllErrors());
        } else {
            Subject subject = subjectResultGenerator.getSubject();
            String updateOrNewText = subjectResult.getId() == 0 ? "New subject result" : "Updating subject result with id " + subjectResult.getId();
            log.info(updateOrNewText + ": Auto-generating subject result after entering examination result for studyplandetail " + studyPlanDetailId + " and subject (" + subject.getId() + " / " + subject.getSubjectDescription() + ")");
            saveSubjectResultIfModified(request, subjectResult, subjectResultInDB, subject.getCurrentAcademicYearId(), subjectResultGenerator);
        }
    }
    
    private void autoDeleteSubjectResult(ExaminationResult examinationResult, String writeWho) {

        if (!appConfigManager.getAutoGenerateSubjectResult()) {
            return;
        }
        
        SubjectResult subjectResult = findLatestSubjectResult(examinationResult.getStudyPlanDetailId(), examinationResult.getSubjectId());
        if (subjectResult == null) {
            // No subject result exists, so there is nothing that could be auto-deleted
            return;
        }

        log.info("auto removing subject result " + subjectResult + " due to removal of examination result " + examinationResult);
        deleteSubjectResult(subjectResult.getId(), writeWho);

    }

    @Override
    @Transactional
    public void updateExaminationResult(ExaminationResult examinationResult, HttpServletRequest request) {

        examinationResult.setWriteWho(opusMethods.getWriteWho(request));
        examinationResultMapper.updateExaminationResult(examinationResult);
        examinationResultMapper.updateExaminationResultHistory(examinationResult);

        autoGenerateSubjectResult(examinationResult, request);
    }

    @Override
    @Transactional
    public void deleteExaminationResult(int id, String writeWho) {
        
        ExaminationResult examinationResult = findExaminationResult(id);
        autoDeleteSubjectResult(examinationResult, writeWho);

        examinationResultMapper.deleteExaminationResult(id);
        
        examinationResult.setWriteWho(writeWho);
        examinationResultMapper.deleteExaminationResultHistory(examinationResult);
    }

    @Override
    public StudyPlanResult findStudyPlanResult(int studyPlanResultId) {
        return studyplanResultMapper.findStudyPlanResult(studyPlanResultId);
    }

    @Override
    public ThesisResult findThesisResult(int thesisResultId) {
        return thesisResultMapper.findThesisResult(thesisResultId);
    }

    @Override
    public ThesisResult findThesisResultByThesisId(int thesisId) {
        return thesisResultMapper.findThesisResultByThesisId(thesisId);
    }

    @Override
    public List < CardinalTimeUnitResult > findCardinalTimeUnitResultsForStudent(
    		Map<String, Object> map) {

        return  cardinaltimeunitResultMapper.findCardinalTimeUnitResultsForStudent(map);
    }

    @Override
    public List<CardinalTimeUnitResult> findCardinalTimeUnitResultsForStudyPlan(int studyPlanId) {
        return cardinaltimeunitResultMapper.findCardinalTimeUnitResultsForStudyPlan(studyPlanId);
    }

    @Override
    public CardinalTimeUnitResult findCardinalTimeUnitResult(int cardinalTimeUnitResultId) {
        return cardinaltimeunitResultMapper.findCardinalTimeUnitResult(cardinalTimeUnitResultId);
    }

    @Override
    public CardinalTimeUnitResult findCardinalTimeUnitResultByParams(
    		Map<String, Object> map) {
        return cardinaltimeunitResultMapper.findCardinalTimeUnitResultByParams(map);
        
    }

    @Override
    public StudyPlanResult findStudyPlanResultByParams(Map<String, Object> map) {
        return studyplanResultMapper.findStudyPlanResultByParams(map);
    }

    @Override
    public List <SubjectResult> findSubjectResultsForStudyPlanByParams(Map<String, Object> map) {
        return subjectResultMapper.findSubjectResultsForStudyPlanByParams(map);
    }

    @Override
    public List <ExaminationResult> findExaminationResultsForStudyPlanByParams(
    			Map<String, Object> map) {
        return examinationResultMapper.findExaminationResultsForStudyPlanByParams(map);
    }
    
    
    @Override
    public StudyPlanResult findStudyPlanResultByStudyPlanId(int studyPlanId) {
        return studyplanResultMapper.findStudyPlanResultByStudyPlanId(studyPlanId);
    }

    @Override
    public String generateExaminationResultMark(
            int studyPlanDetailId, int examinationId,
            String preferredLanguage, BindingResult result) {

        BigDecimal testWeighingFactor = BigDecimal.ZERO;
        String examinationResultMark = "";
        //int examinationResultMarkInt = 0;
        boolean markIsString = false;
        List < ? extends EndGrade > allEndGrades = null;
        Examination examination = null;
        Subject subject = null;
        Study study = null;
        String brsPassingExamination = "";
        BigDecimal brsPassingExaminationDec = null;
        String endGradeTypeCode = null;
        StudyPlanDetail studyPlanDetail = null;
        StudyPlan studyPlan = null;
        StudyGradeType studyGradeType = null;
        SubjectBlock subjectBlock = null;
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;

        // Only calculate examination result if total of weighing factors = 100 [%]
        int totalWeighingFactor = testManager.findTotalWeighingFactor(examinationId);
        if (totalWeighingFactor != 100) {
            result.rejectValue("mark", "jsp.error.percentagetotal");
            return null;
        }

        examination = examinationManager.findExamination(examinationId);
        subject = subjectManager.findSubject(examination.getSubjectId());
        study = studyManager.findStudy(subject.getPrimaryStudyId());

        studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
        studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
        studyPlan = studentManager.findStudyPlan(studyPlanDetail.getStudyPlanId());
        studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        if (studyPlanDetail.getSubjectBlockId() != 0) {
        	subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
        }
        
        if ("Y".equals(examination.getActive())) {

            // see if the endGrades are defined on studygradetype level
        	allEndGrades = findEndGrades(studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(), preferredLanguage);

            // minimum value to pass this subject:
            if (examination.getBRsPassingExamination() != null && !"".equals(examination.getBRsPassingExamination())) {
                brsPassingExamination = examination.getBRsPassingExamination();
            } else {
                brsPassingExamination = this.getBusinessRulesForPassingSubject(
                        subject, subjectBlock, studyPlan, allEndGrades, study, endGradeTypeCode);
                if (log.isDebugEnabled()) {
                    log.debug("ResultManager.generateExaminationResultMark: brsPassingExamination =" + brsPassingExamination);
                }
                if (brsPassingExamination == null) {
                    result.rejectValue("mark", "jsp.error.nobusinessrule.examination");
                }
            }
            // check if there are any field errors (using asterisk) at the current nesting path
            if (!result.hasFieldErrors("*")) {
                if (brsPassingExamination == null || "".equals(brsPassingExamination)) {
                    brsPassingExamination = "0.0";
                }
                if (StringUtil.checkValidInt(brsPassingExamination) == -1) {
                    if (StringUtil.checkValidDouble(brsPassingExamination) == -1) {
                        // mark is string, not number:
                        markIsString = true;
                        for (int j = 0; j < allEndGrades.size(); j++) {
                            if (StringUtil.lrtrim(brsPassingExamination).equals(allEndGrades.get(j).getCode())) {
                                brsPassingExaminationDec = allEndGrades.get(j).getGradePoint();
                            }
                        } 
                    } else {
                        brsPassingExaminationDec =  new BigDecimal(brsPassingExamination);
                    }
                } else {
                    int brsPassingExaminationInt = Integer.parseInt(brsPassingExamination);
                    brsPassingExaminationDec = new BigDecimal(brsPassingExaminationInt);
                }
            }

//            Map<String, Object> findTestResultsMap = new HashMap<>();
//            findTestResultsMap.put("examinationId", examinationId);
//            findTestResultsMap.put("studyPlanDetailId", studyPlanDetailId);
//            testResults = this.findActiveTestResultsForExaminationResult(findTestResultsMap);
//            if (log.isDebugEnabled()) {
//                log.debug("ResultManager.generateExaminationResultMark: testResults.size() = "+ testResults.size());
//            }
            
            // first test if all results for all examinations are there:
            ExaminationResultGenerator resGen = resultGeneratorFactory.resultGenerator(examination, studyPlanDetailId, appConfigManager.getMaxFailedTestResults(), preferredLanguage);
            resGen.validate(result);

            // check if there are any field errors (using asterisk) at the current nesting path;
            // when called by generateAll(), there might be other validation errors, but this should not 
            // prevent the current mark generation
            if (!result.hasFieldErrors("*")) {

                BigDecimal examinationResultMarkDec = BigDecimal.ZERO;
                BigDecimal maxTestMarkDec = BigDecimal.ZERO;
                boolean blInitValue = true;
                int saveTestId = 0;

                List<TestResult> testResults = resGen.getTestResults();
                for (int i = 0; i < testResults.size(); i++) {

                    if (testResults.get(i).getTestId() != saveTestId) {
                        // start calculating values:
                            if (!blInitValue) {
                                // calculate total examination result looping
                                examinationResultMarkDec = examinationResultMarkDec.add(
                                        (testWeighingFactor.divide(new BigDecimal(100))).multiply(maxTestMarkDec));
                                // reset value:
                                maxTestMarkDec = BigDecimal.ZERO;

                                if (!(brsPassingExaminationDec.compareTo(maxTestMarkDec) <= 0)) {
                                    if (log.isDebugEnabled()) {
                                        log.debug("ResultManager.generateExaminationResultMark - test failed: " + maxTestMarkDec);
                                    }
                                }
                            }
                            // reset examination values:
                            Test test = testManager.findTest(testResults.get(i).getTestId());
                            saveTestId = test.getId();
                            testWeighingFactor = new BigDecimal(test.getWeighingFactor());
                    }
                    // reset examinationResult values:
                    String testMark = testResults.get(i).getMark();
                    BigDecimal testMarkDec = BigDecimal.ZERO;

                    if (testMark == null || "".equals(testMark)) {
                        testMark = "0.0";
                    }
                    if (StringUtil.checkValidInt(testMark) == -1) {
                        if (StringUtil.checkValidDouble(testMark) == -1) {
                            // mark is string, not number:
                            markIsString = true;
                            for (int j = 0; j < allEndGrades.size(); j++) {
                                if (StringUtil.lrtrim(testMark).equals(allEndGrades.get(j).getCode())) {
                                    testMarkDec = allEndGrades.get(j).getGradePoint();
                                }
                            }
                        } else {
                            testMarkDec = new BigDecimal(testMark);
                        }
                    } else {
                        int testMarkInt = Integer.parseInt(testMark);
                        testMarkDec = new BigDecimal(testMarkInt);
                    }

                    // comparison necessary, only one result per test (highest):
                    if (testMarkDec.compareTo(maxTestMarkDec) > 0) {
                        maxTestMarkDec = testMarkDec;
                    }
                    blInitValue = false;
                }

                if (!result.hasFieldErrors("*")) {

                    // calculation after loop for last values:
                    examinationResultMarkDec = examinationResultMarkDec.add 
                            (testWeighingFactor.divide(new BigDecimal(100)).multiply(maxTestMarkDec));
                    if (!(brsPassingExaminationDec.compareTo(maxTestMarkDec) <= 0)) {
                        if (log.isDebugEnabled()) {
                            log.debug("ResultManager.generateExaminationResultMark - test failed: " + maxTestMarkDec);
                        }
                    }

                    // decide whether to present a number or a letter:
                    if (markIsString) {

                        // round the double -> int
                        // Use the rounded subject result: 10 (instead of 9.5), 11 (instead of 11.49)
                        // setScale() with 0 fractional digits rounds and is easier than the BigDecimal.round() mode
                        //   see: http://stackoverflow.com/a/4134135/606662 about BigInteger.setScale()
                        //examinationResultMarkInt = examinationResultMarkDec.setScale(0, RoundingMode.HALF_UP).intValue();

                        examinationResultMarkDec = examinationResultMarkDec.setScale(2, RoundingMode.HALF_UP);
                        if (examinationResultMarkDec.compareTo(BigDecimal.ZERO) != 0) {
                            for (int k = 0; k < allEndGrades.size(); k++) {
                                if (examinationResultMarkDec == allEndGrades.get(k).getGradePoint()) {
                                    examinationResultMark = allEndGrades.get(k).getCode();
                                }
                            }
                        } else {
                            examinationResultMark = examinationResultMarkDec.toPlainString();
                        }
                    } else {
                        // TODO change - No formatting of examination results so that we don't lose precision; the subject result will be scaled according to sysoption
//                        examinationResultMark = examinationResultMarkDec.toPlainString();
                    	examinationResultMark = examinationResultRounder.roundMark(examinationResultMarkDec).toPlainString();
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("ResultManager.generateExaminationResultMark: after calculations examinationResultMark = "+ examinationResultMark);
                    }
                }
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("ResultManager.generateExaminationResultMark: errorMsg = "+ result.getAllErrors());
                }
            }

            if (!result.hasFieldErrors("*")) {
                return examinationResultMark;
            } else {
                // return errormessage:
                return null;
            }
        } else {
            // subject is not active:
            result.rejectValue("mark", "jsp.error.subject.inactive");
            return null;
        }
   }

    @Override
    public SubjectResultGenerator generateSubjectResultMark(SubjectResult subjectResult,
            String preferredLanguage, BindingResult result) {

        int studyPlanDetailId = subjectResult.getStudyPlanDetailId();
        int subjectId = subjectResult.getSubjectId();

        // Only calculate subject result if total of weighing factors = 100 [%]
        int totalWeighingFactor = examinationManager.findTotalWeighingFactor(subjectId);
        if (totalWeighingFactor != 100) {
            result.rejectValue("mark", "jsp.error.percentagetotal");
            return null;
        }
        
        Subject subject = subjectManager.findSubject(subjectId);

        if (!"Y".equals(subject.getActive())) {
            result.rejectValue("mark", "jsp.error.subject.inactive");
            return null;
        }

        // first test if results for all examinations are there
        SubjectResultGenerator resGen = resultGeneratorFactory.resultGenerator(subject, studyPlanDetailId, preferredLanguage); 
        resGen.validate(result);

        // check if there are any field errors (using asterisk) at the current nesting path
        if (!result.hasFieldErrors("*")) {

            // calculate the subject result, start with zero value
            resGen.build();
            subjectResult.setMark(resGen.getGeneratedMark());
            subjectResult.setMarkDecimal(resGen.getGeneratedMarkDec());
            subjectResult.setSubjectResultCommentId(resGen.getAssessmentResultCommentId());
            return resGen;

        } else {
        	if (log.isDebugEnabled()) {
            	log.debug("ResultManager.generateSubjectResultMark: return errorMsg = " + result.getAllErrors());
            }
            return null;
        }
    }

    @Override
    public StudyPlanResult generateStudyPlanMark(
            StudyPlanResult studyPlanResult, 
            String preferredLanguage,
            Locale currentLoc, 
            String endGradeTypeCode, 
            int academicYearId, Errors errors) {

        List < ? extends EndGrade > allEndGrades = null;
        StudyPlan studyPlan = null;
        Study study = null;
        String brsPassingStudyplan = "";
        BigDecimal brsPassingSubjectDouble = BigDecimal.ZERO;
        String errorMsg = "";

        studyPlan = studentManager.findStudyPlan(studyPlanResult.getStudyPlanId());
        study = studyManager.findStudy(studyPlan.getStudyId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(studyPlan.getGradeTypeCode(), academicYearId, preferredLanguage);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.generateStudyPlanResultMark: endGrades for endGradeTypeCode " 
                    + studyPlan.getGradeTypeCode() + ", size = " + allEndGrades.size());
        }

        if (studyPlanResult.getMark() == null || "".equals(studyPlanResult.getMark()) 
                || "-".equals(studyPlanResult.getMark()) || "0.0".equals(studyPlanResult.getMark())) {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateStudyPlanResultMark: no forcedMark");
            }

            // find the minimum value to pass this exam (first look in studyplan, then higher):
            brsPassingStudyplan = this.getBusinessRulesForPassingStudyPlan(studyPlan, allEndGrades, study, endGradeTypeCode);
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateStudyPlanResultMark: brsPassingSubject =" 
                        + brsPassingStudyplan);
            }

            if (brsPassingStudyplan == null) {
                errorMsg = messageSource.getMessage(
                        "jsp.error.nobusinessrule.study", null, currentLoc);
            }
            if ("".equals(errorMsg)
                    && (studyPlanResult.getMark() == null 
                    || "".equals(studyPlanResult.getMark()) 
                    || "-".equals(studyPlanResult.getMark())
                    || "0.0".equals(studyPlanResult.getMark()))) {
                if (brsPassingStudyplan == null || "".equals(brsPassingStudyplan)) {
                    brsPassingStudyplan = "0.0";
                }
                if (StringUtil.checkValidDouble(brsPassingStudyplan) == -1) {
                    if (StringUtil.checkValidInt(brsPassingStudyplan) == -1) {
                        for (int j = 0; j < allEndGrades.size(); j++) {
                            if (StringUtil.lrtrim(brsPassingStudyplan).equals(allEndGrades.get(j).getCode())) {
                                brsPassingSubjectDouble = allEndGrades.get(j).getGradePoint();
                            }
                        }
                    } else {
                        brsPassingSubjectDouble = new BigDecimal(brsPassingStudyplan);
                    }
                } else {
                    brsPassingSubjectDouble = new BigDecimal(brsPassingStudyplan);
                }
            }

            // SPECIFIC CALCULATIONS: 
            // 1. calculate based on cardinaltimeunit results for Mozambique
            // 2. calculate based on last 2 senior years of subject results for UNZA, skipping the ones with more than 1 attempt
            // 3. calculate based on senior subject results (3rd and 4th year (and 5th year)) for CBU

            // call private method to do calculations for this studyplan:
            ResultsCalculations resultsCalculations = collegeServiceExtensions.getResultsCalculationsExtension();

            studyPlanResult = resultsCalculations.calculateResultsForStudyPlan(
                    study, studyPlanResult, brsPassingSubjectDouble, preferredLanguage, currentLoc, errors);
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateStudyPlanResultMark: mark calculated: " + studyPlanResult.getMark());
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateStudyPlanResultMark: return forcedMark");
            }
        }

        return studyPlanResult;
    }

    @Override
    public String isPassedStudyPlanResult(StudyPlanResult studyPlanResult, 
            String preferredLanguage, String endGradeTypeCode, int academicYearId) {

        StudyPlan studyPlan = null;
        String brsPassingExam = "";
        BigDecimal brsPassingExamDouble = BigDecimal.ZERO;
        Study study = null;
        BigDecimal examMarkDouble = BigDecimal.ZERO;
        List < ? extends EndGrade > allEndGrades = null;
        String examMark = studyPlanResult.getMark();

        studyPlan = studentManager.findStudyPlan(studyPlanResult.getStudyPlanId());
        study = studyManager.findStudy(studyPlan.getStudyId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(endGradeTypeCode, academicYearId, preferredLanguage);

        // find the minimum value to pass this exam (first look in studyplan, then higher):
        brsPassingExam = this.getBusinessRulesForPassingStudyPlan(
                studyPlan, allEndGrades, study, endGradeTypeCode);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.isPassedStudyPlanResult: endGrades for endGradeTypeCode " + endGradeTypeCode 
                    + ", size = " + allEndGrades.size() 
                    + ", brsPassingExam =" + brsPassingExam);
        }

        if (brsPassingExam == null || "".equals(brsPassingExam)) {
            return "N";
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.isPassedStudyPlanResult: examMark = " + examMark);
            }
            if (examMark == null || "".equals(examMark)) {
                examMark = "0.0";
            } 
            if (StringUtil.checkValidInt(examMark) == -1) {
                if (StringUtil.checkValidDouble(examMark) == -1) {
                    // mark is string, not number:
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(examMark).equals(allEndGrades.get(j).getCode())) {
                            examMarkDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    examMarkDouble = new BigDecimal(examMark); 
                }
            } else {
                int examMarkInt = Integer.parseInt(examMark);
                examMarkDouble = new BigDecimal(examMarkInt);
            }

            if (brsPassingExam == null || "".equals(brsPassingExam)) {
                brsPassingExam = "0.0";
            }
            if (StringUtil.checkValidInt(brsPassingExam) == -1) {
                if (StringUtil.checkValidDouble(brsPassingExam) == -1) {
                    // mark is string, not number:
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(brsPassingExam).equals(allEndGrades.get(j).getCode())) {
                            brsPassingExamDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    brsPassingExamDouble = new BigDecimal(brsPassingExam);
                }
            } else {
                int brsPassingExamInt = Integer.parseInt(brsPassingExam);
                brsPassingExamDouble = new BigDecimal(brsPassingExamInt);
            }

            // comparison necessary, only one result per examination (highest):
            if (brsPassingExamDouble.compareTo(examMarkDouble) <= 0) {
                return "Y";
            } else {
                return "N";
            }
        }
    }

    @Override
    public String isPassedThesisResult(int studyPlanId, 
            ThesisResult thesisResult, 
            String preferredLanguage, String endGradeTypeCode, int academicYearId) {

        StudyPlan studyPlan = null;
        String brsPassingThesis = "";
        BigDecimal brsPassingThesisDouble = BigDecimal.ZERO;
        Study study = null;
        BigDecimal thesisMarkDouble = BigDecimal.ZERO;
        List < ? extends EndGrade > allEndGrades = null;
        String thesisMark = thesisResult.getMark();

        studyPlan = studentManager.findStudyPlan(studyPlanId);
        study = studyManager.findStudy(studyPlan.getStudyId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(endGradeTypeCode, academicYearId, preferredLanguage);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.isPassedThesisResult: endGrades for endGradeTypeCode " + endGradeTypeCode 
                    + ", size = " + allEndGrades.size());
        }
        // find the minimum value to pass this exam (first look in studyplan, then higher):
        brsPassingThesis = this.getBusinessRulesForPassingStudyPlan(
                studyPlan, allEndGrades, study, endGradeTypeCode);

        if (brsPassingThesis == null || "".equals(brsPassingThesis)) {
            return "N";
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.isPassedThesisResult: thesisMark = " + thesisMark);
            }
            if (thesisMark == null || "".equals(thesisMark)) {
                thesisMark = "0.0";
            }
            if (StringUtil.checkValidInt(thesisMark) == -1) {
                if (StringUtil.checkValidDouble(thesisMark) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(thesisMark).equals(allEndGrades.get(j).getCode())) {
                            thesisMarkDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    thesisMarkDouble = new BigDecimal(thesisMark); 
                }
            } else {
                int thesisMarkInt = Integer.parseInt(thesisMark);
                thesisMarkDouble = new BigDecimal(thesisMarkInt);
            }
            if (brsPassingThesis == null || "".equals(brsPassingThesis)) {
                brsPassingThesis = "0.0";
            }
            if (StringUtil.checkValidInt(brsPassingThesis) == -1) {
                if (StringUtil.checkValidDouble(brsPassingThesis) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(brsPassingThesis).equals(allEndGrades.get(j).getCode())) {
                            brsPassingThesisDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    brsPassingThesisDouble = new BigDecimal(brsPassingThesis);
                }
            } else {
                int brsPassingThesisInt = Integer.parseInt(brsPassingThesis);
                brsPassingThesisDouble = new BigDecimal(brsPassingThesisInt);
            }

            // comparison necessary, only one result per examination (highest):
            if (brsPassingThesisDouble.compareTo(thesisMarkDouble) <= 0) {
                return "Y";
            } else {
                return "N";
            }
        }
    }

    @Override
    public void generateCardinalTimeUnitMark(
            CardinalTimeUnitResult cardinalTimeUnitResult, 
            String preferredLanguage, Locale currentLoc, Errors errors) {

        List < SubjectResult > subjectResults = null;
        List < Subject > allSubjectsForStudyPlanCardinalTimeUnit = null;
        List < StudyPlanDetail > allStudyPlanDetailsForStudyPlanCardinalTimeUnit = null;
        StudyPlan studyPlan = null;
        StudyGradeType studyGradeType = null;
        Study study = null;
        String brsPassingSubject = "";
        BigDecimal brsPassingSubjectDouble = BigDecimal.ZERO;
        String minimumMarkStudyPlan = "";
        String maximumMarkStudyPlan = "";
        String mark = null;
        List < ? extends EndGrade > allEndGrades = null;
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;

        studyPlan = studentManager.findStudyPlan(cardinalTimeUnitResult.getStudyPlanId());
        study = studyManager.findStudy(studyPlan.getStudyId());
        studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(
                cardinalTimeUnitResult.getStudyPlanCardinalTimeUnitId());
        studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(), preferredLanguage);

        if (log.isDebugEnabled()) {
            log.debug("ResultManager.generateCardinalTimeUnitResult: empty mark, endgrades = " + allEndGrades.size()
                    + ", gradetypecode = " + studyPlan.getGradeTypeCode());
        }
        // first check min / max mark boundaries for calculation values
        minimumMarkStudyPlan = this.getMinimumMarkForStudyPlan(
                allEndGrades, study, studyPlan.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId());
        maximumMarkStudyPlan = this.getMaximumMarkForStudyPlan(
                allEndGrades, study, studyPlan.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId());

        if (minimumMarkStudyPlan == null) {
            errors.rejectValue("mark", "jsp.error.nominimummark.study");
            return;
        }
        if (minimumMarkStudyPlan == null || "".equals(minimumMarkStudyPlan)) {
            minimumMarkStudyPlan = "0.0";
        }
        if (maximumMarkStudyPlan == null) {
            errors.rejectValue("mark", "jsp.error.nomaximummark.study");
            return;
        }
        if (maximumMarkStudyPlan == null || "".equals(maximumMarkStudyPlan)) {
            maximumMarkStudyPlan = "0.0";
        }

        if (log.isDebugEnabled()) {
            log.debug("ResultManager.generateCardinalTimeUnitResult: before getBusinessRulesForPassingStudyPlan: allEndGrades.size() = "+ allEndGrades.size());
        }
        // find the minimum value to pass this exam (first look in studyplan, then higher):
        brsPassingSubject = this.getBusinessRulesForPassingStudyGradeType(
                study, studyGradeType, allEndGrades);

        if (brsPassingSubject == null) {
            errors.rejectValue("mark", "jsp.error.nobusinessrule.cardinaltimeunit");
            return;
        }
        if (brsPassingSubject == null || "".equals(brsPassingSubject)) {
            brsPassingSubject = "0.0";
        }
        if (StringUtil.checkValidInt(brsPassingSubject) == -1) {
            if (StringUtil.checkValidDouble(maximumMarkStudyPlan) == -1) {
                // mark is string, not number:
                if (log.isDebugEnabled()) {
                    log.debug("ResultManager.generateCardinalTimeUnitResult: brsPassingSubject is string:"
                            + brsPassingSubject);
                }
                for (int j = 0; j < allEndGrades.size(); j++) {
                    if (StringUtil.lrtrim(brsPassingSubject).equals(allEndGrades.get(j).getCode())) {
                        brsPassingSubjectDouble = allEndGrades.get(j).getGradePoint();
                    }
                }
            } else {
                brsPassingSubjectDouble = new BigDecimal(brsPassingSubject);
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateCardinalTimeUnitResult: brsPassingSubject is double:"
                        + brsPassingSubject);
            }
            int brsPassingSubjectInt = Integer.parseInt(brsPassingSubject);
            brsPassingSubjectDouble = new BigDecimal(brsPassingSubjectInt);
        }

        Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyPlanId", studyPlan.getId());
        ctuMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
        ctuMap.put("studyPlanCardinalTimeUnitId",studyPlanCardinalTimeUnit.getId());
        ctuMap.put("studyGradeTypeId", studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        ctuMap.put("active", "Y");

        allSubjectsForStudyPlanCardinalTimeUnit = studentManager.findActiveSubjectsForStudyPlanCardinalTimeUnit(ctuMap);

        allStudyPlanDetailsForStudyPlanCardinalTimeUnit = 
                studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(ctuMap);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.generateCardinalTimeUnitResult: allSubjectsForStudyPlanCardinalTimeUnit.size() = " 
                    + allSubjectsForStudyPlanCardinalTimeUnit.size() + ", allStudyPlanDetailsForStudyPlanCardinalTimeUnit.size() = "
                    + allStudyPlanDetailsForStudyPlanCardinalTimeUnit.size());
        }

        // add the (virtual) blocked subjects from the previous 
        // studyplancardinaltimeunit too, in case one or more have to be repeated:
        if (studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() > 1) {
            Map<String, Object> findBlockedMap = new HashMap<>();
            findBlockedMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_DEFAULT);
            findBlockedMap.put("preferredLanguage", preferredLanguage);
            findBlockedMap.put("studyId", 0);
            findBlockedMap.put("active", "");
            findBlockedMap.put("gradeTypeCode", null);
            findBlockedMap.put("rigidityTypeCode", null);
            findBlockedMap.put("studyGradeTypeId", 
                    studyPlanCardinalTimeUnit.getStudyGradeTypeId());
            findBlockedMap.put("cardinalTimeUnitNumber", 
                    (studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() - 1));
            List < Subject > allBlockedSubjects = subjectManager.findBlockedSubjects(findBlockedMap); 
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateCardinalTimeUnitResult: allBlockedSubjects.size() = " + allBlockedSubjects.size());
            }

            // clean up allBlockedSubjects by checking them with the studyplandetails:
            List < Subject > usedBlockedSubjects = new ArrayList<>();
            for (int j = 0; j < allBlockedSubjects.size(); j++) {
                for (int k = 0; k < allStudyPlanDetailsForStudyPlanCardinalTimeUnit.size(); k++) {
                    if (allBlockedSubjects.get(j).getId()== allStudyPlanDetailsForStudyPlanCardinalTimeUnit.get(k).getSubjectId()) {
                        usedBlockedSubjects.add(allBlockedSubjects.get(j));
                    }
                }
            }
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateCardinalTimeUnitResult: usedBlockedSubjects.size() = " + usedBlockedSubjects.size());
            }

            allSubjectsForStudyPlanCardinalTimeUnit.addAll(usedBlockedSubjects);
        }

        if (allSubjectsForStudyPlanCardinalTimeUnit != null 
                && allSubjectsForStudyPlanCardinalTimeUnit.size() != 0 
                && allStudyPlanDetailsForStudyPlanCardinalTimeUnit != null 
                && allStudyPlanDetailsForStudyPlanCardinalTimeUnit.size() != 0) {

            subjectResults = this.findCalculatableSubjectResultsForCardinalTimeUnit(
                    allStudyPlanDetailsForStudyPlanCardinalTimeUnit, ctuMap);
            //subjectResults = this.findActiveSubjectResultsForCardinalTimeUnit(ctuMap);

            // check: maxNumberOfFailedSubjects (also include non-taken subjects as failed subjects)
            if ((allSubjectsForStudyPlanCardinalTimeUnit.size() - subjectResults.size())
                    > studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit()) {
                String[] errorArgs = new String[1];
                errorArgs[0] = Integer.toString(studyPlanCardinalTimeUnit.getId());
                //            		errorMsg = errorMsg + messageSource.getMessage("jsp.error.notallsubjectresults.ctu", errorArgs, currentLoc);
                errors.rejectValue("mark", "jsp.error.notallsubjectresults.ctu", errorArgs, null);
                return;
            } else {
                int countFailedSubjects = 0;
                for (int i=0;i < subjectResults.size();i++) {
                    if ("N".equals(subjectResults.get(i).getPassed())) {
                        countFailedSubjects ++;
                    }
                }
                if (countFailedSubjects > studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit()) {
                    String[] errorArgs = new String[1];
                    errorArgs[0] = Integer.toString(studyPlanCardinalTimeUnit.getId());
                    errors.rejectValue("mark", "jsp.error.toomany.failedsubjectresults.ctu", errorArgs, null);
                    return;
                }
            }
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.generateCardinalTimeUnitResult: calculatable subjectResults.size() " 
                        + subjectResults.size() + ", studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit() = " 
                        + studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit());
            }
        }


        mark = calculateSubjectResultsForCardinalTimeUnit(study, 
                cardinalTimeUnitResult, subjectResults, 
                allSubjectsForStudyPlanCardinalTimeUnit, brsPassingSubjectDouble, 
                preferredLanguage, currentLoc, errors);

        if (log.isDebugEnabled()) {
            log.debug("ResultManager.generateCardinalTimeUnitResult: after calculation endGrade :" + mark);
        }

        cardinalTimeUnitResult.setMark(mark);   // mark is null in case of error
    }

    @Override
    public String isPassedCardinalTimeUnitResult(int studyPlanCardinalTimeUnitId,
            CardinalTimeUnitResult cardinalTimeUnitResult, 
            String preferredLanguage,  String endGradeTypeCode) {

        StudyPlan studyPlan = null;
        String brsPassingCTU = "";
        BigDecimal brsPassingCTUDouble = BigDecimal.ZERO;
        Study study = null;
        BigDecimal ctuMarkDouble = BigDecimal.ZERO;
        List < ? extends EndGrade > allEndGrades = null;
        String ctuMark = cardinalTimeUnitResult.getMark();
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;

        studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
        studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
        study = studyManager.findStudy(studyPlan.getStudyId());
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(endGradeTypeCode, studyGradeType.getCurrentAcademicYearId(), preferredLanguage);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.isPassedCardinalTimeUnitResult: endGrades for endGradeTypeCode " + endGradeTypeCode 
                    + ", size = " + allEndGrades.size());
        }
        // find the minimum value to pass this exam (first look in studyplan, then higher):
        brsPassingCTU = this.getBusinessRulesForPassingStudyPlan(
                studyPlan, allEndGrades, study, endGradeTypeCode);

        if (brsPassingCTU == null || "".equals(brsPassingCTU)) {
            return "N";
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.isPassedCTUResult: ctuMark = " + ctuMark);
            }
            if (ctuMark == null || "".equals(ctuMark)) {
                ctuMark = "0.0";
            }
            if (StringUtil.checkValidInt(ctuMark) == -1) {
                if (StringUtil.checkValidDouble(ctuMark) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(ctuMark).equals(allEndGrades.get(j).getCode())) {
                            ctuMarkDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    ctuMarkDouble = new BigDecimal(ctuMark); 
                }
            } else {
                int ctuMarkInt = Integer.parseInt(ctuMark);
                ctuMarkDouble = new BigDecimal(ctuMarkInt);
            }
            if (brsPassingCTU == null || "".equals(brsPassingCTU)) {
                brsPassingCTU = "0.0";
            }
            if (StringUtil.checkValidInt(brsPassingCTU) == -1) {
                if (StringUtil.checkValidDouble(brsPassingCTU) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(brsPassingCTU).equals(allEndGrades.get(j).getCode())) {
                            brsPassingCTUDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    brsPassingCTUDouble = new BigDecimal(brsPassingCTU);
                }
            } else {
                int brsPassingCTUInt = Integer.parseInt(brsPassingCTU);
                brsPassingCTUDouble = new BigDecimal(brsPassingCTUInt);
            }

            // comparison necessary, only one result per ctu (highest):
            if (brsPassingCTUDouble.compareTo(ctuMarkDouble) <= 0) {
                return "Y";
            } else {
                return "N";
            }
        }
    }

    @Override
    public String isPassedResult(IResult result, String resultMark, String preferredLanguage) {

        // TODO think of something better to avoid if/else chain

        if (result instanceof SubjectResult) {
            SubjectResult subjectResult = (SubjectResult) result;
            return isPassedSubjectResult(subjectResult, resultMark, preferredLanguage, ((SubjectResult) result).getEndGradeTypeCode(), null);
        } else if (result instanceof ExaminationResult) {
            return isPassedExaminationResult((ExaminationResult) result, resultMark, preferredLanguage);
        } else  if (result instanceof TestResult) {
            return isPassedTestResult((TestResult) result, resultMark, preferredLanguage);
        } else {
            throw new RuntimeException("Invalid type of result: " + result);
        }
    }

    @Override
    public String isPassedSubjectResult(SubjectResult subjectResult, String subjectResultMark, String preferredLanguage, String endGradeTypeCode, SubjectResultGenerator subjectResultGenerator) {
    	
    	// If preconditions already dictate a (negative) passed flag, then don't look any further
        // NB: subjectResultGenerator is only available if result was generated previously
    	if (subjectResultGenerator != null && subjectResultGenerator.isGeneratedPassed() != null) {
    		return subjectResultGenerator.isGeneratedPassed() ? "Y" : "N";
    	}

        Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());
        StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(subjectResult.getStudyPlanDetailId());
        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanDetail.getStudyPlanId());
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
        Study study = studyManager.findStudy(studyGradeType.getStudyId());
        SubjectBlock subjectBlock = null;
        if (studyPlanDetail.getSubjectBlockId() != 0) {
            subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
        }

        // see if the endGrades are defined on studygradetype level
		List<EndGrade> allEndGrades = findEndGrades(endGradeTypeCode, subject.getCurrentAcademicYearId(), preferredLanguage);
        
        // find the minimum value to pass this subject (first look in subject, then higher):
        String brsPassingSubjectResult = this.getBusinessRulesForPassingSubject(subject, subjectBlock, studyPlan, allEndGrades, study, endGradeTypeCode);

        if (brsPassingSubjectResult == null || "".equals(brsPassingSubjectResult)) {
            return "N";
        } else {

        	BigDecimal subjectResultMarkDouble = resultUtil.toDecimalMark(subjectResultMark, allEndGrades);
			BigDecimal brsPassingSubjectResultDouble = resultUtil.toDecimalMark(brsPassingSubjectResult, allEndGrades);

            // comparison necessary, only one result per examination (highest):
            if (subjectResultMarkDouble != null && subjectResultMarkDouble.compareTo(brsPassingSubjectResultDouble) >= 0) {
                return "Y";
            } else {
                return "N";
            }
        }
    }

	private List<EndGrade> findEndGrades(String endGradeTypeCode, int currentAcademicYearId, String preferredLanguage) {
		boolean endGradesPerGradeType = studyManager.useEndGrades(currentAcademicYearId);

        // lookup values for endGrades (used for conversion letters to numbers and vice versa)
        Map<String, Object> endGradeMap = new HashMap<>();
        endGradeMap.put("preferredLanguage", preferredLanguage);
        if (endGradesPerGradeType) {
            endGradeMap.put("endGradeTypeCode", endGradeTypeCode);
        }
        endGradeMap.put("academicYearId", currentAcademicYearId);
        List<EndGrade> allEndGrades = studyManager.findAllEndGrades(endGradeMap);
		return allEndGrades;
	}

    @Override
    public String isPassedExaminationResult(ExaminationResult examinationResult, String examinationResultMark,
            String preferredLanguage) {

        String brsPassingExaminationResult = "";
        BigDecimal brsPassingExaminationResultDouble = BigDecimal.ZERO;
        Examination examination = null;
        Subject subject = null;
        StudyPlanDetail studyPlanDetail = null;
        StudyPlan studyPlan = null;
        StudyGradeType studyGradeType = null;
        Study study = null;
        BigDecimal examinationResultMarkDec = BigDecimal.ZERO;
        List<? extends EndGrade> allEndGrades = null;
        String endGradeTypeCode = examinationResult.getEndGradeTypeCode(); // TODO check if this is correctly read from DB via ResultMap
                                                                           // (like for subjectResult)
        SubjectBlock subjectBlock = null;

        examination = examinationManager.findExamination(examinationResult.getExaminationId());
        subject = subjectManager.findSubject(examinationResult.getSubjectId());
        studyPlanDetail = studentManager.findStudyPlanDetail(examinationResult.getStudyPlanDetailId());
        studyPlan = studentManager.findStudyPlan(studyPlanDetail.getStudyPlanId());
        studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
        study = studyManager.findStudy(studyGradeType.getStudyId());
        if (studyPlanDetail.getSubjectBlockId() != 0) {
            subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
        }

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(endGradeTypeCode, studyGradeType.getCurrentAcademicYearId(), preferredLanguage);

        // find the minimum value to pass this exam (first look in examination,
        // then in subject, then in studyplan, then in study):
        if (examination.getBRsPassingExamination() != null & !"".equals(examination.getBRsPassingExamination())) {
            brsPassingExaminationResult = examination.getBRsPassingExamination();
        } else {
            brsPassingExaminationResult = this.getBusinessRulesForPassingSubject(subject, subjectBlock, studyPlan, allEndGrades, study,
                    endGradeTypeCode);
        }
        if (brsPassingExaminationResult == null || "".equals(brsPassingExaminationResult)) {
            return "N";
        } else {
            if (examinationResultMark == null || "".equals(examinationResultMark)) {
                examinationResultMark = "0.0";
            }
            if (StringUtil.checkValidInt(examinationResultMark) == -1) {
                if (StringUtil.checkValidDouble(examinationResultMark) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(examinationResultMark).equals(allEndGrades.get(j).getCode())) {
                            examinationResultMarkDec = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    examinationResultMarkDec = new BigDecimal(examinationResultMark);
                }
            } else {
                int examinationResultMarkInt = Integer.parseInt(examinationResultMark);
                examinationResultMarkDec = new BigDecimal(examinationResultMarkInt);
            }

            if (brsPassingExaminationResult == null || "".equals(brsPassingExaminationResult)) {
                brsPassingExaminationResult = "0.0";
            }
            if (StringUtil.checkValidInt(brsPassingExaminationResult) == -1) {
                if (StringUtil.checkValidDouble(brsPassingExaminationResult) == -1) {
                    for (int j = 0; j < allEndGrades.size(); j++) {
                        if (StringUtil.lrtrim(brsPassingExaminationResult).equals(allEndGrades.get(j).getCode())) {
                            brsPassingExaminationResultDouble = allEndGrades.get(j).getGradePoint();
                        }
                    }
                } else {
                    brsPassingExaminationResultDouble = new BigDecimal(brsPassingExaminationResult);
                }
            } else {
                int brsPassingExaminationResultInt = Integer.parseInt(brsPassingExaminationResult);
                brsPassingExaminationResultDouble = new BigDecimal(brsPassingExaminationResultInt);
            }

            // comparison necessary, only one result per examination (highest):
            if (brsPassingExaminationResultDouble.compareTo(examinationResultMarkDec) <= 0) {
                return "Y";
            } else {
                return "N";
            }
        }
    }

    @Override
    public String isPassedTestResult(TestResult testResult, 
            String testResultMark, String preferredLanguage) {

       String brsPassingTestResult = "";
       BigDecimal brsPassingTestResultDouble = BigDecimal.ZERO;
       Test test = null;
       Examination examination = null;
       Subject subject = null;
       StudyPlanDetail studyPlanDetail = null;
       StudyPlan studyPlan = null;
       StudyGradeType studyGradeType = null;
       Study study = null;
       BigDecimal testResultMarkDouble = BigDecimal.ZERO;
       List < ? extends EndGrade > allEndGrades = null;
       String endGradeTypeCode = null;
       SubjectBlock subjectBlock = null;

       test = testManager.findTest(testResult.getTestId());
       examination = examinationManager.findExamination(testResult.getExaminationId());
       subject = subjectManager.findSubject(examination.getSubjectId());
       studyPlanDetail = studentManager.findStudyPlanDetail(testResult.getStudyPlanDetailId());
       studyPlan = studentManager.findStudyPlan(studyPlanDetail.getStudyPlanId());
       studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
       study = studyManager.findStudy(studyGradeType.getStudyId());
       if (studyPlanDetail.getSubjectBlockId() != 0) {
    	   subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
       }
       
       // see if the endGrades are defined on studygradetype level
       allEndGrades = findEndGrades(endGradeTypeCode, studyGradeType.getCurrentAcademicYearId(), preferredLanguage);
    
       // find the minimum value to pass this test (first look in test, hierarchically up):
       brsPassingTestResult = this.getBusinessRulesForPassingTest(
               		test, examination, subject, subjectBlock, studyPlan, allEndGrades, 
               		study, endGradeTypeCode);
    
       if (brsPassingTestResult == null || "".equals(brsPassingTestResult)) {
           return "N";
       } else {
    	   if (testResultMark == null || "".equals(testResultMark)) {
    		   testResultMark = "0.0";
	       }
           if (StringUtil.checkValidInt(testResultMark) == -1) {
               if (StringUtil.checkValidDouble(testResultMark) == -1) {
                   for (int j = 0; j < allEndGrades.size(); j++) {
                       if (StringUtil.lrtrim(testResultMark).equals(allEndGrades.get(j).getCode())) {
                    	   testResultMarkDouble = allEndGrades.get(j).getGradePoint();
                       }
                   }
               } else {
                   testResultMarkDouble = new BigDecimal(testResultMark);
               }
           } else {
               int testResultMarkInt = Integer.parseInt(testResultMark);
               testResultMarkDouble = new BigDecimal(testResultMarkInt);
           }

           if (brsPassingTestResult == null || "".equals(brsPassingTestResult)) {
        	   brsPassingTestResult = "0.0";
	       }
           if (StringUtil.checkValidInt(brsPassingTestResult) == -1) {
               if (StringUtil.checkValidDouble(brsPassingTestResult) == -1) {
                   for (int j = 0; j < allEndGrades.size(); j++) {
                       if (StringUtil.lrtrim(brsPassingTestResult).equals(allEndGrades.get(j).getCode())) {
                    	   brsPassingTestResultDouble = allEndGrades.get(j).getGradePoint();
                       }
                   }
               } else {
                   brsPassingTestResultDouble = new BigDecimal(brsPassingTestResult);
               }
           } else {
               int brsPassingTestResultInt = Integer.parseInt(brsPassingTestResult);
               brsPassingTestResultDouble = new BigDecimal(brsPassingTestResultInt);
           }

           // comparison necessary, only one result per examination (highest):
           if (brsPassingTestResultDouble.compareTo(testResultMarkDouble) <= 0) {
               return "Y";
           } else {
               return "N";
           }
       }
    }

    @Override
    public List<SubjectResult> findSubjectResultsForStudyPlan(int studyPlanId) {

        return subjectResultMapper.findSubjectResultsForStudyPlan(studyPlanId);
    }

    @Override
    public StudyPlanCardinalTimeUnit findCalculatableStudyPlanCardinalTimeUnit(
    			Map<String, Object> map) {
	  	
	  	StudyPlanCardinalTimeUnit maxStudyPlanCardinalTimeUnit = null;
  		List < StudyPlanCardinalTimeUnit > allStudyPlanCardinalTimeUnits = null;
    	List <AcademicYear> allAcademicYears = null;
    	Date maxEndDate = new Date();
  		StudyGradeType studyGradeType = null;
  		DateUtil dtc = new DateUtil();

  	     // init settings:
		maxStudyPlanCardinalTimeUnit = null;
		maxEndDate = dtc.parseSimpleDate("1950-01-01", "yyyy-MM-dd");

  		allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(map);
  		
		Map<String, Object> findAcademicYearsMap = new HashMap<>();
		findAcademicYearsMap.put("institutionTypeCode", 
      		OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
		findAcademicYearsMap.put("studyId", 0);
     	findAcademicYearsMap.put("studyPlanId", map.get("studyPlanId"));
     	allAcademicYears = this.findAcademicYearsInStudyPlan(findAcademicYearsMap);
     	
		for (int j = 0; j < allStudyPlanCardinalTimeUnits.size(); j++) {
			studyGradeType = studyManager.findStudyGradeType(allStudyPlanCardinalTimeUnits.get(j).getStudyGradeTypeId());
			for (int x = 0; x < allAcademicYears.size(); x++) {
				/* loop through the academic years to find and save the most recent 
				 * studyplan cardinal time unit */
				if (studyGradeType.getCurrentAcademicYearId() 
						== allAcademicYears.get(x).getId()) {
					if (log.isDebugEnabled()) {
						log.debug("ResultManager.findCalculatableStudyPlanCardinalTimeUnit: "
								+ "academic year found for studyplan cardinal time unit " + allStudyPlanCardinalTimeUnits.get(j).getId() 
								+ ":" + allAcademicYears.get(x).getId());
					}
					if (allAcademicYears.get(x).getEndDate().after(maxEndDate)) {
    					if (log.isDebugEnabled()) {
    						log.debug("ResultManager.findCalculatableStudyPlanCardinalTimeUnit: "
    								+ "new max end date found for studyplan cardinal time unit " + allStudyPlanCardinalTimeUnits.get(j).getId() 
    								+ ":" + allAcademicYears.get(x).getEndDate());
    					}
						maxEndDate = allAcademicYears.get(x).getEndDate();
						maxStudyPlanCardinalTimeUnit = allStudyPlanCardinalTimeUnits.get(j);
					}
				}
			}			
		}
     	return maxStudyPlanCardinalTimeUnit;
  }
    
    
    @Override
    public StudyPlanCardinalTimeUnit findMaxCalculatableStudyPlanCardinalTimeUnit(int studyPlanId) {
	  	
	  	StudyPlanCardinalTimeUnit maxStudyPlanCardinalTimeUnit = null;
  		List < StudyPlanCardinalTimeUnit > allStudyPlanCardinalTimeUnits = null;
    	List <AcademicYear> allAcademicYears = null;
    	Date maxEndDate = new Date();
  		StudyGradeType studyGradeType = null;
  		DateUtil dtc = new DateUtil();
  		int maxCtuNumber = 0;
  		
  	     // init settings:
		maxStudyPlanCardinalTimeUnit = null;
		maxEndDate = dtc.parseSimpleDate("1950-01-01", "yyyy-MM-dd");
		
		maxCtuNumber = (Integer) studentManager.findMaxCardinalTimeUnitNumberForStudyPlan(studyPlanId);
		
		Map<String, Object> ctuMap = new HashMap<>();
		ctuMap.put("studyPlanId", studyPlanId);
    	ctuMap.put("cardinalTimeUnitNumber", maxCtuNumber);
  		allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(ctuMap);
  		
		Map<String, Object> findAcademicYearsMap = new HashMap<>();
		findAcademicYearsMap.put("institutionTypeCode", 
      		OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
		findAcademicYearsMap.put("studyId", 0);
     	findAcademicYearsMap.put("studyPlanId", studyPlanId);
     	allAcademicYears = this.findAcademicYearsInStudyPlan(findAcademicYearsMap);
     	
		for (int j = 0; j < allStudyPlanCardinalTimeUnits.size(); j++) {
			studyGradeType = studyManager.findStudyGradeType(allStudyPlanCardinalTimeUnits.get(j).getStudyGradeTypeId());
			for (int x = 0; x < allAcademicYears.size(); x++) {
				/* loop through the academic years to find and save the most recent 
				 * studyplan cardinal time unit */
				if (studyGradeType.getCurrentAcademicYearId() 
						== allAcademicYears.get(x).getId()) {
					if (log.isDebugEnabled()) {
						log.debug("ResultManager.findMaxCalculatableStudyPlanCardinalTimeUnit: "
								+ "academic year found for studyplan cardinal time unit " + allStudyPlanCardinalTimeUnits.get(j).getId() 
								+ ":" + allAcademicYears.get(x).getId());
					}
					if (allAcademicYears.get(x).getEndDate().after(maxEndDate)) {
    					if (log.isDebugEnabled()) {
    						log.debug("ResultManager.findMaxCalculatableStudyPlanCardinalTimeUnit: "
    								+ "new max end date found for studyplan cardinal time unit " + allStudyPlanCardinalTimeUnits.get(j).getId() 
    								+ ":" + allAcademicYears.get(x).getEndDate());
    					}
						maxEndDate = allAcademicYears.get(x).getEndDate();
						maxStudyPlanCardinalTimeUnit = allStudyPlanCardinalTimeUnits.get(j);
					}
				}
			}			
		}
     	return maxStudyPlanCardinalTimeUnit;
    }

    @Override
    public List<SubjectResult> findActiveSubjectResultsForCardinalTimeUnit(Map<String, Object> map) {
    	
    	List < SubjectResult > allActiveSubjectResultsForCardinalTimeUnit = null;
        allActiveSubjectResultsForCardinalTimeUnit = subjectResultMapper.findActiveSubjectResultsForCardinalTimeUnit(map);
			
    	return allActiveSubjectResultsForCardinalTimeUnit;
    }

    
    @Override
    public List<SubjectResult> findSubjectResultsForSubjectBlock(int subjectBlockId) {

        return subjectResultMapper.findSubjectResultsForSubjectBlock(subjectBlockId);
    }

    @Override
    public List<ExaminationResult> findExaminationResultsForSubjectBlock(int subjectBlockId) {
        return examinationResultMapper.findExaminationResultsForSubjectBlock(subjectBlockId);
    }


    @Override
    public List<SubjectResult> findSubjectResultsForSubjectSubjectBlock(int subjectSubjectBlockId) {

        return subjectResultMapper.findSubjectResultsForSubjectSubjectBlock(subjectSubjectBlockId);
    }

    @Override
    public List<ExaminationResult> findExaminationResultsForSubjectSubjectBlock(int subjectSubjectBlockId) {
        return examinationResultMapper.findExaminationResultsForSubjectSubjectBlock(subjectSubjectBlockId);
    }

    @Override
    public List<SubjectResult> findSubjectResultsForSubjectBlockSubjectBlock(int subjectBlockSubjectBlockId) {

        return subjectResultMapper.findSubjectResultsForSubjectBlockSubjectBlock(subjectBlockSubjectBlockId);
    }

    @Override
    public List<ExaminationResult> findExaminationResultsForSubjectBlockSubjectBlock(int subjectBlockSubjectBlockId) {
        return examinationResultMapper.findExaminationResultsForSubjectBlockSubjectBlock(subjectBlockSubjectBlockId);
    }

    @Override
    public void addStudyPlanResult(StudyPlanResult studyPlanResult, String writeWho) {

        studyPlanResult.setWriteWho(writeWho);

        studyplanResultMapper.addStudyPlanResult(studyPlanResult);
        studyplanResultMapper.addStudyPlanResultHistory(studyPlanResult);
    }

    @Override
    public void updateStudyPlanResult(StudyPlanResult studyPlanResult, String writeWho) {

        studyPlanResult.setWriteWho(writeWho);
        studyplanResultMapper.updateStudyPlanResult(studyPlanResult);
        studyplanResultMapper.updateStudyPlanResultHistory(studyPlanResult);
    }

    @Override
    public void deleteStudyPlanResult(int studyPlanResultId, String writeWho) {

        StudyPlanResult studyPlanResult = findStudyPlanResult(studyPlanResultId);
        studyplanResultMapper.deleteStudyPlanResult(studyPlanResultId);

        studyPlanResult.setWriteWho(writeWho);
        studyplanResultMapper.deleteStudyPlanResultHistory(studyPlanResult);
    }

    @Override
    public void addCardinalTimeUnitResult(CardinalTimeUnitResult cardinalTimeUnitResult, String writeWho) {

        cardinalTimeUnitResult.setWriteWho(writeWho);

        cardinaltimeunitResultMapper.addCardinalTimeUnitResult(cardinalTimeUnitResult);
        cardinaltimeunitResultMapper.addCardinalTimeUnitResultHistory(cardinalTimeUnitResult);
    }

    @Override
    public void updateCardinalTimeUnitResult(CardinalTimeUnitResult cardinalTimeUnitResult, String writeWho) {

        cardinalTimeUnitResult.setWriteWho(writeWho);
        cardinaltimeunitResultMapper.updateCardinalTimeUnitResult(cardinalTimeUnitResult);
        cardinaltimeunitResultMapper.updateCardinalTimeUnitResultHistory(cardinalTimeUnitResult);
    }

    @Override
    public void deleteCardinalTimeUnitResult(int cardinalTimeUnitResultId, String writeWho) {

        CardinalTimeUnitResult cardinalTimeUnitResult = findCardinalTimeUnitResult(cardinalTimeUnitResultId);
        cardinaltimeunitResultMapper.deleteCardinalTimeUnitResult(cardinalTimeUnitResultId);

        cardinalTimeUnitResult.setWriteWho(writeWho);
        cardinaltimeunitResultMapper.deleteCardinalTimeUnitResultHistory(cardinalTimeUnitResult);
    }

    @Override
    public void addThesisResult(ThesisResult thesisResult) {

        thesisResultMapper.addThesisResult(thesisResult);
        thesisResultMapper.addThesisResultHistory(thesisResult);
    }

    @Override
    public void updateThesisResult(ThesisResult thesisResult) {

        thesisResultMapper.updateThesisResult(thesisResult);
        thesisResultMapper.updateThesisResultHistory(thesisResult);
    }

    @Override
    public void deleteThesisResult(int thesisResultId, String writeWho) {

        ThesisResult thesisResult = findThesisResult(thesisResultId);
        thesisResultMapper.deleteThesisResult(thesisResultId);
        
        thesisResult.setWriteWho(writeWho);
        thesisResultMapper.deleteThesisResultHistory(thesisResult);
    }
    
    /** 
     * Method to hierarchically find the appropriate business rules for a test
     * @author MoVe
     * 
     */
	private String getBusinessRulesForPassingTest(
			Test test, Examination examination, 
			Subject subject, SubjectBlock subjectBlock, StudyPlan studyPlan,
			List < ? extends EndGrade > allEndGrades, Study study, 
			String endGradeTypeCode) {

		String brsPassingTest = testManager.getBRsPassingTest(test);

//	    if (test.getBRsPassingTest() != null & !"".equals(test.getBRsPassingTest())) {
//	    	brsPassingTest = test.getBRsPassingTest();
//	    } else {
		if (StringUtils.isBlank(brsPassingTest)) {
            brsPassingTest = this.getBusinessRulesForPassingExamination(examination, subject, subjectBlock, studyPlan, allEndGrades, study, endGradeTypeCode);
        }
	    return brsPassingTest;
	}

    /** 
     * private method to hierarchically find the appropriate business rules for an examination
     * @author MoVe
     * 
     */
	private String getBusinessRulesForPassingExamination(
			Examination examination, 
			Subject subject, SubjectBlock subjectBlock, StudyPlan studyPlan,
			List < ? extends EndGrade > allEndGrades, Study study, 
			String endGradeTypeCode) {

		String brsPassingExamination = null;

        if (examination.getBRsPassingExamination() != null && !"".equals(examination.getBRsPassingExamination())) {
            brsPassingExamination = examination.getBRsPassingExamination();
        } else {
            brsPassingExamination = this.getBusinessRulesForPassingSubject(subject, subjectBlock, studyPlan, allEndGrades, study,
                    endGradeTypeCode);
        }
        return brsPassingExamination;
	}

    /** 
     * private method to hierarchically find the appropriate business rules for a subject
     * @author MoVe
     * 
     */
	private String getBusinessRulesForPassingSubject(
			Subject subject, SubjectBlock subjectBlock, StudyPlan studyPlan,
			List < ? extends EndGrade > allEndGrades, Study study, 
			String endGradeTypeCode) {

		String brsPassingSubject = null;
		 
		if (subject.getBrsPassingSubject() != null && !"".equals(subject.getBrsPassingSubject().trim())) {
	        brsPassingSubject = subject.getBrsPassingSubject().trim();
	    } else {
            if (subjectBlock != null && subjectBlock.getBrsPassingSubjectBlock() != null
	        		&& !"".equals(subjectBlock.getBrsPassingSubjectBlock().trim())) {
	        	brsPassingSubject = subjectBlock.getBrsPassingSubjectBlock().trim();
	        } else {
	        	// zambian situation:

	        	brsPassingSubject = this.getBusinessRulesForPassingStudyPlan(
	        			studyPlan, allEndGrades, study, endGradeTypeCode);
	            log.debug("ResultManager.getBusinessRulesForPassingSubject: zambian situation" + brsPassingSubject);
	        }
	    }
		return brsPassingSubject;
	}

    @Override
 	public String getBusinessRulesForPassingStudyPlan(StudyPlan studyPlan,
			List < ? extends EndGrade > allEndGrades, Study study, 
			String gradeTypeCode) {

		String brsPassingSubject = null;
		
		// 1. check level of studyplan itself, not for Zambian situation:
        if (studyPlan.getBRsPassingExam() != null && !"".equals(studyPlan.getBRsPassingExam().trim())) {
        	brsPassingSubject = studyPlan.getBRsPassingExam().trim();
        }
   		if (log.isDebugEnabled()) {
   			log.debug("ResultManager.getBusinessRulesForPassingStudyPlan: brsPassingSubject = " + brsPassingSubject + ", allEndGrades.size=" + allEndGrades.size());
   		}

        if (brsPassingSubject == null && (allEndGrades == null || allEndGrades.size() == 0)) {
       		// 2. check level of studygradetype (Mozambican situation)
       		if (brsPassingSubject == null || "".equals(brsPassingSubject)) {
	       		Map<String, Object> map = new HashMap<>();
	       		map.put("studyId", study.getId());
	       		map.put("gradeTypeCode", gradeTypeCode);
	       		Integer currentAcademicYearId = studyManager.findMaxAcademicYearForStudyGradeType(map);
	
	       		map.put("currentAcademicYearId", currentAcademicYearId);
	       		brsPassingSubject = this.getBRsPassingSubjectForStudyGradeType(map);
	       	}
       		// 3. no studygradetype defined: check level of study
       		if (brsPassingSubject == null || "".equals(brsPassingSubject)) {
	       		brsPassingSubject = study.getBRsPassingSubject();
       		}
       		if (log.isDebugEnabled()) {
       			log.debug("ResultManager.getBusinessRulesForPassingStudyPlan: no endgrades known, brsPassingSubject after check studygradetype = " + brsPassingSubject);
       		}

       	} else {
       		// endgrades known (Zambian situation): find the lowest possible percentage to pass
       	    BigDecimal lowestPassPercentage = getLowestPassPercentage(allEndGrades);
       		if (lowestPassPercentage != null) {
       		    brsPassingSubject = String.valueOf(lowestPassPercentage);
       		}
       		if (log.isDebugEnabled()) {
       			log.debug("ResultManager.getBusinessRulesForPassingStudyPlan: endgrades known, brsPassingSubject = " + brsPassingSubject);
       		}
       	}

       	return brsPassingSubject;
	}

    @Override
    public BigDecimal getLowestPassPercentage(List<? extends EndGrade> allEndGrades) {
        BigDecimal lowestPassPercentage = null;
        for (int i = 0; i < allEndGrades.size(); i++) {
        	if (!"N".equals(allEndGrades.get(i).getPassed())) {
        	   BigDecimal percentageMin = allEndGrades.get(i).getPercentageMin();
        	   if (lowestPassPercentage == null || lowestPassPercentage.compareTo(percentageMin) > 0) {
        	       lowestPassPercentage = percentageMin;
        	   }
        	}
        }
        return lowestPassPercentage;
    }

    @Override
 	public String getBusinessRulesForPassingStudyGradeType(Study study,
			StudyGradeType studyGradeType, 
			List < ? extends EndGrade > allEndGrades) {

		String brsPassingSubject = null;
		
   		if (log.isDebugEnabled()) {
   			log.debug("ResultManager.getBusinessRulesForPassingStudyPlan: getBusinessRulesForPassingStudyGradeType start, allEndGrades.size=" + allEndGrades.size());
   		}

        if (allEndGrades == null || (allEndGrades.size() == 0 
        		|| (allEndGrades.size() != 0 && (
        			allEndGrades.get(0) == null 
        				|| "".equals(allEndGrades.get(0).getEndGradeTypeCode())))
       			)) {
       		// no EndGradeTypeCode defined (mozambican situation):
        	// 1. check level of study
       		if (brsPassingSubject == null || "".equals(brsPassingSubject)) {
	       		brsPassingSubject = study.getBRsPassingSubject();
       		}
       		// 2. check level of studygradetype
       		if (studyGradeType.getBRsPassingSubject() != null & !"".equals(studyGradeType.getBRsPassingSubject())) {
            	brsPassingSubject = studyGradeType.getBRsPassingSubject();
 	       	}
       		if (log.isDebugEnabled()) {
       			log.debug("ResultManager.getBusinessRulesForPassingStudyGradeType: no EndGradeTypeCode known, brsPassingSubject after check studygradetype = " + brsPassingSubject);
       		}

       	} else {
       		// endgrades known (zambian situation)
       		for (int i = 0; i < allEndGrades.size(); i++) {
 				if (!"N".equals(allEndGrades.get(i).getPassed())) {
 					brsPassingSubject = String.valueOf(allEndGrades.get(i).getPercentageMin());
 					break;
 				}
 			}
       		if (log.isDebugEnabled()) {
       			log.debug("ResultManager.getBusinessRulesForPassingStudyGradeType: EndGradeTypeCode known, brsPassingSubject = " + brsPassingSubject);
       		}
       	}

       	return brsPassingSubject;
	}

    @Override
	public String getBRsPassingSubjectForStudyGradeType(Map<String, Object> map) {

		return studyMapper.findBRsPassingSubjectForStudyGradeType(map);
 	}

    @Override
	public EndGrade calculateEndGradeForMark(
 			String mark, String endGradeTypeCode, String preferredLanguage, int academicYearId) {

        if (log.isDebugEnabled()) {
            log.debug("ResultManager.calculateEndGradeCommentForMark started...");
        }
        
        if (StringUtil.checkValidDouble(mark) != 1) {
            return null;
        }

        List < ? extends EndGrade > allEndGrades;

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(endGradeTypeCode, academicYearId, preferredLanguage);

        BigDecimal markDouble = new BigDecimal(mark);
        EndGrade bestEndGrade = null;
        for (EndGrade endGrade : allEndGrades) {
            // Use <= twice, because smallest (0) and largest (100) possible values have to be covered
            if (endGrade.getPercentageMin().compareTo(markDouble) <= 0 && markDouble.compareTo(endGrade.getPercentageMax()) <= 0) {

                // If more than one end grade matches, take the highest one
                if (bestEndGrade == null || bestEndGrade.getPercentageMax().compareTo(endGrade.getPercentageMax()) < 0) {
                    bestEndGrade = endGrade;
                }
            }
        }

        return bestEndGrade;
    }

    /** 
     * @author MoVe
     * private method to find minimum Mark for a studyPlan
     * @param academicYearId
     * 
     */
	private String getMinimumMarkForStudyPlan(
			List < ? extends EndGrade > allEndGrades, Study study, 
			String endGradeTypeCode, int academicYearId) {

		String minimumMarkStudyPlan = null;
		
	    if (allEndGrades == null || allEndGrades.isEmpty() || allEndGrades.get(0) == null
				|| "".equals(allEndGrades.get(0).getEndGradeTypeCode())) {
	    	// no studygradetype defined (mozambican situation):
			// find the minimum mark on the level of the study:
	        minimumMarkStudyPlan = study.getMinimumMarkSubject();
		} else {
	    	//  studygradetype defined (zambian situation):
			// find the minimum mark on the level of the studygradetype
		    Map<String, Object> map = new HashMap<>();
		    map.put("endGradeTypeCode", endGradeTypeCode);
		    map.put("academicYearId", academicYearId);
            minimumMarkStudyPlan = String.valueOf(studyManager.findMinimumEndGradeForGradeType(map));
		}
	    return minimumMarkStudyPlan;
	}

    /** 
     * @author MoVe
     * private method to find maximum Mark for a studyPlan
     * @param academicYearId
     * 
     */
	private String getMaximumMarkForStudyPlan(
			List < ? extends EndGrade > allEndGrades, Study study, 
			String endGradeTypeCode, int academicYearId) {

		String maximumMarkStudyPlan = null;
	    if (allEndGrades == null || allEndGrades.isEmpty() || allEndGrades.get(0) == null
				|| "".equals(allEndGrades.get(0).getEndGradeTypeCode())) {
	    	// no studygradetype defined (mozambican situation):
			// find the maximum mark on the level of the study:
	        maximumMarkStudyPlan = study.getMaximumMarkSubject();
		} else {
	    	//  studygradetype defined (zambian situation):
			// find the maximum mark on the level of the studygradetype
            Map<String, Object> map = new HashMap<>();
            map.put("endGradeTypeCode", endGradeTypeCode);
            map.put("academicYearId", academicYearId);
	    	maximumMarkStudyPlan = String.valueOf(
					studyManager.findMaximumEndGradeForGradeType(map));
		}
	    return maximumMarkStudyPlan;
	}

    @Override
    public BigDecimal getCreditAmountForCardinalTimeUnitNumber(
    		List <Subject> allSubjectsForCardinalTimeUnit) {

        BigDecimal creditAmount = BigDecimal.ZERO;
        BigDecimal totalCreditAmount = BigDecimal.ZERO;

    	if (log.isDebugEnabled()) {
    		log.debug("ResultManager.getCreditAmountForCardinalTimeUnitNumber: allSubjectsForCardinalTimeUnit.size() = " 
    				+ allSubjectsForCardinalTimeUnit.size());
    	}
        
    	for (int h = 0; h < allSubjectsForCardinalTimeUnit.size(); h++) {
            // reset subject values:
            Subject subject = 
                    subjectManager.findSubject(allSubjectsForCardinalTimeUnit.get(h).getId());
            creditAmount = subject.getCreditAmount();
//            if (creditAmount == 0) {
            if (creditAmount.compareTo(BigDecimal.ZERO) == 0) {
//                totalCreditAmount = 0.0;
                totalCreditAmount = BigDecimal.ZERO;
                break;
                
            } else {
                // re-calculate totalCreditAmount with each subject value:
//                totalCreditAmount = totalCreditAmount + creditAmount;
                totalCreditAmount = totalCreditAmount.add(creditAmount);
            } // end for

        } // end for
        
    	return totalCreditAmount;
    	
    }

    @Override
    public List < SubjectResult > findCalculatableSubjectResultsForStudyPlan(
    		List < StudyPlanDetail > allStudyPlanDetailsFromList,
    		List < Subject > allSubjectsFromList, StudyPlan studyPlan
    		, boolean resultsAfterExclude) {
    	
    	List < SubjectResult > subjectResultsForCTU = null;
    	List < SubjectResult > subjectResultsForStudyPlan = new ArrayList< >();
    	int numberOfCardinalTimeUnitsForStudyPlan = 0;
     	StudyPlanCardinalTimeUnit calculatableStudyPlanCardinalTimeUnit = null;
     	int firstCtuNumber = 1;
    	
        /* all cardinal time units for this studyplan */
     	Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyId", studyPlan.getStudyId());
    	ctuMap.put("gradeTypeCode", studyPlan.getGradeTypeCode());

    	numberOfCardinalTimeUnitsForStudyPlan = 
    		studyManager.findNumberOfCardinalTimeUnitsForStudyAndGradeType(ctuMap);
    	
    	if (resultsAfterExclude) {
    	    int exludedCtuNumber = 1;
    	    Map<String, Object> allUnitsMap =  new HashMap<>();
    	    allUnitsMap.put("studyPlanId", studyPlan.getId());
    	    List < StudyPlanCardinalTimeUnit > allStudyPlanCtus = studentManager.findStudyPlanCardinalTimeUnitsByParams(allUnitsMap);
    	    
    	    for (StudyPlanCardinalTimeUnit studyPlanCtu : allStudyPlanCtus) {
    	        if (studyPlanCtu.getProgressStatusCode().equals(OpusConstants.PROGRESS_STATUS_EXCLUDE_PROGRAM)
    	                || studyPlanCtu.getProgressStatusCode().equals(OpusConstants.PROGRESS_STATUS_EXCLUDE_SCHOOL) 
    	                || studyPlanCtu.getProgressStatusCode().equals(OpusConstants.PROGRESS_STATUS_EXCLUDE_UNIVERSITY)) {
    	            exludedCtuNumber = studyPlanCtu.getCardinalTimeUnitNumber();
    	        }     
    	    }
    	    firstCtuNumber = exludedCtuNumber;
    	}

    	ctuMap.put("studyPlanId", studyPlan.getId());

    	for (int h = firstCtuNumber; h < (numberOfCardinalTimeUnitsForStudyPlan + 1); h++) {
        	
        	ctuMap.put("cardinalTimeUnitNumber", h);

    		calculatableStudyPlanCardinalTimeUnit = this.findCalculatableStudyPlanCardinalTimeUnit(ctuMap);
    	
    		if (calculatableStudyPlanCardinalTimeUnit != null) {
	    		
    			if (OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED.equals(
    					calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())) {
	    			ctuMap.put("studyPlanCardinalTimeUnitId", calculatableStudyPlanCardinalTimeUnit.getId());
		    	
		    		subjectResultsForCTU = this.findCalculatableSubjectResultsForCardinalTimeUnit(
		    				allStudyPlanDetailsFromList, ctuMap);
		    		
		    		if (subjectResultsForCTU.size() != 0) {
		    			subjectResultsForStudyPlan.addAll(subjectResultsForCTU);
		    		}
    			} else {
    				// not actively registered studyplancardinaltimeunit
    				subjectResultsForStudyPlan = null;
    				break;
    			}
    		}
    	}
    	
    	// 1. order the list by subjectresultdate:
    	if (subjectResultsForStudyPlan != null && subjectResultsForStudyPlan.size() != 0) {
    		Collections.sort(subjectResultsForStudyPlan, new SubjectResultDateComparator());
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.findCalculatableSubjectResultsForStudyPlan: subjectResultsForStudyPlan.size = "
                        + subjectResultsForStudyPlan.size());
            }
    	} else {
        	if (log.isDebugEnabled()) {
        	    log.debug("ResultManager.findCalculatableSubjectResultsForStudyPlan: subjectResultsForStudyPlan is NULL");
        	}
    	}
    	return subjectResultsForStudyPlan;
    }

    @Override
    public List < Subject > findSpecificNumberOfCalculatableSubjectsForStudyPlan(
    		List < ? extends EndGrade > allEndGrades, 
    		StudyPlan studyPlan,
    		List < SubjectResult > subjectResultsForStudyPlan, 
    		int numberOfSubjectsToCount) {
    	
    	List < Subject > subjectsForCTU = null;
    	List < Subject > subjectBlockSubjects = null;
    	List < Subject > allSubjects = new ArrayList<>();
    	List < SubjectResult > sortedSubjectResults  = new ArrayList<>();
    	List < Subject > calculatableSubjects = new ArrayList<>();
    	List < StudyPlanDetail > studyPlanDetailsForCTU = null;
    	int maxNumberOfCardinalTimeUnitsForStudyPlan = 0;
     	StudyPlanCardinalTimeUnit calculatableStudyPlanCardinalTimeUnit = null;
    	Subject subject = null;
    	boolean subjectResultForSubjectFound = false;
		SubjectResult subjectResult = null;
		String subjectResultMark = "";
        BigDecimal subjectResultMarkDouble = BigDecimal.ZERO;
        BigDecimal maxSubjectResultMarkDouble = BigDecimal.ZERO;

        /* all cardinal time units for this studyplan */
     	Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyId", studyPlan.getStudyId());
    	ctuMap.put("gradeTypeCode", studyPlan.getGradeTypeCode());

        maxNumberOfCardinalTimeUnitsForStudyPlan = studyManager.findNumberOfCardinalTimeUnitsForStudyAndGradeType(ctuMap);

    	ctuMap.put("studyPlanId", studyPlan.getId());

    	for (int h = 1; h < (maxNumberOfCardinalTimeUnitsForStudyPlan + 1); h++) {
        	
        	ctuMap.put("cardinalTimeUnitNumber", h);

    		calculatableStudyPlanCardinalTimeUnit = this.findCalculatableStudyPlanCardinalTimeUnit(ctuMap);
    	
    		if (calculatableStudyPlanCardinalTimeUnit != null) {
	    		
    			if (OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED.equals(
    					calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())) {
	    			if (log.isDebugEnabled()) {
	    			    log.debug("ResultManager.findSpecificNumberOfCalculatableSubjectsForStudyPlan: actively registered");
	    			}
    			    // 1. find all subjects connected to this studyplancardinaltimeunit 
					// through the studyplandetails
		    		studyPlanDetailsForCTU = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(calculatableStudyPlanCardinalTimeUnit.getId());
		     		
					if (studyPlanDetailsForCTU.size() != 0) {
						subjectsForCTU = new ArrayList<>();
						for (int j = 0; j < studyPlanDetailsForCTU.size(); j ++) {
							if (studyPlanDetailsForCTU.get(j).getSubjectBlockId() != 0) {
								subjectBlockSubjects = subjectBlockMapper.findSubjectsForSubjectBlock(studyPlanDetailsForCTU.get(j).getSubjectBlockId());
								subjectsForCTU.addAll(subjectBlockSubjects);
							} else {
								subject = subjectManager.findSubject(studyPlanDetailsForCTU.get(j).getSubjectId());
								subjectsForCTU.add(subject);
							}
						}
						if (subjectsForCTU.size() != 0) {
							allSubjects.addAll(subjectsForCTU);
						}
						subjectsForCTU = null;
					}
    			} else {
    			    if (log.isDebugEnabled()) {
                        log.debug("ResultManager.findSpecificNumberOfCalculatableSubjectsForStudyPlan: NOT actively registered: "
                                + calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode());
                    }
    				// not actively registered studyplanctu
    				subjectsForCTU = null;
    				allSubjects = null;
    				break;
    			}
    		}
    	}
    	
    	// further sort the newly found subjects:
    	if (allSubjects != null && allSubjects.size() != 0) {
            
    		// 1. find corresponding subjectresults for further sorting:
            for (int h = 0; h < allSubjects.size(); h++) {
                // reset subject values:
                subjectResultForSubjectFound = false;
//                maxSubjectResultMarkDouble = 0.0;
                maxSubjectResultMarkDouble = BigDecimal.ZERO;
                
                // calculate with subject values:
                for (int i = 0; i < subjectResultsForStudyPlan.size(); i++) {
                    if (allSubjects.get(h).getId() == subjectResultsForStudyPlan.get(i).getSubjectId()) {
                        subjectResultForSubjectFound = true;
                        subjectResultMark = subjectResultsForStudyPlan.get(i).getMark();
                        if (subjectResultMark == null || "".equals(subjectResultMark)) {
                        	subjectResultMark = "0.0";
             	        }
                        if (StringUtil.checkValidInt(subjectResultMark) == -1) {
                            if (StringUtil.checkValidDouble(subjectResultMark) == -1) {
                                for (int j = 0; j < allEndGrades.size(); j++) {
                                    if (StringUtil.lrtrim(subjectResultMark).equals(allEndGrades.get(j).getCode())) {
                                    	subjectResultMarkDouble = allEndGrades.get(j).getGradePoint();
                                    }
                                }
                            } else {
                                subjectResultMarkDouble = new BigDecimal(subjectResultMark);
                            }
                        } else {
                            int subjectResultMarkInt = Integer.parseInt(subjectResultMark);
                            subjectResultMarkDouble = new BigDecimal(subjectResultMarkInt);
                        }
                       
                        // comparison necessary, only one subjectresult per subject counts (highest):
                        if (subjectResultMarkDouble.compareTo(maxSubjectResultMarkDouble) > 0) {
                            maxSubjectResultMarkDouble = subjectResultMarkDouble;
                            subjectResult = subjectResultsForStudyPlan.get(i);
                        }
                        // reset value:
                        subjectResultMarkDouble = BigDecimal.ZERO;
                    }
                }
                if (log.isDebugEnabled()) {
                    log.debug("ResultManager.findSpecificNumberOfCalculatableSubjectsForStudyPlan: subjectresult found for subject "
                            + subject.getSubjectDescription() + ", maxSubjectResultMarkDouble =  " + maxSubjectResultMarkDouble);
                }
                if (subjectResultForSubjectFound == true) {
                	sortedSubjectResults.add(subjectResult);
                	subjectResult = null;
                } else {
                	// error: no subjectresult for this subject found. Generation not possible
                	if (log.isDebugEnabled()) {
            			log.debug("ResultManager.findCalculatableSubjectResultsForStudyPlan: ERROR - subject without subjectresult - "
            				+ "allSubjects.get(h).getId() = " + allSubjects.get(h).getId());
            		}
                	return null;
                }
            } // end for calculatable subjects
    	}	
    	
    	if (sortedSubjectResults != null && sortedSubjectResults.size() != 0) {
    		// 2. sort the subjectresultslist:
    		Collections.sort(sortedSubjectResults, new SubjectResultDateComparator());
    		Collections.reverse(sortedSubjectResults);
    	}
    	
		// 2. take only the newest subjects up to the specified number (last 3 years, last 2 years etc.)
		if (sortedSubjectResults != null && sortedSubjectResults.size() != 0
		        && allSubjects != null && allSubjects.size() != 0) {
	    	   for (int i = 0; i < sortedSubjectResults.size(); i++) {
		    		
		    		for (int w = 0; w < allSubjects.size(); w++) {
		    			if (sortedSubjectResults.get(i).getSubjectId() == allSubjects.get(w).getId()) {
		    				calculatableSubjects.add(allSubjects.get(w));
		    			}
		    		}
		    	}
		
				for (int j = 0; j < calculatableSubjects.size(); j++) {
		    		if (log.isDebugEnabled()) {
		    			log.debug("ResultManager.findCalculatableSubjectResultsForStudyPlan: "+ j + ". calculatableSubjects.subjectId = " + calculatableSubjects.get(j).getId()
		    				+ ", description = " + calculatableSubjects.get(j).getSubjectDescription());
		    		}
				}
	    	    
		} else {
			calculatableSubjects = null;
		}
    	
    	return calculatableSubjects;
    }

    @Override
    public List < Subject > findCalculatableSubjectsForStudyPlan(
    		String preferredLanguage, StudyPlan studyPlan, 
    		String numberOfYearsToCount) {
    	
    	List < Subject > subjectsForCTU = null;
    	List < Subject > subjectBlockSubjects = null;
    	List < Subject > calculatableSubjects = new ArrayList<>();
    	List < StudyPlanDetail > studyPlanDetailsForCTU = null;
    	int maxNumberOfCardinalTimeUnitsForStudyPlan = 0;
     	StudyPlanCardinalTimeUnit calculatableStudyPlanCardinalTimeUnit = null;
    	Subject subject = null;
    	StudyGradeType studyGradeType = null;
    	int nrOfUnitsPerYear = 0;
    	int startCTU = 0;

    	/* all cardinal time units for this studyplan */
     	Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyId", studyPlan.getStudyId());
    	ctuMap.put("gradeTypeCode", studyPlan.getGradeTypeCode());
    	ctuMap.put("studyPlanId", studyPlan.getId());
    	
    	maxNumberOfCardinalTimeUnitsForStudyPlan = 
    		studyManager.findNumberOfCardinalTimeUnitsForStudyAndGradeType(ctuMap);

    	//1. find the studygradetype and corresponding cardinaltimeunit code (year / semester / trimester / ..)
    	//   for the last studyplancardinaltimeunit of the studyplan
    	calculatableStudyPlanCardinalTimeUnit = this.findMaxCalculatableStudyPlanCardinalTimeUnit(studyPlan.getId());

    	if (calculatableStudyPlanCardinalTimeUnit != null) {
    		
            studyGradeType = studyManager.findStudyGradeType(calculatableStudyPlanCardinalTimeUnit.getStudyGradeTypeId());
			List <Lookup8> allCardinalTimeUnits = (List <Lookup8>) lookupCacher.getAllCardinalTimeUnits(preferredLanguage);
			for (int i = 0; i < allCardinalTimeUnits.size(); i++) {
				if (allCardinalTimeUnits.get(i).getCode().equals(studyGradeType.getCardinalTimeUnitCode()) ) {
					nrOfUnitsPerYear = allCardinalTimeUnits.get(i).getNrOfUnitsPerYear();
				}
			}
			if (log.isDebugEnabled()) {
    			log.debug("ResultManager.findCalculatableSubjectsForStudyPlan: nrOfUnitsPerYear = " + nrOfUnitsPerYear + 
    					", numberOfYearsToCount = " + numberOfYearsToCount);
    		}
			
			if ("allSeniorYears".equals(numberOfYearsToCount)) {
				// take first two years + 1 as startingpoint for searching,
				// but only if the total number of studyyears is minimum 3 (i.e. 1 senior year):
				if ((calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() / nrOfUnitsPerYear) > 2) {
					startCTU = (2 * nrOfUnitsPerYear) + 1;
//				} else {
//				    numberOfYearsToCount = "allYears";
				}
			}
			if ("lastTwoSeniorYears".equals(numberOfYearsToCount)) {
				// take total number of senior years and substract 2 years as startingpoint for searching,
				// but only if the total number of ctu's is minimum 4 (i.e. 2 senior years):
				if ((calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() / nrOfUnitsPerYear) > 3) {
					startCTU = 
						calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() - (1 * nrOfUnitsPerYear);
//                } else {
//                    numberOfYearsToCount = "allYears";
				}
			}
			if ("lastTwoYears".equals(numberOfYearsToCount)) {
				// take total number of years and substract 2 years as startingpoint for searching:
				startCTU = 
					calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() - (1 * nrOfUnitsPerYear);
//				if (startCTU < 0) {
//                    numberOfYearsToCount = "allYears";
//				}
			}
            if ("allYears".equals(numberOfYearsToCount)) {
                // simply count all years; the first CTU might not be 1 though
                startCTU = (Integer) studentManager.findMinCardinalTimeUnitNumberForStudyPlan(studyPlan.getId());
            }

            if (log.isDebugEnabled()) {
    			log.debug("ResultManager.findCalculatableSubjectsForStudyPlan: startCTU = " + startCTU);
    		}
    	} else {
    		if (log.isDebugEnabled()) {
    			log.debug("ResultManager.findCalculatableSubjectsForStudyPlan: calculatableStudyPlanCardinalTimeUnit is null");
    		}
    	}
    	
    	if (startCTU != 0) {
	    	for (int h = startCTU; h < (maxNumberOfCardinalTimeUnitsForStudyPlan + 1); h++) {

	    		ctuMap.put("cardinalTimeUnitNumber", h);
	    	
	        	calculatableStudyPlanCardinalTimeUnit = this.findCalculatableStudyPlanCardinalTimeUnit(ctuMap);
				if (calculatableStudyPlanCardinalTimeUnit != null) {
		        	
					if (OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED.equals(
							calculatableStudyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())) {
						// 2. find all subjects connected to this studyplancardinaltimeunit 
						// through the studyplandetails
			    		studyPlanDetailsForCTU = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(calculatableStudyPlanCardinalTimeUnit.getId());
			    		if (log.isDebugEnabled()) {
			    			log.debug("ResultManager.findCalculatableSubjectsForStudyPlan: ctunumber = " + h + ", studyPlanDetailsForCTU = " + studyPlanDetailsForCTU.size());
			    		}
						if (studyPlanDetailsForCTU.size() != 0) {
							subjectsForCTU = new ArrayList<>();
							for (int j = 0; j < studyPlanDetailsForCTU.size(); j ++) {
								if (studyPlanDetailsForCTU.get(j).getSubjectBlockId() != 0) {
									subjectBlockSubjects = subjectBlockMapper.findSubjectsForSubjectBlock(studyPlanDetailsForCTU.get(j).getSubjectBlockId());
									subjectsForCTU.addAll(subjectBlockSubjects);
								} else {
									subject = subjectManager.findSubject(studyPlanDetailsForCTU.get(j).getSubjectId());
									subjectsForCTU.add(subject);
								}
							}
							if (subjectsForCTU.size() != 0) {
								
								calculatableSubjects.addAll(subjectsForCTU);
							}
							subjectsForCTU = null;
						}
					} else {
						// studyplanctu is not actively registered, no calculation possible:
						calculatableSubjects = null;
						subjectsForCTU = null;
						break;
					}
				}
	    	}
    	}
    	
    	if (calculatableSubjects != null && calculatableSubjects.size() != 0) {
    		// 3. order the list by academic year:
    		//Collections.sort(calculatableSubjects, new SubjectAcademicYearComparator());
    		Collections.reverse(calculatableSubjects);
    	}
    	
    	if (log.isDebugEnabled()) {
			log.debug("ResultManager.findCalculatableSubjectsForStudyPlan: calculatableSubjects.size() = " + calculatableSubjects.size());
		}
    	return calculatableSubjects;
    }

    @Override
    public List < SubjectResult > findCalculatableSubjectResultsForCardinalTimeUnit(
    		List < StudyPlanDetail > allStudyPlanDetailsFromList, Map<String, Object> map) {

    	List < SubjectResult > allSubjectResultsForSubject = null;
        List<SubjectResult> allActiveSubjectResultsForCardinalTimeUnit = new ArrayList<>();
    	SubjectResult subjectResult = null;

        allSubjectResultsForSubject = this.findActiveSubjectResultsForCardinalTimeUnit(map);

        if (log.isDebugEnabled()) {
    		log.debug("ResultManager.findCalculatableSubjectResultsForCardinalTimeUnit: allSubjectResultsForSubject = "
    				+ allSubjectResultsForSubject.size());
    	}
    	
        if (allStudyPlanDetailsFromList.size() != 0) {
            for (int k = 0; k < allStudyPlanDetailsFromList.size(); k++) {
                for (int j = 0; j < allSubjectResultsForSubject.size(); j++) {
                    if (allSubjectResultsForSubject.get(j).getStudyPlanDetailId() == allStudyPlanDetailsFromList.get(k).getId()) {
                        subjectResult = allSubjectResultsForSubject.get(j);
                    }
                    if (subjectResult != null) {
                        allActiveSubjectResultsForCardinalTimeUnit.add(subjectResult);
                    }
                    // reset:
                    subjectResult = null;
                }
            }
        }
    	
    	if (log.isDebugEnabled()) {
    		log.debug("ResultManager.findCalculatableSubjectResultsForCardinalTimeUnit: allActiveSubjectResultsForCardinalTimeUnit.size = "
    				+ allActiveSubjectResultsForCardinalTimeUnit.size());
    	}
    	
        return allActiveSubjectResultsForCardinalTimeUnit;
        
    }

    @Override
    public String calculateSubjectResultsForCardinalTimeUnit(
    		Study study, 
    		CardinalTimeUnitResult cardinalTimeUnitResult,
    		List <SubjectResult > subjectResults,
            List <Subject> allSubjectsForCardinalTimeUnit,
            BigDecimal brsPassingSubjectDouble,
            String preferredLanguage,
            Locale currentLoc, Errors errors) {

	    Study diffStudy = null;
	    boolean allSubjectsPassed = false;
	    boolean subjectResultForSubjectFound = false;
	    boolean subjectIncomplete = false;
	    BigDecimal creditAmount = BigDecimal.ZERO;
	    BigDecimal totalCreditAmount = BigDecimal.ZERO;
	    String subjectResultMark = "";
	    BigDecimal subjectResultMarkDouble = BigDecimal.ZERO;
	    BigDecimal maxSubjectResultMarkDouble = BigDecimal.ZERO;
	    boolean markIsString = false;
	    String endGrade = null;
	    int endGradeInt = 0;
	    BigDecimal endGradeDouble = BigDecimal.ZERO;
        StudyPlan studyPlan = null;
        StudyGradeType studyGradeType = null;
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
        List < ? extends EndGrade > allEndGrades = null;

        studyPlan = studentManager.findStudyPlan(cardinalTimeUnitResult.getStudyPlanId());
        studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(
        		cardinalTimeUnitResult.getStudyPlanCardinalTimeUnitId());
        studyGradeType = studyManager.findStudyGradeType(
        				studyPlanCardinalTimeUnit.getStudyGradeTypeId());

        // see if the endGrades are defined on studygradetype level
        allEndGrades = findEndGrades(studyPlan.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(), preferredLanguage);
        if (log.isDebugEnabled()) {
        	log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: endGrades for endGradeTypeCode " + studyPlan.getGradeTypeCode() 
        			+ ", size = " + allEndGrades.size());
        }

	    // Cardinal time unit calculation must take into account that subjects may be from
	    // different studies or studygradetypes with their own rewarding scales 
	    // (minimumMark / maximumMark scale).
	    // If these differ, then no generated mark can be set -> errorMsg !
	    if (subjectResults != null && subjectResults.size() != 0) {
	        for (int h = 0; h < allSubjectsForCardinalTimeUnit.size(); h++) {
	            diffStudy = null;
	            Subject subject = null;
	            Map<String, Object> map = new HashMap<>();
	            
	            // first check endgrades for correct comparison values (study or studygradetype)
	            if (allEndGrades == null || allEndGrades.isEmpty()
	                    || "".equals(allEndGrades.get(0).getEndGradeTypeCode())) {
	                //  no studygradetype defined (mozambican situation):
	                if (allSubjectsForCardinalTimeUnit.get(h).getPrimaryStudyId() != study.getId()) {
	                    diffStudy = studyManager.findStudy(
	                                        allSubjectsForCardinalTimeUnit.get(h).getPrimaryStudyId());
	                    if (!diffStudy.getMinimumMarkSubject().equals(study.getMinimumMarkSubject())) {
	                        errors.rejectValue("mark", "jsp.error.different.rewarding.scales");
	                        return null;
	                    }
	                    if (!diffStudy.getMaximumMarkSubject().equals(study.getMaximumMarkSubject())) {
	                        errors.rejectValue("mark", "jsp.error.different.rewarding.scales");
	                        return null;
	                    }
	                }
	            } else {
	                //  studygradetype defined (zambian situation):
	                subject = allSubjectsForCardinalTimeUnit.get(h);
	                map.put("subjectId", subject.getId());
	                map.put("preferredLanguage", preferredLanguage);
	                List <? extends SubjectStudyGradeType> subjectStudyGradeTypes = 
	                        subjectManager.findSubjectStudyGradeTypes(map);
	                BigDecimal saveMinimumEndGradeStudyGradeType = BigDecimal.ZERO;
	                BigDecimal saveMaximumEndGradeStudyGradeType = BigDecimal.ZERO;
	                BigDecimal minimumEndGradeStudyGradeType = BigDecimal.ZERO;
	                BigDecimal maximumEndGradeStudyGradeType = BigDecimal.ZERO;
	                for (int x = 0; x < subjectStudyGradeTypes.size(); x++) {
	                    SubjectStudyGradeType subjectStudyGradeType = subjectStudyGradeTypes.get(x);
                        StudyGradeType sgt = studyManager.findStudyGradeType(subjectStudyGradeType.getStudyGradeTypeId());

	                    Map<String, Object> minMap = new HashMap<>();
	                    minMap.put("endGradeTypeCode", subjectStudyGradeType.getGradeTypeCode());
	                    minMap.put("academicYearId", sgt.getCurrentAcademicYearId());
	                    
	                    minimumEndGradeStudyGradeType = studyManager.findMinimumEndGradeForGradeType(minMap);
	                    maximumEndGradeStudyGradeType = studyManager.findMaximumEndGradeForGradeType(minMap);
                        if (saveMinimumEndGradeStudyGradeType.compareTo(BigDecimal.ZERO) != 0
	                            && saveMinimumEndGradeStudyGradeType.compareTo(minimumEndGradeStudyGradeType) != 0) {
                            errors.rejectValue("mark", "jsp.error.different.rewarding.scales");
                            return null;
	                    }
                        if (saveMaximumEndGradeStudyGradeType.compareTo(BigDecimal.ZERO) != 0 
	                            && saveMaximumEndGradeStudyGradeType.compareTo(maximumEndGradeStudyGradeType) != 0) {
                            errors.rejectValue("mark", "jsp.error.different.rewarding.scales");
                            return null;
	                    }
	                    
	                }
	            }
	                
	        }
	    } else {
	    	String[] errorArgs = new String[1];
	    	errorArgs[0] = Integer.toString(studyPlanCardinalTimeUnit.getId());
	        if (log.isDebugEnabled()) {
	            log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                    + "no subjectresults available for studyplanCTU " + studyPlanCardinalTimeUnit.getId());
	        }
	        errors.rejectValue("mark", "jsp.error.nosubjectresults.ctu", errorArgs, null);
	        return null;
	    }

	        if (log.isDebugEnabled()) {
	            log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                    + "start calculation for all allSubjectsForCardinalTimeUnit.size()"
	                    + allSubjectsForCardinalTimeUnit.size());
	        }
	        for (int h = 0; h < allSubjectsForCardinalTimeUnit.size(); h++) {
	            // reset subject values:
	            subjectResultForSubjectFound = false;
	            allSubjectsPassed = false;
	            subjectIncomplete = false;
	            // reset max value:
                maxSubjectResultMarkDouble = BigDecimal.ZERO;
	            Subject subject = 
	                    subjectManager.findSubject(allSubjectsForCardinalTimeUnit.get(h).getId());
	
	            // 1. check if creditamount is set for the subject:
	            creditAmount = subject.getCreditAmount();
                if (creditAmount.compareTo(BigDecimal.ZERO) == 0) {
	                errors.rejectValue("mark", "jsp.error.subjects.creditamount.empty");
	                return null;
	            } else {
	                // 2. check if academicyear is set for the subject:
	                if (subject.getCurrentAcademicYearId() == 0) {
	                    errors.rejectValue("mark", "jsp.error.subjects.academicyear.empty");
	                    return null;
	                } else {
	                    // calculate with subject values:
	                    for (int i = 0; i < subjectResults.size(); i++) {
	                        if (allSubjectsForCardinalTimeUnit.get(h).getId() == subjectResults.get(i).getSubjectId()) {
	                            if (!OpusConstants.FAILGRADE_INCOMPLETE.equals(
	                            		subjectResults.get(i).getEndGradeComment())) {
		                        	subjectResultForSubjectFound = true;
		                            allSubjectsPassed = true;
		                            // reset subjectResult values:
		                            subjectResultMark = subjectResults.get(i).getMark();

		                            // now count up the total for this subject:
                                    totalCreditAmount = totalCreditAmount.add(creditAmount);

		        	                if (subjectResultMark == null || "".equals(subjectResultMark)) {
		                            	subjectResultMark = "0.0";
		                 	        }
		        	                if (StringUtil.checkValidInt(subjectResultMark) == -1) {
		                                if (StringUtil.checkValidDouble(subjectResultMark) == -1) {
		                                    // mark is string, not number:
		                                    markIsString = true;
		                                    for (int j = 0; j < allEndGrades.size(); j++) {
		                                        if (StringUtil.lrtrim(subjectResultMark).equals(allEndGrades.get(j).getCode())) {
		                                        	subjectResultMarkDouble = allEndGrades.get(j).getGradePoint();
		                                        }
		                                    }
		                                } else {
                                            subjectResultMarkDouble = new BigDecimal(subjectResultMark);
		                                }
		                            } else {
		                                int subjectResultMarkInt = Integer.parseInt(subjectResultMark);
                                        subjectResultMarkDouble = new BigDecimal(subjectResultMarkInt);
		                            }
		                            if (log.isDebugEnabled()) {
		                                log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
		                                        + subject.getSubjectDescription() + ", subjectResultMarkDouble =  " + subjectResultMarkDouble);
		                            }
		            
		                            // comparison necessary, only one result per examination (highest):
                                    if (subjectResultMarkDouble.compareTo(maxSubjectResultMarkDouble) > 0) {
		                                maxSubjectResultMarkDouble = subjectResultMarkDouble;
		                            }
		                            // reset value:
                                    subjectResultMarkDouble = BigDecimal.ZERO;
		                        } else {
		                        	subjectIncomplete = true;
		                        	allSubjectsPassed = true;
		                        }
	                        }
	                    }
	                    if (subjectResultForSubjectFound == false && subjectIncomplete == false) {
	                        //endGrade = "0.0";
	                        if (log.isDebugEnabled()) {
	                            log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                                    + "subjectResultForSubjectFound == false");
	                        }
                            errors.rejectValue("mark", "jsp.error.missingsubjectresults.cardinaltimeunit");
                            return null;
	                    }
	                
	                } // end for
	            }
	
	            // calculate total subject result looping
                if (log.isDebugEnabled()) {
                    log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: " 
                            + subject.getSubjectDescription() + " - maxSubjectResultMarkDouble:" + maxSubjectResultMarkDouble);
                }
                if (subjectIncomplete == false) {
                    endGradeDouble = endGradeDouble.add(creditAmount.multiply(maxSubjectResultMarkDouble));
                }
	        } // end for
	        
	            if (!allSubjectsPassed) {
	                //endGrade = "0.0";
	                errors.rejectValue("mark", "jsp.error.subjects.passed");
	                return null;
	            } else {
	                // end-calculation:
	                if (log.isDebugEnabled()) {
	                    log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                            + "endGradeDouble = " + endGradeDouble + ", totalCreditAmount = "+ totalCreditAmount);
	                }
	                
                    endGradeDouble = endGradeDouble.divide(totalCreditAmount, MC);

	                // decide whether to present a number or a letter:
	                if (markIsString) {
	
	                    // round the double -> int
                        endGradeInt = endGradeDouble.setScale(0, RoundingMode.HALF_UP).intValue();
	
	                    for (int k = 0; k < allEndGrades.size(); k++) {
	                        if (endGradeDouble == allEndGrades.get(k).getGradePoint()) {
	                            endGrade = allEndGrades.get(k).getCode();
	                            // break the for-loop:
	                            break;
	                        }
	                    }
	                    if (log.isDebugEnabled()) {
	                        log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                                + "endGrade is string:" + endGrade);
	                    }
	
	                } else {
	                    if (endGradeInt != 0) {
	                        endGrade = "" + endGradeInt;
	                    } else {
                            endGrade = resultUtil.roundSubjectMark(endGradeDouble).toPlainString();
	                    }
	                    if (log.isDebugEnabled()) {
	                        log.debug("ResultManager.calculateSubjectResultsForCardinalTimeUnit: "
	                                + "endGrade is int / double:" + endGrade);
	                    }
	                }
	            }
	    
	    return endGrade;
    }

    @Override
    public Map<Integer, Authorization> determineAuthorizationForCardinalTimeUnitResults(List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits, HttpServletRequest request) {

        Map<Integer, Authorization> authorizationMap = new HashMap<>();
        for (StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit : studyPlanCardinalTimeUnits) {
            Authorization authorization = determineAuthorizationForCardinalTimeUnitResult(studyPlanCardinalTimeUnit, request);
            authorizationMap.put(studyPlanCardinalTimeUnit.getId(), authorization);
        }
        return authorizationMap;
    }

    @Override
    public Authorization determineAuthorizationForCardinalTimeUnitResult(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, HttpServletRequest request) {

        // Check if logged in user is student, which implies specific privileges
        OpusUser opusUser = opusMethods.getOpusUser();
        Student student = opusUser.getStudent();
        studentManager.fillStudentBalanceInformation(student);

        boolean roleCreate = request.isUserInRole(OpusPrivilege.CREATE_CARDINALTIMEUNIT_RESULTS);
        boolean roleRead = request.isUserInRole(OpusPrivilege.READ_CARDINALTIMEUNIT_RESULTS);
        boolean roleUpdate = request.isUserInRole(OpusPrivilege.UPDATE_CARDINALTIMEUNIT_RESULTS);
        boolean roleDelete = request.isUserInRole(OpusPrivilege.DELETE_CARDINALTIMEUNIT_RESULTS);
        boolean roleEditHistoric = request.isUserInRole(OpusPrivilege.EDIT_HISTORIC_RESULTS);

        boolean authCreate;
        boolean authRead;
        boolean authUpdate;
        boolean authDelete;

        boolean ctuEditable = determineResultsInTimeUnitEditable(studyPlanCardinalTimeUnit, roleEditHistoric);

        CardinalTimeUnitResult cardinalTimeUnitResult = studyPlanCardinalTimeUnit.getCardinalTimeUnitResult();
        if (cardinalTimeUnitResult != null && cardinalTimeUnitResult.getId() != 0) {
            boolean isAssignedStudent = student != null && student.getStudentId() == studentManager.findStudentIdForStudyPlanCardinalTimeUnitId(cardinalTimeUnitResult.getStudyPlanCardinalTimeUnitId());
            authCreate = false; // result already exists, no need to create
            authUpdate = ctuEditable && roleUpdate;
            authRead = roleRead || (isAssignedStudent && studyPlanCardinalTimeUnit.isResultsPublished() && student.getHasMadeSufficientPayments());
            authDelete = ctuEditable && roleDelete;
        } else {
            authCreate = ctuEditable && roleCreate;
            authUpdate = false; // doesn't exist yet, so no update, read or delete possible
            authRead = false;
            authDelete = false;
        }

        Authorization authorization = new Authorization(authCreate, authRead, authUpdate, authDelete);
        return authorization;
    }

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForSubjectResults(List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<SubjectResult> subjectResults, HttpServletRequest request) {

		return determineAuthorizationForSubjectResults(null, allStudyPlanDetails, allStudyPlanCardinalTimeUnits, subjectResults, request);
		//        AuthorizationMap<AuthorizationSubExTest> authorizationMap = new AuthorizationMap<>();
//
//        Map<String, SubjectResult> subjectResultMap = DomainObjectMapCreator.makePropertiesToObjectMap(subjectResults, "studyPlanDetailId", "-", "subjectId");
//
//        SubjectResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forSubjects(request);
//
//        for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
//            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = DomainUtil.getDomainObjectById(allStudyPlanCardinalTimeUnits, studyPlanDetail.getStudyPlanCardinalTimeUnitId());
//            for (Subject subject : studyPlanDetail.getSubjects()) {
//                String key = studyPlanDetail.getId() + "-" + subject.getId();
//                AuthorizationSubExTest authorization = determineAuthorizationForSubExTestResult(studyPlanDetail, studyPlanCardinalTimeUnit,
//                    subjectResultMap.get(key), subject, resultPrivilegeFlags);
//                authorizationMap.put(key, authorization);
//            }
//        }
//
//        return authorizationMap;
    }

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForSubjectResults(Subject subject, List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<SubjectResult> subjectResults, HttpServletRequest request) {

        AuthorizationMap<AuthorizationSubExTest> authorizationMap = new AuthorizationMap<>();

        Map<String, SubjectResult> subjectResultMap = DomainObjectMapCreator.makePropertiesToObjectMap(subjectResults, "studyPlanDetailId", "-", "subjectId");

        SubjectResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forSubjects(request);

        for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = DomainUtil.getDomainObjectById(allStudyPlanCardinalTimeUnits, studyPlanDetail.getStudyPlanCardinalTimeUnitId());
//            for (Subject subject : studyPlanDetail.getSubjects()) {
            subjects(subject, studyPlanDetail).forEach(s -> {
                String key = studyPlanDetail.getId() + "-" + s.getId();
                AuthorizationSubExTest authorization = determineAuthorizationForSubExTestResult(studyPlanDetail, studyPlanCardinalTimeUnit,
                    subjectResultMap.get(key), s, resultPrivilegeFlags);
                authorizationMap.put(key, authorization);
            });
        }

        return authorizationMap;
    }

    /**
     * If given subject is not null, return a collection with only this subject. Otherwise return a collection containing 
     * all subjects of the given studyPlanDetail.
     */
	private List<Subject> subjects(Subject subject, StudyPlanDetail studyPlanDetail) {
		if (subject != null) {
			return Arrays.asList(subject);
		}
		
		return studyPlanDetail.getSubjects();
	}

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForExaminationResults(List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<ExaminationResult> resultAttempts, HttpServletRequest request) {

    	return determineAuthorizationForExaminationResults(null, allStudyPlanDetails, allStudyPlanCardinalTimeUnits, resultAttempts, request);

//        AuthorizationMap<AuthorizationSubExTest> authorizationMap = new AuthorizationMap<>();
//
//        Map<String, ExaminationResult> examinationResultMap = DomainObjectMapCreator.makePropertiesToObjectMap(resultAttempts,
//                "studyPlanDetailId", "-", "examinationId", "-", "attemptNr");
//        
//        ExaminationResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forExaminations(request);
//
//        for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
//            int studyPlanDetailId = studyPlanDetail.getId();
//            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = DomainUtil.getDomainObjectById(allStudyPlanCardinalTimeUnits, studyPlanDetail.getStudyPlanCardinalTimeUnitId());
//            for (Subject subject : studyPlanDetail.getSubjects()) {
//                for (Examination examination : subject.getExaminations()) {
//                    int examinationId = examination.getId();
//                    for (int i = 1; i <= examination.getNumberOfAttempts(); i++) {
//                        String key = studyPlanDetailId + "-" + examinationId + "-" + i;
//                        ExaminationResult examinationResult = examinationResultMap.get(key);
//                        List<IResultAttempt> selectedExaminationResults = findResults(resultAttempts, studyPlanDetailId, examinationId);
//                        AuthorizationSubExTest authorization = determineAuthorizationForMultipleAttemptResult(studyPlanDetail, studyPlanCardinalTimeUnit, selectedExaminationResults, examinationResult,
//                            examination, resultPrivilegeFlags);
//                        authorizationMap.put(key, authorization);
//                        if (examinationResult == null) {        // null if attemptNr doesn't exist -> only one new result can be created at a time -> break nrOrAttempts loop
//                            break;
//                        }
//                    }
//                }
//            }
//        }
//
//        return authorizationMap;
    }

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForExaminationResults(Examination ex, List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<ExaminationResult> resultAttempts, HttpServletRequest request) {

        AuthorizationMap<AuthorizationSubExTest> authorizationMap = new AuthorizationMap<>();

        Map<String, ExaminationResult> examinationResultMap = DomainObjectMapCreator.makePropertiesToObjectMap(resultAttempts,
                "studyPlanDetailId", "-", "examinationId", "-", "attemptNr");
        
        ExaminationResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forExaminations(request);

        for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
            int studyPlanDetailId = studyPlanDetail.getId();
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = DomainUtil.getDomainObjectById(allStudyPlanCardinalTimeUnits, studyPlanDetail.getStudyPlanCardinalTimeUnitId());
            examinations(ex, studyPlanDetail).forEach(examination -> {
//            for (Subject subject : studyPlanDetail.getSubjects()) {
//                for (Examination examination : subject.getExaminations()) {
                    int examinationId = examination.getId();
                    for (int i = 1; i <= examination.getNumberOfAttempts(); i++) {
                        String key = studyPlanDetailId + "-" + examinationId + "-" + i;
                        ExaminationResult examinationResult = examinationResultMap.get(key);
                        List<IResultAttempt> selectedExaminationResults = findResults(resultAttempts, studyPlanDetailId, examinationId);
                        AuthorizationSubExTest authorization = determineAuthorizationForMultipleAttemptResult(studyPlanDetail, studyPlanCardinalTimeUnit, selectedExaminationResults, examinationResult,
                            examination, resultPrivilegeFlags);
                        authorizationMap.put(key, authorization);
                        if (examinationResult == null) {        // null if attemptNr doesn't exist -> only one new result can be created at a time -> break nrOrAttempts loop
                            break;
                        }
                    }
            });
//                }
//            }
        }

        return authorizationMap;
    }

    /**
     * If given examination is not null, return a collection with only this examination. Otherwise return a collection containing 
     * all examinations of all subjects of the given studyPlanDetail.
     */
	private List<Examination> examinations(Examination examination, StudyPlanDetail studyPlanDetail) {
		if (examination != null) {
			return Arrays.asList(examination);
		}
		
		return studyPlanDetail.getSubjects().stream().flatMap(subject -> subject.getExaminations().stream()).collect(Collectors.toList());
	}

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForTestResults(List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<TestResult> resultAttempts, HttpServletRequest request) {

    	return determineAuthorizationForTestResults(null, allStudyPlanDetails, allStudyPlanCardinalTimeUnits, resultAttempts, request);
    }

    @Override
    public AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForTestResults(Test test,
    		List<StudyPlanDetail> allStudyPlanDetails, List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits,
    		List<TestResult> resultAttempts, HttpServletRequest request) {

    	AuthorizationMap<AuthorizationSubExTest> authorizationMap = new AuthorizationMap<>();
    	
    	Map<String, TestResult> testResultMap = DomainObjectMapCreator.makePropertiesToObjectMap(resultAttempts,
    			"studyPlanDetailId", "-", "testId", "-", "attemptNr");
    	
    	TestResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forTests(request);
    	
    	for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
    		int studyPlanDetailId = studyPlanDetail.getId();
    		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = DomainUtil.getDomainObjectById(allStudyPlanCardinalTimeUnits, studyPlanDetail.getStudyPlanCardinalTimeUnitId());

//    		for (Subject subject : studyPlanDetail.getSubjects()) {
//    			for (Examination examination : subject.getExaminations()) {
//    				for (Test t : examination.getTests()) {
    		tests(test, studyPlanDetail).forEach(t -> {
    					int testId = t.getId();
    					for (int i = 1; i <= t.getNumberOfAttempts(); i++) {
    						String key = studyPlanDetailId + "-" + testId + "-" + i;
    						TestResult testResult = testResultMap.get(key);
    						List<IResultAttempt> selectedTestResults = findResults(resultAttempts, studyPlanDetailId, testId);
    						AuthorizationSubExTest authorization = determineAuthorizationForMultipleAttemptResult(studyPlanDetail, studyPlanCardinalTimeUnit, selectedTestResults, testResult,
    								t, resultPrivilegeFlags);
    						authorizationMap.put(key, authorization);
    						if (testResult == null) {        // null if attemptNr doesn't exist -> only one new result can be created at a time -> break nrOrAttempts loop
    							break;
    						}
    					}
//    				}
//    			}
    		});
    	}
    	
    	return authorizationMap;
    }

    /**
     * If given test is not null, return a collection with only this test. Otherwise return a collection containing 
     * all tests of all examinations of all subjects of the given studyPlanDetail.
     */
	private List<Test> tests(Test test, StudyPlanDetail studyPlanDetail) {
		if (test != null) {
			return Arrays.asList(test);
		}
		
		return studyPlanDetail.getSubjects().stream()
				.flatMap(subject -> subject.getExaminations().stream())
				.flatMap(examination -> examination.getTests().stream())
				.collect(Collectors.toList());
	}


    /**
     * Find the results that match the given studyPlanDetailId and examinationId
     * @param allResultAttempt
     * @param studyPlanDetailId
     * @param subjectExamTestId
     * @return
     */
    private List<IResultAttempt> findResults(List<? extends IResultAttempt> allResultAttempt, int studyPlanDetailId, int subjectExamTestId) {
        List<IResultAttempt> resultAttempts = new ArrayList<>();

        for (IResultAttempt resultAttempt : allResultAttempt) {
            if (resultAttempt.getStudyPlanDetailId() == studyPlanDetailId && resultAttempt.getSubjectExamTestId() == subjectExamTestId) {
                resultAttempts.add(resultAttempt);
            }
        }

        return resultAttempts;
    }

    private int findHighestExistingAttemptNr(List<? extends IResultAttempt> results, int studyPlanDetailId, int subjectExamTestId) {
        int highestAttemptNr = 0;
        
        for (IResultAttempt result : results) {
            if (result.getStudyPlanDetailId() == studyPlanDetailId && result.getSubjectExamTestId() == subjectExamTestId) {
                if (result.getId() != 0 && result.getAttemptNr() > highestAttemptNr) {
                    highestAttemptNr = result.getAttemptNr();
                }
            }
        }
        
        return highestAttemptNr;
    }

    @Override
    public <T extends ISubjectExamTest> AuthorizationSubExTest determineAuthorizationForSubExTestResult(StudyPlanDetail studyPlanDetail, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, IResult result,
            T subjectExamTest, ResultPrivilegeFlags<T> resultPrivilegeFlags) {

//		TimeTrack timer = new TimeTrack("determineAuthorizationForSubExTestResult");

        // Check if logged in user is staff member or student, which implies specific privileges
        OpusUser opusUser = opusMethods.getOpusUser();
        StaffMember staffMember = opusUser.getStaffMember();
        Student student = opusUser.getStudent();
        studentManager.fillStudentBalanceInformation(student);

        boolean expiredAssigned = resultPrivilegeFlags.numberOfDaysAssignedHaveExpired(subjectExamTest);

        boolean roleCreate = resultPrivilegeFlags.isRoleCreate();
        boolean roleRead = resultPrivilegeFlags.isRoleRead();
        boolean roleUpdate = resultPrivilegeFlags.isRoleUpdate();
        boolean roleDelete = resultPrivilegeFlags.isRoleDelete();
        boolean roleCreateAssigned = resultPrivilegeFlags.isRoleCreateAssigned() && !expiredAssigned;
        boolean roleReadAssigned = resultPrivilegeFlags.isRoleReadAssigned();
        boolean roleUpdateAssigned = resultPrivilegeFlags.isRoleUpdateAssigned() && !expiredAssigned;
        boolean roleDeleteAssigned = resultPrivilegeFlags.isRoleDeleteAssigned() && !expiredAssigned;
        boolean roleReadOwn = resultPrivilegeFlags.isRoleReadOwn();
        boolean roleEditHistoric = resultPrivilegeFlags.isRoleEditHistoric();

        boolean authCreate;
        boolean authRead;
        boolean authUpdate;
        boolean authDelete;
        boolean isAssignedTeacher;
        boolean staffMemberLimitedToSelf;

        boolean ctuEditable = determineResultsInTimeUnitEditable(studyPlanCardinalTimeUnit, roleEditHistoric);

        // for exempted subjects don't allow creation of results
        boolean nonExempted = !studyPlanDetail.isExempted();

        if (result != null && result.getId() != 0) {
            // result exists
            isAssignedTeacher = isAssignedTeacher(result, staffMember);
            boolean isAssignedStudent = student != null && student.getStudentId() == studentManager.findStudentIdForStudyPlanDetailId(result.getStudyPlanDetailId());
            authCreate = false; // result already exists, no need to create
            // empty mark is a special case for generated failed results and should only be removed, not edited (they might have a comment like "excluded")
            authUpdate = StringUtils.isNotBlank(result.getMark()) && ctuEditable && (roleUpdate || (roleUpdateAssigned && isAssignedTeacher));
            authRead = roleRead || (roleReadAssigned && isAssignedTeacher) || (roleReadOwn && isAssignedStudent && studyPlanCardinalTimeUnit.isResultsPublished() && student.getHasMadeSufficientPayments());
            authDelete = ctuEditable && (roleDelete || (roleDeleteAssigned && isAssignedTeacher));
            staffMemberLimitedToSelf = !roleUpdate && authUpdate;    // only self can be chosen as teacher
//            timer.end("existing results");
        } else {
            // no result exists yet
            Integer classgroupId = studentManager.findStudentsClassgroupIdForStudyPlanDetailId(studyPlanDetail.getId());
            isAssignedTeacher = isAssignedTeacher(subjectExamTest, staffMember, classgroupId);
            authCreate = ctuEditable && nonExempted && (roleCreate || (roleCreateAssigned && isAssignedTeacher));
            authUpdate = false; // doesn't exist yet, so only the "create" privilege is of interest
            authRead = false;
            authDelete = false;
            staffMemberLimitedToSelf = !roleCreate && authCreate;
//            timer.end("no results");
        }

        AuthorizationSubExTest authorization = new AuthorizationSubExTest(authCreate, authRead, authUpdate, authDelete, staffMemberLimitedToSelf);
        return authorization;
    }

    /**
     * Results within CTU are editable if CTU status is "actively registered" and progress status is empty or "waiting for results" or user is eligible to edit historic results.
     * 
     * @param studyPlanCardinalTimeUnit
     * @return
     */
    private boolean determineResultsInTimeUnitEditable(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, boolean roleEditHistoric) {

        // NB: the check to edit historic results does not actually verify if the time unit is from the current year.
        //     This might still be an issue at some point.
        boolean ctuEditable = OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION.equals(studyPlanCardinalTimeUnit.getStudyPlan().getStudyPlanStatusCode())
                && OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED.equals(studyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())
                && (roleEditHistoric || studyPlanCardinalTimeUnit.isEmptyProgressStatus() || studyPlanCardinalTimeUnit.isProgressStatusWaitingForResults() );

        return ctuEditable;
    }

//    private boolean isPeriodExpiredForAssignedTeacher(ResultPrivilegeFlags resultPrivilegeFlags, ISubjectExamTest subjectExamTest) {
//
//        if (subjectExamTest instanceof IExamTest) {
//            return isPeriodExpiredForAssignedTeacher(resultPrivilegeFlags, (IExamTest) subjectExamTest);
//        }
//        
//        return false;
//    }

//    private boolean isPeriodExpiredForAssignedTeacher(ResultPrivilegeFlags resultPrivilegeFlags, IExamTest examTest) {
//
//        Integer numberOfDaysAssigned = resultPrivilegeFlags.getNumberOfDaysAssigned();
//        if (examTest.getAssessmentDate() != null && numberOfDaysAssigned != null) {
//            Date expiryDate = DateUtils.addDays(examTest.getAssessmentDate(), numberOfDaysAssigned);
//
//            // return true if today is later than the expiryDate
//            // time (hour, minute, etc.) is ignored in the comparison, only date part is taking into consideration
//            return  DateUtils.truncatedCompareTo(new Date(), expiryDate, Calendar.DAY_OF_MONTH) > 0;
//        }
//        
//        return false;
//    }

    /**
     * Test if the staffMember is assigned to the given subject, exam or test as a potential teacher.
     * @param subjectExamTest
     * @param staffMember
     * @param classgroupId
     * @return
     */
    private boolean isAssignedTeacher(ISubjectExamTest subjectExamTest, StaffMember staffMember, Integer classgroupId) {
        boolean isAssignedTeacher = staffMember != null && subjectExamTest.isAssignedTeacher(staffMember.getStaffMemberId(), classgroupId);
        return isAssignedTeacher;
    }

    /**
     * Test if the given staffMember is responsible for the given result, i.e. is the one who created the result.
     * @param result
     * @param staffMember
     * @return
     */
    private boolean isAssignedTeacher(IResult result, StaffMember staffMember) {
        boolean isAssignedTeacher = staffMember != null && result.getStaffMemberId() == staffMember.getStaffMemberId();
        return isAssignedTeacher;
    }

    @Override
    public <T extends ISubjectExamTest> AuthorizationSubExTest determineAuthorizationForMultipleAttemptResult(StudyPlanDetail studyPlanDetail, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, List<? extends IResultAttempt> resultAttempts, IResultAttempt resultAttempt,
            T subjectExamTest, ResultPrivilegeFlags<T> resultPrivilegeFlags) {

        AuthorizationSubExTest authorization = determineAuthorizationForSubExTestResult(studyPlanDetail, studyPlanCardinalTimeUnit, resultAttempt, subjectExamTest, resultPrivilegeFlags);

        if (resultAttempt != null && authorization.getDelete()) {    // check only for existing results that have delete flag set
            int highestExistingAttemptNr = findHighestExistingAttemptNr(resultAttempts, resultAttempt.getStudyPlanDetailId(), resultAttempt.getSubjectExamTestId());
    
            // only allow to delete the latest attempt that has a mark
            // that is:
            // - not e.g. the 1st result if a 2nd attempt exists
            // - not new results that weren't written to the DB yet
            if (resultAttempt.getAttemptNr() != highestExistingAttemptNr) {
                authorization.setDelete(false);
            }
        }

        return authorization;
    }

    @Override
    public boolean hasDeleteAuthorization(IResult result, Map<String, ? extends Authorization> authorizationMap) {
        Authorization authorization = resultUtil.getAuthorization(result, authorizationMap);
        return authorization != null && authorization.getDelete();
    }

    @Override
    public void assertDeleteAuthorization(IResult result, Map<String, ? extends Authorization> authorizationMap, String user) {
        if (!hasDeleteAuthorization(result, authorizationMap)) {
            securityLog.info("User '" + user + "' without required delete authorization attempted to delete result: " + result);
            throw new OpusSecurityException("No authorization to delete result");
        }
    }
    
    @Override
    public void assertDeleteAuthorization(CardinalTimeUnitResult cardinalTimeUnitResult, HttpServletRequest request) {
        if (!request.isUserInRole(OpusPrivilege.DELETE_CARDINALTIMEUNIT_RESULTS)) {
            securityLog.info("User '" + opusMethods.getWriteWho(request) + "' without required delete authorization attempted to delete result: " + cardinalTimeUnitResult);
            throw new OpusSecurityException("No authorization to delete result");
        }
    }

    @Override
    public AssessmentStructurePrivilege determineReadPrivilegesForAssessmentStructure(HttpServletRequest request, Subject subject) {
        
        // NB: This does not take into account yet if the subject itself is wihtin reach, e.g. if user is admin-D and assigned to a
        // different organizationalUnit than the subject
        
        AssessmentStructurePrivilege priv = new AssessmentStructurePrivilege();
       
        // Only implemented for logged in staffmember, otherwise don't give any privileges for now
        OpusUser opusUser = opusMethods.getOpusUser();
        StaffMember staffMember = opusUser.getStaffMember();
        
        boolean roleRead = request.isUserInRole(OpusPrivilege.READ_SUBJECTS_RESULTS);
        boolean roleReadAssigned = request.isUserInRole(OpusPrivilege.READ_RESULTS_ASSIGNED_SUBJECTS);
        
        // Note: classgroup is not supported in this method, would need to deal with classgroup e.g. by adding to where clause of generated report
        boolean access = hasAccess(subject, staffMember, roleRead, roleReadAssigned);
        priv.setSubjectAccess(access);
        
        for (Examination examination : subject.getExaminations()) {
            priv.putExaminationAccess(examination.getId(), hasAccess(examination, staffMember, roleRead, roleReadAssigned));

            for (Test test : examination.getTests()) {
                priv.putTestAccess(test.getId(), hasAccess(test, staffMember, roleRead, roleReadAssigned));
            }
        }
        
        return priv;
        
    }

    private boolean hasAccess(ISubjectExamTest subExTest, StaffMember staffMember, boolean roleRead, boolean roleReadAssigned) {
        boolean access = roleRead || (roleReadAssigned && isAssignedTeacher(subExTest, staffMember, null));
        return access;
    }

    
    @Override
	public boolean passCutOffPointContinuedRegistrationMaster(
			StudyPlan studyPlan,
			List<? extends Subject> subjects, List<? extends SubjectResult> subjectResults,
			BigDecimal scaledCutOffPoint, 
			int numberOfSubjectsPerCardinalTimeUnit,
			String gradeTypeCode, String preferredLanguage, String gender, 
			BigDecimal cntdRegistrationMasterCutOffPointCreditFemale, BigDecimal cntdRegistrationMasterCutOffPointCreditMale) {
        
        //float allMarksScore = 0;
        BigDecimal summedSubjectWeight = BigDecimal.ZERO;
        BigDecimal allGradesScore = BigDecimal.ZERO;
        
        if (subjectResults != null && subjectResults.size() > 0) {
            for (SubjectResult subjectResult : subjectResults) {
            	// find the subjectresult to take into account (failed ones should be left out)
                for (Subject subject : subjects) {
            		
            		if (subject.getId() == subjectResult.getSubjectId()) {
            			if (StringUtil.checkValidDouble(subjectResult.getMark()) != -1) {
	            			//double subjectMark = Double.parseDouble(subjectResult.getMark());
                            EndGrade endGrade = this.calculateEndGradeForMark(subjectResult.getMark(), gradeTypeCode, preferredLanguage,
                                    subject.getCurrentAcademicYearId());
	            			BigDecimal subjectResultGradePoint = endGrade.getGradePoint();
//	            			allGradesScore += subjectResultGradePoint * subject.getCreditAmount();
//				            summedSubjectWeight += subject.getCreditAmount();
                            allGradesScore = allGradesScore.add(subjectResultGradePoint.multiply(subject.getCreditAmount()));
                            summedSubjectWeight = summedSubjectWeight.add(subject.getCreditAmount());
			                
			                if (log.isDebugEnabled()) {
			                    log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: subjectresult mark: " + subjectResult.getMark()
			                            + ", subject credit amount: " + subject.getCreditAmount());
			                }
            			} else {
            				if (log.isDebugEnabled()) {
            	                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: mark is no double for subjectresult-id: " + subjectResult.getSubjectId()
            	                		+ ", namely: " + subjectResult.getMark());
            				}
            				return false;
            			}
            		}
            	}
                
            }
            if (log.isDebugEnabled()) {
                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: subjectResults.size(): " + subjectResults.size());
                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: summedSubjectWeight :  " + summedSubjectWeight);
                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: allGradesScore :  " + allGradesScore);
                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: scaledCutOffPoint :  " + scaledCutOffPoint);            
            }
            
            // Master asks for average score, not total, but credit amount per subject must be balanced
//            allGradesScore = (allGradesScore / summedSubjectWeight);
            allGradesScore = allGradesScore.divide(summedSubjectWeight, MC);

            // add female / male cut-off point extra:
            if ("2".equals(gender)) {
//                allGradesScore = allGradesScore + cntdRegistrationMasterCutOffPointCreditFemale;
            	allGradesScore = allGradesScore.add(cntdRegistrationMasterCutOffPointCreditFemale);
                if (log.isDebugEnabled()) {
                    log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: cntdRegistrationMasterCutOffPointCreditFemale = " + cntdRegistrationMasterCutOffPointCreditFemale + ", allGradesScore = " + allGradesScore);
                }
            }
            if ("1".equals(gender)) {
//            	allGradesScore = allGradesScore + cntdRegistrationMasterCutOffPointCreditMale;
                allGradesScore = allGradesScore.add(cntdRegistrationMasterCutOffPointCreditMale);
                if (log.isDebugEnabled()) {
                    log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: cntdRegistrationMasterCutOffPointCreditMale = " + cntdRegistrationMasterCutOffPointCreditMale + ", allGradesScore = " + allGradesScore);
                }
            }
            // trick - save at level of studyplan for sorting
            studyPlan.setAllGradesScore(allGradesScore);

            if (log.isDebugEnabled()) {
                log.debug("resultManager.passCutOffPointContinuedRegistrationMaster: allGradesScore after balance & division:  " + allGradesScore);
            }
//            return allGradesScore >= scaledCutOffPoint;
            return allGradesScore.compareTo(scaledCutOffPoint) >= 0;
        }
        return false;
    }

    public StudyPlanCardinalTimeUnit calculateProgressStatusForStudyPlanCardinalTimeUnit (
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,
            String preferredLanguage, 
            Locale currentLoc) {
        
        if (log.isDebugEnabled()) {
            log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit entered");
        }

        // call specific method for Zambia/Moz/.. to do calculations for this studyplancardinaltimeunit:
        ProgressCalculation progressCalculation = collegeServiceExtensions.getProgressCalculationExtension();
        progressCalculation.calculateProgressStatusForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, preferredLanguage, currentLoc);

        return studyPlanCardinalTimeUnit;
    }
    
    public void setExaminationManager(ExaminationManagerInterface examinationManager) {
        this.examinationManager = examinationManager;
    }

    public void setSubjectManager(SubjectManagerInterface subjectManager) {
        this.subjectManager = subjectManager;
    }

    public void setStudyManager(StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public void setStudentManager(StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public void setTestManager(TestManagerInterface testManager) {
        this.testManager = testManager;
    }

    @Override
    public List<AcademicYear> findAcademicYearsInStudyPlan(Map<String, Object> map) {
    	return academicYearMapper.findAcademicYearsInStudyPlan(map);
    }

    @Override
    public int getNumberOfDifferentSubjects(
            Collection<SubjectResult> subjectResults) {
        if (subjectResults == null) return 0;
        
        Set<Integer> subjectIds = new HashSet<>(subjectResults.size());
        subjectIds.addAll(DomainUtil.getIntProperties(subjectResults, "subjectId"));

        return subjectIds.size();
    }

    public AcademicYearManagerInterface getAcademicYearManager() {
        return academicYearManager;
    }

    public void setAcademicYearManager(AcademicYearManagerInterface academicYearManager) {
        this.academicYearManager = academicYearManager;
    }

    @Override
    public String getMinimumMarkValue(boolean endGradesPerGradeType, Study study) {
        String minimumMarkValue;
        if (!endGradesPerGradeType) {
            // mozambican situation
            minimumMarkValue = study.getMinimumMarkSubject();
        } else {
            // zambian situation
            minimumMarkValue = "0";
        }
        return minimumMarkValue;
    }

    @Override
    public String getMaximumMarkValue(boolean endGradesPerGradeType, Study study) {
        String maximumMarkValue;
        if (!endGradesPerGradeType) {
            // mozambican situation
            maximumMarkValue = study.getMaximumMarkSubject();
        } else {
            // zambian situation
            maximumMarkValue = "100";
        }
        return maximumMarkValue;
    }

    @Override
    public List<ExaminationResultComment> findExaminationResultComments(Map<String, Object> map) {
        return examinationResultCommentMapper.findExaminationResultComments(map);
    }

    @Override
    public List<TestResultComment> findTestResultComments(Map<String, Object> map) {
        return testResultCommentMapper.findTestResultComments(map);
    }

}
