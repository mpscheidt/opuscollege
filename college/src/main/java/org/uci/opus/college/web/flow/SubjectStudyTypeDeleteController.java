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
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectstudytype_delete.view")
public class SubjectStudyTypeDeleteController {
    
    private static Logger log = LoggerFactory.getLogger(SubjectStudyTypeDeleteController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public SubjectStudyTypeDeleteController() {
        super();
    }

    @RequestMapping(method=RequestMethod.POST)
    protected final String deleteSubjectStudyTypePost(HttpServletRequest request) 
            {

        return deleteSubjectStudyType(request);
    }
    
    @RequestMapping(method=RequestMethod.GET)
    protected String deleteSubjectStudyType(HttpServletRequest request)
            {

        HttpSession session = request.getSession(false);        

        int tab = 0;
        int panel = 0;
        int subjectStudyTypeId = 0;
        int subjectId = 0;
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object used here
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyTypeId"))) {
            subjectStudyTypeId = Integer.parseInt(
                                    request.getParameter("subjectStudyTypeId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
            subjectId = Integer.parseInt(request.getParameter("subjectId"));
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

        // delete chosen subjectStudyType
        if (subjectStudyTypeId != 0) {
            subjectManager.deleteSubjectStudyType(subjectStudyTypeId);
        }

        return "redirect:/college/subject.view?newForm=true&tab=" + tab + "&panel=" 
                                 + panel + "&subjectId=" + subjectId
                                 + "&currentPageNumber=" + currentPageNumber;

    }

}
