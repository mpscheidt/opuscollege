package org.uci.opus.scholarship.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.StudyPlanCardinalTimeUnit4Display;

public class ScholarshipApplicationForm {

    private Organization organization;
    private NavigationSettings navigationSettings;
    private ScholarshipApplication scholarshipApplication;
    private Student student;
    private ScholarshipStudent scholarshipStudent;
    private StudyGradeType studyGradeType;  // for the selected studyPlan
    
    private List<AcademicYear> allAcademicYears;
    private List<Lookup> allScholarshipTypes;
    private List<Lookup> allComplaintStatuses;
    private List<Scholarship> allScholarships;
    private List<StudyPlanCardinalTimeUnit4Display> allStudyPlanCardinalTimeUnits4Display;


    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public ScholarshipApplication getScholarshipApplication() {
        return scholarshipApplication;
    }

    public void setScholarshipApplication(ScholarshipApplication scholarshipApplication) {
        this.scholarshipApplication = scholarshipApplication;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public ScholarshipStudent getScholarshipStudent() {
        return scholarshipStudent;
    }

    public void setScholarshipStudent(ScholarshipStudent scholarshipStudent) {
        this.scholarshipStudent = scholarshipStudent;
    }

    public List<Lookup> getAllScholarshipTypes() {
        return allScholarshipTypes;
    }

    public void setAllScholarshipTypes(List<Lookup> allScholarshipTypes) {
        this.allScholarshipTypes = allScholarshipTypes;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List<Lookup> getAllComplaintStatuses() {
        return allComplaintStatuses;
    }

    public void setAllComplaintStatuses(List<Lookup> allComplaintStatuses) {
        this.allComplaintStatuses = allComplaintStatuses;
    }

    public List<Scholarship> getAllScholarships() {
        return allScholarships;
    }

    public void setAllScholarships(List<Scholarship> allScholarships) {
        this.allScholarships = allScholarships;
    }

    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }

    public void setStudyGradeType(StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }

    public List<StudyPlanCardinalTimeUnit4Display> getAllStudyPlanCardinalTimeUnits4Display() {
        return allStudyPlanCardinalTimeUnits4Display;
    }

    public void setAllStudyPlanCardinalTimeUnits4Display(List<StudyPlanCardinalTimeUnit4Display> allStudyPlanCardinalTimeUnits4Display) {
        this.allStudyPlanCardinalTimeUnits4Display = allStudyPlanCardinalTimeUnits4Display;
    }

}
