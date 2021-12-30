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
 * Center for Information Services, Radboud University Nijmegen
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

package org.uci.opus.fee.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.FeeDeadline;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.persistence.AppliedFeeMapper;
import org.uci.opus.fee.persistence.FeeDeadlineMapper;
import org.uci.opus.fee.persistence.FeeMapper;
import org.uci.opus.fee.persistence.StudentBalanceMapper;
import org.uci.opus.fee.service.extpoint.FeeServiceExtensions;
import org.uci.opus.fee.util.AppliedFeeComparator;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.util.OpusMethods;

/**
 * @author move
 *
 */
public class FeeManager implements FeeManagerInterface {

    private static Logger log = LoggerFactory.getLogger(FeeManager.class);
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private FeeServiceExtensions feeServiceExtensions;
    @Autowired private LookupManagerInterface lookupManager;
    
    @Autowired
    private AppliedFeeMapper appliedFeeMapper;
    
    @Autowired
    private FeeDeadlineMapper feeDeadlineMapper;
    
    @Autowired
    private FeeMapper feeMapper;

    @Autowired
    private StudentBalanceMapper studentBalanceMapper;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    
    public List < Fee > findFeesForSubjectBlockStudyGradeTypes(final int studyId) {
        return feeMapper.findFeesForSubjectBlockStudyGradeTypes(studyId);
    }

    public List < Fee > findFeesForSubjectStudyGradeTypes(final int studyId) {
        return feeMapper.findFeesForSubjectStudyGradeTypes(studyId);
    }

    public List < Fee > findAllFees() {
        return feeMapper.findAllFees();
    }

    public Fee findFee(final int feeId) {
        return feeMapper.findFee(feeId);
    }

    @Override
    public int findFeeIdByCategoryCode(String categoryCode, String language) {
//        HashMap<String, Object> map = new HashMap<>();
//        map.put("categoryCode", categoryCode);
//        map.put("language", language);
//        return feeDao.findFeeIdByCategoryCode(map);
        return feeMapper.findFeeIdByCategoryCode(categoryCode, language);
    }
    
//    @Override
//    public int findFeeIdOfCancellation(final String categoryCode, final String language) {
//        HashMap<String, Object> map = new HashMap<>();
//        map.put("categoryCode", categoryCode);
//        map.put("language", language);
//        return feeDao.findFeeIdByCategoryCode(map);
//    }
    
    @Override
    public List < Fee > findFeesForEducationAreas(final HashMap<String, Object> map) {
    	return feeMapper.findFeesForEducationAreas(map);
    }

    public Fee findFeeByStudyIds(final Map<String, Object> map) {
        return feeMapper.findFeeByStudyIds(map);
    }

//    public List < StudyYear > findStudyYearsWithoutFee(final HashMap map) {
//        return feeDao.findStudyYearsWithoutFee(map);
//    }

    public List < SubjectStudyGradeType > findSubjectStudyGradeTypesWithoutFee(Map<String, Object> map) {
        return feeMapper.findSubjectStudyGradeTypesWithoutFee(map);
    }

    public List < SubjectBlockStudyGradeType > findSubjectBlockStudyGradeTypesWithoutFee(final Map<String, Object> map) {
        return feeMapper.findSubjectBlockStudyGradeTypesWithoutFee(map);
    }

    //    public List < Fee > findStudentFeesForStudyYears(final int studentId) {
    //        return feeDao.findStudentFeesForStudyYears(studentId);
    //    }

    @Override
    public void addFee(final Fee fee) {
        feeMapper.addFee(fee);
        feeMapper.addFeeHistory(fee);
    }

    @Override
    public void updateFee(final Fee fee) {
        feeMapper.updateFee(fee);
        feeMapper.updateFeeHistory(fee);
    }

    @Override
    public void deleteFee(final int feeId, final String writeWho) {
        Fee fee = findFee(feeId);
        fee.setWriteWho(writeWho);

        feeMapper.deleteFee(feeId);
        feeMapper.deleteFeeHistory(fee);
    }

    @Override
    public void deleteFeesForStudyGradeType(final int studyGradeTypeId, final String writeWho) {

        List <Fee> fees = feeMapper.findFeesForStudyGradeType(studyGradeTypeId);

        feeMapper.deleteFeesForStudyGradeType(studyGradeTypeId);
        
        for (Fee fee : fees) {
            fee.setWriteWho(writeWho);
            feeMapper.deleteFeeHistory(fee);
        }
    }

    @Override
    public void deleteFeesForSubjectStudyGradeType(final int subjectStudyGradeTypeId, final String writeWho) {

        List <Fee> fees = feeMapper.findFeesForSubjectStudyGradeType(subjectStudyGradeTypeId);

        feeMapper.deleteFeesForSubjectStudyGradeType(subjectStudyGradeTypeId);

        for (Fee fee :  fees) {
            fee.setWriteWho(writeWho);
            feeMapper.deleteFeeHistory(fee);
        }
    }

    @Override
    public void deleteFeesForSubjectBlockStudyGradeType(final int subjectBlockStudyGradeTypeId, final String writeWho) {

        List<Fee> fees = feeMapper.findFeesForSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);

        feeMapper.deleteFeesForSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);

        for (Fee fee : fees) {
            fee.setWriteWho(writeWho);
            feeMapper.deleteFeeHistory(fee);
        }
    }

    public List < Fee > findFeeByAcademicYearAndCategoryCode(final Map<String, Object> map) {
        return feeMapper.findFeeByAcademicYearAndCategoryCode(map);
    }

    public Fee findFeeByStudyGradeTypeIdAndCategoryCode(Map<String, Object> map) {
        return feeMapper.findFeeByStudyGradeTypeIdAndCategoryCode(map);
    }

    public List <StudyGradeType> findStudyGradeTypesForFee(final Map<String, Object> map) {
        return feeMapper.findStudyGradeTypesForFee(map);
    }

    public List < Fee > findFeesForStudyGradeTypes(final int studyId) {
        return feeMapper.findFeesForStudyGradeTypes(studyId);
    }

    public List < Fee > findFeesForBranch(final int branchId) {
        return feeMapper.findFeesForBranch(branchId);
    }

    public List < Fee > findStudentFeesForSubjectStudyGradeTypes(final int studentId) {
        return feeMapper.findStudentFeesForSubjectStudyGradeTypes(studentId);
    }

    public List < Fee > findStudentFeesForSubjectBlockStudyGradeTypes(final int studentId) {
        return feeMapper.findStudentFeesForSubjectBlockStudyGradeTypes(studentId);
    }

    public List < Fee > findStudentFeesForStudyGradeTypes(final int studentId) {
        return feeMapper.findStudentFeesForStudyGradeTypes(studentId);
    }
    
    public List < Fee > findExistingFeesForStudent(final int studentId) {
        return feeMapper.findExistingFeesForStudent(studentId);
    }
    
    public List < Fee > findPossibleSubjectFeesForStudyPlan(final int studyPlanId) {
        return feeMapper.findPossibleSubjectFeesForStudyPlan(studyPlanId);
    }

    public List < Fee > findPossibleSubjectBlockFeesForStudyPlan(final int studyPlanId) {
        return feeMapper.findPossibleSubjectBlockFeesForStudyPlan(studyPlanId);
    }

    public List < Fee > findPossibleStudyGradeTypeFeesForStudyPlan(final int studyPlanId) {
        return feeMapper.findPossibleStudyGradeTypeFeesForStudyPlan(studyPlanId);
    }
    
    public List < Fee > findPossibleEducationAreaFees(final HashMap<String, Object> map) {
    	return feeMapper.findPossibleEducationAreaFeesForStudyPlan(map);
    }
    
    // TODO: JANO - in the future needs to be replace
    public List < Fee > findStudentFeesForAcademicYears(final int studentId) {
        return feeMapper.findStudentFeesForAcademicYears(studentId);
    }

    // migration: apparently unused
//    public List < FeeCategory > findFeeCategoriesWithoutFee(final int studyGradeTypeId) {
//        return feeDao.findFeeCategoriesWithoutFee(studyGradeTypeId);
//    }

    @Override
    public List<Fee> findFeesByParams(Map<String, Object> params) {
        return feeMapper.findFeesByParams(params);
    }

    @Override
    public List<FeeDeadline> findDeadlinesForFee(int feeId) {
    	return feeDeadlineMapper.findDeadlinesForFee(feeId);
    }

	@Override
	public FeeDeadline findFeeDeadline(int id) {
		return feeDeadlineMapper.findFeeDeadline(id);
	}

	@Override
	public void addFeeDeadline(FeeDeadline feeDeadline) {
		feeDeadlineMapper.addFeeDeadline(feeDeadline);
		feeDeadlineMapper.updateFeeDeadlineHistory(feeDeadline, "I");
	}

	@Override
	public void updateFeeDeadline(FeeDeadline feeDeadline) {
	    feeDeadlineMapper.updateFeeDeadline(feeDeadline);
		feeDeadlineMapper.updateFeeDeadlineHistory(feeDeadline, "U");
	}

	@Override
	public void deleteFeeDeadline(int id, String writeWho) {
        FeeDeadline feeDeadline = findFeeDeadline(id);
        feeDeadline.setWriteWho(writeWho);

        feeDeadlineMapper.deleteFeeDeadline(id);
        feeDeadlineMapper.updateFeeDeadlineHistory(feeDeadline, "D");
	}

	@Override
	public List<FeeDeadline> findFeeDeadlines(Map<String, Object> params) {
		return feeDeadlineMapper.findFeeDeadlines(params);
	}

    @Override
    public List<Map<String, Object>> findFeeDeadlinesAsMaps(Map<String, Object> params) {
		return feeDeadlineMapper.findFeeDeadlinesAsMaps(params);
	}

	@Override
	public boolean isRepeatedDeadline(FeeDeadline feeDeadline) {
		return feeDeadlineMapper.isRepeatedDeadline(feeDeadline);
	}

    @Override
    public void updateAllStudentBalances(int studentId, String writeWho) {
        List < StudyPlanDetail> studentStudyPlanDetails = null;
        List <StudyPlan> allStudentStudyPlans = studentManager.findStudyPlansForStudent(studentId);

        for(StudyPlan studyPlan:allStudentStudyPlans){
            studentStudyPlanDetails = studentManager.findStudyPlanDetailsForStudyPlan(studyPlan.getId());
            for(StudyPlanDetail studyPlanDetail:studentStudyPlanDetails){
                createStudentBalances(studyPlanDetail,writeWho);
            }
        }
    }

    @Override
    public List < StudentBalance> findStudentBalances(final int studentId) {
        return studentBalanceMapper.findStudentBalances(studentId);
    }

    @Override
    public List<StudentBalance> findStudentBalancesByFeeId(int feeId) {
        return studentBalanceMapper.findStudentBalancesByFeeId(feeId);
    }

    @Override
    public void addStudentBalance(final StudentBalance studentBalance) {
        studentBalanceMapper.addStudentBalance(studentBalance);
        studentBalanceMapper.addStudentBalanceHistory(studentBalance);
    }

    @Override
    public void deleteStudentBalancesByStudyPlanDetailId(final int studyPlanDetailId, final String writeWho) {

        List <StudentBalance> studentBalances = studentBalanceMapper.findStudentBalancesByStudyPlanDetailId(studyPlanDetailId);

        studentBalanceMapper.deleteStudentBalancesByStudyPlanDetailId(studyPlanDetailId);

        for (StudentBalance studentBalance : studentBalances) {
            studentBalance.setWriteWho(writeWho);
            studentBalanceMapper.deleteStudentBalancesByFeeIdHistory(studentBalance);
        }
    }

    @Override
    public void deleteStudentBalancesByStudyPlanCardinalTimeUnitId(final int studyPlanCardinalTimeUnitId, String writeWho) {
        
        // first delete all payments related to the student balances that are about to be deleted
        for (StudentBalance studentBalance : studentBalanceMapper.findStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId)) {
            paymentManager.deletePaymentsForStudentBalance(studentBalance.getId(), writeWho);
        }

        // delete the student balances
        List <StudentBalance> studentBalances = 
                this.findStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
        
        studentBalanceMapper.deleteStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
        
        for (StudentBalance studentBalance : studentBalances) {
            studentBalance.setWriteWho(writeWho);
            studentBalanceMapper.deleteStudentBalancesByFeeIdHistory(studentBalance);
        }
    }
    
    public List<StudentBalance> findStudentBalancesByStudyPlanCardinalTimeUnitId(final int studyPlanCardinalTimeUnitId) {

        return studentBalanceMapper.findStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
    }
    
    public List<StudentBalance> findStudentBalancesByAcademicYearId(final int academicYearId) {
        
        return studentBalanceMapper.findStudentBalancesByAcademicYearId(academicYearId);
    }
    
    @Override
    public void deleteStudentBalancesByStudentId(final int studentId, final String writeWho) {

        List <StudentBalance> studentBalances = this.findStudentBalances(studentId);

        studentBalanceMapper.deleteStudentBalancesByStudentId(studentId);

        for (StudentBalance studentBalance : studentBalances) {
            studentBalance.setWriteWho(writeWho);
            studentBalanceMapper.deleteStudentBalancesByFeeIdHistory(studentBalance);
        }
    }

    @Override
    public void deleteStudentBalancesByFeeId(final int feeId, final String writeWho) {

        List <StudentBalance> studentBalances = this.findStudentBalancesByFeeId(feeId);

        studentBalanceMapper.deleteStudentBalancesByFeeId(feeId);

        for (StudentBalance studentBalance : studentBalances) {
            studentBalance.setWriteWho(writeWho);
            studentBalanceMapper.deleteStudentBalancesByFeeIdHistory(studentBalance);
        }
    }

    @Override
    public List<StudentBalance> createStudentBalances(StudyPlanDetail studyPlanDetail, String writeWho) {

        if (log.isDebugEnabled()) {
            log.debug("createStudentBalances for StudyPlanDetail entered...");
        }
        /* fetch needed appconfig attributes */

        List < StudentBalance> studentBalances = null;
            StudentBalance newStudentBalance = null;
        
        int studyPlanCardinalTimeUnitId = studyPlanDetail.getStudyPlanCardinalTimeUnitId();
        int studentId = studentManager.findStudentIdForStudyPlanDetailId(studyPlanDetail.getId());
        int subjectId = studyPlanDetail.getSubjectId();
        int subjectBlockId = studyPlanDetail.getSubjectBlockId();
        int studyGradeTypeId = studyPlanDetail.getStudyGradeTypeId();
        // get the academicyear from the studyGradeType
        
        boolean alreadyExist = false;
        
        int subjectBlockStudyGradeTypeId = subjectBlockMapper.findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(subjectBlockId, studyGradeTypeId);

        Map<String, Object> map = new HashMap<>();
        map.put("studyGradeTypeId", studyGradeTypeId);
        map.put("subjectId", subjectId);
        int subjectStudyGradeTypeId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);
        studentBalances = findStudentBalances(studentId);
        List <Fee> allFees = findAllFees();
        for (Fee fee : allFees) {
            alreadyExist=false;
            for(StudentBalance studentBalance:studentBalances){
                if(fee.getId()==studentBalance.getFeeId()){
                    alreadyExist = true;
                    break;
                }
            }
            if (!alreadyExist) {

                // a) Fees for specific subjects and subject blocks
                //    Note: For now, no checks made concerning intensity code etc. because it is under water
                if((fee.getSubjectBlockStudyGradeTypeId()==subjectBlockStudyGradeTypeId && subjectBlockStudyGradeTypeId != 0) ||
                    (fee.getSubjectStudyGradeTypeId()==subjectStudyGradeTypeId && subjectStudyGradeTypeId != 0)) {
                    // Students with no housingcampus do not have accomodation fees
//                      if(!("N".equals(student.getHousingOnCampus())
//                              && OpusConstants.FEE_ACCOMMODATION_CATEGORY.equals(fee.getCategoryCode()))){
                        newStudentBalance = new StudentBalance();
                        newStudentBalance.setFeeId(fee.getId());
                        newStudentBalance.setStudentId(studentId);
                        newStudentBalance.setStudyPlanDetailId(studyPlanDetail.getId());
                        newStudentBalance.setExemption("N");
                        if (writeWho != null) {
                            newStudentBalance.setWriteWho(writeWho);
                        } else {
                            newStudentBalance.setWriteWho("anonymous");
                        }
                        addStudentBalance(newStudentBalance);
                        studentBalances.add(newStudentBalance);
                        createPaymentsForStudentBalance(newStudentBalance,studyPlanDetail,studentId,studyGradeTypeId,writeWho);
//                      }
                }

            }

            // b) General fees for subjects (only if no specific subject or block have already been assigned)
            //    Note: the general subject fee can be applied several times (for each subject)
            if (newStudentBalance == null) {
                StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
                String studyIntensity = fee.getStudyIntensityCode();
                if ("0".equals(studyIntensity) || studyIntensity.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {

                    // The fee must be for 'subject' unit.
                    if (FeeConstants.FEE_UNIT_SUBJECT.equals(fee.getFeeUnitCode())) {

                        // The fee must either match the cardinaltimeunit exactly, or it must be a fee that applies to all CTUs.
                        int cardinalTimeUnitNumber = studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber();
                        if (fee.getCardinalTimeUnitNumber() == 0 || fee.getCardinalTimeUnitNumber() == cardinalTimeUnitNumber) {

                            int nSubjects = 1;

                            // if it is a subject block, multiply by the number of subjects
                            if (studyPlanDetail.getSubjectBlockId() != 0) {
                                SubjectBlock subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
                                List<? extends SubjectSubjectBlock> ssbs = subjectBlock.getSubjectSubjectBlocks();
                                if (ssbs != null) {
                                    nSubjects = ssbs.size();
                                }
                            }
                            
                            for (int i = 0; i < nSubjects; i++) {
                                newStudentBalance = new StudentBalance();
                                newStudentBalance.setFeeId(fee.getId());
                                newStudentBalance.setStudentId(studentId);
                                newStudentBalance.setStudyPlanDetailId(studyPlanDetail.getId());
                                newStudentBalance.setExemption("N");
                                if (writeWho != null) {
                                    newStudentBalance.setWriteWho(writeWho);
                                } else {
                                    newStudentBalance.setWriteWho("anonymous");
                                }
                                addStudentBalance(newStudentBalance);
                                studentBalances.add(newStudentBalance);
                                createPaymentsForStudentBalance(newStudentBalance,studyPlanDetail,studentId,studyGradeTypeId,writeWho);
                            }
                        }
                    }
                }
            }
        }
        return studentBalances;
    }

    @Override
    public List < StudentBalance> createStudentBalances(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, int studentId, 
              String preferredLanguage, String writeWho) {

        if (log.isDebugEnabled()) {
            log.debug("StudentManager.createStudentBalances for StudyPlanCardinalTimeUnit and educationArea fees entered...");
        }

        List < StudentBalance> studentBalances = null;
        List < StudentBalance> newStudentBalances = new ArrayList<StudentBalance>();
        StudentBalance newStudentBalance = null;
        int studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnit.getId();
        int studyGradeTypeId = studyPlanCardinalTimeUnit.getStudyGradeTypeId();
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        
        Lookup9 gradeType = (Lookup9) lookupManager.findLookup(
        		preferredLanguage, studyGradeType.getGradeTypeCode(), "gradeType");
        int studyPlanId = studyPlanCardinalTimeUnit.getStudyPlanId();
        String nationalityGroupCode = studentManager.findStudent(preferredLanguage,studentId).getNationalityGroupCode();

        boolean alreadyExist = false;

        studentBalances = findStudentBalances(studentId);
        
        // (a) get all fees for the particular studyGradeType and take into consideration the nationalityGroup of the student
        Map<String, Object> feeMap = new HashMap<String, Object>();
        feeMap.put("studyGradeTypeId", studyGradeTypeId);
        feeMap.put("studyIntensity", studyPlanCardinalTimeUnit.getStudyIntensityCode());
        feeMap.put("nationalityGroupCode", nationalityGroupCode);
        feeMap.put("feeUnitCodes", Arrays.asList(FeeConstants.FEE_UNIT_CARDINALTIMEUNIT, FeeConstants.FEE_UNIT_STUDYGRADETYPE));
        feeMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
        feeMap.put("active", "Y");
        List<Fee> allFees = new ArrayList<Fee>(); 
        allFees = findFeesByParams(feeMap);
        
        // (b) get all fees based on area (science/art/medicine based) and level (undergraduate/postgraduate) of education
        feeMap.remove("studyGradeTypeId");
        
        feeMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());
        feeMap.put("studyTimeCode", studyGradeType.getStudyTimeCode());
        feeMap.put("studyFormCode", studyGradeType.getStudyFormCode());
        feeMap.put("educationAreaCode", gradeType.getEducationAreaCode());
        feeMap.put("educationLevelCode", gradeType.getEducationLevelCode());
        
//        int branchId = studyManager.findBranchByStudyPlanId(studyPlanId).getId();
//        feeMap.put("branchIdOr0", branchId); // branchId may be 0, then the fee applies to all branches in the given academic year
        List<Fee> allBranchFees = findFeesByParams(feeMap);

        // for now, simply join all fees together -> could be changed to allow overriding of education area fees by studygradetype fees
        if (allBranchFees != null) allFees.addAll(allBranchFees);
        

//        List <Fee> allFees = findAllFees();  // findFeesByParams is in fee module, so not accessible here
        for(Fee fee : allFees){
            alreadyExist=false;
            for (StudentBalance studentBalance : studentBalances) {
                if (fee.getId() == studentBalance.getFeeId()) {
                    alreadyExist = true;
                    break;
                }
            }
            if (!alreadyExist) {
//                if (fee.getStudyGradeTypeId() == studyGradeTypeId) {

                    // The fee must either match the study intensity exactly, or it must be a fee that applies to all intensities.
//                    String studyIntensity = fee.getStudyIntensityCode();
//                    if ("0".equals(studyIntensity) || studyIntensity.equals(studyPlanCardinalTimeUnit.getStudyIntensityCode())) {

                        // Fees can be for cardinaltimeunit or studygradetype
                        // In case of studygradetype, it must be the first studyplancardinaltimeunit that is being added (to put e.g. admission fees)
                        if (FeeConstants.FEE_UNIT_CARDINALTIMEUNIT.equals(fee.getFeeUnitCode()) ||
                                (FeeConstants.FEE_UNIT_STUDYGRADETYPE.equals(fee.getFeeUnitCode()) 
                                        && !studentManager.hasOtherStudyPlanCardinalTimeUnits(studyPlanId, studyPlanCardinalTimeUnitId)
                                        )
                                ) {

                            // The fee must either match the cardinaltimeunit exactly, or it must be a fee that applies to all CTUs.
//                            int cardinalTimeUnitNumber = studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber();
//                            if (fee.getCardinalTimeUnitNumber() == 0 || fee.getCardinalTimeUnitNumber() == cardinalTimeUnitNumber) {
    
                                // Students with no housingcampus do not have accomodation fees
//                                if(!("N".equals(student.getHousingOnCampus()) 
//                                        && FeeConstants.FEE_CATEGORY_ACCOMMODATION.equals(fee.getCategoryCode()))) {

                                    // TODO in case of accommodation fee: check for room type / hostel type
                                    // If any of the filters is applicable, then ask that one if the fee is to be applied
                                    // If none of the filters is applicable, then apply the fee
                                    
                                    if (feeServiceExtensions.isFeeApplicableForCardinalTimeUnit(fee, studyPlanCardinalTimeUnit)) {
                                    
                                        newStudentBalance = new StudentBalance();
                                        newStudentBalance.setFeeId(fee.getId());
                                        newStudentBalance.setStudentId(studentId);
                                        newStudentBalance.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
                                        newStudentBalance.setExemption("N");
                                        if (writeWho != null) {
                                            newStudentBalance.setWriteWho(writeWho);
                                        } else {
                                            newStudentBalance.setWriteWho("anonymous");
                                        }
                                        addStudentBalance(newStudentBalance);
                                        studentBalances.add(newStudentBalance);
                                        
                                        newStudentBalances.add(newStudentBalance);
                                        // remove?
//                                        createPaymentsForStudentBalance(newStudentBalance, studyPlanCardinalTimeUnit, studentId, preferredLanguage, studyGradeTypeId, writeWho);
                                    }
//                                }
//                            }
                        }
//                    }
//                }
            }
        }
//        return studentBalances;
        return newStudentBalances;
    }

/*    @Override
    public List < StudentBalance> createStudentBalances(int academicYearId, int studyPlanId, int studentId, 
            String preferredLanguage, String writeWho) {
          
        if (log.isDebugEnabled()) {
            log.debug("StudentManager.createStudentBalances for branches entered...");
        }
        List < StudentBalance> studentBalances = null;
        StudentBalance newStudentBalance = null;
        int id = 0;
        boolean alreadyExist = false;
        // find the branch that the study of the student belongs to
        int branchId = studyManager.findBranchByStudyPlanId(studyPlanId).getId();
        Student student = studentManager.findStudent(preferredLanguage, studentId);

        studentBalances = findStudentBalances(studentId);
        List <Fee> allFees = findAllFees();
        for(Fee fee:allFees){
            alreadyExist=false;
            for(StudentBalance studentBalance:studentBalances){
                if(fee.getId()==studentBalance.getFeeId()){
                    alreadyExist = true;
                    break;
                }
            }
            if(!alreadyExist){
                if (fee.getBranchId() == branchId && branchId != 0 && fee.getAcademicYearId() == academicYearId) {
                    // Students with no housingcampus do not have accomodation fees
//                      if(!("N".equals(student.getHousingOnCampus()) 
//                              && OpusConstants.FEE_ACCOMMODATION_CATEGORY.equals(fee.getCategoryCode()))){
                        newStudentBalance = new StudentBalance();
                        newStudentBalance.setFeeId(fee.getId());
                        newStudentBalance.setStudentId(studentId);
                        newStudentBalance.setAcademicYearId(academicYearId);
//                      newStudentBalance.set
                        newStudentBalance.setExemption("N");
                        if (writeWho != null) {
                            newStudentBalance.setWriteWho(writeWho);
                        } else {
                            newStudentBalance.setWriteWho("anonymous");
                        }
                        id = addStudentBalance(newStudentBalance);
                        studentBalances.add(newStudentBalance);
                        newStudentBalance.setId(id);
                        // nothing happens in this case here, because there are no payments yet?
                        createPaymentsForStudentBalance(newStudentBalance, academicYearId , studentId, preferredLanguage,  writeWho);
//                      }
                }
            }
        }
        return studentBalances;
    }*/

    @Override
    public void createPaymentsForStudentBalance(StudentBalance newStudentBalance, StudyPlanDetail studyPlanDetail,int studentId,int currentStudyGradeTypeId, String writeWho){
        int subjectId = studyPlanDetail.getSubjectId();
        int subjectBlockId = studyPlanDetail.getSubjectBlockId();
        int subjectStudyGradeTypeId = 0;
        int subjectBlockStudyGradeTypeId = 0;
        int installmentNumber =0;
        double alreadyPaid = 0.0;
        Payment newPayment = null;
        Payment newPaymentReverse = null;
        Map<String, Object> findStudyGradeTypesMap = new HashMap<>();
        Map<String, Object> findSubjectStudyGradeType = new HashMap<>();
        List<StudyGradeType>studyGradeTypes = null;
        List<StudentBalance>studentBalances = findStudentBalances(studentId);
        List <Fee> allFees = findAllFees();
        List<Payment> paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);

        String preferredLanguage = opusMethods.getPreferredLanguage();  // The language doesn't really play a role in this method, but it needs to exist in lookup tables

        //First subjects
        if(subjectId != 0){
            int subjectStudyId = subjectManager.findSubjectPrimaryStudyId(subjectId);
            findStudyGradeTypesMap.put("studyId", subjectStudyId);
            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
            studyGradeTypes=studyManager.findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);
            Collections.sort(studyGradeTypes,new StudyGradeTypesComparatorDescending());
   outer:   for(StudyGradeType studyGradeType: studyGradeTypes){
                alreadyPaid = 0.0;
                if(studyGradeType.getId()==currentStudyGradeTypeId){
                    continue;
                }
                findSubjectStudyGradeType.put("studyGradeTypeId", studyGradeType.getId());
                findSubjectStudyGradeType.put("subjectId", subjectId);
                subjectStudyGradeTypeId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(findSubjectStudyGradeType);
                if(subjectStudyGradeTypeId >0){
                    for(Fee fee:allFees){
                        for(StudentBalance studentBalance:studentBalances){
                            if(fee.getId()==studentBalance.getFeeId() && fee.getSubjectStudyGradeTypeId()==subjectStudyGradeTypeId){
                                for(Payment payment: paymentsForStudent) {
                                    if(payment.getStudentBalanceId()==studentBalance.getId()) {
                                        alreadyPaid += payment.getSumPaid().doubleValue();
                                    }
                                }
                                if(alreadyPaid >0){
                                    // Add payment to current fee/studentBalance 
                                    newPayment = new Payment();
                                    newPayment.setFeeId(newStudentBalance.getFeeId());
                                    newPayment.setStudentBalanceId(newStudentBalance.getId());
                                    newPayment.setPayDate(new Date());
                                    newPayment.setStudentId(newStudentBalance.getStudentId());
                                    newPayment.setActive("Y");
                                    newPayment.setSumPaid(BigDecimal.valueOf(alreadyPaid));
                                    newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,newStudentBalance.getFeeId()));
                                    if(newPayment.getInstallmentNumber()>(installmentNumber = findFee(newStudentBalance.getFeeId())==null?0:findFee(newStudentBalance.getFeeId()).getNumberOfInstallments())){
                                        log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPayment.getInstallmentNumber()+","+(installmentNumber));
                                    }
                                 //   else{
                                            // Add negative payment to older fee/studentBalance
                                        newPaymentReverse = new Payment();
                                        newPaymentReverse.setFeeId(studentBalance.getFeeId());
                                        newPaymentReverse.setStudentBalanceId(studentBalance.getId());
                                        newPaymentReverse.setPayDate(new Date());
                                        newPaymentReverse.setStudentId(studentBalance.getStudentId());
                                        newPaymentReverse.setActive("Y");
                                        newPaymentReverse.setSumPaid(BigDecimal.valueOf(0.0-alreadyPaid));
                                        newPaymentReverse.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,studentBalance.getFeeId()));
                                        if(newPaymentReverse.getInstallmentNumber()>fee.getNumberOfInstallments()){
                                            log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPaymentReverse.getInstallmentNumber()+","+fee.getNumberOfInstallments());
                                        }
                                      //  else{
                                            paymentManager.addPayment(newPaymentReverse, writeWho);
                                            paymentManager.addPayment(newPayment, writeWho);
                                            break outer;
                                        //}   
                                  //  }
                                }
                            }
                        }
                    }   
                }
            }
        }
        // Then subjectblocks
        if(subjectBlockId >0){
            int subjectBlockStudyId = subjectBlockMapper.findSubjectBlockPrimaryStudyId(subjectBlockId);
            findStudyGradeTypesMap.put("studyId", subjectBlockStudyId);
            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
            studyGradeTypes=studyManager.findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);
            Collections.sort(studyGradeTypes,new StudyGradeTypesComparatorDescending());
    outer:  for(StudyGradeType studyGradeType: studyGradeTypes){
                alreadyPaid = 0.0;
                if(studyGradeType.getId()==currentStudyGradeTypeId){
                    continue;
                }
                subjectBlockStudyGradeTypeId = subjectBlockMapper.findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(subjectBlockId, studyGradeType.getId());
                if(subjectBlockStudyGradeTypeId >0){
                    for(Fee fee:allFees){
                        for(StudentBalance studentBalance:studentBalances){
                            if(fee.getId()==studentBalance.getFeeId() && fee.getSubjectBlockStudyGradeTypeId()==subjectBlockStudyGradeTypeId){
                                for(Payment payment: paymentsForStudent){
                                    if(payment.getStudentBalanceId()==studentBalance.getId()){
                                        alreadyPaid += payment.getSumPaid().doubleValue();
                                    }
                                }   
                                if(alreadyPaid >0){
                                    // Add payment to current fee/studentBalance 
                                    newPayment = new Payment();
                                    newPayment.setFeeId(newStudentBalance.getFeeId());
                                    newPayment.setStudentBalanceId(newStudentBalance.getId());
                                    newPayment.setPayDate(new Date());
                                    newPayment.setStudentId(newStudentBalance.getStudentId());
                                    newPayment.setActive("Y");
                                    newPayment.setSumPaid(BigDecimal.valueOf(alreadyPaid));
                                    newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,newStudentBalance.getFeeId()));
                                    if(newPayment.getInstallmentNumber()>(installmentNumber=findFee(newStudentBalance.getFeeId())==null?0:findFee(newStudentBalance.getFeeId()).getNumberOfInstallments())){
                                        log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPayment.getInstallmentNumber()+","+(installmentNumber));
                                    }
                                 //   else{
                                            // Add negative payment to older fee/studentBalance
                                        newPaymentReverse = new Payment();
                                        newPaymentReverse.setFeeId(studentBalance.getFeeId());
                                        newPaymentReverse.setStudentBalanceId(studentBalance.getId());
                                        newPaymentReverse.setPayDate(new Date());
                                        newPaymentReverse.setStudentId(studentBalance.getStudentId());
                                        newPaymentReverse.setActive("Y");
                                        newPaymentReverse.setSumPaid(BigDecimal.valueOf(0.0-alreadyPaid));
                                        newPaymentReverse.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,studentBalance.getFeeId()));
                                        if(newPaymentReverse.getInstallmentNumber()>fee.getNumberOfInstallments()){
                                            log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPaymentReverse.getInstallmentNumber()+","+fee.getNumberOfInstallments());
                                        }
                                      //  else{
                                            paymentManager.addPayment(newPaymentReverse, writeWho);
                                            paymentManager.addPayment(newPayment, writeWho);
                                            break outer;
                                    //    }   
                                 //   }
                                }
                            }
                        }
                    }   
                }
            }
        }
    }

    @Override     
    public void createPaymentsForStudentBalance(StudentBalance newStudentBalance, int academicYearId ,int studentId,String writeWho){

        int installmentNumber =0;
        double alreadyPaid = 0.0;
        Payment newPayment = null;
        Payment newPaymentReverse = null;
        Map<String, Object> findAcademicYearsMap = new HashMap<>();
        List<AcademicYear>academicYears = academicYearManager.findAcademicYears(findAcademicYearsMap);
        Collections.sort(academicYears,new AcademicYearsTypesComparatorDescending());
        List<StudentBalance>studentBalances = findStudentBalances(studentId);
        List <Fee> allFees = findAllFees();
        List<Payment> paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);
        //AcademicYears
        if(academicYearId >0){
 outer:     for(AcademicYear academicYear: academicYears){
                alreadyPaid = 0.0;
                if(academicYear.getId()==academicYearId){
                    continue;
                }
                for(Fee fee:allFees){
                    for(StudentBalance studentBalance:studentBalances){
                        if(fee.getId()==studentBalance.getFeeId() && fee.getAcademicYearId()==academicYear.getId()
                                ){
                            for(Payment payment: paymentsForStudent){
                                if(payment.getStudentBalanceId()==studentBalance.getId()){
                                    alreadyPaid += payment.getSumPaid().doubleValue();
                                }
                            }   
                            if(alreadyPaid >0){
                                // Add payment to current fee/studentBalance 
                                newPayment = new Payment();
                                newPayment.setFeeId(newStudentBalance.getFeeId());
                                newPayment.setStudentBalanceId(newStudentBalance.getId());
                                newPayment.setPayDate(new Date());
                                newPayment.setStudentId(newStudentBalance.getStudentId());
                                newPayment.setActive("Y");
                                newPayment.setSumPaid(BigDecimal.valueOf(alreadyPaid));
                                newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,newStudentBalance.getFeeId()));
                                //
                                if(newPayment.getInstallmentNumber()>(installmentNumber = findFee(newStudentBalance.getFeeId())==null?0:findFee(newStudentBalance.getFeeId()).getNumberOfInstallments())){
                                    log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPayment.getInstallmentNumber()+","+(installmentNumber));
                                }
                              //  else{
                                        // Add negative payment to older fee/studentBalance
                                    newPaymentReverse = new Payment();
                                    newPaymentReverse.setFeeId(studentBalance.getFeeId());
                                    newPaymentReverse.setStudentBalanceId(studentBalance.getId());
                                    newPaymentReverse.setPayDate(new Date());
                                    newPaymentReverse.setStudentId(studentBalance.getStudentId());
                                    newPaymentReverse.setActive("Y");
                                    newPaymentReverse.setSumPaid(BigDecimal.valueOf(0.0-alreadyPaid));
                                    newPaymentReverse.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,studentBalance.getFeeId()));
                                    if(newPaymentReverse.getInstallmentNumber()>fee.getNumberOfInstallments()){
                                        log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPaymentReverse.getInstallmentNumber()+","+fee.getNumberOfInstallments());
                                    }
                                 //   else{
                                        paymentManager.addPayment(newPaymentReverse, writeWho);
                                        paymentManager.addPayment(newPayment, writeWho);
                                        break outer;
                                  //  }   
                              //  }
                            }
                        }
                    }   
                }
            }
        }
    }      

    @Override     
    public void createPaymentsForStudentBalance(StudentBalance newStudentBalance, StudyPlanCardinalTimeUnit currentStudyPlanCardinalTimeUnit,int studentId,int currentStudyGradeTypeId, String writeWho){

        int studyGradeTypeId = currentStudyPlanCardinalTimeUnit.getStudyGradeTypeId();
        int installmentNumber =0;
        double alreadyPaid = 0.0;
        Payment newPayment = null;
        Payment newPaymentReverse = null;
        Map<String, Object> findStudyGradeTypesMap = new HashMap<>();
        List<StudyPlanCardinalTimeUnit>studyPlanCardinalTimeUnits = null;
        List<StudentBalance>studentBalances = findStudentBalances(studentId);
        int studyPlanId = currentStudyPlanCardinalTimeUnit.getStudyPlanId();
        List <Fee> allFees = findAllFees();
        List<Payment> paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);

        String preferredLanguage = opusMethods.getPreferredLanguage();  // The language doesn't really play a role in this method, but it needs to exist in lookup tables

        //StudyPlanDardinalTimeUnits
        if(studyPlanId >0){
          findStudyGradeTypesMap.put("studyPlanId", studyPlanId);
          findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
          studyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(findStudyGradeTypesMap);
          Collections.sort(studyPlanCardinalTimeUnits,new StudyPlanCardinalTimeUnitsComparatorDescending());
 outer:   for(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit: studyPlanCardinalTimeUnits){
                alreadyPaid = 0.0;
                if(studyPlanCardinalTimeUnit.getId()==currentStudyPlanCardinalTimeUnit.getId()){
                    continue;
                }
                if(studyGradeTypeId >0){
                    for(Fee fee:allFees){
                        for(StudentBalance studentBalance:studentBalances){
                            if(fee.getId()==studentBalance.getFeeId() && fee.getStudyGradeTypeId()==studyPlanCardinalTimeUnit.getStudyGradeTypeId()){
                                for(Payment payment: paymentsForStudent){
                                    if(payment.getStudentBalanceId()==studentBalance.getId()){
                                        alreadyPaid += payment.getSumPaid().doubleValue();
                                    }
                                }   
                                if(alreadyPaid >0){
                                    // Add payment to current fee/studentBalance 
                                    newPayment = new Payment();
                                    newPayment.setFeeId(newStudentBalance.getFeeId());
                                    newPayment.setStudentBalanceId(newStudentBalance.getId());
                                    newPayment.setPayDate(new Date());
                                    newPayment.setStudentId(newStudentBalance.getStudentId());
                                    newPayment.setActive("Y");
                                    newPayment.setSumPaid(BigDecimal.valueOf(alreadyPaid));
                                    newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,newStudentBalance.getFeeId()));
                                    if(newPayment.getInstallmentNumber()>(installmentNumber = findFee(newStudentBalance.getFeeId())==null ? 0 : findFee(newStudentBalance.getFeeId()).getNumberOfInstallments())){
                                        log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPayment.getInstallmentNumber()+","+(installmentNumber));
                                    }
                               //     else{
                                            // Add negative payment to older fee/studentBalance
                                        newPaymentReverse = new Payment();
                                        newPaymentReverse.setFeeId(studentBalance.getFeeId());
                                        newPaymentReverse.setStudentBalanceId(studentBalance.getId());
                                        newPaymentReverse.setPayDate(new Date());
                                        newPaymentReverse.setStudentId(studentBalance.getStudentId());
                                        newPaymentReverse.setActive("Y");
                                        newPaymentReverse.setSumPaid(BigDecimal.valueOf(0.0-alreadyPaid));
                                        newPaymentReverse.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(paymentsForStudent,studentBalances,studentBalance.getFeeId()));
                                        if(newPaymentReverse.getInstallmentNumber()>fee.getNumberOfInstallments()){
                                            log.warn("StudentManager.createPaymentsForStudentBalance new payment intallment number bigger than fee installment number "+newPaymentReverse.getInstallmentNumber()+","+fee.getNumberOfInstallments());
                                        }
                                     //   else{
                                            paymentManager.addPayment(newPaymentReverse, writeWho);
                                            paymentManager.addPayment(newPayment, writeWho);
                                            break outer;
                                     //   }   
                                //    }
                                }
                            }
                        }
                    }   
                }
            }
        }
    }      


//    public List < Fee > findAllFees() {
//        return studentDao.findAllFees();
//    }
//
    @Override
    public void updateStudentBalance(final StudentBalance studentBalance) {
        studentBalanceMapper.updateStudentBalance(studentBalance);
        studentBalanceMapper.updateStudentBalanceHistory(studentBalance);
    }



    // TODO move separate class files for these comparators
    public class StudyGradeTypesComparatorDescending implements Comparator<StudyGradeType> {
        public int compare(StudyGradeType studyGradeType1, StudyGradeType studyGradeType2){
            
//            StudyGradeType studyGradeType1 = (StudyGradeType)object1;
//            StudyGradeType studyGradeType2 = (StudyGradeType)object2;
            if(studyGradeType1.getCurrentAcademicYearId() == studyGradeType2.getCurrentAcademicYearId())
                return 0;
                else if(studyGradeType1.getCurrentAcademicYearId() < studyGradeType2.getCurrentAcademicYearId() )
                    return 1;
                else
                    return -1;
        }
    }
    public class StudyPlanCardinalTimeUnitsComparatorDescending implements Comparator<StudyPlanCardinalTimeUnit> {
        public int compare(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit1, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit2) {
            
//            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit1 = (StudyPlanCardinalTimeUnit)object1;
//            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit2 = (StudyPlanCardinalTimeUnit)object2;
            StudyGradeType studyGradeType1 = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit1.getStudyGradeTypeId());
            StudyGradeType studyGradeType2 = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit2.getStudyGradeTypeId());
            if(studyGradeType1.getCurrentAcademicYearId() == studyGradeType2.getCurrentAcademicYearId())
                return 0;
                else if(studyGradeType1.getCurrentAcademicYearId() < studyGradeType2.getCurrentAcademicYearId() )
                   return 1;
                else
                   return -1;
        }
    }
    public class AcademicYearsTypesComparatorDescending implements Comparator<AcademicYear> {
        public int compare(AcademicYear academicYear1, AcademicYear academicYear2) {

//            AcademicYear academicYear1 = (AcademicYear)object1;
//            AcademicYear academicYear2 = (AcademicYear)object2;
            if(Integer.parseInt(academicYear1.getDescription()) == Integer.parseInt(academicYear2.getDescription()))
                return 0;
                else if(Integer.parseInt(academicYear1.getDescription()) < Integer.parseInt(academicYear2.getDescription()) )
                    return 1;
                else
                    return -1;
        }
    }
    
    // methods on appliedFees and BalanceBroughtForward
    @Override
    public List < AppliedFee > findAppliedFeesForStudent(final int studentId) {
        return appliedFeeMapper.findAppliedFeesForStudent(studentId);
    }
    
    @Override
    public AppliedFee findAppliedFeeForStudentBalance(final int studentBalanceId) {
        return appliedFeeMapper.findAppliedFeeForStudentBalance(studentBalanceId);
    }
    
    @Override
    public List < AppliedFee > getAppliedFeesForStudent(Student student, String language) {

         // get all the fees applied to this student
         List < AppliedFee > allAppliedFees = findAppliedFeesForStudent(student.getStudentId());
    
         // student should always exist
         if (student.getStudentId() != 0) {
             // loop through the list and check if any discounts are in order
             for (AppliedFee appliedFee : allAppliedFees) {
                 int ctuNumber = -1;
                 int academicYearId = -1;
                 AcademicYear academicYear = null;
                // BigDecimal discountedFee = new BigDecimal(0.00);
                 StudyPlanCardinalTimeUnit studyPlanCtu = null;
                 int studyPlanCtuId = appliedFee.getStudyPlanCardinalTimeUnitId();
                 int studyPlanDetailId = appliedFee.getStudyPlanDetailId();
                 // used for calculating the final feeDue, taking into account any discounts
               //  BigDecimal hundredPercent = new BigDecimal(100);
                 //BigDecimal discountPercentage = new BigDecimal(0.00);
            
                 // fee on studyPlanCtu
                 if (studyPlanCtuId != 0) {
//                     // get the studPlanCtu so we can get the academicYear and ctuNumber
                     studyPlanCtu = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCtuId);
                
                     // calculate the discount percentage for this fee for this student
//                     discountPercentage = discountPercentage.add(
//                         this.getAppliedFeeDiscountForStudyPlanCtu(studyPlanCtu, appliedFee
//                                                                     , student, language));
                 // fee on subject or subjectBlock                   
                 } else if (studyPlanDetailId != 0) {
                     // get the studPlanCtu so we can get the academicYear and ctuNumber
                     studyPlanCtu = studentManager.findStudyPlanCtuForStudyPlanDetail(
                                                                         studyPlanDetailId);
                
                     // calculate the discount percentage for this fee for this student
//                     discountPercentage = discountPercentage.add(
//                                     this.getAppliedFeeDiscountForStudyPlanDetail(studyPlanCtu
//                                             , appliedFee, student, language
//                                             , appliedFee.getStudyPlanDetailId()));
                     appliedFee.setStudyPlanCardinalTimeUnitId(studyPlanCtu.getId());
                 }
        
                 /* Calculate the actual fee that the student needs to pay, taking into account
                 * any discounts:
                 * feeDue * (100 - discountPercentage) / 100);
                 */
//                 discountedFee = (appliedFee.getFee().getFeeDue())
//                 .multiply((hundredPercent.subtract(discountPercentage))
//                 .divide(hundredPercent));
                 appliedFee.setDiscountedFeeDue(appliedFee.getFee().getFeeDue());
            
                 // get the currentAcademicYearId through the studyGradeType of the
                 // StudyPlanCardinalTimeUnit; this should never by null
                 if (studyPlanCtu != null) {
                     
                     ctuNumber =studyPlanCtu.getCardinalTimeUnitNumber();
                     academicYearId = studyManager.findAcademicYearIdForStudyGradeTypeId(
                                                     studyPlanCtu.getStudyGradeTypeId());

                 // fee on area and level of education: get the academicYearId of the fee   
                 } else {
                	 academicYearId = appliedFee.getAcademicYear().getId();
                 }
                 if (academicYearId != 0) {
                     academicYear = academicYearManager.findAcademicYear(academicYearId);
                 }
        
                 appliedFee.setAcademicYear(academicYear);
                 appliedFee.setCtuNumber(ctuNumber);
        
                 // add all paid fees to the total sum paid for this fee
                 Map<String, Object> map = new HashMap<>();
                 map.put("studentBalanceId", appliedFee.getStudentBalanceId());
                 List<Payment> payments = paymentManager.findPaymentsByParams(map);
                 BigDecimal amountPaid = new BigDecimal(0);
                 for (Payment payment : payments) {
                     amountPaid = amountPaid.add(payment.getSumPaid());
                 }
                 appliedFee.setAmountPaid(amountPaid);
             }
             Collections.sort(allAppliedFees, new AppliedFeeComparator());
             
             if (log.isDebugEnabled()) {
            	 for (AppliedFee appliedFee : allAppliedFees) {
            		 log.debug("getAppliedFeesForStudent.appliedFee = " + appliedFee.toString());
            	 }
             }
         }
         return allAppliedFees;
     }
    
    @Override
    public BigDecimal calculateBalanceBroughtForward(final StudyPlanCardinalTimeUnit newStudyPlanCtu
            , final StudyPlanCardinalTimeUnit previousStudyPlanCtu, final String language
            ) {

        // all fees not (fully) paid by the student yet: only one fee may be paid partially,
        // the others will not have been paid at all
        List<AppliedFee> allAppliedFees = null;
        BigDecimal balanceBroughtForward = new BigDecimal(0.00);
        int previousStudyPlanCtuId =0;
        if (previousStudyPlanCtu != null){
           	previousStudyPlanCtuId = previousStudyPlanCtu.getId();
            int newStudyPlanCtuId = newStudyPlanCtu.getId();

            Student student = studentManager.findPlainStudentByStudyPlanCtuId(newStudyPlanCtuId);
            
            allAppliedFees = this.getAppliedFeesForStudent(student, language);
            // only the appliedFees of the last studyPlanCtu are of interest
            for (AppliedFee appliedFee : allAppliedFees) {
                if (appliedFee.getStudyPlanCardinalTimeUnitId() == previousStudyPlanCtuId) {
                    BigDecimal feeDue = appliedFee.getDiscountedFeeDue();
                    BigDecimal amountPaid = appliedFee.getAmountPaid();

                    // -1: amountPaid < feeDue, 0: amountPaid = feeDue, 1: amountPaid > feeDue
                    // so: if fee not (completely) paid yet, set to list
                    balanceBroughtForward = balanceBroughtForward.add(feeDue.subtract(amountPaid)); 
                }
            }

            int feeIdOfBalanceBF = this.findFeeIdByCategoryCode(FeeConstants.BALANCE_BROUGHT_FORWARD_CAT, language);
            StudentBalance studentBalance = new StudentBalance(student.getStudentId(), feeIdOfBalanceBF
                                                                , "N", "opuscollege-fees");
            studentBalance.setStudyPlanCardinalTimeUnitId(newStudyPlanCtuId);
            studentBalance.setAmount(balanceBroughtForward);
            this.addStudentBalance(studentBalance);
        }
     
        return balanceBroughtForward;
    }
    
//    public BigDecimal getAppliedFeeDiscountForStudyPlanCtu(
//            final StudyPlanCardinalTimeUnit studyPlanCtu
//            , final AppliedFee appliedFee, final Student student
//            , final String language) {
//
//        BigDecimal discountPercentage = new BigDecimal(0);
//        
//        StudyGradeType studyGradeType = null;
//        boolean foundLocalStudentDiscount = false;
//        Fee fee = appliedFee.getFee();
//        
//        /* tuitionWaiverDiscountPercentage */    
////        if("Y".equals(studyPlanCtu.getTuitionWaiver())){
////            discountPercentage = discountPercentage.add(new BigDecimal(
////                                    fee.getTuitionWaiverDiscountPercentage()));
////        }
////        if(studyPlanCtu.getCardinalTimeUnitNumber()>1){
////            discountPercentage = discountPercentage.add(new BigDecimal(
////                                fee.getContinuedRegistrationDiscountPercentage()));
////        }
//        
//        /*fulltimeStudentDiscountPercentage */
//        studyGradeType = studyManager.findStudyGradeType(studyPlanCtu.getStudyGradeTypeId());
////        if("F".equals(studyGradeType.getStudyIntensityCode())){
////            discountPercentage = discountPercentage.add(new BigDecimal(
////                                    fee.getFulltimeStudentDiscountPercentage()));
////        }
////        
//        /*localStudentDiscountPercentage */
////        if("SATC".equals(student.getNationalityGroupCode())){
////            foundLocalStudentDiscount = true;
////        }
////        
////        if("N".equals(student.getForeignStudent())){
////            foundLocalStudentDiscount = true;
////        }
////        if(foundLocalStudentDiscount) {
////            discountPercentage = discountPercentage.add(new BigDecimal(
////                                    fee.getLocalStudentDiscountPercentage()));
////        }
//        
//        /* postgraduateDiscountPercentage */
//        /* check if this is a master */
////        if (opusMethods.isGradeTypeIsMaster(language, studyGradeType.getGradeTypeCode())) {
////            discountPercentage = discountPercentage.add(
////                    new BigDecimal(fee.getPostgraduateDiscountPercentage()));
////        }
//        
//        // TODO: needed??
////        discountPercentage = discountPercentage.add(new BigDecimal(
////                financeServiceExtensions.getDiscountPercentage(student, fee)));
//        
//        // if discountPercentage > 100%, then set it to a 100%
//        discountPercentage = this.maximizeDiscountPercentage(discountPercentage);
//        
//        return discountPercentage;
//        
//    }

//    public BigDecimal getAppliedFeeDiscountForStudyPlanDetail(
//                final StudyPlanCardinalTimeUnit studyPlanCtu
//                    , final AppliedFee appliedFee, final Student student
//                    , final String language, final int studyPlanDetailId) {
//        
//        StudyPlanDetail studyPlanDetail = null;
//        BigDecimal discountPercentage = new BigDecimal(0);
//        StudyGradeType studyGradeType = null;
//        boolean foundLocalStudentDiscount = false;
//        Fee fee = appliedFee.getFee();
//        
//        if("Y".equals(studyPlanCtu.getTuitionWaiver())){
//            discountPercentage = discountPercentage.add(new BigDecimal(
//                                    fee.getTuitionWaiverDiscountPercentage()));
//        }
//        
//        studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
//        /* fulltimeStudentDiscountPercentage */
//        studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
//        if ("F".equals(studyGradeType.getStudyIntensityCode())) {
//            discountPercentage = discountPercentage.add(new BigDecimal(fee.getFulltimeStudentDiscountPercentage()));
//        }
//        
//        /* localStudentDiscountPercentage */
//        if ("SATC".equals(student.getNationalityGroupCode())) {
//            foundLocalStudentDiscount = true;
//        }
//        if ("N".equals(student.getForeignStudent())) {
//            foundLocalStudentDiscount = true;
//        }
//        if (foundLocalStudentDiscount) {
//            discountPercentage = discountPercentage.add(new BigDecimal(fee.getLocalStudentDiscountPercentage()));
//        }
//        /* continuedRegistrationDiscountPercentage */
//        if (studyPlanCtu.getCardinalTimeUnitNumber() > 1) {
//            discountPercentage = discountPercentage.add(new BigDecimal(fee.getContinuedRegistrationDiscountPercentage()));
//        }
//        
//        /* postgraduateDiscountPercentage */
//        /* check if this is a master */
//        if (opusMethods.isGradeTypeIsMaster(language, studyGradeType.getGradeTypeCode())) {
//            discountPercentage = discountPercentage.add(
//                    new BigDecimal(fee.getPostgraduateDiscountPercentage()));
//        }
//        
//        // if discountPercentage > 100%, then set it to a 100%
//        discountPercentage = this.maximizeDiscountPercentage(discountPercentage);
//        
//        return discountPercentage;  
//        
//    }

//    public BigDecimal getAppliedFeeDiscountForBranch(
//        final AppliedFee appliedFee, final Student student) {
//        
//        BigDecimal discountPercentage = new BigDecimal(0);
//        boolean foundLocalStudentDiscount = false;
//        Fee fee = appliedFee.getFee();
//        
//        /* tuitionWaiverDiscountPercentage */    
//        /*fulltimeStudentDiscountPercentage */
//        /*localStudentDiscountPercentage */
//        if("SATC".equals(student.getNationalityGroupCode())){
//            foundLocalStudentDiscount = true;
//        }
//        if("N".equals(student.getForeignStudent())){
//            foundLocalStudentDiscount = true;
//        }
//        if(foundLocalStudentDiscount){
//            discountPercentage = discountPercentage.add(new BigDecimal(fee.getLocalStudentDiscountPercentage()));
//        }
//        /* continuedRegistrationDiscountPercentage */
//        
//        /* postgraduateDiscountPercentage */
//        
//        // if discountPercentage > 100%, then set it to a 100%
//        discountPercentage = this.maximizeDiscountPercentage(discountPercentage);
//        
//        return discountPercentage;
//        
//    }

    /* if the percentage is higher than 100%, then return 100, otherwise return the
       original percentage */
//    private BigDecimal maximizeDiscountPercentage(BigDecimal discountPercentage) {
//        BigDecimal hundred = new BigDecimal(100);
//        if (discountPercentage.compareTo(hundred) == 1) {
//            discountPercentage = hundred;
//        }
//        return discountPercentage;
//    }

}
