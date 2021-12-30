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

package org.uci.opus.college.web.form.study;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.web.flow.study.CurriculumTransitionData;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.CodeToLookupMap;

public class CurriculumTransitionForm {

    private Organization organization;
    private int studyId;
    private CurriculumTransitionData data;
    private boolean checker = true;    // to remember the state in case of binding errors

    private List<AcademicYear> fromAcademicYears;
    private List<AcademicYear> toAcademicYears;
    private List<Study> allStudies;

    // utility
    private CodeToLookupMap codeToGradeTypeMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyFormMap;
    private IdToStudyGradeTypeMap idToStudyGradeTypeMap;


    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public int getStudyId() {
        return studyId;
    }

    public void setStudyId(int studyId) {
        this.studyId = studyId;
    }

    public CurriculumTransitionData getData() {
        return data;
    }

    public void setData(CurriculumTransitionData data) {
        this.data = data;
    }

    public boolean isChecker() {
        return checker;
    }

    public void setChecker(boolean checker) {
        this.checker = checker;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
    }

    public IdToStudyGradeTypeMap getIdToStudyGradeTypeMap() {
        return idToStudyGradeTypeMap;
    }

    public void setIdToStudyGradeTypeMap(IdToStudyGradeTypeMap idToStudyGradeTypeMap) {
        this.idToStudyGradeTypeMap = idToStudyGradeTypeMap;
    }

    public List<AcademicYear> getFromAcademicYears() {
        return fromAcademicYears;
    }

    public void setFromAcademicYears(List<AcademicYear> fromAcademicYears) {
        this.fromAcademicYears = fromAcademicYears;
    }

    public List<AcademicYear> getToAcademicYears() {
        return toAcademicYears;
    }

    public void setToAcademicYears(List<AcademicYear> toAcademicYears) {
        this.toAcademicYears = toAcademicYears;
    }

    public List<Study> getAllStudies() {
        return allStudies;
    }

    public void setAllStudies(List<Study> allStudies) {
        this.allStudies = allStudies;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        return codeToGradeTypeMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }

}
