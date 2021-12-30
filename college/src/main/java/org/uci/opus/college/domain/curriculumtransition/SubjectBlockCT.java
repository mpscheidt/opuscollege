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

package org.uci.opus.college.domain.curriculumtransition;

import java.util.ArrayList;
import java.util.List;


public class SubjectBlockCT {

    // data needed for transition process
    private int originalId;
    private int newId;
    private boolean targetExists;
    private List<SubjectCT> subjects;
    private List<Integer> invalidSubjectIds;

    // additional data for convenience
    private int studyId;

    
    public int getOriginalId() {
        return originalId;
    }
    public void setOriginalId(int originalId) {
        this.originalId = originalId;
    }
    public int getNewId() {
        return newId;
    }
    public void setNewId(int newId) {
        this.newId = newId;
    }
    public boolean isEligibleForTransition() {
        return !isTargetExists();
    }
    public boolean isTargetExists() {
        return targetExists;
    }
    public void setTargetExists(boolean targetExists) {
        this.targetExists = targetExists;
    }
    public void addSubject(SubjectCT subject) {
        if (subjects == null) {
            subjects = new ArrayList<SubjectCT>();
        }
        subjects.add(subject);
    }
    public List<SubjectCT> getSubjects() {
        return subjects;
    }
    public void setSubjects(List<SubjectCT> subjects) {
        this.subjects = subjects;
    }
    public void addInvalidSubjectId(int subjectId) {
        if (invalidSubjectIds == null) {
            invalidSubjectIds = new ArrayList<Integer>();
        }
        invalidSubjectIds.add(subjectId);
    }
    public List<Integer> getInvalidSubjectIds() {
        return invalidSubjectIds;
    }
    public void setInvalidSubjectIds(List<Integer> invalidSubjectIds) {
        this.invalidSubjectIds = invalidSubjectIds;
    }
    public void setStudyId(int studyId) {
        this.studyId = studyId;
    }
    public int getStudyId() {
        return studyId;
    }
}
