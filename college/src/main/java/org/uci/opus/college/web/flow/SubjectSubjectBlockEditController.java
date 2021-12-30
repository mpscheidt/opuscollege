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
import org.uci.opus.college.domain.Study;
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
import org.uci.opus.college.web.form.SubjectSubjectBlockForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectsubjectblock.view")
@SessionAttributes("subjectSubjectBlockForm")
public class SubjectSubjectBlockEditController {

    private static Logger log = LoggerFactory.getLogger(SubjectSubjectBlockEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private MessageSource messageSource;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    private String formView;
     
     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public SubjectSubjectBlockEditController() {
		super();
		this.formView = "college/subject/subjectSubjectBlock";
	}

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectSubjectBlockEditController.setUpForm entered...");
        }
        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject("subjectSubjectBlockForm", session, opusMethods.isNewForm(request));

        SubjectSubjectBlockForm subjectSubjectBlockForm = null;
        Subject subject = null;
        SubjectSubjectBlock subjectSubjectBlock = null;
        SubjectBlock subjectBlock = null;
        Organization organization;
        NavigationSettings navigationSettings;
        
        
        Study study = null;
        int subjectId = 0;
        int subjectSubjectBlockId = 0;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* fetch or create the form object */
        if ((SubjectSubjectBlockForm) session.getAttribute("subjectSubjectBlockForm") != null) {
            subjectSubjectBlockForm = (SubjectSubjectBlockForm) session.getAttribute("subjectSubjectBlockForm");
        } else {
            subjectSubjectBlockForm = new SubjectSubjectBlockForm();
        }
        
        // entering the form: the subjectSubjectBlockForm.subject does not exist yet
        if (subjectSubjectBlockForm.getSubject() == null) {
            // get the subjectId, should always exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
                subjectId = Integer.parseInt(request.getParameter("subjectId"));
            }
            subject = subjectManager.findSubject(subjectId);
            subjectSubjectBlockForm.setSubject(subject);
        } else {
            subject = subjectSubjectBlockForm.getSubject();
        }
        
        // check if subject may be linked to subjectBLock
        if (!subjectSubjectBlockForm.getSubject().isLinkSubjectAndStudyGradeTypeIsAllowed()) {
            subjectSubjectBlockForm.setTxtErr(messageSource.getMessage(
                  "jsp.error.link.subject.subjectblock.teacher.missing", null, RequestContextUtils.getLocale(request)));                            
        } else {
            subjectSubjectBlockForm.setTxtErr("");
        }
            
        // entering the form: the subjectSubjectBlockForm.subjectSubjectBlock does not exist yet
        if (subjectSubjectBlockForm.getSubjectSubjectBlock() == null) {
            
            // get the subjectSubjectBlockId if it exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectSubjectBlockId"))) {
                subjectSubjectBlockId = Integer.parseInt(
                                        request.getParameter("subjectSubjectBlockId"));
            }

            // existing subjectSubjectBlock
            if (subjectSubjectBlockId != 0) {
                subjectSubjectBlock = subjectManager.findSubjectSubjectBlock(subjectSubjectBlockId);

                subjectBlock = subjectBlockMapper.findSubjectBlock(subjectSubjectBlock.getSubjectBlockId());
                subjectSubjectBlockForm.setSubjectBlock(subjectBlock);
                
                // find studyId matching the subjectBlock
                study = studyManager.findStudy(subjectBlock.getPrimaryStudyId());
            } else {
                // new subjectSubjectBlock
                subjectSubjectBlock = new SubjectSubjectBlock();
                subjectSubjectBlock.setSubject(subject);
                // find studyId matching the subject, since the subjectBlock does not exist yet
                study = studyManager.findStudy(subject.getPrimaryStudyId());
            }
            subjectSubjectBlockForm.setSubjectSubjectBlock(subjectSubjectBlock);
            subjectSubjectBlockForm.setStudy(study);
            // find the organization id's
            organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                        study.getId())).getId();
            branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            institutionId = institutionManager.findInstitutionOfBranch(branchId);
        } else {
            subjectSubjectBlock = subjectSubjectBlockForm.getSubjectSubjectBlock();
            subjectBlock = subjectSubjectBlockForm.getSubjectBlock();
            subject = subjectSubjectBlockForm.getSubject();
        }

        /* ORGANIZATION - fetch or create the object */
        if (subjectSubjectBlockForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectSubjectBlockForm.setOrganization(organization);

        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectSubjectBlockForm.getOrganization();
        }
        
        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectSubjectBlockForm.getNavigationSettings() != null) {
            navigationSettings = subjectSubjectBlockForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        subjectSubjectBlockForm.setNavigationSettings(navigationSettings);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(subjectSubjectBlockForm.getOrganization(),
                            session, request, organization.getInstitutionTypeCode()
                                , organization.getInstitutionId(), organization.getBranchId()
                                , organization.getOrganizationalUnitId());

        /* put lookup-tables on the request */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getAddressLookups(preferredLanguage, request);
        lookupCacher.getSubjectLookups(preferredLanguage, request);

        if (organization.getOrganizationalUnitId() != 0) {
            Map<String, Object> findStudiesMap = new HashMap<>();
            
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            subjectSubjectBlockForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            subjectSubjectBlockForm.setAllStudies(null);
        }

        if (subjectSubjectBlockForm.getStudy().getId() != 0) {
        	// find all SubjectSubjectBlocks belonging to subject
            subjectSubjectBlockForm.setAllSubjectSubjectBlocksForSubject( 
       		subjectManager.findSubjectSubjectBlocksForSubject(subject.getId()));

        	// find all subjectBlocks
            Map<String, Object> findSubjectBlocksMap = new HashMap<>();
            findSubjectBlocksMap.put("institutionTypeCode"
                                , organization.getInstitutionTypeCode());
            findSubjectBlocksMap.put("institutionId", organization.getInstitutionId());
            findSubjectBlocksMap.put("branchId", organization.getBranchId());
            findSubjectBlocksMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findSubjectBlocksMap.put("studyId", subjectSubjectBlockForm.getStudy().getId());
            // subject should always exist
//            if (subject != null) {
            	findSubjectBlocksMap.put("currentAcademicYearId", subject.getCurrentAcademicYearId());
//            } else {
//	            if (subjectBlock != null) {
//	            	findSubjectBlocksMap.put("currentAcademicYearId", subjectBlock.getCurrentAcademicYearId());
//	            }
//            }
            subjectSubjectBlockForm.setAllSubjectBlocks(subjectBlockMapper.findSubjectBlocks(findSubjectBlocksMap));
        } else {
            subjectSubjectBlockForm.setAllSubjectSubjectBlocksForSubject(null);
            subjectSubjectBlockForm.setAllSubjectBlocks(null);
        }
        
        if (subjectSubjectBlockForm.getAllAcademicYears() == null) {
            subjectSubjectBlockForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
        }

        model.addAttribute("subjectSubjectBlockForm", subjectSubjectBlockForm);        
        return formView;
    }

    /**
     * Saves the new or updated subjectSubjectblock.
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectSubjectBlockForm") 
                                                SubjectSubjectBlockForm subjectSubjectBlockForm
                                                , BindingResult result, HttpServletRequest request
                                                , SessionStatus status) {

        if (log.isDebugEnabled()) {
            log.debug("SubjectSubjectBlockEditController.processSubmit entered...");
        }

        SubjectSubjectBlock subjectSubjectBlock = subjectSubjectBlockForm
                                                            .getSubjectSubjectBlock();
        Subject subject = subjectSubjectBlockForm.getSubject();
        NavigationSettings navigationSettings = subjectSubjectBlockForm.getNavigationSettings();
        
        String submitFormObject = "";
        String txtErr = "";

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectSubjectBlockValidator().validate(subjectSubjectBlock, result);
            if (result.hasErrors()) {
                /* if an error is detected by the validator, then the setUpForm is not called. Therefore
                 * the lookup tables need to be filled in this method as well
                 */
                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                /* put lookup-tables on the request */
                lookupCacher.getPersonLookups(preferredLanguage, request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                lookupCacher.getAddressLookups(preferredLanguage, request);
                lookupCacher.getSubjectLookups(preferredLanguage, request);
                
                return formView;
            }
            /* if the subject has no teacher or the subject has an examination but no
             * examination teacher, this subject cannot be linked to any subjectBlock
             */
            if (subject.isLinkSubjectAndStudyGradeTypeIsAllowed()) {
                subjectSubjectBlockForm.setTxtErr("");
                if (subjectSubjectBlock.getId() == 0) {
                    subjectManager.addSubjectSubjectBlock(subjectSubjectBlock);
                } else {
                    subjectManager.updateSubjectSubjectBlock(subjectSubjectBlock);
                }
            } else {
                txtErr = messageSource.getMessage(
                        "jsp.error.link.subject.subjectblock.teacher.missing"
                        , null, RequestContextUtils.getLocale(request));
                subjectSubjectBlockForm.setTxtErr(txtErr);
                
                /* if an error is detected by the validator, then the setUpForm is not called. Therefore
                 * the lookup tables need to be filled in this method as well
                 */
                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                /* put lookup-tables on the request */
                lookupCacher.getPersonLookups(preferredLanguage, request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                lookupCacher.getAddressLookups(preferredLanguage, request);
                lookupCacher.getSubjectLookups(preferredLanguage, request);
                
                return formView;
            }

            return "redirect:/college/subject.view?newForm=true&tab=" + navigationSettings.getTab()
            + "&panel=" + navigationSettings.getPanel()
            + "&subjectId=" + subjectSubjectBlock.getSubject().getId()
            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
         // submit but no save
        } else {
            return "redirect:/college/subjectsubjectblock.view";
        }

    }

}
