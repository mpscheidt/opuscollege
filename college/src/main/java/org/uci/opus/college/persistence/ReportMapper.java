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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

/**
 * Defines methods for retrieving data for students reports.
 * 
 * @author Stelio Macumbe
 *
 */
public interface ReportMapper {

	/**
	 * Count students.
	 */
	int findStudentCount(Map<String, Object> map);
	
	/**
	 * Find individual students.
	 */
	List<Map<String, Object>> findStudents(Map<String, Object> map);

	/**
	 * Find study plans for students whose name matches the specified name.
	 */
	List<Map<String, Object>> findStudyPlansByName(Map<String, Object> map);

	/**
	 * Find studyplanCardinaltimeunits.
	 */
	List<Map<String, Object>> findStudyplanCardinalTimeUnits(Map<String, Object> map);

	/**
	 * Count CTUStudygradetypes.
	 */
	int findCTUStudygradetypesCount(Map<String, Object> map);
	
    /**
     * Finds combinations of academic year and time unit (see table cardinaltimeunitstudygradetype),
     * for example "Medicine 2015 1st year".
     */
	List<Map<String, Object>> findCTUStudygradetypes(Map<String, Object> map);

    /**
     * Get a list of cardinal time units.
     * @param map
     * @return
     */
    List<Map<String, Object>> findCTUs(Map<String , Object> map);

}
