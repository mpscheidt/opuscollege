package org.uci.opus.ucm.web.service.campusonline;

import java.util.Collection;

public class LatestTimeUnitDTO {

    private String studyDescription;
    private String gradeTypeDescription;
    private Integer timeUnitNumber;
    private String progressStatus;
    private Collection<ResultDTO> results;

    public Integer getTimeUnitNumber() {
        return timeUnitNumber;
    }

    public void setTimeUnitNumber(Integer timeUnitNumber) {
        this.timeUnitNumber = timeUnitNumber;
    }

    public String getProgressStatus() {
        return progressStatus;
    }

    public void setProgressStatus(String progressStatus) {
        this.progressStatus = progressStatus;
    }

    public String getStudyDescription() {
        return studyDescription;
    }

    public void setStudyDescription(String studyDescription) {
        this.studyDescription = studyDescription;
    }

    public String getGradeTypeDescription() {
        return gradeTypeDescription;
    }

    public void setGradeTypeDescription(String gradeTypeDescription) {
        this.gradeTypeDescription = gradeTypeDescription;
    }

    public Collection<ResultDTO> getResults() {
        return results;
    }

    public void setResults(Collection<ResultDTO> results) {
        this.results = results;
    }

}
