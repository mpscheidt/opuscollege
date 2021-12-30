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

package org.uci.opus.college.domain.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.TestTeacher;

public abstract class StaffMemberUtil {

	public static List<Integer> extractStaffMemberIdsFromSubjectTeachers(List < ? extends SubjectTeacher > subjectTeachers) {
		if (subjectTeachers == null) return null;
		List<Integer> ids = new ArrayList<Integer>(subjectTeachers.size());
		for (Iterator<? extends SubjectTeacher> it = subjectTeachers.iterator(); it.hasNext(); ) {
			SubjectTeacher teacher = it.next();
			ids.add(teacher.getStaffMemberId());
		}
		return ids;
	}

	public static List<Integer> extractStaffMemberIdsFromExaminationTeachers(List < ? extends ExaminationTeacher > examinationTeachers) {
		if (examinationTeachers == null) return null;
		List<Integer> ids = new ArrayList<Integer>(examinationTeachers.size());
		for (Iterator<? extends ExaminationTeacher> it = examinationTeachers.iterator(); it.hasNext(); ) {
			ExaminationTeacher teacher = it.next();
			ids.add(teacher.getStaffMemberId());
		}
		return ids;
	}

    public static List<Integer> extractStaffMemberIdsFromTestTeachers(List < ? extends TestTeacher > testTeachers) {
        if (testTeachers == null) return null;
        List<Integer> ids = new ArrayList<Integer>(testTeachers.size());
        for (Iterator<? extends TestTeacher> it = testTeachers.iterator(); it.hasNext(); ) {
            TestTeacher teacher = it.next();
            ids.add(teacher.getStaffMemberId());
        }
        return ids;
    }

	/**
	 * get list of StaffMember objects which correspond to given list of subjectTeachers
	 * @param allTeachers
	 * @param staffMemberId
	 * @return
	 */
	public static List < StaffMember > extractTeachersBySubjectTeachers(
			List < StaffMember > allTeachers,
			List < ? extends SubjectTeacher > subjectTeachers) {
		if (subjectTeachers == null) return null;
		List<Integer> staffMemberIds = extractStaffMemberIdsFromSubjectTeachers(subjectTeachers);
		List<StaffMember> result = getTeachersWithStaffMemberIds(allTeachers, staffMemberIds);
		return result;
	}

	public static List < StaffMember > extractTeachersByExaminationTeachers(List < StaffMember > allTeachers,
			List < ? extends ExaminationTeacher > examinationTeachers) {
		if (examinationTeachers == null) return null;
		List<Integer> staffMemberIds = extractStaffMemberIdsFromExaminationTeachers(examinationTeachers);
		List<StaffMember> result = getTeachersWithStaffMemberIds(allTeachers, staffMemberIds);
		return result;
	}

    public static List < StaffMember > extractTeachersByTestTeachers(List < StaffMember > allTeachers,
            List < ? extends TestTeacher > testTeachers) {
        if (testTeachers == null) return null;
        List<Integer> staffMemberIds = extractStaffMemberIdsFromTestTeachers(testTeachers);
        List<StaffMember> result = getTeachersWithStaffMemberIds(allTeachers, staffMemberIds);
        return result;
    }

	public static List<StaffMember> getTeachersWithStaffMemberIds(List<StaffMember> allTeachers,
			List<Integer> staffMemberIds) {
		List<StaffMember> result = new ArrayList<StaffMember>(staffMemberIds.size());
		for (Iterator<? extends Integer> it = staffMemberIds.iterator(); it.hasNext(); ) {
			Integer staffMemberId = it.next();
			StaffMember teacher = getTeacher(allTeachers, staffMemberId.intValue());
			result.add(teacher);
		}
		return result;
	}

	/**
	 * get a teacher for a given staffMemberId
	 * @param allTeachers
	 * @param staffMemberId
	 * @return
	 */
	public static StaffMember getTeacher(List < StaffMember > allTeachers, int staffMemberId) {
		StaffMember result = null;
		for (Iterator<? extends StaffMember> it = allTeachers.iterator(); it.hasNext(); ) {
			StaffMember teacher = it.next();
			if (teacher.getStaffMemberId() == staffMemberId) {
				result = teacher;
				break;
			}
		}
		return result;
	}

}
