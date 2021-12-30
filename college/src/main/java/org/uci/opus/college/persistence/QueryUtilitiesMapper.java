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

import org.apache.ibatis.annotations.Param;

/**
 * @author stelio2
 * @since Dec 21, 2009
 */
public interface QueryUtilitiesMapper {

    /**
     * Checks if a table exists in the opuscollege schema
     * 
     * @param tableName
     * @return
     */
    boolean existsTable(String tableName);

    /**
     * Checks if a value exists in a table
     */
    boolean existsValue(@Param("table") String table, @Param("column") String column, @Param("value") Object value);

    /**
     * count occurrences of a value in a table
     * 
     * @param table
     * @param column
     * @param value
     * @return number of occurrences of that value
     */
    int countValue(@Param("table") String table, @Param("column") String column, @Param("value") Object value);

    /**
     * Gets the next id for a sequence. Note that this will permanently set id for the sequence.
     * 
     * @param sequenceName
     * @return nextId
     */
    int getNextId(String sequenceName);

    /**
     * Get the current value of the sequence with the given name.
     * Note that an error is thrown if no sequence value has been created yet in the current session.
     * @param sequenceName
     * @return
     */
    int getCurrentId(String sequenceName);
}
