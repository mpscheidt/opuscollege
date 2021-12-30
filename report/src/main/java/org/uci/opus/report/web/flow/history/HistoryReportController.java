package org.uci.opus.report.web.flow.history;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.jasperreports.JasperReportsMultiFormatView;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.report.web.form.HistoryReportForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping(value="/report/historyreport")
@SessionAttributes("historyReportForm")
public class HistoryReportController {
    
    @Autowired private ApplicationContext applicationContext;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ReportController reportController;
    @Autowired private SecurityChecker securityChecker;

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(
            HttpServletRequest request,
            ModelMap model) throws Exception {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("historyReportForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "report");

        HistoryReportForm historyReportForm = (HistoryReportForm) model.get("historyReportForm");
        
        if (historyReportForm == null) {
            historyReportForm = new HistoryReportForm();
            model.addAttribute("historyReportForm", historyReportForm);
        }

        Map modulesMap = applicationContext.getBeansOfType(Module.class);
        
    	// check the parent context as well for modules
		ApplicationContext parentContext = applicationContext.getParent();
		if (parentContext != null) {
			modulesMap.putAll(applicationContext.getParent().getBeansOfType(Module.class));
		}

        model.addAttribute("modulesMap", modulesMap);
        
        return "report/history/historyReport"; // point to the jsp file
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {

        // custom date editor of the date fields
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method = RequestMethod.POST)
    public ModelAndView processSubmit(
            HttpServletRequest request,
            @ModelAttribute("historyReportForm") HistoryReportForm form,
            ModelMap modelMap) throws Exception {

        HttpSession session = request.getSession(false);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        String tableName = form.getTableName();
        boolean anyOperation = form.isInsert() || form.isUpdate() || form.isDelete();

        if (tableName == null || tableName.isEmpty() || !anyOperation) {
            // do nothing in case of empty tablename or no operation selected
            return new ModelAndView("report/history/historyReport", modelMap); // point to the jsp file
        }

        StringBuilder whereClause = new StringBuilder();
        if (form.getStartDate() != null) {
            whereClause.append(" AND writewhen >= '").append(new java.sql.Date(form.getStartDate().getTime())).append("'");
        }
        if (form.getEndDate() != null) {
            whereClause.append(" AND writewhen <= '");
            whereClause.append(new java.sql.Date(form.getEndDate().getTime()));
            whereClause.append(" 23:59:59'");
        }
        

        Set<String> operations = new HashSet<String>(3);
        if (form.isInsert()) operations.add("'I'");
        if (form.isUpdate()) operations.add("'U'");
        if (form.isDelete()) operations.add("'D'");
        
        whereClause.append(" AND operation IN (");
        whereClause.append(StringUtil.commaSeparatedList(operations));
        
        whereClause.append(")");

        if (form.getWriteWho() != null && !form.getWriteWho().trim().isEmpty()) {
            whereClause.append(" AND writeWho like '%");
            whereClause.append(form.getWriteWho());
            whereClause.append("%'");
        }

        Locale locale = OpusMethods.getPreferredLocale(request);
//        ModelAndView mav = reportController.createReport(session, "HistoryReport",
//                whereClause.toString(),
//                "pdf", locale);
        String format = "pdf";
        String downloadFileName = ServletUtil.getParamSetAttrAsString(request, "downloadFileName"
				, messageSource.getMessage("jsp.historyreport.table." + tableName, null, locale));
   
        //spaces cause the name to be incomplete
        downloadFileName = downloadFileName.replaceAll("\\s+", "_");
   
        JasperReportsMultiFormatView report = reportController.createReport(session, "HistoryReport", downloadFileName, format);
        Map<String, Object> model = reportController.createReportModel(format, whereClause.toString(), locale);

        model.put("preferredLanguage", preferredLanguage);
        model.put("tableName", tableName);
//        reportController.putModelParameter(mav, "SUBREPORT_DIR", "/WEB-INF/reports/jasper/");

        String subReportUrl = "/WEB-INF/reports/jasper/HistoryReport_" + tableName + ".jasper";
        Properties subReportUrls = new Properties();
        subReportUrls.put("subReport", subReportUrl);
        report.setSubReportUrls(subReportUrls);

        ServletContext context = session.getServletContext();
        WebApplicationContext webContext = WebApplicationContextUtils.getWebApplicationContext(context);
        report.setApplicationContext(webContext);      // this will convert the export parameters, so has to be called after setExportParameters()
        ModelAndView mav = new ModelAndView(report, model);

        
        return mav;
    }
    
}
