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

package org.uci.opus.college.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


/**
 * This class represents a group of secondary school subjects.
 * The groupNumber should be used for implementing a display 
 * order and has no meaning apart from that.
 * 
 * @author G. ten Napel
 *
 */
public class SecondarySchoolSubjectGroup implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private int id;
    private int groupNumber;
    private int studyGradeTypeId;
    private int minNumberToGrade;
    private int maxNumberToGrade;
    
    private List < SecondarySchoolSubject > secondarySchoolSubjects;
    
    private int minWeight = 1;
    private int maxWeight = 3;        

    public int getMinWeight() {
        return minWeight;
    }

    public void setMinWeight(int minWeight) {
        this.minWeight = minWeight;
    }

    public int getMaxWeight() {
        return maxWeight;
    }

    public void setMaxWeight(int maxWeight) {
        this.maxWeight = maxWeight;
    }        

    public SecondarySchoolSubjectGroup() {
        if (secondarySchoolSubjects == null) {
            secondarySchoolSubjects = new ArrayList<SecondarySchoolSubject>();
        }         
    }
    
    /**
     * Add a secondary school subject but prevent double entries.
     * @param secondarySchoolSubject to add.
     */
    public void addSubject(SecondarySchoolSubject secondarySchoolSubject) {
        
        if (secondarySchoolSubjects == null) {
            secondarySchoolSubjects = new ArrayList<SecondarySchoolSubject>();
        } 
        
        /* Prevent double entries */
        for (int i = 0; i < secondarySchoolSubjects.size(); i++) {
            if (secondarySchoolSubjects.get(i).getId() == secondarySchoolSubject.getId()) {
                return;
            }
        }        
        
        // Add this groupId
        secondarySchoolSubject.setSecondarySchoolSubjectGroupId(this.id);
        secondarySchoolSubjects.add(secondarySchoolSubject);        
    }
    
    /**
     * Remove a secondary school subject by id.
     * @param secondarySchoolSubjectId to remove.
     */
    public void removeSubject(int secondarySchoolSubjectId) {
        
        if (secondarySchoolSubjects != null) {
            for (int i = 0; i < secondarySchoolSubjects.size(); i++) {
                if (secondarySchoolSubjects.get(i).getId() == secondarySchoolSubjectId) {
                    secondarySchoolSubjects.remove(i);
                }
            }
        }
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {

        this.id = id;
        
        /* Also update secondarySchoolSubjects */
        if (secondarySchoolSubjects != null) {
            for (int i = 0; i < secondarySchoolSubjects.size(); i++) {
                secondarySchoolSubjects.get(i).setSecondarySchoolSubjectGroupId(id);
            } 
        }
    }        
    
    public int getGroupNumber() {
        return groupNumber;
    }

    public void setGroupNumber(int groupNumber) {
        this.groupNumber = groupNumber;
    }
    
    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    public void setStudyGradeTypeId(int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }

    public int getMinNumberToGrade() {
        return minNumberToGrade;
    }

    public void setMinNumberToGrade(int minNumberToGrade) {
        this.minNumberToGrade = minNumberToGrade;
    }

    public int getMaxNumberToGrade() {
        return maxNumberToGrade;
    }

    public void setMaxNumberToGrade(int maxNumberToGrade) {
        this.maxNumberToGrade = maxNumberToGrade;
    }

    public List < SecondarySchoolSubject > getSecondarySchoolSubjects() {
        Collections.sort(secondarySchoolSubjects);
        return secondarySchoolSubjects;
    }

    public void setSecondarySchoolSubjects(
            List <SecondarySchoolSubject> secondarySchoolSubjects) {
        this.secondarySchoolSubjects = secondarySchoolSubjects;        
    }
    
    public String toString() {
    	return "SecondarySchoolSubjectGroup = "
    			+ "\n id = " + id
    			+ "\n groupNumber = " + groupNumber
    			+ "\n studyGradeTypeId = " + studyGradeTypeId
    			+ "\n minNumberToGrade = " + minNumberToGrade
    			+ "\n maxNumberToGrade = " + maxNumberToGrade
    			+ "\n secondarySchoolSubjects = " + secondarySchoolSubjects.toString()
    			+ "\n minWeight = " + minWeight
    			+ "\n maxWeight = " + maxWeight;
    }
 
}
