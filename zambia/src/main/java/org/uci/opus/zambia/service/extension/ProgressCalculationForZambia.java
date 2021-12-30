package org.uci.opus.zambia.service.extension;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.FailedSubjectInfo;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.ProgressCalculation;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.ListUtil;

/*
 * Calculate the progress status for a studyplancardinaltimeunit
 * based on business rules for a university or country
 */
public class ProgressCalculationForZambia implements ProgressCalculation{

    private static Logger log = LoggerFactory.getLogger(ProgressCalculationForZambia.class);
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    
    private boolean isLastCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCtu, StudyGradeType studyGradeType) {
        boolean isLastCtu = false;
        if (studyPlanCtu.getCardinalTimeUnitNumber() == studyGradeType.getNumberOfCardinalTimeUnits()) {
            isLastCtu = true;
        }
        return isLastCtu;
    }
    
    private boolean isMaximumNumberOfCardinalTimeUnitReached(StudyPlan studyPlan, StudyGradeType studyGradeType) {
        boolean isMaxReached = false;

        int maxNumberOfCardinalTimeUnits = studyGradeType.getMaxNumberOfCardinalTimeUnits();
        
        // maxNumberOfCardinalTimeUnits == 0 is interpreted as unlimited
        if (maxNumberOfCardinalTimeUnits != 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("studyPlanId", studyPlan.getId());
            List<Integer> studyPlanCtuIds = studentManager.findStudyPlanCardinalTimeUnitIds(map);

            isMaxReached = studyPlanCtuIds.size() >= maxNumberOfCardinalTimeUnits;
        }

        return isMaxReached;
    }
    
    private boolean hasFailedSubjectTwice(SubjectResult failedSubjectResult, StudyPlan studyPlan, String preferredLanguage) {
        boolean hasFailedTwice = false;
        List < SubjectResult > allSubjectResultsForStudyPlan = null;
        List < StudyPlanDetail > allDetailsForStudyPlan = null;
        List < Subject > allSubjectsForStudyPlan = null;
        String subjectCodeToVerify = subjectManager.findSubject(failedSubjectResult.getSubjectId()).getSubjectCode();
        
        allDetailsForStudyPlan = studentManager.findStudyPlanDetailsForStudyPlan(studyPlan.getId());
        allSubjectsForStudyPlan = studentManager.findActiveSubjectsForStudyPlan(studyPlan.getId());
        if (!ListUtil.isNullOrEmpty(allDetailsForStudyPlan) && !ListUtil.isNullOrEmpty(allSubjectsForStudyPlan)) {
            allSubjectResultsForStudyPlan = resultManager.findCalculatableSubjectResultsForStudyPlan(
                                                            allDetailsForStudyPlan, allSubjectsForStudyPlan, studyPlan, true);
        } else {
            log.info("hasFailedSubjectTwice: allSubjectsForStudyPlan.size() IS NULL " +
                    "or allStudyPlanDetailsForStudyPlan.size() is NULL");
        }
        if (!ListUtil.isNullOrEmpty(allSubjectResultsForStudyPlan)) {
            
            for (SubjectResult subjectResult : allSubjectResultsForStudyPlan) {
                String subjectCode = subjectManager.findSubject(subjectResult.getSubjectId()).getSubjectCode();
                if (subjectCodeToVerify.equals(subjectCode)) {
                    if ("N".equals(resultManager.isPassedSubjectResult(
                            subjectResult, subjectResult.getMark(), 
                             preferredLanguage, studyPlan.getGradeTypeCode(), null))) {
                        
                        hasFailedTwice = true;
                        break;
                    }
                }
            }
        } else {
            log.info("hasFailedSubjectTwice: allSubjectResultsForStudyPlan.size() IS NULL");
        }
        
        return hasFailedTwice;
        
    }

    @Override
    public void calculateProgressStatusForStudyPlanCardinalTimeUnit(
            final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,
            final String preferredLanguage, 
            final Locale currentLoc) {

    	StudyPlan studyPlan = null;
    	List < StudyPlanDetail > studyPlanDetailsForStudyPlanCardinalTimeUnit = null;
    	List < SubjectResult > subjectResultsForCTU = null;
    	StudyGradeType studyGradeType = null;
    	int maxNumberOfFailedSubjects = 0;
    	
        if (log.isDebugEnabled()) {
            log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit entered");
        }
       
        // 1. check if this studyplancardinaltimeunit has a ctu-result:
        studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        maxNumberOfFailedSubjects = studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit();
        studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());

        Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyPlanId", studyPlan.getId());
        ctuMap.put("studyPlanCardinalTimeUnitId",studyPlanCardinalTimeUnit.getId());
        ctuMap.put("currentAcademicYearId", studyGradeType.getCurrentAcademicYearId());
        ctuMap.put("active", "Y");

        CardinalTimeUnitResult cardinalTimeUnitResult = resultManager.findCardinalTimeUnitResultByParams(ctuMap);
        if (cardinalTimeUnitResult != null) {
	        if (log.isDebugEnabled()) {
	            log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: cardinalTimeUnitResult = " + cardinalTimeUnitResult.getId());
	        }
        } else {
            log.info("calculateProgressStatusForStudyPlanCardinalTimeUnit: cardinalTimeUnitResult is NULL; cannot determine progress status");
        	// jump out of this method without action
        	return;
        }
        
        // 2. check if this studyplancardinaltimeunit has calculatable subjectresults:
        ctuMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
        ctuMap.put("studyGradeTypeId", studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        ctuMap.put("active", "Y");

        studyPlanDetailsForStudyPlanCardinalTimeUnit = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(ctuMap);
        if (studyPlanDetailsForStudyPlanCardinalTimeUnit != null && studyPlanDetailsForStudyPlanCardinalTimeUnit.size() != 0) {
	        if (log.isDebugEnabled()) {
	            log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanDetailsForStudyPlanCardinalTimeUnit found, size = " + studyPlanDetailsForStudyPlanCardinalTimeUnit.size() );
	        }
        } else {
        	if (log.isDebugEnabled()) {
	            log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: NO studyPlanDetailsForStudyPlanCardinalTimeUnit found");
	        }
        	// jump out of this method without action:
        	return;
        }
        
        ctuMap.put("studyId", studyPlan.getStudyId());
     	ctuMap.put("gradeTypeCode", studyPlan.getGradeTypeCode());
     	ctuMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());

        subjectResultsForCTU = resultManager.findCalculatableSubjectResultsForCardinalTimeUnit(studyPlanDetailsForStudyPlanCardinalTimeUnit, ctuMap);
     	if (subjectResultsForCTU != null && subjectResultsForCTU.size() != 0) {
     	
     		if (log.isDebugEnabled()) {
                log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: subjectResultsForCTU found, size = " + subjectResultsForCTU.size());
            } 
     	} else {
     		if (log.isDebugEnabled()) {
                log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: NO subjectResultsForCTU found");
            }
        	// jump out of this method without action:
        	return;
     	}
     	
     	// 3. business rules checks:
     	// failed subjects (represented as subjectStudyGradeTypes) of the entire studyPlan
     	List<FailedSubjectInfo> allFailedSubjectsForStudyPlan = studentManager.findAllFailedCompulsorySubjectsForStudyPlan(studyPlan.getId());
 		
 		List < SubjectResult> failedCompulsorySubjectResultsOfCtu = new ArrayList<>();
 		List < SubjectResult> allFailedSubjectResultsInCtu = new ArrayList<>();
 		List < SubjectResult> failedPreviousSubjectResultsInCtu = new ArrayList<>();
 		List < SubjectResult> passedSubjectResults = new ArrayList<>();
     	for (SubjectResult subjectResult : subjectResultsForCTU) {
     	    log.debug("JANO subjectResultsForCTU subjectId: " + subjectResult.getId());
     	    
 			if ("N".equals(resultManager.isPassedSubjectResult(
 			       subjectResult, subjectResult.getMark(), 
 					preferredLanguage, studyGradeType.getGradeTypeCode(), null))) {
 			    log.debug("JANO subjectResultsForCTU subjectId: " + subjectResult.getId() + " - passed = N");
 			    allFailedSubjectResultsInCtu.add(subjectResult);
 			    
 			    boolean previousSubject = false;
 			    String subjectCode = subjectManager.findSubject(subjectResult.getSubjectId()).getSubjectCode(); 
 			   log.debug("JANO subjectResultsForCTU subjectCode: " + subjectCode);
 			    for (FailedSubjectInfo failedSubjectInfo : allFailedSubjectsForStudyPlan) {
 			       log.debug("JANO allFailedSubjectSGT subjectId: " + failedSubjectInfo.getSubjectId());
 			       String failedSubjectCode = subjectManager.findSubject(failedSubjectInfo.getSubjectId()).getSubjectCode();
 			      log.debug("JANO allFailedSubjectSGT subjectCode: " + failedSubjectCode);
 			       if (subjectCode.equals(failedSubjectCode) && subjectResult.getSubjectId() != failedSubjectInfo.getSubjectId()) {
 			          log.debug("JANO allFailedSubjectSGT subjectCode: " + failedSubjectCode + " is previousSubject");
 			           previousSubject = true;
 			           break;
 			       }
 			    }
 			    if (!previousSubject) {
 			       failedCompulsorySubjectResultsOfCtu.add(subjectResult);
 			    } else {
 			       failedPreviousSubjectResultsInCtu.add(subjectResult);
 			    }
 			} else {
 				passedSubjectResults.add(subjectResult);
 			}
 		}

        if (allFailedSubjectsForStudyPlan.size() == 0) {
            log.debug("JANO allFailedSubjectsForStudyPlan.size() == 0");
            if (isLastCardinalTimeUnit(studyPlanCardinalTimeUnit, studyGradeType)) {
                // Graduate: 
                // If all subjects from the final cardinal time-unit are succeeded. 
                // No forwarding to the next cardinal time-unit.
                // TODO: specify how: with honours etc
                studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_GRADUATE);
                if (log.isDebugEnabled()) {
                    log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId() + " set to graduate ");
                } 
                return;
                
            } else if (!isMaximumNumberOfCardinalTimeUnitReached(studyPlan, studyGradeType)){

                if (OpusConstants.STUDY_INTENSITY_FULLTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
                    // Progression / Clear pass: 
                    // If all subjects within the cardinal time-unit are succeeded. Student is automatically 
                    // forwarded to the next cardinal time-unit of the current study-gradetype.
                    studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_CLEAR_PASS);
                    if (log.isDebugEnabled()) {
                        log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId() + " set to clear pass ");
                    } 
                    return;
                }

                if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
                    // To Full-time: 
                    // if all (repeated) subjects within the cardinal time-unit at part-time are 
                    // succeeded and the student wishes to continue to full-time. 
                    // Student is automatically forwarded to the next cardinal time-unit for full-time.
                    studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_TO_FULLTIME);
                    if (log.isDebugEnabled()) {
                        log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId() + " set to to full time ");
                    } 
                    return;
                } else {
                    if (log.isDebugEnabled()) {
                        log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId() + 
                                "has study intensity = " + studyPlanCardinalTimeUnit.getStudyIntensityCode() + ": not permitted, not progress status is set");
                    } 
                    return;
                }
                
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId()
                            + " maximum number of cardinal time units reached: cannot not progress");
                } 
                studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_EXCLUDE_PROGRAM);
                return;
            }
       
        } 
        // at least one compulsory subject of the studyPlan has not been passed yet
        if (allFailedSubjectsForStudyPlan.size() != 0) {
            log.debug("JANO allFailedSubjectsForStudyPlan.size() != 0");
            if (isMaximumNumberOfCardinalTimeUnitReached(studyPlan, studyGradeType)){
                if (log.isDebugEnabled()) {
                    log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId()
                            + " maximum number of cardinal time units reached: cannot not progress");
                }
                studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_EXCLUDE_PROGRAM);
                return;
            } else {
                log.debug("JANO allFailedSubjectsForStudyPlan.size() != 0, max not reached");
//               	String subjectResultMark = "";
//                int subjectResultMarkInt = 0;
//                BigDecimal subjectResultMarkDouble = BigDecimal.ZERO;
        
                // calculate value of C+, D+ and D minimum percentage:
//                BigDecimal dPlusPercentageMinimum = BigDecimal.ZERO;
//                BigDecimal dPercentageMinimum = BigDecimal.ZERO;
         		
        		// lookup values for endGrades (used for conversion letters to numbers and vice versa)
//        		List < ? extends EndGrade > allEndGrades = null;
        		Map<String, Object> endGradeMap = new HashMap<>();
        		endGradeMap.put("preferredLanguage", preferredLanguage);
               	endGradeMap.put("endGradeTypeCode", studyGradeType.getGradeTypeCode());
               	endGradeMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());
//               	allEndGrades = studyManager.findAllEndGrades(endGradeMap);

//               	for (int i = 0 ; i < allEndGrades.size(); i++) {
        //       		if ("C+".equals(allEndGrades.get(i).getCode())) {
        //       			cPlusPercentageMinimum = allEndGrades.get(i).getPercentageMin();
        //       		}
//               		if ("D+".equals(allEndGrades.get(i).getCode())) {
//               			dPlusPercentageMinimum = allEndGrades.get(i).getPercentageMin();
//               		}
//               		if ("D".equals(allEndGrades.get(i).getCode())) {
//               			dPercentageMinimum = allEndGrades.get(i).getPercentageMin();
//               		}
//               	}
               
               	// compulsory in this ctu passed, but not all subjects in studyPlan yet
               	if (failedCompulsorySubjectResultsOfCtu.size() == 0) {
                   	 if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) { 
                         studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_TO_FULLTIME);
                         log.debug("JANO failedCompulsorySubjectResultsOfCtu.size() == 0, partime, wordt: to fulltime");
                     } else {
                         log.debug("JANO failedCompulsorySubjectResultsOfCtu.size() == 0, fulltime, wordt: to proceed & repeat");
                         studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_PROCEED_AND_REPEAT);
                     }
                
                     return;
               	}
               	
               	log.debug("JANO failedCompulsorySubjectResultsOfCtu.size() = " + failedCompulsorySubjectResultsOfCtu.size());
               	log.debug("JANO maxNumberOfFailedSubjects = " + maxNumberOfFailedSubjects);
               	if (failedCompulsorySubjectResultsOfCtu.size() <= maxNumberOfFailedSubjects) {
               	 log.debug("JANO failedCompulsorySubjectResultsOfCtu.size() <= maxNumberOfFailedSubjects");
               	    // regular and evening students (distant students never go to part-time): you are already on parttime, so you failed these already in the previous time unit
               	    // so now, failed twice, means excluded from the program
               	    if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
               	     log.debug("JANO parttime: exclude");
               	        studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_EXCLUDE_SCHOOL);
               	    } else if (OpusConstants.STUDY_INTENSITY_FULLTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
               	     
               	        // could go to proceed and repeat but we need to verify if there are no older subjects that have been failed once already
               	        // if so: exclude
               	        if (failedPreviousSubjectResultsInCtu.size() == 0) {
               	         log.debug("JANO fulltime + failedPreviousSubjectResultsInCtu.size() == 0: pr0ceed & repeat");
               	            studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_PROCEED_AND_REPEAT);
               	        // test if the failedSubjects have been failed more than once, go to parttime
               	        } else {
               	         log.debug("JANO fulltime + failedPreviousSubjectResultsInCtu.size() > 0 ");
                   	         boolean excludeStudent = false;
                             for (SubjectResult failedSubjectResult : failedPreviousSubjectResultsInCtu) {
                                 // if (studyFormCode.equals(OpusConstants.STUDY_FORM_REGULAR)) {
                                      if (hasFailedSubjectTwice(failedSubjectResult, studyPlan, preferredLanguage)) {
                                          excludeStudent = true;
                                          break;
                                      }
                               //   }
                             }
                             if (excludeStudent) {
                                 log.debug("JANO fulltime + failedPreviousSubjectResultsInCtu.size() > 0: already failed once: to parttime ");
                                 
                                 studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_TO_PARTTIME);
                             } else {
                                 log.debug("JANO fulltime + failedPreviousSubjectResultsInCtu.size() > 0: first failure: proceed & repeat ");
                                 studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_PROCEED_AND_REPEAT);
                             }
               	        }           	        
               	    }
                  
        					//Compensatory pass (P) / Proceed and repeat:
        		 			// If less than the max number of failed subjects within the cardinal time-unit for full-time are not succeeded (depending on student-type) 
        		 			// and the lowest grade of the other subjects within the cardinal time-unit is not lower than D+ and the student meets the following:
        		 			//	o has not failed more than the max number of failed subjects in a cardinal time-unit 
        		 			//	o has taken more than half of the number of subjects in this cardinal time-unit
        		 			//	o has obtained an average grade of C+ or higher for the passed subjects in this cardinal time-unit
        		 			//	Student is automatically forwarded to the next cardinal time-unit, including the less than max. failed subjects. 
        				//	studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_PROCEED_AND_REPEAT);
    //    	 	        	if (log.isDebugEnabled()) {
    //    	 	                log.debug("calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = " + studyPlanCardinalTimeUnit.getId() + " set to proceed & repeat for fulltime ");
    //    	 	            } 
        	 	    return;

        		}
               	
               	
               	if (failedCompulsorySubjectResultsOfCtu.size() == (maxNumberOfFailedSubjects +1)) {
               	 if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
                     log.debug("JANO parttime + max + 1 subejcts failed: exclude");
                        studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_EXCLUDE_SCHOOL);
                    } else if (OpusConstants.STUDY_INTENSITY_FULLTIME.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {
                        studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_TO_PARTTIME);
                    }
               	}
               	
               	
                if (failedCompulsorySubjectResultsOfCtu.size() > (maxNumberOfFailedSubjects +1)) {
                    log.debug("JANO failedCompulsorySubjectResultsOfCtu.size() > maxNumberOfFailedSubjects: exclude school");
                    studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_EXCLUDE_SCHOOL);
                    return;
                }
               
        
            } // end !(failedCompulsorySubjectResultsOfCtu.size() + 1) > maxNumberOfFailedSubjects
        } // end allFailedSubjectsForStudyPlan.size() != 0
    }

    @Override
    public boolean proceedCheck (
    		Lookup7 oldProgressStatus,
    		List < SubjectResult > allUnPassedSubjectResults,
    		int subjectId,
    		boolean subjectRepeated 
    		) {
   	
		if (log.isDebugEnabled()) {
			log.debug("proceedCheck entered");
		}
			for (int k = 0 ; k < allUnPassedSubjectResults.size(); k++) {
				if (subjectId == allUnPassedSubjectResults.get(k).getSubjectId()) {
					if ("0".equals(allUnPassedSubjectResults.get(k).getMark())
							&& OpusConstants.FAILGRADE_INCOMPLETE.equals(allUnPassedSubjectResults.get(k).getEndGradeComment())) {
						subjectRepeated = false;
					}
				}
			}
    	
		return subjectRepeated;
    }

}
