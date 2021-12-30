package org.uci.opus.ucm.web.service.campusonline;

import java.util.Collection;

public class CampusOnlineResult {

    private String surname, firstnames, studentStatus;
    private Collection<LatestTimeUnitDTO> latestTimeUnits;

    public CampusOnlineResult() {
    }

    public CampusOnlineResult(String surname, String firstnames, String studentStatus, Collection<LatestTimeUnitDTO> latestTimeUnits) {
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

    public Collection<LatestTimeUnitDTO> getLatestTimeUnits() {
        return latestTimeUnits;
    }

    public void setLatestTimeUnits(Collection<LatestTimeUnitDTO> latestTimeUnits) {
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
