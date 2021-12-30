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
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectSubjectBlockValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectBlockSubjectForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectblocksubject.view")
@SessionAttributes("subjectBlockSubjectForm")
public class SubjectBlockSubjectEditController {
    
    private static Logger log = LoggerFactory.getLogger(SubjectBlockSubjectEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private MessageSource messageSource;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private InstitutionManagerInterface institutionManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    
    private String formView;
     
     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public SubjectBlockSubjectEditController() {
		super();
		this.formView = "college/subjectblock/subjectBlockSubject";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectBlockSubjectEditController.setUpForm entered...");
        }
        
        // if adding or editing a new subjectStudyGradeType, destroy existing ones on the session
        opusMethods.removeSessionFormObject("subjectBlockSubjectForm", session
                                            , opusMethods.isNewForm(request));
        
        SubjectBlockSubjectForm subjectBlockSubjectForm = null;
        SubjectSubjectBlock subjectSubjectBlock = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        Subject subject = null;
        SubjectBlock subjectBlock = null;
        int subjectBlockId = 0;
        int studyId = 0;
        int subjectSubjectBlockId = 0;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        
        /* create the form object */
        subjectBlockSubjectForm = new SubjectBlockSubjectForm();           
        
        // get the subjectSubjectBlock if it exists
        if (request.getParameter("subjectSubjectBlockId") != null 
                && !"".equals(request.getParameter("subjectSubjectBlockId"))) {
            subjectSubjectBlockId = Integer.parseInt(
                                    request.getParameter("subjectSubjectBlockId"));
        }
        
        // subjectSubjectBlock exists
        if (subjectSubjectBlockId != 0) {
            // find the subjectSubjectBlock
            subjectSubjectBlock = subjectManager.findSubjectSubjectBlock(
                                                            subjectSubjectBlockId);
            // save the existing subjectSubjectBlock: needed for check in dropdown box
            subjectBlockSubjectForm.setCurrentSubjectId(subjectSubjectBlock.getSubject()
                                                                            .getId());
            // needed to find the correct organizations
            studyId = subjectSubjectBlock.getSubject().getPrimaryStudyId();
            subjectBlockId = subjectSubjectBlock.getSubjectBlockId();
            subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);
        } else {
            // new subjectSubjectBlock
            subjectSubjectBlock = new SubjectSubjectBlock();

            // get the subjectBlockId, should always exist
            if (request.getParameter("subjectBlockId") != null 
                    && !"".equals(request.getParameter("subjectBlockId"))) {
                subjectBlockId = Integer.parseInt(request.getParameter("subjectBlockId"));
            }
            subjectSubjectBlock.setSubjectBlockId(subjectBlockId);
            subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);
            // needed to find the correct organizations
            studyId = (subjectBlock.getPrimaryStudyId());
            subjectSubjectBlock.setSubjectBlockId(subjectBlock.getId());
            // set empty subject
            subject = new Subject();
            subject.setPrimaryStudyId(studyId);
            subject.setCurrentAcademicYearId(subjectBlock.getCurrentAcademicYearId());
            subjectSubjectBlock.setSubject(subject);
        }
        subjectBlockSubjectForm.setSubjectBlock(subjectBlock);
        
        // set default organization id's
        // find organization id's matching with the studyId determined before
        organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                        studyId)).getId();
        branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
        institutionId = institutionManager.findInstitutionOfBranch(branchId);
        
        subjectBlockSubjectForm.setSubjectSubjectBlock(subjectSubjectBlock);
        
        /* ORGANIZATION - fetch or create the object */
        organization = new Organization();
        // organization id's determined before: based on existing subject
        opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                    , branchId, institutionId);
        subjectBlockSubjectForm.setOrganization(organization);
    
        /* NAVIGATIONSETTINGS - fetch or create the object */
        navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, null);
        subjectBlockSubjectForm.setNavigationSettings(navigationSettings);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pullDowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                subjectBlockSubjectForm.getOrganization(), session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());

        subjectBlockSubjectForm.setAllAcademicYears(
                                            academicYearManager.findAllAcademicYears());

        // get studyId for retrieving lists
        subjectBlock = subjectBlockSubjectForm.getSubjectBlock();
        subject = subjectSubjectBlock.getSubject();
        studyId = subject.getPrimaryStudyId();
        subjectBlockSubjectForm = fillStudyAndSubjectLists(subjectBlockSubjectForm, studyId);

        // should always be filled
        if (subjectBlock.getId() != 0) {
            // find all subjects belonging to subject block
            subjectBlockSubjectForm.setAllSubjectsForSubjectBlock(subjectBlockMapper
                                    .findSubjectsForSubjectBlock(subjectBlock.getId()));
        }

        model.addAttribute("subjectBlockSubjectForm", subjectBlockSubjectForm);        
        return formView;
    }

	@RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectBlockSubjectForm") 
            SubjectBlockSubjectForm subjectBlockSubjectForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectBlockSubjectEditController.processSubmit entered...");
        }
        
        Locale currentLoc = RequestContextUtils.getLocale(request);
        String txtErr = "";
        SubjectSubjectBlock subjectSubjectBlock = subjectBlockSubjectForm.getSubjectSubjectBlock();
        NavigationSettings navSettings = subjectBlockSubjectForm.getNavigationSettings();
        String submitFormObject = "";
        String showSubjectBlockSubjectError = "";
        Subject subject = subjectSubjectBlock.getSubject();
        subjectBlockSubjectForm.setTxtErr("");
        int studyId = subject.getPrimaryStudyId();
        
        subjectBlockSubjectForm = fillStudyAndSubjectLists(subjectBlockSubjectForm, studyId);

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectSubjectBlockValidator().validate(subjectSubjectBlock, result);
            if (result.hasErrors()) {
                return formView;
            }

            // check if subjectBlockSubject already exists:
//            HashMap map = new HashMap();
//            map.put("subjectId", subjectSubjectBlock.getSubject().getId());
//            map.put("subjectBlockId", subjectSubjectBlock.getSubjectBlockId());
            if (subjectSubjectBlock.getId() == 0 
            		&& subjectBlockMapper.findSubjectSubjectBlockByParams(subjectSubjectBlock.getSubject().getId(), subjectSubjectBlock.getSubjectBlockId()) != null) {
                showSubjectBlockSubjectError =  messageSource.getMessage(
                        "jsp.error.subjectblocksubject.edit", null, currentLoc);
                showSubjectBlockSubjectError = showSubjectBlockSubjectError
                        + messageSource.getMessage(
                        "jsp.error.subjectblocksubject.exists", null, currentLoc);
                subjectBlockSubjectForm.setShowSubjectBlockSubjectError(
                                                    showSubjectBlockSubjectError);

                return formView;
            } 
            
            if (subjectSubjectBlock.getSubject().getId() != 0) {
                subject = subjectManager.findSubject(subjectSubjectBlock.getSubject().getId());
                subjectSubjectBlock.setSubject(subject);
            }
            if (!subject.isLinkSubjectAndStudyGradeTypeIsAllowed()) {
                txtErr = messageSource.getMessage(
                        "jsp.error.link.subject.subjectblock.teacher.missing", null, currentLoc);
                subjectBlockSubjectForm.setTxtErr(txtErr);
                
                return formView;
            } else {
                subjectBlockSubjectForm.setTxtErr("");
    	        if (subjectSubjectBlock.getId() == 0) {
    	            subjectManager.addSubjectSubjectBlock(subjectSubjectBlock);
    	        } else {
    	        	subjectManager.updateSubjectSubjectBlock(subjectSubjectBlock);
    	        }
    	        return "redirect:/college/subjectblock.view?newForm=true&tab=" + navSettings.getTab()
    	            + "&panel=" + navSettings.getPanel()
	                + "&subjectBlockId=" + subjectSubjectBlock.getSubjectBlockId()
	                + "&currentPageNumber=" + navSettings.getCurrentPageNumber(); 
            }

        // submit but no save
        } else {
            return formView;
        }

    }
	
	private SubjectBlockSubjectForm fillStudyAndSubjectLists(
	                        SubjectBlockSubjectForm subjectBlockSubjectForm, int studyId) {
	    Organization organization = subjectBlockSubjectForm.getOrganization();
	    int academicYearId = subjectBlockSubjectForm.getSubjectBlock().getCurrentAcademicYearId();
	    if (organization.getOrganizationalUnitId() != 0) {
            Map<String, Object> findStudiesMap = new HashMap<>();
            
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            subjectBlockSubjectForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            subjectBlockSubjectForm.setAllStudies(null);
            studyId = 0;
        }
        
        if (studyId != 0) {
            Map<String, Object> findSubjectsMap = new HashMap<>();
            findSubjectsMap.put("institutionId", organization.getInstitutionId());
            findSubjectsMap.put("branchId", organization.getBranchId());
            findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findSubjectsMap.put("studyId", studyId);
            findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            findSubjectsMap.put("currentAcademicYearId", academicYearId);
            subjectBlockSubjectForm.setAllSubjectsForStudy(subjectManager
                                                            .findSubjects(findSubjectsMap));
        } else {
            subjectBlockSubjectForm.setAllSubjectsForStudy(null);
        }
        return subjectBlockSubjectForm;
	}

}
