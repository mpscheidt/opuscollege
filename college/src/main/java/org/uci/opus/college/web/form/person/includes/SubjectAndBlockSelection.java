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

package org.uci.opus.college.web.form.person.includes;

import java.io.Serializable;
import java.util.Collection;
import java.util.Map;

import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.util.CodeToLookupMap;

public class SubjectAndBlockSelection implements Serializable {

    private static final long serialVersionUID = 1L;

    private Collection<SubjectBlock> compulsorySubjectBlocks;
    private Collection<Subject> compulsorySubjects;
    private Collection<SubjectBlock> optionalSubjectBlocks;
    private Collection<Subject> optionalSubjects;
    
    private Map<Integer, Boolean> disabledSubjectBlocks;
    private Map<Integer, Boolean> disabledSubjects;

    private CodeToLookupMap codeToStudyTimeMap;

    public Collection<SubjectBlock> getCompulsorySubjectBlocks() {
        return compulsorySubjectBlocks;
    }

    public void setCompulsorySubjectBlocks(Collection<SubjectBlock> compulsorySubjectBlocks) {
        this.compulsorySubjectBlocks = compulsorySubjectBlocks;
    }

    public Collection<Subject> getCompulsorySubjects() {
        return compulsorySubjects;
    }

    public void setCompulsorySubjects(Collection<Subject> compulsorySubjects) {
        this.compulsorySubjects = compulsorySubjects;
    }

    public Collection<SubjectBlock> getOptionalSubjectBlocks() {
        return optionalSubjectBlocks;
    }

    public void setOptionalSubjectBlocks(Collection<SubjectBlock> optionalSubjectBlocks) {
        this.optionalSubjectBlocks = optionalSubjectBlocks;
    }

    public Collection<Subject> getOptionalSubjects() {
        return optionalSubjects;
    }

    public void setOptionalSubjects(Collection<Subject> optionalSubjects) {
        this.optionalSubjects = optionalSubjects;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public Map<Integer, Boolean> getDisabledSubjectBlocks() {
        return disabledSubjectBlocks;
    }

    public void setDisabledSubjectBlocks(Map<Integer, Boolean> disabledSubjectBlocks) {
        this.disabledSubjectBlocks = disabledSubjectBlocks;
    }

    public Map<Integer, Boolean> getDisabledSubjects() {
        return disabledSubjects;
    }

    public void setDisabledSubjects(Map<Integer, Boolean> disabledSubjects) {
        this.disabledSubjects = disabledSubjects;
    }

}
