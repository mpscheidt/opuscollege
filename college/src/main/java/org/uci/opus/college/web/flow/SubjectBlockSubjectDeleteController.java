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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: SubjectBlockSubjectDeleteController.
 */
 public class SubjectBlockSubjectDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(SubjectBlockSubjectDeleteController.class);
	 private String viewName;
     private SecurityChecker securityChecker;    
     private SubjectManagerInterface subjectManager;
     private StudyManagerInterface studyManager;
     private StaffMemberManagerInterface staffMemberManager;
     private ResultManagerInterface resultManager;
     private LookupCacher lookupCacher;
     private OpusMethods opusMethods;
     private MessageSource messageSource;
     
     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public SubjectBlockSubjectDeleteController() {
		super();
	}

    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, final HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        Study study = null;
        int subjectSubjectBlockId = 0;
        int studyId = 0;
        int subjectBlockId = 0;
        int tab = 0;
        int panel = 0;
        String showSubjectBlockSubjectError = "";
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (request.getParameter("subjectSubjectBlockId") != null 
                && !"".equals(request.getParameter("subjectSubjectBlockId"))) {
        	subjectSubjectBlockId = Integer.parseInt(request.getParameter("subjectSubjectBlockId"));
        }

    	if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
    		studyId = Integer.parseInt(request.getParameter("studyId"));
    	}

    	if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);

        if (!StringUtil.isNullOrEmpty(request.getParameter("currentPageNumber"))) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        // get the studyId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
        	studyId = Integer.parseInt(request.getParameter("studyId"));
        }
        if (studyId != 0) {
            study = studyManager.findStudy(studyId);
            request.setAttribute("study", study);
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockId"))) {
        	subjectBlockId = Integer.parseInt(request.getParameter("subjectBlockId"));
        }

        // delete chosen subjectSubjectblocks
        if (subjectSubjectBlockId != 0) {
        	Locale currentLoc = RequestContextUtils.getLocale(request);

        	// subjectSubjectBlock cannot be deleted if a subjectresult belongs to it
        	List < SubjectResult > subjectResultList = null;
            subjectResultList = resultManager.findSubjectResultsForSubjectSubjectBlock(
            		subjectSubjectBlockId);
            if (subjectResultList.size() != 0) {
                // show error for linked results
            	showSubjectBlockSubjectError = showSubjectBlockSubjectError
            			+ messageSource.getMessage(
            			"jsp.error.subjectsubjectblock.delete", null, currentLoc);
            	showSubjectBlockSubjectError = showSubjectBlockSubjectError
            			+ messageSource.getMessage(
                        "jsp.error.general.delete.linked.subjectresult", null, currentLoc);
            } else {
            	// subjectSubjectblock cannot be deleted if an examinationResult belongs to it
            	List<ExaminationResult> examinationResults = null;
                List<ExaminationResult> examinationResultList = null;
                ExaminationResult examinationResult = null;
                examinationResults = resultManager.findExaminationResultsForSubjectSubjectBlock(
                		subjectSubjectBlockId);
                for (int i = 0; i < examinationResults.size(); i++) {
                	examinationResult = (ExaminationResult) examinationResults.get(i);
	                examinationResultList = resultManager.findExaminationResults(
	                		examinationResult.getExaminationId());
	                if (examinationResultList.size() != 0) {
	                    // show error for linked examination results
	                	showSubjectBlockSubjectError = showSubjectBlockSubjectError
	                		+ messageSource.getMessage(
	                    	"jsp.error.subjectsubjectblock.delete", null, currentLoc);
	                	showSubjectBlockSubjectError = showSubjectBlockSubjectError
	                		+ messageSource.getMessage(
	                        "jsp.error.general.delete.linked.examinationresult", null, currentLoc);
	                }
	                // one error message is enough:
	                if (!"".equals(showSubjectBlockSubjectError)) {
	                    //break for loop:
	                    break;
	                }
                }
            }
            if (StringUtil.isNullOrEmpty(showSubjectBlockSubjectError)) {
                subjectManager.deleteSubjectSubjectBlock(subjectSubjectBlockId);
            }
        }

        if (studyId != 0) {
            study = studyManager.findStudy(studyId);
        }

        return new ModelAndView("redirect:/college/subjectblock.view?newForm=true&tab=2&panel=0"
                       + "&subjectBlockId=" + subjectBlockId
                       + "&showSubjectBlockSubjectError=" + showSubjectBlockSubjectError);
        
    }

    /**
     * @return Returns the viewName.
     */
    public String getViewName() {
        return viewName;
    }


    /**
     * @param viewName is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    /**
     * @param securityChecker
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }
   
    /**
     * @param studyManager The studyManager to set.
     */
    public void setStudyManager(final StudyManagerInterface studyManager) {
		this.studyManager = studyManager;
	}

	/**
     * @param newSubjectManager The subjectManager to set.
     */
    public void setSubjectManager(final SubjectManagerInterface newSubjectManager) {
    	subjectManager = newSubjectManager;
    }
    
    /**
     * @param newStaffMemberManager The staffMemberManager to set.
     */
    public void setStaffMemberManager(final StaffMemberManagerInterface newStaffMemberManager) {
        staffMemberManager = newStaffMemberManager;
    }

    /**
	 * @param examinationManager The examinationManager to set.
	 */
	public void setResultManager(ResultManagerInterface resultManager) {
		this.resultManager = resultManager;
	}

	/**
     * @param newLookupCacher The lookupCacher to set.
     */
    public void setLookupCacher(final LookupCacher newLookupCacher) {
        lookupCacher = newLookupCacher;
    }

	/**
	 * @param opusMethods The opusMethods to set.
	 */
	public void setOpusMethods(OpusMethods opusMethods) {
		this.opusMethods = opusMethods;
	}

	/**
	 * @param messageSource The messageSource to set.
	 */
	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

    
}
