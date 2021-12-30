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

import org.apache.commons.lang3.StringUtils;

/**
 * @author J.Nooitgedagt
 *
 */
public class Study implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String studyDescription;
    private int organizationalUnitId;
    private String academicFieldCode;
    private Date dateOfEstablishment;
    private Date startDate;
    private String minimumMarkSubject;
    private String maximumMarkSubject;
    private String BRsPassingSubject;
    private String active;
    private List<StudyGradeType> studyGradeTypes;
    private List<SubjectBlock> subjectBlocks;
    private List<Address> addresses;

    public List<Address> getAddresses() {
        return addresses;
    }

    public void setAddresses(List<Address> newAddresses) {
        addresses = newAddresses;
    }

    /**
     * @return Returns the dateOfEstablishment.
     */
    public Date getDateOfEstablishment() {
        return dateOfEstablishment;
    }

    /**
     * @param dateOfEstablishment
     *            The dateOfEstablishment to set.
     */
    public void setDateOfEstablishment(Date dateOfEstablishment) {
        this.dateOfEstablishment = dateOfEstablishment;
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

    /**
     * @return Returns the organizationalUnitId.
     */
    public int getOrganizationalUnitId() {
        return organizationalUnitId;
    }

    /**
     * @param organizationalUnitId
     *            The organizationalUnitId to set.
     */
    public void setOrganizationalUnitId(int organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }

    /**
     * @return Returns the studyDescription.
     */
    public String getStudyDescription() {
        return studyDescription;
    }

    /**
     * @param studyDescription
     *            The studyDescription to set.
     */
    public void setStudyDescription(String studyDescription) {
        this.studyDescription = StringUtils.trim(studyDescription);
    }

    public String getAcademicFieldCode() {
        return academicFieldCode;
    }

    public void setAcademicFieldCode(String newAcademicFieldCode) {
        academicFieldCode = newAcademicFieldCode;
    }

    public List<StudyGradeType> getStudyGradeTypes() {
        return studyGradeTypes;
    }

    public void setStudyGradeTypes(List<StudyGradeType> newStudyGradeTypes) {
        studyGradeTypes = newStudyGradeTypes;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public String getMinimumMarkSubject() {
        return minimumMarkSubject;
    }

    public void setMinimumMarkSubject(String minimumMarkSubject) {
        this.minimumMarkSubject = StringUtils.trim(minimumMarkSubject);
    }

    public String getMaximumMarkSubject() {
        return maximumMarkSubject;
    }

    public void setMaximumMarkSubject(String maximumMarkSubject) {
        this.maximumMarkSubject = StringUtils.trim(maximumMarkSubject);
    }

    public String getBRsPassingSubject() {
        return BRsPassingSubject;
    }

    public void setBRsPassingSubject(String rsPassingSubject) {
        BRsPassingSubject = StringUtils.trim(rsPassingSubject);
    }

    public List<SubjectBlock> getSubjectBlocks() {
        return subjectBlocks;
    }

    public void setSubjectBlocks(List<SubjectBlock> subjectBlocks) {
        this.subjectBlocks = subjectBlocks;
    }

}
