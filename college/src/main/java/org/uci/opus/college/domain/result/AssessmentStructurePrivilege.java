package org.uci.opus.college.domain.result;

import java.util.HashMap;
import java.util.Map;

public class AssessmentStructurePrivilege {

    private boolean subjectAccess;
    private Map<Integer, Boolean> examinationAccess = new HashMap<>();
    private Map<Integer, Boolean> testAccess = new HashMap<>();

    public boolean isSubjectAccess() {
        return subjectAccess;
    }

    public void setSubjectAccess(boolean subjectAccess) {
        this.subjectAccess = subjectAccess;
    }

    public Map<Integer, Boolean> getExaminationAccess() {
        return examinationAccess;
    }

    public void putExaminationAccess(Integer examinationId, boolean access) {
        this.examinationAccess.put(examinationId, access);
    }
    
    public boolean isExaminationAccess(int examinationId) {
        Boolean access = getExaminationAccess().get(examinationId);
        return access != null ? access : false;
    }

    public Map<Integer, Boolean> getTestAccess() {
        return testAccess;
    }

    public void putTestAccess(Integer testId, boolean access) {
        this.testAccess.put(testId, access);
    }

    public boolean isTestAccess(int testId) {
        Boolean access = getTestAccess().get(testId);
        return access != null ? access : false;
    }

}
