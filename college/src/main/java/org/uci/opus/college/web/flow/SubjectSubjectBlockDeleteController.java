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
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectsubjectblock_delete.view")
public class SubjectSubjectBlockDeleteController {

    private static Logger log = LoggerFactory.getLogger(SubjectSubjectBlockDeleteController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private MessageSource messageSource;

	 /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
    public SubjectSubjectBlockDeleteController() {
        super();
    }
	
	@RequestMapping(method=RequestMethod.POST)
	protected final String deleteSubjectSubjectBlockPost(HttpServletRequest request)
	                                        {

	    return deleteSubjectSubjectBlock(request);
	}

	@RequestMapping(method=RequestMethod.GET)
    protected String deleteSubjectSubjectBlock(HttpServletRequest request)
            {

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        int subjectSubjectBlockId = 0;
        int subjectId = 0;
        int tab = 0;
        int panel = 0;
        String showSubjectSubjectBlockError = "";
        int currentPageNumber = 0;
  
        // no form object, nothing to remove from session
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectSubjectBlockId"))) {
        	subjectSubjectBlockId = Integer.parseInt(
        	                                request.getParameter("subjectSubjectBlockId"));
        }

    	if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
    		subjectId = Integer.parseInt(request.getParameter("subjectId"));
    	}

    	if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("currentPageNumber"))) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }

        // delete chosen subjectSubjectBlock
        if (subjectSubjectBlockId != 0) {
        	Locale currentLoc = RequestContextUtils.getLocale(request);

        	// subjectSubjectBlock cannot be deleted if a subjectResult belongs to it
        	List < SubjectResult > subjectResultList = null;
            subjectResultList = resultManager.findSubjectResultsForSubjectSubjectBlock(
            		subjectSubjectBlockId);
            if (subjectResultList.size() != 0) {
                // show error for linked results
            	showSubjectSubjectBlockError = showSubjectSubjectBlockError
            			+ messageSource.getMessage(
            			"jsp.error.subjectsubjectblock.delete", null, currentLoc);
            	showSubjectSubjectBlockError = showSubjectSubjectBlockError
            			+ messageSource.getMessage(
                        "jsp.error.general.delete.linked.subjectresult", null, currentLoc);
            } else {
            	// subjectSubjectBlock cannot be deleted if an examinationResult belongs to it
            	List examinationResults = null;
                List examinationResultList = null;
                ExaminationResult examinationResult = null;
                examinationResults = resultManager.findExaminationResultsForSubjectSubjectBlock(
                		subjectSubjectBlockId);
                for (int i = 0; i < examinationResults.size(); i++) {
                	examinationResult = (ExaminationResult) examinationResults.get(i);
	                examinationResultList = resultManager.findExaminationResults(
	                		examinationResult.getExaminationId());
	                if (examinationResultList.size() != 0) {
	                    // show error for linked examination results
	                	showSubjectSubjectBlockError = showSubjectSubjectBlockError
	                		+ messageSource.getMessage(
	                    	"jsp.error.subjectsubjectblock.delete", null, currentLoc);
	                	showSubjectSubjectBlockError = showSubjectSubjectBlockError
	                		+ messageSource.getMessage(
	                        "jsp.error.general.delete.linked.examinationresult", null, currentLoc);
	                }
	                // one error message is enough:
	                if (!"".equals(showSubjectSubjectBlockError)) {
	                    //break for loop:
	                    break;
	                }
                }
            }
            if (StringUtil.isNullOrEmpty(showSubjectSubjectBlockError)) {
                subjectManager.deleteSubjectSubjectBlock(subjectSubjectBlockId);
            }
        }

        return "redirect:/college/subject.view?newForm=true&tab=" + tab + "&panel=" + panel
                         + "&subjectId=" + subjectId
                         + "&showSubjectSubjectBlockError=" + showSubjectSubjectBlockError
                         + "&currentPageNumber=" + currentPageNumber;
    }

}
