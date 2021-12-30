package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;

public class StudentsClassgroupForm {

    private int studyGradeTypeId;
    private List<Student> students;
    private List<Classgroup> classGroups;
    private List<OrganizationalUnit> orgUnits;
    private int orgUnitId;
    private List<StudyGradeType> studyGradeTypes;

    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    public void setStudyGradeTypeId(int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }

    public List<Student> getStudents() {
        return students;
    }

    public void setStudents(List<Student> students) {
        this.students = students;
    }

    public List<Classgroup> getClassGroups() {
        return classGroups;
    }

    public void setClassGroups(List<Classgroup> classGroups) {
        this.classGroups = classGroups;
    }

    public List<OrganizationalUnit> getOrgUnits() {
        return orgUnits;
    }

    public void setOrgUnits(List<OrganizationalUnit> orgUnits) {
        this.orgUnits = orgUnits;
    }

    public int getOrgUnitId() {
        return orgUnitId;
    }

    public void setOrgUnitId(int orgUnitId) {
        this.orgUnitId = orgUnitId;
    }

    public List<StudyGradeType> getStudyGradeTypes() {
        return studyGradeTypes;
    }

    public void setStudyGradeTypes(List<StudyGradeType> studyGradeTypes) {
        this.studyGradeTypes = studyGradeTypes;
    }

}
