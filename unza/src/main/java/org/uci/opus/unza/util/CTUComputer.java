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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unza.util;

import java.util.HashMap;
import java.util.Map;

import org.jfree.util.Log;
import org.springframework.stereotype.Service;

/*
 * @author: Katuta G.C Kaunda
 * */
@Service
public class CTUComputer {

	/*
	 * This method receives a map object containing the srs acadyr recordand
	 * returns a map containg the ayear split from the semester and theCTU#
	 */
	public static Map<String, Object> getAcademicYearSemester(
			Map<String, Object> stdRecord) {
		/* Compute the AYear */
		Integer ayear = 0;
		Integer yrOfPgm = 0;
		yrOfPgm = Integer.parseInt((String) stdRecord.get("yrofpgm"));
		ayear = Integer.parseInt((String) stdRecord.get("ayear"));
		Integer academicYear = 0;
		academicYear = ayear / 10;

		/* Compute the Semester */
		Integer semester = 0;
		semester = ayear % 10;
		Integer CTU = 0;

		/* Compute the CTU# */
		CTU = computeCTU(yrOfPgm, semester);

		Map<String, Object> ayearToCTU = new HashMap<String, Object>();
		ayearToCTU.put("ayear", academicYear);
		ayearToCTU.put("semester", semester);
		ayearToCTU.put("CTU", CTU);

		return ayearToCTU;
	}
	
	/*Better computeCTU implementation*/
	public static int computeCTU2(int yrofgm, int ayear){
		int semester=0;
		semester = ayear % 10;
		
		if (semester == 1)
			return (yrofgm *2)-1;
		else if (semester == 2)
			return yrofgm * 2;
		else
			return -1;
	}

	/* This Method Computes the CTU# */
	private static int computeCTU(int yrofgm, int semester) {
		/* Get the yrofpgm */
		int yr = yrofgm;
		int semstr = semester;
		int CTU = 0;
		/* Get the semester */

		switch (yr) {
		case 1:
			if (semstr == 1)
				return 1;
			if (semstr == 2)
				return 2;
			break;
		case 2:
			if (semstr == 1)
				return 3;
			if (semstr == 2)
				return 4;
			break;
		case 3:
			if (semstr == 1)
				return 5;
			if (semstr == 2)
				return 6;
			break;
		case 4:
			if (semstr == 1)
				return 7;
			if (semstr == 2)
				return 8;
			break;
		case 5:
			if (semstr == 1)
				return 9;
			if (semstr == 2)
				return 10;
			break;
		case 6:
			if (semstr == 1)
				return 11;
			if (semstr == 2)
				return 12;
			break;
		case 7:
			if (semstr == 1)
				return 13;
			if (semstr == 2)
				return 14;
			break;
		default:
			return 0;

		}
		;

		return 0;
	}
}
