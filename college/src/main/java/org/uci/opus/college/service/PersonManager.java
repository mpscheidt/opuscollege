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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.persistence.PersonMapper;

/**
 * @author J.Nooitgedagt
 *
 */
public class PersonManager implements PersonManagerInterface {

    protected Logger log = LoggerFactory.getLogger(getClass());
    
    @Autowired private PersonMapper personMapper; 
    @Autowired private StaffMemberManagerInterface staffMemberManager; 
    @Autowired private StudentManagerInterface studentManager; 

    /**
     * @param id id of the person
     * @return found person.
     */
    public Person findPersonById(final int id) {
        return personMapper.findPersonById(id);
    }    

    @Override
    public Person findPersonByCode(String personCode) {
        return personMapper.findPersonByCode(personCode);
    }
    
    // TODO move to staff member manager
    @Override
    public List<StaffMember> findDirectors(final Map<String, Object> map) {
        return personMapper.findDirectors(map);
    }
    
    @Override
    public List<StaffMember> findAllDirectors(final int institutionId) {
        Map<String, Object> map = new HashMap<>();
        map.put("institutionId", institutionId);
        return this.findDirectors(map);
    }

    @Override
    public void addPerson(Person person) {
        personMapper.addPerson(person);
    }
    
    @Override
    public void updatePerson(Person person) {
        personMapper.updatePerson(person);
    }

    /**
     * @param person add photo to this person
     */
    public void updatePersonPhotograph(final Person person) {
        personMapper.updatePersonPhotograph(person);
    }

    @Override
    public void deletePerson(int personId, String writeWho) {

        Person person = findPersonById(personId);
        person.setWriteWho(writeWho);
        personMapper.deletePerson(personId);
    }

    @Override
    public boolean isStaffMember(final int personId) {

    	StaffMember staffMember = null;

    	staffMember = staffMemberManager.findStaffMemberByPersonId(personId);       

        if (staffMember != null) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean isStudent(final int personId) {

    	Student student = null;

        student = studentManager.findStudentByPersonId(personId);       

        if (student != null) {
            return true;
        } else {
            return false;
        }
    }

}
