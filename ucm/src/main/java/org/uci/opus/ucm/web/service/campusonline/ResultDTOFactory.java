package org.uci.opus.ucm.web.service.campusonline;

import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.SubjectResultComment;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.persistence.SubjectResultCommentMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.config.OpusConstants;

@Service
public class ResultDTOFactory {

    @Autowired
    private ExaminationManagerInterface examinationManager;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private SubjectResultCommentMapper subjectResultCommentMapper;

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private TestManagerInterface testManager;

    public ResultDTO fromSubjectResult(SubjectResult subjectResult, String language) {

    	Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());

    	ResultDTO subjectResultDTO = new ResultDTO(subject, subjectResult, getStaffMemberName(subjectResult));
        subjectResultDTO.setCreditAmount(subject.getCreditAmount());
        subjectResultDTO.setTimeUnit(getCardinalTimeUnitNumber(subjectResult.getStudyPlanDetailId()));

        subjectResultDTO.setComment(getSubjectResultComment(subjectResult.getSubjectResultCommentId(), language));

        return subjectResultDTO;
    }
    
    private String getSubjectResultComment(Integer subjectResultCommentId, String language) {

    	if (subjectResultCommentId != null) {
        	SubjectResultComment src = subjectResultCommentMapper.findOne(subjectResultCommentId);
        	return messageSource.getMessage(src.getCommentKey(), null, new Locale(language));
        }
        return null;
    }

    private String getStaffMemberName(IResult result) {
        StaffMember staffMember = staffMemberManager.findStaffMember(OpusConstants.LANGUAGE_EN, result.getStaffMemberId());
        return staffMember.getFirstnamesFull() + " " + staffMember.getSurnameFull();
    }

    private int getCardinalTimeUnitNumber(int studyPlanDetailId) {
        StudyPlanCardinalTimeUnit spctu = studentManager.findStudyPlanCtuForStudyPlanDetail(studyPlanDetailId);
        return spctu.getCardinalTimeUnitNumber();
    }

    public ResultDTO fromExaminationResult(ExaminationResult examinationResult) {
        Examination examination = examinationManager.findExamination(examinationResult.getExaminationId());
        ResultDTO subjectResultDTO = new ResultDTO(examination, examinationResult, getStaffMemberName(examinationResult));
        return subjectResultDTO;
    }

    public ResultDTO fromTestResult(TestResult testResult) {
        Test test = testManager.findTest(testResult.getTestId());
        ResultDTO subjectResultDTO = new ResultDTO(test, testResult, getStaffMemberName(testResult));
        return subjectResultDTO;
    }

}
