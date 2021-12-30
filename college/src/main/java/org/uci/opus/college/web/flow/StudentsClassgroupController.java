package org.uci.opus.college.web.flow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.StudentsClassgroupForm;

@Controller
@RequestMapping(value = "/college/studentsclassgroup")
@SessionAttributes(StudentsClassgroupController.FORM)
public class StudentsClassgroupController {
    
    public static final String FORM = "studentsclassgroupform";
    private static final String VIEW_NAME = "/college/person/studentsclassgroup";
    
    @Autowired
    private OrganizationalUnitManagerInterface orgUnitManager;
    
    @Autowired
    private StudyManagerInterface studyManager;

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(ModelMap model) {
        
        StudentsClassgroupForm form = (StudentsClassgroupForm)
                model.get(FORM);
        
        if (form == null) {
            form = new StudentsClassgroupForm();
            model.put(FORM, form);
            
            // put organizationalunits into form object
            List<OrganizationalUnit> orgUnits = 
                    orgUnitManager.findOrganizationalUnits(new HashMap<String, Object>());
            form.setOrgUnits(orgUnits);
        }
        
        return VIEW_NAME;
    }
    
    @RequestMapping(params = "orgUnitId")
    public String processOrgUnitId(@ModelAttribute StudentsClassgroupForm studentsClassgroupForm) {
        
        // put study programs into form object
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitId", studentsClassgroupForm.getOrgUnitId());
        List<Study> studies = studyManager.findStudies(map);

        // TODO use organizationalUnitIt in filter
        List<StudyGradeType> studyGradeTypes = new ArrayList<>();
        for (Study study : studies) {
            Map<String, Object> sgtMap = new HashMap<>();
            sgtMap.put("studyId", study.getId());
            List<StudyGradeType> sgt = studyManager.findStudyGradeTypes(sgtMap);
            studyGradeTypes.addAll(sgt);
        }
        studentsClassgroupForm.setStudyGradeTypes(studyGradeTypes);
        
        return VIEW_NAME;
    }

}
