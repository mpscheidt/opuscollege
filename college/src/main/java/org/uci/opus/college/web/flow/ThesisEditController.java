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
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisStatus;
import org.uci.opus.college.domain.ThesisSupervisor;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.ThesisValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.ThesisForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/thesis")
@SessionAttributes({ ThesisEditController.FORM_OBJECT })
public class ThesisEditController {

    public static final String FORM_OBJECT = "thesisForm";
    private static final String FORM_VIEW = "college/person/thesis";

    private static Logger log = LoggerFactory.getLogger(ThesisEditController.class);

    private ThesisValidator validator = new ThesisValidator();


//    @Autowired
//    private LookupCacher lookupCacher;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private MessageSource messageSource;
    
    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StudyManagerInterface studyManager;

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);

        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "id" (of the thesis) is set, the
     * specified thesis is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        /* set menu to students */
        session.setAttribute("menuChoice", "students");
        
        ThesisForm form = new ThesisForm();
        model.put(FORM_OBJECT, form);
        
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // all academicYears
        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        form.setAllAcademicYears(allAcademicYears);

        // see if the endGrades are defined on studygradetype level:
//        String endGradesPerGradeType = studyManager.findEndGradeType(0);
//        if (endGradesPerGradeType != null || !"".equals(endGradesPerGradeType)) {
//            endGradesPerGradeType = "Y";
//        } else {
//            endGradesPerGradeType = "N";
//        }
//        request.setAttribute("endGradesPerGradeType", endGradesPerGradeType);
        form.setEndGradesPerGradeType(studyManager.useEndGrades());

        
        Thesis thesis;
        int studyPlanId;

        // get the thesisId if it exists
        int thesisId = ServletUtil.getIntParam(request, "thesisId", 0);

        if (thesisId != 0) {

            // EXISTING THESIS
            thesis = studentManager.findThesis(thesisId);

            studyPlanId = thesis.getStudyPlanId();
            
            if (thesis.getThesisSupervisors() != null && thesis.getThesisSupervisors().size() > 0) {
                boolean principalPresent = false;
                for (int i = 0; i < thesis.getThesisSupervisors().size(); i++) {
                    ThesisSupervisor thesisSupervisor = thesis.getThesisSupervisors().get(i);
                    if (thesisSupervisor.getPrincipal().equals(OpusConstants.GENERAL_YES)) {
                        principalPresent = true;
                        break;
                    }
                }
                if (!principalPresent) {
                    String txtMsg = messageSource.getMessage("jsp.msg.no.principal.exists", null, RequestContextUtils.getLocale(request));
                    form.setTxtMsg(txtMsg);
                }

            }
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("thesisId", thesisId);
            map.put("preferredLanguage", preferredLanguage);
            List<ThesisStatus> thesisStatuses = studentManager.findThesisStatuses(map);
            thesis.setThesisStatuses(thesisStatuses);

        } else {

            // NEW THESIS
            thesis = new Thesis();
            thesis.setThesisStatusDate(new Date());
            thesis.setActive("Y");

            studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
            if (studyPlanId == 0) {
                throw new RuntimeException("Neither thesisId nor studyPlanId given");
            }
            thesis.setStudyPlanId(studyPlanId);
        }
        
        form.setThesis(thesis);

        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);
        form.setStudyPlan(studyPlan);

        form.setStudent(studentManager.findStudent(preferredLanguage, studyPlan.getStudentId()));


        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) ThesisForm form, BindingResult result) {

        Thesis thesis = form.getThesis();

        result.pushNestedPath("thesis");
        validator.validate(thesis, result);
        result.popNestedPath();
        
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

//        Thesis changedThesis = null;
//        int studyPlanId = 0;
//        String showThesisEditError = "";



//        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_thesis"))) {
//            tab = Integer.parseInt(request.getParameter("tab_thesis"));
//        } else {
//            if (!StringUtil.isNullOrEmpty(request.getParameter("tab_research"))) {
//                tab = Integer.parseInt(request.getParameter("tab_research"));
//            } else {
//                if (!StringUtil.isNullOrEmpty(request.getParameter("tab_publications"))) {
//                    tab = Integer.parseInt(request.getParameter("tab_publications"));
//                } else {
//                    if (!StringUtil.isNullOrEmpty(request.getParameter("tab_keywords"))) {
//                        tab = Integer.parseInt(request.getParameter("tab_keywords"));
//                    } else {
//                        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_content"))) {
//                            tab = Integer.parseInt(request.getParameter("tab_content"));
//                        } else {
//                            if (!StringUtil.isNullOrEmpty(request.getParameter("tab_researchers"))) {
//                                tab = Integer.parseInt(request.getParameter("tab_researchers"));
//                            } else {
//                                if (!StringUtil.isNullOrEmpty(request.getParameter("tab_supervisors"))) {
//                                    tab = Integer.parseInt(request.getParameter("tab_supervisors"));
//                                } else {
//                                    if (!StringUtil.isNullOrEmpty(request.getParameter("tab_reading"))) {
//                                        tab = Integer.parseInt(request.getParameter("tab_reading"));
//                                    } else {
//                                        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_defense"))) {
//                                            tab = Integer.parseInt(request.getParameter("tab_defense"));
//                                        } else {
//                                            if (!StringUtil.isNullOrEmpty(request.getParameter("tab_clearness"))) {
//                                                tab = Integer.parseInt(request.getParameter("tab_clearness"));
//                                            } else {
//                                                if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//                                                    tab = Integer.parseInt(request.getParameter("tab"));
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }

//        request.setAttribute("tab", tab);
//
//        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_thesis"))) {
//            panel = Integer.parseInt(request.getParameter("panel_thesis"));
//        } else {
//            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_research"))) {
//                panel = Integer.parseInt(request.getParameter("panel_research"));
//            } else {
//                if (!StringUtil.isNullOrEmpty(request.getParameter("panel_publications"))) {
//                    panel = Integer.parseInt(request.getParameter("panel_publications"));
//                } else {
//                    if (!StringUtil.isNullOrEmpty(request.getParameter("panel_keywords"))) {
//                        panel = Integer.parseInt(request.getParameter("panel_keywords"));
//                    } else {
//                        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_content"))) {
//                            panel = Integer.parseInt(request.getParameter("panel_content"));
//                        } else {
//                            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_researchers"))) {
//                                panel = Integer.parseInt(request.getParameter("panel_researchers"));
//                            } else {
//                                if (!StringUtil.isNullOrEmpty(request.getParameter("panel_supervisors"))) {
//                                    panel = Integer.parseInt(request.getParameter("panel_supervisors"));
//                                } else {
//                                    if (!StringUtil.isNullOrEmpty(request.getParameter("panel_reading"))) {
//                                        panel = Integer.parseInt(request.getParameter("panel_reading"));
//                                    } else {
//                                        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_defense"))) {
//                                            panel = Integer.parseInt(request.getParameter("panel_defense"));
//                                        } else {
//                                            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_clearness"))) {
//                                                panel = Integer.parseInt(request.getParameter("panel_clearness"));
//                                            } else {
//                                                if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//                                                    panel = Integer.parseInt(request.getParameter("panel"));
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        request.setAttribute("panel", panel);

        // if empty, create unique thesisCode
        boolean newThesisCode = false;
        if (StringUtil.isNullOrEmpty(thesis.getThesisCode(), true)) {
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String thesisCode = StringUtil.createUniqueCode("T", strRandomCode);
            thesis.setThesisCode(thesisCode);
            newThesisCode = true;
        }

        // NEW THESIS
        if (thesis.getId() == 0) {
            /* test if the code already exists */
            if (!newThesisCode && studentManager.findThesisByCode(thesis.getThesisCode()) != null) {
//                if () {
                    /* reset the thesis fetched */
//                    Locale currentLoc = RequestContextUtils.getLocale(request);
//                    showThesisEditError = thesis.getThesisDescription() + " (" + thesis.getThesisCode() + "). "
//                            + messageSource.getMessage("jsp.error.general.alreadyexists", null, currentLoc);
                    result.rejectValue("thesisCode", "jsp.error.general.alreadyexists");
                    return FORM_VIEW;
//                } else {
//                    // add the new thesis
//                    log.info("adding " + thesis);
//                    studentManager.addThesis(thesis, studyPlanId);
////                    changedThesis = studentManager.findThesisByCode(thesis.getThesisCode());
//                }
            } else {
                // add the new thesis
                log.info("adding " + thesis);
                studentManager.addThesis(thesis);
//                changedThesis = studentManager.findThesisByCode(thesis.getThesisCode());
            }

            // UPDATE THESIS
        } else {

            // update the thesis
            log.info("updating " + thesis);
            studentManager.updateThesis(thesis);
//            changedThesis = studentManager.findThesis(thesis.getId());
        }

//        if (StringUtil.isNullOrEmpty(showThesisEditError, true)) {
//            this.setSuccessView("redirect:/college/thesis.view?newForm=true&tab=" + tab + "&panel=" + panel + "&thesisId=" + changedThesis.getId() + "&studentId=" + studentId
//                    + "&studyPlanId=" + studyPlanId + "&currentPageNumber=" + currentPageNumber);
//        } else {
//            this.setSuccessView("redirect:/college/thesis.view?newForm=true&" + "showThesisEditError=" + showThesisEditError + "&studyPlanId=" + studyPlanId + "&studentId="
//                    + studentId + "&currentPageNumber=" + currentPageNumber);
//        }

        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/thesis.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&thesisId=" + thesis.getId()
              + "&currentPageNumber=" + nav.getCurrentPageNumber();
    }

}
