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

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.SecondarySchoolSubjectGroupForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * @author G. ten Napel
 *
 */
@Controller
@RequestMapping("/college/studygradetypesecondaryschoolsubjects.view")
@SessionAttributes({ "secondarySchoolSubjectGroupForm" })
public class StudyGradeTypeSecondarySchoolSubjectsController {
    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudyManagerInterface studyManager;
    private String formView;

    /** 
    * @see javax.servlet.http.HttpServlet#HttpServlet()
    */     
   public StudyGradeTypeSecondarySchoolSubjectsController() {
       super();
       this.formView = "college/study/studyGradeTypeSecondarySchoolSubjects";
   }

   @RequestMapping(method=RequestMethod.GET)
   public String setUpForm(HttpServletRequest request, ModelMap model) {              
       
       HttpSession session = request.getSession(false); 
       
       /* perform session-check. If wrong, this throws an Exception towards ErrorController */
       securityChecker.checkSessionValid(session);
       
       /* New form instance: Create new secondarySchoolSubjectGroupForm */
       SecondarySchoolSubjectGroupForm secondarySchoolSubjectGroupForm = new SecondarySchoolSubjectGroupForm();
       
       String preferredLanguage = OpusMethods.getPreferredLanguage(request);
       
       /* STUDYFORM.NAVIGATIONSETTINGS - fetch or create the object */
       NavigationSettings navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, null);    
       secondarySchoolSubjectGroupForm.setNavigationSettings(navigationSettings);
       
       /* put list of allSecondarySchoolSubjects on the form */
       List< SecondarySchoolSubject > allSecondarySchoolSubjects = studyManager
                                               .findAllSecondarySchoolSubjects();
       secondarySchoolSubjectGroupForm.setAllSecondarySchoolSubjects(allSecondarySchoolSubjects);
       
       /* fetch studyGradeType and add to form */
       StudyGradeType studyGradeType = null;
       int studyGradeTypeId = 0;
       
       if (request.getParameter("studyGradeTypeId") != null 
               && !"".equals(request.getParameter("studyGradeTypeId"))) {
           
           studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
           studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
           secondarySchoolSubjectGroupForm.setStudyGradeType(studyGradeType);
       }       
                     
       if (request.getParameter("newForm") != null) {
           
           /* User wants to create new SecondarySchoolSubjectGroup */
           SecondarySchoolSubjectGroup secondarySchoolSubjectGroup = new SecondarySchoolSubjectGroup();
           secondarySchoolSubjectGroup.setId(-1); // Until we save it for the first time!
           secondarySchoolSubjectGroup.setStudyGradeTypeId(studyGradeTypeId);
           
           secondarySchoolSubjectGroupForm.setSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           
       } else if (request.getParameter("editExistingGroup") != null) {

           /* Find out if a secondary school subject groupId is provided*/
           if (request.getParameter("groupId") != null && !"".equals(request.getParameter("groupId"))) {   
                              
               /* Exisiting group, load group from database */
               int groupId = Integer.parseInt(request.getParameter("groupId"));
               SecondarySchoolSubjectGroup secondarySchoolSubjectGroup = studyManager.findSecondarySchoolSubjectGroup(preferredLanguage, studyGradeTypeId, groupId);
               secondarySchoolSubjectGroupForm.setSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           }                      
           
       } else if (request.getParameter("deleteSecondarySchoolSubjectGroup") != null) {
           
           /* Find out if a secondary school subject groupId is provided*/           
           if (request.getParameter("groupId") != null && !"".equals(request.getParameter("groupId"))) {           
               int groupId = Integer.parseInt(request.getParameter("groupId"));           
               SecondarySchoolSubjectGroup secondarySchoolSubjectGroup = studyManager.findSecondarySchoolSubjectGroup(preferredLanguage, studyGradeTypeId, groupId);
               studyManager.deleteSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           }

           String mavString = "redirect:/college/studygradetype.view?newForm=true&tab=" + secondarySchoolSubjectGroupForm.getNavigationSettings().getTab()
               + "&panel=" + secondarySchoolSubjectGroupForm.getNavigationSettings().getPanel()
               + "&studyGradeTypeId=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getId()
               + "&studyId=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getStudyId()
               + "&gradeTypeCode=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getGradeTypeCode()
               + "&currentPageNumber=" + secondarySchoolSubjectGroupForm.getNavigationSettings().getCurrentPageNumber();
           
           return mavString;
       }

       model.addAttribute("secondarySchoolSubjectGroupForm", secondarySchoolSubjectGroupForm);       
       return formView;
   }
   
   
   @RequestMapping(method=RequestMethod.POST)
   public String processSubmit(
           @ModelAttribute("secondarySchoolSubjectGroupForm") SecondarySchoolSubjectGroupForm secondarySchoolSubjectGroupForm,
           BindingResult result, SessionStatus status, HttpServletRequest request) {
       
       HttpSession session = request.getSession(false); 
       
       /* perform session-check. If wrong, this throws an Exception towards ErrorController */
       securityChecker.checkSessionValid(session);

       String preferredLanguage = OpusMethods.getPreferredLanguage(request);            

       SecondarySchoolSubjectGroup secondarySchoolSubjectGroup = 
                               secondarySchoolSubjectGroupForm.getSecondarySchoolSubjectGroup();
       List < SecondarySchoolSubject > allSecondarySchoolSubjects =
                                   secondarySchoolSubjectGroupForm.getAllSecondarySchoolSubjects();
              
       if ("true".equals(request.getParameter("submitFormObject"))) {

           // SUBMIT, we need to persist this group
           if (secondarySchoolSubjectGroup.getId() == -1) {
               studyManager.insertSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           } else {               
               studyManager.updateSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           }
           
           String mavString = "redirect:/college/studygradetype.view?newForm=true&tab=" 
               + secondarySchoolSubjectGroupForm.getNavigationSettings().getTab()
               + "&panel=" + secondarySchoolSubjectGroupForm.getNavigationSettings().getPanel()
               + "&studyGradeTypeId=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getId()
               + "&studyId=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getStudyId()
               + "&gradeTypeCode=" + secondarySchoolSubjectGroupForm.getStudyGradeType().getGradeTypeCode()
               + "&currentPageNumber=" + secondarySchoolSubjectGroupForm.getNavigationSettings().getCurrentPageNumber();
           
           return mavString;
           
       } else if ("true".equals(request.getParameter("addSubject"))) {           
           
           /* ADD SUBJECT to existing group that is already loaded from database */
           int secondarySchoolSubjectId = Integer.parseInt(request.getParameter("secondarySchoolSubjectId"));
  
           if (secondarySchoolSubjectId > 0) {
               SecondarySchoolSubject secondarySchoolSubject = studyManager.createSecondarySchoolSubject(
                       secondarySchoolSubjectId, secondarySchoolSubjectGroupForm.getStudyGradeType().getId(), preferredLanguage); 
               
               // add description
               for (SecondarySchoolSubject subject : allSecondarySchoolSubjects) {
                   if (subject.getId() == secondarySchoolSubject.getId()) {
                       secondarySchoolSubject.setDescription(subject.getDescription());
                   }
               }
               
               if (secondarySchoolSubjectGroup == null) {               
                   secondarySchoolSubjectGroup = new SecondarySchoolSubjectGroup();
               }
               secondarySchoolSubjectGroup.addSubject(secondarySchoolSubject);
               secondarySchoolSubjectGroupForm.setSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
           }
           
       } else if ("true".equals(request.getParameter("removeSubject"))) {
           
           /* REMOVE SUBJECT from existing group that is already loaded from database */
           int secondarySchoolSubjectId = Integer.parseInt(request.getParameter("removeSecondarySchoolSubjectId"));
           secondarySchoolSubjectGroup.removeSubject(secondarySchoolSubjectId);
           secondarySchoolSubjectGroupForm.setSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
       }
       
       /* put lookup-tables on the request for allSecondarySchoolSubjects */
       lookupCacher.getStudyLookups(preferredLanguage, request);
       
       return formView;
   }
   
   public void setSecurityChecker(final SecurityChecker securityChecker) {
       this.securityChecker = securityChecker;
   }

   public void setOpusMethods(final OpusMethods newOpusMethods) {
       opusMethods = newOpusMethods;
   }
   
   public void setLookupCacher(final LookupCacher lookupCacher) {
       this.lookupCacher = lookupCacher;
   }

    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }
  
}
