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

package org.uci.opus.college.web.util;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.context.support.MessageSourceResourceBundle;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.view.jasperreports.JasperReportsMultiFormatView;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;

/**
 * Simple <code>Controller</code> implementation returning
 * data for report rendering. This implementation demonstrates
 * how JasperReports view can be integrated into your application
 * without placing a JasperReports dependency on your application code.
 * All data returned in the <code>ModelAndView</code> instances uses
 * standard Java classes.
 *
 * @author Rob Harrop
 * @author Markus Pscheidt
 */
@Controller
@RequestMapping("/college/reports.view")
public class ReportController extends AbstractController {

    public static final String DATA_SOURCE = "dataSource";
    public static final String WHERE_CLAUSE = "whereClause";
    public static final String REPORT_FORMAT = "reportFormat";
    public static final String REPORT_NAME = "reportName";
    public static final String DEFAULT_REPORT_FORMAT = "pdf";
    private static Logger log = LoggerFactory.getLogger(ReportController.class);

    private DataSource dataSource;
    @Autowired private ApplicationContext applicationContext;
    @Autowired private MessageSource messageSource;


    public ReportController(){
        super();
    }

    /**
     * 
     * @return example: map "pdf" to "inline; filename=report.pdf"
     * 
     */
    protected static Properties getContentDispositionMappings(String format) {
        Properties contentDispositionMappings;
        //		contentDispositionMappings.put("pdf", "inline; filename=report.pdf");
        contentDispositionMappings = new Properties();
        contentDispositionMappings.put(format, "inline; filename=report." + format);
        return contentDispositionMappings;
    }

    protected static Properties getContentDispositionMappings(String downloadFileName, String format) {
        Properties contentDispositionMappings;
        
        contentDispositionMappings = new Properties();
        
        contentDispositionMappings.put(format, String.format("inline; filename=%s.%s", downloadFileName, format));
        return contentDispositionMappings;
    }

    @Override
    public ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) {

        return createReport(request);
    }



    /**
     * Intelligently extract the request parameters
     * and create a SQL where clause.
     * Rules: (a) parameters with different names are concatenated by AND;
     * (b) parameters with the same names but different values are concatenated by OR.
     * (c) if parameter values actually consist of two or more fields separated by .AND.,
     * then the fields are concatenated with AND, which in turn are concatenated by OR.
     * Examples:
     * - where.studyId=1&where.studyplanId=2 results in: AND (studyId = 1) AND (studyplanId = 2)
     * - where.studyId=1&whereStudyId=2 results in: AND (studyIN = 1 OR studyId = 2)
     * - where.studyId.AND.studyPlanId=10|1&where.studyId.AND.studyPlanId=11|2 will
     *   result in: AND (studyId = 10 AND studyplanId = 1) 
     *               OR (studyId = 11 AND studyplanId = 2)
     * @param request
     * @return
     */
    public String generateSQLWhereClause(HttpServletRequest request) {
        StringBuffer whereClause = new StringBuffer();
        for (Iterator it = request.getParameterMap().entrySet().iterator(); it.hasNext();) {
            Map.Entry entry = (Map.Entry) it.next();
            String paramName = (String) entry.getKey();
            if (paramName.startsWith("where.") || paramName.startsWith("whereNot0.")) {
                String[] paramValues = request.getParameterValues(paramName);

                // if the value must not be zero, and the value is zero, abort.
                if (paramName.startsWith("whereNot0.")
                        && ("0".equals(paramValues[0]) || "'0'".equals(paramValues[0]))) {
                    continue;
                }

                // find out name of parameter
                if (paramName.startsWith("whereNot0.")) {
                    paramName = paramName.substring("whereNot0.".length());
                } else {
                    paramName = paramName.substring("where.".length());
                }

                // is this a compound parameter (with .and.)?
                String[] sqlFields = paramName.split("\\.and\\.");    // Note: \\. means \. in regexp

                //                whereClause.append( " AND " + "(");
                whereClause.append( " AND ");
                if (paramValues.length > 1) {
                    whereClause.append('(');
                }

                for(int i = 0; i < paramValues.length; i++) {
                    //	   				if (i == 0) {
                    //	   					whereClause.append( " AND " + "(");
                    //	   				}
                    if (sqlFields.length > 1) { whereClause.append("("); }

                    String[] sqlValues = paramValues[i].split("\\|");
                    for (int s = 0; s < sqlFields.length; s++) {
                        //    	   				whereClause.append(paramName).append("=").append(paramValues[i]);
                        whereClause.append(sqlFields[s]).append("=").append(sqlValues[s]);
                        if( (s + 1) != (sqlFields.length)) {
                            whereClause.append(" AND ");
                        }
                    }    	   				

                    if (sqlFields.length > 1) { whereClause.append(")"); }

                    //only append OR if there are more items to add
                    if( (i + 1) != (paramValues.length)) {
                        whereClause.append(" OR ");
                    }
                    //    					else {
                    //    					whereClause.append(")");
                    //    				}	    	
                }
                //                whereClause.append(")");
                if (paramValues.length > 1) {
                    whereClause.append(')');
                }
            }
        }
        return whereClause.toString();
    }



//    public ModelAndView createReport(HttpSession session, String reportName, String format, Map parameters) {
//        ModelAndView mav = createReport(session, reportName, format);
//        putModelParameters(mav, parameters);
//        return mav;
//    }

//    public JasperReportsMultiFormatView createReport(HttpSession session, String reportName) {
//        JasperReportsMultiFormatView view = createReport(session, reportName);
        // resource bundle is apparently not needed to be passed on
        // since it is defined in each report
        // (different reports may use different module specific bundles)
//        try {
//            ResourceBundle resourceBundle = ResourceBundle.getBundle(RESOURCE_BUNDLE_BASE_NAME, locale);
//            putModelParameter(mav, "REPORT_RESOURCE_BUNDLE", resourceBundle);
//        } catch (Exception e) {
//            log.warn(e.getMessage() + " - is the report module not installed?");
//        }
//        return view;
//    }


    /**
     * This version of createReport will try to gather all information
     * from the request (like report name, format and where clause).
     * @param request
     * @return
     */
    public ModelAndView createReport(HttpServletRequest request) {
        String uri = request.getParameter(REPORT_NAME);
        String reportName;

        // get format as a parameter - if not present, search for ending in uri
        String format = request.getParameter(REPORT_FORMAT);
        if (format != null && format.length() > 0) {
            reportName = uri;
        } else {
            format = uri.substring(uri.lastIndexOf(".") + 1);
            reportName = uri.substring(0, uri.lastIndexOf("."));
        }

        String whereClause = generateSQLWhereClause(request);

        Locale curLocale = OpusMethods.getPreferredLocale(request);


        HttpSession session = request.getSession();
//        ModelAndView mav = createReport(session, reportName, whereClause, format, curLocale);
        JasperReportsMultiFormatView report = createReport(session, reportName, format);
        Map model = createReportModel(format, whereClause, curLocale);
        report.setApplicationContext(this.getApplicationContext());      // this will convert the export parameters, so has to be called after setExportParameters()

        String dataSourceString = request.getParameter(DATA_SOURCE);
        if (dataSourceString != null && dataSourceString.trim().length() > 0) {
            Object dataSource = applicationContext.getBean(dataSourceString);
            model.put("dataSource", dataSource);
        }
        
        return new ModelAndView(report, model);
    }

    public JasperReportsMultiFormatView createReport(HttpSession session, String reportName, String format) {

        // set this class as the ViewResolver 
        JasperReportsMultiFormatView report = new CollegeJasperReportsMultiFormatView(session); 

        report.setUrl("/WEB-INF/reports/jasper/" + reportName + ".jasper");

        Map parameters = null;
        parameters = report.getExporterParameters();
        if (parameters == null) {
            parameters = new HashMap();
            report.setExporterParameters(parameters);
        }
        parameters.put(JRExporterParameter.CHARACTER_ENCODING, "UTF8");
        parameters.put(JRHtmlExporterParameter.IMAGES_URI, "../report/image?image=");
        parameters.put(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN, Boolean.FALSE);

        Properties mappings = getContentDispositionMappings(format);
        report.setContentDispositionMappings(mappings);

        // MP 2012-02-08: moved setApplicationContext(), because 
        // this should be the last step before running the report
        // export parameters and sub reports urls need to be set before this step
//        report.setApplicationContext(context);      // this will convert the export parameters, so has to be called after setExportParameters()
//        return new ModelAndView(report, model);
        return report;
    }
    
    public JasperReportsMultiFormatView createReport(HttpSession session, String reportName, String downloadFileName, String format) {

        // set this class as the ViewResolver 
        JasperReportsMultiFormatView report = new CollegeJasperReportsMultiFormatView(session); 

        report.setUrl("/WEB-INF/reports/jasper/" + reportName + ".jasper");

        Map parameters = null;
        parameters = report.getExporterParameters();
        if (parameters == null) {
            parameters = new HashMap();
            report.setExporterParameters(parameters);
        }
        parameters.put(JRExporterParameter.CHARACTER_ENCODING, "UTF8");
        parameters.put(JRHtmlExporterParameter.IMAGES_URI, "../report/image?image=");
        parameters.put(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN, Boolean.FALSE);

        Properties mappings = getContentDispositionMappings(downloadFileName, format);
        report.setContentDispositionMappings(mappings);

        return report;
    }
    
    public Map<String, Object> createReportModel(String format, String whereClause, Locale locale) {

        ApplicationContext context = this.getApplicationContext();

        Map<String, Object> model = getModel();
        model.put("format", format);  // could be done with Interceptor postHandle() method

        if ("html".equals(format) || "xls".equals(format)) {
            model.put(JRParameter.IS_IGNORE_PAGINATION, Boolean.TRUE);
        }

        // set image parameter
        Resource r = context.getResource("/images/report");
        File imageDir;
        try {
            imageDir = r.getFile();
        } catch (IOException e) {
            throw new RuntimeException("Error: image directory not present", e);
        }
        model.put("image_dir", imageDir);

        model.put(WHERE_CLAUSE, whereClause);
        
        // AbstractJasperReportsView.exposeLocalizationContext would set the locale and resource bundle only if not set in the report,
        // but Opus reports shall *always* have the entire set of installed message*.properties files
        model.put(JRParameter.REPORT_LOCALE, locale);
        model.put(JRParameter.REPORT_RESOURCE_BUNDLE, new MessageSourceResourceBundle(messageSource, locale));

        return model;
    }

    
    public ModelAndView createReport(HttpSession session, String reportName,
            String whereClause, String format, Locale locale) {
        
        JasperReportsMultiFormatView report = createReport(session, reportName, format);
        Map model = createReportModel(format, whereClause, locale);
        report.setApplicationContext(this.getApplicationContext());      // this will convert the export parameters, so has to be called after setExportParameters()

        return new ModelAndView(report, model);
    }
    
    public ModelAndView createReport(HttpSession session, String reportName,
            String whereClause, String downloadFileName, String format, Locale locale) {
        
        JasperReportsMultiFormatView report = createReport(session, reportName, downloadFileName, format);
        Map model = createReportModel(format, whereClause, locale);
        report.setApplicationContext(this.getApplicationContext());      // this will convert the export parameters, so has to be called after setExportParameters()

        return new ModelAndView(report, model);
    }

    /**
     * Add the given parameters to the report model so that the report can then access the parameter
     * by the $P{..} syntax.
     * @param mav
     * @param parameters
     */
    public void putModelParameters(ModelAndView mav, Map parameters) {
        mav.getModelMap().putAll(parameters);
    }

    public void putModelParameter(ModelAndView mav, String name, Object value) {
        mav.getModelMap().put(name, value);
    }

    public Object getModelParameter(ModelAndView mav, String name) {
        return mav.getModelMap().get(name);
    }


    public String getWhereClause(ModelAndView mav) {
        return (String)mav.getModel().get(WHERE_CLAUSE); 
    }

    public void setWhereClause(ModelAndView mav, String whereClause) {
        mav.getModelMap().put(WHERE_CLAUSE, whereClause);
    }

    public void addWhereClause(ModelAndView mav, String whereClause) {
        String sql = getWhereClause(mav);
        sql += whereClause;
        setWhereClause(mav, sql);
    }



    private Map getModel() {
        Map model = new HashMap();		

        /*
         * this one can be replaced by data from any list of object
         */
        model.put("dataSource", dataSource);

        return model;
    }

    private void printParameters(Enumeration teste){
        while(teste.hasMoreElements()){
            if (log.isDebugEnabled()) {
                log.debug("\n\n #############  \n" + teste.nextElement());
                log.debug("\n\n #############  \n");
            }
        }		 	 
    }

    public void setDataSource(
            final DataSource dataSource) {
        this.dataSource = dataSource;
    }
    /**
     * Utility method to set the reportFormat attribute in the request.
     * If the reportFormat has been passed as a request parameter,
     * the same value will be set as attribute.
     * Otherwise, the default reportFormat value will be set.
     * @param request
     */
    public static String getParamSetAttrReportFormat(HttpServletRequest request) {
        return ServletUtil.getParamSetAttrAsString(request, "reportFormat", ReportController.DEFAULT_REPORT_FORMAT);
    }

}
