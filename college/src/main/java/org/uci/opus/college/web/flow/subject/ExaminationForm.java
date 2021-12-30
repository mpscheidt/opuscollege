package org.uci.opus.college.web.flow.subject;

import java.util.List;

import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;

public class ExaminationForm {

    private NavigationSettings navigationSettings;

    private Examination examination;
    private Subject subject;
    private Study study;
    private boolean endGradesPerGradeType;
    private int percentageTotal;

    private List<Classgroup> allClassgroups;

    private List<Lookup10> allExaminationTypes;
    private CodeToLookupMap allExaminationTypesMap;

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public List<Lookup10> getAllExaminationTypes() {
        return allExaminationTypes;
    }

    public void setAllExaminationTypes(List<Lookup10> allExaminationTypes) {
        this.allExaminationTypes = allExaminationTypes;
    }

    public CodeToLookupMap getAllExaminationTypesMap() {
        return allExaminationTypesMap;
    }

    public void setAllExaminationTypesMap(CodeToLookupMap allExaminationTypesMap) {
        this.allExaminationTypesMap = allExaminationTypesMap;
    }

    public List<Classgroup> getAllClassgroups() {
        return allClassgroups;
    }

    public void setAllClassgroups(List<Classgroup> allClassgroups) {
        this.allClassgroups = allClassgroups;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    public Study getStudy() {
        return study;
    }

    public void setStudy(Study study) {
        this.study = study;
    }

    public boolean isEndGradesPerGradeType() {
        return endGradesPerGradeType;
    }

    public void setEndGradesPerGradeType(boolean endGradesPerGradeType) {
        this.endGradesPerGradeType = endGradesPerGradeType;
    }

    public int getPercentageTotal() {
        return percentageTotal;
    }

    public void setPercentageTotal(int percentageTotal) {
        this.percentageTotal = percentageTotal;
    }

}
