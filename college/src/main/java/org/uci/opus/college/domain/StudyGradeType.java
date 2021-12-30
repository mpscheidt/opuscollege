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
import java.util.List;

import org.apache.commons.lang3.StringUtils;

/**
 * @author J.Nooitgedagt
 */
public class StudyGradeType implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyId;
    private String studyGradeTypeCode;
    private String gradeTypeCode;
    private String studyDescription;
    private String gradeTypeDescription;
    private String targetGroupCode;
    private int contactId;
    private String disciplineGroupCode;
    private String active;
    private List<? extends SubjectStudyGradeType> subjectsStudyGradeType;
    private List<? extends SubjectBlockStudyGradeType> subjectBlocksStudyGradeType;
    private List<StudyGradeTypePrerequisite> studyGradeTypePrerequisites;
    private List<CardinalTimeUnitStudyGradeType> cardinalTimeUnitStudyGradeTypes;
    private List<Classgroup> classgroups;

    /* cardinal time unit */
    private String studyTimeCode;
    private String studyFormCode;
    private String studyIntensityCode;
    private int currentAcademicYearId;
    private String cardinalTimeUnitCode;
    private int numberOfCardinalTimeUnits;
    private int maxNumberOfCardinalTimeUnits;
    private int numberOfSubjectsPerCardinalTimeUnit;
    private int maxNumberOfSubjectsPerCardinalTimeUnit;
    private int maxNumberOfFailedSubjectsPerCardinalTimeUnit;
    private int maxNumberOfStudents;
    private String BRsPassingSubject;

    private Study study;

    public StudyGradeType() {
    }

    /**
     * @return Returns the contactId.
     */
    public int getContactId() {
        return contactId;
    }

    /**
     * @param contactId
     *            The contactId to set.
     */
    public void setContactId(int contactId) {
        this.contactId = contactId;
    }

    /**
     * @return Returns the id.
     */
    public int getId() {
        return id;
    }

    /**
     * @param id
     *            The id to set.
     */
    public void setId(int id) {
        this.id = id;
    }

    public String getGradeTypeCode() {
        return gradeTypeCode;
    }

    public void setGradeTypeCode(String newGradeTypeCode) {
        gradeTypeCode = newGradeTypeCode;
    }

    public int getStudyId() {
        return studyId;
    }

    public void setStudyId(int newStudyId) {
        studyId = newStudyId;
    }

    public String getTargetGroupCode() {
        return targetGroupCode;
    }

    public void setTargetGroupCode(String newTargetGroupCode) {
        targetGroupCode = newTargetGroupCode;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public String getDisciplineGroupCode() {
        return disciplineGroupCode;
    }

    public void setDisciplineGroupCode(String disciplineGroupCode) {
        this.disciplineGroupCode = disciplineGroupCode;
    }

    public String getGradeTypeDescription() {
        return gradeTypeDescription;
    }

    public void setGradeTypeDescription(String gradeTypeDescription) {
        this.gradeTypeDescription = gradeTypeDescription;
    }

    public String getStudyDescription() {
        return studyDescription;
    }

    public void setStudyDescription(String studyDescription) {
        this.studyDescription = studyDescription;
    }

    public List<? extends SubjectStudyGradeType> getSubjectsStudyGradeType() {
        return subjectsStudyGradeType;
    }

    public void setSubjectsStudyGradeType(List<? extends SubjectStudyGradeType> subjectsStudyGradeType) {
        this.subjectsStudyGradeType = subjectsStudyGradeType;
    }

    public List<? extends SubjectBlockStudyGradeType> getSubjectBlocksStudyGradeType() {
        return subjectBlocksStudyGradeType;
    }

    public void setSubjectBlocksStudyGradeType(List<? extends SubjectBlockStudyGradeType> subjectBlocksStudyGradeType) {
        this.subjectBlocksStudyGradeType = subjectBlocksStudyGradeType;
    }

    public List<StudyGradeTypePrerequisite> getStudyGradeTypePrerequisites() {
        return studyGradeTypePrerequisites;
    }

    public void setStudyGradeTypePrerequisites(List<StudyGradeTypePrerequisite> studyGradeTypePrerequisites) {
        this.studyGradeTypePrerequisites = studyGradeTypePrerequisites;
    }

    /* cardinal time unit */
    public String getStudyTimeCode() {
        return studyTimeCode;
    }

    public void setStudyTimeCode(String studyTimeCode) {
        this.studyTimeCode = studyTimeCode;
    }

    public String getStudyIntensityCode() {
        return studyIntensityCode;
    }

    public void setStudyIntensityCode(String studyIntensityCode) {
        this.studyIntensityCode = studyIntensityCode;
    }

    public int getCurrentAcademicYearId() {
        return currentAcademicYearId;
    }

    public void setCurrentAcademicYearId(int currentAcademicYearId) {
        this.currentAcademicYearId = currentAcademicYearId;
    }

    public String getCardinalTimeUnitCode() {
        return cardinalTimeUnitCode;
    }

    public void setCardinalTimeUnitCode(String cardinalTimeUnitCode) {
        this.cardinalTimeUnitCode = cardinalTimeUnitCode;
    }

    public String getStudyFormCode() {
        return studyFormCode;
    }

    public void setStudyFormCode(String studyFormCode) {
        this.studyFormCode = studyFormCode;
    }

    public int getNumberOfCardinalTimeUnits() {
        return numberOfCardinalTimeUnits;
    }

    public void setNumberOfCardinalTimeUnits(int numberOfCardinalTimeUnits) {
        this.numberOfCardinalTimeUnits = numberOfCardinalTimeUnits;
    }

    public int getMaxNumberOfCardinalTimeUnits() {
        return maxNumberOfCardinalTimeUnits;
    }

    public void setMaxNumberOfCardinalTimeUnits(int maxNumberOfCardinalTimeUnits) {
        this.maxNumberOfCardinalTimeUnits = maxNumberOfCardinalTimeUnits;
    }

    public int getNumberOfSubjectsPerCardinalTimeUnit() {
        return numberOfSubjectsPerCardinalTimeUnit;
    }

    public void setNumberOfSubjectsPerCardinalTimeUnit(int numberOfSubjectsPerCardinalTimeUnit) {
        this.numberOfSubjectsPerCardinalTimeUnit = numberOfSubjectsPerCardinalTimeUnit;
    }

    public int getMaxNumberOfSubjectsPerCardinalTimeUnit() {
        return maxNumberOfSubjectsPerCardinalTimeUnit;
    }

    public void setMaxNumberOfSubjectsPerCardinalTimeUnit(int maxNumberOfSubjectsPerCardinalTimeUnit) {
        this.maxNumberOfSubjectsPerCardinalTimeUnit = maxNumberOfSubjectsPerCardinalTimeUnit;
    }

    public int getMaxNumberOfFailedSubjectsPerCardinalTimeUnit() {
        return maxNumberOfFailedSubjectsPerCardinalTimeUnit;
    }

    public void setMaxNumberOfFailedSubjectsPerCardinalTimeUnit(int maxNumberOfFailedSubjectsPerCardinalTimeUnit) {
        this.maxNumberOfFailedSubjectsPerCardinalTimeUnit = maxNumberOfFailedSubjectsPerCardinalTimeUnit;
    }

    public int getMaxNumberOfStudents() {
        return maxNumberOfStudents;
    }

    public void setMaxNumberOfStudents(int maxNumberOfStudents) {
        this.maxNumberOfStudents = maxNumberOfStudents;
    }

    public String getBRsPassingSubject() {
        return BRsPassingSubject;
    }

    public void setBRsPassingSubject(String rsPassingSubject) {
        BRsPassingSubject = StringUtils.trim(rsPassingSubject);
    }

    public List<CardinalTimeUnitStudyGradeType> getCardinalTimeUnitStudyGradeTypes() {
        return cardinalTimeUnitStudyGradeTypes;
    }

    public void setCardinalTimeUnitStudyGradeTypes(List<CardinalTimeUnitStudyGradeType> cardinalTimeUnitStudyGradeTypes) {
        this.cardinalTimeUnitStudyGradeTypes = cardinalTimeUnitStudyGradeTypes;
    }

    public String getStudyGradeTypeCode() {
        return studyGradeTypeCode;
    }

    public void setStudyGradeTypeCode(String studyGradeTypeCode) {
        this.studyGradeTypeCode = StringUtils.trim(studyGradeTypeCode);
    }

    public Study getStudy() {
        return study;
    }

    public void setStudy(Study study) {
        this.study = study;
    }

    public List<Classgroup> getClassgroups() {
        return classgroups;
    }

    public void setClassgroups(List<Classgroup> classgroups) {
        this.classgroups = classgroups;
    }

}
