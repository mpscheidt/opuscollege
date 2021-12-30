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

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectprerequisite_delete.view")
public class SubjectPrerequisiteDeleteController {
    
     private static Logger log = LoggerFactory.getLogger(SubjectPrerequisiteDeleteController.class);
     @Autowired private SecurityChecker securityChecker;
     @Autowired private SubjectManagerInterface subjectManager;
     @Autowired private MessageSource messageSource;

     /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public SubjectPrerequisiteDeleteController() {
        super();
    }
    
    @RequestMapping(method=RequestMethod.POST)
    protected final String deleteSubjectPrerequisitePost(HttpServletRequest request) {

        return deleteSubjectPrerequisite(request);
    }

    /**
     * Creates a form backing object. If the request parameters "subjectStudyGradeTypeId"
     * and "subjectId" are set, the specified subjectPRerequisite is deleted.
     */
    @RequestMapping(method=RequestMethod.GET)
    protected String deleteSubjectPrerequisite(HttpServletRequest request) {

        
        HttpSession session = request.getSession(false);        
        
        int tab = 0;
        int panel = 0;
        int subjectStudyGradeTypeId = 0;
        // id of the prerequisite to delete
        String requiredSubjectCode = "";
        SubjectPrerequisite subjectPrerequisite = new SubjectPrerequisite();
        int currentPageNumber = 0;
        // subject for the crumble path
        
        String subjectPrerequisiteError = "";

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object, nothing to remove from session
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyGradeTypeId"))) {
            subjectStudyGradeTypeId = Integer.parseInt(
                                        request.getParameter("subjectStudyGradeTypeId"));
        }

        // prerequisite to delete
        if (!StringUtil.isNullOrEmpty(request.getParameter("requiredSubjectCode"))) {
            requiredSubjectCode = request.getParameter("requiredSubjectCode");
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }

        // delete chosen subjectPrerequisite
        if (subjectStudyGradeTypeId != 0 && !StringUtil.isNullOrEmpty(requiredSubjectCode)) {

            subjectPrerequisite.setSubjectStudyGradeTypeId(subjectStudyGradeTypeId);
            subjectPrerequisite.setRequiredSubjectCode(requiredSubjectCode);

            subjectManager.deleteSubjectPrerequisite(subjectPrerequisite);

        } else {
            Locale currentLoc = RequestContextUtils.getLocale(request);
            subjectPrerequisiteError = messageSource.getMessage(
            "jsp.error.subjectprerequisite.delete", null, currentLoc);
        }
        
        return "redirect:/college/subjectstudygradetype.view?newForm=true&tab=" + tab
                                        + "&panel=" + panel
                                        + "&currentPageNumber=" + currentPageNumber
                                        + "&subjectStudyGradeTypeId=" + subjectStudyGradeTypeId
                                        + "&subjectPrerequisiteError=" + subjectPrerequisiteError;
    }

}
