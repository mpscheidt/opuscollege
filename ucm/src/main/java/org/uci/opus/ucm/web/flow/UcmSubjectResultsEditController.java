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

package org.uci.opus.ucm.web.flow;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManager;
import org.uci.opus.college.service.EndGradeManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.MarkValidator;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.college.web.util.exam.SubjectResultLine;
import org.uci.opus.college.web.util.exam.SubjectResultsBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.ucm.domain.StudentResult;
import org.uci.opus.ucm.service.UCMManagerInterface;
import org.uci.opus.ucm.util.FiltersHelper;
import org.uci.opus.ucm.util.StudentsResultsHandler;
import org.uci.opus.ucm.validator.SubjectResultsFormValidator;
import org.uci.opus.ucm.web.form.SubjectResultsForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/ucm/subjectresults.view")
@SessionAttributes({UcmSubjectResultsEditController.FORM_NAME})
public class UcmSubjectResultsEditController {

    private final String viewName = "/ucm/ucm/exam/subjectResults";

    public static final String FORM_NAME = "subjectResultsForm";
    private static Logger log = LoggerFactory.getLogger(UcmSubjectResultsEditController.class);
    
    @Autowired private ApplicationContext context;    
    @Autowired private CollegeWebExtensions collegeWebExtensions;
    @Autowired private EndGradeManagerInterface endGradeManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private AcademicYearManager academicYearManager;
    @Autowired private UCMManagerInterface ucmManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    /** 
     * Adds a property editor for dates to the binder.
     * 
     * @see org.springframework.web.servlet.mvc.BaseCommandController
     *      #initBinder(javax.servlet.http.HttpServletRequest
     *      , org.springframework.web.bind.ServletRequestDataBinder)
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) throws Exception {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
        binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
        binder.setValidator(new SubjectResultsFormValidator());
    }

    

    @RequestMapping(method=RequestMethod.GET)
    public String setUp(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    	  HttpSession session = request.getSession(false);        
    	  
    	  securityChecker.checkSessionValid(session);
          session.setAttribute("menuChoice", "ucm");
          
          int subjectId = ServletUtil.getIntParamSetOnSession(session, request, "subjectId");
          int examinationId = ServletUtil.getIntParamSetOnSession(session, request, "examinationId");
          //if subjectId is set to 0 remove clean the form object
          opusMethods.removeSessionFormObject(FORM_NAME, session, model, subjectId == 0);
          
          SubjectResultsForm subjectResultsForm = (SubjectResultsForm) model.get(FORM_NAME);
          if (subjectResultsForm == null) {
              subjectResultsForm = new SubjectResultsForm();
              model.put(FORM_NAME, subjectResultsForm);
          }
          
          updateSelects(request, response);
          
          
         if(subjectId != 0){
        	 loadSubjectDetails(request, subjectId, model, subjectResultsForm);
         }
          
    	return viewName;
    }
    
    protected void loadSubjectDetails(HttpServletRequest request, int subjectId, ModelMap model, SubjectResultsForm subjectResultsForm){

    	Subject subject = null; //the subject which the results belong to
    	Study study = null; //the study the subject belongs to
    	 String brsPassing = "";
    	
         Locale currentLoc = RequestContextUtils.getLocale(request);
        int studyId = ServletUtil.getIntParam(request, "studyId", 0);

        OpusUser opusUser = opusMethods.getOpusUser();
        if (personManager.isStaffMember(opusUser.getPersonId())) {
            StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
            subjectResultsForm.setStaffMember(staffMember);
        }

        // SUBJECT
        subject = subjectManager.findSubject(subjectId);
        subjectResultsForm.setSubject(subject);

        List<StaffMember> teachers = null;
        List<Integer> staffMemberIds = DomainUtil.getIntProperties(subject.getSubjectTeachers(), "staffMemberId");
        if (!staffMemberIds.isEmpty()) {
            Map<String, Object> staffMemberMap = new HashMap<String, Object>();
            staffMemberMap.put("staffMemberIds", staffMemberIds);
            teachers = staffMemberManager.findStaffMembers(staffMemberMap);
        }
        subjectResultsForm.setTeachers(teachers);
        subjectResultsForm.setIdToSubjectTeacherMap(new IdToStaffMemberMap(teachers));

        // STUDY:
        if (studyId == 0) {
            studyId = subjectManager.findSubjectPrimaryStudyId(subjectId);
        }
        study = studyManager.findStudy(studyId);

        // BRS passing:
        brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
        subjectResultsForm.setBrsPassing(brsPassing);

        // MINIMUM and MAXIMUM GRADE:
        // see if the endGrades are defined on studygradetype level:
        String endGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
        boolean endGradesPerGradeType = endGradeType != null && !endGradeType.isEmpty();
        subjectResultsForm.setEndGradesPerGradeType(endGradesPerGradeType);

        if (!endGradesPerGradeType) {
            // mozambican situation
            //                    subjectResultsForm.setMinimumGrade(study.getMinimumMarkSubject());
            //                    subjectResultsForm.setMaximumGrade(study.getMaximumMarkSubject());
            subjectResultsForm.setMinimumMarkValue(study.getMinimumMarkSubject());
            subjectResultsForm.setMaximumMarkValue(study.getMaximumMarkSubject());
        } else {
            // zambian situation
            //    	            request.setAttribute("minimumMarkValue","0");
            //                	request.setAttribute("maximumMarkValue","100");
            subjectResultsForm.setMinimumMarkValue("0");
            subjectResultsForm.setMaximumMarkValue("100");
        }

    }
    
    public String loadSubjectResults(ModelMap model, HttpServletRequest request) throws Exception {
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.setupForm started...");
        }
        // declare variables
        HttpSession session = request.getSession(false);
        Subject subject = null;
        Study study = null;
        List < SubjectResult > allSubjectResults = null;
        List<StudyPlanDetail> allStudyPlanDetails = null;
        List<Subject> allSubjects = null;
        String examinationResultsHeader = "";
        String brsPassing = "";
        int subjectId = 0;
        /* extra - attachment results */
        List<? extends EndGrade> allEndGrades = null;

        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "ucm");

        
        SubjectResultsForm subjectResultsForm = (SubjectResultsForm) model.get(FORM_NAME);
        if (subjectResultsForm == null) {
            subjectResultsForm = new SubjectResultsForm();
            model.put(FORM_NAME, subjectResultsForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            subjectResultsForm.setNavigationSettings(navigationSettings);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            int studyId = ServletUtil.getIntParam(request, "studyId", 0);

            OpusUser opusUser = opusMethods.getOpusUser();
            if (personManager.isStaffMember(opusUser.getPersonId())) {
                StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
                subjectResultsForm.setStaffMember(staffMember);
            }

            // SUBJECT
            subject = subjectManager.findSubject(subjectId);
            subjectResultsForm.setSubject(subject);

            List<StaffMember> teachers = null;
            List<Integer> staffMemberIds = DomainUtil.getIntProperties(subject.getSubjectTeachers(), "staffMemberId");
            if (!staffMemberIds.isEmpty()) {
                Map<String, Object> staffMemberMap = new HashMap<String, Object>();
                staffMemberMap.put("staffMemberIds", staffMemberIds);
                teachers = staffMemberManager.findStaffMembers(staffMemberMap);
            }
            subjectResultsForm.setTeachers(teachers);
            subjectResultsForm.setIdToSubjectTeacherMap(new IdToStaffMemberMap(teachers));

            // STUDY:
            if (studyId == 0) {
                studyId = subjectManager.findSubjectPrimaryStudyId(subjectId);
            }
            study = studyManager.findStudy(studyId);

            // BRS passing:
            brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
            subjectResultsForm.setBrsPassing(brsPassing);

            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level:
            String endGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
            boolean endGradesPerGradeType = endGradeType != null && !endGradeType.isEmpty();
            subjectResultsForm.setEndGradesPerGradeType(endGradesPerGradeType);

            if (!endGradesPerGradeType) {
                // mozambican situation
                //                    subjectResultsForm.setMinimumGrade(study.getMinimumMarkSubject());
                //                    subjectResultsForm.setMaximumGrade(study.getMaximumMarkSubject());
                subjectResultsForm.setMinimumMarkValue(study.getMinimumMarkSubject());
                subjectResultsForm.setMaximumMarkValue(study.getMaximumMarkSubject());
            } else {
                // zambian situation
                //    	            request.setAttribute("minimumMarkValue","0");
                //                	request.setAttribute("maximumMarkValue","100");
                subjectResultsForm.setMinimumMarkValue("0");
                subjectResultsForm.setMaximumMarkValue("100");
            }

            // STUDY PLAN DETAILS:
            Map<String, Object> findStudyPlanDetails = new HashMap<String, Object>();
            findStudyPlanDetails.put("subjectId", subjectId);
            findStudyPlanDetails.put("academicYearId", subject.getCurrentAcademicYearId());
            findStudyPlanDetails.put("cardinalTimeUnitStatusCode", OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);

            allStudyPlanDetails = studentManager.findStudyPlanDetailsByParams(findStudyPlanDetails);
            // SUBJECT RESULTS:
            allSubjectResults = resultManager.findSubjectResults(subjectId);

            if (endGradesPerGradeType) {
                // load all endGrades that are referenced by the subjectResults (to minimize loading from DB)
                List<String> endGradeCodes = DomainUtil.getStringProperties(allSubjectResults, "endGradeComment");   // TODO endGradeComment should really be called endGradeCode
                Map<String, Object> endGradesMap = new HashMap<String, Object>();
                endGradesMap.put("codes", endGradeCodes);
                endGradesMap.put("academicYearId", subject.getCurrentAcademicYearId());
                endGradesMap.put("lang", preferredLanguage);
                allEndGrades = endGradeManager.findEndGrades(endGradesMap);
            }               

            // CURRENT DATE:
            Date dateNow = new Date();
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            df.setLenient(false);
            String dateNowString = df.format(dateNow); // TODO instead of dateNowString use <fmt:formatDate> with pattern like "dd", "MM", "yyyy"
            subjectResultsForm.setDateNow(dateNowString);

            // Use ResultFormatters to fill up ctuResult and subjectResult objects in the for loop
            // Use ResultFormatter to fill up subjectResult objects in the for loop
            SubjectResultFormatter subjectResultFormatter = collegeWebExtensions.getSubjectResultFormatter();
            subjectResultsForm.setSubjectResultFormatter(subjectResultFormatter);

            Collection<String> endGradeTypeCodes = new HashSet<>();    // remember different kinds of endGradeTypeCodes

            // fetch additional subjectResult related data to make it available in the subjectResult objects
            if (allSubjectResults != null && allSubjectResults.size() != 0) {
            	for (SubjectResult subjectResult : allSubjectResults) {

            	    // determine gradeTypeCode
            	    String gradeTypeCode;
                    if (OpusConstants.ATTACHMENT_RESULT.equals(subject.getResultType())) {
                        gradeTypeCode = OpusConstants.ATTACHMENT_RESULT;
                        subjectResult.setEndGradeTypeCode(gradeTypeCode);   // override studyGradeType.gradeTypeCode which is loaded in resultMap
                    } else {
                        gradeTypeCode = subjectResult.getEndGradeTypeCode();
                    }
                    endGradeTypeCodes.add(gradeTypeCode);

                    // load additional info
                    subjectResultFormatter.loadAdditionalInfo(subjectResult, gradeTypeCode, preferredLanguage);
    	        }
            }
            
            endGradeTypeCodes = new ArrayList<>(endGradeTypeCodes); // convert set to list because iBatis requires a list
            
            if (endGradesPerGradeType) {
                
                // find comments for SubjectResult's endgradetype:
                Map<String, Object> studyGradeTypeEndGradeMap = new HashMap<String, Object>();
                studyGradeTypeEndGradeMap.put("preferredLanguage", preferredLanguage);
                studyGradeTypeEndGradeMap.put("academicYearId", subject.getCurrentAcademicYearId());

                // MP 2013-09: instead of a specific endGradeTypeCode,
                // which doesn't make sense because there can be several SGTs per subject
                // we need to use the gradeTypeCode that corresponds to the studyGradeType referenced by studyPlanDetail (or subject.resultType)
                studyGradeTypeEndGradeMap.put("endGradeTypeCodes", endGradeTypeCodes);
//                Map<String, List<EndGrade>> endGradeTypeCodeToCommentMap = studyManager.findEndGradeTypeToFullEndGradeCommentsMap(studyGradeTypeEndGradeMap, endGradeTypeCodes);

//                List<EndGrade> fullEndGradeCommentsForGradeType = studyManager.findFullEndGradeCommentsForGradeType(studyGradeTypeEndGradeMap);
//                subjectResultsForm.setCodeToFullEndGradeCommentForGradeType(new CodeToEndGradeMap(fullEndGradeCommentsForGradeType));

//                List<EndGrade> fullFailGradeCommentsForGradeType = studyManager.findFullFailGradeCommentsForGradeType(studyGradeTypeEndGradeMap);
                Map<String, List<EndGrade>> endGradeTypeCodeToFailGradesMap = studyManager.findEndGradeTypeCodeToFullFailGradesMap(studyGradeTypeEndGradeMap);
                subjectResultsForm.setEndGradeTypeCodeToFailGradesMap(endGradeTypeCodeToFailGradesMap);
                

            }

            SubjectResultsBuilder srb = context.getBean(SubjectResultsBuilder.class);
            srb.setSubject(subject);
            srb.setAllStudyPlanDetails(allStudyPlanDetails);
            srb.setAllSubjectResults(allSubjectResults);
            srb.setAllEndGrades(allEndGrades);
            srb.build();
            subjectResultsForm.setAllLines(srb.getResultLines());

            List<Integer> studyPlanCardinalTimeUnitIds = DomainUtil.getIntProperties(allStudyPlanDetails, "studyPlanCardinalTimeUnitId");
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnits(studyPlanCardinalTimeUnitIds);
            studentManager.setResultsPublished(allStudyPlanCardinalTimeUnits);
            
            Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap = resultManager.determineAuthorizationForSubjectResults(allStudyPlanDetails, allStudyPlanCardinalTimeUnits, srb.getAllResultsOfLines(), request);
            subjectResultsForm.setSubjectResultAuthorizationMap(subjectResultAuthorizationMap);


        }

        return viewName;
    }

//    @Transactional
   // @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) SubjectResultsForm subjectResultsForm,
            BindingResult result, ModelMap model)
            throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.processSubmit started...");
        }
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        Subject subject = subjectResultsForm.getSubject();
//        String showSubjectResultsError = "";
//        List < StudyPlanDetail > allStudyPlanDetails = null;
//        List < SubjectResult > allSubjectResults = null;
//        boolean subjectResultFound = false;
//        String generateSubjectResultGrade = "";
//        String subjectResultMark = "";
//        String forcedSubjectResultMark = "";
//        SubjectResult subjectResult = null;
//        SubjectResult changedSubjectResult = null;
//        Date subjectResultDate = null;
//        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//        df.setLenient(false);
//        String generatedMark = "";
//        String academicYearChanged = "";
//        String generateAllSubjectResults = "";
//        String adjustAllSubjectResults = "";
//        String adjustmentMark = "";
//        String chosenCardinalTimeUnitNumber = "";
//        String passed = "";
//        StudyPlanDetail studyPlanDetail = null;
//        StudyGradeType studyGradeType = null;
//        int studyGradeTypeId = 0;
        
//        Locale currentLoc = RequestContextUtils.getLocale(request);

//        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
//            studyGradeTypeId = ServletUtil.getIntParam(request, "studyGradeTypeId", 0);
//        }

        if (subjectResultsForm.getAllLines() == null) {
            return viewName;
        }

//        if (!StringUtil.isNullOrEmpty(request.getParameter("academicYearChanged"))) {   // TODO
//            academicYearChanged = request.getParameter("academicYearChanged");
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("generateAllSubjectResults"))) { // TODO
//        	generateAllSubjectResults = request.getParameter("generateAllSubjectResults");
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("adjustAllSubjectResults"))) {   // TODO
//        	adjustAllSubjectResults = request.getParameter("adjustAllSubjectResults");
////        	adjustmentMark = request.getParameter("adjustmentMark");
//        	adjustmentMark = subjectResultsForm.getAdjustmentMark();
//        }
//        if (!"".equals(adjustmentMark)) {
//        	if (StringUtil.checkValidDouble(adjustmentMark) == -1) {
//        		showSubjectResultsError = showSubjectResultsError + messageSource.getMessage(
//                        "jsp.error.adjustmentmark.format", null, currentLoc);
//        	}
//        }

        MarkValidator markValidator = new MarkValidator(subjectResultsForm.getMinimumMarkValue(), subjectResultsForm.getMaximumMarkValue());
//        List<SubjectResult> subjectResults = new ArrayList<SubjectResult>();
        List<SubjectResultLine> subjectResultLines = new ArrayList<SubjectResultLine>();

        for (int i = 0; i < subjectResultsForm.getAllLines().size() ; i++) {
            SubjectResultLine subjectResultLine = subjectResultsForm.getAllLines().get(i);
            SubjectResult subjectResult = subjectResultLine.getSubjectResult();
            int subjectResultId = subjectResult.getId();

            String mark = subjectResult.getMark();

            // This line can be ignored if no data was entered: ie. new result && no mark entered
            // - ignore teacher because when only one teacher then always automatically selected 
            boolean ignore = subjectResultId == 0 && StringUtil.isNullOrEmpty(mark, true);
            if (ignore) {
                continue;       // ignore this line and go to next line
            }

            // -- Validation --

//            boolean lineHasErrors = false;
            result.pushNestedPath("allLines[" + i + "].subjectResult");

            // Validate: Mark correct?
//            BigDecimal markDecimal = null;
//            switch (StringUtil.checkValidDouble(mark)) {
//            case -1:
//                result.rejectValue("subjectResult.mark", "invalid.invalid");
//                lineHasErrors = true;
//                break;
//            case 1:
//                markDecimal = new BigDecimal(mark);
//                break;
//            }
//
//            // Validate: If this line hasn't been ignored (see above), then both mark and teacher have to be filled
//            if (markDecimal == null) {
//                result.rejectValue("subjectResult.mark", "invalid.empty.format");
//                lineHasErrors = true;
            
            markValidator.validate(mark, result);
//            if (result.hasFieldErrors("mark")) {
//                lineHasErrors = true;
//            }

            if (subjectResult.getStaffMemberId() == 0) {
                result.rejectValue("staffMemberId", "jsp.error.no.chosen.staffmember");
//                lineHasErrors = true;
            }

            result.popNestedPath(); // end of validation of this line

//            if (!lineHasErrors) {
//            if (!result.hasErrors()) {
                // only determine passed and endgradecomment if mark changed
//                resultManager.saveSubjectResultIfModified(request, subjectResult, subject.getCurrentAcademicYearId());
//            }
//            subjectResults.add(subjectResult);
            subjectResultLines.add(subjectResultLine);  // store the ones that haven't been ingored
        }


/*        
        // loop through all studyPlanDetails with results per student of this subject:
        allStudyPlanDetails = subjectResultsForm.getAllStudyPlanDetails();
        allSubjectResults = subjectResultsForm.getAllSubjectResults();

        // is this a normal submit or a submit for generateSubjectResult
        for (int i = 0; i < allStudyPlanDetails.size();i++) {       // TODO get rid of i and j

            for (int j = 0; j < allSubjectResults.size();j++) {

            	if (allSubjectResults.get(j).getStudyPlanDetailId() == allStudyPlanDetails.get(i).getId() 
                            && allSubjectResults.get(j).getSubjectId() == subject.getId()) {
            		// reset:
                	generateSubjectResultGrade = "N";

                	if ("Y".equals(generateAllSubjectResults)) {
                		generateSubjectResultGrade = "Y";
                	} else {

                    	// update existing subjectresult:
                        String generateSubjectResultMarkName = allStudyPlanDetails.get(i).getId() + "_" + allSubjectResults.get(j).getId()
                                + "_generateSubjectResultMark";
                        String generateSubjectResultMarkValue = request.getParameter(generateSubjectResultMarkName);
                        if (StringUtil.isNullOrEmpty(generateSubjectResultMarkValue) 
                        		|| "N".equals((String) generateSubjectResultMarkValue)) {
                        	generateSubjectResultGrade = "N";
                        } else {
                        	generateSubjectResultGrade = generateSubjectResultMarkValue;
                        }
                	}

                    // only do an insert if mark is filled or a mark has to be generated:
                    String markName = allStudyPlanDetails.get(i).getId() + "_" + allSubjectResults.get(j).getId() + "_mark";
                    String markValue = request.getParameter(markName);
                    if ((!StringUtil.isNullOrEmpty(markValue) && !"-".equals((String) markValue))
                                    || "Y".equals(generateSubjectResultGrade)
                            		|| "Y".equals(adjustAllSubjectResults)
                        ) {
                        if (log.isDebugEnabled()) {
                       	    log.debug("SubjectResultsEditController.onSubmit: handling " + allStudyPlanDetails.get(i).getId()
                                + "_" + allSubjectResults.get(j).getId() );
                        }
                    	// fill the subjectResult with the request.attribute-values:
                        subjectResult = new SubjectResult();
                        subjectResult.setId(allSubjectResults.get(j).getId());
                        subjectResult.setStudyPlanDetailId(allStudyPlanDetails.get(i).getId());
                        subjectResult.setSubjectId(subject.getId());

                        String subjectResultDateName = allStudyPlanDetails.get(i).getId() + "_" + allSubjectResults.get(j).getId() + "_subjectResultDate";
                        String subjectResultDateValue = request.getParameter(subjectResultDateName);
                        if (!StringUtil.isNullOrEmpty(subjectResultDateValue)) {
                            subjectResultDate = df.parse(subjectResultDateValue);
                        } else {
                            subjectResultDate = new Date();
                        }
                        subjectResult.setSubjectResultDate(subjectResultDate);
                        subjectResult.setMark(markValue);

                        String endGradeCommentName = allStudyPlanDetails.get(i).getId() + "_" + allSubjectResults.get(j).getId() + "_endGradeComment";
                        String endGradeCommentValue = request.getParameter(endGradeCommentName);
                        subjectResult.setEndGradeComment(endGradeCommentValue);

                        String staffMemberIdName = allStudyPlanDetails.get(i).getId() + "_" + allSubjectResults.get(j).getId() + "_staffMemberId";
                        String staffMemberIdValue = request.getParameter(staffMemberIdName);
                        if (!StringUtil.isNullOrEmpty(staffMemberIdValue) && Integer.parseInt(staffMemberIdValue) != 0) {
                            subjectResult.setStaffMemberId(Integer.parseInt(staffMemberIdValue));
                        } else {
                            showSubjectResultsError = showSubjectResultsError + messageSource.getMessage("jsp.error.subjectresult.add", null, currentLoc);
                            showSubjectResultsError += messageSource.getMessage("jsp.error.no.chosen.staffmember", null, currentLoc);
                        }
                        subjectResult.setActive("Y");
                        subjectResult.setPassed("N");
                        if ("".equals(showSubjectResultsError)) {
                            changedSubjectResult = subjectResult;
    
                            // see if you have to overrule the mark:
                            if ("Y".equals(generateSubjectResultGrade)) {

                                subjectResultMark = resultManager.generateSubjectResultMark(allStudyPlanDetails.get(i).getId(), subject.getId(), 
                                        request);
                            } else {
                            	forcedSubjectResultMark = subjectResult.getMark();
                            	if ("Y".equals(adjustAllSubjectResults)) {
                                    if (StringUtil.checkValidDouble(subjectResult.getMark()) != -1) {
                                        forcedSubjectResultMark = Double.toString((Double.parseDouble(adjustmentMark) + Double.parseDouble(subjectResult
                                                .getMark())));
                                        subjectResult.setMark(forcedSubjectResultMark);
                                    }
                            	}
                                if (!"-".equals(forcedSubjectResultMark) && !"".equals(forcedSubjectResultMark)) {
//                                    subjectResultMark = resultManager.generateSubjectResultMark(
//                                        allSubjectResults.get(j).getId(), preferredLanguage, forcedSubjectResultMark, currentLoc);
                                    subjectResultMark = forcedSubjectResultMark;
                                } else {
                                    subjectResultMark = "-";
                                }
                            }
                            // now update the just made or changed subjectresult:
                            if (StringUtil.checkValidInt(subjectResultMark) == -1
                                  && StringUtil.checkValidDouble(subjectResultMark) == -1
                                    && StringUtil.lrtrim(subjectResultMark).length() != 1) {
                                changedSubjectResult.setMark("-");
                                changedSubjectResult.setPassed("N");
                                showSubjectResultsError = showSubjectResultsError + subjectResultMark;
                            } else {
                                changedSubjectResult.setMark(subjectResultMark);
                                studyPlanDetail = studentManager.findStudyPlanDetail(subjectResult.getStudyPlanDetailId());
                                studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
                                passed = resultManager.isPassedSubjectResult(subjectResult, 
                                        subjectResultMark, preferredLanguage, studyGradeType.getGradeTypeCode());
                                changedSubjectResult.setPassed(passed);

                            }
                            // update subjectResult (changed one)
                            changedSubjectResult.setWriteWho(opusMethods.getWriteWho(request));
                            resultManager.updateSubjectResult(changedSubjectResult, request);
                        }
                    }
                }
            }
            
            // reset:
        	generateSubjectResultGrade = "N";
        	
            if ("Y".equals(generateAllSubjectResults)) {
        		generateSubjectResultGrade = "Y";
        	} else {
                // for each studyplandetail there is possibly a new subjectresult:
                String generateSubjectResultMarkName = allStudyPlanDetails.get(i).getId() + "_0_generateSubjectResultMark";
                String generateSubjectResultMarkValue = request.getParameter(generateSubjectResultMarkName);
                if (StringUtil.isNullOrEmpty(generateSubjectResultMarkValue) || "N".equals(generateSubjectResultMarkValue)) {
                	generateSubjectResultGrade = "N";
                } else {
                	generateSubjectResultGrade = generateSubjectResultMarkValue;
                }
        	}
            
            // only do an insert if mark is filled or a mark has to be generated:
//            String markName = allStudyPlanDetails.get(i).getId() + "_0_mark";
//            String markValue = request.getParameter(markName);
SubjectResultLine line = getLine(subjectResultsForm.getAllLines(), allStudyPlanDetails.get(i).getId());
            String markValue = line.getSubjectResult().getMark();
            if (!StringUtil.isNullOrEmpty(markValue)) {
                // fill the new subjectResult with the request.attribute-values:
                subjectResult = new SubjectResult();
                subjectResult.setStudyPlanDetailId(allStudyPlanDetails.get(i).getId());
                subjectResult.setSubjectId(subject.getId());
                
                String subjectResultDateName = allStudyPlanDetails.get(i).getId() + "_0_subjectResultDate";
                String subjectResultDateValue = request.getParameter(subjectResultDateName);
                if (!StringUtil.isNullOrEmpty(subjectResultDateValue)) {
                    subjectResultDate = df.parse(subjectResultDateValue);
                } else {
                    subjectResultDate = new Date();
                }
                subjectResult.setSubjectResultDate(subjectResultDate);
                subjectResult.setMark(markValue);
                String endGradeCommentName = allStudyPlanDetails.get(i).getId() + "_0_endGradeComment";
                String endGradeCommentValue = request.getParameter(endGradeCommentName);
                subjectResult.setEndGradeComment(endGradeCommentValue);

                String staffMemberIdName = allStudyPlanDetails.get(i).getId() + "_0_staffMemberId";
                String staffMemberIdValue = request.getParameter(staffMemberIdName);
                if (!StringUtil.isNullOrEmpty(staffMemberIdValue) && Integer.parseInt(staffMemberIdValue) != 0) {
                    subjectResult.setStaffMemberId(Integer.parseInt(staffMemberIdValue));
                } else {
                    showSubjectResultsError = showSubjectResultsError + messageSource.getMessage("jsp.error.subjectresult.add", null, currentLoc);
                    showSubjectResultsError = showSubjectResultsError + messageSource.getMessage("jsp.error.no.chosen.staffmember", null, currentLoc);
                }
                subjectResult.setActive("Y");
                subjectResult.setPassed("N");
                if ("".equals(showSubjectResultsError)) {
                	subjectResult.setWriteWho(opusMethods.getWriteWho(request));
                    // first add the new subjectresult:
                    int subjectResultId = resultManager.addSubjectResult(subjectResult, request);

                    // then retrieve the new subjectresult for it's id:
                    changedSubjectResult = resultManager.findSubjectResult(subjectResultId);
                    // then see if you have to overrule the mark:
                    if ("Y".equals(generateSubjectResultGrade)) {
                        subjectResultMark = resultManager.generateSubjectResultMark(allStudyPlanDetails.get(i).getId(), subject.getId(), request);
                    } else {
                    	forcedSubjectResultMark = changedSubjectResult.getMark();
                    	if ("Y".equals(adjustAllSubjectResults)) {
                      	    if (StringUtil.checkValidDouble(subjectResult.getMark()) != -1) {
                              	forcedSubjectResultMark = Double.toString(
                              			(Double.parseDouble(adjustmentMark) + Double.parseDouble(subjectResult.getMark()))
                              			);
                              	subjectResult.setMark(forcedSubjectResultMark);
                            }
                       	}
                        if (!"-".equals(forcedSubjectResultMark) && !"".equals(forcedSubjectResultMark)) {
//                            subjectResultMark = resultManager.generateSubjectResultMark(
//                                changedSubjectResult.getId(), preferredLanguage, forcedSubjectResultMark, currentLoc);
                            subjectResultMark = forcedSubjectResultMark;
                        } else {
                            subjectResultMark = "-"; 
                        }
                    }
                    // now update the just made or changed subjectresult:
                    if (StringUtil.checkValidInt(subjectResultMark) == -1
                          && StringUtil.checkValidDouble(subjectResultMark) == -1
                            && StringUtil.lrtrim(subjectResultMark).length() != 1) {
                        changedSubjectResult.setMark("-");
                        changedSubjectResult.setPassed("N");
                        showSubjectResultsError = showSubjectResultsError + subjectResultMark;
                    } else {
                        changedSubjectResult.setMark(subjectResultMark);
                        studyPlanDetail = studentManager.findStudyPlanDetail(changedSubjectResult.getStudyPlanDetailId());
                        studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
                        passed = resultManager.isPassedSubjectResult(subjectResult, 
                                subjectResultMark, preferredLanguage, studyGradeType.getGradeTypeCode());
                        changedSubjectResult.setPassed(passed);

                    }
                    // update subjectResult (new one)
                    changedSubjectResult.setWriteWho(opusMethods.getWriteWho(request));
                    resultManager.updateSubjectResult(changedSubjectResult, request);
                }
            }
        }
*/
        if (result.hasErrors()) {
            return viewName;
        }

        // store to DB
        for (SubjectResultLine subjectResultLIne : subjectResultLines) {
            SubjectResult subjectResultInDB = resultManager.findSubjectResult(subjectResultLIne.getSubjectResult().getId());    // TODO this should be in the resultLine to be shown in screen
            resultManager.saveSubjectResultIfModified(request, subjectResultLIne.getSubjectResult(), subjectResultInDB, subject.getCurrentAcademicYearId(), null);
        }
        
        sessionStatus.setComplete();

        NavigationSettings navigationSettings = subjectResultsForm.getNavigationSettings();
        return "redirect:/college/subjectresults.view?newForm=true"
                    + "&subjectId=" + subject.getId()
//                    + "&showSubjectResultsError="+ showSubjectResultsError
//                    + "&studyGradeTypeId=" + studyGradeTypeId
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                    + "&tab=" + navigationSettings.getTab() 
                    + "&panel=" + navigationSettings.getPanel();
    }

   // @RequestMapping(method=RequestMethod.GET, params = "generate")
    public String generateSubjectResult(@RequestParam("generate") int i,
            SubjectResultsForm subjectResultsForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // Find the respective SubjectResult to set the mark
        SubjectResultLine line = subjectResultsForm.getAllLines().get(i);
        SubjectResult subjectResult = line.getSubjectResult();
//        int studyPlanDetailId = subjectResult.getStudyPlanDetailId();

        // only set mark into form object, don't store, because maybe no teacher chosen yet
        result.pushNestedPath("allLines[" + i + "].subjectResult");
        resultManager.generateSubjectResultMark(subjectResult, preferredLanguage, result);
        result.popNestedPath();

//        if (result.hasErrors()) {
//            return viewName;
//        }
        
//        subjectResult.setMark(mark);

        return viewName;
    }


    /**
     * Try to generate a result for all lines that have no result yet and where lower level results exist.
     * @param subjectResultsForm
     * @param result
     * @param request
     * @param model
     * @return
     */
   // @RequestMapping(method=RequestMethod.POST, params = "generateAll")
    public String generateAllSubjectResults(SubjectResultsForm subjectResultsForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        for (int i = 0; i < subjectResultsForm.getAllLines().size() ; i++) {
            SubjectResultLine subjectResultLine = subjectResultsForm.getAllLines().get(i);
            SubjectResult subjectResult = subjectResultLine.getSubjectResult();
//            int studyPlanDetailId = subjectResult.getStudyPlanDetailId();
            if (subjectResult.getId() == 0 && subjectResultLine.getExaminationResultsFound()) {
                result.pushNestedPath("allLines[" + i + "].subjectResult");
                resultManager.generateSubjectResultMark(subjectResult, preferredLanguage, result);
                result.popNestedPath();
                
//                if (!result.hasFieldErrors("allLines[" + i + "].subjectResult.mark")) {
//                    subjectResult.setMark(mark);
//                }
            }
        }

        return viewName;
    }


    /**
     * Fills select filters according to changes
     * @param request
     * @param response
     * @throws Exception
     */
    protected void updateSelects(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

    	FiltersHelper filtersHelper = new FiltersHelper(academicYearManager, subjectManager, studyManager);
        HttpSession session = request.getSession(false);        

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        Map<String, Object> additionalFindParams = new HashMap<>();
        //      additionalFindParams.put("existStudents", Boolean.TRUE);
        Map<String, Object> parameterMap = filtersHelper.loadAndMakeParameterMap(fb, request, session, additionalFindParams);

        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");
        parameterMap.put("searchValue" , searchValue);
        
        
        //only load subjects if all other filters are filled 
        //this avoids long loading times as there are normally hundreds of subjects
        
        if((fb.getAcademicYearId() != 0) &&
        	(fb.getInstitutionId() != 0) &&
        	(fb.getBranchId() != 0) &&
        	(fb.getOrganizationalUnitId() != 0) &&
        	(fb.getPrimaryStudyId() != 0) &&
        	(fb.getStudyGradeTypeId() != 0)
        		){
        	request.setAttribute("allSubjects", subjectManager.findSubjects(parameterMap));
        }        
        
    }

    protected void readResults(InputStream inp, ModelMap model, HttpServletRequest request) throws IOException{
    
    	Locale currentLoc = RequestContextUtils.getLocale(request);
    	
    	StudentsResultsHandler resultsHandler = new StudentsResultsHandler();
    	
    	List<StudentResult> results = new ArrayList<StudentResult>();
    	
    	resultsHandler.readResultsFromStream(inp);
    	
    	
    	Map<String, String> validEntries = resultsHandler.getValidEntries();
    	
    	if(validEntries.size() > 0){
    		
    		for (Iterator<Map.Entry<String, String>> it = validEntries.entrySet().iterator(); it.hasNext();) {
    			Map.Entry<String,String> entry = it.next();
    			 
    			StudentResult student = ucmManager.findStudentWithCode(entry.getKey());
    			
    			//if code exists set student result
    			if((student != null) && !StringUtil.isNullOrEmpty(student.getStudentName(), true)){
    				student.setResult(new BigDecimal(entry.getValue()));
    				results.add(student);
    			} else {
    				resultsHandler.addInvalidEntry(
    						 messageSource.getMessage("jsp.error.nostudentforcode", new Object[]{entry.getKey()}, currentLoc));
    			}
			}
    	}
    	
    	
    	model.addAttribute("results", results);
    	
    	
    	if(resultsHandler.getErrors().size() > 0)
    	model.addAttribute("resultsErrors", resultsHandler.getErrors());
    	
    	if(resultsHandler.getWarnings().size() > 0)
    	model.addAttribute("resultsWarnings", resultsHandler.getWarnings());
    	
    	if(resultsHandler.getInfo().size() > 0)
    	model.addAttribute("resultsInfo", resultsHandler.getInfo());
    	
    	if(resultsHandler.getInvalidEntries().size() > 0)
    	model.addAttribute("invalidEntries", resultsHandler.getInvalidEntries());
    	
    	if(resultsHandler.getDuplicatedEntries().size() > 0)
    	model.addAttribute("duplicatedEntries", resultsHandler.getDuplicatedEntries());
    	
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processResults(
           @ModelAttribute(FORM_NAME) SubjectResultsForm subjectResultsForm,
            BindingResult result,
            SessionStatus sessionStatus,
            HttpServletRequest request,
            HttpServletResponse response,
            ModelMap model
    		)
            throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.processResults started...");
        }
        
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        updateSelects(request, response);

        new SubjectResultsFormValidator().validate(subjectResultsForm, result);
        
        if (result.hasErrors()) {
        	return viewName;
        } 

        readResults(new ByteArrayInputStream(subjectResultsForm.getStudentsResultsFile()), model, request);
        
        subjectResultsForm.setFormStatus("ResultsProcessed");
        model.addAttribute(FORM_NAME, subjectResultsForm);
        
        
        return viewName;
    }
}
