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

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.CareerPosition;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.GroupedDiscipline;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.LooseSecondarySchoolSubject;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Referee;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.persistence.CareerPositionMapper;
import org.uci.opus.college.persistence.ObtainedQualificationMapper;
import org.uci.opus.college.persistence.RefereeMapper;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.persistence.StudyplanDetailMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusInit;

/**
 * @author J.Nooitgedagt
 *
 */
public class StudyManager implements StudyManagerInterface {

    private static Logger log = LoggerFactory.getLogger(StudyManager.class);

    @Autowired
    private OpusInit opusInit;
    @Autowired
    private CareerPositionMapper careerPositionMapper;
    @Autowired
    private ObtainedQualificationMapper obtainedQualificationMapper;
    @Autowired
    private RefereeMapper refereeMapper;
    @Autowired
    private StudyMapper studyMapper;
    @Autowired
    private StudyplanDetailMapper studyplanDetailMapper;
    @Autowired
    private OpusUserManagerInterface opusUserManager;
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    @Autowired
    private AddressManagerInterface addressManager;
    @Autowired
    private LookupManagerInterface lookupManager;
    @Autowired
    private StudentManagerInterface studentManager;
    @Autowired
    private CollegeServiceExtensions collegeServiceExtensions;

    @Override
    public List<Study> findAllStudies() {

        return studyMapper.findAllStudies();
    }

    @Override
    public List<Study> findStudies(Map<String, Object> map) {
        return studyMapper.findStudies(map);
    }

    @Override
    public List<Study> findStudies(List<Integer> studyIds, String preferredLanguage) {

        Map<String, Object> map = new HashMap<>();
        map.put("studyIds", studyIds);
        map.put("preferredLanguage", preferredLanguage);
        List<Study> allStudies = studyMapper.findStudies(map);

        return allStudies;
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypesForAdmission(String language) {
        return studyMapper.findStudyGradeTypesForAdmission(language);
    }

    @Override
    public Study findStudy(int studyId) {
        return studyMapper.findStudy(studyId);
    }

    @Override
    public Study findStudyByNameUnit(Map<String, Object> map) {
        return studyMapper.findStudyByNameUnit(map);
    }

    @Override
    public List<Study> findAllStudiesForUniversities() {

        return studyMapper.findAllStudiesForUniversities();
    }

    @Override
    public List<Study> findAllStudiesForInstitution(int institutionId) {

        return studyMapper.findAllStudiesForInstitution(institutionId);
    }

    @Override
    public List<Study> findAllStudiesForBranch(int branchId) {

        return studyMapper.findAllStudiesForBranch(branchId);
    }

    @Override
    public List<Study> findAllStudiesForOrganizationalUnit(int organizationalUnitId) {

        return studyMapper.findAllStudiesForOrganizationalUnit(organizationalUnitId);
    }

    @Override
    public List<Subject> findSubjectsForStudy(int studyId) {

        List<Subject> allSubjects = null;

        allSubjects = studyMapper.findSubjectsForStudy(studyId);

        return allSubjects;
    }

    @Override
    public StudyGradeType findStudyGradeType(int studyGradeTypeId) {
        return studyMapper.findStudyGradeType(studyGradeTypeId);
    }

    @Override
    public StudyGradeType findStudyGradeType(int studyGradeTypeId, String language) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyGradeTypeId", studyGradeTypeId);
        map.put("preferredLanguage", language);
        return findStudyGradeTypeConsiderLanguage(map);
    }

    @Override
    public StudyGradeType findStudyGradeTypeConsiderLanguage(Map<String, Object> map) {
        return studyMapper.findStudyGradeTypeConsiderLanguage(map);
    }

    @Override
    public List<StudyGradeType> findAllStudyGradeTypesForStudy(Map<String, Object> findStudyGradeTypesMap) {

        List<StudyGradeType> allStudyGradeTypes = null;

        allStudyGradeTypes = studyMapper.findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);

        return allStudyGradeTypes;
    }

    @Override
    public List<StudyGradeType> findDistinctStudyGradeTypesForStudy(Map<String, Object> findStudyGradeTypesMap) {

        List<StudyGradeType> distinctStudyGradeTypes = null;

        distinctStudyGradeTypes = studyMapper.findDistinctStudyGradeTypesForStudy(findStudyGradeTypesMap);

        return distinctStudyGradeTypes;
    }

    @Override
    public List<StudyGradeType> findAllStudyGradeTypes() {

        List<StudyGradeType> allStudyGradeTypes = null;

        allStudyGradeTypes = studyMapper.findAllStudyGradeTypes();

        return allStudyGradeTypes;
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypes(Map<String, Object> map) {
        return studyMapper.findStudyGradeTypes(map);
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypes(List<Integer> studyGradeTypeIds, String preferredLanguage) {

        List<StudyGradeType> allStudyGradeTypes = null;

        Map<String, Object> map = new HashMap<>();
        map.put("studyGradeTypeIds", studyGradeTypeIds);
        map.put("preferredLanguage", preferredLanguage);
        allStudyGradeTypes = studyMapper.findStudyGradeTypes(map);

        return allStudyGradeTypes;
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypesByParams(Map<String, Object> map) {

        List<StudyGradeType> allStudyGradeTypes = null;

        allStudyGradeTypes = studyMapper.findStudyGradeTypes(map);

        return allStudyGradeTypes;
    }

    @Override
    public List<StudyGradeType> findGradeTypesForSubjectStudies(Map<String, Object> map) {

        List<StudyGradeType> allStudyGradeTypes = null;

        allStudyGradeTypes = studyMapper.findGradeTypesForSubjectStudies(map);

        return allStudyGradeTypes;
    }

    @Override
    public StudyGradeType findStudyGradeTypeByStudyAndGradeType(Map<String, Object> map) {

        StudyGradeType studyGradeType = studyMapper.findStudyGradeTypeByStudyAndGradeType(map);

        return studyGradeType;
    }

    @Override
    public StudyGradeType findStudyGradeTypeByParams(Map<String, Object> map) {

        StudyGradeType studyGradeType = null;

        studyGradeType = studyMapper.findStudyGradeTypeByParams(map);

        return studyGradeType;

    }

    @Override
    public StudyGradeType findPlainStudyGradeType(Map<String, Object> map) {
        return studyMapper.findPlainStudyGradeType(map);
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypePrerequisites(int studyGradeTypeId) {
        return studyMapper.findStudyGradeTypePrerequisites(studyGradeTypeId);
    }

    @Override
    public List<StudyPlan> findStudyPlansForStudyGradeType(int studyGradeTypeId) {
        return studyMapper.findStudyPlansForStudyGradeType(studyGradeTypeId);
    }

    @Override
    public List<StudyPlanDetail> findStudyPlanDetailsForSubjectBlock(int subjectBlockId) {
        return studyplanDetailMapper.findStudyPlanDetailsForSubjectBlock(subjectBlockId);
    }

    @Override
    public List<AcademicYear> findAllAcademicYears(Map<String, Object> map) {

        List<AcademicYear> allAcademicYears = null;
        allAcademicYears = studyMapper.findAllAcademicYears(map);

        return allAcademicYears;
    }

    @Override
    public AcademicYear findAcademicYear(int academicYearId) {
        return studyMapper.findAcademicYear(academicYearId);
    }

    @Override
    public int findAcademicYearIdForStudyGradeTypeId(int studyGradeTypeId) {
        return studyMapper.findAcademicYearIdForStudyGradeTypeId(studyGradeTypeId);
    }

    @Override
    public void addStudy(Study study) {
        studyMapper.addStudy(study);

    }

    @Override
    @Transactional
    public void updateStudy(Study study) {

        // check if orgUnitid has changed, if yes, update accordingly opususerrole.orgUnitId and
        // opususer.preferredorgUnitId
        // for those students that are subscribed to the study.

        Study currentStudy = findStudy(study.getId());
        int oldOrganizationalUnitId = currentStudy.getOrganizationalUnitId();
        int newOrganizationalUnitId = study.getOrganizationalUnitId();
        if (oldOrganizationalUnitId != newOrganizationalUnitId) {
            // if orgUnit has changed, update opususerrole.orgUnitid and
            // opususer.preferredorganizationalunitid
            // for affected students

            // update orgUnitId only of those students that are subscribed to the study in question
            List<OpusUserRole> opusUserRoles = opusUserManager.findOpusUserRolesForStudy(study.getId());
            for (OpusUserRole opusUserRole : opusUserRoles) {
                opusUserRole.setOrganizationalUnitId(newOrganizationalUnitId);
                opusUserManager.updateOpusUserRole(opusUserRole);
            }

        }

        studyMapper.updateStudy(study);
    }

    @Override
    public void deleteStudy(int studyId) {

        addressManager.deleteAddressesForStudy(studyId);

        studyMapper.deleteStudy(studyId);
    }

    @Override
    public void addStudyGradeType(StudyGradeType studyGradeType) {

        studyMapper.addStudyGradeType(studyGradeType);

        // get the newly assigned id
        int studyGradeTypeId = studyGradeType.getId();

        // insert cardinalTimeUnitStudyGradeTypes
        if (studyGradeType.getCardinalTimeUnitStudyGradeTypes() != null) {
            for (int i = 0; i < studyGradeType.getCardinalTimeUnitStudyGradeTypes().size(); i++) {
                CardinalTimeUnitStudyGradeType ct = studyGradeType.getCardinalTimeUnitStudyGradeTypes().get(i);
                ct.setStudyGradeTypeId(studyGradeTypeId);
                studyMapper.addCardinalTimeUnitStudyGradeType(ct);
            }
        }
    }

    @Override
    public boolean alreadyExistsStudyGradeTypeCode(int id, int academicYearId, String studyGradeTypeCode) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("currentAcademicYearId", academicYearId);
        map.put("studyGradeTypeCode", studyGradeTypeCode);
        return studyMapper.alreadyExistsStudyGradeTypeCode(map);
    }

    @Override
    public boolean alreadyExistsStudyGradeTypeCode(StudyGradeType studyGradeType) {
        return alreadyExistsStudyGradeTypeCode(studyGradeType.getId(), studyGradeType.getCurrentAcademicYearId(), studyGradeType.getStudyGradeTypeCode());
    }

    @Override
    public void updateStudyGradeType(StudyGradeType studyGradeType) {

        studyMapper.updateStudyGradeType(studyGradeType);

        // first delete all CardinalTimeUnitStudyGradeTypes for this studygradetypeid
        studyMapper.deleteCardinalTimeUnitStudyGradeTypes(studyGradeType.getId());

        // then insert new ones
        if (studyGradeType.getCardinalTimeUnitStudyGradeTypes() != null) {
            for (int i = 0; i < studyGradeType.getCardinalTimeUnitStudyGradeTypes().size(); i++) {
                CardinalTimeUnitStudyGradeType ct = studyGradeType.getCardinalTimeUnitStudyGradeTypes().get(i);
                studyMapper.addCardinalTimeUnitStudyGradeType(ct);
            }
        }
    }

    @Override
    public void deleteStudyGradeType(int studyGradeTypeId, HttpServletRequest request) {

        // first delete all CardinalTimeUnitStudyGradeTypes for this studygradetype
        studyMapper.deleteCardinalTimeUnitStudyGradeTypes(studyGradeTypeId);

        // for(Module module:modules){
        // if ("fee".equals(module.getModule())) {
        // // then delete fees that are bound to the studygradetype
        // feeManager.deleteFeesForStudyGradeType(studyGradeTypeId, request);
        // }
        // }
        collegeServiceExtensions.beforeStudyGradeTypeDelete(studyGradeTypeId, request);

        // delete possibly existing prerequisites
        studyMapper.deleteStudyGradeTypePrerequisites(studyGradeTypeId);

        studyMapper.deleteStudyGradeType(studyGradeTypeId);
    }

    @Override
    public void addStudyGradeTypePrerequisite(StudyGradeTypePrerequisite prerequisite) {
        studyMapper.addStudyGradeTypePrerequisite(prerequisite);
    }

    @Override
    public void deleteStudyGradeTypePrerequisite(StudyGradeTypePrerequisite prerequisite) {
        studyMapper.deleteStudyGradeTypePrerequisite(prerequisite);
    }

    @Override
    public int findMaxAcademicYearForStudyGradeType(Map<String, Object> map) {
        return studyMapper.findMaxAcademicYearForStudyGradeType(map);
    }

    @Override
    public CardinalTimeUnitStudyGradeType findCardinalTimeUnitStudyGradeTypeByParams(Map<String, Object> map) {
        CardinalTimeUnitStudyGradeType cardinalTimeUnitStudyGradeType = null;
        cardinalTimeUnitStudyGradeType = studyMapper.findCardinalTimeUnitStudyGradeTypeByParams(map);
        return cardinalTimeUnitStudyGradeType;
    }

    @Override
    public List<CardinalTimeUnitStudyGradeType> findCardinalTimeUnitStudyGradeTypes(int studyGradeTypeId) {
        return studyMapper.findCardinalTimeUnitStudyGradeTypes(studyGradeTypeId);
    }

    @Override
    public int countSubjectsInStudyPlanDetails(List<StudyPlanDetail> studyPlanDetails) {
        int totalNumberOfSubjects = 0;

        for (int i = 0; i < studyPlanDetails.size(); i++) {
            if (studyPlanDetails.get(i).getSubjectId() != 0) {
                totalNumberOfSubjects = totalNumberOfSubjects + 1;
            } else if (studyPlanDetails.get(i).getSubjectBlockId() != 0) {
                SubjectBlock subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetails.get(i).getSubjectBlockId());
                if (subjectBlock != null && subjectBlock.getSubjectSubjectBlocks() != null) {
                    totalNumberOfSubjects = totalNumberOfSubjects + subjectBlock.getSubjectSubjectBlocks().size();
                }
            } else {
                log.warn("studyplandetail (id = " + studyPlanDetails.get(i).getId()
                        + ") has both subjectId = 0 and subjectBlockId = 0. This should never happen");
            }
        }
        return totalNumberOfSubjects;
    }

    @Override
    public int findMaxCardinalTimeUnitNumberForStudyGradeType(int studyGradeTypeId) {

        Integer maxCardinalTimeUnitNumber = studyMapper.findMaxCardinalTimeUnitNumberForStudyGradeType(studyGradeTypeId);

        // if (maxCardinalTimeUnitNumber == null) {
        // maxCardinalTimeUnitNumber =
        // studyMapper.findNumberOfCardinalTimeUnitsForStudyGradeType(studyGradeTypeId);
        // }

        return maxCardinalTimeUnitNumber;

    }

    @Override
    public int findNumberOfCardinalTimeUnitsForStudyGradeType(int studyGradeTypeId) {

        return studyMapper.findNumberOfCardinalTimeUnitsForStudyGradeType(studyGradeTypeId);

    }

    @Override
    public int findNumberOfCardinalTimeUnitsForStudyAndGradeType(Map<String, Object> map) {

        int numberOfCardinalTimeUnits = 0;
        numberOfCardinalTimeUnits = studyMapper.findNumberOfCardinalTimeUnitsForStudyAndGradeType(map);
        return numberOfCardinalTimeUnits;

    }

    @Override
    public int findNumberOfCardinalTimeUnitsForStudyPlan(int studyPlanId) {

        int numberOfCardinalTimeUnits = 0;
        numberOfCardinalTimeUnits = studyMapper.findNumberOfCardinalTimeUnitsForStudyPlan(studyPlanId);
        return numberOfCardinalTimeUnits;

    }

    @Override
    public List<EndGrade> findAllEndGrades(Map<String, Object> map) {

        return studyMapper.findAllEndGrades(map);
    }

    @Override
    public String findEndGradeType(int academicYearId) {

        return studyMapper.findEndGradeType(academicYearId);
    }

    @Override
    public boolean useEndGrades() {
        return useEndGrades(0);
    }

    @Override
    public boolean useEndGrades(int academicYearId) {

        String randomGradeTypeForAcademicYear = this.findEndGradeType(academicYearId);
        boolean endGradesPerGradeType = StringUtils.isNotBlank(randomGradeTypeForAcademicYear);
        return endGradesPerGradeType;
    }

    @Override
    public BigDecimal findMinimumEndGradeForGradeType(Map<String, Object> map) {

        BigDecimal bd = studyMapper.findMinimumEndGradeForGradeType(map);
        return bd == null ? BigDecimal.ZERO : bd;
    }

    @Override
    public BigDecimal findMaximumEndGradeForGradeType(Map<String, Object> map) {

        BigDecimal bd = studyMapper.findMaximumEndGradeForGradeType(map);
        return bd == null ? BigDecimal.ZERO : bd;
    }

    @Override
    public Lookup findGradeTypeByStudyGradeTypeId(int studyGradeTypeId, String language) {
        return studyMapper.findGradeTypeByStudyGradeTypeId(studyGradeTypeId, language);
    }

    @Override
    public List<SecondarySchoolSubject> findSecondarySchoolSubjects(int secondarySchoolSubjectGroupId, String preferredLanguage) {

        Map<String, Object> map = new HashMap<>();
        map.put("secondarySchoolSubjectGroupId", secondarySchoolSubjectGroupId);
        map.put("preferredLanguage", preferredLanguage);

        return studyMapper.findSecondarySchoolSubjects(map);
    }

    @Override
    public List<SecondarySchoolSubject> findSecondarySchoolSubjectsForStudyPlan(Map<String, Object> map) {

        return studyMapper.findSecondarySchoolSubjectsForStudyPlan(map);
    }

    @Override
    public List<SecondarySchoolSubject> findSecondarySchoolSubjects(Map<String, Object> map) {

        return studyMapper.findSecondarySchoolSubjects(map);
    }

    @Override
    public List<SecondarySchoolSubject> findUngroupedSecondarySchoolSubjectsForStudyPlan(Map<String, Object> map) {
        // add 0 to the map
        map.put("secondarySchoolSubjectGroupId", 0);

        return studyMapper.findSecondarySchoolSubjectsForStudyPlan(map);
    }

    @Override
    public List<SecondarySchoolSubject> findAllSecondarySchoolSubjects() {
        return studyMapper.findAllSecondarySchoolSubjects();
    }

    @Override
    public List<SecondarySchoolSubjectGroup> findSecondarySchoolSubjectGroups(int studyGradeTypeId, String preferredLanguage) {
        List<SecondarySchoolSubjectGroup> groupList = studyMapper.findSecondarySchoolSubjectGroups(studyGradeTypeId);
        for (SecondarySchoolSubjectGroup oneGroup : groupList) {
            List<SecondarySchoolSubject> secondarySchoolSubjects = this.findSecondarySchoolSubjects(oneGroup.getId(), preferredLanguage);
            oneGroup.setSecondarySchoolSubjects(secondarySchoolSubjects);
        }

        return groupList;
    }

    @Override
    public List<SecondarySchoolSubjectGroup> findSecondarySchoolSubjectGroupsForStudyPlan(Map<String, Object> map) {

        int studyPlanId = 0;

        List<SecondarySchoolSubjectGroup> selectedGroupList = new ArrayList<>();
        studyPlanId = (Integer) map.get("studyPlanId");

        // extend the map with a default weight
        map.put("defaultWeight", 1);

        List<SecondarySchoolSubjectGroup> groupList = studyMapper.findSecondarySchoolSubjectGroupsForStudyPlan(studyPlanId);
        List<StudyPlanCardinalTimeUnit> lowestStudyPlanCTUs = studentManager.findLowestStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);

        if (lowestStudyPlanCTUs != null && lowestStudyPlanCTUs.size() != 0) {
            // fetch only the groups from the list with the right studygradetype
            for (int i = 0; i < groupList.size(); i++) {
                if (groupList.get(i).getStudyGradeTypeId() == lowestStudyPlanCTUs.get(0).getStudyGradeTypeId()) {

                    selectedGroupList.add(groupList.get(i));
                }
            }

            for (SecondarySchoolSubjectGroup oneGroup : selectedGroupList) {

                map.put("secondarySchoolSubjectGroupId", oneGroup.getId());

                List<SecondarySchoolSubject> secondarySchoolSubjects = this.findSecondarySchoolSubjectsForStudyPlan(map);

                oneGroup.setSecondarySchoolSubjects(secondarySchoolSubjects);
            }
        }

        return selectedGroupList;
    }

    @Override
    public List<SecondarySchoolSubject> findGradedSecondarySchoolSubjectsForStudyPlan(int studyPlanId) {

        List<SecondarySchoolSubject> gradedSecondarySchoolSubjects = new ArrayList<>();
        SecondarySchoolSubject gradedSecondarySchoolSubject = null;
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);

        List<Integer> selectedIdList = studyMapper.findGradedSecondarySchoolSubjectIdsForStudyPlan(map);

        for (int i = 0; i < selectedIdList.size(); i++) {
            map.put("gradedSecondarySchoolSubjectId", selectedIdList.get(i).intValue());

            gradedSecondarySchoolSubject = studyMapper.findGradedSecondarySchoolSubjectForStudyPlan(map);

            gradedSecondarySchoolSubjects.add(gradedSecondarySchoolSubject);
        }

        return gradedSecondarySchoolSubjects;
    }

    @Override
    public List<SecondarySchoolSubject> findGradedUngroupedSecondarySchoolSubjectsForStudyPlan(int studyPlanId) {

        List<SecondarySchoolSubject> gradedUngroupedSecondarySchoolSubjects = new ArrayList<>();
        SecondarySchoolSubject gradedUngroupedSecondarySchoolSubject = null;
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("secondarySchoolSubjectGroupId", 0);

        List<Integer> selectedIdList = studyMapper.findGradedSecondarySchoolSubjectIdsForStudyPlan(map);

        for (int i = 0; i < selectedIdList.size(); i++) {
            map.put("gradedSecondarySchoolSubjectId", selectedIdList.get(i).intValue());

            gradedUngroupedSecondarySchoolSubject = studyMapper.findGradedSecondarySchoolSubjectForStudyPlan(map);

            gradedUngroupedSecondarySchoolSubjects.add(gradedUngroupedSecondarySchoolSubject);
        }

        return gradedUngroupedSecondarySchoolSubjects;
    }

    @Override
    public SecondarySchoolSubjectGroup findSecondarySchoolSubjectGroup(String preferredLanguage, int studyGradeTypeId, int groupId) {

        SecondarySchoolSubjectGroup secondarySchoolSubjectGroup = studyMapper.findSecondarySchoolSubjectGroup(groupId);

        if (secondarySchoolSubjectGroup != null) {

            List<SecondarySchoolSubject> secondarySchoolSubjects = this.findSecondarySchoolSubjects(secondarySchoolSubjectGroup.getId(), preferredLanguage);
            secondarySchoolSubjectGroup.setSecondarySchoolSubjects(secondarySchoolSubjects);
        }

        return secondarySchoolSubjectGroup;
    }

    /**
     * Just create this pojo, then call 'fillSecondarySchoolSubject' to add subject descriptions.
     * 
     * @param secondarySchoolSubjectId
     * @param studyGradeTypeId
     * @param preferredLanguage
     * @return
     */
    @Override
    public SecondarySchoolSubject createSecondarySchoolSubject(int secondarySchoolSubjectId, int studyGradeTypeId, String preferredLanguage) {

        SecondarySchoolSubject secondarySchoolSubject = new SecondarySchoolSubject(secondarySchoolSubjectId, studyGradeTypeId);

        return secondarySchoolSubject;
    }

    /**
     * Add new SecondarySchoolSubjectGroup, insert the group and the list of secondarySchoolSubjects.
     * 
     * @param secondarySchoolSubjectGroup
     *            to insert.
     */
    @Override
    public void insertSecondarySchoolSubjectGroup(SecondarySchoolSubjectGroup secondarySchoolSubjectGroup) {

        int groupNumber = studyMapper.getMaxSecondarySchoolSubjectGroupNumber(secondarySchoolSubjectGroup.getStudyGradeTypeId());
        secondarySchoolSubjectGroup.setGroupNumber(groupNumber);

        int groupId = studyMapper.insertSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);

        if (secondarySchoolSubjectGroup.getSecondarySchoolSubjects() != null) {
            for (SecondarySchoolSubject secondarySchoolSubject : secondarySchoolSubjectGroup.getSecondarySchoolSubjects()) {
                secondarySchoolSubject.setSecondarySchoolSubjectGroupId(groupId);
                studyMapper.insertGroupedSecondarySchoolSubject(secondarySchoolSubject);
            }
        }
    }

    /**
     * Update existing secondarySchoolSubjectGroup
     * 
     * @param secondarySchoolSubjectGroup
     */
    @Override
    public void updateSecondarySchoolSubjectGroup(SecondarySchoolSubjectGroup secondarySchoolSubjectGroup) {

        studyMapper.updateSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup);
        studyMapper.deleteGroupedSecondarySchoolSubjectList(secondarySchoolSubjectGroup.getId());

        if (secondarySchoolSubjectGroup.getSecondarySchoolSubjects() != null) {
            for (SecondarySchoolSubject secondarySchoolSubject : secondarySchoolSubjectGroup.getSecondarySchoolSubjects()) {
                studyMapper.insertGroupedSecondarySchoolSubject(secondarySchoolSubject);
            }
        }
    }

    /**
     * Delete existing secondarySchoolSubjectGroup
     * 
     * @param secondarySchoolSubjectGroup
     *            to delete
     */
    @Override
    public void deleteSecondarySchoolSubjectGroup(SecondarySchoolSubjectGroup secondarySchoolSubjectGroup) {

        studyMapper.deleteGroupedSecondarySchoolSubjectList(secondarySchoolSubjectGroup.getId());
        studyMapper.deleteSecondarySchoolSubjectGroup(secondarySchoolSubjectGroup.getId());
    }

    @Override
    public void addGradedSecondarySchoolSubject(SecondarySchoolSubject secondarySchoolSubject, int studyPlanId, int groupId, String writeWho) {

        Map<String, Object> map = new HashMap<>();
        map.put("secondarySchoolSubject", secondarySchoolSubject);
        map.put("studyPlanId", studyPlanId);
        map.put("groupId", groupId);
        map.put("writeWho", writeWho);

        studyMapper.addGradedSecondarySchoolSubject(map);
    }

    @Override
    public void updateGradedSecondarySchoolSubject(SecondarySchoolSubject secondarySchoolSubject, int studyPlanId, int groupId, String writeWho) {

        Map<String, Object> map = new HashMap<>();
        map.put("secondarySchoolSubject", secondarySchoolSubject);
        map.put("studyPlanId", studyPlanId);
        map.put("groupId", groupId);
        map.put("writeWho", writeWho);

        studyMapper.updateGradedSecondarySchoolSubject(map);
    }

    @Override
    public void deleteGradedSecondarySchoolSubject(SecondarySchoolSubject secondarySchoolSubject, int studyPlanId, String writeWho) {
        Map<String, Object> map = new HashMap<>();
        map.put("secondarySchoolSubject", secondarySchoolSubject);
        map.put("studyPlanId", studyPlanId);
        map.put("writeWho", writeWho);

        studyMapper.deleteGradedSecondarySchoolSubject(map);
    }

    @Override
    public List<EndGrade> findFullEndGradeCommentsForGradeType(Map<String, Object> map) {

        List<EndGrade> allEndGrades = new ArrayList<>();
        List<EndGrade> allGradeTypeComments = new ArrayList<>();
        List<EndGrade> allFailGradeComments = new ArrayList<>();
        List<EndGrade> allEndGradeGeneralComments = new ArrayList<>();
        String preferredLanguage = (String) map.get("preferredLanguage");
        String endGradeType = (String) map.get("endGradeTypeCode");

        allGradeTypeComments = studyMapper.findFullEndGradeCommentsForGradeType(map);
        allEndGrades.addAll(allGradeTypeComments);
        if (log.isDebugEnabled()) {
            log.debug("StudyManager.findFullEndGradeCommentsForGradeType: after findEndGradeCommentsForGradeType " + "- allEndGrades.size() = "
                    + allEndGrades.size());
        }

        // extend this list with the general grades (endgradegeneral)
        allEndGradeGeneralComments = studyMapper.findFullEndGradeCommentsForGeneralGrades(preferredLanguage);
        allEndGrades.addAll(allEndGradeGeneralComments);
        if (log.isDebugEnabled()) {
            log.debug("StudyManager.findFullEndGradeCommentsForGradeType: after findEndGradeCommentsForGeneralGrades " + "- allEndGrades.size() = "
                    + allEndGrades.size());
        }

        // extend this list with the failgrades (failgrade)
        if (!OpusConstants.ATTACHMENT_RESULT.equals(endGradeType)) {
            allFailGradeComments = studyMapper.findFullEndGradeCommentsForFailGrades(preferredLanguage);
            allEndGrades.addAll(allFailGradeComments);
            if (log.isDebugEnabled()) {
                log.debug("StudyManager.findFullEndGradeCommentsForGradeType: after findEndGradeCommentsForFailGrades " + "- allEndGrades.size() = "
                        + allEndGrades.size());
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("StudyManager.findFullEndGradeCommentsForGradeType: findEndGradeCommentsForFailGrades not executed because of attachment result "
                        + "- allEndGrades.size() = " + allEndGrades.size());
            }
        }
        return allEndGrades;
    }

    @SuppressWarnings("unchecked")
    @Override
    public Map<String, List<EndGrade>> findEndGradeTypeCodeToFullEndGradesMap(Map<String, Object> map) {

        Map<String, List<EndGrade>> gradeTypeCodeToCommentMap = new HashMap<>();

        Map<String, Object> findMap = new HashMap<>(map);
        for (String endGradeTypeCode : (Collection<String>) map.get("endGradeTypeCodes")) {
            findMap.put("endGradeTypeCode", endGradeTypeCode);

            gradeTypeCodeToCommentMap.put(endGradeTypeCode, findFullEndGradeCommentsForGradeType(findMap));
        }

        return gradeTypeCodeToCommentMap;
    }

    @Override
    public List<EndGrade> findFullFailGradeCommentsForGradeType(Map<String, Object> map) {

        List<EndGrade> allEndGrades = new ArrayList<>();
        List<EndGrade> allGradeTypeComments = new ArrayList<>();
        List<EndGrade> allFailGradeComments = new ArrayList<>();
        List<EndGrade> allEndGradeGeneralComments = new ArrayList<>();
        String preferredLanguage = (String) map.get("preferredLanguage");
        String endGradeType = (String) map.get("endGradeTypeCode");

        allGradeTypeComments = studyMapper.findFullFailEndGradeCommentsForGradeType(map);
        allEndGrades.addAll(allGradeTypeComments);
        if (log.isDebugEnabled()) {
            log.debug("StudyManager.findFullFailGradeCommentsForGradeType: after findEndGradeCommentsForGradeType " + "- allEndGrades.size() = "
                    + allEndGrades.size());
        }

        // extend this list with the general grades (endgradegeneral)
        allEndGradeGeneralComments = studyMapper.findFullEndGradeCommentsForGeneralGrades(preferredLanguage);
        allEndGrades.addAll(allEndGradeGeneralComments);
        if (log.isDebugEnabled()) {
            log.debug("ResultManager.findFullFailGradeCommentsForGradeType: after findEndGradeCommentsForGeneralGrades " + "- allEndGrades.size() = "
                    + allEndGrades.size());
        }

        // extend this list with the failgrades (failgrade)
        if (!OpusConstants.ATTACHMENT_RESULT.equals(endGradeType)) {
            allFailGradeComments = studyMapper.findFullEndGradeCommentsForFailGrades(preferredLanguage);
            allEndGrades.addAll(allFailGradeComments);
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.findFullFailGradeCommentsForGradeType: after findEndGradeCommentsForFailGrades " + "- allEndGrades.size() = "
                        + allEndGrades.size());
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultManager.findFullFailGradeCommentsForGradeType: findEndGradeCommentsForFailGrades not executed because of attachment result "
                        + "- allEndGrades.size() = " + allEndGrades.size());
            }
        }

        return allEndGrades;
    }

    @SuppressWarnings("unchecked")
    @Override
    public Map<String, List<EndGrade>> findEndGradeTypeCodeToFullFailGradesMap(Map<String, Object> map) {

        Map<String, List<EndGrade>> gradeTypeCodeToCommentMap = new HashMap<>();

        Map<String, Object> findMap = new HashMap<>(map);
        for (String endGradeTypeCode : (Collection<String>) map.get("endGradeTypeCodes")) {
            findMap.put("endGradeTypeCode", endGradeTypeCode);

            gradeTypeCodeToCommentMap.put(endGradeTypeCode, findFullFailGradeCommentsForGradeType(findMap));
        }

        return gradeTypeCodeToCommentMap;
    }

    @Override
    public List<StudyGradeType> findStudyGradeTypesForStudyPlan(int studyPlanId) {
        return studyMapper.findStudyGradeTypesForStudyPlan(studyPlanId);
    }

    @Override
    public void addObtainedQualification(ObtainedQualification obtainedQualification) {
        obtainedQualificationMapper.addObtainedQualification(obtainedQualification);
    }

    @Override
    public void deleteObtainedQualification(int obtainedQualificationId) {
        obtainedQualificationMapper.deleteObtainedQualification(obtainedQualificationId);
    }

    @Override
    public void deleteObtainedQualificationsByStudyPlanId(int studyPlanId) {
        obtainedQualificationMapper.deleteObtainedQualificationsByStudyPlanId(studyPlanId);
    }

    @Override
    public List<ObtainedQualification> findObtainedQualificationsByStudyPlanId(int studyPlanId) {
        return obtainedQualificationMapper.findObtainedQualificationsByStudyPlanId(studyPlanId);
    }

    @Override
    public void addCareerPosition(CareerPosition careerPosition) {
        careerPositionMapper.addCareerPosition(careerPosition);
    }

    @Override
    public void deleteCareerPosition(int careerPositionId) {

        careerPositionMapper.deleteCareerPosition(careerPositionId);
    }

    @Override
    public void deleteCareerPositionsByStudyPlanId(int studyPlanId) {

        careerPositionMapper.deleteCareerPositionsByStudyPlanId(studyPlanId);
    }

    @Override
    public List<CareerPosition> findCareerPositionsByStudyPlanId(int studyPlanId) {
        return careerPositionMapper.findCareerPositionsByStudyPlanId(studyPlanId);
    }

    @Override
    public void addReferee(Referee referee) {
        refereeMapper.addReferee(referee);
    }

    @Override
    public void updateReferee(Referee referee) {
        refereeMapper.updateReferee(referee);
    }

    @Override
    public void deleteReferee(int refereeId) {
        refereeMapper.deleteReferee(refereeId);
    }

    @Override
    public void deleteRefereesByStudyPlanId(int studyPlanId) {

        refereeMapper.deleteRefereesByStudyPlanId(studyPlanId);
    }

    @Override
    public List<Referee> findRefereesByStudyPlanId(int studyPlanId) {
        return refereeMapper.findRefereesByStudyPlanId(studyPlanId);
    }

    @Override
    public void adaptReferees(StudyPlan studyPlan) {
        // may have size 0, 1 or 2
        List<Referee> savedReferees = refereeMapper.findRefereesByStudyPlanId(studyPlan.getId());
        // always 2
        Referee firstReferee = studyPlan.getAllReferees().get(0);
        Referee secondReferee = studyPlan.getAllReferees().get(1);
        if (savedReferees.size() != 0) {
            refereeMapper.deleteRefereesByStudyPlanId(studyPlan.getId());
        }
        // insert if referee(s) present
        if (!firstReferee.isEmpty()) {
            refereeMapper.addReferee(firstReferee);
        }
        if (!secondReferee.isEmpty()) {
            refereeMapper.addReferee(secondReferee);
        }
    }

    @Override
    public List<Lookup> findDisciplinesForGroup(Map<String, Object> map) {
        return studyMapper.findDisciplinesForGroup(map);
    }

    @Override
    public int findNrOfEndgradesToTransfer(Map<String, Object> map) {
        return studyMapper.findNrOfEndgradesToTransfer(map);
    }

    @Override
    public List<Integer> findStudyPlansByStudyId(int studyId) {
        return studyMapper.findStudyPlansByStudyId(studyId);
    }

    @Override
    public Branch findBranchByStudyPlanId(int studyPlanId) {
        return studyMapper.findBranchByStudyPlanId(studyPlanId);
    }

    /* ##################### LooseSecondarySchoolSubjects queries ############################### */

    @Override
    public List<LooseSecondarySchoolSubject> findLooseSecondarySchoolSubjects(Map<String, Object> map) {
        return studyMapper.findLooseSecondarySchoolSubjects(map);
    }

    @Override
    public void deleteLooseSecondarySchoolSubject(Map<String, Object> map) {
        studyMapper.deleteLooseSecondarySchoolSubject(map);
    }

    @Override
    public void deleteLooseSecondarySchoolSubjectById(int id) {

        Map<String, Object> map = new HashMap<>();

        map.put("id", id);

        studyMapper.deleteLooseSecondarySchoolSubject(map);
    }

    @Override
    public void updateLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject) {
        studyMapper.updateLooseSecondarySchoolSubject(looseSecondarySchoolSubject);
    }

    @Override
    public void addLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject) {
        studyMapper.addLooseSecondarySchoolSubject(looseSecondarySchoolSubject);
    }

    @Override
    public LooseSecondarySchoolSubject findLooseSecondarySchoolSubject(Map<String, Object> map) {
        return studyMapper.findLooseSecondarySchoolSubject(map);
    }

    @Override
    public LooseSecondarySchoolSubject findLooseSecondarySchoolSubjectById(int id) {

        Map<String, Object> map = new HashMap<>();
        map.put("id", id);

        return studyMapper.findLooseSecondarySchoolSubject(map);
    }

    /* ##################### DisciplineGroups queries ############################### */

    // @Override
    // public List<DisciplineGroup> findDisciplineGroups(
    // Map<String, Object> map) {
    // return studyMapper.findDisciplineGroups(map);
    // }
    //
    // @Override
    // public void deleteDisciplineGroup(Map<String, Object> map) {
    // studyMapper.deleteDisciplineGroup(map);
    // }
    //
    // @Override
    // public void deleteDisciplineGroupById(int id) {
    //
    // Map<String, Object> map = new HashMap<>();
    //
    // map.put("id", id);
    //
    // studyMapper.deleteDisciplineGroup(map);
    // }
    //
    //
    // @Override
    // public void updateDisciplineGroup(
    // DisciplineGroup disciplineGroup) {
    // studyMapper.updateDisciplineGroup(disciplineGroup);
    // }
    //
    // @Override
    // public int addDisciplineGroup(
    // DisciplineGroup disciplineGroup) {
    // return studyMapper.addDisciplineGroup(disciplineGroup);
    // }
    //
    //
    // @Override
    // public DisciplineGroup findDisciplineGroup(
    // Map<String, Object> map) {
    // return studyMapper.findDisciplineGroup(map);
    // }
    //
    // @Override
    // public DisciplineGroup findDisciplineGroupById(int id) {
    //
    // Map<String, Object> map = new HashMap<>();
    // map.put("id", id);
    //
    // return studyMapper.findDisciplineGroup(map);
    // }
    //
    // @Override
    // public List<Map<String, Object>> findDisciplineGroupsAsMaps(
    // Map<String, Object> map) {
    // return studyMapper.findDisciplineGroupsAsMaps(map);
    // }

    @Override
    public int findNrOfUnitsPerYearForCardinalTimeUnitCode(String cardinalTimeUnitCode) {
        return studyMapper.findNrOfUnitsPerYearForCardinalTimeUnitCode(cardinalTimeUnitCode);
    }

    /* ##################### GroupedDiscipline queries ############################### */

    @Override
    public void addGroupedDiscipline(GroupedDiscipline groupedDiscipline) {
        studyMapper.addGroupedDiscipline(groupedDiscipline);
    }

    @Override
    public void deleteGroupedDiscipline(Map<String, Object> map) {
        studyMapper.deleteGroupedDiscipline(map);
    }

    @Override
    public void addGroupedDisciplines(List<GroupedDiscipline> groupedDisciplines) {

        for (GroupedDiscipline groupedDiscipline : groupedDisciplines)
            studyMapper.addGroupedDiscipline(groupedDiscipline);

    }

    @Override
    public List<Lookup> findDisciplinesNotInGroup(Map<String, Object> map) {
        return studyMapper.findDisciplinesNotInGroup(map);
    }

    @Override
    public List<Lookup> findDisciplinesNotInGroup(int disciplineGroupId, String lang) {

        Map<String, Object> map = new HashMap<>();

        map.put("disciplineGroupId", disciplineGroupId);
        map.put("lang", lang);

        return studyMapper.findDisciplinesNotInGroup(map);
    }

    @Override
    public List<Lookup> findDisciplinesForGroup(int disciplineGroupId, String lang) {

        Map<String, Object> map = new HashMap<>();

        map.put("disciplineGroupId", disciplineGroupId);
        map.put("lang", lang);

        return studyMapper.findDisciplinesForGroup(map);
    }

    @Override
    public void deleteGroupedDiscipline(int disciplineGroupId, String disciplineCode) {

        Map<String, Object> map = new HashMap<>();

        map.put("disciplineGroupId", disciplineGroupId);
        map.put("disciplineCode", disciplineCode);

        deleteGroupedDiscipline(map);

    }

    @Override
    public Map<String, Object> findDisciplineDependencies(Map<String, Object> params) {
        return studyMapper.findDisciplineDependencies(params);
    }

    @Override
    public Map<String, Object> findDisciplineDependencies(String disciplineCode) {

        Map<String, Object> map = new HashMap<>();
        map.put("disciplineCode", disciplineCode);

        return findDisciplineDependencies(map);
    }

    @Override
    public void deleteDiscipline(String disciplineCode) {

        Map<String, Object> map = new HashMap<>();

        map.put("disciplineCode", disciplineCode);

        // delete discipline
        lookupManager.deleteLookupByCode(null, disciplineCode, "discipline");

        // delete GroupDisciplines associated to it
        deleteGroupedDiscipline(map);

    }

    @Override
    public String findGradeTypeCodeForStudyPlanDetail(int studyPlanDetailId) {
        return studyMapper.findGradeTypeCodeForStudyPlanDetail(studyPlanDetailId);
    }

    public void setAddressManager(AddressManagerInterface addressManager) {
        this.addressManager = addressManager;
    }

    public void setLookupManager(LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }

    public void setStudentManager(StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public void setCollegeServiceExtensions(CollegeServiceExtensions collegeServiceExtensions) {
        this.collegeServiceExtensions = collegeServiceExtensions;
    }

    @Override
    public Classgroup findClassgroupById(int classgroupId) {
        return studyMapper.findClassgroupById(classgroupId);
    }

    @Override
    public List<Classgroup> findClassgroups(Map<String, Object> map) {
        return studyMapper.findClassgroups(map);
    }

    @Override
    public List<Classgroup> findClassgroupsBySubjectId(int subjectId) {
        Map<String, Object> findClassgroupsMap = new HashMap<>();
        findClassgroupsMap.put("subjectId", subjectId);
        return this.findClassgroups(findClassgroupsMap);
    }

    @Override
    public int findClassgroupCount(Map<String, Object> map) {
        return studyMapper.findClassgroupCount(map);
    }

    @Override
    public void updateClassgroup(Classgroup classgroup, String writeWho) {
        classgroup.setWriteWho(writeWho);

        studyMapper.updateClassgroup(classgroup);
    }

    @Override
    public void addClassgroup(Classgroup classgroup, String writeWho) {
        classgroup.setWriteWho(writeWho);

        studyMapper.addClassgroup(classgroup);
    }

    @Override
    public void deleteClassgroup(int classgroupId) {
        studyMapper.deleteClassgroup(classgroupId);
    }

    @Override
    public void addStudentClassgroup(int studentId, int classgroupId, String writeWho) {
        studyMapper.addStudentClassgroup(studentId, classgroupId, writeWho);
    }

    @Override
    public void deleteStudentClassgroup(int studentId, int classgroupId) {
        studyMapper.deleteStudentClassgroup(studentId, classgroupId);
    }

    @Override
    public void addSubjectClassgroup(int subjectId, int classgroupId, String writeWho) {
        studyMapper.addSubjectClassgroup(subjectId, classgroupId, writeWho);
    }

    /**
     * Add multiple subjectClassgroups.
     */
    public void addSubjectClassgroups(List<SubjectClassgroup> subjectClassgroups, String writeWho) {
        for (SubjectClassgroup sc : subjectClassgroups) {
            this.addSubjectClassgroup(sc.getSubjectId(), sc.getClassgroupId(), writeWho);
        }
    }

    @Override
    public void deleteSubjectClassgroup(int subjectId, int classgroupId) {
        studyMapper.deleteSubjectClassgroup(subjectId, classgroupId);
    }

    @Override
    public void deleteSubjectClassgroups(List<SubjectClassgroup> subjectClassgroups) {
        for (SubjectClassgroup sc : subjectClassgroups) {
            this.deleteSubjectClassgroup(sc.getSubjectId(), sc.getClassgroupId());
        }
    }

    @Override
    public int getMaximumNumberOfSubjectsPerCardinalTimeUnit(StudyGradeType studyGradeType) {
        int maxNumberOfSubjects = studyGradeType.getMaxNumberOfSubjectsPerCardinalTimeUnit();
        if (maxNumberOfSubjects == 0) {
            // if unspecified (= 0), then take application init parameter
            maxNumberOfSubjects = opusInit.getMaxSubjectsPerCardinalTimeUnit();
        }
        return maxNumberOfSubjects;
    }
}
