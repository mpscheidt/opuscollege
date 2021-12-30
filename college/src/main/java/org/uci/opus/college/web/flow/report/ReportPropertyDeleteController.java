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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.college.web.flow.report;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * @author smacumbe
 *Feb 14, 2009
 */
@Controller
@RequestMapping(value = "/college/report/reportproperty_delete.view")
public class ReportPropertyDeleteController {


    private static Logger log = LoggerFactory.getLogger(ReportPropertyDeleteController.class);
    
    private String viewName;

    @Autowired private SecurityChecker securityChecker;
    @Autowired private ReportPropertyMapper reportPropertyMapper;

    public ReportPropertyDeleteController() {
        super();
        this.viewName = "admin/reportproperties";
    }

    @RequestMapping(method = RequestMethod.GET)
    protected final ModelAndView handleRequestInternal(
            final HttpServletRequest request, final HttpServletResponse response) {

        HttpSession session = request.getSession(false);        

        int propertyId = ServletUtil.getParamSetAttrAsInt(request, "propertyId", 0);
        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "");

        /*
         * perform session-check. If wrong, this throws an Exception towards
         * ErrorController
         */
        securityChecker.checkSessionValid(session);

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");


        int currentPageNumber = ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 1);
        String institutionTypeCode = ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode", 
                OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);

        reportPropertyMapper.delete(propertyId);
        
        return new ModelAndView("redirect:/college/report/reportproperties.view?reportName=" + reportName  + "&institutionTypeCode=" + institutionTypeCode + "&currentPageNumber=" + currentPageNumber);
    }

}
