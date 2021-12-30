package org.uci.opus.ucm.domain;

import java.math.BigDecimal;

import org.uci.opus.college.domain.result.SubjectResult;

public class StudentResult extends SubjectResult {

    private static final long serialVersionUID = 1L;

    private String studentCode;
    private String studentName;
    private BigDecimal result;

    public StudentResult() {
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public BigDecimal getResult() {
        return result;
    }

    public void setResult(BigDecimal result) {
        this.result = result;
    }

}
