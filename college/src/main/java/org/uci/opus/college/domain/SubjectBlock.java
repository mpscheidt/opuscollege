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
 * @author move
 *
 */
public class SubjectBlock implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String subjectBlockCode;
    private String subjectBlockDescription;
    private int primaryStudyId;
    private String active;
    private String targetGroupCode;
    private String brsPassingSubjectBlock;
    private String blockTypeCode;
    private String brsMaxContactHours;
    private String studyTimeCode;
    private int currentAcademicYearId;
    private String freeChoiceOption;
    private List<? extends SubjectSubjectBlock> subjectSubjectBlocks;
    private List<? extends SubjectBlockStudyGradeType> subjectBlockStudyGradeTypes;

    private Study primaryStudy;

    public SubjectBlock() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSubjectBlockCode() {
        return subjectBlockCode;
    }

    public void setSubjectBlockCode(String subjectBlockCode) {
        this.subjectBlockCode = StringUtils.trim(subjectBlockCode);
    }

    public String getSubjectBlockDescription() {
        return subjectBlockDescription;
    }

    public void setSubjectBlockDescription(String subjectBlockDescription) {
        this.subjectBlockDescription = StringUtils.trim(subjectBlockDescription);
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public String getTargetGroupCode() {
        return targetGroupCode;
    }

    public void setTargetGroupCode(String targetGroupCode) {
        this.targetGroupCode = targetGroupCode;
    }

    public String getBrsPassingSubjectBlock() {
        return brsPassingSubjectBlock;
    }

    public void setBrsPassingSubjectBlock(String brsPassingSubjectBlock) {
        this.brsPassingSubjectBlock = StringUtils.trim(brsPassingSubjectBlock);
    }

    public List<? extends SubjectSubjectBlock> getSubjectSubjectBlocks() {
        return subjectSubjectBlocks;
    }

    public void setSubjectSubjectBlocks(List<? extends SubjectSubjectBlock> subjectSubjectBlocks) {
        this.subjectSubjectBlocks = subjectSubjectBlocks;
    }

    public String getBlockTypeCode() {
        return blockTypeCode;
    }

    public void setBlockTypeCode(String blockTypeCode) {
        this.blockTypeCode = blockTypeCode;
    }

    public String getBrsMaxContactHours() {
        return brsMaxContactHours;
    }

    public void setBrsMaxContactHours(String brsMaxContactHours) {
        this.brsMaxContactHours = StringUtils.trim(brsMaxContactHours);
    }

    public String getStudyTimeCode() {
        return studyTimeCode;
    }

    public void setStudyTimeCode(String studyTimeCode) {
        this.studyTimeCode = studyTimeCode;
    }

    public int getCurrentAcademicYearId() {
        return currentAcademicYearId;
    }

    public void setCurrentAcademicYearId(int currentAcademicYearId) {
        this.currentAcademicYearId = currentAcademicYearId;
    }

    public int getPrimaryStudyId() {
        return primaryStudyId;
    }

    public void setPrimaryStudyId(int primaryStudyId) {
        this.primaryStudyId = primaryStudyId;
    }

    public List<? extends SubjectBlockStudyGradeType> getSubjectBlockStudyGradeTypes() {
        return subjectBlockStudyGradeTypes;
    }

    public void setSubjectBlockStudyGradeTypes(List<? extends SubjectBlockStudyGradeType> subjectBlockStudyGradeTypes) {
        this.subjectBlockStudyGradeTypes = subjectBlockStudyGradeTypes;
    }

    public String getFreeChoiceOption() {
        return freeChoiceOption;
    }

    public void setFreeChoiceOption(String freeChoiceOption) {
        this.freeChoiceOption = freeChoiceOption;
    }

    @Override
    public int hashCode() {
        return getId();
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof SubjectBlock))
            return false;

        SubjectBlock other = (SubjectBlock) obj;
        return other.getId() == getId();
    }

    public String toString() {
        return "\n SubjectBlock is: " + "\n id = " + id + "\n subjectBlockCode = " + subjectBlockCode + "\n subjectBlockDescription = "
                + subjectBlockDescription + "\n currentAcademicYearId = " + currentAcademicYearId + "\n primaryStudyId = " + primaryStudyId
                + "\n blockTypeCode = " + blockTypeCode + "\n targetGroupCode = " + targetGroupCode + "\n studyTimeCode = " + studyTimeCode
                + "\n freeChoiceOption = " + freeChoiceOption + "\n brsMaxContactHours = " + brsMaxContactHours + "\n brsPassingSubjectBlock = "
                + brsPassingSubjectBlock + "\n active = " + active;
    }

    public Study getPrimaryStudy() {
        return primaryStudy;
    }

    public void setPrimaryStudy(Study primaryStudy) {
        this.primaryStudy = primaryStudy;
    }

}
