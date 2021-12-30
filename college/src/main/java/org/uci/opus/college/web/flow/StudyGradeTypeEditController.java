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

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.CardinalTimeUnitStudyGradeTypeComparator;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.DisciplineGroupMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.StudyGradeTypeValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyGradeTypeForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.AcademicYearUtil;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

/**
 * Servlet implementation class for Servlet: ContractEditController.
 * 
 *     http://www.mkyong.com/spring-mvc/spring-mvc-form-handling-annotation-example/
 *     http://levelup.lishman.com/spring/form-processing/controller.php
 * 
 */
@Controller
@RequestMapping("/college/studygradetype.view")
@SessionAttributes({ "studyGradeTypeForm" })
public class StudyGradeTypeEditController {

    private static Logger log = LoggerFactory.getLogger(StudyGradeTypeEditController.class);     
    private final String formView;

    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private DisciplineGroupMapper disciplineGroupMapper;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private MessageSource messageSource;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudentManagerInterface studentManager; 
    @Autowired private StudyGradeTypeValidator studyGradeTypeValidator;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public StudyGradeTypeEditController() {
        super();
        this.formView = "college/study/studyGradeType";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	TimeTrack timer = new TimeTrack("StudyGradeTypeEditController.setupForm");
               
        if (log.isDebugEnabled()) {
            log.debug("StudyGradeTypeEditController.setUpForm entered...");  
        }

        StudyGradeTypeForm studyGradeTypeForm = new StudyGradeTypeForm();        
        NavigationSettings navigationSettings = new NavigationSettings();
        Organization organization = null;

        StudyGradeType studyGradeType = null;
        int studyGradeTypeId = 0;
        int studyId = 0;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String showStudyGradeTypeError = "";
        String showStudyGradeTypeMessage = "";
        String showSubjectStudyGradeTypeError = "";
        String showSubjectBlockStudyGradeTypeError = "";

//        List < Lookup > allDisciplineGroups = null;
 
        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject("studyGradeTypeForm", session, model, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
   	 	Locale currentLoc = RequestContextUtils.getLocale(request);

   	 	studyGradeTypeId = ServletUtil.getIntParam(request, "studyGradeTypeId", 0);

        // show errors:
        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudyGradeTypeError"))) {
            showStudyGradeTypeError = request.getParameter("showStudyGradeTypeError");
        }
        request.setAttribute("showStudyGradeTypeError", showStudyGradeTypeError);

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectStudyGradeTypeError"))) {
            showSubjectStudyGradeTypeError = request.getParameter("showSubjectStudyGradeTypeError");
        }
        request.setAttribute("showSubjectStudyGradeTypeError", showSubjectStudyGradeTypeError);

        if (!StringUtil.isNullOrEmpty(
                request.getParameter("showSubjectBlockStudyGradeTypeError"))) {
            
            showSubjectBlockStudyGradeTypeError 
                = request.getParameter("showSubjectBlockStudyGradeTypeError");
        }
        request.setAttribute("showSubjectBlockStudyGradeTypeError",
                showSubjectBlockStudyGradeTypeError);

        // show messages, set request attribute after other checks down below:
        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudyGradeTypeMessage"))) {
            showStudyGradeTypeMessage = request.getParameter("showStudyGradeTypeMessage");
        }

        /* STUDYGRADETYPEFORM.ORGANIZATION - fetch or create the object */
        organization = new Organization();
        organization = opusMethods.fillOrganization(session, request, organization,
                organizationalUnitId, branchId, institutionId);

        studyGradeTypeForm.setOrganization(organization);

        /* STUDYFORM.NAVIGATIONSETTINGS - fetch or create the object */
        opusMethods.fillNavigationSettings(request, navigationSettings, null);    
        studyGradeTypeForm.setNavigationSettings(navigationSettings);        

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());

        /* put lookup-tables on the request */
        // needed for allGradeTypes
        
        putLookupsIntoRequest(request, preferredLanguage);   

        studyGradeTypeForm.setAllDisciplineGroups(
                disciplineGroupMapper.findDisciplineGroups(null)
        		);

        // see if the endGrades are defined on studygradetype level:
        String endGradesPerGradeType = studyManager.findEndGradeType(0);
        if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
            endGradesPerGradeType = "N";
        } else {
            endGradesPerGradeType = "Y";
        }
        studyGradeTypeForm.setEndGradesPerGradeType(endGradesPerGradeType);        

        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        studyGradeTypeForm.setAllAcademicYears(allAcademicYears);

        if (studyGradeTypeId != 0) {
            studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
            if (studyGradeType == null) {
                throw new RuntimeException("Invalid studyGradeTypeId given");
            }
            studyId = studyGradeType.getStudyId();
        } else {
            studyGradeType = new StudyGradeType();

            studyId = ServletUtil.getIntParam(request, "studyId", 0);
            if (studyId == 0) {
                throw new RuntimeException("Neither studyGradeTypeId nor studyId given");
            }

            studyGradeType.setStudyId(studyId);
            studyGradeType.setActive("Y");
        }
        Study study = studyManager.findStudy(studyId);
        studyGradeTypeForm.setStudy(study);

        // utility
        studyGradeTypeForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        studyGradeTypeForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));

        studyGradeTypeForm.setAllContacts(staffMemberManager.findAllContacts(study.getOrganizationalUnitId()));

        Map<String, Object> findGradeTypesForStudyMap = new HashMap<>();
        findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
        findGradeTypesForStudyMap.put("studyId", studyId);
        studyGradeTypeForm.setAllStudyGradeTypesForStudy(
                studyManager.findAllStudyGradeTypesForStudy(findGradeTypesForStudyMap));
        
        if (studyGradeTypeId != 0) {
        	 
        	// check if any of the subjectstudygradetypes is connected to any studyplan:
            List<SubjectStudyGradeType> allSubjectStudyGradeTypes = subjectManager.findSubjectsForStudyGradeType(studyGradeType.getId());
            if (allSubjectStudyGradeTypes != null && allSubjectStudyGradeTypes.size() != 0) {
	        	for (int i=0;i< allSubjectStudyGradeTypes.size();i++) {
        	        Map<String, Object> ssgMap = new HashMap<>();
        	        ssgMap.put("subjectId", allSubjectStudyGradeTypes.get(i).getSubjectId());
        	        ssgMap.put("studyGradeTypeId", studyGradeTypeId);
                    List<? extends StudyPlanDetail> studyPlanDetails = studentManager.findStudyPlanDetailsByParams(ssgMap);
                    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
                        showStudyGradeTypeMessage = messageSource.getMessage("jsp.message.studygradetype.edit", null, currentLoc)
                                + messageSource.getMessage("jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
                        break;
                    }
                }
	    	}
	    	// check if any of the subjectblockstudygradetypes is connected to any studyplan:
            Map<String, Object> sbsgtMap = new HashMap<>();
            sbsgtMap.put("studyGradeTypeId", studyGradeTypeId);
            sbsgtMap.put("preferredLanguage", preferredLanguage);
            List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(sbsgtMap);
	    	if (allSubjectBlockStudyGradeTypes != null 
	    			&& allSubjectBlockStudyGradeTypes.size() != 0) {
	        	for (int i=0;i< allSubjectBlockStudyGradeTypes.size();i++) {
	    	    	Map<String, Object> sbsgMap = new HashMap<>();
	    	    	sbsgMap.put("subjectBlockId", allSubjectBlockStudyGradeTypes.get(i).getSubjectBlock().getId());
	    	    	sbsgMap.put("studyGradeTypeId", studyGradeTypeId);
	    	    	List <? extends StudyPlanDetail > studyPlanDetails = 
	    	    		studentManager.findStudyPlanDetailsByParams(sbsgMap);
	    	    	if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
	    	    	    showStudyGradeTypeMessage =  messageSource.getMessage(
	                            "jsp.message.studygradetype.edit", null, currentLoc)
	                        + messageSource.getMessage(
	                            "jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
	            		break;    
	            	}
	        	}
	    	}

        }
        request.setAttribute("showStudyGradeTypeMessage", showStudyGradeTypeMessage);

        // Initial fill of CardinalTimeUnitStudyGradeTypes list: if list is empty but
        // there should be ctu's (getNumberOfCardinalTimeUnits() > 0) then fill up:        
        if (studyGradeType.getNumberOfCardinalTimeUnits() > 0 
           && (studyGradeType.getCardinalTimeUnitStudyGradeTypes() == null
                || studyGradeType.getCardinalTimeUnitStudyGradeTypes().size() < 1)) {

            studyGradeType = fillCardinalTimeUnitStudyGradeTypes(studyGradeType);
        }                
        
        // Add Secondary School Subject Groups 
        List < SecondarySchoolSubjectGroup > allSecondarySchoolSubjectGroups = studyManager.findSecondarySchoolSubjectGroups(
                                                studyGradeTypeId, preferredLanguage);
        studyGradeTypeForm.setAllSecondarySchoolSubjectGroups(allSecondarySchoolSubjectGroups);
    	// check if there are enough secondary school subjects added to a bachelor studygradetype:
    	if (opusMethods.isGradeTypeIsBachelor(preferredLanguage, studyGradeType.getGradeTypeCode())) {
     		if (studyGradeTypeForm.getAllSecondarySchoolSubjectGroups() != null) {
    			int numberOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsCount();
    			int totalNumberToGrade = 0;
    			for (int i=0; i < studyGradeTypeForm.getAllSecondarySchoolSubjectGroups().size(); i++) {
    				totalNumberToGrade = totalNumberToGrade + studyGradeTypeForm.getAllSecondarySchoolSubjectGroups().get(i).getMaxNumberToGrade();
             	}
    			if (totalNumberToGrade < numberOfSecondarySchoolSubjects) {
                    // only show error if the academicyear of the studygradetype is higher than this academic year
                    if (!AcademicYearUtil.isPastAcademicYear(
                            allAcademicYears, studyGradeType.getCurrentAcademicYearId(),
                            academicYearManager.getCurrentAcademicYear().getId())) {
                        showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage(
                            "jsp.error.secondaryschoolsubject.definition.missing", null, currentLoc);
                    }
    			}
    		} else {
    		    // only show error if the academicyear of the studygradetype is higher than this academic year
    		    if (!AcademicYearUtil.isPastAcademicYear(
    		            allAcademicYears, studyGradeType.getCurrentAcademicYearId(),
    		            academicYearManager.getCurrentAcademicYear().getId())) {
    		        showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage(
                        "jsp.error.secondaryschoolsubject.definition.missing", null, currentLoc);
    		    }
    		}
    	}
        request.setAttribute("showStudyGradeTypeError", showStudyGradeTypeError);
        
        studyGradeTypeForm.setStudyGradeType(studyGradeType);
        model.addAttribute("studyGradeTypeForm", studyGradeTypeForm);

        timer.end();
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("studyGradeTypeForm") StudyGradeTypeForm studyGradeTypeForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        NavigationSettings navigationSettings = studyGradeTypeForm.getNavigationSettings();
        
        String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");
		
        StudyGradeType studyGradeType = studyGradeTypeForm.getStudyGradeType();

        int studyId = studyGradeType.getStudyId();
        int tab = 0;
        int panel = 0;
//        String showStudyGradeTypeMessage = "";
        int currentPageNumber = 0;
        String nextView = "";
        
        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_studygradetype"))) {
            panel = Integer.parseInt(request.getParameter("panel_studygradetype"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_studygradetype"))) {
            tab = Integer.parseInt(request.getParameter("tab_studygradetype"));
        }
        request.setAttribute("tab", tab);
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        Locale currentLoc = RequestContextUtils.getLocale(request);
        
        if (!"true".equals(request.getParameter("submitFormObject"))) {            

            request = setRequestParameters(request);
            
            // Initial fill of CardinalTimeUnitStudyGradeTypes list: if list is empty but
            // there should be ctu's (getNumberOfCardinalTimeUnits() > 0) then fill up:
            if (studyGradeType.getNumberOfCardinalTimeUnits() > 0 
               && (studyGradeType.getCardinalTimeUnitStudyGradeTypes() == null
                    || studyGradeType.getCardinalTimeUnitStudyGradeTypes().size() < 1)) {

                    studyGradeType = fillCardinalTimeUnitStudyGradeTypes(studyGradeType);
            }

            // The number of CTUs may have changed -> add or remove to match the new number
            studyGradeType = changeCardinalTimeUnitStudyGradeTypes(studyGradeType);
            
            return formView;
        }

        result.pushNestedPath("studyGradeType");
    	studyGradeTypeValidator.onBindAndValidate(request, studyGradeTypeForm.getStudyGradeType(), result);
    	result.popNestedPath();

    	if (result.hasErrors()) {
            putLookupsIntoRequest(request, preferredLanguage);        
        	return formView;
        }

        /* test if the combination already exists */
        Map<String, Object> map = new HashMap<>();
        map.put("studyId", studyGradeType.getStudyId());
        map.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
        map.put("currentAcademicYearId", studyGradeType.getCurrentAcademicYearId());
        map.put("studyTimeCode", studyGradeType.getStudyTimeCode());
        map.put("studyFormCode", studyGradeType.getStudyFormCode());
        map.put("preferredLanguage", preferredLanguage);
        if ("Y".equals(iUseOfPartTimeStudyGradeTypes)) {
        	map.put("studyIntensityCode", studyGradeType.getStudyIntensityCode());
        }
		if (studyGradeType.getId() == 0 && studyManager.findStudyGradeTypeByParams(map) != null) {

//            showStudyGradeTypeError = studyGradeType.getGradeTypeCode() + ". "
//            + messageSource.getMessage(
//                    "jsp.error.studygradetype.edit", null, currentLoc)
//            + messageSource.getMessage(
//                    "jsp.error.general.alreadyexists", null, currentLoc);

		    result.reject("jsp.error.general.alreadyexists");

            putLookupsIntoRequest(request, preferredLanguage);        
            return formView;
        }

//        String showStudyGradeTypeError = "";

        if (studyGradeType.getId() == 0) {

            // add
            studyManager.addStudyGradeType(studyGradeType);

//                StudyGradeType newStudyGradeType = studyManager.findStudyGradeTypeByParams(map);
            
            nextView = "redirect:/college/studygradetype.view?newForm=true&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel() 
                + "&studyId=" + studyId
                + "&studyGradeTypeId=" + studyGradeType.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
       
            return nextView;

        } else {

            // update

            // check if any of the subjectstudygradetypes is connected to any studyplan:
//        	List < SubjectStudyGradeType > allSubjectStudyGradeTypes = 
//        		subjectManager.findSubjectsForStudyGradeType(studyGradeType.getId());
//        	if (allSubjectStudyGradeTypes != null 
//        			&& allSubjectStudyGradeTypes.size() != 0) {
//            	for (int i=0;i< allSubjectStudyGradeTypes.size();i++) {
//	        	        
//        	        Map<String, Object> ssgMap = new HashMap<>();
//        	        ssgMap.put("subjectId", allSubjectStudyGradeTypes.get(i).getSubjectId());
//        	        ssgMap.put("studyGradeTypeId", allSubjectStudyGradeTypes.get(i).getStudyGradeTypeId());
//	    	    	List <? extends StudyPlanDetail > studyPlanDetails = 
//	    	    		studentManager.findStudyPlanDetailsByParams(ssgMap);
//	    	    	if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
//        	    		showStudyGradeTypeMessage = messageSource.getMessage(
//        	                    "jsp.message.studygradetype.edit", null, currentLoc)
//        	                + messageSource.getMessage(
//        	                    "jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
//        	    		break;
//        	    	}
//            	}
//        	}
//        	// check if any of the subjectblockstudygradetypes is connected to any studyplan:
//            Map<String, Object> sbsgtMap = new HashMap<>();
//            sbsgtMap.put("studyGradeTypeId", studyGradeType.getId());
//            sbsgtMap.put("preferredLanguage", preferredLanguage);
//            List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(sbsgtMap);
//        	if (allSubjectBlockStudyGradeTypes != null 
//        			&& allSubjectBlockStudyGradeTypes.size() != 0) {
//            	for (int i=0;i< allSubjectBlockStudyGradeTypes.size();i++) {
//
//        	        Map<String, Object> sbsgMap = new HashMap<>();
//        	        sbsgMap.put("subjectBlockId", 
//        	        		allSubjectBlockStudyGradeTypes.get(i).getSubjectBlock().getId());
//        	        sbsgMap.put("studyGradeTypeId", 
//        	        		allSubjectBlockStudyGradeTypes.get(i).getStudyGradeType().getId());
//	    	    	List <? extends StudyPlanDetail > studyPlanDetails = 
//	    	    		studentManager.findStudyPlanDetailsByParams(sbsgMap);
//	    	    	if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
//	            		showStudyGradeTypeMessage =  messageSource.getMessage(
//	                            "jsp.message.studygradetype.edit", null, currentLoc)
//	            		    + messageSource.getMessage(
//	                            "jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
//	            		break;    
//	            	}
//            	}
//        	}
        	// check if there are enough secondary school subjects added to a bachelor studygradetype:
//        	if (opusMethods.isGradeTypeIsBachelor(preferredLanguage, studyGradeType.getGradeTypeCode())) {
//                List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
//
//                if (studyGradeTypeForm.getAllSecondarySchoolSubjectGroups() != null) {
//        			int numberOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsCount();
//        			int totalNumberToGrade = 0;
//        			for (int i=0; i < studyGradeTypeForm.getAllSecondarySchoolSubjectGroups().size(); i++) {
//        				totalNumberToGrade = totalNumberToGrade + studyGradeTypeForm.getAllSecondarySchoolSubjectGroups().get(i).getMaxNumberToGrade();
//                 	}
//        			if (totalNumberToGrade < numberOfSecondarySchoolSubjects) {
//                        // only show error if the academicyear of the studygradetype is higher than this academic year
//                        if (!AcademicYearUtil.isPastAcademicYear(
//                                allAcademicYears, studyGradeType.getCurrentAcademicYearId(),
//                                academicYearManager.getCurrentAcademicYear().getId())) {
//                            showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage(
//	                            "jsp.error.secondaryschoolsubject.definition.missing", null, currentLoc);
//                        }
//        			}
//        		} else {
//                    // only show error if the academicyear of the studygradetype is higher than this academic year
//                    if (!AcademicYearUtil.isPastAcademicYear(
//                            allAcademicYears, studyGradeType.getCurrentAcademicYearId(),
//                            academicYearManager.getCurrentAcademicYear().getId())) {
//                        showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage(
//                            "jsp.error.secondaryschoolsubject.definition.missing", null, currentLoc);
//                    }
//                }
//        	}
        	
//        	if ("".equals(showStudyGradeTypeError)) {
            	studyManager.updateStudyGradeType(studyGradeType);
//            }
        }
        
//        if ("".equals(showStudyGradeTypeError)) {
//            nextView = "redirect:/college/study.view?newForm=true&tab=" + navigationSettings.getTab() 
//                            + "&panel=" + navigationSettings.getPanel() 
//                            + "&studyId=" + studyId
//                            + "&currentPageNumber=" + currentPageNumber;
//        } else {
            nextView = "redirect:/college/studygradetype.view?newForm=true&tab=" + tab 
            + "&panel=" + panel 
            + "&studyId=" + studyId
            + "&studyGradeTypeId=" + studyGradeType.getId()
//            + "&showStudyGradeTypeError=" + showStudyGradeTypeError
//            + "&showStudyGradeTypeMessage=" + showStudyGradeTypeMessage
            + "&currentPageNumber=" + currentPageNumber;
//        }
        return nextView;
        
    }

    /** fill lookup-tables with right values */
    private void putLookupsIntoRequest(HttpServletRequest request, String preferredLanguage) {
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getSubjectLookups(preferredLanguage, request);
        lookupCacher.getAllRfcStatuses(preferredLanguage, request);
    }
    
    /**
     * To be removed (when all request paramters are in the FormObject).
     * @param request to be filled.
     * @return request filled with parameters.
     */
    private HttpServletRequest setRequestParameters(HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);  
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        int institutionId = OpusMethods.getInstitutionId(session, request);            
        int branchId = OpusMethods.getBranchId(session, request);            
        int organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);

        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION
                                , institutionId, branchId, organizationalUnitId);

        putLookupsIntoRequest(request, preferredLanguage);  

        return request;
    }
    
    /**
     * @param studyGradeType to fille.
     * @return filled studyGradeType.
     */
    private StudyGradeType fillCardinalTimeUnitStudyGradeTypes(StudyGradeType studyGradeType) {
        
        List <CardinalTimeUnitStudyGradeType> cardinalTimeUnitStudyGradeTypes =
            new ArrayList<>();

        // add default objects to list
        for (int i = 0; i < studyGradeType.getNumberOfCardinalTimeUnits(); i++) {
            CardinalTimeUnitStudyGradeType ctu = new CardinalTimeUnitStudyGradeType();
            ctu.setStudyGradeTypeId(studyGradeType.getId());
            ctu.setCardinalTimeUnitNumber(i + 1);
            cardinalTimeUnitStudyGradeTypes.add(ctu);
        }

        studyGradeType.setCardinalTimeUnitStudyGradeTypes(cardinalTimeUnitStudyGradeTypes);
        
        return studyGradeType; 
    }
    
    /**
     * See if list with CardinalTimeUnitStudyGradeTypes is not equal to 
     * NumberOfCardinalTimeUnits and should threfore be changed.
     * @param studyGradeType to check.
     * @return possibly changed studyGradeType.
     */
    private StudyGradeType changeCardinalTimeUnitStudyGradeTypes(StudyGradeType studyGradeType) {
        
        if (studyGradeType != null && studyGradeType.getCardinalTimeUnitStudyGradeTypes() != null) {
                    
            if (studyGradeType.getNumberOfCardinalTimeUnits() 
                    > studyGradeType.getCardinalTimeUnitStudyGradeTypes().size()) {
        
                // fill up empty places
                
                // get existing studyPlanCardinalTimeUnitNumbers (e.g. only ctunr 2 exists, not ctunr 1)
                List<Integer> existingCardinalTimeUnitNumber =
                        DomainUtil.getIntProperties(studyGradeType.getCardinalTimeUnitStudyGradeTypes(), "cardinalTimeUnitNumber");
                
//                for (int i = studyGradeType.getCardinalTimeUnitStudyGradeTypes().size(); 
                for (int i = 1;
                    i <= studyGradeType.getNumberOfCardinalTimeUnits(); i++) {
                    
                    if (existingCardinalTimeUnitNumber == null || !existingCardinalTimeUnitNumber.contains(i)) {
                        CardinalTimeUnitStudyGradeType ctu = new CardinalTimeUnitStudyGradeType();
                        ctu.setStudyGradeTypeId(studyGradeType.getId());
                        ctu.setCardinalTimeUnitNumber(i);
                        studyGradeType.getCardinalTimeUnitStudyGradeTypes().add(ctu);
                    }
                }
                
                // sort along cardinal time unit number
                Collections.sort(studyGradeType.getCardinalTimeUnitStudyGradeTypes(),
                        new CardinalTimeUnitStudyGradeTypeComparator());
            }
            
            if (studyGradeType.getNumberOfCardinalTimeUnits() 
                    < studyGradeType.getCardinalTimeUnitStudyGradeTypes().size()) {
                
                // remove surplus of objects
                List <CardinalTimeUnitStudyGradeType> newList = 
                    new ArrayList <>();

                for (int i = 0; i < studyGradeType.getNumberOfCardinalTimeUnits(); i++) {
                    newList.add(studyGradeType.getCardinalTimeUnitStudyGradeTypes().get(i));
                }
                studyGradeType.setCardinalTimeUnitStudyGradeTypes(newList);
            }
        }
        
        return studyGradeType; 
    }        
   
   
}
