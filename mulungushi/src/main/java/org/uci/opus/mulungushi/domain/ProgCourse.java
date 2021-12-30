package org.uci.opus.mulungushi.domain;

public class ProgCourse {

    private String programNo;
    @Override
    public String toString() {
        return "ProgCourse [programNo=" + programNo + ", courseNo=" + courseNo + ", elective=" + elective + "]";
    }

    private String courseNo;
    private boolean elective;

    public String getProgramNo() {
        return programNo;
    }

    public void setProgramNo(String programNo) {
        this.programNo = programNo;
    }

    public boolean isElective() {
        return elective;
    }

    public void setElective(boolean elective) {
        this.elective = elective;
    }

    public String getCourseNo() {
        return courseNo;
    }

    public void setCourseNo(String courseNo) {
        this.courseNo = courseNo;
    }

}
