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
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2011
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
package org.uci.opus.accommodation.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.accommodation.domain.AccommodationResource;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.domain.StudentAccommodationResource;
import org.uci.opus.accommodation.persistence.AccommodationMapper;
import org.uci.opus.accommodation.service.expoint.AccommodationServiceExtensions;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;

public class AccommodationManager implements AccommodationManagerInterface {

    private static Logger log = LoggerFactory.getLogger(AccommodationManager.class);

    @Autowired
    private AccommodationMapper accommodationMapper;

    @Autowired
    private AccommodationServiceExtensions accommodationServiceExtensions;

    @Autowired
    private HostelManagerInterface hostelManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Override
    public void addStudentAccommodation(StudentAccommodation studentAccommodation) {

        accommodationMapper.addStudentAccommodation(studentAccommodation);
        accommodationMapper.updateStudentAccommodationHistory(studentAccommodation, "I");

    }

    @Override
    @Transactional
    public int updateStudentAccommodation(StudentAccommodation studentAccommodation, HttpServletRequest request) {

        if ("N".equalsIgnoreCase(studentAccommodation.getApproved())) {
            studentAccommodation.setApprovedById(0);
            studentAccommodation.setApprovedBy(null);
            studentAccommodation.setDateApproved(null);
        } else if ("Y".equalsIgnoreCase(studentAccommodation.getApproved())) {
            OpusUser opusUser = opusMethods.getOpusUser();
            studentAccommodation.setApprovedById(staffMemberManager.findStaffMemberIdByPersonId(opusUser.getPersonId()));
            studentAccommodation.setDateApproved(new Date());
        }

        StudentAccommodation studentAccommodationInDB = findStudentAccommodation(studentAccommodation.getId());
        int oldRoomId = studentAccommodationInDB.getRoomId();
        int newRoomId = studentAccommodation.getRoomId();
        boolean fireDeallocated = false;
        boolean fireAllocated = false;

        if (newRoomId != oldRoomId) { // Any change in the allocated room?
            if (oldRoomId != 0) {
                // deallocate old room
                hostelManager.increaseAvailableBedSpaceByOne(oldRoomId);
                fireDeallocated = true;
            }
            if (newRoomId != 0) {
                // allocate new room
                studentAccommodation.setAllocated("Y");
                studentAccommodation.setDateDeallocated(null);
                hostelManager.reduceAvailableBedSpaceByOne(newRoomId);
                fireAllocated = true;
            } else {
                studentAccommodation.setAllocated("N");
                studentAccommodation.setDateDeallocated(new Date());
            }
        }
        // if(newRoomId != 0) {
        // studentAccommodation.setAllocated("Y");
        // studentAccommodation.setDateDeallocated(null);
        //
        // // check if it was newly allocated or reallocated
        // if ("Y".equalsIgnoreCase(studentAccommodationInDB.getAllocated())) {
        // // reallocate
        // if (oldRoomId != newRoomId) {
        // hostelManager.increaseAvailableBedSpaceByOne(oldRoomId);
        // hostelManager.reduceAvailableBedSpaceByOne(newRoomId);
        // }
        // } else {
        // // newly allocated
        // hostelManager.reduceAvailableBedSpaceByOne(newRoomId);
        // }
        // }

        studentAccommodation.setWriteWho(opusMethods.getWriteWho(request));
        int rows = this.updateStudentAccommodation(studentAccommodation);

        // after the new studentAccommodation has been written to DB, make notifications
        if (fireDeallocated) {
            accommodationServiceExtensions.roomDeallocated(studentAccommodation, request);
        }
        if (fireAllocated) {
            accommodationServiceExtensions.roomAllocated(studentAccommodation, request);
        }

        return rows;
    }

    private int updateStudentAccommodation(StudentAccommodation studentAccommodation) {
        int rows = accommodationMapper.updateStudentAccommodation(studentAccommodation);
        accommodationMapper.updateStudentAccommodationHistory(studentAccommodation, "U");
        return rows;
    }

    @Override
    @Transactional
    public void deallocate(StudentAccommodation studentAccommodation, HttpServletRequest request) {

        studentAccommodation.setRoomId(0);
        studentAccommodation.setRoom(null);
        studentAccommodation.setApproved("N");

        updateStudentAccommodation(studentAccommodation, request);

    }

    @Override
    public StudentAccommodation findStudentAccommodation(int id) {
        return accommodationMapper.findStudentAccommodation(id);
    }

    @Override
    public List<Student> findAccommodatedStudents(int academicYearId) {

        Map<String, Object> map = new HashMap<>();
        map.put("academicYearId", academicYearId);
        List<String> studentCodes = accommodationMapper.findAccommodatedStudentsByParams(map);
        return createStudentList(studentCodes);

        // return accommodationDao.findAccommodatedStudents(academicYearId);
    }

    /**
     * This method is used to create a collection of Student Object given a List of StudentCodes
     * 
     * @param studentCodes
     * @return Returns null if the List is Zero
     */
    private List<Student> createStudentList(List<String> studentCodes) {
        List<Student> lstStudents = null;
        if (studentCodes.size() > 0) {
            lstStudents = new ArrayList<Student>();
            for (String studentCode : studentCodes) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentCode", studentCode);
                lstStudents.add(studentManager.findStudentByParams2(map));
            }
        }
        return lstStudents;
    }

    @Override
    public List<Student> findNonAccommodatedStudents(int academicYearId) {

        Map<String, Object> map = new HashMap<>();
        map.put("academicYearId", academicYearId);
        List<String> studentCodes = accommodationMapper.findNonAccommodatedStudentsByParams(map);
        return createStudentList(studentCodes);
    }

    @Override
    public List<Student> findApprovedAccommodationStudents(int academicYearId) {

        Map<String, Object> map = new HashMap<>();
        map.put("academicYearId", academicYearId);
        List<String> studentCodes = accommodationMapper.findApprovedAccommodationStudentsByParams(map);
        return createStudentList(studentCodes);
    }

    @Override
    public List<Student> findNonApprovedAccommodationStudents(int academicYearId) {

        Map<String, Object> map = new HashMap<>();
        map.put("academicYearId", academicYearId);
        List<String> studentCodes = accommodationMapper.findNonApprovedAccommodationStudentsByParams(map);
        return createStudentList(studentCodes);
    }

    @Override
    public StudentAccommodation findStudentAccommodationByParams(Map<String, Object> criteria) {
        List<StudentAccommodation> list = accommodationMapper.findStudentAccommodationsByParams(criteria);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<StudentAccommodation> findStudentAccommodationsByParams(Map<String, Object> criteria) {
        return accommodationMapper.findStudentAccommodationsByParams(criteria);
    }

    @Override
    public int deleteStudentAccommodation(int id, String writeWho) {

        StudentAccommodation studentAccommodation = findStudentAccommodation(id);
        studentAccommodation.setWriteWho(writeWho);

        int rows = accommodationMapper.deleteStudentAccommodation(id);
        accommodationMapper.updateStudentAccommodationHistory(studentAccommodation, "D");

        return rows;
    }

    @Override
    public List<StudentAccommodation> findApplicantsByParams(Map<String, Object> params) {
        return accommodationMapper.findApplicantsByParams(params);
    }

    @Override
    public List<StudentAccommodation> findStudentAccommodationsToReAllocateByParams(Map<String, Object> params) {
        return accommodationMapper.findStudentAccommodationsToReAllocateByParams(params);
    }

    /**
     * Get the academicYearId which would be used to extract accommodation details as well as
     * accommodationFees
     * 
     * @param studentId
     * @return
     */
    @Override
    public int getAcademicYearId(int studentId) {
        List<? extends StudyPlan> studyPlans = studentManager.findStudyPlansForStudent(studentId);
        int studyPlanId = studyPlans.get(0).getId();
        List<? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
        int studyGradeTypeId = 0;

        // progressStatusCode 26 is for "TPT - To Part-Time"
        if (studyPlanCardinalTimeUnits.size() > 1 && !studyPlanCardinalTimeUnits.get(1).getProgressStatusCode().equals("29")) {
            for (int i = 1; i < studyPlanCardinalTimeUnits.size(); i++) {
                if (studyPlanCardinalTimeUnits.get(i).getProgressStatusCode().equals("29")) {
                    studyGradeTypeId = studyPlanCardinalTimeUnits.get(i - 1).getStudyGradeTypeId();
                    break;
                } else {
                    studyGradeTypeId = studyPlanCardinalTimeUnits.get(i).getStudyGradeTypeId();
                }
            }
        } else {
            studyGradeTypeId = studyPlanCardinalTimeUnits.get(0).getStudyGradeTypeId();
        }

        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        return studyGradeType.getCurrentAcademicYearId();
    }

    @Override
    public void allocateAccommodationResource(StudentAccommodationResource resource) {

        if (log.isInfoEnabled() || log.isDebugEnabled() || log.isTraceEnabled()) {
            log.info("allocating accommodation resource => " + resource);
        }

        accommodationMapper.allocateAccommodationResource(resource);

    }

    @Override
    public void deallocateAccommodationResource(int studentAccommodationResourceId, Date dateReturned, String commentWhenReturning) {
        if (log.isInfoEnabled() || log.isDebugEnabled() || log.isTraceEnabled()) {
            log.info("unallocating accommodation resource => " + getStudentAccommodationResource(studentAccommodationResourceId));
        }

        accommodationMapper.deallocateAccommodationResource(studentAccommodationResourceId, dateReturned, commentWhenReturning);
    }

    @Override
    public StudentAccommodationResource getStudentAccommodationResource(int id) {

        Map<String, Object> map = new HashMap<>();
        map.put("id", id);

        List<StudentAccommodationResource> list = accommodationMapper.findStudentAccommodationResourceByParams(map);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<StudentAccommodationResource> getStudentAccommodationResources(int studentAccommodationId) {

        if (log.isInfoEnabled() || log.isDebugEnabled() || log.isTraceEnabled()) {
            log.info("retrieving studentAccommodationResources for studentAccommodationId=>" + studentAccommodationId);
        }

        return accommodationMapper.findStudentAccommodationResourceByStudentAccommodationId(studentAccommodationId);
    }

    @Override
    public List<AccommodationResource> getAccommodationResources() {
        return accommodationMapper.getAccommodationResources();
    }

    @Override
    public void deleteStudentAccommodationResource(int id) {
        accommodationMapper.deleteStudentAccommodationResource(id);
    }
}