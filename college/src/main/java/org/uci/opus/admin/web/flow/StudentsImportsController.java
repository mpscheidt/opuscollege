/*
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
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
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
*/

package org.uci.opus.admin.web.flow;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

//import com.thoughtworks.xstream.XStream;
//import com.thoughtworks.xstream.io.xml.DomDriver;

/**
 * @author smacumbe
 *July 07, 2009
 */
public class StudentsImportsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(StudentsImportsController.class);
    private SecurityChecker securityChecker;
    private StudentManagerInterface studentManager;
    private BranchManagerInterface branchManager;
    private StudyManagerInterface studyManager;
    private OpusUserManagerInterface opusUserManager;
    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;
    private LookupManagerInterface lookupManager;
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    private InstitutionManagerInterface institutionManager;
    private MessageSource messageSource;
    private String viewName;

    // studentnumbergenerator must be autowired because of primary flag:
    @Autowired private StudentNumberGeneratorInterface studentNumberGenerator;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */	 	
    public StudentsImportsController() {
        super();
    }

    @Override
    protected final ModelAndView handleRequestInternal(
            HttpServletRequest request, final HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        ModelAndView mav = new ModelAndView(viewName);
        /*
         * perform session-check. If wrong, this throws an Exception towards
         * ErrorController
         */
        securityChecker.checkSessionValid(session);

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* set menu to students */
        session.setAttribute("menuChoice", "admin");

        ServletUtil.getParamSetAttrAsString(request, "showStudentError", "");
        fb.initChosenValues();

        fb.doLookups();

        fb.loadStudies();

        fb.loadStudyGradeTypes();

        // STUDYYEAR: fb.loadStudyYears();

        int academicYearId = ServletUtil.getIntParam(request, "academicYearId", 0);

        int primaryStudyId2 = ServletUtil.getParamSetAttrAsInt(request,
                "primaryStudyId2", 0);
        int studyYearId2 = ServletUtil.getParamSetAttrAsInt(request,
                "studyYearId2", 0);
        int studyGradeTypeId2 = ServletUtil.getParamSetAttrAsInt(request,
                "studyGradeTypeId2", 0);

        // StudentFilterBuilder only loads studyyears when they is
        // a studygradetype however it is necessary to have all studyyears
        // so in fastinput.jsp it is possible to retrieve the
        // yearnumbervariation
        // and display it in the variation cell
        // STUDYYEAR: request.setAttribute("studyYears", studyManager.findAllStudyYears());

        // moved down because possibly other institutionId, branchId and/or
        // orgId needed
        fb.loadInstitutionBranchOrgUnit();

        Map<String, Object> map = makeParameterMap(fb.getInstitutionId(), fb.getBranchId(),
                fb.getOrganizationalUnitId(), fb.getPrimaryStudyId(), fb
                .getStudyGradeTypeId(), 
                // STUDYYEAR: fb.getStudyYearId(),
                academicYearId, preferredLanguage , OpusMethods.getInstitutionTypeCode(request));

        String operation = request.getParameter("operation");


        if("getfile".equalsIgnoreCase(operation)){

            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            CommonsMultipartFile commonsfile = (CommonsMultipartFile) multipartRequest.getFile("file");
            String type = null;
            if(commonsfile != null){
                type = commonsfile.getContentType();
            }


            List<Student> students = fromXML(commonsfile.getInputStream());
            List<Student> errorStudents = new ArrayList<Student>();
            List<Student> importStudents =  new ArrayList<Student>();

            for (Student student : students) {

                String errors = checkStudent(student, multipartRequest, session, opusMethods); 
                if(!StringUtil.isNullOrEmpty(errors , true)){
                    errorStudents.add(student);
                    student.setRemarks(errors);
                } else {
                    importStudents.add(student);
                }
            }

            session.setAttribute("importStudents" , importStudents);
            request.setAttribute("errorStudents" , errorStudents);
            //instructs the jsp to show the students table
            //this stops the jsp of showing the table when the user has not yet uploaded a file
            request.setAttribute("showStudents" , true);

        } else if("importstudents".equalsIgnoreCase(operation)){

            List<Student> importStudents = (List<Student>)session.getAttribute("importStudents");

            // get selected students
            String[] studentsIds = request.getParameterValues("studentId");

            for (int i = 0; (studentsIds != null) && (i < studentsIds.length); i++) {
                int studentId = Integer.parseInt(studentsIds[i]);

                Student student = getStudentById(studentId, importStudents);

                if(student != null){
                    ///studentManager.addStudent(preferredLanguage, student, studentOpusUserRole, studentOpusUser, currentLoc, request);
                }
            }
            //remove importStudents from session as they will no longer be needed
            session.removeAttribute("importStudents");
        }
        return mav;
    }

    /**
     * Builds a parameter map with usual required parameters , institutionId , branchId , primaryStudyId , etc 
     * @param institutionId
     * @param branchId
     * @param organizationalUnitId
     * @param primaryStudyId
     * @param studyGradeTypeId
     * @param studyYearId
     * @param academicYear
     * @param institutionTypeCode
     * @return map with parameters
     */
    private Map<String, Object> makeParameterMap(int institutionId , int branchId , int organizationalUnitId ,
            int primaryStudyId , int studyGradeTypeId , 
            // STUDYYEAR: int studyYearId ,
            int  academicYearId , String lang , String institutionTypeCode){

        Map<String, Object> parameterMap = new HashMap<String, Object>(); 
        if(institutionId != 0)
            parameterMap.put("institutionId" , institutionId);
        if(branchId != 0)
            parameterMap.put("branchId" , branchId);
        if(organizationalUnitId != 0)
            parameterMap.put("organizationalUnitId" , organizationalUnitId);
        if(primaryStudyId != 0)
            parameterMap.put("studyId" , primaryStudyId);
        if(studyGradeTypeId != 0)
            parameterMap.put("studyGradeTypeId" , studyGradeTypeId);		
        // STUDYYEAR: if(studyYearId != 0)
        // STUDYYEAR: 	parameterMap.put("studyYearId" , studyYearId);
        if(academicYearId != 0)
            parameterMap.put("academicYearId" , academicYearId);

        parameterMap.put("institutionTypeCode" , institutionTypeCode);

        return parameterMap;
    }


    /**
     * @param viewName the viewName to set
     */
    public void setViewName(String viewName) {
        this.viewName = viewName;
    }


    /**
     * @param log the log to set
     */
    public static final void setLog(Logger log) {
        StudentsImportsController.log = log;
    }


    /**
     * @param securityChecker the securityChecker to set
     */
    public void setSecurityChecker(SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }


    /**
     * @param studentManager the studentManager to set
     */
    public void setStudentManager(StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }


    /**
     * @param branchManager the branchManager to set
     */
    public void setBranchManager(BranchManagerInterface branchManager) {
        this.branchManager = branchManager;
    }


    /**
     * @param studyManager the studyManager to set
     */
    public void setStudyManager(StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }


    /**
     * @param opusUserManager the opusUserManager to set
     */
    public void setOpusUserManager(OpusUserManagerInterface opusUserManager) {
        this.opusUserManager = opusUserManager;
    }


    /**
     * @param opusMethods the opusMethods to set
     */
    public void setOpusMethods(OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }


    /**
     * @param lookupCacher the lookupCacher to set
     */
    public void setLookupCacher(LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }


    /**
     * @param lookupManager the lookupManager to set
     */
    public void setLookupManager(LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }


    /**
     * @param organizationalUnitManager the organizationalUnitManager to set
     */
    public void setOrganizationalUnitManager(
            OrganizationalUnitManagerInterface organizationalUnitManager) {
        this.organizationalUnitManager = organizationalUnitManager;
    }


    /**
     * @param institutionManager the institutionManager to set
     */
    public void setInstitutionManager(InstitutionManagerInterface institutionManager) {
        this.institutionManager = institutionManager;
    }


    /**
     * @param messageSource the messageSource to set
     */
    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    /**
     * Formats the output of the XML to match those specified by the schema
     * @param items
     * @return
     */
    private List<Student> fromXML(InputStream inputStream){

//        XStream xstream = new XStream(new DomDriver());
        List <Student> students = null;

        //Makes that xStream shows only the class name instead of the full class name (i.e. including package)
//        xstream.alias("address", Address.class);
//        xstream.alias("branch", Branch.class);
//        xstream.alias("contract",Contract.class);
//        xstream.alias("exam", StudyPlanResult.class);
//        xstream.alias("examination",Examination.class);
//        xstream.alias("institution", Institution.class);
//        xstream.alias("student", org.uci.opus.college.domain.Student.class);
//        xstream.alias("studentAbsence" , StudentAbsence.class);
//        xstream.alias("study", Study.class);
//        xstream.alias("studyGradeType" , StudyGradeType.class);
//        xstream.alias("studyPlan", StudyPlan.class);
//        xstream.alias("studyPlanDetail",StudyPlanDetail.class);
//        // STUDYYEAR: xstream.alias("studyYear", StudyYear.class);
//        xstream.alias("subject", Subject.class);
//        xstream.alias("subjectResult", SubjectResult.class);
//        xstream.alias("test", Test.class);
//        xstream.alias("testResult", TestResult.class);
//        xstream.alias("students", List.class);

//        students = (List<Student>)xstream.fromXML(inputStream);						

        return students;
    }


    private String checkStudent(Student student , HttpServletRequest request ,HttpSession session, OpusMethods opusMethods){

        StringBuffer error = new StringBuffer();
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("studentCode", student.getStudentCode());
        map.put("surnameFull" , student.getSurnameFull());
        map.put("firstNamesFull" , student.getFirstnamesFull());
        map.put("birthdate" , student.getBirthdate());

        int organizationalUnitId = opusMethods.getOrganizationalUnitId2(session, request);

        Student testStudent = studentManager.findStudentByCode(student.getStudentCode());


        if(testStudent != null){
            error.append("1.");
            error.append(messageSource.getMessage("jsp.error.import.student.code.exists", null, request.getLocale()));
        }

        testStudent = studentManager.findStudentByParams2(map);

        if(testStudent != null){
            //if there was already an error add this one to the list in another line
            if(error.length() != 0){
                error.append("<br />");
            }
            error.append("2.");
            error.append(messageSource.getMessage("jsp.error.import.student.exists", null, request.getLocale()));
        }


        //String studentCode = createUniqueStudentNumberOnSubmit(organizationalUnitId);
        //student.setStudentCode(studentCode);

        return error.toString();
    }

    /**
     * Update id fied for avoiding for avoiding conflicts
     * @param student
     */
    private void updateIds(Student student){

        /*Student
         *
         *	
         */

    }

//    protected String createUniqueStudentNumberOnSubmit(int organizationalUnitId) {
//        String studentCode;
//        StudentNumberGeneratorInterface studentCodeCalc = getStudentNumberGenerator();
//        studentCode = studentCodeCalc.createUniqueStudentNumberOnSubmit(organizationalUnitId, x);
//        return studentCode;
//    }


    /**
     * Looks for a student in the list of students to be imported
     * @param id
     * @param students
     * @return
     */
    private Student getStudentById(int id , List<Student> students){
        Student student = null;

        for (Iterator iterator = students.iterator(); iterator.hasNext();) {
            student = (Student) iterator.next();

            if(id == student.getId()){
                break;
            }
        }

        return student;
    }
    /**
     * @return the studentNumberGenerator
     */
    public StudentNumberGeneratorInterface getStudentNumberGenerator() {
        return studentNumberGenerator;
    }


}
