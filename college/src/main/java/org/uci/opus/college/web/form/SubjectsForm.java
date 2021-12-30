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

package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.util.CodeToLookupMap;

public class SubjectsForm extends OverviewForm<Subject> implements AcademicYearIdField {

    private int studyId;
    private int academicYearId;
    private String orderBy;

    // used to show the name of the primary study of each subject in the overview
    private IdToStudyMap idToStudyMap;

    // cannot be the same as allStudies, since it needs to be empty when the 
    // organizationalUnit is not selected
    private List<? extends Study> dropDownListStudies;
//    private List<? extends Subject> allSubjects;
    private List<AcademicYear> allAcademicYears;
    
    private CodeToLookupMap codeToStudyTimeMap;
    
    // utility
    private IdToAcademicYearMap idToAcademicYearMap;

    private int subjectCount;

    public SubjectsForm() {
        super();
    }

    public int getStudyId() {
        return studyId;
    }

    public void setStudyId(int studyId) {
        this.studyId = studyId;
    }

    public List<? extends Study> getDropDownListStudies() {
        return dropDownListStudies;
    }
    public void setDropDownListStudies(
            List<? extends Study> dropDownListStudies) {
        this.dropDownListStudies = dropDownListStudies;
    }
    public List<Subject> getAllSubjects() {
//        return allSubjects;
        return getAllItems();
    }
    public void setAllSubjects(List<Subject> allSubjects) {
//        this.allSubjects = allSubjects;
        setAllItems(allSubjects);
    }
    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }
    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public int getSubjectCount() {
        return subjectCount;
    }

    public void setSubjectCount(int subjectCount) {
        this.subjectCount = subjectCount;
    }

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public IdToStudyMap getIdToStudyMap() {
        return idToStudyMap;
    }

    public void setIdToStudyMap(IdToStudyMap idToStudyMap) {
        this.idToStudyMap = idToStudyMap;
    }

}
