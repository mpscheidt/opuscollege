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

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.ThesisSupervisor;

public interface ThesisSupervisorMapper {

    /**
     * Add an advisor to a thesis
     * 
     * @param thesisSupervisor
     *            to add
     */
    void addThesisSupervisor(ThesisSupervisor thesisSupervisor);

    /**
     * Update a given thesis advisor
     * 
     * @param thesisSupervisor
     *            to update
     */
    void updateThesisSupervisor(ThesisSupervisor thesisSupervisor);

    /**
     * Update whether or not all supervisors of a given thesis are principal supervisors
     * 
     * @param thesisId
     *            id of the thesis the supervisors are linked to
     * @param principal
     *            Y or N
     */
    void updateThesisSupervisorsPrincipal(@Param("thesisId") int thesisId, @Param("principal") String principal);

    /**
     * Delete a given supervisor
     * 
     * @param thesisSupervisorId
     *            id of the supervisor to delete
     */
    void deleteThesisSupervisor(int thesisSupervisorId);

    /**
     * Delete all thesis supervisors of a given thesis
     * 
     * @param thesisId
     *            id of the thesis to which the supervisors to delete ar linked
     */
    void deleteThesisSupervisorsByThesisId(int thesisId);

    /**
     * Find a thesis supervisor by it's id
     * 
     * @param id
     *            of the supervisor to find
     * @return a ThesisSupervisor
     */
    ThesisSupervisor findThesisSupervisor(int id);

    /**
     * Find the thesis supervisors of a given thesis
     * 
     * @param thesisId
     *            id of the thesis to which the supervisors are linked
     * @return a list of ThesisSupervisors
     */
    List<ThesisSupervisor> findThesisSupervisorsByThesisId(int thesisId);

}
