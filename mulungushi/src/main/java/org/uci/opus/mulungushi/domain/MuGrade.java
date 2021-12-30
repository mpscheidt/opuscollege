package org.uci.opus.mulungushi.domain;

public class MuGrade {

	private Integer studentNo;
	private String academicYear;
	private String semester;
	private String programNo;
	private String courseNo;
	private Double caMarks;
    private Double examMarks;
    private Double totalMarks;
	private String grade;
	private Double points;

	public Integer getStudentNo() {
		return studentNo;
	}

	public void setStudentNo(Integer studentNo) {
		this.studentNo = studentNo;
	}

	public String getAcademicYear() {
		return academicYear;
	}

	public void setAcademicYear(String academicYear) {
		this.academicYear = academicYear;
	}

	public String getSemester() {
		return semester;
	}

	public void setSemester(String semester) {
		this.semester = semester;
	}

	public String getProgramNo() {
		return programNo;
	}

	public void setProgramNo(String programNo) {
		this.programNo = programNo;
	}

	public String getCourseNo() {
		return courseNo;
	}

	public void setCourseNo(String courseNo) {
		this.courseNo = courseNo;
	}

	public Double getTotalMarks() {
		return totalMarks;
	}

	public void setTotalMarks(Double totalMarks) {
		this.totalMarks = totalMarks;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public Double getPoints() {
		return points;
	}

	public void setPoints(Double points) {
		this.points = points;
	}

	@Override
	public String toString() {
		return "MuGrade [studentNo=" + studentNo + ", academicYear="
				+ academicYear + ", semester=" + semester + ", programNo="
				+ programNo + ", courseNo=" + courseNo + ", caMarks=" + caMarks + ", examMarks=" + examMarks
				+ ", totalMarks=" + totalMarks + ", grade=" + grade + ", points=" + points + "]";
	}

    public Double getCaMarks() {
        return caMarks;
    }

    public void setCaMarks(Double caMarks) {
        this.caMarks = caMarks;
    }

    public Double getExamMarks() {
        return examMarks;
    }

    public void setExamMarks(Double examMarks) {
        this.examMarks = examMarks;
    }

	
}
