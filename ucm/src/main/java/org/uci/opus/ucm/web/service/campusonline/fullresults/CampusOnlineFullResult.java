package org.uci.opus.ucm.web.service.campusonline.fullresults;

import java.util.Collection;

public class CampusOnlineFullResult {

    private String surname, firstnames, studentStatus;
    private Collection<LatestTimeUniFullResultDTO> latestTimeUnits;

    public CampusOnlineFullResult() {
    }

    public CampusOnlineFullResult(String surname, String firstnames, String studentStatus, Collection<LatestTimeUniFullResultDTO> latestTimeUnits) {
        this.surname = surname;
        this.firstnames = firstnames;
        this.studentStatus = studentStatus;
        this.latestTimeUnits = latestTimeUnits;
    }

    public String getStudentStatus() {
        return studentStatus;
    }

    public void setStudentStatus(String studentStatus) {
        this.studentStatus = studentStatus;
    }

    public Collection<LatestTimeUniFullResultDTO> getLatestTimeUnits() {
        return latestTimeUnits;
    }

    public void setLatestTimeUnits(Collection<LatestTimeUniFullResultDTO> latestTimeUnits) {
        this.latestTimeUnits = latestTimeUnits;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getFirstnames() {
        return firstnames;
    }

    public void setFirstnames(String firstnames) {
        this.firstnames = firstnames;
    }

}
