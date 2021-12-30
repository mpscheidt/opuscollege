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

package org.uci.opus.college.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.persistence.StaffMemberMapper;
import org.uci.opus.util.Encode;
import org.uci.opus.util.StringUtil;

/**
 * @author move
 * Service class that contains OpusUser-related management methods. 
 */
public class StaffMemberManager implements StaffMemberManagerInterface {

    protected Logger log = LoggerFactory.getLogger(getClass());
    
    @Autowired private StaffMemberMapper staffMemberMapper;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private OpusUserManagerInterface opusUserManager; 
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private SubjectManagerInterface subjectManager;

    @Override
    public List < StaffMember > findAllStaffMembers(final String preferredLanguage) {

        Map<String, Object> map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        return staffMemberMapper.findAllStaffMembers(map);
    }

    @Override
    public List<StaffMember> findStaffMembers(final Map<String, Object> map) {
        return staffMemberMapper.findStaffMembers(map);
    }

    @Override
    public List < StaffMember > findUnboundTeachers(final Map<String, Object> map) {

        List<StaffMember> allTeachers = null;
        List<SubjectTeacher> allBoundTeachers = null;
        List<StaffMember> allUnboundTeachers = new ArrayList<>();
    	
    	int subjectId = (Integer) map.get("subjectId");
    	boolean blAddToUnbound = true;
    	StaffMember staffMember = null;
    	SubjectTeacher subjectTeacher = null;
    	
    	// fetch all staffMembers for institution/branch/orgUnit:
    	allTeachers = this.findStaffMembers(map);
        allBoundTeachers = subjectManager.findSubjectTeachers(subjectId);

    	// combine the two lists into a new list with unbound teachers for this subject:
    	for (int i = 0; i < allTeachers.size(); i++) {
    		staffMember = (StaffMember) allTeachers.get(i);
    		for (int j = 0; j < allBoundTeachers.size(); j++) {
    			subjectTeacher = (SubjectTeacher) allBoundTeachers.get(j);
    			if (staffMember.getStaffMemberId() == subjectTeacher.getStaffMemberId()) {
    				blAddToUnbound = false;
    			}
    		}
    		// add to list or not:
    		if (blAddToUnbound) {
    			allUnboundTeachers.add(staffMember);
    		}
    		blAddToUnbound = true;
    	}
    	
        return allUnboundTeachers;
    }

    @Override
    public StaffMember findStaffMember(final String preferredLanguage, final int staffMemberId) {
        return staffMemberMapper.findStaffMember(preferredLanguage, staffMemberId);
    }

    @Override
    public StaffMember findStaffMemberByPersonId(final int personId) {
        return staffMemberMapper.findStaffMemberByPersonId(personId);
    }

    @Override
    public int findStaffMemberIdByPersonId(int personId) {
        Integer staffMemberId = staffMemberMapper.findStaffMemberIdByPersonId(personId);
        return staffMemberId == null ? 0 : staffMemberId;
    }

    @Override
    public StaffMember findStaffMemberByCode(final String preferredLanguage, final String staffMemberCode) {
        return staffMemberMapper.findStaffMemberByCode(preferredLanguage, staffMemberCode);
    }

    @Override
    public boolean alreadyExistsStaffMemberCode(String staffMemberCode, int staffMemberId) {
        return staffMemberMapper.alreadyExistsStaffMemberCode(staffMemberCode, staffMemberId);
    }

//  MP 2015-01-03: Apparently not used anymore
//    @Override
//    public StaffMember findStaffMemberByParams(final Map<String, Object> map) {
//        
//        StaffMember staffMember  = null;
//
//        staffMember = staffMemberMapper.findStaffMemberByParams(map);
//        
//        return staffMember;
//    }

    @Override
    public int countStaffMembers(Map<String, Object> map) {
        return staffMemberMapper.countStaffMembers(map);
    }

    @Override
    public OrganizationalUnit findOrganizationalUnitForStaffMember(final int personId) {
        OrganizationalUnit organizationalUnit = staffMemberMapper.findOrganizationalUnitForStaffMember(personId);
        return organizationalUnit;
    }

    @Override
    public List<Contract> findContractsForStaffMember(final int staffMemberId) {
        return staffMemberMapper.findContractsForStaffMember(staffMemberId);
    }

    @Override
    public List<StaffMemberFunction> findFunctionsForStaffMember(final int staffMemberId) {
        return staffMemberMapper.findFunctionsForStaffMember(staffMemberId);
    }

    @Override
    public List<SubjectTeacher> findSubjectsForStaffMember(final int staffMemberId) {
        return staffMemberMapper.findSubjectsForStaffMember(staffMemberId);
    }

    @Override
    public List<ExaminationTeacher> findExaminationsForStaffMember(final int staffMemberId) {
        return staffMemberMapper.findExaminationsForStaffMember(staffMemberId);
    }
    
    @Override
    public List<TestTeacher> findTestsForStaffMember(int staffMemberId) {
        return staffMemberMapper.findTestsForStaffMember(staffMemberId);
    }

    @Override
    public void addFunctionToStaffMember(final int staffMemberId, final String functionCode, final String functionLevelCode) {
        staffMemberMapper.addFunctionToStaffMember(staffMemberId, functionCode, functionLevelCode);
    }

    @Override
    @Transactional
    public int addStaffMember(final StaffMember staffMember
                                    , final OpusUserRole staffOpusUserRole
                                    , final OpusUser staffOpusUser) {

        int newStaffMemberId = 0;

        // insert person:
        personManager.addPerson(staffMember);
        // retrieve new personId:
        Person person = personManager.findPersonByCode(staffMember.getPersonCode());

        // create new opusUser + opusUserRole:
        // language is always filled
        staffOpusUser.setPersonId(person.getId());
        if (StringUtils.isEmpty(staffOpusUser.getUserName())) {
            String userName = StringUtil.createSimpleUniqueCode("U", StringUtil.fullTrim(staffMember.getSurnameFull()));
        	staffOpusUser.setUserName(userName);
        	staffOpusUserRole.setUserName(userName);
        }

        staffOpusUser.setUserName(staffOpusUserRole.getUserName());
        if (StringUtils.isEmpty(staffOpusUserRole.getRole())) {
        	Role role = opusUserManager.findFirstExistingRole(staffOpusUser.getLang2LetterCode(), new String[] {"staff", "guest"});
        	staffOpusUserRole.setRole(role.getRole());
        }
        if (StringUtils.isEmpty(staffOpusUser.getPw())) {
        	staffOpusUser.setPw(Encode.encodeMd5(staffMember.getPersonCode()));
        }

        opusUserManager.addOpusUser(staffOpusUser);

        // update staffmember before inserting:
        staffMember.setPersonId(person.getId());

        // insert and write history
        newStaffMemberId = staffMemberMapper.addStaffMember(staffMember);
        addStaffMemberHistory(staffMember, "I");
        
        // update opusUserRole with the correct organizationalUnitId before inserting
//        int orgId = (this.findOrganizationalUnitForStaffMember(person.getId())).getId();
        int orgId = staffMember.getPrimaryUnitOfAppointmentId();
        staffOpusUserRole.setOrganizationalUnitId(orgId);
        opusUserManager.addOpusUserRole(staffOpusUserRole);

        return newStaffMemberId;
    }

    private void addStaffMemberHistory(StaffMember staffMember, String operation) {
        staffMemberMapper.addStaffMemberHistory(staffMember, operation);
    }

    @Override
    public void updateStaffMemberAndOpusUser(final StaffMember staffMember
                                    , final OpusUser staffOpusUser
                                    , final String oldPw) {

        this.updateStaffMember(staffMember);
        opusUserManager.updateOpusUser(staffOpusUser, oldPw);
    }
    
    @Override
    public void updateStaffMember(StaffMember staffMember) {

        /* first update staffMember part in case staffMemberId changed */
        staffMemberMapper.updateStaffMember(staffMember);
        addStaffMemberHistory(staffMember, "U");

        // TODO if PrimaryUnitOfAppointment is changed, change also in the opusUserRole

        personManager.updatePerson(staffMember);
    }

    @Override
    public void deleteStaffMember(final String preferredLanguage, final int staffMemberId, String writeWho) {

        StaffMember staffMember = staffMemberMapper.findStaffMember(preferredLanguage, staffMemberId);
        
        if (staffMember.getAddresses().size() != 0) {
            staffMemberMapper.deleteStaffMemberInAddress(staffMember.getPersonId());
        }
        if (staffMember.getFunctions().size() != 0) {
            staffMemberMapper.deleteStaffMemberInFunction(staffMemberId);
        }
        if (staffMember.getContracts().size() != 0) {
            staffMemberMapper.deleteStaffMemberInContract(staffMemberId);
        }

        staffMember.setWriteWho(writeWho);
        staffMemberMapper.deleteStaffMember(staffMemberId);
        addStaffMemberHistory(staffMember, "D");

        opusUserManager.deleteOpusUserRole(staffMember.getPersonId());
        opusUserManager.deleteOpusUser(staffMember.getPersonId());
        personManager.deletePerson(staffMember.getPersonId(), writeWho);
    }

    @Override
    public void deleteLookupFromStaffMember(final int staffMemberId, final String lookupCode
                                                 , final String lookupType) {
        lookupManager.deleteLookupFromEntity("staffmember", staffMemberId, lookupCode, lookupType);
    }

    @Override
    public int findPersonId(int staffMemberId) {
        Integer personId = staffMemberMapper.findPersonId(staffMemberId);
        return personId != null ? personId : 0;
    }

    @Override
    public int findPersonId(String staffMemberId) {
        if (staffMemberId == null || staffMemberId.isEmpty()) return 0;
        return findPersonId(new Integer(staffMemberId));
    }

    @Override
    public List<StaffMember> findAllContacts(final int organizationalUnitId) {
        return staffMemberMapper.findAllContacts(organizationalUnitId);
    }

}
