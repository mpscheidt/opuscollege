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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.ExaminationValidator;
import org.uci.opus.college.web.flow.subject.ExaminationForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/examination")
@SessionAttributes({ ExaminationEditController.FORM_OBJECT })
public class ExaminationEditController {

    public static final String FORM_OBJECT = "examinationForm";
    private static final String FORM_VIEW = "college/subject/examination";

    private static Logger log = LoggerFactory.getLogger(ExaminationEditController.class);

    private ExaminationValidator validator = new ExaminationValidator();

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private ExaminationManagerInterface examinationManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private TestManagerInterface testManager;

    public ExaminationEditController() {
        super();
    }

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));

    }

    /**
     * Creates a form backing object. If the request parameter "staff_member_ID" is set, the
     * specified staff member is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_OBJECT, session, model, opusMethods.isNewForm(request));

        ExaminationForm form = (ExaminationForm) model.get(FORM_OBJECT);
        if (form == null) {
            form = new ExaminationForm();
            model.put(FORM_OBJECT, form);

            form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

            int examinationId = ServletUtil.getIntParam(request, "examinationId", 0);

            /* with each call the preferred language may be changed */
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);

            // institutionId = OpusMethods.getInstitutionId(session, request);
            // session.setAttribute("institutionId", institutionId);
            //
            // branchId = OpusMethods.getBranchId(session, request);
            // session.setAttribute("branchId", branchId);
            //
            // organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            // session.setAttribute("organizationalUnitId", organizationalUnitId);
            //
            // String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
            // request.setAttribute("institutionTypeCode", institutionTypeCode);

            // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
            // opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request,
            // institutionTypeCode, institutionId, branchId, organizationalUnitId);

            List<Lookup10> allExaminationTypes = lookupCacher.getAllExaminationTypes(preferredLanguage);
            form.setAllExaminationTypes(allExaminationTypes);
            form.setAllExaminationTypesMap(new CodeToLookupMap(allExaminationTypes));

            Examination examination;
            Subject subject;
            int subjectId;

            if (examinationId != 0) {

                // EXISTING examination
                examination = examinationManager.findExamination(examinationId);
                subject = examination.getSubject();
                subjectId = examination.getSubjectId();

            } else {

                // NEW examination
                examination = new Examination();
                
                subjectId = ServletUtil.getIntParam(request, "examinationSubjectId", 0);
                if (subjectId == 0) {
                    throw new RuntimeException("Neither examinationId not subjectId givens");
                }

                examination.setSubjectId(subjectId);
                examination.setActive("Y");
                
                /* generate examinationCode */
                createAndSetExaminationCode(examination);

                subject = subjectManager.findSubject(subjectId);
            }
            form.setExamination(examination);
            form.setSubject(subject);

            // needed to show the subject's name in the header (bread crumbs path)
            Study study = studyManager.findStudy(subject.getPrimaryStudyId());
            form.setStudy(study);

            // see if the endGrades are defined on studygradetype level (zambian situation):
            form.setEndGradesPerGradeType(studyManager.useEndGrades(subject.getCurrentAcademicYearId()));
//            String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
//            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
//                endGradesPerGradeType = "N";
//            } else {
//                endGradesPerGradeType = "Y";
//            }
//            request.setAttribute("endGradesPerGradeType", endGradesPerGradeType);

            // calculate total percentage of tests underneath examination:
            // if (examination.getTests() != null && examination.getTests().size() != 0) {
            // for (int i = 0; i < examination.getTests().size(); i++) {
            // if ("Y".equals(examination.getTests().get(i).getActive())) {
            // percentageTotal = percentageTotal
            // + examination.getTests().get(i).getWeighingFactor();
            // }
            // }
            // }
            int percentageTotal = testManager.findTotalWeighingFactor(examinationId);
            form.setPercentageTotal(percentageTotal);

            List<Classgroup> allClassgroups = null;
            if (subjectId != 0) {
                allClassgroups = studyManager.findClassgroupsBySubjectId(subjectId);
            }
            form.setAllClassgroups(allClassgroups);

        }

        return FORM_VIEW;
    }

    private void createAndSetExaminationCode(Examination examination) {
        String examinationCode = StringUtil.createUniqueCode("E", "" + examination.getSubjectId());
        examination.setExaminationCode(examinationCode);
    }

    /**
     * Saves the new or updated contract.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) ExaminationForm form, BindingResult result) {

        Examination examination = form.getExamination();

        result.pushNestedPath("examination");
        validator.validate(examination, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int subjectId = examination.getSubjectId();

        /* if examinationCode is made empty, give default value */
        if (StringUtil.isNullOrEmpty(examination.getExaminationCode())) {
            /* generate examinationCode */
            createAndSetExaminationCode(examination);
        }

        /*
         * the total percentage of all underlying examinations of the subject cannot exceed 100%. So
         * adding or updating the examination cannot succeed if it makes the total exceed the 100%
         */
        int totalPercentage = examinationManager.findTotalWeighingFactor(subjectId, examination.getId());
        totalPercentage += examination.getWeighingFactor();

        /* test if the combination already exists */
        Map<String, Object> findExaminationMap = new HashMap<>();
        findExaminationMap.put("examinationCode", examination.getExaminationCode());
        findExaminationMap.put("examinationDescription", examination.getExaminationDescription());
        findExaminationMap.put("subjectId", examination.getSubjectId());
        findExaminationMap.put("examinationTypeCode", examination.getExaminationTypeCode());
        if (examination.getId() != 0) {
            findExaminationMap.put("id", examination.getId());
        }
        if (examinationManager.findExaminationByParams(findExaminationMap) != null) {
            result.reject("jsp.error.general.alreadyexists");
            return FORM_VIEW;
        }

        // test if the total percentage of examinations of the subject does not exceed 100
        if (totalPercentage > 100) {
            result.rejectValue("examination.weighingFactor", "jsp.error.percentagetotal.exceeds.hundred");
            return FORM_VIEW;
        }

        boolean newExamination = true;
        if (examination.getId() == 0) {
            log.info("adding " + examination);
            examinationManager.addExamination(examination);
        } else {
            newExamination = false;
            log.info("updating " + examination);
            examinationManager.updateExamination(examination);
        }

        NavigationSettings nav = form.getNavigationSettings();
        
        String view;
        if (newExamination) {
            view = "redirect:/college/examination.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&examinationSubjectId=" + subjectId + "&examinationId="
                    + examination.getId() + "&currentPageNumber=" + nav.getCurrentPageNumber();
        } else {
            view = "redirect:/college/subject.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&subjectId=" + subjectId + "&from=examination" + "&currentPageNumber="
                    + nav.getCurrentPageNumber();
        }

        return view;
    }

}
