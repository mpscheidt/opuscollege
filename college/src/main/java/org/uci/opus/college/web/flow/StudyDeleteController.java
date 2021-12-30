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
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * @author J.Nooitgedagt
 *
 */

@Controller
@RequestMapping("/college/study_delete.view")
public class StudyDeleteController {
    
    private static Logger log = LoggerFactory.getLogger(StudyDeleteController.class);
    private String viewName;
    @Autowired private MessageSource messageSource;    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    
    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public StudyDeleteController() {
        super();
        this.viewName = "college/study/studies";
    }

    /** 
     * {@inheritDoc}
     * @see org.springframework.web.servlet.mvc.Controller
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
	@RequestMapping(method=RequestMethod.POST)
	protected final String deleteStudyPost(HttpServletRequest request) {

    	return deleteStudy(request);

    }

    /** 
     * {@inheritDoc}.
     * @see org.springframework.web.servlet.mvc.Controller(
     *    javax.servlet.http.HttpServletRequest)
    */
    @RequestMapping(method=RequestMethod.GET)
    protected String deleteStudy(HttpServletRequest request) {

        String txtErr = "";
        int currentPageNumber = 0;

    	HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        int studyId = Integer.parseInt(request.getParameter("studyId"));

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // delete chosen study:
        if (studyId != 0) {

        	Locale currentLoc = RequestContextUtils.getLocale(request);

        	// studygradetype (and underlying subjectblocks) part of this studyId ?
            List < ? extends StudyGradeType > studyGradeTypeList = null;
            HashMap map = new HashMap();
            map.put("preferredLanguage", preferredLanguage);
            map.put("studyId", studyId);
            studyGradeTypeList = studyManager.findAllStudyGradeTypesForStudy(map);
            if (studyGradeTypeList.size() != 0) {
                // show error for linked results
            	txtErr = messageSource.getMessage(
                            "jsp.error.general.delete.linked.studygradetype", null, currentLoc);
            } else {
            	// subject part of this study?
                List < ? extends Subject > subjectList = null;
                subjectList = studyManager.findSubjectsForStudy(studyId);
                if (subjectList.size() != 0) {
                    // show error for linked results
                	txtErr = messageSource.getMessage(
                                    "jsp.error.general.delete.linked.subject", null, currentLoc);
                } else {
                    // study part of studyplan?
                    List < Integer > studyPlanIds = studyManager.findStudyPlansByStudyId(studyId);
                    if (!ListUtil.isNullOrEmpty(studyPlanIds)) {
                        // show error for linked studyPlans
                        txtErr = messageSource.getMessage(
                                        "jsp.error.general.delete.linked.studyplan", null, currentLoc); 
                    } else {
                        studyManager.deleteStudy(studyId);
                    }
                }
            }
        }

        viewName = "redirect:/college/studies.view?newForm=true&txtErr=" + txtErr
                + "&currentPageNumber=" + currentPageNumber;

        return viewName;
    }
    
}
