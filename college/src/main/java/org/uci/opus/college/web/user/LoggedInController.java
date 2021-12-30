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

package org.uci.opus.college.web.user;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.util.StudentUtil;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.util.Encode;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.OpusMethods;

/**
 * This controller is activated after a user logged in successfully.
 * A comment is written to the security log.
 * The locale is set according to the user's settings.
 * The user's default role is set. This triggers the {@link RoleChangeInterceptor}. 
 * 
 * @author markus
 * @see RoleChangeInterceptor
 */

@Controller
public class LoggedInController {

    /**
     * What is logged to the securityLog is also logged in the standard log (unless additivity flag is set to false in the log4j2 config).
     */
    private static Logger securityLog = LoggerFactory.getLogger("SECURITY." + LoggedInController.class);
    private static Logger log = LoggerFactory.getLogger(LoggedInController.class);

    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusUserManagerInterface opusUserManager;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private OpusMethods opusMethods;

    @RequestMapping(value="/college/loggedIn.view")
    public String loggedIn(HttpServletRequest request) {

        HttpSession session = request.getSession(false);        

        SecurityContext sContext = SecurityContextHolder.getContext();
        Authentication auth = sContext.getAuthentication();
        String userName = auth.getName();

        
        OpusUser opusUser = opusUserManager.findOpusUserByUserName(userName);
        String localeString = opusUser.getLang().trim();
        Locale locale = StringUtils.parseLocaleString(localeString);
        String preferredLanguage = locale.getLanguage();

        securityLog.info("User '" + userName + "' logged in");

        List<String> applicationLanguages = appConfigManager.getAppLanguages();
        if (!applicationLanguages.contains(localeString) && !applicationLanguages.contains(preferredLanguage)) {
            String fallbackLocale = !applicationLanguages.isEmpty() ? applicationLanguages.get(0) : session.getServletContext().getInitParameter("javax.servlet.jsp.jstl.fmt.fallbackLocale"); 
            log.warn("User '" + userName + "' logged in with preferred locale = " + localeString + ", which is not part of the application locales. Resetting preferred locale to " + fallbackLocale);
            localeString = fallbackLocale;
            locale = StringUtils.parseLocaleString(localeString);
            preferredLanguage = locale.getLanguage();
        }

        // on login, determine the preferred / default role (will be picked up by RoleChangeInterceptor)
        int organizationalUnitId = opusUser.getPreferredOrganizationalUnitId();
        OpusUserRole opusUserRole = opusUserManager.findOpusUserRoleByOrgUnit(userName, organizationalUnitId);
        if (opusUserRole == null) {
            String err = "User '" + userName + "' has no role with the preferredOrganizationalUnitId " + organizationalUnitId;
            securityLog.warn(err);

            // try any other role
            List<OpusUserRole> opusUserRoles = opusUserManager.findOpusUserRolesByUserName(userName);
            if (opusUserRoles == null || opusUserRoles.size() == 0) {
                err = "User '" + userName + "' has no roles at all";
                securityLog.warn(err);
                throw new RuntimeException(err);
            } else {
                opusUserRole = opusUserRoles.get(0);    // just take any role
            }
        }
        
        
        // Get all non expired roles for this user
        // Note: make sure the date of the DB server is correct, otherwise opusUserRole entries may not be found because of validFrom and validThrough
        Map<String , Object> userRolesMap = new HashMap<>();
        userRolesMap.put("userName", userName);
        userRolesMap.put("excludeExpired", "true");
        userRolesMap.put("excludeUnavailable", "true");
        userRolesMap.put("preferredLanguage", preferredLanguage);
        List<Map<String,Object>> opusUserRoles = (List <Map<String,Object>>) opusUserManager.findOpusUserRolesByParams2(userRolesMap);
        if (opusUserRoles.isEmpty()) {
            String err = "User '" + userName + "' has no roles assigned (in preferred language '" + preferredLanguage + "') - impossible to login";
            securityLog.warn(err);
            throw new RuntimeException(err);
        }

        // --- if no errors occurred, update session ---
        session.setAttribute("opusUser", opusUser);
        session.setAttribute("opusUserRoles", opusUserRoles);

        // this allows tomcat manager to see logged in user names
        Person person = personManager.findPersonById(opusUser.getPersonId());
        session.setAttribute("userName", userName + " (" + person.getFirstnamesFull() + " " + person.getSurnameFull() + ")");
        
        String firstNameFull=person.getFirstnamesFull()!=null?person.getFirstnamesFull():"";
        String firstNameAlias=person.getFirstnamesAlias()!=null?person.getFirstnamesAlias():"";
        String surnameFull=person.getSurnameFull()!=null?person.getSurnameFull():"";
        String surnameAlias=person.getSurnameAlias()!=null?person.getSurnameAlias():"";
        
        //add a session attribute which stores the full names of the currently logged-in user
        session.setAttribute("userFullName", firstNameFull+" "+firstNameAlias+" "+surnameAlias+" "+surnameFull);
        
        // --- determine view ---
        
        /* Check if this user logs in for first time by checking his/her password.
         * If so redirect to compulsory change of password
         */
        String view = null;
        
        //        Person person = personManager.findPersonById(opusUser.getPersonId());
        String encodedPersonCode = Encode.encodeMd5(person.getPersonCode());
        if (opusUser.getPw().equals(encodedPersonCode)) {
            //log.debug("pwcheck succeeded");
            // VIEW FOR STAFFMEMBER
            if (opusMethods.isStaffMember()) {
                StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(
                                                opusUser.getPersonId());

                view = "redirect:/college/staffmember.view?newForm=true&tab=1&panel=0"
                		 + "&from=staffmembers&staffMemberId=" 
                    + staffMember.getStaffMemberId() + "&showUserNameError=" + 
                    messageSource.getMessage("jsp.error.password.firstchange", null, locale);
            // VIEW FOR STUDENT 
            } else if (opusMethods.isStudent()) {
                Student student = opusUser.getStudent();
               
                view = "redirect:/college/student/personal.view?newForm=true&tab=1&panel=0"
                    + "&from=students&studentId="
                    + student.getStudentId() + "&showUserNameError=" + 
                    messageSource.getMessage("jsp.error.password.firstchange", null, locale);
            }
        } else if (opusMethods.isStudent()) {
            Student student = opusUser.getStudent();

            List<StudyPlanCardinalTimeUnit> studyPlanCTUs = new ArrayList<>();
                // if studyplan with CTU present, then show the CTU, otherwise the person view
                if (!ListUtil.isNullOrEmpty(student.getStudyPlans())) {
                    for (int i = 0; student.getStudyPlans().size() > i; i++) {
                        StudyPlan studyPlan = student.getStudyPlans().get(i);
                        if (!ListUtil.isNullOrEmpty(studyPlan.getStudyPlanCardinalTimeUnits())) {
                            for (int j = 0; studyPlan.getStudyPlanCardinalTimeUnits().size() > j; j++) {
                                StudyPlanCardinalTimeUnit studyPlanCTU = 
                                                    studyPlan.getStudyPlanCardinalTimeUnits().get(j);
                                boolean isOpusUserThisStudent = false;
                                if (opusUser.getPersonId() == student.getPersonId()) {
                                    isOpusUserThisStudent = true;
                                }
                                if (StudentUtil.isEditableStudyPlanCTU(request, studyPlan
                                        .getStudyPlanStatusCode(), studyPlanCTU, isOpusUserThisStudent)) {
                                    studyPlanCTUs.add(studyPlanCTU);
                                }
                            }
                        }
                    }
                }
                if (log.isDebugEnabled()) {
                    log.debug("LoggedInCOntroller number of studyPlans: " + student.getStudyPlans().size());
                    log.debug("LoggedInCOntroller number of current StudyPlanCTUs: " + studyPlanCTUs.size());
                }
                opusMethods.fillParamsAtStartUp(request);
                
                // one current studyPlanCTU: go to studyPlanCTU screen
                if (studyPlanCTUs.size() == 1) {
                    view = "redirect:/college/studyplancardinaltimeunit.view?newForm=true&tab=0"
                                + "&panel=0&currentPageNumber=1"
                                + "&studyPlanCardinalTimeUnitId=" + studyPlanCTUs.get(0).getId()
                                + "&studyPlanId=" + studyPlanCTUs.get(0).getStudyPlanId();
                // more than one current studyPlanCTU + one studyPlan: go to studyPlan screen
                } else if (studyPlanCTUs.size() > 1 && student.getStudyPlans().size() == 1) {
                    view = "redirect:/college/studyplan.view?newForm=true&tab=1&panel=0"
                            + "&currentPageNumber=1"
                            + "&studentId="+ student.getStudentId()
                            + "&studyPlanId=" + studyPlanCTUs.get(0).getStudyPlanId();
                } else {
                    view = "redirect:/college/student/personal.view?newForm=true&tab=0&panel=0"
                    		+ "&from=students&studentId=" + student.getStudentId();
                }
        } 
        
        if (view == null) {
            view = "redirect:/college/start.view?preferredLanguage=" + localeString;
        }
        
        // let the interceptor know the role
        view += "&opusUserRoleId=" + opusUserRole.getId();

        if (opusUser.getFailedLoginAttempts() != 0) {
            view += "&failedLoginAttempts=" + opusUser.getFailedLoginAttempts();
            // reset failed login count to zero on a successful login
            opusUser.setFailedLoginAttempts((short) 0);
            opusUserManager.updateOpusUser(opusUser, opusUser.getPw());
        }
        
		return view;
    }

}
