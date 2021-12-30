package org.uci.opus.college.domain;

import java.io.Serializable;
import java.util.Date;

import org.uci.opus.college.util.TimeUnit;

public class BranchAcademicYearTimeUnit implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int branchId;
    private int academicYearId;
    private String cardinalTimeUnitCode;
    private int cardinalTimeUnitNumber;
    private Date resultsPublishDate;
    private String active = "Y";

    public BranchAcademicYearTimeUnit() {
        super();
    }

    public BranchAcademicYearTimeUnit(int branchId, String cardinalTimeUnitCode, int cardinalTimeUnitNumber, Date resultsPublishDate) {
        this();
        this.branchId = branchId;
        this.cardinalTimeUnitCode = cardinalTimeUnitCode;
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
        this.resultsPublishDate = resultsPublishDate;
    }

    /**
     * Utility method to obtain a code that represents a TimeUnit object
     * @return
     */
    public String getTimeUnitCode() {
        return TimeUnit.makeCode(cardinalTimeUnitCode, cardinalTimeUnitNumber);
    }

    public int getBranchId() {
        return branchId;
    }

    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public String getCardinalTimeUnitCode() {
        return cardinalTimeUnitCode;
    }

    public void setCardinalTimeUnitCode(String cardinalTimeUnitCode) {
        this.cardinalTimeUnitCode = cardinalTimeUnitCode;
    }

    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }

    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

    public Date getResultsPublishDate() {
        return resultsPublishDate;
    }

    public void setResultsPublishDate(Date resultsPublishDate) {
        this.resultsPublishDate = resultsPublishDate;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

}
