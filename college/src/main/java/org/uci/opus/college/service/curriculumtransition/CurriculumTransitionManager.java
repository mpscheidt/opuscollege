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

package org.uci.opus.college.service.curriculumtransition;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectBlockCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectCT;
import org.uci.opus.college.persistence.ExaminationMapper;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.persistence.TestMapper;
import org.uci.opus.college.service.extpoint.AcademicYearTransitionExtPoint;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.StudyGradeTypeTransitionExtPoint;
import org.uci.opus.college.service.extpoint.SubjectBlockStudyGradeTypeTransitionExtPoint;
import org.uci.opus.college.service.extpoint.SubjectStudyGradeTypeTransitionExtPoint;
import org.uci.opus.college.web.flow.study.CurriculumTransitionData;

@Service
public class CurriculumTransitionManager implements CurriculumTransitionManagerInterface {

    private static Logger log = LoggerFactory.getLogger(CurriculumTransitionManager.class);

    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private StudyMapper studyMapper;
    @Autowired private SubjectMapper subjectMapper;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private ExaminationMapper examinationMapper;
    @Autowired private TestMapper testMapper;

    @Override
    public CurriculumTransitionData loadCurriculumTransitionData(int fromAcademicYearId, int toAcademicYearId, Map<String, Object> params) {
        CurriculumTransitionData data = new CurriculumTransitionData();
        data.setFromAcademicYearId(fromAcademicYearId);
        data.setToAcademicYearId(toAcademicYearId);

        loadCurriculumTransitionData(data, params);

        return data;
    }

    @Override
    public void loadCurriculumTransitionData(CurriculumTransitionData data, Map<String, Object> params) {

        Map<String, Object> map = new HashMap<>();
        map.put("fromAcademicYearId", data.getFromAcademicYearId());
        map.put("toAcademicYearId", data.getToAcademicYearId());
        if (params != null) {
            map.putAll(params);
        }

        Map<Integer, StudyGradeTypeCT> studyGradeTypes = studyMapper.findStudyGradeTypesForTransition(map);
        data.setStudyGradeTypes(studyGradeTypes);
        
        Map<Integer, SubjectBlockCT> subjectBlocks = subjectBlockMapper.findSubjectBlocksForTransition(map);
        data.setSubjectBlocks(subjectBlocks);

        Map<Integer, SubjectCT> subjects = subjectMapper.findSubjectsForTransition(map);
        data.setSubjects(subjects);

        preSelectAll(data);
        
        // check if endGrades have been transferred already
        int nEndGrades = studyMapper.findNrOfEndgradesToTransfer(map);
        data.setNrOfGradesEligibleForTransfer(nEndGrades);
        if (nEndGrades > 0) {
            data.setEndGradesSelectedForTransfer(true);
        }
    }

    public void preSelectAll(CurriculumTransitionData data) {

        // preselect all study grade types, subject blocks and subjects
        if (data.getEligibleStudyGradeTypes() != null) {
        	for (StudyGradeTypeCT sgt : data.getEligibleStudyGradeTypes()) {
        		data.getSelectedStudyGradeTypeIds().add(sgt.getOriginalId());
        	}
        }
        if (data.getEligibleSubjectBlocks() != null) {
        	for (SubjectBlockCT sb : data.getEligibleSubjectBlocks()) {
        		data.getSelectedSubjectBlockIds().add(sb.getOriginalId());
        	}
        }
        if (data.getEligibleSubjects() != null) {
	        for (SubjectCT s : data.getEligibleSubjects()) {
	            data.getSelectedSubjectIds().add(s.getOriginalId());
	        }
        }
        
    }

    /* (non-Javadoc)
     * @see org.uci.opus.college.service.curriculumtransition.CurriculumTransitionManagerInterface#transferCurriculum(org.uci.opus.college.web.flow.study.CurriculumTransitionData, int)
     */
    @Override
    @Transactional
    public void transferCurriculum(CurriculumTransitionData data) {

        int sourceAcademicYearId = data.getFromAcademicYearId();
        int targetAcademicYearId = data.getToAcademicYearId();
        
        // 0. transfer data that is directly related to academic years
        // (this could also be the last step instead of the first)
        Collection<AcademicYearTransitionExtPoint> academicYearTransitionExtensions = collegeServiceExtensions.getAcademicYearTransitionsExtensions();
//	TODO: JANO how to transfer?
//        if (academicYearTransitionExtensions != null) {
//            for (Iterator<AcademicYearTransitionExtPoint> it = academicYearTransitionExtensions.iterator(); it.hasNext(); ) {
//                AcademicYearTransitionExtPoint extension = it.next();
//                extension.transfer(sourceAcademicYearId, targetAcademicYearId);
//            }
//        }
        
        // 1. Transfer study grade type and related tables
        transferStudyGradeTypes(data.getSelectedStudyGradeTypes(), targetAcademicYearId);
        transferStudyGradeTypePrerequisites(sourceAcademicYearId, targetAcademicYearId);
        
        // 2. Transfer subject and related tables
        transferSubjects(data.getSelectedSubjects(), targetAcademicYearId);
        transferSubjectTeachers(sourceAcademicYearId, targetAcademicYearId);
        transferSubjectStudyTypes(sourceAcademicYearId, targetAcademicYearId);
        transferSubjectStudyGradeTypes(sourceAcademicYearId, targetAcademicYearId);
        transferSubjectPrerequisites(sourceAcademicYearId, targetAcademicYearId);

        // 3. Transfer subject blocks and related tables
        transferSubjectBlocks(data.getSelectedSubjectBlocks(), targetAcademicYearId);
        transferSubjectBlockStudyGradeTypes(sourceAcademicYearId, targetAcademicYearId);
        transferSubjectBlockPrerequisites(sourceAcademicYearId, targetAcademicYearId);
        transferSubjectSubjectBlocks(sourceAcademicYearId, targetAcademicYearId);
        
        // 4. Transfer end grades
        if (data.isEndGradesSelectedForTransfer()) {
            transferEndGrades(sourceAcademicYearId, targetAcademicYearId);
        }
    }

    /**
     * Here, the eligible study grade types are transferred,
     * and subjectStudyGradeType records for already transferred subjects are created.
     */
    @Override
    public void transferStudyGradeTypes(List<StudyGradeTypeCT> eligibleStudyGradeTypes,
            int toAcademicYearId) {
        if (eligibleStudyGradeTypes == null || eligibleStudyGradeTypes.isEmpty()) return;
        
        for (StudyGradeTypeCT studyGradeType: eligibleStudyGradeTypes) {
            transferStudyGradeType(studyGradeType, toAcademicYearId);
        }
    }
    
    @Override
    public int transferStudyGradeType(
            final StudyGradeTypeCT studyGradeType,
            int toAcademicYearId) {

        studyMapper.transferStudyGradeType(studyGradeType, toAcademicYearId);
        int newId = studyGradeType.getNewId();
        log.info("Transferred StudyGradeType record with original id = " + studyGradeType.getOriginalId() + " to new id = " + newId);
        transferCardinalTimeUnitStudyGradeTypes(studyGradeType.getOriginalId(), newId);
        transferClassgroups(studyGradeType.getOriginalId(), newId);
        transferSecondaryschoolsubjectgroups(studyGradeType.getOriginalId(), newId);

        // now transfer further study grade type related tables as defined in extensions
        transferStudyGradeTypeExtensions(studyGradeType.getOriginalId(), newId);

        return newId;
    }
    
    private void transferStudyGradeTypeExtensions(int originalStudyGradeTypeId, int newStudyGradeTypeId) {
        
        Collection<StudyGradeTypeTransitionExtPoint> studyGradeTypeTransitionExtensions = collegeServiceExtensions.getStudyGradeTypeTransitionExtensions();
        
        if (studyGradeTypeTransitionExtensions == null) return;
        
        for (Iterator<StudyGradeTypeTransitionExtPoint> it = studyGradeTypeTransitionExtensions.iterator(); it.hasNext(); ) {
            StudyGradeTypeTransitionExtPoint sgtExtension = it.next();
            sgtExtension.transfer(originalStudyGradeTypeId, newStudyGradeTypeId);
        }
    }

    @Override
    public void transferStudyGradeTypePrerequisites(int sourceAcademicYearId, int targetAcademicYearId) {
        studyMapper.transferStudyGradeTypePrerequisites(sourceAcademicYearId, targetAcademicYearId);
    }

    @Override
    public void transferCardinalTimeUnitStudyGradeTypes(int originalStudyGradeTypeId, int newStudyGradeTypeId) {

        List<CardinalTimeUnitStudyGradeType> ctuStudyGradeTypes = studyMapper.findCardinalTimeUnitStudyGradeTypes(originalStudyGradeTypeId);
        for (CardinalTimeUnitStudyGradeType ctuStudyGradeType: ctuStudyGradeTypes) {
            transferCardinalTimeUnitStudyGradeType(ctuStudyGradeType, newStudyGradeTypeId);
        }
    }

    @Override
    public int transferCardinalTimeUnitStudyGradeType(CardinalTimeUnitStudyGradeType ctuStudyGradeType, int newStudyGradeTypeId) {

        Map<String, Object> map = new HashMap<>();
        map.put("originalCardinalTimeUnitStudyGradeTypeId", ctuStudyGradeType.getId());
        map.put("newStudyGradeTypeId", newStudyGradeTypeId);
        studyMapper.transferCardinalTimeUnitStudyGradeType(map);

        int newId = (int) map.get("id");
        log.info("Transferred CardinalTimeUnitStudyGradeType record with original id = " + ctuStudyGradeType.getId() + " to new id = " + newId);
        return newId;
    }

    @Override
    public void transferClassgroups(int originalStudyGradeTypeId, int newStudyGradeTypeId) {

        Map<String, Object> findMap = new HashMap<>();
        findMap.put("studyGradeTypeId", originalStudyGradeTypeId);
        List<Classgroup> classgroups = studyMapper.findClassgroups(findMap);

        for (Classgroup classgroup: classgroups) {
            transferClassgroup(classgroup, newStudyGradeTypeId);
        }
    }
    
    @Override
    public void transferClassgroup(Classgroup classgroup, int newStudyGradeTypeId) {
        
        // NB: return value is number of inserted rows (has to be one in this case), not the new ID!
        // See transferStudyGradeType and transferCardinalTimeUnitStudyGradeType for two ways to access the new ID
        studyMapper.transferClassgroup(classgroup.getId(), newStudyGradeTypeId);
    }

    @Override
    public void transferSecondaryschoolsubjectgroups(
            int originalStudygradetypeId, int newStudygradetypeId) {
        // read the list of secondaryschoolsubjectgroups, we'll need to know
        // original and new ids so transfer groupedsecondaryschoolsubjects
        List<SecondarySchoolSubjectGroup> groups = studyMapper.findSecondarySchoolSubjectGroups(originalStudygradetypeId);
        for (SecondarySchoolSubjectGroup group: groups) {
            transferSecondaryschoolsubjectgroup(group, newStudygradetypeId);
        }
    }

    @Override
    public int transferSecondaryschoolsubjectgroup(SecondarySchoolSubjectGroup subjectGroup, int newStudyGradeTypeId) {
        
        // first transfer the Secondaryschoolsubjectgroup itself
        Map<String, Object> map = new HashMap<>();
        map.put("originalSecondarySchoolSubjectGroupId", subjectGroup.getId());
        map.put("newStudyGradeTypeId", newStudyGradeTypeId);
        studyMapper.transferSecondaryschoolsubjectgroup(map);
        
        int newSubjectGroupId = (int) map.get("newId");
        log.info("Transferred SecondarySchoolSubjectGroup record with original id = " + subjectGroup.getId() + " to new id = " + newSubjectGroupId);
        
        // then, transfer associated records: groupedsecondaryschoolsubjects
        transferGroupedsecondaryschoolsubjects(subjectGroup.getId(), newSubjectGroupId);

        return newSubjectGroupId;
    }

    @Override
    public void transferGroupedsecondaryschoolsubjects(
            int originalSecondaryschoolsubjectgroupId,
            int newSecondaryschoolsubjectgroupId) {

        List<Integer> groupedSubjectIds = studyMapper.findGroupedSecondarySchoolSubjectIds(originalSecondaryschoolsubjectgroupId);
        for (int groupedSubjectId : groupedSubjectIds) {
            transferGroupedsecondaryschoolsubject(groupedSubjectId, newSecondaryschoolsubjectgroupId);
        }
    }

    @Override
    public void transferGroupedsecondaryschoolsubject(int groupedSubjectId, int newSecondaryschoolsubjectgroupId) {

        studyMapper.transferGroupedsecondaryschoolsubject(groupedSubjectId, newSecondaryschoolsubjectgroupId);
    }

    @Override
    public void transferSubjectStudyGradeTypes(int sourceAcademicYearId,
            int targetAcademicYearId) {
        subjectMapper.transferSubjectStudyGradeTypes(sourceAcademicYearId, targetAcademicYearId);

        // process extensions
        Collection<SubjectStudyGradeTypeTransitionExtPoint> subjectStudyGradeTypeTransitionExtensions = collegeServiceExtensions.getSubjectStudyGradeTypeTransitionsExtensions();
        
        if (subjectStudyGradeTypeTransitionExtensions != null) {
            for (Iterator<SubjectStudyGradeTypeTransitionExtPoint> it = subjectStudyGradeTypeTransitionExtensions.iterator(); it.hasNext(); ) {
                SubjectStudyGradeTypeTransitionExtPoint extension = it.next();
                extension.transfer(sourceAcademicYearId, targetAcademicYearId);
            }
        }
    }

//    public int transferSubjectStudyGradeType(final SubjectCT subject,
//            final StudyGradeTypeCT studyGradeType) {
//        return transferSubjectStudyGradeType(subject.getOriginalId(),
//                subject.getNewId(), studyGradeType.getOriginalId(),
//                studyGradeType.getNewId());
//    }
//
//    public int transferSubjectStudyGradeType(
//            final int originalSubjectId, final int newSubjectId, 
//            final int originalStudyGradeTypeId, final int newStudyGradeTypeId) {
//        return subjectDao.transferSubjectStudyGradeType(originalSubjectId, 
//                newSubjectId, originalStudyGradeTypeId,
//                newStudyGradeTypeId);
//    }

    /**
     * Here, the eligible subjects are transferred
     * and subjectStudyGradeType records are written for already transferred study grade types.
     */
    @Override
    public void transferSubjects(final List<SubjectCT> subjects, final int toAcademicYearId) {
        if (subjects == null || subjects.isEmpty()) return;

        for (SubjectCT subject: subjects) {
            transferSubject(subject, toAcademicYearId);
        }
    }

    @Override
    public int transferSubject(final SubjectCT subject,
            final int toAcademicYearId) {

        subjectMapper.transferSubject(subject, toAcademicYearId);
        int newSubjectId = subject.getNewId();
        log.info("Transferred Subject record with original id = " + subject.getOriginalId() + " to new id = " + subject.getNewId());
        transferExaminations(subject.getOriginalId(), subject.getNewId(), toAcademicYearId);
        return newSubjectId;
    }

    @Override
    public void transferSubjectTeachers(int sourceAcademicYearId,
            int targetAcademicYearId) {
        subjectMapper.transferSubjectTeachers(sourceAcademicYearId,
                targetAcademicYearId);
    }
    
    @Override
    public void transferSubjectStudyTypes(int sourceAcademicYearId,
            int targetAcademicYearId) {
        subjectMapper.transferSubjectStudyTypes(sourceAcademicYearId,
                targetAcademicYearId);
    }
    
    @Override
    public void transferSubjectPrerequisites(int sourceAcademicYearId, int targetAcademicYearId) {
        subjectMapper.transferSubjectPrerequisites(sourceAcademicYearId, targetAcademicYearId);
    }

    @Override
    public void transferSubjectBlockPrerequisites(int sourceAcademicYearId, int targetAcademicYearId) {
        subjectBlockMapper.transferSubjectBlockPrerequisites(sourceAcademicYearId, targetAcademicYearId);
    }
    
    @Override
    public void transferExaminations(final int originalSubjectId,
            int newSubjectId, int toAcademicYearId) {

        // read the list of examinations, we'll need to know
        // original and new ids to transfer examinationTeachers and tests
        List<? extends Examination> examinations = examinationMapper.findExaminationsForSubject(originalSubjectId);
        for (Examination examination : examinations) {
            transferExamination(examination, newSubjectId, toAcademicYearId);
        }
    }
    
    @Override
    public int transferExamination(Examination examination, int newSubjectId, int toAcademicYearId) {
        
        // first transfer the examination itself
        Map<String, Object> map = new HashMap<>();
        map.put("originalExaminationId", examination.getId());
        map.put("newSubjectId", newSubjectId);
        examinationMapper.transferExamination(map);
        int newExaminationId = (int) map.get("newId");
        log.info("Transferred Examination record with original id = " + examination.getId() + " to new id = " + newExaminationId);
        
        // then, transfer associated records: teachers and tests
        transferExaminationTeachers(examination.getId(), newExaminationId, toAcademicYearId);
        transferTests(examination.getId(), newExaminationId, toAcademicYearId);

        return newExaminationId;
    }

    @Override
    public void transferExaminationTeachers(final int originalExaminationId, final int newExaminationId, int targetAcademicYearId) {

        examinationMapper.transferExaminationTeachers(originalExaminationId, newExaminationId, targetAcademicYearId);
    }

    @Override
    public void transferTests(final int originalExaminationId, final int newExaminationId, int toAcademicYearId) {
        
        List<? extends Test> tests = testMapper.findTestsForExamination(originalExaminationId);
        for (Test test: tests) {
            transferTest(test, newExaminationId, toAcademicYearId);
        }
    }

    @Override
    public void transferTest(Test test, int newExaminationId, int toAcademicYearId) {
        // first process test, get the new test id
        Map<String, Object> map = new HashMap<>();
        map.put("originalTestId", test.getId());
        map.put("newExaminationId", newExaminationId);
        testMapper.transferTest(map);
        int newTestId = (int) map.get("newId");
        log.info("Transferred Test record with original id = " + test.getId() + " to new id = " + newTestId);
        
        // then process associated records: testTeachers
        testMapper.transferTestTeachers(test.getId(), newTestId, toAcademicYearId);
    }

    @Override
    public void transferSubjectBlocks(List<SubjectBlockCT> eligibleSubjectBlocks,
            int toAcademicYearId) {
        if (eligibleSubjectBlocks == null) return;
//        subjectDao.transferSubjectBlocks(eligibleSubjectBlocks, toAcademicYearId);
        for (SubjectBlockCT subjectBlock: eligibleSubjectBlocks) {
            subjectBlockMapper.transferSubjectBlock(subjectBlock, toAcademicYearId);
        }

    }

    @Override
    public void transferSubjectBlockStudyGradeTypes(int sourceAcademicYearId, int targetAcademicYearId) {

        subjectBlockMapper.transferSubjectBlockStudyGradeTypes(sourceAcademicYearId, targetAcademicYearId);

        // process extensions
        Collection<SubjectBlockStudyGradeTypeTransitionExtPoint> subjectBlockStudyGradeTypeTransitionExtensions = collegeServiceExtensions.getSubjectBlockStudyGradeTypeTransitionsExtensions();

        if (subjectBlockStudyGradeTypeTransitionExtensions != null) {
            for (Iterator<SubjectBlockStudyGradeTypeTransitionExtPoint> it = subjectBlockStudyGradeTypeTransitionExtensions.iterator(); it.hasNext(); ) {
                SubjectBlockStudyGradeTypeTransitionExtPoint extension = it.next();
                extension.transfer(sourceAcademicYearId, targetAcademicYearId);
            }
        }
    }

    @Override
    public void transferSubjectSubjectBlocks(int sourceAcademicYearId, int targetAcademicYearId) {
        subjectBlockMapper.transferSubjectSubjectBlocks(sourceAcademicYearId, targetAcademicYearId);
    }

    @Override
    public List<SubjectStudyGradeType> findSubjectStudyGradeTypesForSubjectTransition(
            Map<String, Object> map) {

        List<SubjectStudyGradeType> ssgts;
        ssgts = subjectMapper.findSubjectStudyGradeTypesForSubjectTransition(map);
        return ssgts;
    }

    @Override
    public List < SubjectStudyGradeType > findSubjectStudyGradeTypesForSGTTransition(final Map<String, Object> map) {
        
        List<SubjectStudyGradeType> ssgts;
        ssgts = subjectMapper.findSubjectStudyGradeTypesForSGTTransition(map);
        return ssgts;
    }

    @Override
    public List <? extends SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForSubjectBlockTransition(Map<String, Object> map) {
        
        List<? extends SubjectBlockStudyGradeType> sbsgts;
        sbsgts = subjectBlockMapper.findSubjectBlockStudyGradeTypesForSubjectBlockTransition(map);
        return sbsgts;
    }

    @Override
    public List<? extends SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForStudyGradeTypeTransition(
            Map<String, Object> map) {
        
        List<? extends SubjectBlockStudyGradeType> sbsgts;
        sbsgts = subjectBlockMapper.findSubjectBlockStudyGradeTypesForStudyGradeTypeTransition(map);
        return sbsgts;
    }

    @Override
    public List<? extends SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectTransition(
            Map<String, Object> map) {
        
        List<? extends SubjectSubjectBlock> ssbs;
        ssbs = subjectMapper.findSubjectSubjectBlocksForSubjectTransition(map);
        return ssbs;
    }

    @Override
    public List<? extends SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectBlockTransition(
            Map<String, Object> map) {
        
        List<? extends SubjectSubjectBlock> ssbs;
        ssbs = subjectMapper.findSubjectSubjectBlocksForSubjectBlockTransition(map);
        return ssbs;
    }

    @Override
    public void transferEndGrades(int sourceAcademicYear, int targetAcademicYear) {
        
        studyMapper.transferEndGrades(sourceAcademicYear, targetAcademicYear);
    }
    
}
