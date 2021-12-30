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

package org.uci.opus.college.domain.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectSubjectBlock;

public class SubjectAndBlockCompilation {

    List<SubjectBlock> compulsorySubjectBlocks = new ArrayList<SubjectBlock>();
    List<SubjectBlock> optionalSubjectBlocks = new ArrayList<SubjectBlock>();
    List<SubjectBlock> floatingCompulsorySubjectBlocks = new ArrayList<SubjectBlock>();
    List<SubjectBlock> floatingOptionalSubjectBlocks = new ArrayList<SubjectBlock>();
    List<Subject> compulsorySubjects = new ArrayList<Subject>();
    List<Subject> optionalSubjects = new ArrayList<Subject>();
    List<Subject> floatingCompulsorySubjects = new ArrayList<Subject>();
    List<Subject> floatingOptionalSubjects = new ArrayList<Subject>();
    
    public List<SubjectBlock> getCompulsorySubjectBlocks() {
        return compulsorySubjectBlocks;
    }
    public void setCompulsorySubjectBlocks(
            List<SubjectBlock> compulsorySubjectBlocks) {
        this.compulsorySubjectBlocks = compulsorySubjectBlocks;
    }
    public List<SubjectBlock> getOptionalSubjectBlocks() {
        return optionalSubjectBlocks;
    }
    public void setOptionalSubjectBlocks(List<SubjectBlock> optionalSubjectBlocks) {
        this.optionalSubjectBlocks = optionalSubjectBlocks;
    }
    public List<Subject> getCompulsorySubjects() {
        return compulsorySubjects;
    }
    public void setCompulsorySubjects(List<Subject> compulsorySubjects) {
        this.compulsorySubjects = compulsorySubjects;
    }
    public List<Subject> getOptionalSubjects() {
        return optionalSubjects;
    }
    public void setOptionalSubjects(List<Subject> optionalSubjects) {
        this.optionalSubjects = optionalSubjects;
    }
    
    @Override
    public int hashCode() {
        return getCompulsorySubjectBlocks().hashCode()
             + getOptionalSubjectBlocks().hashCode()
             + getFloatingCompulsorySubjectBlocks().hashCode()
             + getFloatingOptionalSubjectBlocks().hashCode()
             + getCompulsorySubjects().hashCode()
             + getOptionalSubjects().hashCode()
             + getFloatingCompulsorySubjects().hashCode()
             + getFloatingOptionalSubjects().hashCode();
    }
    
    @Override
    public boolean equals(Object obj) {
        if (! (obj instanceof SubjectAndBlockCompilation)) return false;
        SubjectAndBlockCompilation other = (SubjectAndBlockCompilation) obj;
        
        return other.getCompulsorySubjectBlocks().equals(compulsorySubjectBlocks)
            && other.getOptionalSubjectBlocks().equals(optionalSubjectBlocks)
            && other.getFloatingCompulsorySubjectBlocks().equals(floatingCompulsorySubjectBlocks)
            && other.getFloatingOptionalSubjectBlocks().equals(floatingOptionalSubjectBlocks)
            && other.getCompulsorySubjects().equals(compulsorySubjects)
            && other.getOptionalSubjects().equals(optionalSubjects)
            && other.getFloatingCompulsorySubjects().equals(floatingCompulsorySubjects)
            && other.getFloatingOptionalSubjects().equals(floatingOptionalSubjects);
    }
    public List<SubjectBlock> getFloatingCompulsorySubjectBlocks() {
        return floatingCompulsorySubjectBlocks;
    }
    public void setFloatingCompulsorySubjectBlocks(
            List<SubjectBlock> floatingCompulsorySubjectBlocks) {
        this.floatingCompulsorySubjectBlocks = floatingCompulsorySubjectBlocks;
    }
    public List<SubjectBlock> getFloatingOptionalSubjectBlocks() {
        return floatingOptionalSubjectBlocks;
    }
    public void setFloatingOptionalSubjectBlocks(
            List<SubjectBlock> floatingOptionalSubjectBlocks) {
        this.floatingOptionalSubjectBlocks = floatingOptionalSubjectBlocks;
    }
    public List<Subject> getFloatingCompulsorySubjects() {
        return floatingCompulsorySubjects;
    }
    public void setFloatingCompulsorySubjects(
            List<Subject> floatingCompulsorySubjects) {
        this.floatingCompulsorySubjects = floatingCompulsorySubjects;
    }
    public List<Subject> getFloatingOptionalSubjects() {
        return floatingOptionalSubjects;
    }
    public void setFloatingOptionalSubjects(List<Subject> floatingOptionalSubjects) {
        this.floatingOptionalSubjects = floatingOptionalSubjects;
    }
    
    public Collection<SubjectBlock> getAllSubjectBlocks() {
        Collection<SubjectBlock> subjectBlocks = new HashSet<SubjectBlock>();
        subjectBlocks.addAll(getCompulsorySubjectBlocks());
        subjectBlocks.addAll(getOptionalSubjectBlocks());
        subjectBlocks.addAll(getFloatingCompulsorySubjectBlocks());
        subjectBlocks.addAll(getFloatingOptionalSubjectBlocks());
        return subjectBlocks;
    }

    public Collection<Subject> getAllSubjectsInclBlocks() {
        Collection<Subject> subjects = new HashSet<Subject>();
        subjects.addAll(getCompulsorySubjects());
        subjects.addAll(getOptionalSubjects());
        subjects.addAll(getFloatingCompulsorySubjects());
        subjects.addAll(getFloatingOptionalSubjects());
        for (SubjectBlock subjectBlock: getAllSubjectBlocks()) {
            for (SubjectSubjectBlock ssb: subjectBlock.getSubjectSubjectBlocks()) {
                subjects.add(ssb.getSubject());
            }
        }
        return subjects;
    }

}
