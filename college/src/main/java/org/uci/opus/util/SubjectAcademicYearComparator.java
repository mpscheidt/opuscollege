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

package org.uci.opus.util;

import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.service.AcademicYearManagerInterface;


public class SubjectAcademicYearComparator implements Comparator<Subject> {

	@Autowired private AcademicYearManagerInterface academicYearManager;
	
	 public int compare(Subject o1, Subject o2) {
		 
		List < AcademicYear > allAcademicYears = null;
		Date maxEndDate = new Date();
	    int maxAcademicYearId = 0;
	    DateUtil dtc = new DateUtil();
			
	    allAcademicYears = academicYearManager.findAllAcademicYears();
				
		maxEndDate = dtc.parseSimpleDate("1950-01-01", "yyyy-MM-dd");
		maxAcademicYearId = 0;
			
		for (int x = 0; x < allAcademicYears.size(); x++) {
			/* use the enddate to see which is the most recent subject */
			if (o1.getCurrentAcademicYearId() 
						== allAcademicYears.get(x).getId()) {
				if (allAcademicYears.get(x).getEndDate().after(maxEndDate)) {
					maxEndDate = allAcademicYears.get(x).getEndDate();
					maxAcademicYearId = o1.getCurrentAcademicYearId();
				}
			}
		}
		for (int x = 0; x < allAcademicYears.size(); x++) {
			/* use the enddate to see which is the most recent subject */
			if (o2.getCurrentAcademicYearId() 
						== allAcademicYears.get(x).getId()) {
				if (allAcademicYears.get(x).getEndDate().after(maxEndDate)) {
					maxEndDate = allAcademicYears.get(x).getEndDate();
					maxAcademicYearId = o1.getCurrentAcademicYearId();
				}
			}
		}
		if (o1.getCurrentAcademicYearId() == maxAcademicYearId 
				&& o2.getCurrentAcademicYearId() != maxAcademicYearId) {
			return 1;
		}
		if (o1.getCurrentAcademicYearId() == maxAcademicYearId 
				&& o2.getCurrentAcademicYearId() == maxAcademicYearId) {
			return 0;
		}
		if (o2.getCurrentAcademicYearId() == maxAcademicYearId
				&& o1.getCurrentAcademicYearId() != maxAcademicYearId ) {
			return -1;
		}
		
		// default value:
		return 0;
    }
}
