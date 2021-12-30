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

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/studygradetype_delete")
public class StudyGradeTypeDeleteController {

    private static Logger log = LoggerFactory.getLogger(StudyGradeTypeDeleteController.class);

    @Autowired
    StudyManagerInterface studyManager;

    @Autowired
    SubjectManagerInterface subjectManager;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public StudyGradeTypeDeleteController() {
        super();
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        int studyGradeTypeId = 0;
        int studyId = 0;
        int tab = 0;
        int panel = 0;
        String showStudyGradeTypeError = "";
        int currentPageNumber = 0;

        if (request.getParameter("studyGradeTypeId") != null && !"".equals(request.getParameter("studyGradeTypeId"))) {
            studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
        }
        if (request.getParameter("studyId") != null && !"".equals(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);

        // delete chosen studyGradeType:
        if (studyGradeTypeId != 0 && studyId != 0) {

            Locale currentLoc = RequestContextUtils.getLocale(request);

            // studygradetype cannot be deleted if a studyplan belongs to it
            List<StudyPlan> studyGradeTypeStudyPlanList = studyManager.findStudyPlansForStudyGradeType(studyGradeTypeId);
            if (studyGradeTypeStudyPlanList.size() != 0) {
                // show error for linked results
                showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.studygradetype.delete", null, currentLoc);
                showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.general.delete.linked.studyplan", null, currentLoc);
            } else {

                // studygradetype cannot be deleted if a subjectblock belongs to it
                List<SubjectBlock> studyGradeTypeSubjectBlockList = subjectBlockMapper.findAllSubjectBlocksForStudyGradeType(studyGradeTypeId);
                if (studyGradeTypeSubjectBlockList.size() != 0) {
                    // show error for linked results
                    showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.studygradetype.delete", null, currentLoc);
                    showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.general.delete.linked.subjectblock", null, currentLoc);
                }

                // studygradetype cannot be deleted if a subject belongs to it
                List<SubjectStudyGradeType> subjectStudyGradeTypeList = subjectManager.findSubjectsForStudyGradeType(studyGradeTypeId);
                if (subjectStudyGradeTypeList.size() != 0) {
                    // show error for linked results
                    showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.studygradetype.delete", null, currentLoc);
                    showStudyGradeTypeError = showStudyGradeTypeError + messageSource.getMessage("jsp.error.general.delete.linked.subject", null, currentLoc);
                }
            }

            // only delete if no errors found:
            if (StringUtil.isNullOrEmpty(showStudyGradeTypeError)) {
                log.info("deleting " + studyGradeTypeId);
                studyManager.deleteStudyGradeType(studyGradeTypeId, request);
            }
        }

        return "redirect:/college/study.view?newForm=true&tab=" + tab + "&panel=" + panel + "&studyId=" + studyId + "&showStudyGradeTypeError=" + showStudyGradeTypeError
                + "&currentPageNumber=" + currentPageNumber;

    }

}
