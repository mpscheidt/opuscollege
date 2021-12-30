package org.uci.opus.ucm.web.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.lookup.LookupUtil;

@Controller
public class DadosCertificado {

    private static final String LANGUAGE = "pt";

    private SimpleDateFormat dateFormat;

    @Autowired
    private JsonResponseFactory jsonResponseFactory;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    /**
     * (Birth) dates are expected in the ISO format: yyyy-MM-dd
     * @param binder
     */
    @InitBinder
    private void dateBinder(WebDataBinder binder) {
        dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        CustomDateEditor editor = new CustomDateEditor(dateFormat, true);
        binder.registerCustomEditor(Date.class, editor);
    }

    @RequestMapping(value = "/dadosCertificado/{studentCode}/{birthDate}/{hash}", produces = "application/json; charset=utf-8", method = RequestMethod.GET)
    @ResponseBody
    public JsonResponse getResultsByStudentCode(@PathVariable String studentCode, @PathVariable Date birthDate, @PathVariable String hash) {
        
        String birthDateString = dateFormat.format(birthDate);

        // Verify hash
        JsonResponse jsonResponse = jsonResponseFactory.fromMD5Hash(studentCode + birthDateString, hash);
        if (!jsonResponse.isSuccessful()) {
            return jsonResponse;
        }

        // Verify studentCode
        Student student = studentManager.findStudentByCode(studentCode);
        if (student == null || !datesMatch(birthDate, student.getBirthdate())) {
            jsonResponse = jsonResponseFactory.fromInvalidStudentCodeOrBirthDate();
        }
        if (!jsonResponse.isSuccessful()) {
            return jsonResponse;
        }

        jsonResponse.setResult(buildDadosCertificados(student));
        return jsonResponse;
    }

    private boolean datesMatch(Date date1, Date date2) {
        boolean match = date1.equals(date2);
        return match;
    }

    private List<DadosCertificadoDTO> buildDadosCertificados(Student student) {
        List<DadosCertificadoDTO> dados = new ArrayList<>();
        
        for (StudyPlan studyPlan : student.getStudyPlans()) {
            StudyPlanResult studyPlanResult = studyPlan.getStudyPlanResult();
            if (studyPlanResult != null && "Y".equalsIgnoreCase(studyPlanResult.getPassed())) {
                DadosCertificadoDTO data = new DadosCertificadoDTO();
                data.setSurname(student.getSurnameFull());
                data.setFirstnames(student.getFirstnamesFull());
                data.setGraduated(true);
                data.setMark(studyPlanResult.getMark());
                data.setStudy(getStudyDescription(studyPlan.getStudyId()));
                data.setDegree(getGradeTypeDescription(studyPlan.getGradeTypeCode()));
                dados.add(data);
            }
        }

        return dados;
    }
    
    private String getStudyDescription(int studyId) {
        Study study = studyManager.findStudy(studyId);
        return study != null ? study.getStudyDescription() : "Unknown study with id " + studyId;
    }
    
    private String getGradeTypeDescription(String gradeTypeCode) {
        List<Lookup9> allGradeTypes = lookupCacher.getAllGradeTypes(LANGUAGE);
        Lookup gradeType = LookupUtil.getLookupByCode(allGradeTypes, gradeTypeCode);
        return gradeType != null ? gradeType.getDescription() : "Unknown grade type with code = " + gradeTypeCode + " in language " + LANGUAGE;
    }
}
