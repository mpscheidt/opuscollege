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
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectBlockStudyGradeTypeValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectBlockStudyGradeTypeForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectblockstudygradetype.view")
@SessionAttributes("subjectBlockStudyGradeTypeForm")
public class SubjectBlockStudyGradeTypeEditController {

   
    private static Logger log = LoggerFactory.getLogger(SubjectBlockStudyGradeTypeEditController.class);
    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private StudentManagerInterface studentManager;
     
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public SubjectBlockStudyGradeTypeEditController() {
        super();
        this.formView = "college/subjectblock/subjectBlockStudyGradeType";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectBlockStudyGradeTypeEditController.setUpForm entered...");
        }
        
        // if adding or editing a new subjectStudyGradeType, destroy existing ones on the session
        opusMethods.removeSessionFormObject("subjectBlockStudyGradeTypeForm", session, model, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        SubjectBlockStudyGradeTypeForm subjectBlockStudyGradeTypeForm = null;
        SubjectBlockStudyGradeType subjectBlockStudyGradeType = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;
        
        int currentAcademicYearId = 0;

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int subjectBlockId = 0;
        int studyId = 0;
        int subjectBlockStudyGradeTypeId = 0;
        StudyGradeType studyGradeType = null;
        int maxNumberOfCardinalTimeUnits = 0;
        int numberOfCardinalTimeUnits = 0;
        SubjectBlock subjectBlock = null;

        /* fetch or create the form object */
        if ((SubjectBlockStudyGradeTypeForm) session.getAttribute("subjectBlockStudyGradeTypeForm") 
                                                                                    != null) {
            subjectBlockStudyGradeTypeForm = (SubjectBlockStudyGradeTypeForm) 
                                        session.getAttribute("subjectBlockStudyGradeTypeForm");
        } else {
            subjectBlockStudyGradeTypeForm = new SubjectBlockStudyGradeTypeForm();           
        }

        if (subjectBlockStudyGradeTypeForm.getSubjectBlockStudyGradeType() == null) {
            // check if subjectBlockStudyGradeTypeId exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockStudyGradeTypeId"))) {
                subjectBlockStudyGradeTypeId = Integer.parseInt(
                                            request.getParameter("subjectBlockStudyGradeTypeId"));
            }
        
            // existing subjectBlockStudyGradeType
            if (subjectBlockStudyGradeTypeId != 0) {
                
                subjectBlockStudyGradeType = subjectBlockMapper
                                        .findSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId, preferredLanguage);
                // save the existing studyGradeTypeId: needed for check in dropdown box
                subjectBlockStudyGradeTypeForm.setCurrentStudyGradeTypeId(subjectBlockStudyGradeType.getStudyGradeType().getId());
                subjectBlockId = subjectBlockStudyGradeType.getSubjectBlock().getId();
                // needed to find the correct organizations
                studyId = subjectBlockStudyGradeType.getStudyGradeType().getStudyId();

            } else {
                // new subjectBlockStudyGradeType
                subjectBlockStudyGradeType = new SubjectBlockStudyGradeType();
                subjectBlockStudyGradeType.setActive("Y");           

                // get the subjectBlockId, should always exist
                if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockId"))) {
                  subjectBlockId = Integer.parseInt(request.getParameter("subjectBlockId"));
                }
                subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);
                // needed to find the correct organizations
                studyId = subjectBlock.getPrimaryStudyId();
                
                subjectBlockStudyGradeType.setSubjectBlock(subjectBlock);
                
                // set empty studyGradeType
                studyGradeType = new StudyGradeType();
                studyGradeType.setStudyId(studyId);
                studyGradeType.setCurrentAcademicYearId(subjectBlock.getCurrentAcademicYearId());
                
                subjectBlockStudyGradeType.setStudyGradeType(studyGradeType);
            }
            
            subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);
            subjectBlockStudyGradeTypeForm.setSubjectBlock(subjectBlock);
            subjectBlockStudyGradeTypeForm.setSubjectBlockStudyGradeType(subjectBlockStudyGradeType);

            // set default organization id's
            // find organization id's matching with the studyId determined before
            organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                            studyId)).getId();
            branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            institutionId = institutionManager.findInstitutionOfBranch(branchId);
            
        } else {
            subjectBlockStudyGradeType = subjectBlockStudyGradeTypeForm
                                                    .getSubjectBlockStudyGradeType();
        }

        /* ORGANIZATION - fetch or create the object */
        if (subjectBlockStudyGradeTypeForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectBlockStudyGradeTypeForm.setOrganization(organization);
    
        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectBlockStudyGradeTypeForm.getOrganization();
        }
    
        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectBlockStudyGradeTypeForm.getNavigationSettings() != null) {
            navigationSettings = subjectBlockStudyGradeTypeForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            subjectBlockStudyGradeTypeForm.setNavigationSettings(navigationSettings);
        }

       	// check if subjectblockstudygradetype is connected to any studyplan:
        if (subjectBlockStudyGradeType.getStudyGradeType().getId() != 0
        		&& subjectBlockStudyGradeType.getSubjectBlock().getId() != 0) {
	        Locale currentLoc = RequestContextUtils.getLocale(request);
	        HashMap<String, Object> map = new HashMap<>();
	        map.put("studyGradeTypeId", subjectBlockStudyGradeType.getStudyGradeType().getId());
	        map.put("subjectBlockId", subjectBlockStudyGradeType.getSubjectBlock().getId());
	        map.put("cardinalTimeUnitNumber", subjectBlockStudyGradeType.getCardinalTimeUnitNumber());

	        List <? extends StudyPlanDetail > studyPlanDetails = 
	    		studentManager.findStudyPlanDetailsByParams(map);
    	    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {   		
	    		subjectBlockStudyGradeTypeForm.setShowSubjectBlockStudyGradeTypeError(
	    			messageSource.getMessage(
	                    "jsp.error.subjectblockstudygradetype.edit", null, currentLoc)
	                + messageSource.getMessage(
	                    "jsp.error.general.delete.linked.studyplandetail", null, currentLoc));
	    	}
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pullDowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                subjectBlockStudyGradeTypeForm.getOrganization(), session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());

        if (subjectBlockStudyGradeTypeForm.getAllAcademicYears() == null) {
            subjectBlockStudyGradeTypeForm.setAllAcademicYears(
                                            academicYearManager.findAllAcademicYears());
        }
        
        // get list of studies
        if (organization.getOrganizationalUnitId() != 0) {
            HashMap<String, Object> findStudiesMap = new HashMap<>();

            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            subjectBlockStudyGradeTypeForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            subjectBlockStudyGradeTypeForm.setAllStudies(null);
        }

        // set parameters for retrieving lists
        subjectBlock = subjectBlockStudyGradeType.getSubjectBlock();
        
        currentAcademicYearId = subjectBlock.getCurrentAcademicYearId();
        studyGradeType = subjectBlockStudyGradeType.getStudyGradeType();
        studyId = studyGradeType.getStudyId();

        if (studyId != 0) {
            
            HashMap<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", studyId);
            findGradeTypesForStudyMap.put("currentAcademicYearId", currentAcademicYearId);
            subjectBlockStudyGradeTypeForm.setDistinctStudyGradeTypesForStudy(
                        studyManager.findDistinctStudyGradeTypesForStudy(
                                                            findGradeTypesForStudyMap));
        } else {
            subjectBlockStudyGradeTypeForm.setDistinctStudyGradeTypesForStudy(null);
        }
        
        // allStudyGradeTypesForStudy
        if (!StringUtil.isNullOrEmpty(studyGradeType.getGradeTypeCode(), true)) {
            HashMap<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", studyId);
            findGradeTypesForStudyMap.put("currentAcademicYearId", currentAcademicYearId);
            findGradeTypesForStudyMap.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
            subjectBlockStudyGradeTypeForm.setAllStudyGradeTypesForStudy(
                            studyManager.findAllStudyGradeTypesForStudy(
                                                            findGradeTypesForStudyMap));
        } else {
            subjectBlockStudyGradeTypeForm.setAllStudyGradeTypesForStudy(null);
        }

        // numberOfCardinalTimeUnits and maxNumberOfCardinalTimeUnits
        if (studyGradeType.getId() != 0) {
            studyGradeType = studyManager.findStudyGradeType(studyGradeType.getId());
        } else if (studyGradeType.getId() == 0
                && !StringUtil.isNullOrEmpty(studyGradeType.getGradeTypeCode(), true)
                && currentAcademicYearId != 0
                && !StringUtil.isNullOrEmpty(studyGradeType.getStudyFormCode(), true)
                && !StringUtil.isNullOrEmpty(studyGradeType.getStudyTimeCode(), true)) {

            Map<String, Object> map = new HashMap<>();
            map.put("studyId", studyId);
            map.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
            map.put("currentAcademicYearId", currentAcademicYearId);
            map.put("studyFormCode", studyGradeType.getStudyFormCode());
            map.put("studyTimeCode", studyGradeType.getStudyTimeCode());
            map.put("studyIntensityCode", "F");
            StudyGradeType dummySgt = studyManager.findStudyGradeTypeByStudyAndGradeType(map);
            if (dummySgt != null) {
                maxNumberOfCardinalTimeUnits = dummySgt.getMaxNumberOfCardinalTimeUnits();
                numberOfCardinalTimeUnits =  dummySgt.getNumberOfCardinalTimeUnits();
            }
            if (maxNumberOfCardinalTimeUnits != 0) {
            	studyGradeType.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);
            } else {
            	studyGradeType.setMaxNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
            }
            studyGradeType.setNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
        } else {
            studyGradeType.setMaxNumberOfCardinalTimeUnits(0);
            studyGradeType.setNumberOfCardinalTimeUnits(0);
        }
        // resetting needed here
        subjectBlockStudyGradeTypeForm.getSubjectBlockStudyGradeType().setStudyGradeType(studyGradeType);
        
        if (subjectBlock.getId() != 0) {
            HashMap<String, Object> findGradeTypesForSubjectBlockStudiesMap = new HashMap<>();
            findGradeTypesForSubjectBlockStudiesMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForSubjectBlockStudiesMap.put("studyId", studyId);
            findGradeTypesForSubjectBlockStudiesMap.put("currentAcademicYearId", currentAcademicYearId);
            findGradeTypesForSubjectBlockStudiesMap.put("subjectBlockId", subjectBlock.getId());
            subjectBlockStudyGradeTypeForm.setAllStudyGradeTypesForSubjectBlock(
                    subjectBlockMapper.findGradeTypesForSubjectBlockStudies(
                                                            findGradeTypesForSubjectBlockStudiesMap));
        }
        
        /* put lookup-tables on the request */
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getSubjectLookups(preferredLanguage, request);
        
        model.addAttribute("subjectBlockStudyGradeTypeForm", subjectBlockStudyGradeTypeForm); 
        
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectBlockStudyGradeTypeForm") 
            SubjectBlockStudyGradeTypeForm subjectBlockStudyGradeTypeForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectBlockStudyGradeTypeEditController.processSubmit entered...");
        }

        SubjectBlockStudyGradeType subjectBlockStudyGradeType = subjectBlockStudyGradeTypeForm
        .getSubjectBlockStudyGradeType();
        NavigationSettings navSettings = subjectBlockStudyGradeTypeForm.getNavigationSettings();
        String showSubjectBlockStudyGradeTypeError = "";
        
        String submitFormObject = "";
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectBlockStudyGradeTypeValidator().validate(subjectBlockStudyGradeType, result);
            if (result.hasErrors()) {
                /* if an error is detected by the Validator, then the setUpForm is not called. Therefore
                 * the lookup tables need to be filled in this method as well
                 */
                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                lookupCacher.getSubjectLookups(preferredLanguage, request);
                
                return formView;
            }
            
            // check if subjectblockstudygradetype already exists:
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("studyGradeTypeId", subjectBlockStudyGradeType.getStudyGradeType().getId());
            map.put("subjectBlockId", subjectBlockStudyGradeType.getSubjectBlock().getId());
            map.put("cardinalTimeUnitNumber", subjectBlockStudyGradeType.getCardinalTimeUnitNumber());

            Locale currentLoc = RequestContextUtils.getLocale(request);

            if (subjectBlockStudyGradeType.getId() == 0 
                    && subjectBlockMapper.findSubjectBlockStudyGradeTypeByParams(map) != null) {
                showSubjectBlockStudyGradeTypeError =  messageSource.getMessage(
                        "jsp.error.subjectblockstudygradetype.edit", null, currentLoc);
                    showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                        + messageSource.getMessage(
                        "jsp.error.subjectblockstudygradetype.exists", null, currentLoc);
                    subjectBlockStudyGradeTypeForm.setShowSubjectBlockStudyGradeTypeError(
                                                        showSubjectBlockStudyGradeTypeError);
                    
                    return "redirect:/college/subjectblockstudygradetype.view";
            } else {
            	
                if (subjectBlockStudyGradeType.getId() == 0) {
                    // insert new
                    subjectBlockMapper.addSubjectBlockStudyGradeType(subjectBlockStudyGradeType);
                } else {
                    // update existing
                    subjectBlockMapper.updateSubjectBlockStudyGradeType(subjectBlockStudyGradeType);
                }
                status.setComplete();
                return "redirect:/college/subjectblock.view?newForm=true&tab=" + navSettings.getTab() 
                + "&panel=" + navSettings.getPanel()
                + "&subjectBlockId=" + subjectBlockStudyGradeType.getSubjectBlock().getId()
                + "&currentPageNumber=" + navSettings.getCurrentPageNumber(); 
            }

        // submit but no save
        } else {
            return "redirect:/college/subjectblockstudygradetype.view";
        }
    }

}
