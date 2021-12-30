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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.util.StringUtil;

/**
 * @author J.Nooitgedagt
 */

@Controller
@RequestMapping("/college/penalty_delete.view")
public class PenaltyDeleteController {
    
    private static Logger log = LoggerFactory.getLogger(PenaltyDeleteController.class);

    @Autowired private StudentManagerInterface studentManager;
    
    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public PenaltyDeleteController() {
        super();
    }
    
    @RequestMapping(method=RequestMethod.POST)
    protected final String deletePenaltyPost(HttpServletRequest request) 
            {

        return deletePenalty(request);
    }

    @RequestMapping(method=RequestMethod.GET)
    protected String deletePenalty(HttpServletRequest request) {

        int currentPageNumber = 0;
        int tab = 0;
        int panel = 0;
        int penaltyId = 0;
        int studentId = 0;

        if (!StringUtil.isNullOrEmpty(request.getParameter("penaltyId"))) {
            penaltyId = Integer.parseInt(request.getParameter("penaltyId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
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
        
        // delete chosen penalty:
        if (penaltyId != 0 && studentId != 0) {
            studentManager.deletePenalty(penaltyId);
        }
        
        return "redirect:/college/student-absences.view?newForm=true&tab=" + tab + "&panel=" + panel 
                + "&studentId=" + studentId
                + "&currentPageNumber=" + currentPageNumber;

    }
}
