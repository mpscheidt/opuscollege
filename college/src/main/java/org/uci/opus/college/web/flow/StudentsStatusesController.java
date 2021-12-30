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

package org.uci.opus.college.web.flow;

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
import org.uci.opus.college.service.GeneralManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * @author smacumbe
 *March 14, 2009
 *
 * NB: This is not used anymore, works inspiration, maybe the screen can be useful to assign or view student statuses
 *     of many students at once.
 */
@Deprecated
public class StudentsStatusesController extends AbstractController {

	  	private Logger log = LoggerFactory.getLogger(StudentsStatusesController.class);
	    private SecurityChecker securityChecker;
		private StudentManagerInterface studentManager;
		private StudyManagerInterface studyManager;
		private GeneralManagerInterface generalManager;
		private OpusMethods opusMethods;
		private LookupCacher lookupCacher;
		private LookupManagerInterface lookupManager;
		private String viewName;
		private AcademicYearManagerInterface academicYearManager;
	 
	    /** 
		 * @see javax.servlet.http.HttpServlet#HttpServlet()
		 */	 	
		public StudentsStatusesController() {
			super();
		}

	   
	    @Override
		protected final ModelAndView handleRequestInternal(
			HttpServletRequest request, final HttpServletResponse response)
			{

		HttpSession session = request.getSession(false);

		/*
		 * perform session-check. If wrong, this throws an Exception towards
		 * ErrorController
		 */
		securityChecker.checkSessionValid(session);
		
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

		StudentFilterBuilder fb = new StudentFilterBuilder(request,
				opusMethods, lookupCacher, studyManager, studentManager);

		String preferredLanguage = OpusMethods.getPreferredLanguage(request);
		String orderBy = ServletUtil.getParamSetAttrAsString(request, "orderBy", "person.surnameFull");
        String searchField = ServletUtil.getParamSetAttrAsString(request, "searchField", "person.surnameFull");
        String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "").trim();
        //default status code active (1)
        String studentStatusCode = ServletUtil.getParamSetAttrAsString(request, "studentStatusCode", "1");	

		/* set menu to students */
		session.setAttribute("menuChoice", "students");

		ServletUtil.getParamSetAttrAsString(request, "showStudentError", "");
		fb.initChosenValues();

		fb.doLookups();

		fb.loadStudies();

		fb.loadStudyGradeTypes();

//		fb.loadStudyYears();

		int academicYearId = ServletUtil.getParamSetAttrAsInt(request, "academicYearId", 0);

		lookupCacher.getStudentLookups(preferredLanguage, request);
		// StudentFilterBuilder only loads studyyears when they is
		// a studygradetype however it is necessary to have all studyyears
		// so in fastinput.jsp it is possible to retrieve the
		// yearnumbervariation
		// and display it in the variation cell
//		request.setAttribute("studyYears", studyManager.findAllStudyYears());
		
		// moved down because possibly other institutionId, branchId and/or
		// orgId needed
		fb.loadInstitutionBranchOrgUnit();

		Map<String, Object> parameterMap = makeParameterMap(fb.getInstitutionId(), fb.getBranchId(),
				fb.getOrganizationalUnitId(), fb.getPrimaryStudyId(), fb
						.getStudyGradeTypeId(), 
						//fb.getStudyYearId(),
				academicYearId, preferredLanguage , OpusMethods.getInstitutionTypeCode(request));

		
		if(!StringUtil.isNullOrEmpty(orderBy , true))
        	parameterMap.put("orderBy", orderBy);
        
		if(!"0".equals(studentStatusCode))
	        parameterMap.put("studentStatusCode", studentStatusCode);
		
        parameterMap.put("searchField", searchField);
        parameterMap.put("searchValue", searchValue);
        
        
		List<? extends Student> allStudents = studentManager
				.findStudentsByStudyGradeAcademicYear(parameterMap);

		request.setAttribute("allAcademicYears", 
					academicYearManager.findAllAcademicYears());

		if(request.getParameter("loadStudents") != null){
			request.setAttribute("allStudents", allStudents);
		}
		
		setViewName("college/person/studentsstatuses");

		String operation = request.getParameter("operation");

		if ("assignstatuses".equals(operation)) {
		
			List<Student> assignedStudents = new ArrayList<>();
			
			String[] studentsIds = request.getParameterValues("studentId");
			assignStatus(studentsIds, request.getParameter("newStatusCode"));
			
			for(int i = 0; i < studentsIds.length; i++){
				int id = Integer.parseInt(studentsIds[i]);
				
				assignedStudents.add(studentManager.findStudent(preferredLanguage, id));
			}
			
			request.setAttribute("students", assignedStudents);
			setViewName("college/person/studentsstatusesresults");
		}

		return new ModelAndView(viewName);
	}

	    private Map<String, Object> makeParameterMap(int institutionId, int branchId,
			int organizationalUnitId, int primaryStudyId, int studyGradeTypeId,
			//int studyYearId, 
			int academicYearId, String lang,
			String institutionTypeCode) {

		Map<String, Object> parameterMap = new HashMap<>();
		if (institutionId != 0)
			parameterMap.put("institutionId", institutionId);
		if (branchId != 0)
			parameterMap.put("branchId", branchId);
		if (organizationalUnitId != 0)
			parameterMap.put("organizationalUnitId", organizationalUnitId);
		if (primaryStudyId != 0)
			parameterMap.put("studyId", primaryStudyId);
		if (studyGradeTypeId != 0)
			parameterMap.put("studyGradeTypeId", studyGradeTypeId);
		if (academicYearId != 0)
			parameterMap.put("academicYearId", academicYearId);

		parameterMap.put("institutionTypeCode", institutionTypeCode);

		return parameterMap;
	}


	    private void assignStatus(String[] studentsIds , String studentStatusCode){
	    	
	    	for(int i = 0; i < studentsIds.length; i++){
	    		generalManager.updateField("student", "studentId", new Integer(studentsIds[i]) , "studentStatusCode", studentStatusCode);
	    	}
	    }
	    
	    
		/**
		 * @param viewName the viewName to set
		 */
		public void setViewName(String viewName) {
			this.viewName = viewName;
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


		/**
		 * @param lookupManager the lookupManager to set
		 */
		public void setLookupManager(LookupManagerInterface lookupManager) {
			this.lookupManager = lookupManager;
		}


		/**
		 * @param generalManager the generalManager to set
		 */
		public void setGeneralManager(GeneralManagerInterface generalManager) {
			this.generalManager = generalManager;
		}


		public void setAcademicYearManager(final AcademicYearManagerInterface academicYearManager) {
			this.academicYearManager = academicYearManager;
		}


		
	    

	}
