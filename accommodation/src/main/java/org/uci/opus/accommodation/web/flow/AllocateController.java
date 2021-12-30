/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/
package org.uci.opus.accommodation.web.flow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.StudentsForm;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;


@Controller
@RequestMapping("/accommodation/allocate.view")
@SessionAttributes({"studentsForm"})
@PreAuthorize("hasAnyRole('READ_ACCOMMODATION_DATA')")
public class AllocateController {

    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private AppConfigManagerInterface appConfigManager;

    private static Logger log = LoggerFactory.getLogger(AllocateController.class);

    public AllocateController() {
        super();
        this.formView = "accommodation/students/allocate";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        StudentsForm studentsForm = new StudentsForm();

        //Organization organization = null;
        //NavigationSettings navigationSettings = null;
        HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        loadData(studentsForm, model, request);
        return formView;

    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("studentsForm") StudentsForm studentsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,ModelMap model) {

        setDefaultData(model, studentsForm,OpusMethods.getPreferredLanguage(request));

        return formView;
    }

    private void loadData(StudentsForm studentsForm,ModelMap model, HttpServletRequest request){
        HttpSession session = request.getSession(false);
        session.setAttribute("menuChoice", "accommodation");
        setDefaultData(model,studentsForm,OpusMethods.getPreferredLanguage(request));
    }

    private void setDefaultData(ModelMap model,StudentsForm studentsForm,String preferredLanguage){
        List<Institution> institutions= getInstitutions();
        List<Branch> firstLevelUnits=null;
        List<OrganizationalUnit> secondLevelUnits=null;
        List<Study> studies=null;
        List<StudyGradeType> studyGradeTypes=null;
        List<AcademicYear> academicYears=academicYearManager.findAllAcademicYears();
        int maxCardintalTimeUnit=0;
        Map<String,Object> roomParams=new HashMap<String, Object>();
        Map<String,Object> blockParams=new HashMap<String, Object>();
        List<HostelBlock> allBlocks=null;
        List<Room> allRooms=null;

        if(institutions!=null && institutions.size()>0){

            //if(studentsForm.getInstitutionId()==0) studentsForm.setInstitutionId(institutions.get(0).getId());
            firstLevelUnits=getBranches(studentsForm.getInstitutionId());
            if(studentsForm.getInstitutionId()!=0){
                //	studentsForm.setInstitutionId(institutions.get(0).getId());
                firstLevelUnits=getBranches(studentsForm.getInstitutionId());
                if(studentsForm.getFirstLevelUnitId()!=0 && firstLevelUnits!=null && firstLevelUnits.size()>0){
                    if(studentsForm.getFirstLevelUnitId()==0) studentsForm.setFirstLevelUnitId(firstLevelUnits.get(0).getId());

                    secondLevelUnits=getOrganizationalUnits(studentsForm.getFirstLevelUnitId());
                    if(secondLevelUnits!=null && secondLevelUnits.size()>0){
                        if(studentsForm.getSecondLevelUnitId()==0 || (studentsForm.getSecondLevelUnitId()!=0 && organizationalUnitManager.findOrganizationalUnit(studentsForm.getSecondLevelUnitId()).getBranchId()!=studentsForm.getFirstLevelUnitId())) studentsForm.setSecondLevelUnitId(secondLevelUnits.get(0).getId());

                        studies=getStudies(studentsForm.getSecondLevelUnitId(),preferredLanguage);
                        if(studies!=null && studies.size()>0){
                            if(studentsForm.getStudyId()==0 || (studentsForm.getStudyId()!=0 && studyManager.findStudy(studentsForm.getStudyId()).getOrganizationalUnitId()!=studentsForm.getSecondLevelUnitId())) studentsForm.setStudyId(studies.get(0).getId());

                            studyGradeTypes=getStudyGradeTypes(studentsForm.getStudyId(),preferredLanguage);
                            if(studyGradeTypes!=null && studyGradeTypes.size()>0){

                                if(studentsForm.getStudyGradeTypeId()==0 || (studentsForm.getStudyGradeTypeId()!=0 && studyManager.findStudyGradeType(studentsForm.getStudyGradeTypeId()).getStudyId()!=studentsForm.getStudyId())) studentsForm.setStudyGradeTypeId(studyGradeTypes.get(0).getId());

                                //get maximum CardinalTimeUnit
                                maxCardintalTimeUnit=studyManager.findStudyGradeType(studentsForm.getStudyGradeTypeId()).getMaxNumberOfCardinalTimeUnits();

                                if(studentsForm.getCardinalTimeUnitNumber()==0) studentsForm.setCardinalTimeUnitNumber(1);
                                //get academic Years for the StudyGradeType
                                //academicYears=getAcademicYears(studentsForm.getStudyGradeTypeId());
                            }
                        }
                    }
                }
            }	
        }

        if(studentsForm.getHostelId()!=0 && useHostelBlocks()){
            blockParams.put("hostelId", studentsForm.getHostelId());
            blockParams.put("lang",preferredLanguage);
            allBlocks=hostelManager.findBlocksByParams(blockParams);

            if(studentsForm.getBlockId()!=0 && studentsForm.getHostelId()==hostelManager.findBlockById(studentsForm.getBlockId()).getHostel().getId()) roomParams.put("blockId", studentsForm.getBlockId());
            roomParams.put("hostelId", studentsForm.getHostelId());
            roomParams.put("lang",preferredLanguage);
            allRooms=hostelManager.findRoomsByParams(roomParams);


        }else if(studentsForm.getHostelId()!=0 && !useHostelBlocks()){
            roomParams.put("hostelId", studentsForm.getHostelId());
            roomParams.put("lang", preferredLanguage);
            allRooms=hostelManager.findRoomsByParams(roomParams);
        }



        model.addAttribute("allInstitutions",institutions);
        model.addAttribute("allFirstLevelUnits",firstLevelUnits);
        model.addAttribute("allSecondLevelUnits",secondLevelUnits);
        model.addAttribute("allStudies",studies);
        model.addAttribute("allStudyGradeTypes", studyGradeTypes);
        model.addAttribute("maxCardinalTimeUnit",maxCardintalTimeUnit);
        model.addAttribute("allAcademicYears",academicYears);

        model.addAttribute("allHostels", hostelManager.findAllHostels());
        model.addAttribute("allBlocks", allBlocks);
        model.addAttribute("allRooms", allRooms);
        model.addAttribute("applicants",getStudentAccommodations(studentsForm,preferredLanguage));
        model.addAttribute("studentsForm",studentsForm);
        model.addAttribute("useHostelBlocks", useHostelBlocks());

        Map<Integer,String> mapAcademicYear=new HashMap<Integer, String>();
        for(AcademicYear ay:academicYears) 
            mapAcademicYear.put(ay.getId(), ay.getDescription());

        model.addAttribute("mapAcademicYear",mapAcademicYear);
    }


    private List<StudentAccommodation> getStudentAccommodations(StudentsForm studentsForm,String preferredLanguage){
        Map<String,Object> params=new HashMap<String, Object>();
        if(studentsForm!=null){

            if(studentsForm.getInstitutionId()!=0) params.put("institutionId",studentsForm.getInstitutionId());
            if(studentsForm.getFirstLevelUnitId()!=0) params.put("branchId",studentsForm.getFirstLevelUnitId());
            if(studentsForm.getSecondLevelUnitId()!=0) params.put("organizationalUnitId",studentsForm.getSecondLevelUnitId());
            if(studentsForm.getStudyGradeTypeId()!=0) params.put("studyGradeTypeId", studentsForm.getStudyGradeTypeId());
            if(studentsForm.getAcademicYearId()!=0) params.put("academicYearId",studentsForm.getAcademicYearId());
            if(studentsForm.getCardinalTimeUnitNumber()!=0) params.put("cardinalTimeUnitNumber", studentsForm.getCardinalTimeUnitNumber());

            if(studentsForm.getHostelId()!=0 && useHostelBlocks()){
                params.put("hostelId", studentsForm.getHostelId());
                params.put("lang", preferredLanguage);
                if(studentsForm.getBlockId()!=0 && studentsForm.getHostelId()==hostelManager.findBlockById(studentsForm.getBlockId()).getHostel().getId()) params.put("blockId", studentsForm.getBlockId());
                if(studentsForm.getRoomId()!=0 && studentsForm.getHostelId()==hostelManager.findRoomById(studentsForm.getRoomId()).getHostel().getId()) params.put("roomId", studentsForm.getRoomId());
            }else if(!useHostelBlocks()){
                if(studentsForm.getRoomId()!=0 && studentsForm.getHostelId()==hostelManager.findRoomById(studentsForm.getRoomId()).getHostel().getId()) params.put("roomId", studentsForm.getRoomId());
            }


            if(studentsForm.getStatus()!=null && !studentsForm.getStatus().equals("0")){
                if(studentsForm.getStatus().equals("applicants") || studentsForm.getStatus().equals("accommodated"))
                    params.put("allocated", studentsForm.getStatus().equals("applicants")?"N":"Y");
            }

            List<StudentAccommodation> studentAccommodations=accommodationManager.findApplicantsByParams(params);
            List<StudentAccommodation> studentAccommodations2=new ArrayList<StudentAccommodation>();

            //If progressStatus is not equal to 0 then get students who are either on fullTime or partTime
            if(studentsForm.getProgressStatus()!=null && studentAccommodations!=null && !studentsForm.getProgressStatus().equals("0")){
                for(StudentAccommodation studentAccommodation:studentAccommodations){
                    //Get students who are either on Full Time or Part Time
                    if((studentsForm.getProgressStatus().equals("PT") && isStudentOnPartTime(studentAccommodation.getStudent().getStudentId())) || studentsForm.getProgressStatus().equals("FT")){
                        studentAccommodations2.add(studentAccommodation);
                    }
                    studentAccommodations=studentAccommodations2;
                }
            }

            return studentAccommodations;
        }

        return null;
    }

    /**
     * Get the academicYearId which would be used to extract accommodation details as well as accommodationFees
     * @param studentId
     * @return
     */
    private boolean isStudentOnPartTime(int studentId){
        List<? extends StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(studentId);
        int studyPlanId=studyPlans.get(0).getId();
        List<? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits=studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);

        //progressStatusCode 26 is for "TPT- To Part-Time" 
        if(studyPlanCardinalTimeUnits.size()>1 && !studyPlanCardinalTimeUnits.get(1).getProgressStatusCode().equals("29")){
            return true;
        }else{
            return false;
        }
    }

    private List<Institution> getInstitutions(){
        return institutionManager.findInstitutions(null);
    }

    private List<Branch> getBranches(int institutionId){
        Map<String, Object> param=new HashMap<String, Object>();
        param.put("institutionId", institutionId);
        return branchManager.findBranches((Map<String,Object>)param);
    }

    private List<OrganizationalUnit> getOrganizationalUnits(int branchId){
        Map<String, Object> param=new HashMap<String, Object>();
        param.put("branchId", branchId);
        param.put("unitLevel", 1);
        return organizationalUnitManager.findOrganizationalUnits(param);
    }
    private List<Study> getStudies(int organizationUnitId,String preferredLanguage){
        return studyManager.findAllStudiesForOrganizationalUnit(organizationUnitId);
    }

    private List<StudyGradeType> getStudyGradeTypes(int studyId,String preferredLanguage){
        Map<String, Object> param=new HashMap<String, Object>();
        param.put("preferredLanguage",preferredLanguage);
        param.put("studyId", studyId);

        return studyManager.findStudyGradeTypesByParams(param);
    }

    private boolean useHostelBlocks(){
        AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
        if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
            return true;
        }
        return false;
    }
}