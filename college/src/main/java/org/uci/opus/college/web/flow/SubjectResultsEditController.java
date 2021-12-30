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

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.SubjectResultCommentMapper;
import org.uci.opus.college.service.EndGradeManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.result.ResultUtil;
import org.uci.opus.college.service.result.SubjectResultGenerator;
import org.uci.opus.college.validator.MarkValidator;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.SubjectResultsForm;
import org.uci.opus.college.web.util.exam.ResultsReportBuilder;
import org.uci.opus.college.web.util.exam.SubjectResultLine;
import org.uci.opus.college.web.util.exam.SubjectResultLines;
import org.uci.opus.college.web.util.exam.SubjectResultsBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

/**
 * 
 * @author markus
 *
 */
@Controller
@RequestMapping("/college/subjectresults")
@SessionAttributes({ SubjectResultsEditController.FORM_NAME })
public class SubjectResultsEditController {

	private final String viewName = "college/exam/subjectResults";

	public static final String FORM_NAME = "subjectResultsForm";
	private static Logger log = LoggerFactory.getLogger(SubjectResultsEditController.class);

	@Autowired
	private ApplicationContext context;

	@Autowired
	private CollegeWebExtensions collegeWebExtensions;
	@Autowired
	private EndGradeManagerInterface endGradeManager;
	@Autowired
	private LookupCacher lookupCacher;
	@Autowired
	private OpusMethods opusMethods;
	@Autowired
	private PersonManagerInterface personManager;
	@Autowired
	private ResultManagerInterface resultManager;
	@Autowired
	private SecurityChecker securityChecker;
	@Autowired
	private StaffMemberManagerInterface staffMemberManager;
	@Autowired
	private StudentManagerInterface studentManager;
	@Autowired
	private StudyManagerInterface studyManager;
	@Autowired
	private SubjectManagerInterface subjectManager;
	@Autowired
	private ResultUtil resultUtil;
	@Autowired
	private ResultsReportBuilder resultsReportBuilder;
	
	@Autowired
	private SubjectResultCommentMapper subjectResultCommentMapper;

	/**
	 * Adds a property editor for dates to the binder.
	 * 
	 * @see org.springframework.web.servlet.mvc.BaseCommandController
	 *      #initBinder(javax.servlet.http.HttpServletRequest ,
	 *      org.springframework.web.bind.ServletRequestDataBinder)
	 */
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		df.setLenient(false);
		binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
	}

	@RequestMapping(method = RequestMethod.GET)
	public String setupForm(ModelMap model, HttpServletRequest request) {

		if (log.isDebugEnabled()) {
			log.debug("SubjectResultsEditController.setupForm started...");
		}
		// declare variables
		HttpSession session = request.getSession(false);
		Subject subject = null;
		Study study = null;
		List<SubjectResult> allSubjectResults = null;
		List<StudyPlanDetail> allStudyPlanDetails = null;
		String brsPassing = "";
		/* extra - attachment results */
		List<? extends EndGrade> allEndGrades = null;

		securityChecker.checkSessionValid(session);
		opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
		session.setAttribute("menuChoice", "exams");

		SubjectResultsForm form = (SubjectResultsForm) model.get(FORM_NAME);
		if (form == null) {
			TimeTrack timer = new TimeTrack("SubjectResultsEditController.setupForm");
			form = new SubjectResultsForm();
			model.put(FORM_NAME, form);

			NavigationSettings navigationSettings = new NavigationSettings();
			opusMethods.fillNavigationSettings(request, navigationSettings, null);
			form.setNavigationSettings(navigationSettings);

			String preferredLanguage = OpusMethods.getPreferredLanguage(request);
			Locale currentLoc = RequestContextUtils.getLocale(request);

			form.setCodeToStudyPlanStatusMap(
					new CodeToLookupMap(lookupCacher.getAllStudyPlanStatuses(preferredLanguage)));
			form.setIdToSubjectResultCommentMap(new IdToObjectMap<>(subjectResultCommentMapper.findSubjectResultComments(new HashMap<>())));

			int subjectId = ServletUtil.getIntParam(request, "subjectId", 0);
			if (subjectId == 0) {
				throw new RuntimeException("subjectId not given");
			}

			int studyId = ServletUtil.getIntParam(request, "studyId", 0);

			// load logged in staff member
			OpusUser opusUser = opusMethods.getOpusUser();
			int staffMemberIdLoggedIn = 0;
			if (personManager.isStaffMember(opusUser.getPersonId())) {

				StaffMember staffMemberLoggedIn = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
				form.setStaffMember(staffMemberLoggedIn);
				staffMemberIdLoggedIn = staffMemberLoggedIn.getStaffMemberId();
			}

			// SUBJECT
			subject = subjectManager.findSubject(subjectId);
			form.setSubject(subject);

			List<StaffMember> teachers = null;
			List<Integer> staffMemberIds = DomainUtil.getIntProperties(subject.getSubjectTeachers(), "staffMemberId");
			if (!staffMemberIds.isEmpty()) {
				Map<String, Object> staffMemberMap = new HashMap<>();
				staffMemberMap.put("staffMemberIds", staffMemberIds);
				teachers = staffMemberManager.findStaffMembers(staffMemberMap);
			}
			form.setTeachers(teachers);
			form.setIdToSubjectTeacherMap(new IdToStaffMemberMap(teachers));

			Map<String, Object> findClassgroupsMap = new HashMap<>();
			findClassgroupsMap.put("subjectId", subjectId);
			List<Classgroup> classgroups = studyManager.findClassgroups(findClassgroupsMap);
			form.setAllClassgroups(classgroups);

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
			timer.measure("begin");

			// STUDY:
			if (studyId == 0) {
				studyId = subjectManager.findSubjectPrimaryStudyId(subjectId);
			}
			study = studyManager.findStudy(studyId);

			// BRS passing:
			brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
			form.setBrsPassing(brsPassing);

			// MINIMUM and MAXIMUM GRADE:
			// see if the endGrades are defined on studygradetype level:
			String endGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
			boolean endGradesPerGradeType = endGradeType != null && !endGradeType.isEmpty();
			form.setEndGradesPerGradeType(endGradesPerGradeType);

			if (!endGradesPerGradeType) {
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
			findStudyPlanDetails.put("academicYearId", subject.getCurrentAcademicYearId());
			findStudyPlanDetails.put("cardinalTimeUnitStatusCode",
					OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);

			allStudyPlanDetails = studentManager.findStudyPlanDetailsByParams(findStudyPlanDetails);
			// SUBJECT RESULTS:
			allSubjectResults = resultManager.findSubjectResults(subjectId);
			timer.measure("findStudyPlanDetailsByParams, findSubjectResults");

			if (endGradesPerGradeType) {
				// load all endGrades that are referenced by the subjectResults
				// (to minimize loading from DB)
				List<String> endGradeCodes = DomainUtil.getStringProperties(allSubjectResults, "endGradeComment"); // TODO
																													// endGradeComment
																													// should
																													// really
																													// be
																													// called
																													// endGradeCode
				Map<String, Object> endGradesMap = new HashMap<>();
				endGradesMap.put("codes", endGradeCodes);
				endGradesMap.put("academicYearId", subject.getCurrentAcademicYearId());
				endGradesMap.put("lang", preferredLanguage);
				allEndGrades = endGradeManager.findEndGrades(endGradesMap);
			}

			// CURRENT DATE:
			Date dateNow = new Date();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			df.setLenient(false);
			String dateNowString = df.format(dateNow); // TODO instead of
														// dateNowString use
														// <fmt:formatDate> with
														// pattern like "dd",
														// "MM", "yyyy"
			form.setDateNow(dateNowString);

			// Use ResultFormatters to fill up ctuResult and subjectResult
			// objects in the for loop
			// Use ResultFormatter to fill up subjectResult objects in the for
			// loop
			SubjectResultFormatter subjectResultFormatter = collegeWebExtensions.getSubjectResultFormatter();
			form.setSubjectResultFormatter(subjectResultFormatter);

			Collection<String> endGradeTypeCodes = new HashSet<>(); // remember
																	// different
																	// kinds of
																	// endGradeTypeCodes

			// fetch additional subjectResult related data to make it available
			// in the subjectResult objects
			if (allSubjectResults != null && allSubjectResults.size() != 0) {
				for (SubjectResult subjectResult : allSubjectResults) {

					// determine gradeTypeCode
					String gradeTypeCode;
					if (OpusConstants.ATTACHMENT_RESULT.equals(subject.getResultType())) {
						gradeTypeCode = OpusConstants.ATTACHMENT_RESULT;
						subjectResult.setEndGradeTypeCode(gradeTypeCode); // override
																			// studyGradeType.gradeTypeCode
																			// which
																			// is
																			// loaded
																			// in
																			// resultMap
					} else {
						gradeTypeCode = subjectResult.getEndGradeTypeCode();
					}
					endGradeTypeCodes.add(gradeTypeCode);

					// load additional info
					subjectResultFormatter.loadAdditionalInfo(subjectResult, gradeTypeCode, preferredLanguage);
				}
			}
			timer.measure("additional info");

			endGradeTypeCodes = new ArrayList<>(endGradeTypeCodes); // convert
																	// set to
																	// list
																	// because
																	// iBatis
																	// requires
																	// a list

			if (endGradesPerGradeType) {

				// find comments for SubjectResult's endgradetype:
				Map<String, Object> studyGradeTypeEndGradeMap = new HashMap<>();
				studyGradeTypeEndGradeMap.put("preferredLanguage", preferredLanguage);
				studyGradeTypeEndGradeMap.put("academicYearId", subject.getCurrentAcademicYearId());

				// MP 2013-09: instead of a specific endGradeTypeCode,
				// which doesn't make sense because there can be several SGTs
				// per subject
				// we need to use the gradeTypeCode that corresponds to the
				// studyGradeType referenced by studyPlanDetail (or
				// subject.resultType)
				studyGradeTypeEndGradeMap.put("endGradeTypeCodes", endGradeTypeCodes);
				Map<String, List<EndGrade>> endGradeTypeCodeToFailGradesMap = studyManager
						.findEndGradeTypeCodeToFullFailGradesMap(studyGradeTypeEndGradeMap);
				form.setEndGradeTypeCodeToFailGradesMap(endGradeTypeCodeToFailGradesMap);

			}

			// SubjectResultsBuilder srb = new
			// SubjectResultsBuilder(opusInit.getPreferredPersonSorting());
			SubjectResultsBuilder srb = context.getBean(SubjectResultsBuilder.class);
			srb.setSubject(subject);
			srb.setAllStudyPlanDetails(allStudyPlanDetails);
			srb.setAllSubjectResults(allSubjectResults);
			srb.setAllEndGrades(allEndGrades);
			srb.build();
			form.setAllLines(srb.getResultLines());
			timer.measure("subject result lines");

			if (!allStudyPlanDetails.isEmpty()) {
				List<Integer> studyPlanCardinalTimeUnitIds = DomainUtil.getIntProperties(allStudyPlanDetails,
						"studyPlanCardinalTimeUnitId");
				List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager
						.findStudyPlanCardinalTimeUnits(studyPlanCardinalTimeUnitIds);
				studentManager.setResultsPublished(allStudyPlanCardinalTimeUnits);
//				long start = System.currentTimeMillis();
				Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap = resultManager
						.determineAuthorizationForSubjectResults(subject, allStudyPlanDetails, allStudyPlanCardinalTimeUnits,
								(List<SubjectResult>) srb.getAllResultsOfLines(), request);
//				log.info("time to determine privileges: " + (System.currentTimeMillis() - start) + " ms");
				form.setSubjectResultAuthorizationMap(subjectResultAuthorizationMap);

				// determine rights to read - and hence create report for -
				// every part of the assessment structure
				form.setAssessmentStructurePrivilege(
						resultManager.determineReadPrivilegesForAssessmentStructure(request, subject));
			}
			timer.end("determineAuthorizationForSubjectResults");
		}

		return viewName;
	}

	@RequestMapping("/classgroup")
	public String classgroupChanged(@ModelAttribute(FORM_NAME) SubjectResultsForm form) {
		return redirectUrl(form);
	}

	@Transactional
	@RequestMapping(method = RequestMethod.POST)
	public String processSubmit(HttpServletRequest request, SessionStatus sessionStatus,
			@ModelAttribute(FORM_NAME) SubjectResultsForm subjectResultsForm, BindingResult result, ModelMap model) {

		if (log.isDebugEnabled()) {
			log.debug("SubjectResultsEditController.processSubmit started...");
		}
		HttpSession session = request.getSession(false);
		securityChecker.checkSessionValid(session);

		Subject subject = subjectResultsForm.getSubject();
		if (subjectResultsForm.getAllLines() == null) {
			return viewName;
		}

		MarkValidator markValidator = new MarkValidator(subjectResultsForm.getMinimumMarkValue(),
				subjectResultsForm.getMaximumMarkValue());
		List<SubjectResultLine> subjectResultLines = new ArrayList<>();

		for (int i = 0; i < subjectResultsForm.getAllLines().size(); i++) {
			SubjectResultLine subjectResultLine = (SubjectResultLine) subjectResultsForm.getAllLines().get(i);
			SubjectResult subjectResult = subjectResultLine.getSubjectResult();
			int subjectResultId = subjectResult.getId();

			String mark = subjectResult.getMark();

			// This line can be ignored if no data was entered: ie. new result
			// && no mark entered
			// - ignore teacher because when only one teacher then always
			// automatically selected
			boolean ignore = subjectResultId == 0 && StringUtil.isNullOrEmpty(mark, true);
			if (ignore) {
				continue; // ignore this line and go to next line
			}

			// -- Validation --

			result.pushNestedPath("allLines[" + i + "].subjectResult");

			// Validate: Mark correct?
			markValidator.validate(mark, result);

			if (subjectResult.getStaffMemberId() == 0) {
				result.rejectValue("staffMemberId", "jsp.error.no.chosen.staffmember");
			}

			result.popNestedPath(); // end of validation of this line

			subjectResultLines.add(subjectResultLine); // store the ones that
														// haven't been ingored
		}

		if (result.hasErrors()) {
			return viewName;
		}

		// store to DB
		for (SubjectResultLine subjectResultLIne : subjectResultLines) {
			SubjectResult subjectResultInDB = resultManager
					.findSubjectResult(subjectResultLIne.getSubjectResult().getId()); // TODO
																						// this
																						// should
																						// be
																						// in
																						// the
																						// resultLine
																						// to
																						// be
																						// shown
																						// in
																						// screen
			resultManager.saveSubjectResultIfModified(request, subjectResultLIne.getSubjectResult(), subjectResultInDB,
					subject.getCurrentAcademicYearId(), subjectResultLIne.getResultGenerator());
		}

		sessionStatus.setComplete();

		return redirectUrl(subjectResultsForm);
	}

	private String redirectUrl(SubjectResultsForm form) {
		Subject subject = form.getSubject();
		NavigationSettings navigationSettings = form.getNavigationSettings();
		return "redirect:/college/subjectresults.view?newForm=true" + "&subjectId=" + subject.getId()
				+ (form.getClassgroupId() == null ? "" : "&classgroupId=" + form.getClassgroupId())
				+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber() + "&tab="
				+ navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel();
	}

	@RequestMapping(method = RequestMethod.GET, params = "generate")
	public String generateSubjectResult(@RequestParam("generate") int i, SubjectResultsForm subjectResultsForm,
			BindingResult result, HttpServletRequest request, ModelMap model) {

		String preferredLanguage = OpusMethods.getPreferredLanguage(request);

		// Find the respective SubjectResult to set the mark
		SubjectResultLine line = subjectResultsForm.getAllLines().get(i);
		SubjectResult subjectResult = ((SubjectResultLine) line).getSubjectResult();
		// int studyPlanDetailId = subjectResult.getStudyPlanDetailId();

		result.pushNestedPath("allLines[" + i + "].subjectResult");
		// only set mark into form object, don't store, because maybe no teacher
		// chosen yet
		SubjectResultGenerator resultGenerator = resultManager.generateSubjectResultMark(subjectResult,
				preferredLanguage, result);
		line.setResultGenerator(resultGenerator);
		result.popNestedPath();

		if (result.hasErrors()) {
			return viewName;
		}

		// subjectResult.setMark(mark);

		return viewName;
	}

	/**
	 * Try to generate a result for all lines that have no result yet and where
	 * lower level results exist.
	 * 
	 * @param subjectResultsForm
	 * @param result
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, params = "generateAll")
	public String generateAllSubjectResults(SubjectResultsForm subjectResultsForm, BindingResult result,
			HttpServletRequest request, ModelMap model) {

		String preferredLanguage = OpusMethods.getPreferredLanguage(request);
		Map<String, AuthorizationSubExTest> authorizationMap = subjectResultsForm.getSubjectResultAuthorizationMap();

		for (int i = 0; i < subjectResultsForm.getAllLines().size(); i++) {
			SubjectResultLine subjectResultLine = (SubjectResultLine) subjectResultsForm.getAllLines().get(i);
			SubjectResult subjectResult = subjectResultLine.getSubjectResult();

			// Only generate if has create privilege (same condition as in jsp)
			AuthorizationSubExTest authorization = (AuthorizationSubExTest) resultUtil.getAuthorization(subjectResult,
					authorizationMap);
			if (!authorization.getCreate()) {
				continue;
			}

			// int studyPlanDetailId = subjectResult.getStudyPlanDetailId();
			if (subjectResult.getId() == 0 && subjectResultLine.getExaminationResultsFound()) {
				result.pushNestedPath("allLines[" + i + "].subjectResult");
				SubjectResultGenerator resultGenerator = resultManager.generateSubjectResultMark(subjectResult,
						preferredLanguage, result);
				subjectResultLine.setResultGenerator(resultGenerator);
				result.popNestedPath();

				// if (!result.hasFieldErrors("allLines[" + i +
				// "].subjectResult.mark")) {
				// subjectResult.setMark(mark);
				// }
			}
		}

		return viewName;
	}

	@RequestMapping(method = RequestMethod.POST, params = "adjustAll")
	public String adjustAllSubjectResults(SubjectResultsForm subjectResultsForm, BindingResult result,
			HttpServletRequest request, ModelMap model) {

		String adjustmentMark = subjectResultsForm.getAdjustmentMark();
		if (StringUtil.checkValidDouble(adjustmentMark) == -1) {
			result.rejectValue("adjustmentMark", "jsp.error.adjustmentmark.format");
		}

		if (result.hasErrors()) {
			return viewName;
		}

		BigDecimal adjustmentMarkDecimal = new BigDecimal(adjustmentMark);
		for (SubjectResultLine line : subjectResultsForm.getAllLines()) {
			SubjectResult subjectResult = ((SubjectResultLine) line).getSubjectResult();
			String mark = subjectResult.getMark();
			if (StringUtil.checkValidDouble(mark) == 1) {
				BigDecimal markDecimal = new BigDecimal(mark);
				BigDecimal adjustedMark = markDecimal.add(adjustmentMarkDecimal);
				subjectResult.setMark(adjustedMark.toString());
			}
		}

		return viewName;
	}

	// @Transactional
	// @RequestMapping(method=RequestMethod.GET, params = "delete=true")
	@RequestMapping(value = "/delete/{lineIdx}")
	public String deleteSubjectResult(// @RequestParam("subjectResultId") int
										// subjectResultId,
			@PathVariable("lineIdx") int lineIdx, SubjectResultsForm subjectResultsForm, BindingResult bindingResult,
			HttpServletRequest request, ModelMap model) {

		SubjectResultLines allLines = subjectResultsForm.getAllLines();
		SubjectResult subjectResult = allLines.getResult(lineIdx, 0);

		// Assert authorization
		Map<String, AuthorizationSubExTest> authorizationMap = subjectResultsForm.getSubjectResultAuthorizationMap();
		String writeWho = opusMethods.getWriteWho(request);
		resultManager.assertDeleteAuthorization(subjectResult, authorizationMap, writeWho);

		bindingResult.pushNestedPath("allLines[" + lineIdx + "].subjectResult");
		StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(subjectResult.getStudyPlanDetailId());

		// subject Result cannot be deleted if examination results are present
		Map<String, Object> map = new HashMap<>();
		map.put("studyPlanCardinalTimeUnitId", studyPlanDetail.getStudyPlanCardinalTimeUnitId());
		CardinalTimeUnitResult ctuResult = resultManager.findCardinalTimeUnitResultByParams(map);
		if (ctuResult != null && !StringUtil.isEmpty(ctuResult.getMark(), true)) {
			// bindingResult.reject("jsp.error.subjectresult.delete");
			bindingResult.rejectValue("mark", "general.exists.cardinaltimeunitresult");
		}
		bindingResult.popNestedPath();

		if (bindingResult.hasErrors()) {
			return viewName;
		}

		resultManager.deleteSubjectResult(subjectResult.getId(), writeWho);

		NavigationSettings navigationSettings = subjectResultsForm.getNavigationSettings();
		Subject subject = subjectResultsForm.getSubject();

		return "redirect:/college/subjectresults.view?newForm=true" + "&subjectId=" + subject.getId()
				+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber() + "&tab="
				+ navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel();
	}

	@RequestMapping(value = "/subjectResults/{format}")
	public ModelAndView subjectResults(HttpServletRequest request, @PathVariable("format") String format,
			@ModelAttribute(FORM_NAME) SubjectResultsForm form) {

		return resultsReportBuilder.subjectResults(request, form.getAssessmentStructurePrivilege(),
				form.getSubject().getId(), form.getClassgroupId(), format);
	}

	@RequestMapping(value = "/examinationResults/{examinationId}/{format}")
	public ModelAndView examinationResults(HttpServletRequest request, @PathVariable("examinationId") int examinationId,
			@PathVariable("format") String format, @ModelAttribute(FORM_NAME) SubjectResultsForm form,
			BindingResult result, ModelMap model) {

		return resultsReportBuilder.examinationResults(request, form.getAssessmentStructurePrivilege(), examinationId,
				form.getClassgroupId(), format);
	}

	@RequestMapping(value = "/testResults/{testId}/{format}")
	public ModelAndView testResults(HttpServletRequest request, @PathVariable("testId") int testId,
			@PathVariable("format") String format, @ModelAttribute(FORM_NAME) SubjectResultsForm form) {

		return resultsReportBuilder.testResults(request, form.getAssessmentStructurePrivilege(), testId,
				form.getClassgroupId(), format);
	}

}
