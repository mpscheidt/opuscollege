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

package org.uci.opus.college.web.flow.study;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectBlockCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectCT;

public class CurriculumTransitionData {

    private int fromAcademicYearId;
    private int toAcademicYearId;
    
    /** map original DB id to study grade type */
    private Map<Integer, StudyGradeTypeCT> studyGradeTypes;

    /** map original DB id to subject block */
    private Map<Integer, SubjectBlockCT> subjectBlocks;

    /** map original DB id to new subject */
    private Map<Integer, SubjectCT> subjects;

    // user may (de)select a subset of the eligible items
    private List<Integer> selectedStudyGradeTypeIds;
    private List<Integer> selectedSubjectBlockIds;
    private List<Integer> selectedSubjectIds;

    private int nrOfGradesEligibleForTransfer;
    private boolean endGradesSelectedForTransfer;
    
    
    public int getEligibleStudyGradeTypeCount() {
        if (studyGradeTypes == null || studyGradeTypes.size() == 0) return 0;
        return getEligibleStudyGradeTypes().size();
    }
    
    public int getSelectedStudyGradeTypeCount() {
        List<StudyGradeTypeCT> selectedStudyGradeTypes = getSelectedStudyGradeTypes();
        if (selectedStudyGradeTypes == null) return 0;
        return selectedStudyGradeTypes.size();
    }
    
    /**
     * Eligible study grade types are those for which no target exists yet, i.e.
     * for which no study grade type record exists in the target academic year.
     * 
     * @return
     */
    public List<StudyGradeTypeCT> getEligibleStudyGradeTypes() {
        if (studyGradeTypes == null || studyGradeTypes.size() == 0) return null;
        
        List<StudyGradeTypeCT> list = new ArrayList<StudyGradeTypeCT>();
        for (Iterator<StudyGradeTypeCT> it = studyGradeTypes.values().iterator(); it.hasNext(); ) {
            StudyGradeTypeCT sgt = it.next();
            if (sgt.isEligibleForTransition()) {
                list.add(sgt);
            }
        }
        return list;
    }

    public int getTotalStudyGradeTypeCount() {
        return (studyGradeTypes == null ? 0 : studyGradeTypes.size());
    }
    
    public int getEligibleSubjectBlockCount() {
        if (subjectBlocks == null || subjectBlocks.size() == 0) return 0;
        return getEligibleSubjectBlocks().size();
    }
    
    public int getSelectedSubjectBlockCount() {
        List<SubjectBlockCT> selectedSubjectBlocks = getSelectedSubjectBlocks();
        if (selectedSubjectBlocks == null) return 0;
        return selectedSubjectBlocks.size();
    }
    
    /**
     * Eligible subject blocks are those for which no target exists yet, i.e.
     * for which no subject block record exists yet in the target academic year.
     * 
     * @return
     */
    public List<SubjectBlockCT> getEligibleSubjectBlocks() {
        if (subjectBlocks == null || subjectBlocks.size() == 0) return null;
        
        List<SubjectBlockCT> list = new ArrayList<SubjectBlockCT>();
        for (Iterator<SubjectBlockCT> it = subjectBlocks.values().iterator(); it.hasNext(); ) {
            SubjectBlockCT sb = it.next();
            if (sb.isEligibleForTransition()) {
                list.add(sb);
            }
        }
        return list;
    }
    
    public int getTotalSubjectBlockCount() {
        return (subjectBlocks == null ? 0 : subjectBlocks.size());
    }
    
    public int getEligibleSubjectCount() {
        if (subjects == null || subjects.size() == 0) return 0;
        return getEligibleSubjects().size();
    }
    
    public int getSelectedSubjectCount() {
        List<SubjectCT> selectedSubjects = getSelectedSubjects();
        if (selectedSubjects == null) return 0;
        return selectedSubjects.size();
    }
    
    /**
     * Eligible subjects are those for which no target exists yet, i.e. for
     * which no subject record exists yet in the target academic year.
     * 
     * @return
     */
    public List<SubjectCT> getEligibleSubjects() {
        if (subjects == null || subjects.size() == 0) return null;
        
        List<SubjectCT> list = new ArrayList<SubjectCT>();
        for (Iterator<SubjectCT> it = subjects.values().iterator(); it.hasNext(); ) {
            SubjectCT subject = it.next();
            if (subject.isEligibleForTransition()) {
                list.add(subject);
            }
        }
        return list;
    }
    
    public int getTotalSubjectCount() {
        return (subjects == null ? 0 : subjects.size());
    }
    
    public Map<Integer, StudyGradeTypeCT> getStudyGradeTypes() {
        return studyGradeTypes;
    }

    public void setStudyGradeTypes(
            Map<Integer, StudyGradeTypeCT> studyGradeTypes) {
        this.studyGradeTypes = studyGradeTypes;
    }

    public StudyGradeTypeCT getStudyGradeType(int originalId) {
        if (studyGradeTypes == null) return null;
        return studyGradeTypes.get(originalId);
    }
    
    public void addStudyGradeType(StudyGradeTypeCT studyGradeType) {
        if (studyGradeTypes == null) {
            studyGradeTypes = new HashMap<Integer, StudyGradeTypeCT>();
        }
        studyGradeTypes.put(studyGradeType.getOriginalId(), studyGradeType);
    }

    public Map<Integer, SubjectBlockCT> getSubjectBlocks() {
        return subjectBlocks;
    }

    public void setSubjectBlocks(Map<Integer, SubjectBlockCT> subjectBlocks) {
        this.subjectBlocks = subjectBlocks;
    }
    
    public SubjectBlockCT getSubjectBlock(int originalId) {
        if (subjectBlocks == null) return null;
        return subjectBlocks.get(originalId);
    }
    
    public void addSubjectBlock(SubjectBlockCT subjectBlock) {
        if (subjectBlocks == null) {
            subjectBlocks = new HashMap<Integer, SubjectBlockCT>();
        }
        subjectBlocks.put(subjectBlock.getOriginalId(), subjectBlock);
    }

    public Map<Integer, SubjectCT> getSubjects() {
        return subjects;
    }

    public void setSubjects(Map<Integer, SubjectCT> subjects) {
        this.subjects = subjects;
    }
    
    public SubjectCT getSubject(int originalId) {
        if (subjects == null) return null;
        return subjects.get(originalId);
    }
    
    public void addSubject(SubjectCT subject) {
        if (subjects == null) {
            subjects = new HashMap<Integer, SubjectCT>();
        }
        subjects.put(subject.getOriginalId(), subject);
    }

    public void setFromAcademicYearId(int fromAcademicYearId) {
        this.fromAcademicYearId = fromAcademicYearId;
    }

    public int getFromAcademicYearId() {
        return fromAcademicYearId;
    }

    public void setToAcademicYearId(int toAcademicYearId) {
        this.toAcademicYearId = toAcademicYearId;
    }

    public int getToAcademicYearId() {
        return toAcademicYearId;
    }

    public List<Integer> getSelectedStudyGradeTypeIds() {
        
        // form needs non-null collection
        if (selectedStudyGradeTypeIds == null) {
            selectedStudyGradeTypeIds = new ArrayList<Integer>();
        }
        return selectedStudyGradeTypeIds;
    }

    public void setSelectedStudyGradeTypeIds(List<Integer> selectedStudyGradeTypeIds) {
        this.selectedStudyGradeTypeIds = selectedStudyGradeTypeIds;
    }

    public List<Integer> getSelectedSubjectBlockIds() {
        
        // form needs non-null collection
        if (selectedSubjectBlockIds == null) {
            selectedSubjectBlockIds = new ArrayList<Integer>();
        }
        return selectedSubjectBlockIds;
    }

    public void setSelectedSubjectBlockIds(List<Integer> selectedSubjectBlockIds) {
        this.selectedSubjectBlockIds = selectedSubjectBlockIds;
    }

    public List<Integer> getSelectedSubjectIds() {

        // form needs non-null collection
        if (selectedSubjectIds == null) {
            selectedSubjectIds = new ArrayList<Integer>();
        }
        return selectedSubjectIds;
    }

    public void setSelectedSubjectIds(List<Integer> selectedSubjectIds) {
        this.selectedSubjectIds = selectedSubjectIds;
    }

    /**
     * Get the list of selected study grade types, based on the property selectedStudyGradeTypeIds.
     * @return
     */
    public List<StudyGradeTypeCT> getSelectedStudyGradeTypes() {

        List<StudyGradeTypeCT> selectedSGTs = new ArrayList<StudyGradeTypeCT>();
        for (int id : getSelectedStudyGradeTypeIds()) {
            selectedSGTs.add(studyGradeTypes.get(id));
        }
        
        return selectedSGTs;
    }

    /**
     * Get the list of selected subject Blocks, based on the property selectedSubjectBlocks.
     * @return
     */
    public List<SubjectBlockCT> getSelectedSubjectBlocks() {

        List<SubjectBlockCT> selectedSBs = new ArrayList<SubjectBlockCT>();
        for (int id : getSelectedSubjectBlockIds()) {
            selectedSBs.add(subjectBlocks.get(id));
        }
        
        return selectedSBs;
    }

    /**
     * Get the list of selected subjects, based on the property selectedSubjectIds.
     * @return
     */
    public List<SubjectCT> getSelectedSubjects() {

        List<SubjectCT> selectedSujects = new ArrayList<SubjectCT>();
        for (int id : getSelectedSubjectIds()) {
            selectedSujects.add(subjects.get(id));
        }
        
        return selectedSujects;
    }

    public boolean isEndGradesSelectedForTransfer() {
        return endGradesSelectedForTransfer;
    }

    public void setEndGradesSelectedForTransfer(boolean endGradesSelectedForTransfer) {
        this.endGradesSelectedForTransfer = endGradesSelectedForTransfer;
    }

    public int getNrOfGradesEligibleForTransfer() {
        return nrOfGradesEligibleForTransfer;
    }

    public void setNrOfGradesEligibleForTransfer(
            int nrOfGradesEligibleForTransfer) {
        this.nrOfGradesEligibleForTransfer = nrOfGradesEligibleForTransfer;
    }

}
