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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.util.CodeToLookupMap;

public class SubjectBlockForm {
    
    SubjectBlock subjectBlock;
    NavigationSettings navigationSettings;
    Organization organization;

    // errors
    String showSubjectBlockError;
    String showSubjectBlockStudyGradeTypeError;
    String showSubjectSubjectBlockError;
    String showSubjectBlockSubjectError;
    
    // lists
    List <AcademicYear> allAcademicYears;
    List < ? extends Study > allStudies;
    List < ? extends Study > allPrimaryStudies;
    List < ? extends StudyGradeType > allStudyGradeTypes;
    List < ? extends SubjectBlock > allSubjectBlocks;
    List < ? extends Subject > allSubjects;
    
    // lookups
    private List<? extends Lookup> allStudyTimes;
    private List<? extends Lookup> allStudyForms;
    private List<? extends Lookup> allBlockTypes;
    private List<? extends Lookup> allRigidityTypes;
    private List<? extends Lookup> allImportanceTypes;
    
    // utility
    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToLookupMap codeToGradeTypeMap;

    public SubjectBlockForm() {
        super();
        showSubjectBlockError = "";
        showSubjectBlockStudyGradeTypeError = "";
        showSubjectSubjectBlockError = "";
        showSubjectBlockSubjectError = "";
    }

    public SubjectBlock getSubjectBlock() {
        return subjectBlock;
    }

    public void setSubjectBlock(final SubjectBlock subjectBlock) {
        this.subjectBlock = subjectBlock;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(final NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(final Organization organization) {
        this.organization = organization;
    }

    public String getShowSubjectBlockError() {
        return showSubjectBlockError;
    }

    public void setShowSubjectBlockError(final String showSubjectBlockError) {
        this.showSubjectBlockError = showSubjectBlockError;
    }

    public String getShowSubjectBlockStudyGradeTypeError() {
        return showSubjectBlockStudyGradeTypeError;
    }

    public void setShowSubjectBlockStudyGradeTypeError(
            final String showSubjectBlockStudyGradeTypeError) {
        this.showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError;
    }

    public String getShowSubjectSubjectBlockError() {
        return showSubjectSubjectBlockError;
    }

    public void setShowSubjectSubjectBlockError(
            final String showSubjectSubjectBlockError) {
        this.showSubjectSubjectBlockError = showSubjectSubjectBlockError;
    }

    public String getShowSubjectBlockSubjectError() {
        return showSubjectBlockSubjectError;
    }

    public void setShowSubjectBlockSubjectError(
            final String showSubjectBlockSubjectError) {
        this.showSubjectBlockSubjectError = showSubjectBlockSubjectError;
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

    public List<? extends Study> getAllPrimaryStudies() {
        return allPrimaryStudies;
    }

    public void setAllPrimaryStudies(final List<? extends Study> allPrimaryStudies) {
        this.allPrimaryStudies = allPrimaryStudies;
    }

    public List<? extends StudyGradeType> getAllStudyGradeTypes() {
        return allStudyGradeTypes;
    }

    public void setAllStudyGradeTypes(
            final List<? extends StudyGradeType> allStudyGradeTypes) {
        this.allStudyGradeTypes = allStudyGradeTypes;
    }

    public List<? extends SubjectBlock> getAllSubjectBlocks() {
        return allSubjectBlocks;
    }

    public void setAllSubjectBlocks(
            final List<? extends SubjectBlock> allSubjectBlocks) {
        this.allSubjectBlocks = allSubjectBlocks;
    }

    public List<? extends Subject> getAllSubjects() {
        return allSubjects;
    }

    public void setAllSubjects(final List<? extends Subject> allSubjects) {
        this.allSubjects = allSubjects;
    }

    public List<? extends Lookup> getAllStudyTimes() {
        return allStudyTimes;
    }

    public void setAllStudyTimes(List<? extends Lookup> allStudyTimes) {
        this.allStudyTimes = allStudyTimes;
    }

    public List<? extends Lookup> getAllStudyForms() {
        return allStudyForms;
    }

    public void setAllStudyForms(List<? extends Lookup> allStudyForms) {
        this.allStudyForms = allStudyForms;
    }

    public List<? extends Lookup> getAllBlockTypes() {
        return allBlockTypes;
    }

    public void setAllBlockTypes(List<? extends Lookup> allBlockTypes) {
        this.allBlockTypes = allBlockTypes;
    }

    public List<? extends Lookup> getAllRigidityTypes() {
        return allRigidityTypes;
    }

    public void setAllRigidityTypes(List<? extends Lookup> allRigidityTypes) {
        this.allRigidityTypes = allRigidityTypes;
    }

    public List<? extends Lookup> getAllImportanceTypes() {
        return allImportanceTypes;
    }

    public void setAllImportanceTypes(List<? extends Lookup> allImportanceTypes) {
        this.allImportanceTypes = allImportanceTypes;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        return codeToGradeTypeMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }
    
    

}
