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

package org.uci.opus.college.web.flow.person;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.result.SubjectResult;

/**
 * 
 * @author markus
 *
 */
public class StudyPlanCardinalTimeUnitStatistics {
    
    private Logger log = LoggerFactory.getLogger(getClass());
    
    private DateFormat dateInstance;
    StudyPlanCardinalTimeUnit studyPlanCTU;
    List<Subject> subscribedSubjects;
    List<SubjectResult> subjectResults;
    List<SubjectResult> passedSubjectResults;
    List<SubjectResult> failedSubjectResults;
    List<Subject> subjectsWithoutResult;

    public StudyPlanCardinalTimeUnitStatistics(StudyPlanCardinalTimeUnit studyPlanCTU, Locale locale) {
        this.studyPlanCTU = studyPlanCTU;
        dateInstance = DateFormat.getDateInstance(DateFormat.MEDIUM, locale);
    }
    
    public List<Subject> getSubscribedSubjects() {
        if (subscribedSubjects != null) return subscribedSubjects;

        List<Subject> subjects = new ArrayList<Subject>();
        if (studyPlanCTU.getStudyPlanDetails() != null) {
            for (StudyPlanDetail sdp: studyPlanCTU.getStudyPlanDetails()) {
                if (sdp.getSubjects() != null) { subjects.addAll(sdp.getSubjects()); }
                if (sdp.getSubjectBlock() != null) {
//                    for (SubjectBlock subjectBlock: sdp.getSubjectBlocks()) {
                    SubjectBlock subjectBlock = sdp.getSubjectBlock();
                    if (subjectBlock.getSubjectSubjectBlocks() != null) {
                        for (SubjectSubjectBlock ssb: subjectBlock.getSubjectSubjectBlocks()) {
                            if (ssb.getSubject() != null) {
                                subjects.add(ssb.getSubject());
                            }
                        }
                    }
//                    }
                }
            }
        }
        subscribedSubjects = subjects;
        return subscribedSubjects;
    }
    
    
    public List<SubjectResult> getSubjectResults() {
        if (subjectResults != null) return subjectResults;
        
        subjectResults = new ArrayList<SubjectResult>();
        if (studyPlanCTU.getStudyPlanDetails() != null) {
            for (StudyPlanDetail sdp: studyPlanCTU.getStudyPlanDetails()) {
                subjectResults.addAll(sdp.getSubjectResults());
            }
        }
        return subjectResults;
    }

    public List<SubjectResult> getPassedSubjectResults() {
        if (passedSubjectResults != null) return passedSubjectResults;
        
        passedSubjectResults = new ArrayList<SubjectResult>();
        for (SubjectResult sr: getSubjectResults()) {
            if ("Y".equalsIgnoreCase(sr.getPassed())) {
                passedSubjectResults.add(sr);
            }
        }
        return passedSubjectResults;
    }
    
    public List<SubjectResult> getFailedSubjectResults() {
        if (failedSubjectResults != null) return failedSubjectResults;
        
        failedSubjectResults = new ArrayList<SubjectResult>();
        for (SubjectResult sr: getSubjectResults()) {
            if ("N".equalsIgnoreCase(sr.getPassed()) && !hasPassed(sr.getSubjectId())) {
                failedSubjectResults.add(sr);
            }
        }
        return failedSubjectResults;
    }
    
    public List<Subject> getSubjectsWithoutResult() {
        if (subjectsWithoutResult != null) return subjectsWithoutResult;
        
        subjectsWithoutResult = new ArrayList<Subject>();
        
        for (Subject s: getSubscribedSubjects()) {
            if (!hasSubjectResult(s.getId())) {
                subjectsWithoutResult.add(s);
            }
        }
        return subjectsWithoutResult;
    }
    
    public boolean hasSubjectResult(int subjectId) {
        boolean hasResult = false;
        for (SubjectResult sr: getSubjectResults()) {
            if (subjectId == sr.getSubjectId()) {
                hasResult = true;
                break;
            }
        }
        return hasResult;
    }

    public boolean hasPassed(int subjectId) {
        boolean hasResult = false;
        for (SubjectResult sr: getPassedSubjectResults()) {
            if (subjectId == sr.getSubjectId()) {
                hasResult = true;
                break;
            }
        }
        return hasResult;
    }
    
    public Subject getSubscribedSubject(int subjectId) {
        Subject subject = null;

        for (Subject s: getSubscribedSubjects()) {
            if (subjectId == s.getId()) {
                subject = s;
                break;
            }
        }
        
        return subject;
    }

    public List<String> getSubscribedSubjectsInfo() {
        List<String> info = new ArrayList<String>();
        for (Subject subject: getSubscribedSubjects()) {
            StringBuilder b = new StringBuilder();
            b.append(subject.getSubjectDescription());
            info.add(b.toString());
        }
        return info;
    }

    public List<String> getSubjectResultHistory() {
        List<String> history = new ArrayList<String>();
        for (SubjectResult sr: getSubjectResults()) {
            if (sr.getSubjectId() == 0) {
                log.warn("subjectId = 0 for subjectresult with id = " + sr.getId() + ". This should not happen.");
                continue;
            }
            StringBuilder b = new StringBuilder();
            b.append(sr.getSubjectResultDate() == null ? "?" : dateInstance.format(sr.getSubjectResultDate()));
            b.append(": ");
            b.append(getSubscribedSubject(sr.getSubjectId()).getSubjectDescription());
            b.append(": ");
            b.append(sr.getMark());
            b.append(" (");
            b.append(sr.getPassed());
            b.append(")");
            history.add(b.toString());
        }
        return history;
    }
}
