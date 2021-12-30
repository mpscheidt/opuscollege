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
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyType;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/subject.view")
@SessionAttributes(SubjectEditController.SUBJECT_FORM)
public class SubjectEditController {

    static final String SUBJECT_FORM = "subjectForm";

    private static Logger log = LoggerFactory.getLogger(SubjectEditController.class);

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private LookupCacher lookupCacher;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private MessageSource messageSource;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private ExaminationManagerInterface examinationManager;

    private String formView;

    public SubjectEditController() {
        super();
        this.formView = "college/subject/subject";
    }

    /**
     * 
     * @param request
     * @param model
     * @return 
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {
		TimeTrack timer = new TimeTrack("SubjectEditController.setupForm");
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectEditController.setUpForm entered...");
        }
        // declare variables
        SubjectForm subjectForm = null;
        Organization organization = null;
        Subject subject = null;
        NavigationSettings navSettings = null;
        
        HttpSession session = request.getSession(false);        
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;

        String unitStudyDescription = "";
        int studyId = 0;
        int subjectId = 0;
        String showExaminationError = "";
        String showSubjectStudyGradeTypeError = "";
        String showSubjectSubjectBlockError = "";
        String showSubjectTeacherError = "";

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // when entering a new form, destroy any existing objectForms on the session
        opusMethods.removeSessionFormObject(SUBJECT_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to curriculum */
        session.setAttribute("menuChoice", "studies");
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        /* fetch or create the form object */
        subjectForm = (SubjectForm) model.get(SUBJECT_FORM);
        if (subjectForm == null) {
            subjectForm = new SubjectForm();
            model.addAttribute(SUBJECT_FORM, subjectForm);        
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showExaminationError"))) {
            showExaminationError = request.getParameter("showExaminationError");
            subjectForm.setShowExaminationError(showExaminationError);
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectStudyGradeTypeError"))) {
        	showSubjectStudyGradeTypeError = request.getParameter("showSubjectStudyGradeTypeError");
        	subjectForm.setShowSubjectStudyGradeTypeError(showSubjectStudyGradeTypeError);
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectSubjectBlockError"))) {
        	showSubjectSubjectBlockError = request.getParameter("showSubjectSubjectBlockError");
        	subjectForm.setShowSubjectSubjectBlockError(showSubjectSubjectBlockError);
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectTeacherError"))) {
        	showSubjectTeacherError = request.getParameter("showSubjectTeacherError");
        	subjectForm.setShowSubjectTeacherError(showSubjectTeacherError);
        }

        // entering the form: the SubjectForm.subject does not exist yet
        if (subjectForm.getSubject() == null) {
            
            // get the subjectId if it exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
                subjectId = Integer.parseInt(request.getParameter("subjectId"));
            }
            // EXISTING SUBJECT
            if (subjectId != 0) {
                subject = subjectManager.findSubject(subjectId);
                // used to show the description of the organizational unit the study belongs to
                unitStudyDescription = organizationalUnitManager.findOrganizationalUnitOfStudy(
                                subject.getPrimaryStudyId()).getOrganizationalUnitDescription();
                model.addAttribute(unitStudyDescription);
                
                // studyGradeTypes to which this subject is linked / assigned
                List < SubjectStudyGradeType > allSubjectStudyGradeTypes = null;
                Map<String, Object> map = new HashMap<>();
                map.put("subjectId", subjectId);
                map.put("preferredLanguage", preferredLanguage);

                // is a map because in addition to thesubjectId the language is needed
                allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes(map);

                // set the prerequisite subjects
                for (int i = 0; i < allSubjectStudyGradeTypes.size(); i++) {
                    
                    SubjectStudyGradeType subjectStudyGradeType = allSubjectStudyGradeTypes.get(i);
                    int subjectStudyGradeTypeId = subjectStudyGradeType.getId();
                    
                    // get list of prerequisites
                    List<SubjectPrerequisite> subjectPrerequisites =
                                    subjectManager.findSubjectPrerequisites(subjectStudyGradeTypeId);
                    // set the list of prerequisited subjects to the subjectStudyGradeType 
                    subjectStudyGradeType.setSubjectPrerequisites(subjectPrerequisites);
                    
                 }
                
                subject.setSubjectStudyGradeTypes(allSubjectStudyGradeTypes);
                
                // TODO should also be fetched with subject itself, but is a map
                //studyTypes that are part of this subject
                map.put("orderBy", "studyType.description");
                List <SubjectStudyType> allSubjectStudyTypes = subjectManager.findSubjectStudyTypes(map);
                subject.setSubjectStudyTypes(allSubjectStudyTypes);
                
                int percentageTotal = examinationManager.findTotalWeighingFactor(subjectId);
                subjectForm.setTotalWeighingFactor(percentageTotal);
                
                if (percentageTotal != 100) {
                    // reset the examination error in this case:
                    Locale currentLoc = RequestContextUtils.getLocale(request);
                    if (!"".equals(showExaminationError)) {
                        showExaminationError = showExaminationError + "<br/>";
                    }
                    showExaminationError = showExaminationError 
                        + messageSource.getMessage("jsp.error.percentagetotal", null, currentLoc);
                }
                subjectForm.setShowExaminationError(showExaminationError);
                
                // find organization id's matching with the subject
                studyId = subject.getPrimaryStudyId();
                organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                                studyId)).getId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);
            // NEW SUBJECT
            } else {
                subject = new Subject();
                subject.setHoursToInvest(OpusConstants.HOURS_TO_INVEST);
                subject.setFreeChoiceOption("N");
                subject.setActive("Y");
                // set default organization id's
                institutionId = OpusMethods.getInstitutionId(session, request);
                branchId = OpusMethods.getBranchId(session, request);
                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            }
        } else {
            subject = subjectForm.getSubject();
            if (subject.getPrimaryStudyId() != 0) {
                // used to show the description of the organizational unit the study belongs to
                unitStudyDescription = organizationalUnitManager.findOrganizationalUnitOfStudy(
                                subject.getPrimaryStudyId()).getOrganizationalUnitDescription();
            }
            model.addAttribute(unitStudyDescription);
        }
        subjectForm.setSubject(subject);
        
        if (subjectForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject or default values
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectForm.setOrganization(organization);
        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectForm.getOrganization();
        }

        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectForm.getNavigationSettings() != null) {
            navSettings = subjectForm.getNavigationSettings();
        } else {
            navSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navSettings, null);
        }
        subjectForm.setNavigationSettings(navSettings);

       	// check if one of the subjectstudygradetypes is connected to any studyplan:
        List < ? extends SubjectStudyGradeType > subjectStudyGradeTypes = 
        		subject.getSubjectStudyGradeTypes();
        if (subjectStudyGradeTypes != null && subjectStudyGradeTypes.size() != 0) {
            for (int i = 0; i < subjectStudyGradeTypes.size();i++) {
    	        if (subjectStudyGradeTypes.get(i).getStudyGradeTypeId() != 0
    	        		&& subjectStudyGradeTypes.get(i).getSubjectId() != 0) {
    		        Locale currentLoc = RequestContextUtils.getLocale(request);
    		        Map<String, Object> map = new HashMap<>();
    		        map.put("subjectId", subjectStudyGradeTypes.get(i).getSubjectId());
    		        map.put("studyGradeTypeId", subjectStudyGradeTypes.get(i).getStudyGradeTypeId());

    		        List <? extends StudyPlanDetail > studyPlanDetails = 
    		    		studentManager.findStudyPlanDetailsByParams(map);
		    	    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {   		
    		    		subjectForm.setShowSubjectEditError(
    		    			messageSource.getMessage(
    		                    "jsp.warning.subject.edit", null, currentLoc)
    		                + ": "
    		                + messageSource.getMessage(
    		                    "jsp.error.general.delete.linked.studyplan", null, currentLoc));
    		    		// break the for loop:
                        break;
    		    	}
    	        }
            }
        }
        
        
        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill dropDowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                subjectForm.getOrganization(), session, request
                            , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                            , organization.getBranchId(), organization.getOrganizationalUnitId());

        /* fill lookup-tables with right values */
        lookupCacher.getSubjectLookups(preferredLanguage, request);
        lookupCacher.getPersonLookups(preferredLanguage, request);

        subjectForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
        subjectForm.setAllFrequencies(lookupCacher.getAllFrequencies());
        subjectForm.setAllStudyTimes(lookupCacher.getAllStudyTimes(preferredLanguage));
        subjectForm.setAllStudyForms(lookupCacher.getAllStudyForms(preferredLanguage));
        subjectForm.setAllRigidityTypes(lookupCacher.getAllRigidityTypes(preferredLanguage));
        subjectForm.setAllImportanceTypes(lookupCacher.getAllImportanceTypes(preferredLanguage));
        

        if (organization.getOrganizationalUnitId() != 0) {
            Map<String, Object> findStudiesMap = new HashMap<>();
            
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            subjectForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            subjectForm.setAllStudies(null);
        }
        request.setAttribute("idToStudyMap", new IdToStudyMap(subjectForm.getAllStudies()));

        if (subjectForm.getAllAcademicYears() == null) {
            subjectForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
        }

        if (subjectForm.getAllStudyGradeTypes() == null) {
            subjectForm.setAllStudyGradeTypes(studyManager.findAllStudyGradeTypes());
        }
        
		subjectForm.setAllClassgroups(studyManager.findClassgroupsBySubjectId(subject.getId()));

        // see if the endGrades are defined on studygradetype level:
        String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
        if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
            endGradesPerGradeType = "N";
        } else {
            endGradesPerGradeType = "Y";
        }
        subjectForm.setEndGradesPerGradeType(endGradesPerGradeType);        

        timer.end();
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute(SUBJECT_FORM) SubjectForm subjectForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

        Subject subject = subjectForm.getSubject();
        NavigationSettings navSettings = subjectForm.getNavigationSettings();
        Organization organization = subjectForm.getOrganization();
        
        Subject changedSubject = null;
        String submitFormObject = "";

        HttpSession session = request.getSession(false);        

        // if empty, create unique subjectCode
        if (StringUtil.isNullOrEmpty(subject.getSubjectCode(), true)) {
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String subjectCode = StringUtil.createUniqueCode("S", strRandomCode); 
            subject.setSubjectCode(subjectCode);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitContentFormObject"))) {
            submitFormObject = request.getParameter("submitContentFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectValidator().validate(subjectForm, result);
            if (result.hasErrors()) {
                return formView;
            }
            
            // check if the subject already exists in the chosen academic year
            Map<String, Object> chkSubjectCodeMap = new HashMap<>();
            chkSubjectCodeMap.put("subjectCode", subject.getSubjectCode());
            chkSubjectCodeMap.put("subjectDescription", subject.getSubjectDescription());
            chkSubjectCodeMap.put("academicYearId", subject.getCurrentAcademicYearId());
            Subject sameSubject = subjectManager.findSubjectByCode(chkSubjectCodeMap);
            
            // check uniqueness according to DB: code, description, academicYearId:
            if (sameSubject != null && sameSubject.getId() != subject.getId()) {
                result.reject("jsp.error.subject.exists");
            }
            
            if (result.hasErrors()) {
                return formView;
            }

        	// NEW SUBJECT
    	    if (subject.getId() == 0) {
                // add the new subject
                subjectManager.addSubject(subject);
                status.setComplete();
                
                // id not known yet
                Map<String, Object> findSubjectMap = new HashMap<>();
                findSubjectMap.put("subjectDescription", subject.getSubjectDescription());
                findSubjectMap.put("subjectCode", subject.getSubjectCode());
                findSubjectMap.put("primaryStudyId", subject.getPrimaryStudyId());
                findSubjectMap.put("academicYearId", subject.getCurrentAcademicYearId());
                changedSubject = subjectManager.findSubjectByDescriptionStudyCode(findSubjectMap);
                
                return "redirect:/college/subject.view?newForm=true&" 
                        + "&subjectId=" + changedSubject.getId();
            // UPDATE SUBJECT
            } else {
                // update the subject
                subjectManager.updateSubject(subject);
                status.setComplete();
                if (log.isDebugEnabled()) {
                    log.debug("SubjectEditController.processSubmit: status Complete ");
                }
                return "redirect:/college/subject.view?newForm=true&tab=" + navSettings.getTab()
                        + "&panel=" + navSettings.getPanel()
                        + "&subjectId=" + subject.getId()
                        + "&currentPageNumber=" + navSettings.getCurrentPageNumber();
            }

        } else {
            // submit but no save
            session.setAttribute("institutionId", organization.getInstitutionId());
            session.setAttribute("branchId", organization.getBranchId());
            session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());

            return "redirect:/college/subject.view";
        }
    }

}
