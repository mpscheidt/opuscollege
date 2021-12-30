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

import org.uci.opus.college.domain.util.SubjectAndBlockCompilation;

public class SubscribeToSubjectsFilterForm {

    private Organization organization;
    private StudySettings studySettings;
    private boolean showProcessed;

    private SubjectAndBlockCompilation allSubjectsAndBlocks;
    private Collection<Integer> defaultSubjectBlockIds;
    private Collection<Integer> defaultSubjectIds;

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setStudySettings(StudySettings studySettings) {
        this.studySettings = studySettings;
    }

    public StudySettings getStudySettings() {
        return studySettings;
    }

    public void setShowProcessed(boolean showProcessed) {
        this.showProcessed = showProcessed;
    }

    public boolean isShowProcessed() {
        return showProcessed;
    }

    public SubjectAndBlockCompilation getAllSubjectsAndBlocks() {
        return allSubjectsAndBlocks;
    }

    public void setAllSubjectsAndBlocks(SubjectAndBlockCompilation allSubjectsAndBlocks) {
        this.allSubjectsAndBlocks = allSubjectsAndBlocks;
    }

    public Collection<Integer> getDefaultSubjectBlockIds() {
        return defaultSubjectBlockIds;
    }

    public void setDefaultSubjectBlockIds(Collection<Integer> defaultSubjectBlockIds) {
        this.defaultSubjectBlockIds = defaultSubjectBlockIds;
    }

    public Collection<Integer> getDefaultSubjectIds() {
        return defaultSubjectIds;
    }

    public void setDefaultSubjectIds(Collection<Integer> defaultSubjectIds) {
        this.defaultSubjectIds = defaultSubjectIds;
    }

}
