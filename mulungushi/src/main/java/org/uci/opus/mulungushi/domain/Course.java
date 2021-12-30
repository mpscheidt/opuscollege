package org.uci.opus.mulungushi.domain;

import java.util.ArrayList;
import java.util.List;

public class Course {

	private String courseNo;
	private String courseName;
	private String school;
	
	private List<ProgCourse> progCourses = new ArrayList<>();

	public String getCourseNo() {
		return courseNo;
	}

	public void setCourseNo(String courseNo) {
		this.courseNo = courseNo;
	}

	public String getCourseName() {
		return courseName;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	public String getSchool() {
		return school;
	}

	@Override
    public String toString() {
        return "Course [courseNo=" + courseNo + ", courseName=" + courseName + ", school=" + school + ", progCourses=" + progCourses + "]";
    }

    public void setSchool(String school) {
		this.school = school;
	}

    public List<ProgCourse> getProgCourses() {
        return progCourses;
    }

    public void setProgCourses(List<ProgCourse> progCourses) {
        this.progCourses = progCourses;
    }

}
