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

import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.config.OpusConstants;

/**
 * @author J.Nooitgedagt
 * @author markus
 */
public class StudyPlanDetail implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private int studyPlanCardinalTimeUnitId;
    private int subjectBlockId;
    private int subjectId;
    private int studyGradeTypeId;
    private boolean exempted;
    private String active;
    private List<ExaminationResult> examinationResults;
    private List<TestResult> testResults;
    private List<Subject> subjects; // in case of subjectBlock, here can be all subjects
    private SubjectBlock subjectBlock;
    private List<SubjectResult> subjectResults;

    public StudyPlanDetail() {
        this.active = OpusConstants.ACTIVE;
    }

    public StudyPlanDetail(int subjectId, int subjectBlockId, int studyGradeTypeId, int studyPlanCardinalTimeUnitId, int studyPlanId) {
        this();
        this.subjectId = subjectId;
        this.subjectBlockId = subjectBlockId;
        this.studyGradeTypeId = studyGradeTypeId;
        this.studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnitId;
        this.studyPlanId = studyPlanId;
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

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public int getStudyPlanId() {
        return studyPlanId;
    }

    public void setStudyPlanId(int newStudyPlanId) {
        studyPlanId = newStudyPlanId;
    }

    public int getSubjectBlockId() {
        return subjectBlockId;
    }

    public void setSubjectBlockId(int newSubjectBlockId) {
        subjectBlockId = newSubjectBlockId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int newSubjectId) {
        subjectId = newSubjectId;
    }

    /**
     * @return the studyGradeTypeId
     */
    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    /**
     * @param studyGradeTypeId
     *            the studyGradeTypeId to set
     */
    public void setStudyGradeTypeId(int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }

    public int getStudyPlanCardinalTimeUnitId() {
        return studyPlanCardinalTimeUnitId;
    }

    public void setStudyPlanCardinalTimeUnitId(int studyPlanCardinalTimeUnitId) {
        this.studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnitId;
    }

    public List< ExaminationResult> getExaminationResults() {
        return examinationResults;
    }

    public void setExaminationResults(List< ExaminationResult> examinationResults) {
        this.examinationResults = examinationResults;
    }

    public List< TestResult> getTestResults() {
        return testResults;
    }

    public void setTestResults(List< TestResult> testResults) {
        this.testResults = testResults;
    }

    /**
     * When this object is loaded using the result map, the list of subjects includes those inside subject blocks.
     * @return
     */
    public List< Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(List< Subject> subjects) {
        this.subjects = subjects;
    }

    public List< SubjectResult> getSubjectResults() {
        return subjectResults;
    }

    public void setSubjectResults(List< SubjectResult> subjectResults) {
        this.subjectResults = subjectResults;
    }

    public SubjectBlock getSubjectBlock() {
        return subjectBlock;
    }

    public void setSubjectBlock(SubjectBlock subjectBlock) {
        this.subjectBlock = subjectBlock;
    }

    public boolean isExempted() {
        return exempted;
    }

    public void setExempted(boolean exempted) {
        this.exempted = exempted;
    }

}
