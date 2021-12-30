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

import org.uci.opus.college.domain.Student;

public interface StudentNumberGeneratorInterface {
    
    /**
     * Calculate a new unique student number
     * when the screen is displayed where the user can enter new student data.
     */
    public static final String KEY_SCREEN = "screen";

    /**
     * Calculate a new unique student number when a new student is to be
     * created in the database, and the student code is empty.
     */
    public static final String KEY_SUBMIT = "submit";

    /**
     * Decide if a student number shall be generated in a given situation,
     * e.g. on screen when entering a new student, when submitting a new student,
     * or when admitting a student.
     * @param key e.g. "screen", "submit", "admission"
     * @return
     */
    boolean applies(String key);

	/**
	 * calculate a new unique student number
	 * when the screen is displayed where the user can enter new student data.
	 * @return the student number
	 */
//	String createUniqueStudentNumberOnScreen(int organizationalUnitId);
	
    /**
     * Get a validator to be used before calling
     * <code>createUniqueStudentNumberOnSubmit(int, Student)</code.
     * 
     * @return if null is returned, no validator shall be used.
     */
//	Validator getOnSubmitValidator(String modeOfGeneration);
	
    /**
     * Calculate a new unique student number. when a new student is to be
     * created in the database, and the student code is empty.
     * @param key
     * @param organizationalUnitId
     *            the organizational unit to which the student is assigned
     * @param student
     *            the student object after being filled in by the user, but
     *            before being submitted to the database
     * 
     * @return the student number
     */
//	String createUniqueStudentNumberOnSubmit(int organizationalUnitId, final Student student);
	
    String createUniqueStudentCode(String key, int organizationalUnitId, final Student student);

}
