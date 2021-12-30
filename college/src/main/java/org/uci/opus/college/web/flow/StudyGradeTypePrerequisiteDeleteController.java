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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: SubjectPrerequisiteDeleteController.
 * Deletes prerequisites from subjectStudyGradeTypes
 *
 */
 public class StudyGradeTypePrerequisiteDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(StudyGradeTypePrerequisiteDeleteController.class);
     private String viewName;
     private SecurityChecker securityChecker;    
     private StudyManagerInterface studyManager;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public StudyGradeTypePrerequisiteDeleteController() {
        super();
    }

    /**
     * Creates a form backing object. If the request parameters "subjectStudyGradeTypeId"
     * and "subjectId" are set, the specified subjectPRerequisite is deleted.
     */
    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) {
        
        HttpSession session = request.getSession(false);        
        
        // study of which to remove the prerequisite
        int studyId = 0;
        int tab = 0;
        int panel = 0;
        int studyGradeTypeId = 0;
        int requiredStudyId = 0;
        String requiredGradeTypeCode = "";
        StudyGradeTypePrerequisite prerequisite = new StudyGradeTypePrerequisite();
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
            studyGradeTypeId = Integer.parseInt(
                                        request.getParameter("studyGradeTypeId"));
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(
                                        request.getParameter("studyId"));
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("requiredStudyId"))) {
            requiredStudyId = Integer.parseInt(
                                        request.getParameter("requiredStudyId"));
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("requiredGradeTypeCode"))) {
            requiredGradeTypeCode = request.getParameter("requiredGradeTypeCode");
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

        // delete chosen prerequisite
        if (studyGradeTypeId != 0
                && requiredStudyId != 0 && !StringUtil.isNullOrEmpty(requiredGradeTypeCode)) {
            
            prerequisite.setStudyGradeTypeId(studyGradeTypeId);
            prerequisite.setRequiredStudyId(requiredStudyId);
            prerequisite.setRequiredGradeTypeCode(requiredGradeTypeCode);
            
            studyManager.deleteStudyGradeTypePrerequisite(prerequisite);
        }

        this.setViewName("redirect:/college/studygradetype.view?newForm=true&tab=" + tab + "&panel=" 
                                 + panel + "&studyGradeTypeId=" + studyGradeTypeId
                                 + "&studyId=" + studyId
                                 + "&from=deletePrerequisite"
                                 + "&currentPageNumber=" + currentPageNumber);

        return new ModelAndView(viewName);
    }


    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public String getViewName() {
        return viewName;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }
}
