package org.uci.opus.college.web.flow;

import org.springframework.web.multipart.MultipartFile;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.web.form.NavigationSettings;

public class ReportPropertyForm {

    private NavigationSettings navigationSettings;
    
    private ReportProperty reportProperty;
    
    private String reportPath;
    private MultipartFile multipartFile;

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public ReportProperty getReportProperty() {
        return reportProperty;
    }

    public void setReportProperty(ReportProperty reportProperty) {
        this.reportProperty = reportProperty;
    }

    public String getReportPath() {
        return reportPath;
    }

    public void setReportPath(String reportPath) {
        this.reportPath = reportPath;
    }

    public MultipartFile getMultipartFile() {
        return multipartFile;
    }

    public void setMultipartFile(MultipartFile multipartFile) {
        this.multipartFile = multipartFile;
    }

}
