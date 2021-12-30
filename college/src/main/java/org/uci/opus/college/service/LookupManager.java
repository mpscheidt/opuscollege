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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.domain.ILookup;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.persistence.AppVersionMapper;
import org.uci.opus.college.persistence.LookupMapper;
import org.uci.opus.college.util.TimeUnitInYear;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.CodeToTimeUnitMap;

/**
 * @author move
 * Service class that contains Lookup-related management methods. 
 */
public class LookupManager implements LookupManagerInterface {

	private static Logger log = LoggerFactory.getLogger(LookupManager.class);

    private LookupMapper lookupMapper; 
    private QueryUtilitiesManagerInterface queryUtilitiesManager;
    private SqlSession sqlSession;
    private AppVersionMapper appVersionMapper;

    private Map<String, String> lookupTypeToSuffixMap;

    @Autowired
    public LookupManager(LookupMapper lookupManager, QueryUtilitiesManagerInterface queryUtilitiesDao, SqlSession sqlSession, AppVersionMapper appVersionMapper) {
        this.lookupMapper = lookupManager;
        this.queryUtilitiesManager = queryUtilitiesDao;
        this.sqlSession = sqlSession;
        this.appVersionMapper = appVersionMapper;
        
        this.lookupTypeToSuffixMap = new HashMap<>();
        this.lookupTypeToSuffixMap.put("Lookup", "");
        this.lookupTypeToSuffixMap.put("Lookup1", "1");
        this.lookupTypeToSuffixMap.put("Lookup2", "2");
        this.lookupTypeToSuffixMap.put("Lookup3", "3");
        this.lookupTypeToSuffixMap.put("Lookup4", "4");
        this.lookupTypeToSuffixMap.put("Lookup5", "5");
        this.lookupTypeToSuffixMap.put("Lookup6", "6");
        this.lookupTypeToSuffixMap.put("Lookup7", "7");
        this.lookupTypeToSuffixMap.put("Lookup8", "8");
        this.lookupTypeToSuffixMap.put("Lookup9", "9");
        this.lookupTypeToSuffixMap.put("Lookup10", "10");
    }

    @Override
    public <T extends Lookup> List<T> findAllRows(final String preferredLanguage, final String tableName) {
        return this.findAllRows(preferredLanguage, tableName, DEFAULT_SORT);
    }

    @Override
    public <T extends Lookup> List<T> findAllRows(String preferredLanguage, String tableName, String order) {
        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_LANG, preferredLanguage);
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        map.put("order", order);
        
        // For Lookup1 ... Lookup9 add the digit (1..9) to the sqlMap, e.g. findAllRows2 for Lookup2
        String sqlMap = LookupMapper.class.getName() + ".findAllRows" + getSuffixForTable(tableName);

        return sqlSession.selectList(sqlMap, map);
    }

    /**
     * Determine the suffix for the given lookup type
     * @param sqlMap
     * @param lookupType
     * @return suffix or "" if no suffix found
     */
    private String getSuffix(String lookupType) {
        String suffix = this.lookupTypeToSuffixMap.get(lookupType);
        return suffix != null ? suffix : "";
    }
    
    /**
     * Get suffix given the table name.
     * @param tableName
     * @return
     */
    private String getSuffixForTable(String tableName) {
        String lookupType = getLookupType(tableName);
        return getSuffix(lookupType);
    }

    @Override
    public <T extends Lookup> List<T> findAllRowsForCode(final String preferredLanguage, final String tableName, final String codeName, final String code) {

        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_LANG, preferredLanguage);
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        map.put("codeName", codeName);
        map.put(LookupMapper.KEY_CODE, code);

        String sqlMap = LookupMapper.class.getName() + ".findAllRowsForCode" + getSuffixForTable(tableName);

        return sqlSession.selectList(sqlMap, map);
    }

    @Override
    public <T extends Lookup> List<T> findRowsByDescription(String preferredLanguage, String tableName, String description) {

        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_LANG, preferredLanguage);
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        map.put(LookupMapper.KEY_DESCRIPTION, description);
        
        String statement = LookupMapper.class.getName() + ".findRowsByDescription" + getSuffixForTable(tableName);
        return sqlSession.selectList(statement, map);
    }
    
    @Override
    public <T extends ILookup> T findLookup(final String language, final String lookupCode, final String tableName) {

        Map<String,Object> map = new HashMap<>();

        map.put(LookupMapper.KEY_LANG, language);
        map.put(LookupMapper.KEY_CODE, lookupCode);

        return this.findLookup(tableName, map);
    }

    @Override
    public <T extends ILookup> T findLookup(String tableName, Map<String, Object> map) {
        
        String statement = prepareFindLookupMapAndStatement(tableName, map);
        return sqlSession.selectOne(statement, map);
    }

    /**
     * Put tableName into map and return the findLookup statement for the given tableName.
     * @param tableName
     * @param map
     * @return
     */
    private String prepareFindLookupMapAndStatement(String tableName, Map<String, Object> map) {
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        return LookupMapper.class.getName() + ".findLookup" + getSuffixForTable(tableName);
    }

    @Override
    public <T extends ILookup> List<T> findLookups(String tableName, Map<String, Object> map) {
        String statement = prepareFindLookupMapAndStatement(tableName, map);
        return sqlSession.selectList(statement, map);
    }

    @Override
    public <T extends Lookup> List<T> findLookups(String language, String lookupCode, String lookupDescription, String tableName) {
        Map<String,Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_LANG, language);
        map.put(LookupMapper.KEY_CODE, lookupCode);
        map.put(LookupMapper.KEY_DESCRIPTION, lookupDescription);
        return this.findLookups(tableName, map);
    }

    @Override
    public <T extends ILookup> List<T> findLookupsForCode(String tableName, String lookupCode) {
        Map<String,Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_CODE, lookupCode);
        return this.findLookups(tableName, map);
    }

    @Override
    public <T extends Lookup> List<T> findLookups(String language, String tableName) {
        Map<String,Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_LANG, language);
        return this.findLookups(tableName, map);
    }

    @Override
    public void deleteLookupFromEntity(final String entityName, final int entityId, final String lookupCode, final String tableName) {
       lookupMapper.deleteLookupFromEntity(entityName, entityId, lookupCode, tableName);
    }

    @Override
    public AppVersion getCoreModule() {
        return appVersionMapper.getCoreModule();
	}

    @Override
 	public List < AppVersion > getAppVersions() {
        return appVersionMapper.getAppVersions();
	}

 	@Override
    public AppVersion getAppVersion(String module) {
        return appVersionMapper.getAppVersion(module);
    }
 	
 	@Override
 	public void add(AppVersion appVersion) {
 	   appVersionMapper.add(appVersion);
 	}

    @Override
    public void update(AppVersion appVersion) {
        appVersionMapper.update(appVersion);
    }

    @Override
    public double getModuleDbVersion(Module module) {
        String moduleString = module.getModule();
        return getModuleDbVersion(moduleString);
    }

    @Override
    public double getModuleDbVersion(String moduleString) {
        AppVersion appVersion = getAppVersion(moduleString);
        double version = (appVersion == null) ? 0.0 : appVersion.getDbVersion();
        return version;
    }

    @Override
 	public int getNextId(String tableName) {
 		
        Integer intCode = lookupMapper.getNextId(tableName);
        //when there are no entries then there will be no code so it may return null
        //in this case use default value
        return intCode != null ? intCode.intValue() : 0;
	}

    @Override
    public List<LookupTable> findAllLookupTables() {
        
        return lookupMapper.findAllLookupTables();
    }
    
    @Override
    public List<LookupTable> findLookupTablesByName(String tableName) {
        return lookupMapper.findLookupTablesByName(tableName);
    }

    @Override
    public LookupTable findLookupTableByName(String tableName) {
        return lookupMapper.findLookupTableByName(tableName);
    }
    
    @Override
	public <T extends ILookup> void addLookup(T lookup , String tableName) {
        
        log.info("adding " + tableName + ": " + lookup);

        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        map.put("lookup", lookup);

        String statement = LookupMapper.class.getName() + ".addLookup" + getSuffixForTable(tableName);
        sqlSession.insert(statement, map);
	}
	
    @Override
    public <L extends Lookup> void addLookups(List<L> lookups, String tableName) {
        
        for (L lookup : lookups) {
            this.addLookup(lookup, tableName);
        }
        
    };
    
    @Override
    public <L extends Lookup> String addLookupSet(List<L> lookups, String tableName) {

        String code = getNextId(tableName) + "";
        
        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_TABLENAME, tableName);        
        
        for (int i = 0; i < lookups.size(); i++) {
            lookups.get(i).setCode(code);
            map.put("lookup",lookups.get(i));
            String statement = LookupMapper.class.getName() + ".addLookup" + getSuffixForTable(tableName);
            sqlSession.insert(statement, map);
        }       
        
        return code;
	}
	
    @Override
    public <T extends ILookup> void updateLookup(T lookup , String tableName) {

        log.info("updating " + tableName + ": " + lookup);

        Map<String, Object> map = new HashMap<>();
        map.put(LookupMapper.KEY_TABLENAME, tableName);
        map.put("lookup", lookup);

        String statement = LookupMapper.class.getName() + ".updateLookup" + getSuffixForTable(tableName);
        sqlSession.insert(statement, map);
    }

    @Override
	public <L extends ILookup> void updateLookups(List<L> lookups, String tableName) {
        
        for(L lookup: lookups) {
            this.updateLookup(lookup, tableName);
        }
    }
	
    @Override
	public void deleteLookupByCode(String lang , String code ,String tableName) {
        
        log.info("deleting lookup with code '" + code + "' and lang '" + lang + "' from table " + tableName);

        lookupMapper.deleteLookupByCode(lang, code , tableName);
		
	}
	
	/**
	 * Gets a type of lookup given its name
	 * @param tableName
	 * @return
	 */
    @Override
	public String getLookupType(String tableName){
		
		return findLookupTableByName(tableName).getLookupType();
	}

    @Override
    public boolean hasDependentValues(String dependentTable, String dependentColumn, String lookupCode) {
		
		 if(queryUtilitiesManager.existsTable(dependentTable)){
			 return lookupMapper.hasDependentValues(dependentTable, dependentColumn , lookupCode);
		 } else {
			 return false;
		 }
		
	}

    @Override
    public  <T extends Lookup> T  findLookupById(int id, String tableName) {
        
        Map<String,Object> params = new HashMap<>();
        
        params.put("id", id);
        params.put(LookupMapper.KEY_TABLENAME, tableName);

        return this.findLookup(tableName, params);
    }

    @Override
    public List<TimeUnitInYear> getAllTimeUnitsInYear(String preferredLanguage) {
        List<TimeUnitInYear> timeUnits = new ArrayList<>();

        List<Lookup8> allCardinalTimeUnits = findAllRows(preferredLanguage, "cardinalTimeUnit");
        if (allCardinalTimeUnits != null) {
            for (Lookup8 cardinalTimeUnit : allCardinalTimeUnits) {
                for (int i = 1; i <= cardinalTimeUnit.getNrOfUnitsPerYear(); i++) {
                    TimeUnitInYear timeUnit = new TimeUnitInYear(cardinalTimeUnit, i);
                    timeUnits.add(timeUnit);
                }
            }
        }

        return timeUnits;
    }

    @Override
    public CodeToLookupMap getCodeToLookupMap(String preferredLanguage, String tableName) {
        List<Lookup8> allCardinalTimeUnits = findAllRows(preferredLanguage, tableName);
        return new CodeToLookupMap(allCardinalTimeUnits);
    }

    @Override
    public CodeToTimeUnitMap getCodeToTimeUnitMap(String preferredLanguage) {
        List<TimeUnitInYear> allTimeUnits = getAllTimeUnitsInYear(preferredLanguage);
        return new CodeToTimeUnitMap(allTimeUnits);
    }

}
