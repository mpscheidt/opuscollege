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
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectStudyGradeTypeValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectStudyGradeTypeForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author MoVe
 */
@Controller
@SessionAttributes("subjectStudyGradeTypeForm")
public class SubjectStudyGradeTypeEditController {
    
    private static Logger log = LoggerFactory.getLogger(SubjectStudyGradeTypeEditController.class);
    private String formView;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private MessageSource messageSource;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudentManagerInterface studentManager;

    public SubjectStudyGradeTypeEditController() {
        super();
        this.formView = "college/subject/subjectStudyGradeType";
    }

    @RequestMapping(value="/college/subjectstudygradetype.view", method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectStudyGradeTypeEditController.setUpForm entered...");
        }
        
        // declare variables
        HttpSession session = request.getSession(false);       
        
        SubjectStudyGradeTypeForm subjectStudyGradeTypeForm = null;
        SubjectStudyGradeType subjectStudyGradeType = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;
        Subject subject = null;
        StudyGradeType studyGradeType = null;
        int subjectId = 0;
        int studyId = 0;
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;

        int subjectStudyGradeTypeId = 0;
        int maxNumberOfCardinalTimeUnits = 0;
        int numberOfCardinalTimeUnits = 0;
        int currentAcademicYearId = 0;

 
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding or editing a new subjectStudyGradeType, destroy existing ones on the session
        opusMethods.removeSessionFormObject("subjectStudyGradeTypeForm", session, model, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* fetch or create the form object */
        if ((SubjectStudyGradeTypeForm) session.getAttribute("subjectStudyGradeTypeForm") 
                                                                                    != null) {
            subjectStudyGradeTypeForm = (SubjectStudyGradeTypeForm) 
                                        session.getAttribute("subjectStudyGradeTypeForm");
        } else {
            subjectStudyGradeTypeForm = new SubjectStudyGradeTypeForm();           
        }
        
        /* SUBJECT - fetch or create the object */
        if (subjectStudyGradeTypeForm.getSubject() == null) {
            // TODO: get subjectId directly via subjectStudyGradeTypeId
            // subjectId should exist
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
                subjectId = Integer.parseInt(request.getParameter("subjectId"));
            } else {
                // check if subjectStudyGradeTypeId exists
                if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyGradeTypeId"))) {
                    subjectStudyGradeTypeId = Integer.parseInt(
                                                request.getParameter("subjectStudyGradeTypeId"));
                    HashMap map = new HashMap();
                    map.put("preferredLanguage", preferredLanguage);
                    map.put("subjectStudyGradeTypeId", subjectStudyGradeTypeId);
                    subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(map);
                    subjectId = subjectStudyGradeType.getSubjectId();
                }
            }

            subject = subjectManager.findSubject(subjectId);
            subjectStudyGradeTypeForm.setSubject(subject);
            
            // check if subject may be linked to studyGradeType
            if (!subjectStudyGradeTypeForm.getSubject().isLinkSubjectAndStudyGradeTypeIsAllowed()) {
                subjectStudyGradeTypeForm.setTxtErr(messageSource.getMessage(
                      "jsp.error.link.subject.studygradetype.teacher.missing", null, RequestContextUtils.getLocale(request)));                            
            } else {
                subjectStudyGradeTypeForm.setTxtErr("");
            }

            // set default organization id's
            // find organization id's matching with the subject
            studyId = subject.getPrimaryStudyId();
            organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                            studyId)).getId();
            branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            institutionId = institutionManager.findInstitutionOfBranch(branchId);
            
        } else {
            subject = subjectStudyGradeTypeForm.getSubject();
        }
        currentAcademicYearId = subject.getCurrentAcademicYearId();

        /* SUBJECTSTUDYGRADETYPE - fetch or create the object */
        if (subjectStudyGradeTypeForm.getSubjectStudyGradeType() == null) {

            // check if subjectStudyGradeTypeId exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyGradeTypeId"))) {
                subjectStudyGradeTypeId = Integer.parseInt(
                                            request.getParameter("subjectStudyGradeTypeId"));
            }

            // EXISTING subjectStudyGradeType
            if (subjectStudyGradeTypeId != 0) {
            	
            	log.debug("subjectstudygradetypeeditcontroller - studygradetype != 0");
            	HashMap map = new HashMap();
                map.put("subjectStudyGradeTypeId", subjectStudyGradeTypeId);
                map.put("preferredLanguage", preferredLanguage);
                subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(map);
                
                // save the existing studyGradeTypeId: needed for check in dropdown box
                subjectStudyGradeTypeForm.setCurrentStudyGradeTypeId(subjectStudyGradeType.getStudyGradeTypeId());
                
                // set default organization id's
                // find organization id's matching with the studyId of the subjectStudyGradeType
                studyId = subjectStudyGradeType.getStudyGradeType().getStudyId();
                organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                                studyId)).getId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);

             // NEW subjectStudyGradeType
            } else {
                subjectStudyGradeType = new SubjectStudyGradeType();
                subjectStudyGradeType.setSubjectId(subjectId);
                subjectStudyGradeType.setStudyId(studyId);
                
                // set empty studyGradeType
                studyGradeType = new StudyGradeType();
                studyGradeType.setStudyId(studyId);
                studyGradeType.setCurrentAcademicYearId(subject.getCurrentAcademicYearId());
                subjectStudyGradeType.setActive("Y");
            }
            subjectStudyGradeTypeForm.setSubjectStudyGradeType(subjectStudyGradeType);
            // determine maxNumberOfCardinalTimeUnits of existing
            
            if (subjectStudyGradeType.getStudyGradeTypeId() != 0) {
            	studyGradeType = studyManager.findStudyGradeType(subjectStudyGradeType.getStudyGradeTypeId());
                maxNumberOfCardinalTimeUnits = studyGradeType.getMaxNumberOfCardinalTimeUnits();
                numberOfCardinalTimeUnits = studyGradeType.getNumberOfCardinalTimeUnits();
                if (maxNumberOfCardinalTimeUnits != 0) {
                	subjectStudyGradeTypeForm.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);
                } else {
                	subjectStudyGradeTypeForm.setMaxNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
                }
                subjectStudyGradeTypeForm.setNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
            }
        } else {
            subjectStudyGradeType = subjectStudyGradeTypeForm.getSubjectStudyGradeType();
            
            // determine maxNumberOfCardinalTimeUnits and numberOfCardinalTimeUnits
            if (subjectStudyGradeType.getStudyId() != 0
                    && !StringUtil.isNullOrEmpty(subjectStudyGradeType.getGradeTypeCode(), true)
                    && currentAcademicYearId != 0
                    && subjectStudyGradeType.getStudyGradeTypeId() != 0
                    ) {
                studyGradeType = studyManager.findStudyGradeType(subjectStudyGradeType
                                                            .getStudyGradeTypeId());
                if (maxNumberOfCardinalTimeUnits != 0) {
                	subjectStudyGradeTypeForm.setMaxNumberOfCardinalTimeUnits(studyGradeType
                                                            .getMaxNumberOfCardinalTimeUnits());
                } else {
                	subjectStudyGradeTypeForm.setMaxNumberOfCardinalTimeUnits(studyGradeType
                            .getNumberOfCardinalTimeUnits());
                }
                subjectStudyGradeTypeForm.setNumberOfCardinalTimeUnits(studyGradeType
                                                            .getNumberOfCardinalTimeUnits());
            } else {
                subjectStudyGradeTypeForm.setMaxNumberOfCardinalTimeUnits(0);
                subjectStudyGradeTypeForm.setNumberOfCardinalTimeUnits(0);
            }
            
        }
        
        /* ORGANIZATION - fetch or create the object */
        if (subjectStudyGradeTypeForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectStudyGradeTypeForm.setOrganization(organization);

        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectStudyGradeTypeForm.getOrganization();
        }
        
        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectStudyGradeTypeForm.getNavigationSettings() != null) {
            navigationSettings = subjectStudyGradeTypeForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        subjectStudyGradeTypeForm.setNavigationSettings(navigationSettings);
        
        if (subjectStudyGradeTypeForm.getAllAcademicYears() == null) {
            Map academicYearMap = new HashMap();
            academicYearMap.put("organizationalUnitId" , organization.getOrganizationalUnitId());
            subjectStudyGradeTypeForm.setAllAcademicYears(
                                            academicYearManager.findAllAcademicYears());
        }

    	// check if subjectstudygradetype is connected to any studyplan:
        if (subjectStudyGradeType.getSubjectId() != 0 && 
        		subjectStudyGradeType.getStudyGradeTypeId() != 0) {
	        Locale currentLoc = RequestContextUtils.getLocale(request);
	        HashMap map = new HashMap();
	        map.put("subjectId", subjectStudyGradeType.getSubjectId());
	        map.put("studyGradeTypeId", subjectStudyGradeType.getStudyGradeTypeId());

	        List <? extends StudyPlanDetail > studyPlanDetails = 
	    		studentManager.findStudyPlanDetailsByParams(map);
    	    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {   		
    	        if (request.isUserInRole("CREATE_STUDYGRADETYPES")) {
    	    		subjectStudyGradeTypeForm.setTxtMsg(
    	    			messageSource.getMessage(
                        "jsp.error.subjectstudygradetype.edit", null, currentLoc)
                        + messageSource.getMessage(
                        "jsp.error.general.delete.linked.studyplandetail", null, currentLoc));
    	    	} else {
	    	    	subjectStudyGradeTypeForm.setShowSubjectStudyGradeTypeError( 
		    			messageSource.getMessage(
		                    "jsp.error.subjectstudygradetype.edit", null, currentLoc)
		                + messageSource.getMessage(
		                    "jsp.error.general.delete.linked.studyplandetail", null, currentLoc));
    	    	}
    	    }
        }
        
        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pullDowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                subjectStudyGradeTypeForm.getOrganization(), session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());

        /* study domain attributes */
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getSubjectLookups(preferredLanguage, request);

        // get list of studies
        if (organization.getInstitutionId() != 0) {
            Map<String, Object> findStudiesMap = new HashMap<>();
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            subjectStudyGradeTypeForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        }

        studyId = subjectStudyGradeType.getStudyId();
        currentAcademicYearId = subject.getCurrentAcademicYearId();
        
        // DistinctStudyGradeTypesForStudy
        if (studyId != 0) {
            Map<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", studyId);
            findGradeTypesForStudyMap.put("currentAcademicYearId", currentAcademicYearId);
            subjectStudyGradeTypeForm.setDistinctStudyGradeTypesForStudy(
                        studyManager.findDistinctStudyGradeTypesForStudy(findGradeTypesForStudyMap));            
        } else {
            subjectStudyGradeTypeForm.setDistinctStudyGradeTypesForStudy(null);
        }
        
        // allStudyGradeTypesForStudy and AllStudyGradeTypesForSubject
        if (!StringUtil.isNullOrEmpty(subjectStudyGradeType.getGradeTypeCode(), true)) {
            Map<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", studyId);
            findGradeTypesForStudyMap.put("gradeTypeCode", subjectStudyGradeType.getGradeTypeCode());
            findGradeTypesForStudyMap.put("currentAcademicYearId", currentAcademicYearId);
            subjectStudyGradeTypeForm.setAllStudyGradeTypesForStudy(
                        studyManager.findAllStudyGradeTypesForStudy(findGradeTypesForStudyMap));
            Map<String, Object> findGradeTypesForSubjectStudiesMap = new HashMap<>();
            findGradeTypesForSubjectStudiesMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForSubjectStudiesMap.put("studyId", studyId);
            findGradeTypesForSubjectStudiesMap.put("currentAcademicYearId", currentAcademicYearId);
            findGradeTypesForSubjectStudiesMap.put("subjectId", subject.getId());
            subjectStudyGradeTypeForm.setAllStudyGradeTypesForSubject(studyManager.findGradeTypesForSubjectStudies(
                                                            findGradeTypesForSubjectStudiesMap));
        } else {
            subjectStudyGradeTypeForm.setAllStudyGradeTypesForStudy(null);
        }
        
        // subjectclassgroup
        if (subjectStudyGradeType != null && subjectStudyGradeType.getId() != 0 && subjectStudyGradeType.getStudyGradeTypeId() != 0 && subjectStudyGradeType.getSubjectId() != 0) {
			Map<String, Object> findClassgroupsMap = new HashMap<String, Object>();
			findClassgroupsMap.put("studyGradeTypeId", subjectStudyGradeType.getStudyGradeTypeId());
			findClassgroupsMap.put("subjectId", subjectStudyGradeType.getSubjectId());
			subjectStudyGradeTypeForm.setAllClassgroups(studyManager.findClassgroups(findClassgroupsMap));
			subjectStudyGradeTypeForm.setIdToAcademicYearMap(new IdToAcademicYearMap(academicYearManager.findAllAcademicYears()));
		} else {
			subjectStudyGradeTypeForm.setAllClassgroups(null);
		}
        
        model.addAttribute("subjectStudyGradeTypeForm", subjectStudyGradeTypeForm);        
        return formView;
    }
    
    @RequestMapping(value="/college/subjectstudygradetype.view", method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectStudyGradeTypeForm") SubjectStudyGradeTypeForm subjectStudyGradeTypeForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectStudyGradeTypeEditController.processSubmit entered...");
        }
        
    	SubjectStudyGradeType subjectStudyGradeType = subjectStudyGradeTypeForm
    	                                                    .getSubjectStudyGradeType();
    	Subject subject = subjectStudyGradeTypeForm.getSubject();
        NavigationSettings navSettings = subjectStudyGradeTypeForm.getNavigationSettings();

        String txtErr = "";
        String submitFormObject = "";
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectStudyGradeTypeValidator().validate(subjectStudyGradeType, result);
            if (result.hasErrors()) {
                /* if an error is detected by the Validator, then the setUpForm is not called. Therefore
                 * the lookup tables need to be filled in this method as well
                 */
                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                lookupCacher.getSubjectLookups(preferredLanguage, request);
                
                return formView;
            }
            
            Locale currentLoc = RequestContextUtils.getLocale(request);

            if (subjectStudyGradeType.getStudyGradeTypeId() == 0) {

                subjectStudyGradeTypeForm.setShowSubjectStudyGradeTypeError(messageSource.getMessage(
                        "jsp.error.subjectstudygradetype.edit", null, currentLoc)
                + messageSource.getMessage(
                        "jsp.general.studygradetype", null, currentLoc)
                + " " + messageSource.getMessage(
                        "invalid.empty.format", null, currentLoc));
                
                return "redirect:/college/subjectstudygradetype.view";
                
            } else {
            	

                HashMap map = new HashMap();
                map.put("subjectId", subject.getId());
                map.put("studyGradeTypeId", subjectStudyGradeType.getStudyGradeTypeId());

            	// check if subjectstudygradetype is connected to any studyplan:

		        List <? extends StudyPlanDetail > studyPlanDetails = 
		    		studentManager.findStudyPlanDetailsByParams(map);
	    	    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
	    	    	
	    	        if (request.isUserInRole("CREATE_STUDYGRADETYPES")) {
	    	    		subjectStudyGradeTypeForm.setTxtMsg(
	    	    			messageSource.getMessage(
	                        "jsp.error.subjectstudygradetype.edit", null, currentLoc)
	                        + messageSource.getMessage(
	                        "jsp.error.general.delete.linked.studyplandetail", null, currentLoc));
	    	    	} else {
		            	
	    	    		subjectStudyGradeTypeForm.setShowSubjectStudyGradeTypeError( 
	    	    			messageSource.getMessage(
                            "jsp.error.subjectstudygradetype.edit", null, currentLoc)
                            + messageSource.getMessage(
                            "jsp.error.general.delete.linked.studyplandetail", null, currentLoc));

                        return "redirect:/college/subjectstudygradetype.view";
	    	    	}    
            	}
	    	    
	    	    /* if the subject has no teacher or the subject has an examination but no
	    	     * examination teacher, this subject cannot be linked to any studyGradeType
	    	     */
	    	    if (!subjectStudyGradeTypeForm.getSubject().isLinkSubjectAndStudyGradeTypeIsAllowed()) {
	    	        txtErr = messageSource.getMessage(
	                      "jsp.error.link.subject.studygradetype.teacher.missing", null, currentLoc);

    	    	    subjectStudyGradeTypeForm.setTxtErr(txtErr);
    	    	    
	                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
	                lookupCacher.getStudyLookups(preferredLanguage, request);
	                lookupCacher.getSubjectLookups(preferredLanguage, request);
    	    	                
	    	        return formView;
	    	    } else {
	    	        subjectStudyGradeTypeForm.setTxtErr("");
	    	    }

                // insert new
                if (subjectStudyGradeType.getId() == 0) {
                    subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
                    
                    int newId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);
                    // should work but doesn't do anything in this case, not needed
                    status.setComplete();
                    
                    return "redirect:/college/subjectstudygradetype.view?newForm=true&tab="
                    + navSettings.getTab()
                    + "&panel=" + navSettings.getPanel() 
                    + "&subjectId=" + subject.getId()
                    + "&subjectStudyGradeTypeId=" + newId
                    + "&currentPageNumber="
                    + navSettings.getCurrentPageNumber();
                } else {
                    subjectManager.updateSubjectStudyGradeType(subjectStudyGradeType);
                    
                    // should work but doesn't do anything in this case, not needed
                    status.setComplete();
                    
                    return "redirect:/college/subject.view?newForm=true&tab=" + navSettings.getTab()
                    + "&panel=" + navSettings.getPanel() 
                    + "&subjectId=" + subject.getId()
                    + "&currentPageNumber="
                    + navSettings.getCurrentPageNumber();
                }

            }
        // submit but no save
        } else {
            return "redirect:/college/subjectstudygradetype.view";
        }
    }
	
	@RequestMapping(value="/college/subject/subjectclassgroup_delete.view", method = RequestMethod.GET)
	public String processDelete(
			@ModelAttribute("subjectStudyGradeTypeForm") SubjectStudyGradeTypeForm subjectStudyGradeTypeForm,
			BindingResult result,
			SessionStatus status,
			HttpServletRequest request,
			ModelMap model) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        NavigationSettings navigationSettings = subjectStudyGradeTypeForm.getNavigationSettings();
        
        int classgroupId = Integer.parseInt(request.getParameter("classgroupId"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        int subjectStudyGradeTypeId = Integer.parseInt(request.getParameter("subjectStudyGradeTypeId"));

        if (classgroupId != 0 && subjectId != 0) {
        	// TODO: clarify if there are any conditions which prevent the deletion of a subjectclassgroup.

        	String showError = "";
        	//showError = "test";
        	
            if (!"".equals(showError)) {
                return "redirect:/college/subjectstudygradetype.view"
                		+ "?tab=" + navigationSettings.getTab()
        		        + "&panel=" + navigationSettings.getPanel() 
        		        + "&subjectId=" + subjectId
        		        + "&subjectStudyGradeTypeId=" + subjectStudyGradeTypeId
        		        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            			+ "&showSubjectClassgroupError=" + showError;
            } 
            
            studyManager.deleteSubjectClassgroup(subjectId, classgroupId);
            
            status.setComplete();
        }

        return "redirect:/college/subjectstudygradetype.view"
        		+ "?tab=" + navigationSettings.getTab()
		        + "&panel=" + navigationSettings.getPanel() 
		        + "&subjectId=" + subjectId
		        + "&subjectStudyGradeTypeId=" + subjectStudyGradeTypeId
		        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
	}
}
