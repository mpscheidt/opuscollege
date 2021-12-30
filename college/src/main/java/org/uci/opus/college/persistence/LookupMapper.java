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
import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.college.domain.Lookup;

/**
 * Interface for Lookup-related management methods. The Lookups are filled with various general code-listings (country, addresstype, ...).
 * 
 * In org.uci.opus.college.domain there are 7 children of the parent Lookup class: Lookup1 to Lookup8. Together they cover all lookup-tables
 * in the database. All Lookups have a complete code-list for each language supported (e.g. EN, PT, ...) See for a complete list of the
 * lookup-tables (and the lookup1 to lookup8 variations): org.uci.opus.college.data.LookupDao.
 * 
 * @author move
 */
public interface LookupMapper {

    public static final String KEY_LANG = "preferredLanguage";
    public static final String KEY_CODE = "code";
    public static final String KEY_DESCRIPTION = "description";
    public static final String KEY_TABLENAME = "tableName";

    /**
     * 
     * @param preferredLanguage
     * @param tableName
     * @param order
     * @return
     * 
     */
    <T extends Lookup> List<T> findAllRows(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows1(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows2(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows3(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows4(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows5(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows6(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows7(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows8(String preferredLanguage, String tableName, String order);

    <T extends Lookup> List<T> findAllRows9(String preferredLanguage, String tableName, String order);

    /**
     * @param preferredLanguage
     *            of user
     * @param tableName
     *            table which is being queried
     * @param codeName
     *            name of the code-column in this table
     * @param code
     *            of the lookups to find
     * @return List of all rows for a specific code-name from this lookuptable.
     */
    <T extends Lookup> List<T> findAllRowsForCode(String preferredLanguage, String tableName, String codeName, String code);

    /**
     * Finds lookups given a description or part of the description If set to NULL , the preferredLanguage is ignored
     * 
     * @param preferredLanguage
     * @param tableName
     * @param description
     * @return
     */
    <T extends Lookup> List<T> findRowsByDescription(String preferredLanguage, String tableName, String description);

    Object findLookup(Map<String, Object> params, final String tableName);

    /**
     * @param entityName
     * @param entityId
     * @param lookupCode
     * @param tableName
     */
    // void addLookupToEntity(final String entityName, final int entityId
    // , final String lookupCode, final String tableName);

    /**
     * @param entityName
     *            generic name for lookup-entity
     * @param entityId
     *            id of lookup entity
     * @param lookupCode
     *            code of lookup to delete
     * @param tableName
     *            name of lookup table
     */
    void deleteLookupFromEntity(@Param("entityName") String entityName, @Param("entityId") int entityId, @Param("lookupCode") String lookupCode,
            @Param("tableName") String tableName);
    // void deleteLookupFromEntity(final String entityName, final int entityId
    // , final String lookupCode, final String tableName);

    /**
     * Gets the max code value from a lookup table
     * 
     * @param tableName
     *            - the name of the table from which extract the code
     * @return a code
     */
    Integer getNextId(@Param("tableName") String tableName);

    /**
     * Finds all Lookup tables available
     * 
     * @return - List of available lookup tables
     */
    List<LookupTable> findAllLookupTables();

    /**
     * Finds all lookup tables which the name is more less the specified
     * 
     * @param tableName
     * @return
     */
    List<LookupTable> findLookupTablesByName(String tableName);

    /**
     * Gets a lookup table given its name
     * 
     * @param tableName
     * @return a look which name is the same as the one specified
     */
    LookupTable findLookupTableByName(String tableName);

    // MP 2014-12-29: Apparently not used anywhere
    // /**
    // * Adds a lookup
    // * @param code
    // * @param description
    // * @param lang
    // * @param active
    // * @param tableName
    // */
    // void addLookup(String code , String description , String lang ,String active, String tableName);

    /**
     * Adds a Lookup
     * 
     * @param <T>
     * @param lookup
     *            - may be a Lookup instance or an instance of subclass of Lookup
     * @param tableName
     * @throws IllegalAccessException
     * @throws IllegalArgumentException
     */
    <T extends Lookup> void addLookup(T lookup, String tableName);

    /**
     * Adds a set of lookups
     * 
     * @param <T>
     * @param lookup
     * @param tableName
     * @return the code of the new set of lookups
     */
    <L extends Lookup> String addLookupSet(List<L> lookups, String tableName);

    /**
     * Updates a lookup entry It gets the id of the parameter Lookup "T" and puts its values in whatever lookup that has the same id (and
     * table) in the database
     * 
     * @param lookup
     * @param tableName
     * @throws IllegalAccessException
     * @throws IllegalArgumentException
     */
    <T extends Lookup> void updateLookup(T lookup, String tableName);

    /**
     * Deletes a lookup given a code and language if only the language is null then every lookup with the specified code will be deleted
     * 
     * @param code
     * @param lang
     * @param tableName
     */
    void deleteLookupByCode(@Param("lang") String lang, @Param("code") String code, @Param("tableName") String tableName);

    // MP 2014-12-29: not used anywhere
    // /**
    // * Finds the values for a dependency, more exactly it returns the codes of the dependencies
    // * @param map
    // * @return
    // */
    // List <String> findDependencyValues(String lookupTable , String dependentTable , String dependentColumn);

    /**
     * Finds if the dependency between a lookup table and other table has any value
     * 
     * @param dependentTable
     * @param dependentColumn
     * @param lookupCode
     * @return true if any value exists else false
     */
    // boolean hasDependentValues(String dependentTable , String dependentColumn , String lookupCode);
    boolean hasDependentValues(@Param("dependentTable") String dependentTable, @Param("dependentColumn") String dependentColumn,
            @Param("lookupCode") String lookupCode);

    /**
     * Returns the type of lookup specified by the table name. The returned value is a String . e.g. Lookup , Lookup1 , Lookup2 ... Lookup8
     * 
     * @param tableName
     * @return
     */
    String getLookupType(String tableName);

}
