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

package org.uci.opus.college.web.extpoint;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.service.AcademicYearManagerInterface;

public abstract class ThesisResultFormatter extends ResultFormatter<ThesisResult, String> {

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    /**
     * Get a String representation of the given thesis result.
     * This overrides the get(Object) method from the Map interface and enables
     * the use in JSP pages.
     * @param thesisResult
     * @return
     */
    @Override
    public abstract String get(Object thesisResult);

    /**
     * Load info needed for displaying the result with get(thesisResult).
     * @param thesisResult
     * @param endGradeTypeCode
     * @param preferredLanguage
     */
    public void loadAdditionalInfo(ThesisResult thesisResult, String endGradeTypeCode, String preferredLanguage) {
        
        if (!getUseEndGrades()) {
            return;
        }
        
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", thesisResult.getStudyPlanId());
        AcademicYear lastAcademicYear = academicYearManager.findLastAcademicYear(map);
        
        // only if we have at least one spctu is there a chance for an endgrade
        if (lastAcademicYear == null) {
            return;
        }

        EndGrade endGrade = getEndGrade(lastAcademicYear.getId(), thesisResult.getMark(), endGradeTypeCode, preferredLanguage);

        if (endGrade != null) {
            thesisResult.setGradePoint(endGrade.getGradePoint());
        }

    }

}
