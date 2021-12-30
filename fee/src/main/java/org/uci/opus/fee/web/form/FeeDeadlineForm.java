package org.uci.opus.fee.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.FeeDeadline;

public class FeeDeadlineForm {
    
    private NavigationSettings navigationSettings;
    private FeeDeadline feeDeadline;
    private Branch branch;
    private AcademicYear academicYear;
    private Fee fee;
    private StudyGradeType studyGradeType;
    private Study study;
    private Subject subject;
    private SubjectBlock subjectBlock;
    private Lookup8 cardinalTimeUnit;
    private List< Lookup8 > cardinalTimeUnits;
    
    private String from;
    
    
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	
	public void setNavigationSettings(NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	public FeeDeadline getFeeDeadline() {
		return feeDeadline;
	}

	public void setFeeDeadline(FeeDeadline feeDeadline) {
		this.feeDeadline = feeDeadline;
	}

	public FeeDeadline createNewFeeDeadline(int feeId, String writeWho) {
		
		FeeDeadline deadline = new FeeDeadline();
		
		deadline.setActive("Y");
		deadline.setWriteWho(writeWho);
		deadline.setFeeId(feeId);
		
		return deadline;
	}

	public Branch getBranch() {
		return branch;
	}

	public void setBranch(Branch branch) {
		this.branch = branch;
	}

	public AcademicYear getAcademicYear() {
		return academicYear;
	}

	public void setAcademicYear(AcademicYear academicYear) {
		this.academicYear = academicYear;
	}

	public Fee getFee() {
		return fee;
	}

	public void setFee(Fee fee) {
		this.fee = fee;
	}

	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}

	public void setStudyGradeType(StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	public Study getStudy() {
		return study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	public SubjectBlock getSubjectBlock() {
		return subjectBlock;
	}

	public void setSubjectBlock(SubjectBlock subjectBlock) {
		this.subjectBlock = subjectBlock;
	}

	public Lookup8 getCardinalTimeUnit() {
		return cardinalTimeUnit;
	}

	public void setCardinalTimeUnit(Lookup8 cardinalTimeUnit) {
		this.cardinalTimeUnit = cardinalTimeUnit;
	}

	public List<Lookup8> getCardinalTimeUnits() {
		return cardinalTimeUnits;
	}

	public void setCardinalTimeUnits(List<Lookup8> cardinalTimeUnits) {
		this.cardinalTimeUnits = cardinalTimeUnits;
	}
	
}
