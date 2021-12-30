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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.config.OpusConstants;

/**
 * @author M. in het Veld
 * @author markus
 */

public class StudyPlanCardinalTimeUnit implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private int studyGradeTypeId;
    // private int currentAcademicYearId;
    private int cardinalTimeUnitNumber;
    private List<StudyPlanDetail> studyPlanDetails;
    private String active;
    private CardinalTimeUnitResult cardinalTimeUnitResult;
    private String progressStatusCode;
    private boolean progressStatusPreselect;
    private String cardinalTimeUnitStatusCode;
    private List<Rfc> rfcs;

    private List<? extends SubjectResult> subjectResults;
    private String tuitionWaiver;
    private String studyIntensityCode;
    private String writeWho;
    private Date writeWhen;

    private StudyPlan studyPlan;

    // dynamically determined properties (not stored in DB)
    private boolean resultsPublished;

    public StudyPlanCardinalTimeUnit() {
        progressStatusPreselect = false;
    }

    /**
     * Check if this instance of {@link StudyPlanCardinalTimeUnit} has a progress status which can be considered empty, i.e. null, empty
     * string or '0'.
     * 
     * @return
     */
    public boolean isEmptyProgressStatus() {
        boolean empty = progressStatusCode == null || progressStatusCode.isEmpty() || "0".equals(progressStatusCode);
        return empty;
    }

    /**
     * Test if the progress status code is equal to {@link OpusConstants#PROGRESS_STATUS_WAITING_FOR_RESULTS}
     * 
     * @return
     */
    public boolean isProgressStatusWaitingForResults() {
        return OpusConstants.PROGRESS_STATUS_WAITING_FOR_RESULTS.equals(progressStatusCode);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudyPlanId() {
        return studyPlanId;
    }

    public void setStudyPlanId(int studyPlanId) {
        this.studyPlanId = studyPlanId;
    }

    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    public void setStudyGradeTypeId(int newStudyGradeTypeId) {
        studyGradeTypeId = newStudyGradeTypeId;
    }

    public String getProgressStatusCode() {
        return progressStatusCode;
    }

    public void setProgressStatusCode(String progressStatusCode) {
        this.progressStatusCode = progressStatusCode;
    }

    public boolean isProgressStatusPreselect() {
        return progressStatusPreselect;
    }

    public void setProgressStatusPreselect(boolean progressStatusPreselect) {
        this.progressStatusPreselect = progressStatusPreselect;
    }

    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }

    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

    public List<StudyPlanDetail> getStudyPlanDetails() {
        return studyPlanDetails;
    }

    public void setStudyPlanDetails(List<StudyPlanDetail> studyPlanDetails) {
        this.studyPlanDetails = studyPlanDetails;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public CardinalTimeUnitResult getCardinalTimeUnitResult() {
        return cardinalTimeUnitResult;
    }

    public void setCardinalTimeUnitResult(CardinalTimeUnitResult cardinalTimeUnitResult) {
        this.cardinalTimeUnitResult = cardinalTimeUnitResult;
    }

    public void setCardinalTimeUnitStatusCode(String cardinalTimeUnitStatusCode) {
        this.cardinalTimeUnitStatusCode = cardinalTimeUnitStatusCode;
    }

    public String getCardinalTimeUnitStatusCode() {
        return cardinalTimeUnitStatusCode;
    }

    public String getTuitionWaiver() {
        return tuitionWaiver;
    }

    public void setTuitionWaiver(String tuitionWaiver) {
        this.tuitionWaiver = tuitionWaiver;
    }

    public void setRfcs(List<Rfc> rfcs) {
        this.rfcs = rfcs;
    }

    public List<Rfc> getRfcs() {
        return rfcs;
    }

    public Rfc getLatestRfc() {
        Rfc latest = null;
        if (rfcs != null) {
            for (Rfc rfc : rfcs) {
                if (latest == null || rfc.getWriteWhen().compareTo(latest.getWriteWhen()) > 0) {
                    latest = rfc;
                }
            }
        }
        return latest;
    }

    /**
     * @return the subjectResults
     */
    public List<? extends SubjectResult> getSubjectResults() {
        return subjectResults;
    }

    /**
     * @param subjectResults
     *            the subjectResults to set
     */
    public void setSubjectResults(List<? extends SubjectResult> subjectResults) {
        this.subjectResults = subjectResults;
    }

    /**
     * Get a list of all subjects that are linked to this time unit via the studyPlanDetails.
     * The list of subjects includes subjects inside subject blocks.
     * 
     * @return the subjects
     */
    public List<Subject> getSubjects() {
        
        List<Subject> subjects = new ArrayList<>();
        
        for (StudyPlanDetail sdp : studyPlanDetails) {
            subjects.addAll(sdp.getSubjects());
        }
        
        return subjects;
    }

    public void setStudyIntensityCode(String studyIntensityCode) {
        this.studyIntensityCode = studyIntensityCode;
    }

    public String getStudyIntensityCode() {
        return studyIntensityCode;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public Date getWriteWhen() {
        return writeWhen;
    }

    public void setWriteWhen(Date writeWhen) {
        this.writeWhen = writeWhen;
    }

    public boolean isResultsPublished() {
        return resultsPublished;
    }

    public void setResultsPublished(boolean resultsPublished) {
        this.resultsPublished = resultsPublished;
    }

    public StudyPlan getStudyPlan() {
        return studyPlan;
    }

    public void setStudyPlan(StudyPlan studyPlan) {
        this.studyPlan = studyPlan;
    }

}
