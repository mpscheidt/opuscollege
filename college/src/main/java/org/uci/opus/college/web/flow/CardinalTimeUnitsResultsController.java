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
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

public class CardinalTimeUnitsResultsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(CardinalTimeUnitsResultsController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private StudyManagerInterface studyManager;
    private SubjectManagerInterface subjectManager;
    private OpusMethods opusMethods;


   /** 
    * @see javax.servlet.http.HttpServlet#HttpServlet()
    */     
   public CardinalTimeUnitsResultsController() {
       super();
   }

   @Override
   protected ModelAndView handleRequestInternal(HttpServletRequest request, 
           HttpServletResponse response) {

       HttpSession session = request.getSession(false);        
       int institutionId = 0;
       int branchId = 0;
       int organizationalUnitId = 0;
       int studyId = 0;
       int currentPageNumber = 0;
       
       /* perform session-check. If wrong, this throws an Exception towards ErrorController */
       securityChecker.checkSessionValid(session);
       
       // no form object in this controller yet
//       opusMethods.removeSessionFormObject("...", session, opusMethods.isNewForm(request));
       
       // if a subject is linked to a result, it can not be deleted; this attribute is
       // used to show an error message.
       request.setAttribute("showError", request.getParameter("showError"));
       
       /* set menu to examinations */
       session.setAttribute("menuChoice", "exams");

       if (request.getParameter("currentPageNumber") != null) {
           currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
       }
       request.setAttribute("currentPageNumber", currentPageNumber);

       /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
       institutionId = OpusMethods.getInstitutionId(session, request);
       session.setAttribute("institutionId", institutionId);
       
       branchId = OpusMethods.getBranchId(session, request);
       session.setAttribute("branchId", branchId);
       
       organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
       session.setAttribute("organizationalUnitId", organizationalUnitId);
               

       studyId = OpusMethods.getStudyId(session, request);
       session.setAttribute("studyId", studyId);
       
       /*
        *  find a LIST OF INSTITUTIONS of the correct educationtype
        *  
        *  set first the institutionTypeCode;
        *  for now studies, and therefore subjects, are only registered
        *  for universities; if in the future this should change, it will
        *  be easier to alter the code
        */
       String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
       request.setAttribute("institutionTypeCode", institutionTypeCode);
       
       // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
       opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                           session, request, institutionTypeCode, institutionId
                                               , branchId, organizationalUnitId);

      // LIST OF STUDIES
       // used to show the name of the primary study of each subject in the overview
       List < ? extends Study > allStudies = null;
       Map<String, Object> findStudiesMap = new HashMap<>();
       
       if (organizationalUnitId != 0) {
           findStudiesMap.put("institutionId", institutionId);
           findStudiesMap.put("branchId", branchId);
           findStudiesMap.put("organizationalUnitId", organizationalUnitId);
           findStudiesMap.put("institutionTypeCode", institutionTypeCode);
           allStudies = (ArrayList < Study >) studyManager.findStudies(findStudiesMap);
       }
       request.setAttribute("allStudies", allStudies);

       // LIST OF CARDINAL TIME UNITS
       // TODO : implement cardinaltimeunitsresults controller
       List allCardinalTimeUnits = null;
       request.setAttribute("allCardinalTimeUnits", allCardinalTimeUnits);

       return new ModelAndView(viewName); 
   }
  
   /**
    * @param viewName is set by Spring on application init.
    */
   public void setViewName(final String viewName) {
       this.viewName = viewName;
   }

   public void setSubjectManager(final SubjectManagerInterface subjectManager) {
       this.subjectManager = subjectManager;
   }

   /**
    * @param securityChecker is set by Spring on application init.
    */
   public void setSecurityChecker(final SecurityChecker securityChecker) {
       this.securityChecker = securityChecker;
   }

   /**
    * @param studyManager is set by Spring on application init.
    */
   public void setStudyManager(final StudyManagerInterface studyManager) {
       this.studyManager = studyManager;
   }


   public void setOpusMethods(final OpusMethods opusMethods) {
       this.opusMethods = opusMethods;
   }

}
