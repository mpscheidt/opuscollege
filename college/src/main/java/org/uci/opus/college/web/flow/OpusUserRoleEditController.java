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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.validator.OpusUserRoleValidator;
import org.uci.opus.college.web.form.OpusUserRoleForm;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/userrole.view")
@SessionAttributes({ OpusUserRoleEditController.OPUS_USER_ROLE_FORM })
@PreAuthorize("hasAnyRole('UPDATE_USER_ROLES')")
public class OpusUserRoleEditController {

    static final String OPUS_USER_ROLE_FORM = "opusUserRoleForm";

    private static Logger log = LoggerFactory.getLogger(OpusUserRoleEditController.class);

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private OpusUserManagerInterface opusUserManager;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;

    @Autowired
    private BranchManagerInterface branchManager;

    @Autowired
    private InstitutionManagerInterface institutionManager;

    @Autowired
    private OpusUserRoleValidator opusUserRoleValidator;

    private static final String formView = "college/person/userrole";

    public OpusUserRoleEditController() {
        super();
    }

    @InitBinder
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));

    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        OpusUserRoleForm opusUserRoleForm = null;

        HttpSession session = request.getSession(false);

        String userName = request.getParameter("userName");
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // users may be staff members or students "stId" stands for both
        int stId = ServletUtil.getIntParam(request, "stId", 0);
        int roleId = ServletUtil.getIntParam(request, "roleId", 0);

        // organizational units which user has not a role assigned, a user cannot have different roles in the same org unit
        List<OrganizationalUnit> availableOrganizationalUnits = new ArrayList<>();

        OpusUser opusUser = opusUserManager.findOpusUserByUserName(userName);
        OpusUserRole opusUserRole = null;

        opusMethods.removeSessionFormObject(OPUS_USER_ROLE_FORM, session, model, opusMethods.isNewForm(request));

        /* OpusUserRoleForm - fetch or create the form object and fill it with opusUserRole */
        opusUserRoleForm = (OpusUserRoleForm) model.get(OPUS_USER_ROLE_FORM);
        if (opusUserRoleForm == null) {
            opusUserRoleForm = new OpusUserRoleForm();

            // get only roles that are <= than the own role
            OpusUserRole loggedInOpusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
            String loggedInRole = loggedInOpusUserRole.getRole();
            List<Role> allRoles = opusUserManager.findRolesByParams(preferredLanguage, loggedInRole);
            opusUserRoleForm.setAllRoles(allRoles);

            int institutionId = OpusMethods.getInstitutionId(session, request);
            int branchId = OpusMethods.getBranchId(session, request);

            if (roleId != 0) {
                opusUserRole = opusUserManager.findOpusUserRoleById(roleId);

                // when editing a user role also add in the dropdown of organizational units the corresponding ounit for this role
                OrganizationalUnit roleOrganizationalUnit = organizationalUnitManager.findOrganizationalUnit(opusUserRole.getOrganizationalUnitId());
                availableOrganizationalUnits.add(roleOrganizationalUnit);

                // only load set these on request and session when
                // userRoleIsFirstLoaded
                if (opusUserRoleForm.getOpusUserRole() == null) {
                    // set selected branch and institution according to role
                    branchId = branchManager.findBranchOfOrganizationalUnit(opusUserRole.getOrganizationalUnitId());
                    institutionId = institutionManager.findInstitutionOfBranch(branchId);
                }

            } else {

                opusUserRole = new OpusUserRole();
                opusUserRole.setUserName(userName);
                opusUserRole.setValidFrom(new Date());
            }

            opusUserRoleForm.setUserRoles(opusUserManager.findOpusUserRolesByUserName(userName));

            // request.setAttribute("branchId", branchId);
            // request.setAttribute("institutionId", institutionId);
            opusUserRole.setInstitutionId(institutionId);
            opusUserRole.setBranchId(branchId);

            session.setAttribute("branchId", branchId);
            session.setAttribute("institutionId", institutionId);

            // opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId, 0);
            Organization organization = new Organization();
            opusMethods.fillOrganization(session, request, organization, opusUserRole.getOrganizationalUnitId(), branchId, institutionId);
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
            opusUserRoleForm.setOrganization(organization);

            // organizational units which user has not a role assigned
            availableOrganizationalUnits.addAll(findAvailableOrgUnits(institutionId, branchId, userName));

            if (opusUser.getIsStaffMember()) {

                session.setAttribute("menuChoice", "staffmembers");

                StaffMember staffMember = opusUser.getStaffMember();

                opusUserRoleForm.setStaffMember(staffMember);
                opusUserRoleForm.setUserType("staffmember");

                stId = staffMember.getStaffMemberId();

            } else {

                session.setAttribute("menuChoice", "students");

                Student student = opusUser.getStudent();

                opusUserRoleForm.setStudent(student);
                opusUserRoleForm.setUserType("student");

                stId = student.getStudentId();
            }

            opusUserRoleForm.setIsPreferredOrganizationalUnit(opusUser.getPreferredOrganizationalUnitId() == opusUserRole.getOrganizationalUnitId());

            organization.setAllOrganizationalUnits(availableOrganizationalUnits);
            opusUserRoleForm.setStId(stId);
            opusUserRoleForm.setEditingUser(opusUser);
            opusUserRoleForm.setOpusUserRole(opusUserRole);

            model.addAttribute("roleBranch", branchManager.findBranch(branchId));
            model.addAttribute(OPUS_USER_ROLE_FORM, opusUserRoleForm);

        }

        return formView;
    }

    private List<OrganizationalUnit> findAvailableOrgUnits(int institutionId, int branchId, String userName) {

        Map<String, Object> findOrgUnitsMap = new HashMap<>();
        findOrgUnitsMap.put("institutionId", institutionId);
        findOrgUnitsMap.put("branchId", branchId);
        findOrgUnitsMap.put("userName", userName);

        // organizational units which user has not a role assigned
        return opusUserManager.findOrganizationalUnitsNotInUserRole(findOrgUnitsMap);

    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(OPUS_USER_ROLE_FORM) OpusUserRoleForm opusUserRoleForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        opusUserRoleForm.syncOrganizationWithOpusUserRole();

        OpusUserRole opusUserRole = opusUserRoleForm.getOpusUserRole();
        int stId = ServletUtil.getIntParam(request, "stId", 0);

        String successView = "";
        // flag for setting this user role has the default one when user logs in
        String isPreferredOUnit = request.getParameter("isPreferredOrganizationalUnit");

        String userType = ServletUtil.getParamSetAttrAsString(request, "userType", "");

        opusUserRoleValidator.validate(opusUserRoleForm.getOpusUserRole(), result);

        if (result.hasErrors()) {
            return formView;

        } else {

            if (opusUserRole.getId() == 0) {
                opusUserManager.addOpusUserRole(opusUserRole);
            } else {
                opusUserManager.updateOpusUserRole(opusUserRole);
            }

            // if "isPreferredOrganizationalUnit" flag is set on the request then update
            // users preferredOrganizationalUitId
            if (!StringUtil.isNullOrEmpty(isPreferredOUnit, true)) {
                OpusUser user = opusUserManager.findOpusUserByUserName(opusUserRole.getUserName());

                user.setPreferredOrganizationalUnitId(opusUserRole.getOrganizationalUnitId());
                user.setPw(null);// setting password to null causes it not to be
                // updated
                opusUserManager.updateOpusUser(user, null);
            }

            if ("staffmember".equals(userType)) {
                successView = "redirect:/college/staffmember.view?newForm=true&tab=1&panel=2&staffMemberId=" + stId;
            } else if ("student".equals(userType)) {
                successView = "redirect:/college/student-opususer.view?newForm=true&tab=1&panel=2&studentId=" + stId;
            }

        }
        return successView;
    }

    @RequestMapping(method = RequestMethod.POST, params = "task=institution")
    public String institutionChanged(@ModelAttribute(OPUS_USER_ROLE_FORM) OpusUserRoleForm opusUserRoleForm, BindingResult result) {

        opusMethods.loadBranches(opusUserRoleForm.getOrganization());
        // opusUserRoleForm.syncOrganizationWithOpusUserRole();

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params = "task=branch")
    public String branchChanged(@ModelAttribute(OPUS_USER_ROLE_FORM) OpusUserRoleForm opusUserRoleForm, BindingResult result) {

        Organization organization = opusUserRoleForm.getOrganization();

        // int institutionId = OpusMethods.getInstitutionId(session, request);
        // int branchId = OpusMethods.getBranchId(session, request);
        int institutionId = organization.getInstitutionId();
        int branchId = organization.getBranchId();
        // int organizationalUnitId = organization.getOrganizationalUnitId();

        if (branchId == 0) {
            organization.clearOrganizationalUnits();
        } else {
            // organizational units for which user has yet no role assigned
            organization.setAllOrganizationalUnits(findAvailableOrgUnits(institutionId, branchId, opusUserRoleForm.getOpusUserRole().getUserName()));
        }

        // reset organizationalUnitId
        organization.setOrganizationalUnitId(0);

        // opusUserRoleForm.syncOrganizationWithOpusUserRole();

        return formView;
    }

}
