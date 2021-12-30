package org.uci.opus.accommodationfee.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.expoint.IRoomAllocationListener;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.OpusMethods;

@Service
public class RoomAllocationListener implements IRoomAllocationListener {

    @Autowired private FeeManagerInterface feeManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;

    /**
     * Add fees for the allocated room.
     */
    @Override
    public void roomAllocated(StudentAccommodation studentAccommodation, HttpServletRequest request) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String writeWho = opusMethods.getWriteWho(request);

        // CTU fees (semester/trimester/year/...)
//        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());

        int academicYearId = studentAccommodation.getAcademicYear().getId();
        Student student = studentAccommodation.getStudent();

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentAcademicYearId", academicYearId);

        for (StudyPlan studyPlan : student.getStudyPlans()) {
            
            map.put("studyPlanId", studyPlan.getId());
            
            // get all spctus in the given academic year and create the fees in each spctu
            List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(map);
            for (StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit : studyPlanCardinalTimeUnits) {

                // NB: This assumes that createStudentBalances(...) is intelligent enough
                // to avoid billing the same fee twice.
                feeManager.createStudentBalances(studyPlanCardinalTimeUnit,
                      studyPlan.getStudentId(),
                      preferredLanguage, writeWho);
            }
        }

    }

    /**
     * Remove fees related to the deallocated room.
     */
    @Override
    public void roomDeallocated(StudentAccommodation studentAccommodation, HttpServletRequest request) {
        
        // Currently, no fees are removed automatically
        
    }

}
