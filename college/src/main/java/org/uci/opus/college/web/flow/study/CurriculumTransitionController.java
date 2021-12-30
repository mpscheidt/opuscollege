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

package org.uci.opus.college.web.flow.study;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.curriculumtransition.CurriculumTransitionManagerInterface;
import org.uci.opus.college.validator.CurriculumTransitionValidator;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.study.CurriculumTransitionForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * A wizard to guide the duplication of studygradetypes, subjectblocks and subjects
 */
@Controller
@RequestMapping(value="/college/study/curriculumTransition")
@SessionAttributes(CurriculumTransitionController.FORM_NAME)
public class CurriculumTransitionController {

    public static final String FORM_NAME = "curriculumTransitionForm";
    private static final String INIT_FORMVIEW = "/college/study/curriculumTransition/curriculumTransitionInit";

    private static Logger log = LoggerFactory.getLogger(CurriculumTransitionController.class);
    @Autowired private CurriculumTransitionManagerInterface curriculumTransitionManager;
    @Autowired private CurriculumTransitionValidator curriculumTransitionValidator;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private SecurityChecker securityChecker;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public CurriculumTransitionController() {
        super();
    }

    // initial get; there is still no form object
    @RequestMapping(value="/init.view", method = RequestMethod.GET)
    public String setupInitScreen(HttpServletRequest request, ModelMap model) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
    
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        
        session.setAttribute("menuChoice", "studies");

        CurriculumTransitionForm curriculumTransitionForm = (CurriculumTransitionForm) model.get(FORM_NAME);
        if (curriculumTransitionForm == null) {
            curriculumTransitionForm = new CurriculumTransitionForm();
            model.addAttribute(FORM_NAME, curriculumTransitionForm);
            
            
        }

        // create filter objects and initialize with request/session values
        if (curriculumTransitionForm.getOrganization() == null) {
            Organization organization = new Organization();
            curriculumTransitionForm.setOrganization(organization);
            opusMethods.fillOrganization(session, request, organization);

            Integer primaryStudyId = ServletUtil.getIntObject(session, request, "primaryStudyId");
            if (primaryStudyId != null) {
                curriculumTransitionForm.setStudyId(primaryStudyId);
            }
        }
        
        if (curriculumTransitionForm.getData() == null) {
            CurriculumTransitionData data = new CurriculumTransitionData();
            curriculumTransitionForm.setData(data);

            Integer fromAcademicYearId = ServletUtil.getIntObject(session, request, "fromAcademicYearId");
            if (fromAcademicYearId != null) {
                data.setFromAcademicYearId(fromAcademicYearId);
            }

            Integer toAcademicYearId = ServletUtil.getIntObject(session, request, "toAcademicYearId");
            if (toAcademicYearId != null) {
                data.setToAcademicYearId(toAcademicYearId);
            }
        }
        
        return setupInitScreen(request, curriculumTransitionForm, model);
    }    
    
    // filter selection goes via POST
    @RequestMapping(value="/init.view", method = RequestMethod.POST)
    public String setupInitScreen(HttpServletRequest request, CurriculumTransitionForm curriculumTransitionForm, ModelMap model) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        referenceDataForInitPage(request, curriculumTransitionForm);
        return INIT_FORMVIEW; // point to the jsp file (init.jsp)
    }
    
    @RequestMapping(value="/init.view", params = "previewButton")
    public String previewButtonPressed(CurriculumTransitionForm curriculumTransitionForm, BindingResult result) {

        result.pushNestedPath("data");
        curriculumTransitionValidator.validate(curriculumTransitionForm.getData(), result);
        result.popNestedPath();
        
        if (result.hasErrors()) {
            return INIT_FORMVIEW;
        }
        
        return "redirect:/college/study/curriculumTransition/preview.view";
    }
    
    @RequestMapping(value="/preview.view", method=RequestMethod.GET)
    public String getPreviewScreen(HttpServletRequest request, CurriculumTransitionForm curriculumTransitionForm, ModelMap model) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        Map<String, Object> map = referenceDataForPreviewPage(request, curriculumTransitionForm);
        model.addAllAttributes(map);
        
        return "/college/study/curriculumTransition/curriculumTransitionPreview";
    }

    @RequestMapping(value="/preview.view", params = "backToInitButton")
    public String backToInitButtonPressed() {
        return "redirect:/college/study/curriculumTransition/init.view";
    }
    
    @RequestMapping(value="/preview.view", params = "transferButton")
    public String transferButtonPressed(HttpServletRequest request, CurriculumTransitionForm curriculumTransitionForm,
            BindingResult result, ModelMap model) {
        
        // validate if at least one student has been selected
        CurriculumTransitionData data = curriculumTransitionForm.getData();
        List<Integer> selectedStudyGradeTypeIds = data.getSelectedStudyGradeTypeIds();
        List<Integer> selectedSubjectBlockIds = data.getSelectedSubjectBlockIds();
        List<Integer> selectedSubjectIds = data.getSelectedSubjectIds();
        if ((selectedStudyGradeTypeIds == null || selectedStudyGradeTypeIds.isEmpty())
                && (selectedSubjectBlockIds == null || selectedSubjectBlockIds.isEmpty())
                && (selectedSubjectIds == null || selectedSubjectIds.isEmpty())
                && !data.isEndGradesSelectedForTransfer()) {
            result.reject("jsp.error.curriculumtransition.nothingselected");
        }
        if (result.hasErrors()) {
            return getPreviewScreen(request, curriculumTransitionForm, model);
        }
        
        return "redirect:/college/study/curriculumTransition/transfer.view";
    }
    
    @RequestMapping(value="/transfer.view", method=RequestMethod.GET)
    public String getResultScreen(HttpServletRequest request,
            SessionStatus sessionStatus, CurriculumTransitionForm curriculumTransitionForm,
            Model model) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        CurriculumTransitionData data = curriculumTransitionForm.getData();
        curriculumTransitionManager.transferCurriculum(data);
        request.setAttribute("curriculumTransitionData", data);

        // after transition is done (or cancelled)
        // release session attribute
        sessionStatus.setComplete();
        
        Map<String, Object> map = referenceDataForResultPage(request, curriculumTransitionForm);
        model.addAllAttributes(map);

        return "/college/study/curriculumTransition/curriculumTransitionResult";
    }

    
    protected void referenceDataForInitPage(HttpServletRequest request, CurriculumTransitionForm form) {
        HttpSession session = request.getSession(false);

        String institutionTypeCode = OpusMethods.getInstitutionTypeCodeAndSetAttr(request);
        int institutionId = form.getOrganization().getInstitutionId();
        session.setAttribute("institutionId", institutionId);

        int branchId = form.getOrganization().getBranchId();
        session.setAttribute("branchId", branchId);

        int organizationalUnitId = form.getOrganization().getOrganizationalUnitId();
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        int studyId = form.getStudyId();
        session.setAttribute("primaryStudyId", studyId);

        int fromAcademicYearId = form.getData().getFromAcademicYearId();
        session.setAttribute("fromAcademicYearId", fromAcademicYearId);

        int toAcademicYearId = form.getData().getToAcademicYearId();
        session.setAttribute("toAcademicYearId", toAcademicYearId);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS for filters
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(form.getOrganization(), request);
     
        // --- Build the model ---

        // studies
        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", institutionTypeCode);
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId" , organizationalUnitId);
        List <Study> allStudies = studyManager.findStudies(map);
        form.setAllStudies(allStudies);

        // "from" academic years
        List <AcademicYear> fromAcademicYears = null;
        map.put("studyId", form.getStudyId());

        fromAcademicYears = studyManager.findAllAcademicYears(map);
        form.setFromAcademicYears(fromAcademicYears);

        // "to" academic years
        List <AcademicYear> toAcademicYears = academicYearManager.findAllAcademicYears();
        form.setToAcademicYears(toAcademicYears);

        if (fromAcademicYearId != 0 && toAcademicYearId != 0) {
            Map<String, Object> params = new HashMap<>();
            params.put("institutionId", institutionId);
            params.put("branchId", branchId);
            params.put("organizationalUnitId", organizationalUnitId);
            params.put("studyId", studyId);
            CurriculumTransitionData data = curriculumTransitionManager.loadCurriculumTransitionData(
                    fromAcademicYearId, toAcademicYearId, params);
            form.setData(data);
            
        }

//        return model;
	}

    protected Map<String, Object> referenceDataForPreviewPage(
            HttpServletRequest request,
            CurriculumTransitionForm curriculumTransitionForm) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        // make utility maps for jsp
        curriculumTransitionForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
        curriculumTransitionForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
        curriculumTransitionForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));

        // --- Build the model ---
        Map<String, Object> model = new HashMap<>();

        String institutionTypeCode = OpusMethods.getInstitutionTypeCodeAndSetAttr(request);
        Organization organization = curriculumTransitionForm.getOrganization();
        int institutionId = organization.getInstitutionId();
        int branchId = organization.getBranchId();
        int organizationalUnitId = organization.getOrganizationalUnitId();
        int studyId = curriculumTransitionForm.getStudyId();

        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", institutionTypeCode);
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("studyId", studyId);

        model.put("allSubjectBlocks", subjectBlockMapper.findSubjectBlocks(map));
        model.put("allSubjects", subjectManager.findSubjects(map));

        // get some added info on the links between subjects / blocks / SGTs

        int sourceAcademicYearId = curriculumTransitionForm.getData().getFromAcademicYearId();
        int targetAcademicYearId = curriculumTransitionForm.getData().getToAcademicYearId();
        List<Integer> subjectIds = DomainUtil.getIntProperties(curriculumTransitionForm.getData().getEligibleSubjects(), "originalId");
        List<Integer> subjectBlockIds = DomainUtil.getIntProperties(curriculumTransitionForm.getData().getEligibleSubjectBlocks(), "originalId");
        List<Integer> studyGradeTypeIds = DomainUtil.getIntProperties(curriculumTransitionForm.getData().getEligibleStudyGradeTypes(), "originalId");

        // subjectStudyGradeTypes for which SGTs already exists in target year,
        // so with the transfer of the subjects the subjectStudyGradeTypes can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("subjectIds", subjectIds);
        List<? extends SubjectStudyGradeType> subjectStudyGradeTypesForSubjects = curriculumTransitionManager
                .findSubjectStudyGradeTypesForSubjectTransition(map);
        model.put("subjectStudyGradeTypesForSubjects", subjectStudyGradeTypesForSubjects);
        
        // subjectStudyGradeTypes for which subjects already exists in target year,
        // so with the transfer of the subjects the subjectStudyGradeTypes can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        List<? extends SubjectStudyGradeType> subjectStudyGradeTypesForSGTs = curriculumTransitionManager
                .findSubjectStudyGradeTypesForSGTTransition(map);
        model.put("subjectStudyGradeTypesForSGTs", subjectStudyGradeTypesForSGTs);

        // remaining subjectStudyGradeTypes for which neither subject nor SGT exist in target year
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("subjectIds", subjectIds);
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        List<? extends SubjectStudyGradeType> commonSsgts = subjectManager.findSubjectStudyGradeTypes(map);
        
        commonSsgts.removeAll(subjectStudyGradeTypesForSubjects);   // avoid duplicate display
        commonSsgts.removeAll(subjectStudyGradeTypesForSGTs);       // avoid duplicate display
        model.put("commonSubjectStudyGradeTypes", commonSsgts);

        // subjectBlockStudyGradeTypes for which SGTs already exist in target year,
        // so with the transfer of the subjectBlocks the subjectBlockStudyGradeTypes can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("subjectBlockIds", subjectBlockIds);
        List<? extends SubjectBlockStudyGradeType> subjectBlockStudyGradeTypesForSubjectBlocks = curriculumTransitionManager
                .findSubjectBlockStudyGradeTypesForSubjectBlockTransition(map);
        model.put("subjectBlockStudyGradeTypesForSubjectBlocks", subjectBlockStudyGradeTypesForSubjectBlocks);

        // subjectBlockStudyGradeTypes for which subject blocks already exist in target year,
        // so with the transfer of the studyGradeTypes the subjectBlockStudyGradeTypes can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        List<? extends SubjectBlockStudyGradeType> subjectBlockStudyGradeTypesForStudyGradeTypes = curriculumTransitionManager
                .findSubjectBlockStudyGradeTypesForStudyGradeTypeTransition(map);
        model.put("subjectBlockStudyGradeTypesForStudyGradeTypes", subjectBlockStudyGradeTypesForStudyGradeTypes);

        // subjectBlockStudyGradeTypes for which neither subjectBlock nor SGT exist in target year,
        // therefore both subject blocks and SGTs are eligible for transition
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("subjectBlockIds", subjectBlockIds);
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        List<? extends SubjectBlockStudyGradeType> commonSbsgts = subjectBlockMapper.findSubjectBlockStudyGradeTypes(map);
        model.put("commonSubjectBlockStudyGradeTypes", commonSbsgts);   // TODO like with commonSsgts, remove the duplicates (implies SubjectBlockStudyGradeType.hashCode() and .equals() methods)

        // subjectSubjectBlocks for which neither subject nor subjectBlock exist in target year,
        // therefore both subjects and subject blocks are eligible for transition
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("subjectIds", subjectIds);
        map.put("subjectBlockIds", subjectBlockIds);
        List<? extends SubjectSubjectBlock> commonSsbs = subjectManager.findSubjectSubjectBlocks(map);
        model.put("commonSubjectSubjectBlocks", commonSsbs);

        // subjectSubjectBlocks for which subjectBlocks already exist in target year,
        // so with the transfer of the subjects the subjectSubjectBlocks can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("subjectIds", subjectIds);
        List<? extends SubjectSubjectBlock> subjectSubjectBlocksForSubjects = curriculumTransitionManager
                .findSubjectSubjectBlocksForSubjectTransition(map);
        model.put("subjectSubjectBlocksForSubjects", subjectSubjectBlocksForSubjects);

        // subjectSubjectBlocks for which subjects already exist in target year,
        // so with the transfer of the subject blocks the subjectSubjectBlocks can also be transferred
        map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("sourceAcademicYearId", sourceAcademicYearId);
        map.put("targetAcademicYearId", targetAcademicYearId);
        map.put("subjectBlockIds", subjectBlockIds);
        List<? extends SubjectSubjectBlock> subjectSubjectBlocksForSubjectBlocks = curriculumTransitionManager
                .findSubjectSubjectBlocksForSubjectBlockTransition(map);
        model.put("subjectSubjectBlocksForSubjectBlocks", subjectSubjectBlocksForSubjectBlocks);

        // utility map to display studyGradeType properties
        map = new HashMap<>();
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        map.put("preferredLanguage", preferredLanguage);
        List<? extends StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(map);
        curriculumTransitionForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(allStudyGradeTypes));

        return model;
    }

    protected Map<String, Object> referenceDataForResultPage(
            HttpServletRequest request,
            CurriculumTransitionForm curriculumTransitionForm) {

        Map<String, Object> model = new HashMap<>();

        CurriculumTransitionData data = curriculumTransitionForm.getData();
        AcademicYear fromAcadYear = academicYearManager.findAcademicYear(data.getFromAcademicYearId());
        AcademicYear toAcadYear = academicYearManager.findAcademicYear(data.getToAcademicYearId());
        
        model.put("fromAcademicYear", fromAcadYear.getDescription());
        model.put("toAcademicYear", toAcadYear.getDescription());
        
        return model;
    }
}
