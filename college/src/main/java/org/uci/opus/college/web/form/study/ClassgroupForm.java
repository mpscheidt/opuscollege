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

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.CodeToLookupMap;

public class ClassgroupForm {

    private NavigationSettings navigationSettings;
    private Classgroup classgroup;
    private Organization organization;
    private int studyId;
    private int academicYearId;
    private List<Study> allStudies;
    private List<AcademicYear> allAcademicYears;
    private List<StudyGradeType> allStudyGradeTypes;

    private List<Subject> allSubjects;
    private Collection<Integer> subjectIds = new HashSet<>();

    private CodeToLookupMap codeToGradeTypeMap;
    private CodeToLookupMap codeToStudyFormMap;
    private CodeToLookupMap codeToStudyTimeMap;

    /**
     * Populate subjectIds from the entries in classgroup.subjectClassgroups.
     * 
     * <p>
     * Note that no subjectClassgroups exist for a new classgroup (with id = 0). In this case, the method does nothing.
     */
    public void initSubjectIdsFromSubjectClassgroups() {
        if (classgroup == null || classgroup.getSubjectClassgroups() == null) {
            return;
        }

        for (SubjectClassgroup sc : classgroup.getSubjectClassgroups()) {
            this.subjectIds.add(sc.getSubjectId());
        }
    }

    /**
     * Test if an entry in classgroup.subjectClassgroups exists with given subjectId.
     * 
     * <p>
     * Note that new classgroups do not have any subjectClassgroups yet. In this case, the method returns false.
     */
    private boolean existsSubjectClassgroup(int subjectId) {
        if (classgroup == null || classgroup.getSubjectClassgroups() == null) {
            return false;
        }

        for (SubjectClassgroup sc : classgroup.getSubjectClassgroups()) {
            if (subjectId == sc.getSubjectId()) {
                return true;
            }
        }

        return false;
    }
    
    /**
     * Test if an entry in subjectIds exists with given subjectId.
     */
    private boolean existsSubjectId(int subjectId) {
        if (this.subjectIds == null) {
            return false;
        }

        return subjectIds.contains(subjectId);
    }

    public List<SubjectClassgroup> getSubjectClassgroupsToDelete() {
        if (classgroup == null || classgroup.getSubjectClassgroups() == null) {
            return Collections.emptyList();
        }

        List<SubjectClassgroup> toDelete = new ArrayList<>();
        for (SubjectClassgroup sc : this.classgroup.getSubjectClassgroups()) {
            if (!existsSubjectId(sc.getSubjectId())) {
                toDelete.add(sc);
            }
        }

        return toDelete;
    }

    public List<SubjectClassgroup> getSubjectClassgroupsToAdd() {
        if (subjectIds == null) {
            return Collections.emptyList();
        }

        List<SubjectClassgroup> toAdd = new ArrayList<>();
        for (Integer subjectId : subjectIds) {
            if (!existsSubjectClassgroup(subjectId)) {
                toAdd.add(new SubjectClassgroup(subjectId, this.classgroup.getId()));
            }
        }

        return toAdd;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Classgroup getClassgroup() {
        return classgroup;
    }

    public void setClassgroup(Classgroup classgroup) {
        this.classgroup = classgroup;
    }

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(Organization organization) {
		this.organization = organization;
	}

	public List<Study> getAllStudies() {
		return allStudies;
	}

	public void setAllStudies(List<Study> allStudies) {
		this.allStudies = allStudies;
	}

	public List<StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	public void setAllStudyGradeTypes(List<StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}

	public int getStudyId() {
		return studyId;
	}

	public void setStudyId(int studyId) {
		this.studyId = studyId;
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

    public CodeToLookupMap getCodeToGradeTypeMap() {
        return codeToGradeTypeMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public Collection<Integer> getSubjectIds() {
        return subjectIds;
    }

    public void setSubjectIds(Collection<Integer> subjectIds) {
        this.subjectIds = subjectIds;
    }

    public List<Subject> getAllSubjects() {
        return allSubjects;
    }

    public void setAllSubjects(List<Subject> allSubjects) {
        this.allSubjects = allSubjects;
    }

}
