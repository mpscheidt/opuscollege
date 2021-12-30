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
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.util.StringUtil;

/**
 * @author J.Nooitgedagt
 *
 */
public class StudyPlan implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private int studyId;
    private int minor1Id;
    private String gradeTypeCode;
    private String studyPlanDescription;
    private StudyPlanResult studyPlanResult;
    private String BRsPassingExam;
    private String missingDocuments;
    private String active;
    private Thesis thesis;
    private String studyPlanStatusCode;
    private String applicantCategoryCode;
    private int applicationNumber;
    private int firstChoiceOnwardStudyId;
    private String firstChoiceOnwardGradeTypeCode;
    private int secondChoiceOnwardStudyId;
    private String secondChoiceOnwardGradeTypeCode;
    private int thirdChoiceOnwardStudyId;
    private String thirdChoiceOnwardGradeTypeCode;
    private List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits;
    private List<StudyPlanDetail> studyPlanDetails;
    private List < SecondarySchoolSubject > gradedSecondarySchoolSubjects;
    private List < SecondarySchoolSubjectGroup > secondarySchoolSubjectGroups;
    private List < SecondarySchoolSubject > ungroupedSecondarySchoolSubjects;
    private List < ObtainedQualification > allObtainedQualifications;
    private List < CareerPosition > allCareerPositions;
    private List < Referee > allReferees;
    private int   numberOfSubjectsToGrade;
    private BigDecimal allGradesScore;
    private Lookup previousDiscipline;
    private String previousDisciplineGrade;
    private String writeWho;
    private Date writeWhen;

    // lazy loaded for convenience
    private Study study;

    private static Logger log = LoggerFactory.getLogger(StudyPlan.class);
    
    /**
     * @return Returns the id.
     */
    public int getId() {
        return id;
    }
    /**
     * @param id The id to set.
     */
    public void setId(int id) {
        this.id = id;
    }
    public int getStudentId() {
        return studentId;
    }
    public void setStudentId(int newStudentId) {
        studentId = newStudentId;
    }

    /**
	 * @return the studyId
	 */
	public int getStudyId() {
		return studyId;
	}
	/**
	 * @param studyId the studyId to set
	 */
	public void setStudyId(int studyId) {
		this.studyId = studyId;
	}
    public int getMinor1Id() {
        return minor1Id;
    }
    public void setMinor1Id(int minor1Id) {
        this.minor1Id = minor1Id;
    }
	public String getGradeTypeCode() {
        return gradeTypeCode;
    }
    public void setGradeTypeCode(String newGradeTypeCode) {
        gradeTypeCode = newGradeTypeCode;
    }
    
    public String getActive() {
        return active;
    }
    public void setActive(String newactive) {
        active = newactive;
    }
	public String getStudyPlanDescription() {
		return studyPlanDescription;
	}
	public void setStudyPlanDescription(String studyPlanDescription) {
		this.studyPlanDescription = StringUtils.trim(studyPlanDescription);
	}
	public StudyPlanResult getStudyPlanResult() {
        return studyPlanResult;
    }
    public void setStudyPlanResult(StudyPlanResult studyPlanResult) {
        this.studyPlanResult = studyPlanResult;
    }
    public String getBRsPassingExam() {
        return BRsPassingExam;
    }
    public void setBRsPassingExam(String BrsPassingExam) {
        BRsPassingExam = BrsPassingExam;
    }
    public Thesis getThesis() {
        return thesis;
    }
    public void setThesis(Thesis thesis) {
        this.thesis = thesis;
    }
    public String getStudyPlanStatusCode() {
        return studyPlanStatusCode;
    }
    public void setStudyPlanStatusCode(String studyPlanStatusCode) {
        this.studyPlanStatusCode = studyPlanStatusCode;
    }
    public String getApplicantCategoryCode() {
        return applicantCategoryCode;
    }
    public void setApplicantCategoryCode(String applicantCategoryCode) {
        this.applicantCategoryCode = applicantCategoryCode;
    }
    
	/**
	 * @return the applicationNumber
	 */
	public int getApplicationNumber() {
		return applicationNumber;
	}
	/**
	 * @param applicationNumber the applicationNumber to set
	 */
	public void setApplicationNumber(int applicationNumber) {
		this.applicationNumber = applicationNumber;
	}
	public List<StudyPlanCardinalTimeUnit> getStudyPlanCardinalTimeUnits() {
		return studyPlanCardinalTimeUnits;
	}
	public void setStudyPlanCardinalTimeUnits(
			List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits) {
		this.studyPlanCardinalTimeUnits = studyPlanCardinalTimeUnits;
	}
	public List<StudyPlanDetail> getStudyPlanDetails() {
		return studyPlanDetails;
	}
	public void setStudyPlanDetails(List<StudyPlanDetail> studyPlanDetails) {
		this.studyPlanDetails = studyPlanDetails;
	}
	
    public List<SecondarySchoolSubject> getGradedSecondarySchoolSubjects() {
        return gradedSecondarySchoolSubjects;
    }
    public void setGradedSecondarySchoolSubjects(
            List<SecondarySchoolSubject> gradedSecondarySchoolSubjects) {
        this.gradedSecondarySchoolSubjects = gradedSecondarySchoolSubjects;
    }
    
    /**
	 * @return the ungroupedSecondarySchoolSubjects
	 */
	public List<SecondarySchoolSubject> getUngroupedSecondarySchoolSubjects() {
		return ungroupedSecondarySchoolSubjects;
	}
	/**
	 * @param ungroupedSecondarySchoolSubjects the ungroupedSecondarySchoolSubjects to set
	 */
	public void setUngroupedSecondarySchoolSubjects(
			List<SecondarySchoolSubject> ungroupedSecondarySchoolSubjects) {
		this.ungroupedSecondarySchoolSubjects = ungroupedSecondarySchoolSubjects;
	}
	
	public List < SecondarySchoolSubjectGroup > getSecondarySchoolSubjectGroups() {
        return secondarySchoolSubjectGroups;
    }
    public void setSecondarySchoolSubjectGroups(
            List < SecondarySchoolSubjectGroup > secondarySchoolSubjectGroups) {
        this.secondarySchoolSubjectGroups = secondarySchoolSubjectGroups;
    }
    
    private Comparator<Object> subjectGradesComparator = 
            new Comparator<Object>() {
	    public int compare(Object o1, Object o2) {
	        SecondarySchoolSubject subject1 = (SecondarySchoolSubject) o1;
	        SecondarySchoolSubject subject2 = (SecondarySchoolSubject) o2;
	        return StringUtil.emptyStringIfNull(subject2.getGrade()).compareToIgnoreCase(
	        		StringUtil.emptyStringIfNull(subject1.getGrade()));            
	    }
    };
    
    private Comparator<Object> subjectGradesReverseComparator = 
            new Comparator<Object>() {
	    public int compare(Object o1, Object o2) {
	        SecondarySchoolSubject subject1 = (SecondarySchoolSubject) o1;
	        SecondarySchoolSubject subject2 = (SecondarySchoolSubject) o2;
	        return StringUtil.emptyStringIfNull(subject1.getGrade()).compareToIgnoreCase(
	        		StringUtil.emptyStringIfNull(subject2.getGrade()));            
	    }
    };
    
    /* For admission BA/BSC the cut-off point is a desired max total of all secondary school grades
	 * So for a number of 5 counted secondary school grades the highest cut-offpoint would be
	 *       (highestGrade * numberOfSecondarySchoolSubjects)
	 *       (     1       *         5     					= 5)
	 *  The lowest max total will be (depending on grade 5 or 6 will be 25 or 30.     
	 */
    public boolean passCutOffPointAdmissionBachelor(BigDecimal cutOffPoint, String gender,
			BigDecimal admissionBachelorCutOffPointCreditFemale, 
			BigDecimal admissionBachelorCutOffPointCreditMale) {
                
    	boolean passCutOffPoint = false;
        BigDecimal allGradesScore = BigDecimal.ZERO;
       
        if (log.isDebugEnabled()) {
            log.debug("StudyPlan.passCutOffPointAdmissionBachelor - gender: " + gender);
            log.debug("StudyPlan.passCutOffPointAdmissionBachelor - admissionBachelorCutOffPointCreditFemale :  " + admissionBachelorCutOffPointCreditFemale);
            log.debug("StudyPlan.passCutOffPointAdmissionBachelor - admissionBachelorCutOffPointCreditMale :  " + admissionBachelorCutOffPointCreditMale);            
        }
        
        if (gradedSecondarySchoolSubjects != null && gradedSecondarySchoolSubjects.size() > 0) {
           
            // Bachelor asks for total score, not average. Weight must be balanced though:
            allGradesScore = calculateGradesScore(cutOffPoint, gender, 
            		admissionBachelorCutOffPointCreditFemale, admissionBachelorCutOffPointCreditMale);

            if (log.isDebugEnabled()) {
                log.debug("StudyPlan.passCutOffPointAdmissionBachelor - gradedSecondarySchoolSubjects.size(): " + gradedSecondarySchoolSubjects.size());
                log.debug("StudyPlan.passCutOffPointAdmissionBachelor - allGradesScore :  " + allGradesScore);
                log.debug("StudyPlan.passCutOffPointAdmissionBachelor - cutOffPoint :  " + cutOffPoint);    
                log.debug("StudyPlan.passCutOffPointAdmissionBachelor - allGradesScore <= cutOffPoint : " + (allGradesScore.compareTo(cutOffPoint) <= 0));
            }
            // if allGradesScore is 0, there are not enough graded secondary school subjects
//            if ( allGradesScore != 0 ) {
            if ( allGradesScore.compareTo(BigDecimal.ZERO) != 0 ) {
//            	passCutOffPoint = allGradesScore <= cutOffPoint;
                passCutOffPoint = allGradesScore.compareTo(cutOffPoint) <= 0;
            }
           
        }
        return passCutOffPoint;
    }
    
    
    /* check if there are enough subjects graded per group and in total */
    public boolean isEnoughGradedSubjects() {   	
    	int total = 0;
	    if (secondarySchoolSubjectGroups != null) {
	        
	        for (SecondarySchoolSubjectGroup group : secondarySchoolSubjectGroups) {
	            int minGraded = group.getMinNumberToGrade();
	          
	            int counter = 0;
	            for (SecondarySchoolSubject subject : group.getSecondarySchoolSubjects()) {
	                // check if subject is graded
	                if (!StringUtil.isNullOrEmpty(subject.getGrade(), true) && !"0".equals(subject.getGrade())) {
	                    counter = counter + 1;
	                }
	            }
	            if (counter < minGraded) {
            		if (log.isDebugEnabled()) {
            			log.debug("StudyPlan.isEnoughGradedSubjects() not enough subjects "
            					+ "graded in group " + group.getGroupNumber() + ": minGraded = " 
            					+ minGraded + ", counted = " + counter);
            		}
	            	return false;
	            } else {
	                total = total + counter;
	            }
	        }
	        
	        if (total < numberOfSubjectsToGrade) {
	        	if (log.isDebugEnabled()) {
        			log.debug("StudyPlan.isEnoughGradedSubjects() not enough subjects "
        					+ "graded in total; should be at least: " + numberOfSubjectsToGrade);
        		}
	        	return false;
	        }
	    }
	    
	    return true;
	}

    /* For admission BA/BSC the gradesScore is the calculated value based on secondary school subjects)
	 *       (     1       *         5     					= 5)
	 *  The lowest max total will be (depending on grade 5 or 6 will be 25 or 30.     
	 */
    public BigDecimal calculateGradesScore(BigDecimal cutOffPoint, String gender,
			BigDecimal admissionBachelorCutOffPointCreditFemale, 
			BigDecimal admissionBachelorCutOffPointCreditMale) {
                
        BigDecimal allGradesScore = BigDecimal.ZERO;
        BigDecimal summedSubjectWeight = BigDecimal.ZERO;
        int  gradesScore = 0;

        /* Get from each group the minimum number of subjects to grade and of course get the
           subjects with the highest grades if there are more subjects graded than the minimum
           required, save these subjects in another list; but no more than the maximum number that
           may be graded in that list */
        if (isEnoughGradedSubjects()) {
        	
            List<SecondarySchoolSubject> listOfSubjectsGradesCounted = new ArrayList<>();
            List<SecondarySchoolSubject> listOfSubjectsGradesNotCounted = new ArrayList<>();
        	
        	/* check if minGradePoint higher or lower than maxGradePoint to determine sort direction
   		     * must be the same for all subjects
   		     * NB: since default the highest grade is a lower number (e.g. 1) and the lowest grade
   		     * a higher number (e.g. 6) apparently it has been decided to reverse the minimum 
   		     * and maximum grade. So, careful, might be a bit confusing and should be adjusted
   		     * in the future.
   		     */
   		    int minimumGrade = secondarySchoolSubjectGroups.get(0).getSecondarySchoolSubjects()
   		    												.get(0).getMinimumGradePoint();
   		    int maximumGrade = secondarySchoolSubjectGroups.get(0).getSecondarySchoolSubjects()
   		    												.get(0).getMaximumGradePoint();
   		    
   		    if (log.isDebugEnabled()) {
   		    	log.debug("StudyPlan.calculateGradesScore minimumGrade = " + minimumGrade 
   		    										+ ", maximumGrade = " + maximumGrade);
   		    }
   		    
        	for (SecondarySchoolSubjectGroup group : secondarySchoolSubjectGroups) {
        		 List < SecondarySchoolSubject > subjectList = group.getSecondarySchoolSubjects();
        		 int minNumberToGrade = group.getMinNumberToGrade();
        		 int maxNumberToGrade = group.getMaxNumberToGrade();
        		 
        		 if (minimumGrade < maximumGrade) {
        			// order list from highest to lowest grades
        			 Collections.sort(subjectList, subjectGradesReverseComparator);
        		 } else {
        			// order list from lowest to highest grades
        			Collections.sort(subjectList, subjectGradesComparator);
        		 }

        		 int counter = 0; 
        		 for (SecondarySchoolSubject subject : subjectList) {
        			if (log.isDebugEnabled()) {
        				log.debug("StudyPlan.calculateGradesScore subject desc/grade = "
        							+ subject.getDescription() + " / " + subject.getGrade());
        			}
        			if (counter < minNumberToGrade) {
        				if (!StringUtil.isNullOrEmpty(subject.getGrade(), true)) {
	        				gradesScore += Integer.parseInt(subject.getGrade()) * subject.getWeight();
//	        				summedSubjectWeight += subject.getWeight();
                            summedSubjectWeight = summedSubjectWeight.add(new BigDecimal(subject.getWeight()));
	        				listOfSubjectsGradesCounted.add(subject);
	        				if (log.isDebugEnabled()) {
	     		                log.debug("StudyPlan.calculateGradesScore - SecondarySchoolSubject grade counted: " + subject.getGrade()
	     		                        + " , weight: " + subject.getWeight()
	     		                        + " , allGradesScore (incl. weight): " + gradesScore 
	     		                        + " , summedSubjectWeight: " + summedSubjectWeight);
	     		            }
	        				counter = counter + 1;
        				}
        			} else if (counter < maxNumberToGrade) {
        				if (!StringUtil.isNullOrEmpty(subject.getGrade(), true)) {
        					listOfSubjectsGradesNotCounted.add(subject);
        					counter = counter + 1;
        				}
        			}        			
        		 }
        	}
        	
        	// now we have a list with the minimum number of subjects from each group, with the highest scores
        	// check if this is the correct amount of subjects graded
        	if (listOfSubjectsGradesCounted.size() == numberOfSubjectsToGrade) {
        		// gradesScore correct; do nothing
        	// not enough subject grades, so get the best subjects from the list "listOfSubjectsGradesNotCounted"
        	} else {
        		// first sort the not counted subjects in order of grades
        		if (minimumGrade < maximumGrade) {
        			// order list from highest to lowest grades
        			Collections.sort(listOfSubjectsGradesNotCounted, subjectGradesReverseComparator);
        		} else {
        			// order list from lowest to highest grades 
        			Collections.sort(listOfSubjectsGradesNotCounted, subjectGradesComparator);
        		}
        		
        		int subjectsAlreadyCounted = listOfSubjectsGradesCounted.size();
        		
        		/* if the number of subjects calculated is lower than the number of subject that
        		 * should be graded, count more graded subjects 
        		 */
    			for (SecondarySchoolSubject subject : listOfSubjectsGradesNotCounted) {

    				while (subjectsAlreadyCounted < numberOfSubjectsToGrade) {
        				if (!StringUtil.isNullOrEmpty(subject.getGrade())) {
        					listOfSubjectsGradesCounted.add(subject);
        				
        					gradesScore += Integer.parseInt(subject.getGrade()) 
        														* subject.getWeight();
        					if (log.isDebugEnabled()) {
        						log.debug("StudyPlan.calculateGradesScore add not counted "
        								+ "subject/grade: " + subject.getDescription() + " / "
        								+ subject.getGrade()  + "' total score = " + gradesScore);
        					}
        					
//            				summedSubjectWeight += subject.getWeight();
                            summedSubjectWeight = summedSubjectWeight.add(new BigDecimal(subject.getWeight()));
            				subjectsAlreadyCounted += 1;
        				}
    				
    				}
    			}
        			
        	}
        	
        	// Bachelor asks for total score, not average. Weight must be balanced though:
//	        allGradesScore = (gradesScore / summedSubjectWeight ) * listOfSubjectsGradesCounted.size();
            allGradesScore = new BigDecimal(gradesScore * listOfSubjectsGradesCounted.size()).divide(summedSubjectWeight, ResultManagerInterface.MC);

	        // add female / male cut-off point extra:
	        if ("2".equals(gender)) {
//	        	allGradesScore = allGradesScore + admissionBachelorCutOffPointCreditFemale;
                allGradesScore = allGradesScore.add(admissionBachelorCutOffPointCreditFemale);
	            if (log.isDebugEnabled()) {
	                log.debug("StudyPlan.calculateGradesScore: admissionBachelorCutOffPointCreditFemale = "
	                + admissionBachelorCutOffPointCreditFemale + ", allGradesScore = " + allGradesScore);
	            }
	        }
	        if ("1".equals(gender)) {
//	        	allGradesScore = allGradesScore + admissionBachelorCutOffPointCreditMale;
                allGradesScore = allGradesScore.add(admissionBachelorCutOffPointCreditMale);
	            if (log.isDebugEnabled()) {
	                log.debug("StudyPlan.calculateGradesScore: admissionBachelorCutOffPointCreditMale = "
	                + admissionBachelorCutOffPointCreditMale + ", allGradesScore = " + allGradesScore);
	            }
	        }
		} else {
			// not enough subjects, so don't calculate
			allGradesScore = BigDecimal.ZERO;
		}

        this.setAllGradesScore(allGradesScore);
        
        return allGradesScore;
    }

    
    public int getFirstChoiceOnwardStudyId() {
        return firstChoiceOnwardStudyId;
    }
    public void setFirstChoiceOnwardStudyId(int firstChoiceOnwardStudyId) {
        this.firstChoiceOnwardStudyId = firstChoiceOnwardStudyId;
    }
    public String getFirstChoiceOnwardGradeTypeCode() {
        return firstChoiceOnwardGradeTypeCode;
    }
    public void setFirstChoiceOnwardGradeTypeCode(String firstChoiceOnwardGradeTypeCode) {
        this.firstChoiceOnwardGradeTypeCode = firstChoiceOnwardGradeTypeCode;
    }
    public int getSecondChoiceOnwardStudyId() {
        return secondChoiceOnwardStudyId;
    }
    public void setSecondChoiceOnwardStudyId(
            int secondChoiceOnwardStudyId) {
        this.secondChoiceOnwardStudyId = secondChoiceOnwardStudyId;
    }
    public String getSecondChoiceOnwardGradeTypeCode() {
        return secondChoiceOnwardGradeTypeCode;
    }
    public void setSecondChoiceOnwardGradeTypeCode(
            String secondChoiceOnwardGradeTypeCode) {
        this.secondChoiceOnwardGradeTypeCode = secondChoiceOnwardGradeTypeCode;
    }
    public int getThirdChoiceOnwardStudyId() {
        return thirdChoiceOnwardStudyId;
    }
    public void setThirdChoiceOnwardStudyId(
            int thirdChoiceOnwardStudyId) {
        this.thirdChoiceOnwardStudyId = thirdChoiceOnwardStudyId;
    }
    public String getThirdChoiceOnwardGradeTypeCode() {
        return thirdChoiceOnwardGradeTypeCode;
    }
    public void setThirdChoiceOnwardGradeTypeCode(String thirdChoiceOnwardGradeTypeCode) {
        this.thirdChoiceOnwardGradeTypeCode = thirdChoiceOnwardGradeTypeCode;
    }
    
	public int getNumberOfSubjectsToGrade() {
		return numberOfSubjectsToGrade;
	}
	public void setNumberOfSubjectsToGrade(int numberOfSubjectsToGrade) {
		this.numberOfSubjectsToGrade = numberOfSubjectsToGrade;
	}
	/**
	 * @return the allGradesScore
	 */
	public BigDecimal getAllGradesScore() {
		return allGradesScore;
	}
	/**
	 * @param allGradesScore the allGradesScore to set
	 */
	public void setAllGradesScore(BigDecimal allGradesScore) {
		this.allGradesScore = allGradesScore;
	}
    public List < ObtainedQualification > getAllObtainedQualifications() {
        return allObtainedQualifications;
    }
    public void setAllObtainedQualifications(
            List < ObtainedQualification > allObtainedQualifications) {
        this.allObtainedQualifications = allObtainedQualifications;
    }
    public List < CareerPosition > getAllCareerPositions() {
        return allCareerPositions;
    }
    public void setAllCareerPositions(List < CareerPosition > allCareerPositions) {
        this.allCareerPositions = allCareerPositions;
    }
    public List < Referee > getAllReferees() {
        return allReferees;
    }
    public void setAllReferees(List < Referee > allReferees) {
        this.allReferees = allReferees;
    }

    public Lookup getPreviousDiscipline() {
        return previousDiscipline;
    }
    public void setPreviousDiscipline(Lookup previousDiscipline) {
        this.previousDiscipline = previousDiscipline;
    }
    public String getPreviousDisciplineGrade() {
        return previousDisciplineGrade;
    }
    public void setPreviousDisciplineGrade(String previousDisciplineGrade) {
        this.previousDisciplineGrade = previousDisciplineGrade;
    }
	public String getWriteWho() {
		return writeWho;
	}
	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}
	public Date getWriteWhen() {
		return writeWhen;
	}
	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}
	public String getMissingDocuments() {
		return missingDocuments;
	}
	public void setMissingDocuments(String missingDocuments) {
		this.missingDocuments = StringUtils.trim(missingDocuments);
	}
    public Study getStudy() {
        return study;
    }
    public void setStudy(Study study) {
        this.study = study;
    }
    
}
