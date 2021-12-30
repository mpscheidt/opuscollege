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

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.ImageIcon;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

import net.sf.jasperreports.engine.JRImageRenderer;
import net.sf.jasperreports.renderers.BatikRenderer;

@Controller
@RequestMapping(value="/college/report/logmailerrorsreport.view")
public class LogMailErrorsReportController  {

    private static Logger log = LoggerFactory.getLogger(LogMailErrorsReportController.class);

    private String viewName;

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private ReportController reportController;
    @Autowired private ReportPropertyMapper reportPropertyMapper;

    public LogMailErrorsReportController() {
        super();
        viewName = "/admin/logmailerrors";
    }

    @RequestMapping(method=RequestMethod.GET)
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession(false);

        securityChecker.checkSessionValid(session);
        /* set menu to report */
        session.setAttribute("menuChoice", "admin");
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale locale = OpusMethods.getPreferredLocale(request);

        ModelAndView mav = new ModelAndView(viewName);
        
        String reportFormat = ServletUtil.getParamSetAttrAsString(request, "reportFormat", "pdf");
        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "LogMailErrorsList");
        String reportFullName = reportName;//full path to report
        
         locale = OpusMethods.getPreferredLocale(request);
         String requestWhereClause = reportController.generateSQLWhereClause(request);
            
			mav = reportController.createReport(session, reportFullName,
                    requestWhereClause,
                    reportFormat, locale);

            StringBuilder whereClause = new StringBuilder();


            reportController.addWhereClause(mav, whereClause.toString());
            reportController.putModelParameter(mav, "lang", preferredLanguage);
            reportController.putModelParameters(mav, getUserProperties(reportName));


        return mav;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }
    
    protected Map<String, Object> getUserProperties(String reportName) {

        Map<String, Object> map = new HashMap<String, Object>();

        List<ReportProperty> properties = reportPropertyMapper.findPropertiesForReport(reportName);

        for (Iterator<ReportProperty> iterator = properties.iterator(); iterator.hasNext();) {
            ReportProperty property = (ReportProperty) iterator.next();
            String propertyName = property.getName();

            //if it is a file property
            if (!property.getType().equalsIgnoreCase("text")) {

                if (property.isVisible()) {
                    if ((property.getFile().length == 0)) {
                        //reportController.putModelParameter(mav, "reportLogo", new ImageIcon().getImage());
                        map.put(propertyName, new ImageIcon().getImage());
                    } else {

                        //choose a different renderer for SVG images
                        if ("image/svg+xml".equals(property.getType())) {
                            map.put(propertyName, BatikRenderer.getInstance(property.getFile()));
                        } else {
                            map.put(propertyName, JRImageRenderer.getInstance(property.getFile()));  
                        }
                    }
                } else {
                    map.put(propertyName, new ImageIcon().getImage());
                }

                //if it is text property
            } else {

                if (property.isVisible()) {
                    map.put(propertyName, property.getText());
                } else {
                    map.put(propertyName, "");
                }
            }
        }

        return map;
    	
    }
    
    
}
