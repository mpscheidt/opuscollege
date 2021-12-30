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
import java.util.Date;
import java.util.List;

public class Thesis implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private String thesisCode;
    private String thesisDescription;
    private String thesisContentDescription;
    private int creditAmount;
    private String brsApplyingToThesis;
    private String brsPassingThesis;
    private String keywords;
    private String researchers;
    private String supervisors;
    private String publications;
    private String readingCommittee;
    private String defenseCommittee;
    private String statusOfClearness;
    private Date thesisStatusDate;
    private int startAcademicYearId; // year(s) of research
    private Double affiliationFee;
    private String research;
    private String nonRelatedPublications; // publishedWorks - textarea
    private String active;

    private List<ThesisSupervisor> thesisSupervisors;
    private List<ThesisStatus> thesisStatuses;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getThesisCode() {
        return thesisCode;
    }

    public void setThesisCode(String thesisCode) {
        this.thesisCode = thesisCode;
    }

    public String getThesisDescription() {
        return thesisDescription;
    }

    public void setThesisDescription(String thesisDescription) {
        this.thesisDescription = thesisDescription;
    }

    public String getThesisContentDescription() {
        return thesisContentDescription;
    }

    public void setThesisContentDescription(String thesisContentDescription) {
        this.thesisContentDescription = thesisContentDescription;
    }

    public int getCreditAmount() {
        return creditAmount;
    }

    public void setCreditAmount(int creditAmount) {
        this.creditAmount = creditAmount;
    }

    public String getBrsApplyingToThesis() {
        return brsApplyingToThesis;
    }

    public void setBrsApplyingToThesis(String brsApplyingToThesis) {
        this.brsApplyingToThesis = brsApplyingToThesis;
    }

    public String getBrsPassingThesis() {
        return brsPassingThesis;
    }

    public void setBrsPassingThesis(String brsPassingThesis) {
        this.brsPassingThesis = brsPassingThesis;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getResearchers() {
        return researchers;
    }

    public void setResearchers(String researchers) {
        this.researchers = researchers;
    }

    public String getSupervisors() {
        return supervisors;
    }

    public void setSupervisors(String supervisors) {
        this.supervisors = supervisors;
    }

    public String getPublications() {
        return publications;
    }

    public void setPublications(String publications) {
        this.publications = publications;
    }

    public String getReadingCommittee() {
        return readingCommittee;
    }

    public void setReadingCommittee(String readingCommittee) {
        this.readingCommittee = readingCommittee;
    }

    public String getDefenseCommittee() {
        return defenseCommittee;
    }

    public void setDefenseCommittee(String defenseCommittee) {
        this.defenseCommittee = defenseCommittee;
    }

    public String getStatusOfClearness() {
        return statusOfClearness;
    }

    public void setStatusOfClearness(String statusOfClearness) {
        this.statusOfClearness = statusOfClearness;
    }

    public Date getThesisStatusDate() {
        return thesisStatusDate;
    }

    public void setThesisStatusDate(Date thesisStatusDate) {
        this.thesisStatusDate = thesisStatusDate;
    }

    public int getStartAcademicYearId() {
        return startAcademicYearId;
    }

    public void setStartAcademicYearId(int startAcademicYearId) {
        this.startAcademicYearId = startAcademicYearId;
    }

    public Double getAffiliationFee() {
        return affiliationFee;
    }

    public void setAffiliationFee(Double affiliationFee) {
        this.affiliationFee = affiliationFee;
    }

    public String getResearch() {
        return research;
    }

    public void setResearch(String research) {
        this.research = research;
    }

    public String getNonRelatedPublications() {
        return nonRelatedPublications;
    }

    public void setNonRelatedPublications(String nonRelatedPublications) {
        this.nonRelatedPublications = nonRelatedPublications;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public List<ThesisSupervisor> getThesisSupervisors() {
        return thesisSupervisors;
    }

    public void setThesisSupervisors(List<ThesisSupervisor> thesisSupervisors) {
        this.thesisSupervisors = thesisSupervisors;
    }

    public List<ThesisStatus> getThesisStatuses() {
        return thesisStatuses;
    }

    public void setThesisStatuses(List<ThesisStatus> thesisStatuses) {
        this.thesisStatuses = thesisStatuses;
    }

    public int getStudyPlanId() {
        return studyPlanId;
    }

    public void setStudyPlanId(int studyPlanId) {
        this.studyPlanId = studyPlanId;
    }

}
