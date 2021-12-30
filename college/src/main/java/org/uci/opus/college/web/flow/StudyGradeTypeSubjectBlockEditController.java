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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.StudyGradeTypeSubjectBlockValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.study.StudyGradeTypeSubjectBlockForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * @author MoVe
 */
@Controller
@RequestMapping("/college/studygradetypesubjectblock")
@SessionAttributes({ StudyGradeTypeSubjectBlockEditController.FORM_OBJECT })
public class StudyGradeTypeSubjectBlockEditController {

    public static final String FORM_OBJECT = "studyGradeTypeSubjectBlockForm";
    private static final String FORM_VIEW = "college/study/studyGradeTypeSubjectBlock";

    private static Logger log = LoggerFactory.getLogger(StudyGradeTypeSubjectBlockEditController.class);
    
    private StudyGradeTypeSubjectBlockValidator validator = new StudyGradeTypeSubjectBlockValidator();

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    MessageSource messageSource;
    
    @Autowired
    AcademicYearManagerInterface academicYearManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public StudyGradeTypeSubjectBlockEditController() {
        super();
    }

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "subjectStudyGradeTypeId" is set, the
     * specified subjectStudyGradeType is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        
        StudyGradeTypeSubjectBlockForm form = new StudyGradeTypeSubjectBlockForm();
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        
        Organization organization = new Organization();
        opusMethods.fillOrganization(session, request, organization);
        form.setOrganization(organization);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);

        
        String gradeTypeCode = "";

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // check if subjectStudyGradeTypeId exists
        int subjectBlockStudyGradeTypeId = ServletUtil.getIntParam(request, "subjectBlockStudyGradeTypeId", 0);

        // primaryStudyId should exist
        int studyId = ServletUtil.getIntParam(request, "primaryStudyId", 0);

        // studyGradeTypeId should exist
        int studyGradeTypeId = ServletUtil.getIntParam(request, "studyGradeTypeId", 0);

        // subjectBlockId may exist
        int subjectBlockId = ServletUtil.getIntParam(request, "subjectBlockId", 0);


        StudyGradeType studyGradeType = null;
        if (studyGradeTypeId != 0) {
            studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        }
        form.setStudyGradeType(studyGradeType);

        SubjectBlockStudyGradeType subjectBlockStudyGradeType;
        SubjectBlock subjectBlock;
        if (subjectBlockStudyGradeTypeId != 0) {
            // existing subjectStudyGradeType
            subjectBlockStudyGradeType = subjectBlockMapper.findSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId, preferredLanguage);
            subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockStudyGradeType.getSubjectBlock().getId());
        } else {
            // new subjectStudyGradeType
            subjectBlock = new SubjectBlock();
            subjectBlockStudyGradeType = new SubjectBlockStudyGradeType();
            subjectBlockStudyGradeType.setStudyGradeType(new StudyGradeType());
            subjectBlockStudyGradeType.setSubjectBlock(subjectBlock);
            subjectBlockStudyGradeType.getStudyGradeType().setId(studyGradeTypeId);
            subjectBlockStudyGradeType.setActive("Y");
            subjectBlockStudyGradeType.getStudyGradeType().setGradeTypeCode(gradeTypeCode);
            subjectBlockStudyGradeType.getStudyGradeType().setStudyId(studyId);
            subjectBlockStudyGradeType.getSubjectBlock().setId(subjectBlockId);
        }
        form.setSubjectBlockStudyGradeType(subjectBlockStudyGradeType);

        form.setStudyId(studyId);

        loadStudies(form);
        loadOtherFilters(form);
        
        /* get subject lookups so we can use allRigidityTypes (for example) */
        form.setAllRigidityTypes(lookupCacher.getAllRigidityTypes(preferredLanguage));

        model.put(FORM_OBJECT, form);
        
        return FORM_VIEW;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.institutionId")
    public String institutionChanged(@ModelAttribute(FORM_OBJECT) StudyGradeTypeSubjectBlockForm form) {

        opusMethods.loadBranches(form.getOrganization());
        loadStudies(form);
        loadOtherFilters(form);
        return FORM_VIEW;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.branchId")
    public String branchChanged(@ModelAttribute(FORM_OBJECT) StudyGradeTypeSubjectBlockForm form) {

        opusMethods.loadOrganizationalUnits(form.getOrganization());
        loadStudies(form);
        loadOtherFilters(form);
        return FORM_VIEW;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.organizationalUnitId")
    public String organizationalUnitChanged(@ModelAttribute(FORM_OBJECT) StudyGradeTypeSubjectBlockForm form) {

        loadStudies(form);
        loadOtherFilters(form);
        return FORM_VIEW;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=studyId")
    public String studyChanged(@ModelAttribute(FORM_OBJECT) StudyGradeTypeSubjectBlockForm form) {

        loadOtherFilters(form);
        return FORM_VIEW;
    }
    
    private void loadStudies(StudyGradeTypeSubjectBlockForm form) {
        
        Organization organization = form.getOrganization();

        // get list of studies
        List<Study> allStudies = null;
        if (organization.getOrganizationalUnitId() != 0) {

            Map<String, Object> findStudiesMap = new HashMap<>();
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
            allStudies = studyManager.findStudies(findStudiesMap);
        }
        form.setAllStudies(allStudies);
    }
    
    private void loadOtherFilters(StudyGradeTypeSubjectBlockForm form) {

        Organization organization = form.getOrganization();
        StudyGradeType studyGradeType = form.getStudyGradeType();
        int studyId = form.getStudyId();
        if (studyId == 0) {
            form.setMaxNumberOfCardinalTimeUnits(0);
            return;
        }

        // find all subjectBlocks
        Map<String, Object> findSubjectBlocksMap = new HashMap<>();
        findSubjectBlocksMap.put("institutionId", organization.getInstitutionId());
        findSubjectBlocksMap.put("branchId", organization.getBranchId());
        findSubjectBlocksMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        // do not specify study, since there might be subjectblocks from other studies:
        findSubjectBlocksMap.put("studyId", studyId);
        findSubjectBlocksMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        if (studyGradeType != null) {
            findSubjectBlocksMap.put("currentAcademicYearId", studyGradeType.getCurrentAcademicYearId());
        }
        findSubjectBlocksMap.put("active", "");
        List<SubjectBlock> allSubjectBlocks = subjectBlockMapper.findSubjectBlocks(findSubjectBlocksMap);
        form.setAllSubjectBlocks(allSubjectBlocks);

        List<Integer> allSubjectBlockIdsForStudyGradeType = subjectManager.findSubjectBlocksByStudyGradeType(studyGradeType);
        form.setAllSubjectBlockIdsForStudyGradeType(allSubjectBlockIdsForStudyGradeType);

        int maxNumberOfCardinalTimeUnits = studyManager.findNumberOfCardinalTimeUnitsForStudyGradeType(studyGradeType.getId());
        form.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);

    }

    /**
     * Saves the new or updated subjectStudyGradeType.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) StudyGradeTypeSubjectBlockForm form, BindingResult result) {

        SubjectBlockStudyGradeType subjectBlockStudyGradeType = form.getSubjectBlockStudyGradeType();

        result.pushNestedPath("subjectBlockStudyGradeType");
        validator.validate(subjectBlockStudyGradeType, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int studyGradeTypeId = 0;
        StudyGradeType studyGradeType = null;


        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
            studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
        }

        NavigationSettings nav = form.getNavigationSettings();
        
        // get the studyGradeType so the correct gradeType can be returned
        // and possible the correct studyId
        studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);


            // check if subjectblockstudygradetype already exists:
            Map<String, Object> map = new HashMap<>();
            map.put("studyGradeTypeId", subjectBlockStudyGradeType.getStudyGradeType().getId());
            map.put("subjectBlockId", subjectBlockStudyGradeType.getSubjectBlock().getId());
            map.put("cardinalTimeUnitNumber", subjectBlockStudyGradeType.getCardinalTimeUnitNumber());

            if (subjectBlockMapper.findSubjectBlockStudyGradeTypeByParams(map) != null) {
                result.reject("jsp.error.subjectblockstudygradetype.exists");
                return FORM_VIEW;
            }

            if (subjectBlockStudyGradeType.getId() == 0) {
                // insert new
                log.info("adding " + subjectBlockStudyGradeType);
                subjectBlockMapper.addSubjectBlockStudyGradeType(subjectBlockStudyGradeType);
            } else {
                // update existing
                log.info("updating " + subjectBlockStudyGradeType);
                subjectBlockMapper.updateSubjectBlockStudyGradeType(subjectBlockStudyGradeType);
            }

            return "redirect:/college/studygradetype.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&from=subjectblockstudygradetype" + "&studyGradeTypeId="
                    + subjectBlockStudyGradeType.getStudyGradeType().getId() + "&studyId=" + studyGradeType.getStudyId() + "&gradeTypeCode=" + studyGradeType.getGradeTypeCode()
                    + "&currentPageNumber=" + nav.getCurrentPageNumber();

    }
}
