package org.uci.opus.college.web.extpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.util.DummyMap;

public abstract class ResultFormatter<K, V> extends DummyMap<K, V> {

    protected Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private ResultManagerInterface resultManager;

    // remove this once Opus has a proper cache
    private Boolean useEndGrades;

    // a cheap-and-dirty apporach to "cache" the "useEndGrades" sys-option
    // TODO replace this after a proper cache has been introduced in Opus.
    protected boolean getUseEndGrades() {
        if (this.useEndGrades == null) {
            this.useEndGrades = appConfigManager.getUseEndGrades();
            log.info("useEndGrades flag is: " + this.useEndGrades);
        }
        return this.useEndGrades;
    }

    /**
     * Find the EndGrade for the given parameters.
     * 
     * @param studyPlanId
     * @param mark
     * @param endGradeTypeCode
     * @param preferredLanguage
     * @return
     */
    protected EndGrade getEndGrade(int academicYearId, String mark, String endGradeTypeCode, String preferredLanguage) {

        // only load endgrade related data if endgrades are used at all
        if (!getUseEndGrades()) {
            return null;
        }

        EndGrade endGrade = resultManager.calculateEndGradeForMark(mark, endGradeTypeCode, preferredLanguage, academicYearId);

        return endGrade;
    }
}
