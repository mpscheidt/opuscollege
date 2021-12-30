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
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectSubjectBlock;

public class SubjectSubjectBlockForm {
    
    SubjectSubjectBlock subjectSubjectBlock;
    Subject subject;
    SubjectBlock subjectBlock;
    Organization organization;
    NavigationSettings navigationSettings;
    
    Study study;
    
    // lists
    List <AcademicYear> allAcademicYears;
    List < ? extends Study > allStudies;
    List < SubjectSubjectBlock > allSubjectSubjectBlocksForSubject;
    List < SubjectBlock > allSubjectBlocks;
    
    // error
    String txtErr;
    
    public SubjectSubjectBlockForm() {
        
    }
    
    public SubjectSubjectBlock getSubjectSubjectBlock() {
        return subjectSubjectBlock;
    }
    public void setSubjectSubjectBlock(final SubjectSubjectBlock subjectSubjectBlock) {
        this.subjectSubjectBlock = subjectSubjectBlock;
    }
    public Subject getSubject() {
        return subject;
    }

    public void setSubject(final Subject subject) {
        this.subject = subject;
    }

    public SubjectBlock getSubjectBlock() {
        return subjectBlock;
    }

    public void setSubjectBlock(final SubjectBlock subjectBlock) {
        this.subjectBlock = subjectBlock;
    }

    public Organization getOrganization() {
        return organization;
    }
    public void setOrganization(final Organization organization) {
        this.organization = organization;
    }
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setNavigationSettings(final NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Study getStudy() {
        return study;
    }

    public void setStudy(final Study study) {
        this.study = study;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(final List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List<? extends Study> getAllStudies() {
        return allStudies;
    }

    public void setAllStudies(final List<? extends Study> allStudies) {
        this.allStudies = allStudies;
    }

    public List<SubjectSubjectBlock> getAllSubjectSubjectBlocksForSubject() {
        return allSubjectSubjectBlocksForSubject;
    }

    public void setAllSubjectSubjectBlocksForSubject(
            final List<SubjectSubjectBlock> allSubjectSubjectBlocksForSubject) {
        this.allSubjectSubjectBlocksForSubject = allSubjectSubjectBlocksForSubject;
    }

    public List<SubjectBlock> getAllSubjectBlocks() {
        return allSubjectBlocks;
    }

    public void setAllSubjectBlocks(final List<SubjectBlock> allSubjectBlocks) {
        this.allSubjectBlocks = allSubjectBlocks;
    }

    public String getTxtErr() {
        return txtErr;
    }

    public void setTxtErr(final String txtErr) {
        this.txtErr = txtErr;
    }

}
