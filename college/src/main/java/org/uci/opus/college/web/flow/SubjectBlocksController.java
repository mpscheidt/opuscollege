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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectBlocksForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/subjectblocks")
@SessionAttributes({ SubjectBlocksController.FORM_OBJECT })
public class SubjectBlocksController {

    public static final String FORM_OBJECT = "subjectBlocksForm";
    private static Logger log = LoggerFactory.getLogger(SubjectBlocksController.class);

    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private StudyManagerInterface studyManager;
    
    @Autowired
    private MessageSource messageSource;

    @Autowired
    private OpusMethods opusMethods;
    
    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    @Autowired
    SubjectManagerInterface subjectManager;

    public SubjectBlocksController() {
        super();
        this.formView = "college/subjectblock/subjectblocks";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String showSubjectBlocks(ModelMap model, HttpServletRequest request) {
		TimeTrack timer = new TimeTrack("SubjectBlocksController.showSubjectBlocks");

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // when entering a new form, destroy any existing objectForms on the session
        opusMethods.removeSessionFormObject(FORM_OBJECT, session, model, opusMethods.isNewForm(request));

        Organization organization = null;
        NavigationSettings navigationSettings = null;

        /* set menu to subjects */
        session.setAttribute("menuChoice", "studies");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String institutionTypeCode = "";
        int studyId = 0;
        SubjectBlock subjectBlock = null;
        List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = null;

        /* fetch or create the form object */
        SubjectBlocksForm subjectBlocksForm = (SubjectBlocksForm) model.get(FORM_OBJECT);
        if (subjectBlocksForm == null) {
            subjectBlocksForm = new SubjectBlocksForm();
            if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
                studyId = Integer.parseInt(request.getParameter("studyId"));
                subjectBlocksForm.setStudyId(studyId);
            }
        }

        /* ORGANIZATION - fetch or create the object */
        if (subjectBlocksForm.getOrganization() != null) {
            organization = subjectBlocksForm.getOrganization();
        } else {
            organization = new Organization();

            organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
            branchId = ((Integer) session.getAttribute("branchId"));
            institutionId = ((Integer) session.getAttribute("institutionId"));

            organization.setOrganizationalUnitId(organizationalUnitId);
            organization.setBranchId(branchId);
            organization.setInstitutionId(institutionId);
            institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
            organization.setInstitutionTypeCode(institutionTypeCode);

            subjectBlocksForm.setOrganization(organization);
        }

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (subjectBlocksForm.getNavigationSettings() != null) {
            navigationSettings = subjectBlocksForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "subjectblocks.view");
        }
        subjectBlocksForm.setNavigationSettings(navigationSettings);

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockError"))) {
            subjectBlocksForm.setSubjectBlockError(request.getParameter("subjectBlockError"));
        }

        /*
         * find a LIST OF INSTITUTIONS of the correct educationtype
         * 
         * the institutionTypeCode is used (set in code above) for now studies, and therefore
         * subjects, are only registered for universities; if in the future this should change, it
         * will be easier to alter the code
         */

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, organization.getInstitutionTypeCode(), organization.getInstitutionId(),
                organization.getBranchId(), organization.getOrganizationalUnitId());

        /* fill lookup-tables with right values */
        lookupCacher.getSubjectLookups(preferredLanguage, request);

        // LIST OF STUDIES
        // used to show the name of the primary study of each subjectblock in the overview
        List<? extends Study> allStudies = null;
        Map<String, Object> findStudiesMap = new HashMap<>();

        findStudiesMap.put("institutionId", organization.getInstitutionId());
        findStudiesMap.put("branchId", organization.getBranchId());
        findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        allStudies = studyManager.findStudies(findStudiesMap);
        subjectBlocksForm.setAllStudies(allStudies);
        timer.measure("all studies");

        if (organization.getOrganizationalUnitId() != 0) {
            subjectBlocksForm.setDropDownListStudies(allStudies);
        }

        // academic years combo
        List<AcademicYear> allAcademicYears = null;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        map.put("studyId", subjectBlocksForm.getStudyId());
        allAcademicYears = studyManager.findAllAcademicYears(map);
        subjectBlocksForm.setAllAcademicYears(allAcademicYears);

        // reset academicYearId if not in list of available academic years (e.g. after changing
        // study filter selection)
        if (!DomainUtil.getIds(allAcademicYears).contains(subjectBlocksForm.getAcademicYearId())) {
            subjectBlocksForm.setAcademicYearId(0);
        }

        /* study domain attributes */
        subjectBlocksForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

        // LIST OF SUBJECTBLOCKS
        List<? extends SubjectBlock> allSubjectBlocks = null;
        Map<String, Object> findSubjectBlocksMap = new HashMap<String, Object>();
        findSubjectBlocksMap.put("institutionId", organization.getInstitutionId());
        findSubjectBlocksMap.put("branchId", organization.getBranchId());
        findSubjectBlocksMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findSubjectBlocksMap.put("studyId", subjectBlocksForm.getStudyId());
        findSubjectBlocksMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findSubjectBlocksMap.put("searchValue", navigationSettings.getSearchValue());
        findSubjectBlocksMap.put("active", "");
        findSubjectBlocksMap.put("currentAcademicYearId", subjectBlocksForm.getAcademicYearId());
        allSubjectBlocks = subjectBlockMapper.findSubjectBlocks(findSubjectBlocksMap);
        timer.measure("all subject blocks");
        
        // add studyGradeTypes to each subjectblock
        Map<String, Object> gradeTypesMap = new HashMap<>();
        gradeTypesMap.put("preferredLanguage", preferredLanguage);

        for (int i = 0; i < allSubjectBlocks.size(); i++) {
            // get the subjectBlock
            subjectBlock = allSubjectBlocks.get(i);
            // set the subjectBlockId
            gradeTypesMap.put("subjectBlockId", subjectBlock.getId());
            // get and set the studyGradeTypes of this subjectblock
            allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(gradeTypesMap);
            subjectBlock.setSubjectBlockStudyGradeTypes(allSubjectBlockStudyGradeTypes);
        }
        subjectBlocksForm.setAllSubjectBlocks(allSubjectBlocks);

        timer.end("subjectBlockStudyGradeTypes");
        model.addAttribute(FORM_OBJECT, subjectBlocksForm);
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(FORM_OBJECT) SubjectBlocksForm subjectBlocksForm, BindingResult result, SessionStatus status, HttpServletRequest request) {

        NavigationSettings navigationSettings = subjectBlocksForm.getNavigationSettings();
        Organization organization = subjectBlocksForm.getOrganization();
        HttpSession session = request.getSession(false);

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("institutionId", organization.getInstitutionId());

        return "redirect:subjectblocks.view?currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    /**
     * Delete subject block with given id.
     */
    @RequestMapping(value = "/delete/{subjectBlockId}", method = RequestMethod.GET)
    public String deleteFunction(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) SubjectBlocksForm subjectBlocksForm, @PathVariable("subjectBlockId") Integer subjectBlockId) {

        String subjectBlockError = "";

        // subjectBlock cannot be deleted if it belongs to a studyplan
        List<StudyPlanDetail> subjectBlockStudyPlanList = studyManager.findStudyPlanDetailsForSubjectBlock(subjectBlockId);
        if (subjectBlockStudyPlanList.size() != 0) {
            Locale currentLoc = RequestContextUtils.getLocale(request);

            // show error for linked results
            subjectBlockError = messageSource.getMessage("jsp.error.subjectblock.delete", null, currentLoc);
            subjectBlockError = subjectBlockError + messageSource.getMessage("jsp.error.general.delete.linked.studyplan", null, currentLoc);
        } else {
            log.info("deleting " + subjectBlockId);
            subjectManager.deleteSubjectBlock(subjectBlockId);
        }

        return "redirect:/college/subjectblocks.view?newForm=true&" + "subjectBlockError=" + subjectBlockError + "&currentPageNumber=" + subjectBlocksForm.getNavigationSettings().getCurrentPageNumber();
    }

}
