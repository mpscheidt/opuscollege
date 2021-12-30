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

import java.util.Collection;
import java.util.HashSet;

import org.uci.opus.college.domain.Student;

public class FastStudentInputForm {

    private Student student;
    private Collection<Integer> subjectBlockStudyGradeTypeIds = new HashSet<>();
    private Collection<Integer> subjectStudyGradeTypeIds = new HashSet<>();
    private int maxNumberOfSubjects;
    private boolean studentCodeWillBeGenerated;
    
    public FastStudentInputForm() {
    }
    
    public Student getStudent() {
        return student;
    }
    
    public void setStudent(Student student) {
        this.student = student;
    }
    
    public Collection<Integer> getSubjectBlockStudyGradeTypeIds() {
        return subjectBlockStudyGradeTypeIds;
    }
    
    public void setSubjectBlockStudyGradeTypeIds(
            Collection<Integer> subjectBlockStudyGradeTypeIds) {
        if (subjectBlockStudyGradeTypeIds == null) return;
        this.subjectBlockStudyGradeTypeIds = subjectBlockStudyGradeTypeIds;
    }

    public Collection<Integer> getSubjectStudyGradeTypeIds() {
        return subjectStudyGradeTypeIds;
    }

    public void setSubjectStudyGradeTypeIds(Collection<Integer> subjectStudyGradeTypeIds) {
        if (subjectStudyGradeTypeIds == null) return;
        this.subjectStudyGradeTypeIds = subjectStudyGradeTypeIds;
    }

    public int getMaxNumberOfSubjects() {
        return maxNumberOfSubjects;
    }

    public void setMaxNumberOfSubjects(int maxNumberOfSubjects) {
        this.maxNumberOfSubjects = maxNumberOfSubjects;
    }

    public boolean isStudentCodeWillBeGenerated() {
        return studentCodeWillBeGenerated;
    }

    public void setStudentCodeWillBeGenerated(boolean studentCodeWillBeGenerated) {
        this.studentCodeWillBeGenerated = studentCodeWillBeGenerated;
    }
    
}
