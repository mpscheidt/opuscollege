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
 * s
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
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.domain.util.SubjectComparator;
import org.uci.opus.college.persistence.ExaminationMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSGTSelection;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSelection;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;

/**
 * @author J.Nooitgedagt
 *
 */
public class SubjectManager implements SubjectManagerInterface {

    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private SubjectMapper subjectMapper;
    @Autowired private ExaminationMapper examinationMapper;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    @Override
    public List<Subject> findSubjects(final Map<String, Object> map) {
        return subjectMapper.findSubjects(map);
    }

    @Override
    public List<Subject> findSubjects(Collection<Integer> subjectIds) {
        
        // If subjectIds is empty, it's important to not launch a query, otherwise all subjects would be loaded
        if (subjectIds == null || subjectIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        Map<String, Object> findSubjectsMap = new HashMap<>();
        findSubjectsMap.put("subjectIds", subjectIds);
        return this.findSubjects(findSubjectsMap);
    }

    @Override
    public List<Subject> findSubjectsByStudy(final int studyId) {

        Map<String,Object> map = new HashMap<>();
        map.put("studyId", studyId);
        return subjectMapper.findSubjectsByStudy(map);
    }

    @Override
    public Subject findSubject(final int subjectId) {

    	return subjectMapper.findSubject(subjectId);
    }
    
    @Override
    public Subject findSubjectByCode(final Map<String, Object> map) {

    	return subjectMapper.findSubjectByCode(map);
    }

    @Override
    public Subject findSubjectByDescriptionStudy(final Map<String, Object> map) {

    	return subjectMapper.findSubjectByDescriptionStudy(map);
    }

    @Override
    public Subject findSubjectByDescriptionStudyCode(final Map<String, Object> map) {

    	return subjectMapper.findSubjectByDescriptionStudyCode(map);
    }

    @Override
    public void addSubject(final Subject subject) {

    	subjectMapper.addSubject(subject);
    }

    @Override
    public void updateSubject(final Subject subject) {

    	subjectMapper.updateSubject(subject);
    }

    @Override
    public void deleteSubject(final int subjectId, final HttpServletRequest request) {

        // first delete subjectStudyGradeTypes of this subject
        this.deleteSubjectStudyGradeTypesBySubjectId(subjectId, request);
        
        // then delete subjectSubjectBlocks belonging to this subject
        subjectMapper.deleteSubjectSubjectBlocks(subjectId);
        
        subjectMapper.deleteSubjectSubjectBlocks(subjectId);
        subjectMapper.deleteSubjectStudyTypes(subjectId);
        subjectMapper.deleteAllSubjectTeachers(subjectId);
        examinationMapper.deleteAllExaminationsForSubject(subjectId);

        // then delete subject
    	subjectMapper.deleteSubject(subjectId);

    }

    @Override
    public Subject findSubjectByDescriptionStudyCode2(final Map<String, Object> map) {

    	return subjectMapper.findSubjectByDescriptionStudyCode2(map);
    }
    
    @Override
    public int findSubjectPrimaryStudyId(final int subjectId) {

    	return subjectMapper.findSubjectPrimaryStudyId(subjectId);
    }

    @Override
    public SubjectTeacher findSubjectTeacher(final int subjectTeacherId) {

    	return subjectMapper.findSubjectTeacher(subjectTeacherId);
    }
    
    @Override
    public List < SubjectTeacher > findSubjectTeachers(final int subjectId) {

    	return subjectMapper.findSubjectTeachers(subjectId);
    }
    
    @Override
    public void addSubjectTeacher(final SubjectTeacher subjectTeacher) {

    	subjectMapper.addSubjectTeacher(subjectTeacher);
    }

    @Override
    public void updateSubjectTeacher(final SubjectTeacher subjectTeacher) {

    	subjectMapper.updateSubjectTeacher(subjectTeacher);
    }

    @Override
    public void deleteSubjectTeacher(final int subjectTeacherId) {

    	subjectMapper.deleteSubjectTeacher(subjectTeacherId);
    }

    @Override
    public boolean existSubjectStudyPlanDetails(final int subjectId) {
        return subjectMapper.existSubjectStudyPlanDetails(subjectId);
    }
    
    @Override
    public List<Subject> findSubjectsForStudyPlan(final int studyPlanId) {
        return subjectMapper.findSubjectsForStudyPlan(studyPlanId);
    }

    @Override
    public SubjectStudyGradeType findSubjectStudyGradeType(final Map<String, Object> map) {
        return subjectMapper.findSubjectStudyGradeType(map);
    }
    
    @Override
    public SubjectStudyGradeType findSubjectStudyGradeType(String preferredLanguage, int subjectStudyGradeTypeId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("subjectStudyGradeTypeId", subjectStudyGradeTypeId);
        return subjectMapper.findSubjectStudyGradeType(map);
    }
    
    @Override
    public int findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(final Map<String, Object> map) {
        Integer id = subjectMapper.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);
        return id == null ? 0 : id;
    }
    
    @Override
    public List < SubjectPrerequisite > findSubjectPrerequisites(
                                                    final int subjectStudyGradeTypeId) {
       
        return subjectMapper.findSubjectPrerequisites(subjectStudyGradeTypeId);
    }
    
    @Override
    public List<String> findPrerequisiteSubjectCodes(final int subjectStudyGradeTypeId) {

        return subjectMapper.findPrerequisiteSubjectCodes(subjectStudyGradeTypeId);
    }
    
    @Override
    public List < SubjectPrerequisite > findPrerequisitesBySubjectCodeAndStudyPlanId(
                                                    final int studyPlanId, final String subjectCode) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("subjectCode", subjectCode);
        return subjectMapper.findPrerequisitesBySubjectCodeAndStudyPlanId(map);
    }
    
    @Override
    public List < SubjectStudyGradeType > findSubjectStudyGradeTypes(final Map<String, Object> map) {

    	return subjectMapper.findSubjectStudyGradeTypes(map);
    }
    
    @Override
    public List<SubjectStudyGradeType> findSubjectStudyGradeTypes(List<Integer> studyPlanDetailIds, String preferredLanguage) {
        Map<String, Object> ssgtMap = new HashMap<>();
        ssgtMap.put("preferredLanguage", preferredLanguage);
        ssgtMap.put("studyPlanDetailIds", studyPlanDetailIds);
        return this.findSubjectStudyGradeTypes(ssgtMap);
    }

    @Override
    public List < SubjectStudyGradeType > findSubjectStudyGradeTypesForStudy(final Map<String, Object> map) {

    	return subjectMapper.findSubjectStudyGradeTypesForStudy(map);
    }

    @Override
    public void addSubjectStudyGradeType(final SubjectStudyGradeType subjectStudyGradeType) {
        subjectMapper.addSubjectStudyGradeType(subjectStudyGradeType);
    }
    
    @Override
    public void updateSubjectStudyGradeType(
                        final SubjectStudyGradeType subjectStudyGradeType) {
        subjectMapper.updateSubjectStudyGradeType(subjectStudyGradeType);
    }

    @Override
    public void deleteSubjectStudyGradeType(final int subjectStudyGradeTypeId, HttpServletRequest request) {

//        for(Module module:modules){
//			if ("fee".equals(module.getModule())) {
//				// delete fees that are bound to the subjectstudygradetype
//				feeManager.deleteFeesForSubjectStudyGradeType(subjectStudyGradeTypeId, writeWho);
//			}
//        }
        collegeServiceExtensions.beforeSubjectStudyGradeTypeDelete(subjectStudyGradeTypeId, request);

        // delete possible prerequisites
        subjectMapper.deleteSubjectPrerequisites(subjectStudyGradeTypeId);
        
        subjectMapper.deleteSubjectStudyGradeType(subjectStudyGradeTypeId);
    }
    
    /*
     * apparently ununsed
     *  if used: move to studyManager
     */
//    @Override
//    public int findStudyGradeTypeId(final Map<String, Object> map) {
//        return subjectMapper.findStudyGradeTypeId(map);
//    }
    
    @Override
    public List < SubjectStudyType > findSubjectStudyTypes(final Map<String, Object> map) {
        return subjectMapper.findSubjectStudyTypes(map);
    }
    
    @Override
    public SubjectStudyType findSubjectStudyType(final Map<String, Object> map) {
        return subjectMapper.findSubjectStudyType(map);
    }

    @Override
    public void addSubjectStudyType(final SubjectStudyType subjectStudyType) {
        subjectMapper.addSubjectStudyType(subjectStudyType);
    }
    
    @Override
    public void updateSubjectStudyType(final SubjectStudyType subjectStudyType) {
        subjectMapper.updateSubjectStudyType(subjectStudyType);
    }
    
    @Override
    public void deleteSubjectStudyType(final int subjectStudyTypeId) {
        subjectMapper.deleteSubjectStudyType(subjectStudyTypeId);
    }
    
    @Override
    public void addSubjectPrerequisite(final SubjectPrerequisite subjectPrerequisite) {
        subjectMapper.addSubjectPrerequisite(subjectPrerequisite);
    }
    
    @Override
    public void deleteSubjectPrerequisite(final SubjectPrerequisite subjectPrerequisite) {
        subjectMapper.deleteSubjectPrerequisite(subjectPrerequisite);
    }

    @Override
    public List < SubjectSubjectBlock > findSubjectSubjectBlocks(final Map<String, Object> map) {
        
        List < SubjectSubjectBlock > allSubjectSubjectBlocks = null;
        allSubjectSubjectBlocks = subjectMapper.findSubjectSubjectBlocks(map);

        return allSubjectSubjectBlocks;
    }
    
    @Override
    public SubjectSubjectBlock findSubjectSubjectBlock(final int subjectSubjectBlockId) {
        
    	SubjectSubjectBlock subjectSubjectBlock = null;
    	subjectSubjectBlock = subjectMapper.findSubjectSubjectBlock(subjectSubjectBlockId);

    	return subjectSubjectBlock;
    }

    @Override
    public List < SubjectSubjectBlock > findSubjectSubjectBlocksForSubject(final int subjectId) {
        
        List < SubjectSubjectBlock > allSubjectSubjectBlocks = null;
        allSubjectSubjectBlocks = subjectMapper.findSubjectSubjectBlocksForSubject(subjectId);

        return allSubjectSubjectBlocks;
    }

    @Override
    public void addSubjectSubjectBlock(final SubjectSubjectBlock subjectSubjectBlock) {
        subjectMapper.addSubjectSubjectBlock(subjectSubjectBlock);
    }
    
    @Override
    public void updateSubjectSubjectBlock(final SubjectSubjectBlock subjectSubjectBlock) {
        subjectMapper.updateSubjectSubjectBlock(subjectSubjectBlock);
    }
    
    @Override
    public void deleteSubjectSubjectBlock(final int subjectSubjectBlockId) {
        
    	subjectMapper.deleteSubjectSubjectBlock(subjectSubjectBlockId);
    }
    
    @Override
    public List<Integer> findSubjectsByStudyGradeType(final StudyGradeType studyGradeType) {

        return subjectMapper.findSubjectsByStudyGradeType(studyGradeType);
    }

    @Override
    public List<Integer> findSubjectBlocksByStudyGradeType(final StudyGradeType studyGradeType) {

        return subjectMapper.findSubjectBlocksByStudyGradeType(studyGradeType);
    }

    /**
     * Delete all studyGradeTypes linked to a subject. Used when deleting a complete subject.
     * @param subjectId id of the subject the studyGradeTypes are linked to
     */
    private void deleteSubjectStudyGradeTypesBySubjectId(final int subjectId, final HttpServletRequest request) {
        String language = OpusConstants.DEFAULT_LANGUAGE;
        Map<String, Object> map = new HashMap<>();
        map.put("preferredLanguage", language);
        map.put("subjectId", subjectId);
        List<SubjectStudyGradeType> subjectStudyGradeTypes = this.findSubjectStudyGradeTypes(map);
        for (int i = 0; i < subjectStudyGradeTypes.size(); i++) {
            // first delete all subjectPrerequisites
            SubjectStudyGradeType ssg = (SubjectStudyGradeType) subjectStudyGradeTypes.get(i);
            int subjectStudyGradeTypeId = ssg.getId();
            subjectMapper.deleteSubjectPrerequisites(subjectStudyGradeTypeId);
            // then the subjectStudyGradeType can be deleted
            this.deleteSubjectStudyGradeType(subjectStudyGradeTypeId, request);
        }

    }
 
    @Override
    public List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypes(List<Integer> studyPlanDetailIds, String preferredLanguage) {
        Map<String, Object> sbsgtMap = new HashMap<>();
        sbsgtMap.put("preferredLanguage", preferredLanguage);
        sbsgtMap.put("studyPlanDetailIds", studyPlanDetailIds);
        return subjectBlockMapper.findSubjectBlockStudyGradeTypes(sbsgtMap);
    }

    @Override
    public void deleteSubjectBlockStudyGradeType(final int subjectBlockStudyGradeTypeId,
    		final HttpServletRequest request) {
    	
//        for(Module module:modules){
//			if ("fee".equals(module.getModule())) {
//				// then delete fees that are bound to the subjectstudygradetype
//                feeManager.deleteFeesForSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId, writeWho);
//			}
//        }
        collegeServiceExtensions.beforeSubjectBlockStudyGradeTypeDelete(subjectBlockStudyGradeTypeId, request);

        subjectBlockMapper.deleteSubjectBlockPrerequisites(subjectBlockStudyGradeTypeId);
        subjectBlockMapper.deleteSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);
        
    }
    
    @Override
    public List < SubjectStudyGradeType >  findSubjectsForStudyGradeType(
                final int studyGradeTypeId) {
        return subjectMapper.findSubjectsForStudyGradeType(studyGradeTypeId);
    }

    @Override
    public List <SubjectStudyGradeType> findSubjectStudyGradeTypes2 (final Map<String, Object> map){
    	return subjectMapper.findSubjectStudyGradeTypes2(map);
    }

    /**
     * Delete all subjectStudyGradeTypes of a given subjectBlock
     * Used in deleteSubjectBlock
     * @param subjectBlockId id of the subjectBlock
     */
    private void deleteAllStudyGradeTypesFromSubjectBlock(final int subjectBlockId) {
        // get the subjectStudyGradeTypes to remove
        Map<String,Object> map = new HashMap<>();
        map.put("preferredLanguage", OpusConstants.DEFAULT_LANGUAGE);
        map.put("subjectBlockId", subjectBlockId);
        List < SubjectBlockStudyGradeType > list = subjectBlockMapper.findSubjectBlockStudyGradeTypes(map);
        // loop through the subjectStudyGradeTypes, first delete any prerequisites then
        // the subjectStudyGradeType
        for (int i = 0; i < list.size(); i++) {
            SubjectBlockStudyGradeType obj = list.get(i);
            int subjectBlockStudyGradeTypeId = obj.getId();
            // delete subjectBlockPrerequisites
            subjectBlockMapper.deleteSubjectBlockPrerequisites(subjectBlockStudyGradeTypeId);
            // delete the subjectStudyGradeType
            subjectBlockMapper.deleteSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);
        }
    }

    @Override
    public void deleteSubjectBlock(final int subjectBlockId) {

        // remove all links to subjects from the subjectBlock
        subjectBlockMapper.deleteAllSubjectsFromSubjectBlock(subjectBlockId);

        // delete all links to studyGradeTypes and underlying prerequisites
        this.deleteAllStudyGradeTypesFromSubjectBlock(subjectBlockId);

        subjectBlockMapper.deleteSubjectBlock(subjectBlockId);
    }

    @Override
    public SubjectStudyGradeType findSubjectStudyGradeTypeByParams(final Map<String, Object> map) {
        return subjectMapper.findSubjectStudyGradeTypeByParams(map);
    }

    @Override
    public List <SubjectStudyGradeType> findBlockedSubjectStudyGradeTypeByParams(final Map<String, Object> map) {
        return subjectMapper.findBlockedSubjectStudyGradeTypeByParams(map);
    }
    
    @Override
    public List<SubjectStudyGradeType> findBlockedSubjectStudyGradeTypeByParams(List<Integer> subjectBlockStudyGradeTypeIds) {
        Map<String, Object> findBlockedMap = new HashMap<>();
        findBlockedMap.put("subjectBlockStudyGradeTypeIds", subjectBlockStudyGradeTypeIds);
        return this.findBlockedSubjectStudyGradeTypeByParams(findBlockedMap);
    }

    @Override
    public int findSubjectCount(Map<String, Object> map) {
        return subjectMapper.findSubjectCount(map);
    }

    @Override
    public List < Subject > findBlockedSubjects(final Map<String, Object> map) {
        return subjectMapper.findBlockedSubjects(map);
    }

    @Override
    public int findSubjectBlockIdByParams(Map<String, Object> map) {
        return subjectMapper.findSubjectBlockIdByParams(map);
    }
    
    @Override
    public List <Subject> findSubjectsInSubjectBlock (final int subjectBlockId) {
    	return subjectMapper.findSubjectsInSubjectBlock(subjectBlockId);
    }

    @Override
    public SubjectAndBlockSGTSelection getSubjectAndBlockSGTSelection(int studyGradeTypeId, Integer cardinalTimeUnitNumber, String preferredLanguage) {
        List<SubjectBlockStudyGradeType> compulsorySubjectBlockStudyGradeTypes = null;
        List<SubjectStudyGradeType> compulsorySubjectStudyGradeTypes = null;
        List<SubjectBlockStudyGradeType> optionalSubjectBlockStudyGradeTypes = null;
        List<SubjectStudyGradeType> optionalSubjectStudyGradeTypes = null;
        List<Subject> allSubjects = new ArrayList<>();
        if (cardinalTimeUnitNumber != null && cardinalTimeUnitNumber != 0 && studyGradeTypeId != 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("preferredLanguage", preferredLanguage);
            map.put("studyGradeTypeId", studyGradeTypeId);
            map.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);
            
            // SubjectBlockStudyGradeType has reference to subjectBlock
            compulsorySubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(map);

            // SubjectStudyGradeType unfortunately has no subject references...
            compulsorySubjectStudyGradeTypes = this.findSubjectStudyGradeTypes(map);
 
            // ...so, to display subjects, let's get the list of subjects
            Collection<Integer> subjectIds = DomainUtil.getIntProperties(compulsorySubjectStudyGradeTypes, "subjectId");
            Collection<Subject> subjects = this.findSubjects(subjectIds);
            if (subjects != null) allSubjects.addAll(subjects);
            
            // after compulsory, load optional subject (blocks)
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
            optionalSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(map);
            optionalSubjectStudyGradeTypes = this.findSubjectStudyGradeTypes(map);
            subjectIds = DomainUtil.getIntProperties(optionalSubjectStudyGradeTypes, "subjectId");
            subjects = this.findSubjects(subjectIds);
            if (subjects != null) allSubjects.addAll(subjects);
           
        }

//        model.put("compulsorySubjectBlockStudyGradeTypes", compulsorySubjectBlockStudyGradeTypes);
//        model.put("compulsorySubjectStudyGradeTypes", compulsorySubjectStudyGradeTypes);
//        model.put("optionalSubjectBlockStudyGradeTypes", optionalSubjectBlockStudyGradeTypes);
//        model.put("optionalSubjectStudyGradeTypes", optionalSubjectStudyGradeTypes);
//        model.put("idToSubjectMap", new IdToSubjectMap(allSubjects));

        SubjectAndBlockSGTSelection sabc = new SubjectAndBlockSGTSelection();
        sabc.setCompulsorySubjectBlockStudyGradeTypes(compulsorySubjectBlockStudyGradeTypes);
        sabc.setCompulsorySubjectStudyGradeTypes(compulsorySubjectStudyGradeTypes);
        sabc.setOptionalSubjectBlockStudyGradeTypes(optionalSubjectBlockStudyGradeTypes);
        sabc.setOptionalSubjectStudyGradeTypes(optionalSubjectStudyGradeTypes);
        sabc.setIdToSubjectMap(new IdToSubjectMap(allSubjects));
        sabc.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
        return sabc;
    }

    @Override
    public SubjectAndBlockSelection getSubjectAndBlockSelection(int studyGradeTypeId, Integer cardinalTimeUnitNumber, String preferredLanguage) {
        SubjectAndBlockSelection sabc = new SubjectAndBlockSelection();
        
        if (studyGradeTypeId == 0 || cardinalTimeUnitNumber == null || cardinalTimeUnitNumber == 0) {
            return sabc;
        }

//        StudyPlan studyPlan = studyPlanDetailForm.getStudyPlan();
//        StudyGradeType studyGradeType = studyPlanDetailForm.getStudyGradeType();
//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        Organization organization = studyPlanDetailForm.getOrganization();
//        StudyGradeType minorStudyGradeType = null;

        Map<String, Object> findMap = new HashMap<>();
        findMap.put("preferredLanguage", preferredLanguage);
        findMap.put("studyGradeTypeId", studyGradeTypeId);
        findMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        findMap.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);


        // SUBJECTBLOCKS & SUBJECTS
        sabc.setCompulsorySubjectBlocks(subjectBlockMapper.findSubjectBlocks(findMap));

        // subjects that are (a) sorted, and (b) without duplicates
        Collection<Subject> allSubjects = new TreeSet<>(new SubjectComparator());
        allSubjects.addAll(this.findSubjects(findMap));

        // add blocked subjects of selected CTUnumber
        List<Subject> allBlockedSubjects = this.findBlockedSubjects(findMap);
        allSubjects.addAll(allBlockedSubjects);
        sabc.setCompulsorySubjects(allSubjects);

        // after compulsory, load optional subject (blocks)
        findMap.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
        sabc.setOptionalSubjectBlocks(subjectBlockMapper.findSubjectBlocks(findMap));

        allSubjects = new TreeSet<>(new SubjectComparator());
        allSubjects.addAll(this.findSubjects(findMap));
        allBlockedSubjects = this.findBlockedSubjects(findMap);
        allSubjects.addAll(allBlockedSubjects);
        sabc.setOptionalSubjects(allSubjects);
        
        sabc.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
        
        return sabc;
    }

}
