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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

//import com.thoughtworks.xstream.XStream;
//import com.thoughtworks.xstream.io.xml.DomDriver;

/**
 * @author smacumbe
 *July 07, 2009
 */
public class StudentsExportsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(StudentsExportsController.class);
    private SecurityChecker securityChecker;
    private StudentManagerInterface studentManager;
    private StudyManagerInterface studyManager;
    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;
    private String viewName;
    private AcademicYearManagerInterface academicYearManager;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */	 	
    public StudentsExportsController() {
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

        List<? extends Student> allStudents = studentManager
        .findStudentsByStudyGradeAcademicYear(map);
        // STUDYYEAR: List<?extends StudyYear> studyYears = studyManager.findAllStudyYears();

//        StudentCloner studentCloner = new StudentCloner();
        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());

        if(request.getParameter("loadStudents") != null){
            request.setAttribute("allStudents", allStudents);
        }

        String operation = request.getParameter("operation");
        System.out.println("\n op : " + operation);
        Student clone = null;
        if (operation != null) {

            // get selected students
            String[] studentsIds = request.getParameterValues("studentId");

            List<Student> errorStudents = new ArrayList<Student>();
            ArrayList<Student> students = new ArrayList<Student>();

            if (operation.equalsIgnoreCase("export")) {

                for (int i = 0; (studentsIds != null) && (i < studentsIds.length); i++) {
                    int studentId = Integer.parseInt(studentsIds[i]);

                    Student student = studentManager.findStudent(
                            preferredLanguage, studentId);

//                    clone = studentCloner.deepClone(student);
//                    students.add(clone);
                    students.add(student);

                }

                //System.out.println("Generating file for : " + students.size());
                String XMLStudents = toXML(students);
                System.out.println("");
                System.out.println(XMLStudents);
                response.setContentType("application/x-download");
                response.setHeader("Content-Disposition","attachment; filename=export.xml");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print(XMLStudents);
                mav = null;
                System.out.println("\n\n\n");


            } 

            // adds students with errors to the request
            if (!errorStudents.isEmpty()) {
                request.setAttribute("errorStudents", errorStudents);
            }
            // adds students with no errors to the request
            if (!students.isEmpty()) {
                request.setAttribute("students", students);
            }

        }

        return mav;
    }


    /**
     * Builds a parameter map with usual required parameters , institutionId , branchId , primaryStudyId , etc. 
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
        StudentsExportsController.log = log;
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
     * @param studyManager the studyManager to set
     */
    public void setStudyManager(StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
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

    public void setAcademicYearManager(final AcademicYearManagerInterface academicYearManager) {
        this.academicYearManager = academicYearManager;
    }

    /**
     * Formats the output of the XML to match those specified by the schema
     * @param items
     * @return
     */
    private String toXML(List<Student> items){
return "-- xml conversion currently deactivated --";
//        XStream xstream = new XStream(new DomDriver());
//
//        //Makes that xStream shows only the class name instead of the full class name (i.e. including package)
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
//        // STUDYYEAR:  xstream.alias("studyYear", StudyYear.class);
//        xstream.alias("subject", Subject.class);
//        xstream.alias("subjectResult", SubjectResult.class);
//        xstream.alias("test", Test.class);
//        xstream.alias("testResult", TestResult.class);
//        xstream.alias("students", List.class);
//
//        return xstream.toXML(items);
    }

}
