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

package org.uci.opus.college.web.flow;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AuthorizationMap;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.result.TestResultComment;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.result.TestResultValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.TestResultsForm;
import org.uci.opus.college.web.util.exam.ResultsReportBuilder;
import org.uci.opus.college.web.util.exam.TestResultLine;
import org.uci.opus.college.web.util.exam.TestResultLines;
import org.uci.opus.college.web.util.exam.TestResultsBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping(TestResultsEditController.URL)
@SessionAttributes({ TestResultsEditController.FORM_NAME })
public class TestResultsEditController {

	public static final String URL = "/college/testresults";
	private final String viewName = "college/exam/testResults";
	public static final String FORM_NAME = "testResultsForm";

	private static Logger log = LoggerFactory.getLogger(TestResultsEditController.class);

	@Autowired
	private ApplicationContext context;

	@Autowired
	private SecurityChecker securityChecker;

	@Autowired
	private StudentManagerInterface studentManager;

	@Autowired
	private StudyManagerInterface studyManager;

	@Autowired
	private OpusMethods opusMethods;

	@Autowired
	private LookupCacher lookupCacher;

	@Autowired
	private SubjectManagerInterface subjectManager;

	@Autowired
	private ResultManagerInterface resultManager;

	@Autowired
	private StaffMemberManagerInterface staffMemberManager;

	@Autowired
	private ExaminationManagerInterface examinationManager;

	@Autowired
	private TestManagerInterface testManager;

	@Autowired
	private ResultsReportBuilder resultsReportBuilder;

	@InitBinder
	public void initBinder(ServletRequestDataBinder binder) {

		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		df.setLenient(false);
		binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
	}

	/**
	 * Creates a form backing object. If the request parameter "test_ID" is set,
	 * the specified staff member is read. Otherwise a new one is created.
	 */
	@RequestMapping(method = RequestMethod.GET)
	public String setupForm(HttpServletRequest request, ModelMap model) {
		TimeTrack timer = new TimeTrack("TestResultsEditController.setupForm");

		HttpSession session = request.getSession(false);
		securityChecker.checkSessionValid(session);
		opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

		TestResultsForm form = (TestResultsForm) model.get(FORM_NAME);
		if (form == null) {
			form = new TestResultsForm();
			model.put(FORM_NAME, form);

			NavigationSettings navigationSettings = new NavigationSettings();
			opusMethods.fillNavigationSettings(request, navigationSettings, null);
			form.setNavigationSettings(navigationSettings);

			String preferredLanguage = OpusMethods.getPreferredLanguage(request);
			Locale currentLoc = RequestContextUtils.getLocale(request);

			form.setCodeToStudyPlanStatusMap(
					new CodeToLookupMap(lookupCacher.getAllStudyPlanStatuses(preferredLanguage)));
			form.setCodeToExaminationTypeMap(
					new CodeToLookupMap(lookupCacher.getAllExaminationTypes(preferredLanguage)));

			List<TestResultComment> comments = resultManager.findTestResultComments(new HashMap<String, Object>());
			form.setTestResultComments(comments);
			timer.measure("test result comments");

			int testId = ServletUtil.getIntParam(request, "testId", 0);
			if (testId == 0) {
				throw new RuntimeException("testId not given");
			}

			Test test = testManager.findTest(testId);
			form.setTest(test);

			int examinationId = test.getExaminationId();
			Examination examination = examinationManager.findExamination(examinationId);
			form.setExamination(examination);

			int subjectId = examination.getSubjectId();
			Subject subject = subjectManager.findSubject(subjectId);
			form.setSubject(subject);

			// load logged in staff member
			OpusUser opusUser = opusMethods.getOpusUser();
			int staffMemberIdLoggedIn = 0;
			if (opusUser.getIsStaffMember()) {
				// StaffMember staffMember = opusUser.getStaffMember();
				// form.setStaffMember(staffMember);
				StaffMember staffMemberLoggedIn = opusUser.getStaffMember();
				form.setStaffMember(staffMemberLoggedIn);
				staffMemberIdLoggedIn = staffMemberLoggedIn.getStaffMemberId();
			}

			List<StaffMember> teachers = null;
			List<Integer> staffMemberIds = DomainUtil.getIntProperties(examination.getTeachersForExamination(),
					"staffMemberId");
			if (!staffMemberIds.isEmpty()) {
				Map<String, Object> staffMemberMap = new HashMap<>();
				staffMemberMap.put("staffMemberIds", staffMemberIds);
				teachers = staffMemberManager.findStaffMembers(staffMemberMap);
			}
			form.setTeachers(teachers);
			form.setIdToTestTeacherMap(new IdToStaffMemberMap(teachers));
			timer.measure("staff members");

			Map<String, Object> findClassgroupsMap = new HashMap<>();
			findClassgroupsMap.put("subjectId", subjectId);
			List<Classgroup> classgroups = studyManager.findClassgroups(findClassgroupsMap);
			form.setAllClassgroups(classgroups);
			timer.measure("classgroups");

			Integer classgroupId = ServletUtil.getIntObject(request, "classgroupId");

			if (classgroupId == null && !classgroups.isEmpty()) {
				findClassgroupsMap.put("staffMemberId", staffMemberIdLoggedIn);
				List<Classgroup> classGroupsforStaffMember = studyManager.findClassgroups(findClassgroupsMap);

				if (!classGroupsforStaffMember.isEmpty()) {
					Classgroup cg = classGroupsforStaffMember.get(0);
					classgroupId = cg.getId();
				} else {
					classgroupId = classgroups.get(0).getId();
				}

			}

			if (classgroupId != null) {
				form.setClassgroupId(classgroupId);

			}

			// BRs PASSING:
			Study study = studyManager.findStudy(subject.getPrimaryStudyId());

			String brsPassing = testManager.getBRsPassingTest(test);
			// if (!StringUtils.isBlank(test.getBRsPassingTest())) {
			// brsPassing = test.getBRsPassingTest();
			// } else if
			// (!StringUtils.isBlank(examination.getBRsPassingExamination())) {
			if (StringUtils.isBlank(brsPassing)) {
				brsPassing = examination.getBRsPassingExamination();
			}
			// } else {
			if (StringUtils.isBlank(brsPassing)) {
				brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
			}
			form.setBrsPassing(brsPassing);

			// MINIMUM and MAXIMUM GRADE:
			// see if the endGrades are defined on studygradetype level:
			String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
			if (StringUtils.isEmpty(endGradesPerGradeType)) {
				// mozambican situation
				form.setMinimumMarkValue(study.getMinimumMarkSubject());
				form.setMaximumMarkValue(study.getMaximumMarkSubject());
			} else {
				// zambian situation
				form.setMinimumMarkValue("0");
				form.setMaximumMarkValue("100");
			}

			// STUDY PLAN DETAILS:
			Map<String, Object> findStudyPlanDetails = new HashMap<>();
			findStudyPlanDetails.put("subjectId", subjectId);
			findStudyPlanDetails.put("classgroupId", classgroupId);
			findStudyPlanDetails.put("cardinalTimeUnitStatusCode",
					OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
			List<StudyPlanDetail> allStudyPlanDetails = studentManager
					.findStudyPlanDetailsByParams(findStudyPlanDetails);
			timer.measure("studyPlanDetails");

			// TEST RESULTS:
			List<TestResult> allTestResults = resultManager.findTestResults(testId);
			timer.measure("test results");

			TestResultsBuilder rb = context.getBean(TestResultsBuilder.class);
			rb.setTest(test);
			rb.setAllStudyPlanDetails(allStudyPlanDetails);
			rb.setAllTestResults(allTestResults);
			rb.build();
			TestResultLines resultLines = rb.getResultLines();
			form.setAllLines(resultLines);
			timer.measure("results builder");

			if (!allStudyPlanDetails.isEmpty()) {
				List<Integer> studyPlanCardinalTimeUnitIds = DomainUtil.getIntProperties(allStudyPlanDetails,
						"studyPlanCardinalTimeUnitId");
				List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager
						.findStudyPlanCardinalTimeUnits(studyPlanCardinalTimeUnitIds);
				studentManager.setResultsPublished(allStudyPlanCardinalTimeUnits);

				AuthorizationMap<AuthorizationSubExTest> testResultAuthorizationMap = resultManager
						.determineAuthorizationForTestResults(test, allStudyPlanDetails, allStudyPlanCardinalTimeUnits,
								(List<TestResult>) rb.getAllResultsOfLines(), request);
				form.setTestResultAuthorizationMap(testResultAuthorizationMap);

				// see also comment in ExaminationResultsEditController:
				// authorization logic should move from form to ResultLines
				resultLines.setResultAuthorizationMap(testResultAuthorizationMap);

				// determine rights to read - and hence create report for -
				// every part of the assessment structure
				form.setAssessmentStructurePrivilege(
						resultManager.determineReadPrivilegesForAssessmentStructure(request, subject));
				timer.measure("authorizations");
			}

		}

		timer.end();
		return viewName;

	}

	@RequestMapping("/classgroup")
	public String classgroupChanged(@ModelAttribute(FORM_NAME) TestResultsForm form) {
		return redirectUrl(form);
	}

	/**
	 * Saves the new or updated test results.
	 * 
	 * @throws ParseException
	 */
	@Transactional
	@RequestMapping(method = RequestMethod.POST)
	public String processSubmit(HttpServletRequest request, SessionStatus sessionStatus,
			@ModelAttribute(FORM_NAME) TestResultsForm form, BindingResult bindingResult) {

		HttpSession session = request.getSession(false);
		securityChecker.checkSessionValid(session);

		if (form.getAllLines() == null) {
			return viewName;
		}

		TestResultValidator resultValidator = new TestResultValidator(form.getMinimumMarkValue(),
				form.getMaximumMarkValue(), opusMethods.getOpusUser());

		log.info("Saving results for test " + form.getTest());
		TestResultLines lines = form.getAllLines();
		lines.saveAllResults(resultValidator, bindingResult, resultManager, request);

		if (bindingResult.hasErrors()) {
			return viewName;
		}

		sessionStatus.setComplete();

		return redirectUrl(form);
	}

	private String redirectUrl(TestResultsForm form) {
		Test test = form.getTest();
		NavigationSettings navigationSettings = form.getNavigationSettings();
		return "redirect:/college/testresults.view?newForm=true" + "&testId=" + test.getId()
				+ (form.getClassgroupId() == null ? "" : "&classgroupId=" + form.getClassgroupId())
				+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber() + "&tab="
				+ navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel();
	}

	@RequestMapping(value = "/pdfSubjectResults/{format}")
	public ModelAndView pdfSubjectResults(HttpServletRequest request, @PathVariable("format") String format,
			@ModelAttribute(FORM_NAME) TestResultsForm form) {

		return resultsReportBuilder.subjectResults(request, form.getAssessmentStructurePrivilege(),
				form.getSubject().getId(), form.getClassgroupId(), format);
	}

	@RequestMapping(value = "/pdfExaminationResults/{examinationId}/{format}")
	public ModelAndView pdfExaminationResults(HttpServletRequest request,
			@PathVariable("examinationId") int examinationId, @PathVariable("format") String format,
			@ModelAttribute(FORM_NAME) TestResultsForm form) {

		return resultsReportBuilder.examinationResults(request, form.getAssessmentStructurePrivilege(), examinationId,
				form.getClassgroupId(), format);
	}

	@RequestMapping(value = "/pdfTestResults/{testId}/{format}")
	public ModelAndView pdfTestResults(HttpServletRequest request, @PathVariable("testId") int testId,
			@PathVariable("format") String format, @ModelAttribute(FORM_NAME) TestResultsForm form) {

		return resultsReportBuilder.testResults(request, form.getAssessmentStructurePrivilege(), testId,
				form.getClassgroupId(), format);
	}

	@RequestMapping(method = RequestMethod.POST, params = "deleteAll")
	public String deleteAll(HttpServletRequest request, SessionStatus sessionStatus,
			@ModelAttribute(FORM_NAME) TestResultsForm form, BindingResult bindingResult) {

		log.info("attempting to delete all test results");

		// looping all lines
		for (TestResultLine line : form.getAllLines()) {

			// looping the attempts
			for (int i = 0; i < line.getResults().size(); i++) {
				TestResult testResult = line.getResults().get(i);
				String key = testResult.getStudyPlanDetailId() + "-" + testResult.getTestId() + "-" + (i + 1);
				if (form.getTestResultAuthorizationMap().get(key).getDelete()) {
					resultManager.deleteTestResult(testResult.getId(), opusMethods.getWriteWho(request));
				}
			}
		}

		return redirectUrl(form);
	}

}
