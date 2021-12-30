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
 * The Original Code is Opus-College scholarship module code.
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
package org.uci.opus.scholarship.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.scholarship.domain.Sponsor;

public interface SponsorMapper {

    List<Sponsor> findAllSponsors();

    /**
     * Find a list of academicYears that a given sponsor offers scholarships
     * 
     * @param sponsorId
     *            id of the sponsor
     * @return a list of academicYears
     */
    List<AcademicYear> findAcademicYearsForSponsor(int sponsorId);

    void addSponsor(Sponsor sponsor);
    
    void updateSponsor(Sponsor sponsor);
    
    void deleteSponsor(int sponsorId);
    
    Sponsor findSponsorById(int sponsorId);
    
    List<Sponsor> findSponsors(Map<String, Object> params);
    
    List<Map<String, Object>> findSponsorsAsMaps(Map<String, Object> params);
    
    boolean doesSponsorExist(Map<String, Object> params);
    
    /**
     *Finds tables which reference sponsor with id = sponsorId 
     * @param sponsorid
     * @return
     */
    Map<String, Object> findSponsorDependencies(int sponsorId);
    
    void insertSponsorHistory(@Param("Sponsor") Sponsor sponsor, @Param("operation") String operation);

    /**
     * Transfer sponsors from one academic year to another.
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSponsors(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

}
