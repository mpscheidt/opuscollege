/*******************************************************************************
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
 * The Original Code is Opus-College scholarship module code.
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
 ******************************************************************************/
package org.uci.opus.scholarship.web.flow;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author u606118
 *
 */
public class SubsidyDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(SubsidyDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private ScholarshipManagerInterface scholarshipManager;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public SubsidyDeleteController() {
        super();
    }
    
    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        
        ServletContext context;
        
        String showSubsidyError = "";
        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        context = this.getServletContext();

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }

        int subsidyId = 
            Integer.parseInt(request.getParameter("subsidyId"));

        // delete chosen subsidy:
        if (subsidyId != 0) {
            scholarshipManager.deleteSubsidy(subsidyId); 
        }
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:/scholarship/scholarshipstudent.view");
        mav.getModelMap().put("showSubsidyError", showSubsidyError);
        mav.getModelMap().put("studentId", request.getParameter("studentId"));
        mav.getModelMap().put("panel", request.getParameter("panel"));
        mav.getModelMap().put("tab", request.getParameter("tab"));
        mav.getModelMap().put("currentPageNumber", currentPageNumber);
        
        return mav; 
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
     * @return Returns the securityChecker.
     */
    public SecurityChecker getSecurityChecker() {
        return securityChecker;
    }

    /**
     * @param securityChecker is set by Spring on application init.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }
   
    /**
     * @param scholarshipManager the scholarshipManager to set
     */
    public void setScholarshipManager(final ScholarshipManagerInterface scholarshipManager) {
        this.scholarshipManager = scholarshipManager;
    }

}
