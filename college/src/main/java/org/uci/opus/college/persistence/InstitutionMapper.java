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

package org.uci.opus.college.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.Institution;

/**
 * @author J.Nooitgedagt
 *
 */
public interface InstitutionMapper {

    /**
     * Get a list of all institutions of a certain educationType.
     * 
     * @param findInstitutionsMap
     *            might contain the parameters: educationTypeCode
     * @return list of institutions
     */
    List<Institution> findInstitutions(final Map<String, Object> findInstitutionsMap);

    /**
     * This method is used for editing an organizationalUnit. With the branchId of the organizationalUnit, the corresponding institutionId
     * is selected. This is needed to show the correct institution in the dropdown list in organizationalunit.jsp.
     * 
     * @param branchId
     *            used to find the corresponding institutionId
     * @return institutionId
     */
    Integer findInstitutionOfBranch(final int branchId);

    /**
     * @param institutionId
     *            id of the institution to find
     * @return Institution found
     */
    Institution findInstitution(final int institutionId);

    /**
     * @param institutionCode
     * @return institution
     */
    Institution findInstitutionByCode(String institutionCode);
    
    /**
     * Find a duplicate according to the unique key
     */
    Institution existsDuplicate(@Param("institutionCode") String institutionCode, @Param("id") int id);

    /**
     * @param institution
     *            to add
     */
    void addInstitution(final Institution institution);

    /**
     * @param institution
     *            to update
     */
    void updateInstitution(final Institution institution);

    /**
     * @param institutionId
     *            id of institution to delete
     */
    void deleteInstitution(final int institutionId);
}
