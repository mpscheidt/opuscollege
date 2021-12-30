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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.SubjectBlockPrerequisite;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: SubjectPrerequisiteDeleteController.
 * Deletes prerequisites from subjectStudyGradeTypes
 *
 */
 public class SubjectBlockPrerequisiteDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(SubjectBlockPrerequisiteDeleteController.class);
     private String viewName;
     private SecurityChecker securityChecker;    
     private SubjectManagerInterface subjectManager;
     
     @Autowired
     private SubjectBlockMapper subjectBlockMapper;

     /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public SubjectBlockPrerequisiteDeleteController() {
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
        
        int tab = 0;
        int panel = 0;
        int subjectBlockStudyGradeTypeId = 0;
        // id of the prerequisite to delete
        String requiredSubjectBlockCode = "";
        SubjectBlockPrerequisite subjectBlockPrerequisite = new SubjectBlockPrerequisite();
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockStudyGradeTypeId"))) {
            subjectBlockStudyGradeTypeId = Integer.parseInt(
                                        request.getParameter("subjectBlockStudyGradeTypeId"));
        }

        // prerequisite to delete
        if (!StringUtil.isNullOrEmpty(request.getParameter("requiredSubjectBlockCode"))) {
            requiredSubjectBlockCode = request.getParameter("requiredSubjectBlockCode");
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

        // delete chosen subjectPrerequisite
        if (subjectBlockStudyGradeTypeId != 0
                && !StringUtil.isNullOrEmpty(requiredSubjectBlockCode)) {
            
            subjectBlockPrerequisite.setSubjectBlockStudyGradeTypeId(subjectBlockStudyGradeTypeId);
            subjectBlockPrerequisite.setRequiredSubjectBlockCode(requiredSubjectBlockCode);
            
            subjectBlockMapper.deleteSubjectBlockPrerequisite(subjectBlockPrerequisite);

            // get missing parameters for redirect to subjectblockstudygradetype.view
            SubjectBlockStudyGradeType subjectBlockStudyGradeType = subjectBlockMapper.findSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId, OpusConstants.DEFAULT_LANGUAGE);

            return new ModelAndView("redirect:/college/subjectblockstudygradetype.view?newForm=true&tab=" + tab + "&panel=" 
                                 + panel + "&subjectBlockStudyGradeTypeId=" + subjectBlockStudyGradeTypeId
                                 + "&from=deleteSubjectBlockPrerequisite"
                                 + "&currentPageNumber=" + currentPageNumber
                                 + "&subjectBlockId=" + subjectBlockStudyGradeType.getSubjectBlock().getId()
                                 + "&studyId=" + subjectBlockStudyGradeType.getStudyGradeType().getStudyId()
                                 + "&studyGradeTypeId=" + subjectBlockStudyGradeType.getStudyGradeType().getId()
                                 + "&gradeTypeCode=" + subjectBlockStudyGradeType.getStudyGradeType().getGradeTypeCode());
        } else {
            return new ModelAndView(viewName);
        }
    }


    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setSubjectManager(final SubjectManagerInterface subjectManager) {
        this.subjectManager = subjectManager;
    }

    public String getViewName() {
        return viewName;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }
}
