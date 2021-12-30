package org.uci.opus.ucm.web.service.campusonline;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.lookup.LookupUtil;

@Service
public class LatestTimeUnitDTOFactory {

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StudentManagerInterface studentManager;

    /**
     * Create a {@link LatestTimeUnitDTO} object for the given studyPlan.
     * 
     * @param studyPlan
     * @return
     */
    public LatestTimeUnitDTO forStudyPlan(StudyPlan studyPlan) {
        LatestTimeUnitDTO timeUnit = new LatestTimeUnitDTO();

        // studyDescription (comes from StudyPlan)
        timeUnit.setStudyDescription(studyPlan.getStudy().getStudyDescription());

        // gradeTypeDescription (comes from StudyPlan)
        Lookup9 gradeType = LookupUtil.getLookupByCode(lookupCacher.getAllGradeTypes(OpusConstants.LANGUAGE_PT), studyPlan.getGradeTypeCode());
        timeUnit.setGradeTypeDescription(gradeType == null ? null : gradeType.getDescription());

        // Find the most recent spctu and set timeUnitNumber and progressStatus
        StudyPlanCardinalTimeUnit latestForStudyPlan = studentManager.findMaxCardinalTimeUnitForStudyPlan(studyPlan.getId());
        timeUnit.setTimeUnitNumber(latestForStudyPlan.getCardinalTimeUnitNumber());

        String progressStatusCode = latestForStudyPlan.getProgressStatusCode();
        if (progressStatusCode != null) {
            Lookup7 progressStatus = LookupUtil.getLookupByCode(lookupCacher.getAllProgressStatuses(OpusConstants.LANGUAGE_PT), progressStatusCode);
            timeUnit.setProgressStatus(progressStatus == null ? null : progressStatus.getDescription());
        }

        return timeUnit;
    }

}
