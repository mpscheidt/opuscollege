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

package org.uci.opus.college.service;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.audit.EndGradeHistory;

public interface EndGradeManagerInterface {

	/**
	 * Gets all endgrades in a particular idiomm, if lang set null every endgrade is returned	
	 * @param lang 
	 * @return
	 */
	List<? extends EndGrade> findAllEndGrades(String lang);
	List<? extends EndGrade> findEndGrades(Map<String, Object> map);

	List<Map> findEndGradesAsMaps(Map<String, Object> map);
	/**
	 * Finds endGrade based on code 
	 * @param code TODO
	 * @param endGradeTypeCode
	 * @param academicYearId TODO
	 * @param lang
	 * @return
	 */
	EndGrade findEndgrade(String code, String endGradeTypeCode, int academicYearId, String lang);
	
	EndGrade findEndGradeById(int endGradeId);
	
	/**
	 * Check if a given endGrade already exists in the list of general endGrades
	 * @param endGrade to check
	 * @return return true or false
	 */
	boolean isEndGradeExists(EndGrade endGrade);
	
	void updateEndGrade(EndGrade endGrade);
	
	/** Adds endGrade and return its id
	 * @param endGrade
	 * @return the id for the endgrade
	 */
	int addEndGrade(EndGrade endGrade);
	
	/**
	 * Adds a set of end grades, i.e. end grades tied by code
	 * @param endGrades
	 */
	void addEndGradeSet(List<? extends EndGrade> endGrades);
	void updateEndGradeSet(List<? extends EndGrade> endGrades);
	/**
	 * 
	 * @param code
	 * @param endGradeTypeCode
	 * @param academicYearId
	 * @param writeWho
	 */
	void deleteEndGradeSet(String code, String endGradeTypeCode, int academicYearId, String writeWho);

	/**
	 * 
	 * @param endGradeId
	 * @return
	 */
	List<EndGradeHistory> findEndGradeHistory(int endGradeId);

}
