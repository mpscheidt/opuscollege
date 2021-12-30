package org.uci.opus.ucm.web.service.campusonline;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.util.StringUtil;

public class ResultDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    // subject/examination/test fields
    private int subjectid;
    private String code;
    private String description;
    private BigDecimal creditAmount;
    
    // subject/studygradetype relation
    private int timeUnit;

    // result fields
    private String mark;
    private Boolean passed;
    private String comment;
    private String staffMemberName;

    private List<ResultDTO> subResults = new ArrayList<>();

    public ResultDTO() {
    }

    public ResultDTO(ISubjectExamTest subExTest, IResult result, String staffMemberName) {
        this.code = subExTest.getCode();
        this.description = subExTest.getDescription();
        this.mark = result.getMark();
        this.passed = StringUtil.toBoolean(result.getPassed());
        this.staffMemberName = staffMemberName;
        this.subjectid=subExTest.getId();
    }

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<ResultDTO> getSubResults() {
        return subResults;
    }

    public void setSubResults(List<ResultDTO> subResults) {
        this.subResults = subResults;
    }

    public boolean addSubResult(ResultDTO subResult) {
        return subResults.add(subResult);
    }

    public boolean isPassed() {
        return passed;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public BigDecimal getCreditAmount() {
        return creditAmount;
    }

    public void setCreditAmount(BigDecimal creditAmount) {
        this.creditAmount = creditAmount;
    }

    public String getStaffMemberName() {
        return staffMemberName;
    }

    public void setStaffMemberName(String staffMemberName) {
        this.staffMemberName = staffMemberName;
    }

    public int getTimeUnit() {
        return timeUnit;
    }

    public void setTimeUnit(int timeUnit) {
        this.timeUnit = timeUnit;
    }

	public int getSubjectid() {
		return subjectid;
	}

	public void setSubjectid(int subjectid) {
		this.subjectid = subjectid;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}
    
    
}
