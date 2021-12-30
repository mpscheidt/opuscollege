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

package org.uci.opus.college.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.uci.opus.util.ListUtil;

/**
 * @author J. Nooitgedagt
 *
 */
public class Subject implements ISubjectExamTest, Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String subjectCode;
    private String subjectDescription;
    private String subjectContentDescription;
    private int primaryStudyId;
    private String active;
    private String targetGroupCode;
    // private String rigidityTypeCode;
    private String freeChoiceOption;
    private BigDecimal creditAmount;
    private int hoursToInvest;
    private String frequencyCode;
    // private String studyFormCode;
    private String studyTimeCode;
    private String examTypeCode;
    private int maximumParticipants;
    private String brsApplyingToSubject;
    private String brsPassingSubject;

    // thematic subjects directly under a studyGradeType
    private List<SubjectStudyGradeType> subjectStudyGradeTypes;

    // subjects within a subjectBlock
    private List<SubjectSubjectBlock> subjectSubjectBlocks;
    private List<SubjectStudyType> subjectStudyTypes;
    private List<SubjectTeacher> subjectTeachers;
    private List<Examination> examinations;
    private List<SubjectClassgroup> subjectClassgroups;

    /* cardinal time unit */
    private int currentAcademicYearId;

    /*
     * academicYear added to avoid looping in jsp's when description is needed; currentAcademicYearId could be removed, but it needs refactoring of the code so for now we keep it
     */
    private AcademicYear academicYear;

    private String resultType;

    private Study primaryStudy;

    public Subject() {
        this.creditAmount = BigDecimal.ZERO;
        this.maximumParticipants = 0;
        this.active = "Y";
    }

    @Override
    public List<? extends ISubjectExamTest> getSubItems() {
        // NB: need to call the getter (rather than returning the field value) so that lazy loading proxy can jump in
        return getExaminations();
    }

    public String getBrsApplyingToSubject() {
        return brsApplyingToSubject;
    }

    public void setBrsApplyingToSubject(String brsApplyingToSubject) {
        this.brsApplyingToSubject = brsApplyingToSubject;
    }

    public String getBrsPassingSubject() {
        return brsPassingSubject;
    }

    public void setBrsPassingSubject(String brsPassingSubject) {
        this.brsPassingSubject = StringUtils.trim(brsPassingSubject);
    }

    public BigDecimal getCreditAmount() {
        return creditAmount;
    }

    public void setCreditAmount(BigDecimal creditAmount) {
        this.creditAmount = creditAmount;
    }

    public List<Examination> getExaminations() {
        return examinations;
    }

    public void setExaminations(List<Examination> examinations) {
        this.examinations = examinations;
    }

    public String getExamTypeCode() {
        return examTypeCode;
    }

    public void setExamTypeCode(String examTypeCode) {
        this.examTypeCode = examTypeCode;
    }

    public String getFreeChoiceOption() {
        return freeChoiceOption;
    }

    public void setFreeChoiceOption(String freeChoiceOption) {
        this.freeChoiceOption = freeChoiceOption;
    }

    public String getFrequencyCode() {
        return frequencyCode;
    }

    public void setFrequencyCode(String frequencyCode) {
        this.frequencyCode = frequencyCode;
    }

    public int getMaximumParticipants() {
        return maximumParticipants;
    }

    public void setMaximumParticipants(int maximumParticipants) {
        this.maximumParticipants = maximumParticipants;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    // public String getRigidityTypeCode() {
    // return rigidityTypeCode;
    // }
    // public void setRigidityTypeCode(String rigidityTypeCode) {
    // this.rigidityTypeCode = rigidityTypeCode;
    // }
    // public String getStudyFormCode() {
    // return studyFormCode;
    // }
    // public void setStudyFormCode(String studyFormCode) {
    // this.studyFormCode = studyFormCode;
    // }
    public List<SubjectStudyGradeType> getSubjectStudyGradeTypes() {
        return subjectStudyGradeTypes;
    }

    public void setSubjectStudyGradeTypes(List<SubjectStudyGradeType> subjectStudyGradeTypes) {
        this.subjectStudyGradeTypes = subjectStudyGradeTypes;
    }

    public String getStudyTimeCode() {
        return studyTimeCode;
    }

    public void setStudyTimeCode(String studyTimeCode) {
        this.studyTimeCode = studyTimeCode;
    }

    public String getCode() {
        return getSubjectCode();
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = StringUtils.trim(subjectCode);
    }

    public String getSubjectContentDescription() {
        return subjectContentDescription;
    }

    public void setSubjectContentDescription(String subjectContentDescription) {
        this.subjectContentDescription = StringUtils.trim(subjectContentDescription);
    }

    public String getDescription() {
        return getSubjectDescription();
    }

    public String getSubjectDescription() {
        return subjectDescription;
    }

    public void setSubjectDescription(String subjectDescription) {
        this.subjectDescription = StringUtils.trim(subjectDescription);
    }

    public String getTargetGroupCode() {
        return targetGroupCode;
    }

    public void setTargetGroupCode(String targetGroupCode) {
        this.targetGroupCode = targetGroupCode;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<SubjectStudyType> getSubjectStudyTypes() {
        return subjectStudyTypes;
    }

    public void setSubjectStudyTypes(List<SubjectStudyType> subjectStudyTypes) {
        this.subjectStudyTypes = subjectStudyTypes;
    }

    public int getHoursToInvest() {
        return hoursToInvest;
    }

    public void setHoursToInvest(int hoursToInvest) {
        this.hoursToInvest = hoursToInvest;
    }

    public int getPrimaryStudyId() {
        return primaryStudyId;
    }

    public void setPrimaryStudyId(int primaryStudyId) {
        this.primaryStudyId = primaryStudyId;
    }

    // public int getSubjectStructureValidFromYear() {
    // return subjectStructureValidFromYear;
    // }
    // public void setSubjectStructureValidFromYear(
    // int subjectStructureValidFromYear) {
    // this.subjectStructureValidFromYear = subjectStructureValidFromYear;
    // }
    // public int getSubjectStructureValidThroughYear() {
    // return subjectStructureValidThroughYear;
    // }
    // public void setSubjectStructureValidThroughYear(
    // int subjectStructureValidThroughYear) {
    // this.subjectStructureValidThroughYear = subjectStructureValidThroughYear;
    // }

    public List<SubjectTeacher> getSubjectTeachers() {
        return subjectTeachers;
    }

    public void setSubjectTeachers(List<SubjectTeacher> subjectTeachers) {
        this.subjectTeachers = subjectTeachers;
    }

    public List<SubjectSubjectBlock> getSubjectSubjectBlocks() {
        return subjectSubjectBlocks;
    }

    public void setSubjectSubjectBlocks(List<SubjectSubjectBlock> subjectSubjectBlocks) {
        this.subjectSubjectBlocks = subjectSubjectBlocks;
    }

    /* cardinal time unit */
    public int getCurrentAcademicYearId() {
        return currentAcademicYearId;
    }

    public void setCurrentAcademicYearId(int currentAcademicYearId) {
        this.currentAcademicYearId = currentAcademicYearId;
    }

    public AcademicYear getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(AcademicYear academicYear) {
        this.academicYear = academicYear;
    }

    public String getResultType() {
        return resultType;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    @Override
    public int hashCode() {
        // note the conditions of hashCode() in relation to the equals() method
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Subject))
            return false;

        Subject other = (Subject) obj;
        return other.getId() == getId();
    }

    /**
     * Test if the given staffMember is assigned to the subject as a teacher.
     * 
     * @param staffMemberId
     * @return
     */
    @Override
    public boolean isAssignedTeacher(int staffMemberId, Integer classgroupId) {
        boolean isSubjectTeacher = false;
        int classgroupStudentId = classgroupId != null ? classgroupId : 0;
        if (getSubjectTeachers() != null) {
            for (SubjectTeacher subjectTeacher : getSubjectTeachers()) {
                if (staffMemberId == subjectTeacher.getStaffMemberId()) {
                    int classgroupTeacherId = subjectTeacher.getClassgroupId() != null ? subjectTeacher.getClassgroupId() : 0;
                    if (classgroupStudentId == 0 || classgroupTeacherId == 0) {
                        isSubjectTeacher = true;
                        break;
                    } else if (classgroupStudentId == classgroupTeacherId) {
                        isSubjectTeacher = true;
                        break;
                    }
                }
            }
        }
        return isSubjectTeacher;
    }

    /*
     * In order to link a subject to a studygradeType it must have at least one subject teacher defined. Furthermore, if examinations are defined, these must have at least one
     * examination teacher defined.
     */
    public boolean isLinkSubjectAndStudyGradeTypeIsAllowed() {
        boolean isAllowed = false;
        if (!ListUtil.isNullOrEmpty(getSubjectTeachers())) {
            if (!ListUtil.isNullOrEmpty(getExaminations())) {
                isAllowed = true;
                for (int i = 0; i < getExaminations().size(); i++) {

                    if (ListUtil.isNullOrEmpty(getExaminations().get(i).getTeachersForExamination())) {
                        isAllowed = false;
                        break;
                    }
                }
            } else {
                isAllowed = true;
            }
        }
        return isAllowed;
    }

    public List<SubjectClassgroup> getSubjectClassgroups() {
        return subjectClassgroups;
    }

    public void setSubjectClassgroups(List<SubjectClassgroup> subjectClassgroups) {
        this.subjectClassgroups = subjectClassgroups;
    }

    @Override
    public String toString() {
        return "Subject [id=" + id + ", subjectCode=" + subjectCode + ", subjectDescription=" + subjectDescription + "]";
    }

    public Study getPrimaryStudy() {
        return primaryStudy;
    }

    public void setPrimaryStudy(Study primaryStudy) {
        this.primaryStudy = primaryStudy;
    }

}
