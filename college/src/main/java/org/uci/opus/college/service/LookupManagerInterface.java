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

import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.domain.ILookup;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.util.TimeUnit;
import org.uci.opus.college.util.TimeUnitInYear;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.CodeToTimeUnitMap;

/**
 * Interface for Lookup-related management methods. The Lookups are filled with various general code-listings (country, addresstype, ...).
 * 
 * In org.uci.opus.college.domain there are 6 children of the parent Lookup class: Lookup1 to Lookup8. Together they cover all lookup-tables
 * in the database. All Lookups have a complete code-list for each language supported (e.g. EN, PT, ...) See for a complete list of the
 * lookup-tables (and the lookup1 to lookup8 variations): org.uci.opus.college.data.LookupDao.
 * 
 * @author move
 */
public interface LookupManagerInterface extends AppVersionAccessor {

    /**
     * Default sort order for retrieval of lookup table records.
     */
    public static String DEFAULT_SORT = "lower(description)";

    /**
     * Find a list of lookup objects; e.g. addressTypes, civilTitles etc.
     * 
     * @param preferredLanguage
     *            of user
     * @param tableName
     *            name of table in which to search for the lookup objects
     * @return List of Lookup objects, ordered by <code>description</code>
     */
    <T extends Lookup> List<T> findAllRows(String preferredLanguage, String tableName);

    /**
     * Find a list of lookup objects, with additional parameter for the ORDER BY clause.
     * 
     * @param preferredLanguage
     * @param tableName
     * @param order
     * @return
     */
    <T extends Lookup> List<T> findAllRows(String preferredLanguage, String tableName, String order);

    /**
     * Find a list of lookup objects; e.g. addressTypes, civilTitles etc.
     * 
     * Returned items are ordered by <code>description</code>.
     * 
     * The <code>preferredLanguage</code> may be null to retrieve items in all languages.
     * 
     * @param preferredLanguage
     *            language of choice
     * @param tableName
     *            name of table
     * @param codeName
     *            name of code
     * @param code
     *            code itself
     * @return List of Lookup objects
     */
    <T extends Lookup> List<T> findAllRowsForCode(String preferredLanguage, String tableName, String codeName, String code);

    /**
     * Find a lookup object; e.g. addressTypes, civilTitles etc.
     * 
     * @param language
     *            (optional)
     * @param lookupCode
     *            (optional)
     * @param tableName
     *            name of table in which to search for the lookup object
     * @return Lookup object or one of its variants
     * @see #findLookup(String, Map)
     */
    <T extends ILookup> T findLookup(String language, String lookupCode, String tableName);

    /**
     * Find a single lookup object. Note that an exception is thrown if more than one records match the parameters.
     * 
     * @param tableName
     * @param map
     * @return
     */
    <T extends ILookup> T findLookup(String tableName, Map<String, Object> map);

    /**
     * Utility method that calls {@link #findLookups(String, Map)}.
     * 
     * @param language
     *            (optional)
     * @param lookupCode
     *            (optional)
     * @param lookupDescription
     *            (optional)
     * @param tableName
     * @see #findLookups(String, Map)
     * @return
     */
    <T extends Lookup> List<T> findLookups(String language, String lookupCode, String lookupDescription, String tableName);

    /**
     * Get the lookups in all languages for the given code and table name.
     */
    <T extends ILookup> List<T> findLookupsForCode(String tableName, String lookupCode);

    /**
     * Find lookups for given table and language.
     */
    <T extends Lookup> List<T> findLookups(String language, String tableName);

    /**
     * 
     * @param tableName
     * @param map
     * @return
     */
    <T extends ILookup> List<T> findLookups(String tableName, Map<String, Object> map);

    /**
     * 
     * @param entityName
     * @param entityId
     * @param lookupCode
     * @param tableName
     */
    void deleteLookupFromEntity(String entityName, int entityId, String lookupCode, String tableName);

    /**
     * Finds lookups given a description or part of the description If set to NULL , the preferredLanguage is ignored
     * 
     * @param preferredLanguage
     * @param tableName
     * @param description
     * @return
     */
    <T extends Lookup> List<T> findRowsByDescription(String preferredLanguage, String tableName, String description);

    /**
     * Find the current core module.
     * 
     * @return AppVersion coreModule
     */
    AppVersion getCoreModule();

    /**
     * @see getModuleDbVersion(String moduleString)
     * @param module
     * @return
     */
    double getModuleDbVersion(Module module);

    /**
     * Get the current database version of the given module.
     * 
     * @param moduleString
     * @return 0.0 if no database version is found in the appVersions table.
     */
    double getModuleDbVersion(String moduleString);

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

    /**
     * Gets the max code value from a lookup table
     * 
     * @param tableName
     *            - the name of the table from which extract the code
     * @return a code
     */
    int getNextId(String tableName);

    /**
     * Adds a lookup.
     * 
     * @param tableName
     *            without the 'opuscollege.' schema prefix
     */
    <L extends ILookup> void addLookup(L lookup, String tableName);

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
     * Convenience method for adding a group of lookups
     * 
     * @param <L>
     * @param lookup
     * @param tableName
     * @throws IllegalArgumentException
     * @throws IllegalAccessException
     */
    <L extends Lookup> void addLookups(List<L> lookups, String tableName);

    /**
     * updates a lookup
     * 
     * @param lookup
     * @param tableName
     * @throws IllegalAccessException
     * @throws IllegalArgumentException
     */
    <L extends ILookup> void updateLookup(L lookup, String tableName);

    /**
     * 
     * @param lookups
     * @param tableName
     * @see #updateLookup(Lookup, String)
     */
    <L extends ILookup> void updateLookups(List<L> lookups, String tableName);

    /**
     * Deletes a lookup given a code and language if only the language is null then every lookup with the specified code will be deleted
     * 
     * @param code
     * @param lang
     * @param tableName
     */
    void deleteLookupByCode(String lang, String code, String tableName);

    /**
     * Finds if the dependency between a lookup table and other table has any value
     * 
     * @param dependentTable
     * @param dependentColumn
     * @param lookupCode
     * @return true if any value exists else false
     */
    boolean hasDependentValues(String dependentTable, String dependentColumn, String lookupCode);

    <T extends Lookup> T findLookupById(int id, String tableName);

    /**
     * Gets a type of lookup given its name
     * 
     * @param tableName
     * @return
     */
    public String getLookupType(String tableName);

    /**
     * Get a list of all time units, which is derived from the cardinaltimeunit table, based on the cardinaltimeunit code and nrOfUnits.
     * 
     * @return list of {@link TimeUnit}s
     */
    List<TimeUnitInYear> getAllTimeUnitsInYear(String preferredLanguage);

    /**
     * Get all rows of the specified table and return a CodeToLookupMap made up of these rows.
     * 
     * @param preferredLanguage
     * @param tableName
     * @return
     */
    CodeToLookupMap getCodeToLookupMap(String preferredLanguage, String tableName);

    CodeToTimeUnitMap getCodeToTimeUnitMap(String preferredLanguage);

}
