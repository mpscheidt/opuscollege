/*******************************************************************************
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
 ******************************************************************************/
package org.uci.opus.fee.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.fee.domain.FeeDeadline;

public interface FeeDeadlineMapper {

    /**
     * Transfer feeDeadlines that do not yet exist in the target year.
     */
    void transferStudyGradeTypeFeeDeadlines(@Param("sourceStudyGradeTypeId") int sourceStudyGradeTypeId,
            @Param("targetStudyGradeTypeId") int targetStudyGradeTypeId,
            @Param("interval") String interval);

    /**
     * Transfer feeDeadlines that do not yet exist in the target year.
     */
    void transferAcademicYearFeeDeadlines(@Param("sourceAcademicYearId") int sourceAcademicYearId,
            @Param("targetAcademicYearId") int targetAcademicYearId,
            @Param("interval") String interval);

    /**
     * Transfer feeDeadlines that do not yet exist in the target year.
     */
    void transferSubjectFeeDeadlines(@Param("sourceAcademicYearId") int sourceAcademicYearId,
            @Param("targetAcademicYearId") int targetAcademicYearId,
            @Param("interval") String interval);

    /**
     * Transfer feeDeadlines that do not yet exist in the target year.
     */
    void transferSubjectBlockFeeDeadlines(@Param("sourceAcademicYearId") int sourceAcademicYearId,
            @Param("targetAcademicYearId") int targetAcademicYearId,
            @Param("interval") String interval);

    List<FeeDeadline> findDeadlinesForFee(int feeId);

    FeeDeadline findFeeDeadline(int id);

    List<FeeDeadline> findFeeDeadlines(Map<String, Object> params);

    List<Map<String, Object>> findFeeDeadlinesAsMaps(Map<String, Object> params);
    
    void addFeeDeadline(FeeDeadline feeDeadline);

    void updateFeeDeadlineHistory(@Param("FeeDeadline") FeeDeadline feeDeadline, @Param("operation") String operation);
    
    void updateFeeDeadline(FeeDeadline feeDeadline);

    void deleteFeeDeadline(int id);

    boolean isRepeatedDeadline(FeeDeadline feeDeadline);
    

}
