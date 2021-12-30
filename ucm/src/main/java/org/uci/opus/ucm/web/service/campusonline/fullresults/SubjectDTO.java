package org.uci.opus.ucm.web.service.campusonline.fullresults;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.uci.opus.college.domain.Subject;

public class SubjectDTO {

    private int subjectid;
	private String code;
    private String description;
    private BigDecimal creditAmount;
    
    private List<FullResultDTO> results = new ArrayList<>();

    public SubjectDTO(Subject subExTest) {
        this.code = subExTest.getCode();
        this.description = subExTest.getDescription();
        this.creditAmount = subExTest.getCreditAmount();
        this.subjectid=subExTest.getId();
    }
    
    public int getSubjectid() {
		return subjectid;
	}

	public void setSubjectid(int subjectid) {
		this.subjectid = subjectid;
	}

	public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public List<FullResultDTO> getResults() {
        return results;
    }

    public void setResults(List<FullResultDTO> results) {
        this.results = results;
    }

    public void addResult(FullResultDTO result) {
        this.results.add(result);
    }
    
}
