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
 ******************************************************************************/
package org.uci.opus.accommodation.web.flow.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

	/**
	 * @author move
	 * Reusable builder element to be used by controllers which display students that are accommodated lists.
	 * Loads combo box entries for combo boxes typically used to show students that are accommodated lists.
	 * One should be able to use a subset of the total possible combo boxes.
	 */
	public class AccommodationStudentFilterBuilder {

	    private Logger log = LoggerFactory.getLogger("AccommodationStudentFilterBuilder");
	    
	    private OpusMethods opusMethods;
	    private LookupCacher lookupCacher;
	    private StudyManagerInterface studyManager;
	    private AccommodationManagerInterface accommodationManager;
	    
		private HttpSession session;
		private HttpServletRequest request;
		private HttpServletResponse response;
		private String preferredLanguage;
		private int institutionId = 0;
		private int branchId = 0;
	    
		private int organizationalUnitId = 0;
		private int primaryStudyId = 0;
		private int studyGradeTypeId = 0;
		private int cardinalTimeUnitNumber = 0;
		private int appliedForAccommodation = 0;
		private int grantedAccommodation = 0;
		
	    private String statusCode = "";
		private String institutionTypeCode = "";
		private String searchValue = "";

		
		public AccommodationStudentFilterBuilder(HttpServletRequest request,
	            HttpServletResponse response,
	            OpusMethods opusMethods,
	            LookupCacher lookupCacher,
	            StudyManagerInterface studyManager,
	            StudentManagerInterface studentManager,
	            AccommodationManagerInterface accommodationManager) {
			super();
			this.request = request;
			this.response = response;
			this.opusMethods = opusMethods;
			this.lookupCacher = lookupCacher;
			this.studyManager = studyManager;
			this.accommodationManager = accommodationManager;
			session = request.getSession(false);

	        preferredLanguage = OpusMethods.getPreferredLanguage(request);
		}

		
		public void initChosenValues() {
		    
		    // get the searchValue and put it on the session
	        searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");

		    /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
	        institutionId = OpusMethods.getInstitutionId(session, request);
	        session.setAttribute("institutionId", institutionId);
	        
	        branchId = OpusMethods.getBranchId(session, request);
	        session.setAttribute("branchId", branchId);
	        
	        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
	        session.setAttribute("organizationalUnitId", organizationalUnitId);
	        
	        // remember if study is chosen
	        if (request.getParameter("primaryStudyId") != null) {
	            primaryStudyId = ServletUtil.getParamSetAttrAsInt(request, "primaryStudyId", 0);
	            
	        } else if (session.getAttribute("primaryStudyId") != null) {
	            primaryStudyId = (Integer) session.getAttribute("primaryStudyId");
//	            request.setAttribute("primaryStudyId", primaryStudyId);
	        }
	        session.setAttribute("primaryStudyId", primaryStudyId);
//	        session.setAttribute("studyId", primaryStudyId);
	        
	        
	        if (request.getParameter("studyGradeTypeId") != null) {
	        	studyGradeTypeId = ServletUtil.getParamSetAttrAsInt(request, "studyGradeTypeId", 0);
	            
	        } else if (session.getAttribute("studyGradeTypeId") != null) {
	        	studyGradeTypeId = (Integer) session.getAttribute("studyGradeTypeId");
//	            request.setAttribute("studyGradeTypeId", studyGradeTypeId);
	        }
	        session.setAttribute("studyGradeTypeId", studyGradeTypeId);        
	        //studyGradeTypeId = ServletUtil.getParamSetAttrAsInt(request, "studyGradeTypeId", 0);
	        
	        
	        if (request.getParameter("cardinalTimeUnitNumber") != null) {
	        	cardinalTimeUnitNumber = ServletUtil.getParamSetAttrAsInt(request, "cardinalTimeUnitNumber", 0);
	            
	        } else if (session.getAttribute("cardinalTimeUnitNumber") != null) {
	        	cardinalTimeUnitNumber = (Integer) session.getAttribute("cardinalTimeUnitNumber");
//	            request.setAttribute("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
	        }
	        session.setAttribute("cardinalTimeUnitNumber", cardinalTimeUnitNumber);        
	        
	        if (request.getParameter("statusCode") != null) {
	            statusCode = ServletUtil.getParamSetAttrAsString(request, "statusCode", "");
	            
	        } else if (session.getAttribute("statusCode") != null) {
	            statusCode = (String) session.getAttribute("statusCode");
//	            request.setAttribute("statusCode", statusCode);
	        }
	        session.setAttribute("statusCode", statusCode);        
	        //statusCode = ServletUtil.getParamSetAttrAsString(request, "statusCode", "");

	        institutionTypeCode = ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode", 
	        		OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
	        
	        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);

	        // TODO : fill in the right parameters for accommodation
	        
	        
		}
		
		
		public void loadInstitutionBranchOrgUnit() {
	        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
	                session, request, institutionTypeCode, institutionId
	                                    , branchId, organizationalUnitId);
		}
		
		public void doLookups() {
	        /* fill lookup-tables with right values */
	        lookupCacher.getPersonLookups(preferredLanguage, request);
	        
		}

		public void loadStudies() {
			loadStudies(null);
		}
		
		public void loadStudies(Map<String, Object> additionalfindParams) {
	        // LIST OF STUDIES
	        // used to show the name of the primary study of each subject in the overview
	        List < ? extends Study > allStudies = null;
	        Map<String, Object> findStudiesMap = new HashMap<String, Object>();
	        if (additionalfindParams != null) {
	        	findStudiesMap.putAll(additionalfindParams);
	        }

	    	findStudiesMap.put("institutionId", institutionId);
	    	findStudiesMap.put("branchId", branchId);
	    	findStudiesMap.put("organizationalUnitId", organizationalUnitId);
	    	findStudiesMap.put("institutionTypeCode", institutionTypeCode);
	    	allStudies = studyManager.findStudies(findStudiesMap);
	        request.setAttribute("allStudies", allStudies);
	        
	        // LIST OF STUDIES TO SHOW IN DROP DOWN LIST
	        // this cannot be the same list as allStudies, because this
	        // list needs to be empty if the organizational unit is not chosen
	        List < ? extends Study > dropDownListStudies = null;
	        if (organizationalUnitId != 0) {
	            dropDownListStudies = allStudies;
	        }
	        request.setAttribute("dropDownListStudies", dropDownListStudies);
		}

		public void loadStudyGradeTypes() {
			loadStudyGradeTypes(null);
		}
		public void loadStudyGradeTypes(Map<String, Object> additionalfindParams) {
	        // LIST OF STUDYGRADEYPES
	        List < ? extends StudyGradeType > allStudyGradeTypes = null;
	        if (primaryStudyId != 0) {
	            Map<String, Object> findStudyGradeTypesMap = new HashMap<String, Object>();
	            if (additionalfindParams != null) {
	            	findStudyGradeTypesMap.putAll(additionalfindParams);
	            }
	            findStudyGradeTypesMap.put("studyId", primaryStudyId);
	            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
	        	allStudyGradeTypes = studyManager
	                                .findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);
	        }
	        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);
		}

		public void loadMaxCardinalTimeUnitNumber() {
	        int maxNumberOfCardinalTimeUnits = 0;
	        if (studyGradeTypeId != 0) {
	        	maxNumberOfCardinalTimeUnits = 
	        		studyManager.findNumberOfCardinalTimeUnitsForStudyGradeType(
	        				studyGradeTypeId);
	        } else {
	        	maxNumberOfCardinalTimeUnits = 
	        		Integer.parseInt((String) session.getAttribute("iMaxCardinalTimeUnits"));
	        }
	        request.setAttribute("maxNumberOfCardinalTimeUnits", maxNumberOfCardinalTimeUnits);
		}
		
		
		public List < ? extends Student > loadAccommodationStudents() {
	        /* retrieve student domain lookups */
	        List < ? extends Student > allStudents = null;
	        //allStudents = opusMethods.getAllStudents(session, request);
	        Map<String, Object> findStudentsMap = new HashMap<String, Object>();
	        findStudentsMap.put("institutionId", institutionId);
	        findStudentsMap.put("branchId", branchId);
	        findStudentsMap.put("organizationalUnitId", organizationalUnitId);
	        findStudentsMap.put("institutionTypeCode", institutionTypeCode);
	        findStudentsMap.put("studyId", primaryStudyId);
	        findStudentsMap.put("studyGradeTypeId", studyGradeTypeId);
	        findStudentsMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
	        findStudentsMap.put("statusCode", statusCode);
	        findStudentsMap.put("searchValue", searchValue);
	        findStudentsMap.put("appliedForAccommodation", appliedForAccommodation);
	        findStudentsMap.put("grantedAccommodation", grantedAccommodation);
	        
	        // TODO: implement this method in AccommodationManager
	        //allStudents = accommodationManager.findStudentsAppliedForAccommodation(
	        //                                                findStudentsMap);
	        request.setAttribute("allStudents", allStudents);

	        return allStudents;
		}
		
		public HttpServletRequest getRequest() {
			return request;
		}


		public HttpServletResponse getResponse() {
			return response;
		}


		public int getInstitutionId() {
			return institutionId;
		}


		public int getBranchId() {
			return branchId;
		}


		public int getOrganizationalUnitId() {
			return organizationalUnitId;
		}


		public int getPrimaryStudyId() {
			return primaryStudyId;
		}


		public int getStudyGradeTypeId() {
			return studyGradeTypeId;
		}


		public String getInstitutionTypeCode() {
			return institutionTypeCode;
		}


		public int getCardinalTimeUnitNumber() {
			return cardinalTimeUnitNumber;
		}

		public String getStatusCode() {
			return statusCode;
		}

		public int getAppliedForAccommodation() {
			return appliedForAccommodation;
		}

		public int getGrantedAccommodation() {
			return grantedAccommodation;
		}

	
	}
