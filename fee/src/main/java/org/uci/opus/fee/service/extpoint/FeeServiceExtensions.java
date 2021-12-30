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
 * The Original Code is Opus-College fee module code.
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

package org.uci.opus.fee.service.extpoint;

import java.lang.reflect.Field;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;
import org.uci.opus.fee.domain.Fee;

@Service
public class FeeServiceExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(FeeServiceExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private Collection<FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit> feeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit;
    
    // curriculum transition
    private Collection<AcademicYearFeeTransitionExtPoint> academicYearFeeTransitionsExtensions;

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

    public Collection<FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit> getFeeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit() {
        return feeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit;
    }

    @Autowired(required=false)
    public void setFeeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit(Collection<FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit> advisors) {
        this.feeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit = advisors;
        extensionPointUtil.logExtensions(log, FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit.class, advisors);
    }

    /**
     * If either no advisor supports the fee, or if at least one advisor says {@link FeeAdvisorApplicability#FEE_APPROVED},
     * then the fee is applicable.
     * <br>
     * I.e. if at least one says {@link FeeAdvisorApplicability#FEE_REJECTED}, and no one says {@link FeeAdvisorApplicability#FEE_APPROVED},
     * then the fee is not be applied (to the student).
     * @param fee
     * @param studyPlanCardinalTimeUnit
     * @return
     */
    public boolean isFeeApplicableForCardinalTimeUnit(final Fee fee, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
        // overallApplicability can move from UNSUPPORTED TO REJECTED to APPROVED, but not in the other direction.
        FeeAdvisorApplicability overallApplicability = FeeAdvisorApplicability.UNSUPPORTED;
        if (feeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit != null) {
            for (FeeApplicabilityAdvisorForStudyPlanCardinalTimeUnit extension : feeApplicabilityAdvisorsForStudyPlanCardinalTimeUnit) {
                FeeAdvisorApplicability applicability = extension.applies(fee, studyPlanCardinalTimeUnit);
                switch (applicability) {
                case FEE_REJECTED:
                    if (overallApplicability == FeeAdvisorApplicability.UNSUPPORTED) {
                        overallApplicability = FeeAdvisorApplicability.FEE_REJECTED;
                    }
                    break;
                case FEE_APPROVED:
                    overallApplicability = FeeAdvisorApplicability.FEE_APPROVED;
                    break;
                default:
                    // do nothing in case of UNSUPPORTED
                    break;
                }
            }
        }
        return overallApplicability != FeeAdvisorApplicability.FEE_REJECTED;
    }

    public Collection<AcademicYearFeeTransitionExtPoint> getAcademicYearFeeTransitionsExtensions() {
        return academicYearFeeTransitionsExtensions;
    }

    @Autowired(required=false)
    public void setAcademicYearFeeTransitionsExtensions(Collection<AcademicYearFeeTransitionExtPoint> academicYearFeeTransitionsExtensions) {
        this.academicYearFeeTransitionsExtensions = academicYearFeeTransitionsExtensions;
        extensionPointUtil.logExtensions(log, AcademicYearFeeTransitionExtPoint.class, academicYearFeeTransitionsExtensions);
    }

    /**
     * Delegate
     * @param sourceFeeId
     * @param targetFeeId
     */
    public void transfer(int sourceFeeId, int targetFeeId) {
        if (academicYearFeeTransitionsExtensions != null) {
            for (AcademicYearFeeTransitionExtPoint extension : academicYearFeeTransitionsExtensions) {
                extension.transfer(sourceFeeId, targetFeeId);
            }
        }
    }

}
