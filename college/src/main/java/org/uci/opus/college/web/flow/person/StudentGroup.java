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

import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.util.SubjectBlockUtil;
import org.uci.opus.college.domain.util.SubjectEquivKey;

public class StudentGroup implements Serializable {

    private static final long serialVersionUID = 1L;

    private Collection<Subject> allSubjects;
    private Collection<SubjectBlock> allSubjectBlocks;    // subject blocks with subject references
    private Collection<Subject> passedSubjects;
    private Set<Integer> subscribedSubjectBlockIds = new HashSet<>();
    private Set<Integer> subscribedSubjectIds = new HashSet<>();
    private String cardinalTimeUnitStatusCode;
    
    public String studentCode;

    /**
     * The subjects that are not in the curriculum, but a student is subscribed to it anyway.
     */
    private Collection<Subject> outerCurricularSubjects;
    
    public Collection<Subject> getAllSubjects() {
        return allSubjects;
    }
    public void setAllSubjects(Collection<Subject> allSubjects) {
        this.allSubjects = allSubjects;
    }
    public Collection<SubjectBlock> getAllSubjectBlocks() {
        return allSubjectBlocks;
    }
    public void setAllSubjectBlocks(Collection<SubjectBlock> allSubjectBlocks) {
        this.allSubjectBlocks = allSubjectBlocks;
    }
    public Collection<Subject> getPassedSubjects() {
        return passedSubjects;
    }
    public void setPassedSubjects(Collection<Subject> passedSubjects) {
        this.passedSubjects = passedSubjects;
    }
    public Set<Integer> getSubscribedSubjectBlockIds() {
        return subscribedSubjectBlockIds;
    }
    public void setSubscribedSubjectBlockIds(Set<Integer> subscribedSubjectBlockIds) {
        this.subscribedSubjectBlockIds = subscribedSubjectBlockIds;
    }
    public void addSubscribedSubjectBlockId(int subjectBlockId) {
        subscribedSubjectBlockIds.add(subjectBlockId);
    }
    public Set<Integer> getSubscribedSubjectIds() {
        return subscribedSubjectIds;
    }
    public void setSubscribedSubjectIds(Set<Integer> subscribedSubjectIds) {
        this.subscribedSubjectIds = subscribedSubjectIds;
    }
    public void addSubscribedSubjectId(int subjectId) {
        subscribedSubjectIds.add(subjectId);
    }


    private Map<Number, Subject> idToSubjectMap;
    protected void populateIdToSubjectMap() {
        idToSubjectMap = new HashMap<Number, Subject>();
        if (getAllSubjects() != null) {
            for (Subject subject: getAllSubjects()) {
                idToSubjectMap.put(subject.getId(), subject);
            }
        }
    }
    
    public Subject getSubject(int subjectId) {
        if (idToSubjectMap == null) {
            populateIdToSubjectMap();
        }
        return idToSubjectMap.get(subjectId);
    }
    
    private Map<SubjectEquivKey, Subject> passedSubjectEquivMap;
    protected void populatePassedSubjectEquivMap() {
        passedSubjectEquivMap = new HashMap<SubjectEquivKey, Subject>();
        if (getPassedSubjects() != null) {
            for (Subject subject: getPassedSubjects()) {
                SubjectEquivKey key = new SubjectEquivKey(subject.getSubjectCode(), subject.getSubjectDescription());
                passedSubjectEquivMap.put(key, subject);
            }
        }
    }
    
    // To decide if a subject has been passed, we can't use subjectId, 
    // but have to search for subject results for equivalent subjects,
    // that are subjects with the same code and description.
    // That's what the subject equivalence map is for.
    public boolean hasPassed(Subject subject) {
        if (subject == null) return false;
        
        if (passedSubjectEquivMap == null) {
            populatePassedSubjectEquivMap();
        }
        SubjectEquivKey key = new SubjectEquivKey(subject.getSubjectCode(), subject.getSubjectDescription());
        return passedSubjectEquivMap.get(key) != null;
    }

    public boolean hasPassed(int subjectId) {
        Subject subject = getSubject(subjectId);
        return hasPassed(subject);
    }

    private Map<Number, Boolean> passedSubjectMap;      // key: subjectId
    public Map<Number, Boolean> getPassedSubjectMap() {
        if (passedSubjectMap == null) {
            passedSubjectMap = new HashMap<Number, Boolean>();
            if (getAllSubjects() != null) {
                for (Subject subject: getAllSubjects()) {
                    if (hasPassed(subject)) {
                        passedSubjectMap.put(subject.getId(), Boolean.TRUE);
                    }
                }
            }
        }
        return passedSubjectMap;
    }
    
    private Map<Number, Boolean> passedAnySubjectMap;   // key: subjectBlockId
    public Map<Number, Boolean> getPassedAnySubjectMap() {
        if (passedAnySubjectMap == null) {
            passedAnySubjectMap = new HashMap<Number, Boolean>();
            if (getAllSubjectBlocks() != null) {
                for (SubjectBlock subjectBlock: getAllSubjectBlocks()) {
                    if (hasPassedAnySubject(subjectBlock)) {
                        passedAnySubjectMap.put(subjectBlock.getId(), Boolean.TRUE);
                    }
                }
            }
        }
        return passedAnySubjectMap;
    }
    
    public boolean hasPassedAnySubject(SubjectBlock sb) {
        boolean passed = false;
        if (sb != null) {
            List<Subject> subjects = SubjectBlockUtil.getAllSubjects(sb);
            for (Subject subject: subjects) {
                if (hasPassed(subject)) {
                    passed = true;
                    break;
                }
            }
        }
        return passed;
    }
    public boolean hasPassedAnySubject(int subjectBlockId) {
        SubjectBlock sb = getSubjectBlock(subjectBlockId);
        return hasPassedAnySubject(sb);
    }
    
    public SubjectBlock getSubjectBlock(int subjectBlockId) {
        SubjectBlock subjectBlock = null;
        for (SubjectBlock sb: getAllSubjectBlocks()) {
            if (sb.getId() == subjectBlockId) {
                subjectBlock = sb;
                break;
            }
        }
        return subjectBlock;
    }
    
    @Override
    public int hashCode() {
        int hashCode = allSubjects == null ? 0 : allSubjects.hashCode();
        hashCode += allSubjectBlocks == null ? 0 : allSubjectBlocks.hashCode();
        hashCode += passedSubjects == null ? 0 : passedSubjects.hashCode();
        hashCode += subscribedSubjectBlockIds == null ? 0 : subscribedSubjectBlockIds.hashCode();
        hashCode += subscribedSubjectIds == null ? 0 : subscribedSubjectIds.hashCode();
        hashCode += cardinalTimeUnitStatusCode == null ? 0 : cardinalTimeUnitStatusCode.hashCode();
        return hashCode;
    }

    // Attention: The StudentGroupComparator is used to compare StudentGroups and sort them within a TreeMap
    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof StudentGroup)) return false;
        
        StudentGroup other = (StudentGroup) obj;

        // pattern for comparison:   ((a == b) || ((a != null) && a.equals(b)))
        boolean q = allSubjects == other.getAllSubjects() || (allSubjects != null && allSubjects.equals(other.getAllSubjects()));
        q = q && (allSubjectBlocks == other.getAllSubjectBlocks() || (allSubjectBlocks != null && allSubjectBlocks.equals(other.getAllSubjectBlocks())));
        q = q && (passedSubjects == other.getPassedSubjects() || (passedSubjects != null && passedSubjects.equals(other.getPassedSubjects())));
        q = q && (subscribedSubjectBlockIds == other.getSubscribedSubjectBlockIds() || (subscribedSubjectBlockIds != null && subscribedSubjectBlockIds.equals(other.getSubscribedSubjectBlockIds())));
        q = q && (subscribedSubjectIds == other.getSubscribedSubjectIds() || (subscribedSubjectIds != null && subscribedSubjectIds.equals(other.getSubscribedSubjectIds())));
        q = q && (cardinalTimeUnitStatusCode == other.getCardinalTimeUnitStatusCode() || (cardinalTimeUnitStatusCode != null && cardinalTimeUnitStatusCode.equals(other.getCardinalTimeUnitStatusCode())));
        
        return q;
    }
    
    public void setCardinalTimeUnitStatusCode(String cardinalTimeUnitStatusCode) {
        this.cardinalTimeUnitStatusCode = cardinalTimeUnitStatusCode;
    }
    public String getCardinalTimeUnitStatusCode() {
        return cardinalTimeUnitStatusCode;
    }

    @Override
    public String toString() {
        return "StudentGroup " + studentCode + " [allSubjects=" + allSubjects
                + ", allSubjectBlocks=" + allSubjectBlocks
                + ", passedSubjects=" + passedSubjects
                + ", subscribedSubjectBlockIds=" + subscribedSubjectBlockIds
                + ", subscribedSubjectIds=" + subscribedSubjectIds
                + ", cardinalTimeUnitStatusCode=" + cardinalTimeUnitStatusCode
                + "]";
    }
    public Collection<Subject> getOuterCurricularSubjects() {
        return outerCurricularSubjects;
    }
    public void setOuterCurricularSubjects(Collection<Subject> outerCurricularSubjects) {
        this.outerCurricularSubjects = outerCurricularSubjects;
    }
}
