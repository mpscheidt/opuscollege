package org.uci.opus.college.domain.util;

/**
 * Data passed on between methods (in SubjectManager) that work with failed subjects.
 * 
 * @author markus
 *
 */
public class FailedSubjectInfo {

    private int subjectId;
    private String subjectCode;
    private int cardinalTimeUnitNumber;

    public FailedSubjectInfo() {
    }
    
    public FailedSubjectInfo(int subjectId, String subjectCode, int cardinalTimeUnitNumber) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }
    
    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }

    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

}
