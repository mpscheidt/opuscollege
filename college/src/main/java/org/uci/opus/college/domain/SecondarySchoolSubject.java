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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class represents a GROUPED secondary school subject.
 * The id links to an actual secondary school subject, 
 * together with a groupid (secondarySchoolSubjectGroupId) this is unique.
 * 
 * See {@link LooseSecondarySchoolSubject} for the class that represents a record in the secondaryschoolsubject table.
 * 
 * @author G. ten Napel
 *
 */
public class SecondarySchoolSubject implements Serializable, Comparable<SecondarySchoolSubject> {
    
    private static final long serialVersionUID = 1L;

    private int id;
    private int secondarySchoolSubjectGroupId;
    private String description;
    private int gradedSecondarySchoolSubjectId;
    private String grade;
    private int minimumGradePoint;
    private int maximumGradePoint;
    private int weight;
    private String level;
    
    private static Logger log = LoggerFactory.getLogger(SecondarySchoolSubject.class);
    
    public SecondarySchoolSubject() {
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public SecondarySchoolSubject(int id, int secondarySchoolSubjectGroupId) {
        this.id = id;
        this.secondarySchoolSubjectGroupId = secondarySchoolSubjectGroupId;
    }
    
    public int getSecondarySchoolSubjectGroupId() {
        return secondarySchoolSubjectGroupId;
    }
    
    public void setSecondarySchoolSubjectGroupId(int secondarySchoolSubjectGroupId) {
        this.secondarySchoolSubjectGroupId = secondarySchoolSubjectGroupId;
    }    
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getGradedSecondarySchoolSubjectId() {
        return gradedSecondarySchoolSubjectId;
    }

    public void setGradedSecondarySchoolSubjectId(
            int gradedSecondarySchoolSubjectId) {
        this.gradedSecondarySchoolSubjectId = gradedSecondarySchoolSubjectId;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    public float getScale() {
        return maximumGradePoint - minimumGradePoint;
    }
    
    /**
     * @return grade devided by scale
     */
    public float getScaledGrade() {
                
        float grade = Float.valueOf(this.grade.trim()).floatValue();        
        
        if (log.isDebugEnabled()) {
            log.debug(" CUTOFFPOINT: grade: " + grade 
                    + " scale: " + getScale() 
                    + " ( maximumGradePoint " + maximumGradePoint 
                    + " minimumGradePoint " + minimumGradePoint + ")");
        }
        
        if (getScale() == 0) {
            return 0;
        }

        return (grade - minimumGradePoint) / getScale();
    }        

    public int getMinimumGradePoint() {
        return minimumGradePoint;
    }

    public void setMinimumGradePoint(int minimumGradePoint) {
        this.minimumGradePoint = minimumGradePoint;
    }

    public int getMaximumGradePoint() {
        return maximumGradePoint;
    }

    public void setMaximumGradePoint(int maximumGradePoint) {
        this.maximumGradePoint = maximumGradePoint;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }  
    
    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public int compareTo(SecondarySchoolSubject comp) {
        
        String myDesc = getDescription();
        if (myDesc == null) myDesc = "";
        
        String otherDesc = comp.getDescription();
        if (otherDesc == null) otherDesc = "";
        
        return myDesc.compareToIgnoreCase(otherDesc);
    }
    
    public String toString() {
    	return "SecondarySchoolSubject = "
    			+ "\n id = " + id
    			+ "\n secondarySchoolSubjectGroupId = " + secondarySchoolSubjectGroupId
    			+ "\n description = " + description
    			+ "\n gradedSecondarySchoolSubjectId = " + gradedSecondarySchoolSubjectId
    			+ "\n grade = " + grade
    			+ "\n minimumGradePoint = " + minimumGradePoint
    			+ "\n maximumGradePoint = " + maximumGradePoint
    			+ "\n weight = " + weight
    			+ "\n level = " + level;
    }

}
