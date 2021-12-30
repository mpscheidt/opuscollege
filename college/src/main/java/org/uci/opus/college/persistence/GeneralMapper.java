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

import java.util.Map;


/**
 * @author Stelio Macumbe
 * March 14 , 2009
 */
public interface GeneralMapper {


	/**
	 * Updates a table "tableName" with the "fields" based in the table "updateField" and "updateFieldValue".
	 * @param tableName
	 * @param criteriaField
	 * @param criteriaValue
	 * @param field
	 * @param newValue
	 */
	<V , V2> void updateField(String tableName , String criteriaField , V2 criteriaValue , String field , V newValue);

	/**
	 * Finds the correct email property in the mailConfig table
	 * @param map with the following: mailType
	 * 								propertyName
	 * 								preferredLanguage
	 * @return corresponding configproperty
	 */
	String findMailConfigProperty(Map map);

	/**
	 * Logs a mail that could not be sent
	 * @param map with: recipients - list of 0 - n recipients
	 * 		msgSubject - subject of the mail
	 * 		msgSender - sender from the mail 
	 * 		errorMsg - the reason the mail could not be sent
	 */
	void logMailError(final Map map);

	/**
	 * Logs a mail that could not be sent
	 * @param map with: 
	 *  	ipAddress - ip address of the request
	 *  	requestString - content of the request
	 *  	errorMsg - the reason the request could not be received
	 */
	void logRequestError(final Map map);


}
