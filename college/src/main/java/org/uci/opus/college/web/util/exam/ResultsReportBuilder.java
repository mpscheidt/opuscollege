package org.uci.opus.college.web.util.exam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.web.user.OpusSecurityException;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.report.config.ReportConstants;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;

@Service
public class ResultsReportBuilder {

    @Autowired
    private AppConfigManagerInterface appConfigManager;
    
    @Autowired
    private OpusInit opusInit;

    @Autowired
    private ReportController reportController;

    public ModelAndView subjectResults(HttpServletRequest request, AssessmentStructurePrivilege assessmentStructurePrivilege, int subjectId, Integer classgroupId, String format) {
        
        if (!assessmentStructurePrivilege.isSubjectAccess()) {
            throw new OpusSecurityException("Unauthorized");
        }

        String reportName = appConfigManager.getSubjectResultsReport();
        if (StringUtils.isBlank(reportName)) {
            throw new RuntimeException("Received a pdfSubjectResults request, but such a report has not been declared.");
        }

        HttpSession session = request.getSession(false);
        ModelAndView mav = reportController.createReport(session, reportName,
                whereClause("AND subject.id = " + subjectId, classgroupId),
                "SubjectResults_" + subjectId, format, OpusMethods.getPreferredLocale(request));

        return mav;
    }

    public ModelAndView examinationResults(HttpServletRequest request, AssessmentStructurePrivilege assessmentStructurePrivilege, int examinationId, Integer classgroupId, String format) {

        if (!assessmentStructurePrivilege.isExaminationAccess(examinationId)) {
            throw new OpusSecurityException("Unauthorized");
        }

        String reportName = appConfigManager.getExaminationResultsReport();
        if (StringUtils.isBlank(reportName)) {
            throw new RuntimeException("Received a pdfExaminationResults request, but such a report has not been declared.");
        }

        HttpSession session = request.getSession(false);
        ModelAndView mav = reportController.createReport(session, reportName,
                whereClause("AND examination.id = " + examinationId, classgroupId),
                "ExaminationResults_" + examinationId,  format, OpusMethods.getPreferredLocale(request));

        applyModelParameters(mav);

        return mav;
    }

    public ModelAndView testResults(HttpServletRequest request, AssessmentStructurePrivilege assessmentStructurePrivilege, int testId, Integer classgroupId, String format) {
        
        if (!assessmentStructurePrivilege.isTestAccess(testId)) {
            throw new OpusSecurityException("Unauthorized");
        }

        String reportName = appConfigManager.getTestResultsReport();
        if (StringUtils.isBlank(reportName)) {
            throw new RuntimeException("Received a pdfTestResults request, but such a report has not been declared.");
        }

        HttpSession session = request.getSession(false);
        ModelAndView mav = reportController.createReport(session, reportName,
                whereClause("AND test.id = " + testId, classgroupId),
                "TestResults_" + testId,  format, OpusMethods.getPreferredLocale(request));

        applyModelParameters(mav);

        return mav;
    }
    
    private String whereClause(String baseWhereClause, Integer classgroupId) {
        String wc = baseWhereClause;
        if (classgroupId != null) {
            wc += " AND classgroupId = " + classgroupId;
        }
        return wc;
    }

    private void applyModelParameters(ModelAndView mav) {
        reportController.putModelParameter(mav, "orderClause", ", " + opusInit.getPreferredPersonSorting());
        reportController.putModelParameter(mav, "nameFormat", ReportConstants.NAME_FORMAT_DEFAULT);
    }

}
