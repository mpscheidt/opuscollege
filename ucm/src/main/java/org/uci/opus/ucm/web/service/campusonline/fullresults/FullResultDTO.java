package org.uci.opus.ucm.web.service.campusonline.fullresults;

import java.io.Serializable;

import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.util.StringUtil;

public class FullResultDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String code;
    private String description;

    // result fields
    private String mark;
    private Boolean passed;
    private String comment;
    private String staffMemberName;

    // subject/studygradetype relation
    private int timeUnit;
    
//    private List<ResultDTO> subResults = new ArrayList<>();

    public FullResultDTO() {
    }

    public FullResultDTO(ISubjectExamTest subextest, IResult result, String staffMemberName) {
        this.code = subextest.getCode();
        this.description = subextest.getDescription();
        this.mark = result.getMark();
        this.passed = StringUtil.toBoolean(result.getPassed());
        this.staffMemberName = staffMemberName;
    }

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

//    public List<ResultDTO> getSubResults() {
//        return subResults;
//    }
//
//    public void setSubResults(List<ResultDTO> subResults) {
//        this.subResults = subResults;
//    }
//
//    public boolean addSubResult(ResultDTO subResult) {
//        return subResults.add(subResult);
//    }

    public boolean isPassed() {
        return passed;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

}
