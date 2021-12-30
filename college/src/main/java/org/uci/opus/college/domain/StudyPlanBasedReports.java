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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

import java.util.Date;

public class StudyPlanBasedReports {

    private int id;
    private String surnameFull;
    private String firstnamesFull;
    private String civilTitleCode;
    private Date birthdate;
    private String studyPlanDescription;
    private String gradeTypeCode;
    private String studyDescription;
    private int numberOfYears;
    private int personId;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getSurnameFull() {
        return surnameFull;
    }
    public void setSurnameFull(String surnameFull) {
        this.surnameFull = surnameFull;
    }
    public String getFirstnamesFull() {
        return firstnamesFull;
    }
    public void setFirstnamesFull(String firstnamesFull) {
        this.firstnamesFull = firstnamesFull;
    }
    public String getCivilTitleCode() {
        return civilTitleCode;
    }
    public void setCivilTitleCode(String civilTitleCode) {
        this.civilTitleCode = civilTitleCode;
    }
    public Date getBirthdate() {
        return birthdate;
    }
    public void setBirthdate(Date birthdate) {
        this.birthdate = birthdate;
    }
    public String getGradeTypeCode() {
        return gradeTypeCode;
    }
    public void setGradeTypeCode(String gradeTypeCode) {
        this.gradeTypeCode = gradeTypeCode;
    }
    public String getStudyPlanDescription() {
        return studyPlanDescription;
    }
    public void setStudyPlanDescription(String studyPlanDescription) {
        this.studyPlanDescription = studyPlanDescription;
    }
    public int getNumberOfYears() {
        return numberOfYears;
    }
    public void setNumberOfYears(int numberOfYears) {
        this.numberOfYears = numberOfYears;
    }
    public String getStudyDescription() {
        return studyDescription;
    }
    public void setStudyDescription(String studyDescription) {
        this.studyDescription = studyDescription;
    }
    public int getPersonId() {
        return personId;
    }
    public void setPersonId(int personId) {
        this.personId = personId;
    }


}
