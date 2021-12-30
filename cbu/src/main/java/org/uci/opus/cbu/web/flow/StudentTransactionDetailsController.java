package org.uci.opus.cbu.web.flow;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.jasperreports.JasperReportsMultiFormatView;
import org.uci.opus.cbu.persistence.CbuMapper;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.util.OpusMethods;

@Controller
@RequestMapping("/college/studentTransactionDetails.view")
public class StudentTransactionDetailsController {
    
    @Autowired private ApplicationContext applicationContext;
    @Autowired private ReportController reportController;
    @Autowired private CbuMapper cbuDao;

    @RequestMapping(method=RequestMethod.GET)
    public ModelAndView setUpForm(HttpServletRequest request) {

        String reportName = "StudentTransactionDetails";
        String format = "pdf";
        String studentCode = request.getParameter("studentCode");
        String whereClause = " AND \"CUCODE\" = '" + studentCode + "'";
        Locale curLocale = OpusMethods.getPreferredLocale(request);

        HttpSession session = request.getSession();
        JasperReportsMultiFormatView report = reportController.createReport(session, reportName, format);
        Map<String, Object> model = reportController.createReportModel(format, whereClause, curLocale);
        report.setApplicationContext(applicationContext);      // this will convert the export parameters, so has to be called after setExportParameters()

        Object dataSource = applicationContext.getBean("dimensionsDataSource");
        model.put("dataSource", dataSource);

        List<Map<String, Object>> detailsList = cbuDao.findStudentTransactionDetailsData(studentCode);
        if (detailsList != null && !detailsList.isEmpty()) {
            Map<String, Object> details = detailsList.get(0);
            model.put("studyProgramme", details.get("studyDescription") + "/" + details.get("gradeTypeDescription"));
            model.put("yearOfStudy", ((Integer)details.get("cardinalTimeUnitNumber") / (Integer)details.get("nrOfUnitsPerYear")) + 1);
            model.put("school", details.get("branchDescription"));
        }

        return new ModelAndView(report, model);
    }

}
