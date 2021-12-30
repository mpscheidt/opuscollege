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
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyDescriptionMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.SubjectBlockValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectBlockForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/subjectblock")
@SessionAttributes("subjectBlockForm")
public class SubjectBlockEditController {
    
    private static Logger log = LoggerFactory.getLogger(SubjectBlockEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudentManagerInterface studentManager;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    private String formView;
     
	public SubjectBlockEditController() {
		super();
		this.formView = "college/subjectblock/subjectBlock";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {
		TimeTrack timer = new TimeTrack("SubjectBlockEditController");
            
        if (log.isDebugEnabled()) {
            log.debug("SubjectBlockEditController.setUpForm entered...");
        }

        HttpSession session = request.getSession(false);        
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new subject, destroy any existing one on the session
        opusMethods.removeSessionFormObject("subjectBlockForm", session, model, opusMethods.isNewForm(request));
        
        /* set menu to curriculum */
        session.setAttribute("menuChoice", "studies");
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        // declare variables
        Organization organization = null;
        NavigationSettings navigationSettings = null;
        
        SubjectBlock subjectBlock = null;
        int subjectBlockId = 0;
        int studyId = 0;
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String showSubjectBlockStudyGradeTypeError = "";
        String showSubjectBlockSubjectError = "";
        String showSubjectSubjectBlockError = "";
        
        /* fetch or create the form object */
        SubjectBlockForm subjectBlockForm = (SubjectBlockForm) model.get("subjectBlockForm");
        if (subjectBlockForm == null) {
            subjectBlockForm = new SubjectBlockForm();
        }

        // entering the form: the SubjectForm.subject does not exist yet
        if (subjectBlockForm.getSubjectBlock() == null) {
            // get the subjectId if it exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockId"))) {
                subjectBlockId = Integer.parseInt(request.getParameter("subjectBlockId"));
            }
            
            // EXISTING SUBJECTBLOCK
            if (subjectBlockId != 0) {
                subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);

                // find organization id's matching with the subject
                studyId = subjectBlock.getPrimaryStudyId();
                organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                                studyId)).getId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);
            // NEW SUBJECTBLOCK
            } else {
                subjectBlock = new SubjectBlock();
                subjectBlock.setActive("Y");
                // set default organization id's
                institutionId = OpusMethods.getInstitutionId(session, request);
                branchId = OpusMethods.getBranchId(session, request);
                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            }
            subjectBlockForm.setSubjectBlock(subjectBlock);
        } else {
            subjectBlock = subjectBlockForm.getSubjectBlock();
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectBlockError"))) {
            subjectBlockForm.setShowSubjectBlockError(request.getParameter("showSubjectBlockError"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectBlockStudyGradeTypeError"))) {
            showSubjectBlockStudyGradeTypeError = request.getParameter(
                                                        "showSubjectBlockStudyGradeTypeError");
            subjectBlockForm.setShowSubjectBlockStudyGradeTypeError(showSubjectBlockStudyGradeTypeError);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectSubjectBlockError"))) {
            showSubjectSubjectBlockError = request.getParameter("showSubjectSubjectBlockError");
            subjectBlockForm.setShowSubjectSubjectBlockError(showSubjectSubjectBlockError);
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showSubjectBlockSubjectError"))) {
            showSubjectBlockSubjectError = 
                    request.getParameter("showSubjectBlockSubjectError");
            subjectBlockForm.setShowSubjectBlockSubjectError(showSubjectBlockSubjectError);
        }

        if (subjectBlockForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject or default values
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectBlockForm.setOrganization(organization);
        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectBlockForm.getOrganization();
        }

        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectBlockForm.getNavigationSettings() != null) {
            navigationSettings = subjectBlockForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        subjectBlockForm.setNavigationSettings(navigationSettings);

       	// check if one of the subjectblockstudygradetypes is connected to any studyplan:
        List < ? extends SubjectBlockStudyGradeType > subjectBlockStudyGradeTypes = 
        		subjectBlock.getSubjectBlockStudyGradeTypes();
        if (subjectBlockStudyGradeTypes != null && subjectBlockStudyGradeTypes.size() != 0) {
            for (int i = 0; i < subjectBlockStudyGradeTypes.size();i++) {
    	        if (subjectBlockStudyGradeTypes.get(i).getStudyGradeType().getId() != 0
    	        		&& subjectBlockStudyGradeTypes.get(i).getSubjectBlock().getId() != 0) {
    		        Locale currentLoc = RequestContextUtils.getLocale(request);
    		        HashMap<String, Object> map = new HashMap<>();
    		        map.put("studyGradeTypeId", subjectBlockStudyGradeTypes.get(i).getStudyGradeType().getId());
    		        map.put("subjectBlockId", subjectBlockStudyGradeTypes.get(i).getSubjectBlock().getId());
    		        map.put("cardinalTimeUnitNumber", subjectBlockStudyGradeTypes.get(i).getCardinalTimeUnitNumber());
    		    	List <? extends StudyPlanDetail > studyPlanDetails = 
    		    		studentManager.findStudyPlanDetailsByParams(map);
		    	    if (studyPlanDetails != null && studyPlanDetails.size() != 0) {	
    		    		subjectBlockForm.setShowSubjectBlockError(
    		    			messageSource.getMessage(
    		                    "jsp.warning.subjectblock.edit", null, currentLoc)
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
                subjectBlockForm.getOrganization(), session, request
                            , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                            , organization.getBranchId(), organization.getOrganizationalUnitId());

        /* put lookup-tables on the request */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getAddressLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getSubjectLookups(preferredLanguage, request);
        
        subjectBlockForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
        subjectBlockForm.setAllStudyTimes(lookupCacher.getAllStudyTimes(preferredLanguage));
        subjectBlockForm.setAllStudyForms(lookupCacher.getAllStudyForms(preferredLanguage));
        subjectBlockForm.setAllBlockTypes(lookupCacher.getAllBlockTypes());
        subjectBlockForm.setAllRigidityTypes(lookupCacher.getAllRigidityTypes(preferredLanguage));
        subjectBlockForm.setAllImportanceTypes(lookupCacher.getAllImportanceTypes(preferredLanguage));

        
        /* put lists in subjectBlockForm */
        if (subjectBlockForm.getAllAcademicYears() == null) {
            subjectBlockForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
        }

        // utility
        subjectBlockForm.setIdToAcademicYearMap(new IdToAcademicYearMap(subjectBlockForm.getAllAcademicYears()));
        
        if (organization.getOrganizationalUnitId() != 0) {
            /*  used to show the primaryStudy in the list of subjects; organization id's should
                not be included, since the subject may be from another organization than the
                subjectBlock it is linked to
            */
            Map<String, Object> findStudiesMap = new HashMap<>();
            findStudiesMap.put("institutionId", 0);
            findStudiesMap.put("branchId", 0);
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            subjectBlockForm.setAllPrimaryStudies(studyManager.findStudies(findStudiesMap));
        } else {
            subjectBlockForm.setAllPrimaryStudies(null);
        }
        
        if (subjectBlockForm.getAllStudies() == null) {
            Map<String, Object> findAllStudiesMap = new HashMap<>();
            findAllStudiesMap.put("institutionId", 0);
            findAllStudiesMap.put("branchId", 0);
            findAllStudiesMap.put("organizationalUnitId", 0);
            findAllStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            subjectBlockForm.setAllStudies(studyManager.findStudies(findAllStudiesMap));
        }
        request.setAttribute("idToStudyDescriptionMap", new IdToStudyDescriptionMap(subjectBlockForm.getAllStudies()));


        /*  used to show the studyGradeType in the list of studyGradeTypes; organization id's
            should not be included, since the studyGradeType may be from another organization
            than the subjectBlock it is linked to.
        */
        Map<String, Object> findStudyGradeTypesMap = new HashMap<>();
        findStudyGradeTypesMap.put("institutionId", 0);
        findStudyGradeTypesMap.put("branchId", 0);
        findStudyGradeTypesMap.put("organizationalUnitId", 0);
        findStudyGradeTypesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
        subjectBlockForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findStudyGradeTypesMap));

        model.addAttribute("subjectBlockForm", subjectBlockForm);      
        timer.end();
        return formView;
    }

   
	@RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectBlockForm") SubjectBlockForm subjectBlockForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        SubjectBlock subjectBlock = subjectBlockForm.getSubjectBlock();
        NavigationSettings navigationSettings = subjectBlockForm.getNavigationSettings();
        Organization organization = subjectBlockForm.getOrganization();
        String submitFormObject = "";

        HttpSession session = request.getSession(false);        

        Locale currentLoc = RequestContextUtils.getLocale(request);

        // if empty, create unique subjectBlockCode
        if (StringUtil.isNullOrEmpty(subjectBlock.getSubjectBlockCode(), true)) {
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String subjectBlockCode = StringUtil.createUniqueCode("SB", strRandomCode); 
            subjectBlock.setSubjectBlockCode(subjectBlockCode);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectBlockValidator().validate(subjectBlock, result);
            if (result.hasErrors()) {
                return formView;
            }

            if (StringUtil.isNullOrEmpty(subjectBlock.getSubjectBlockCode())) {
                subjectBlockForm.setShowSubjectBlockError(
                                messageSource.getMessage("jsp.error.subjectblock.edit"
                                                                , null, currentLoc));                
            } else {
                /* test if the combination already exists */
//                Map<String, Object> findSubjectBlockMap = new HashMap<>();
//                findSubjectBlockMap.put("code", subjectBlock.getSubjectBlockCode());
//                findSubjectBlockMap.put("description", subjectBlock.getSubjectBlockDescription());
//                findSubjectBlockMap.put("currentAcademicYearId", subjectBlock.getCurrentAcademicYearId());
                SubjectBlock sameSubjectBlock = subjectBlockMapper.findSubjectBlockByParams(subjectBlock.getSubjectBlockCode(),
                        subjectBlock.getCurrentAcademicYearId(), subjectBlock.getSubjectBlockDescription());
                
                if (sameSubjectBlock != null && sameSubjectBlock.getId() != subjectBlock.getId()) {

                    result.reject("jsp.error.subjectblock.edit");
                    result.reject("jsp.error.subjectblock.alreadyexists", new String[] {
                            subjectBlock.getSubjectBlockCode(),
                            subjectBlock.getSubjectBlockDescription(),
                            subjectBlockForm.getIdToAcademicYearMap().get(subjectBlock.getCurrentAcademicYearId()).getDescription()
                    }, "Subjectblock already exists");
                    return formView;
                }
            }
            
            	// NEW SUBJECTBLOCK
                if (subjectBlock.getId() == 0) {
        
                    //new subjectblock is added with minimum fields);
                    subjectBlockMapper.addSubjectBlock(subjectBlock);
                    status.setComplete();
//                    int lastSubjectBlockId = subjectBlock.getId();
//                    // id not known yet
//                    changedSubjectBlock = subjectBlockMapper.findSubjectBlock(lastSubjectBlockId);
    
                    return "redirect:/college/subjectblock.view?newForm=true&subjectBlockId=" 
                                                        + subjectBlock.getId(); 
                // UPDATE SUBJECTBLOCK
                } else {
                    subjectBlockMapper.updateSubjectBlock(subjectBlock);
                    status.setComplete();
                
//                    subjectBlock = subjectManager.findSubjectBlock(subjectBlock.getId());
                    return "redirect:/college/subjectblocks.view?newForm=true&subjectBlockId="
                                    + subjectBlock.getId()
                                    + "&currentPageNumber="
                                    + navigationSettings.getCurrentPageNumber();
                }
        } else {
            // submit but no save
            //status.setComplete();
            session.setAttribute("institutionId", organization.getInstitutionId());
            session.setAttribute("branchId", organization.getBranchId());
            session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());

            return "redirect:/college/subjectblock.view";
        } 
    }

}
