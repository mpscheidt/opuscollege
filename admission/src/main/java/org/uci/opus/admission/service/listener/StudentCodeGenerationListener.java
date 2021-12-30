package org.uci.opus.admission.service.listener;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.extpoint.IStudyPlanListener;
import org.uci.opus.config.OpusConstants;

@Service
public class StudentCodeGenerationListener implements IStudyPlanListener {
    
    /**
     * Create a new student number when the status of a student is set to
     * {@link OpusConstants#STUDYPLAN_STATUS_APPROVED_ADMISSION}.
     */
    public static final String KEY_ADMISSION = "admission";

    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudentNumberGeneratorInterface studentNumberGenerator;
    @Autowired private StudyMapper studyDao;

    /**
     * Same behaviour as #beforeStudyPlanUpdate(StudyPlan, HttpServletRequest)
     */
    @Override
    public void studyPlanAdded(StudyPlan studyPlan, String writeWho) {
        createStudentCode(studyPlan, writeWho);
    }

    /**
     * Noop.
     */
    @Override
    public void beforeStudyPlanDelete(int studyPlanId, String writeWho) {
    }

    /**
     * @see #beforeStudyPlanStatusUpdate(StudyPlan, HttpServletRequest).
     */
    @Override
    public void beforeStudyPlanUpdate(StudyPlan studyPlan, String writeWho) {
        beforeStudyPlanStatusUpdate(studyPlan, writeWho);
    }

    /**
     * If the study plan status was set to {@link OpusConstants#STUDYPLAN_STATUS_APPROVED_ADMISSION},
     * the studentNumberGenerator is applicable to admission
     * and the student has yet no student code,
     * then call the studentNumber Generator to create a new studentCode.
     * The student is updated in the database with the new studentCode.
     */
    @Override
    public void beforeStudyPlanStatusUpdate(StudyPlan studyPlan, String writeWho) {
        createStudentCode(studyPlan, writeWho);
    }

    private void createStudentCode(StudyPlan studyPlan, String writeWho) {
        if (studentNumberGenerator == null || !studentNumberGenerator.applies(KEY_ADMISSION)) {
            return;
        }

        int studentId = studyPlan.getStudentId();
        if (OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION.equals(studyPlan.getStudyPlanStatusCode())) {

            Student student = studentManager.findStudent(OpusConstants.LANGUAGE_EN, studentId);
            Study study = studyDao.findStudy(student.getPrimaryStudyId());
            String studentCode = studentNumberGenerator.createUniqueStudentCode(KEY_ADMISSION, study.getOrganizationalUnitId(), student);
            student.setStudentCode(studentCode);

            student.setWriteWho(writeWho);
            studentManager.updateStudent(student);
        }
    }

}
