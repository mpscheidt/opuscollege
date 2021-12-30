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

package org.uci.opus.util.lookup;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.util.TimeUnit;

@Component
public class LookupUtil {

    @Autowired private MessageSource messageSource;

	/** 
	 * Create a map for quicker searching of Lookup objects by code and language.
	 * @param lookups
	 * @return
	 */
/*  public Map<CodeAndLang, Lookup> makeCodeAndLangToLookupMap(List<? extends Lookup> lookups) {
		assert lookups != null;
		Map<CodeAndLang, Lookup> map = new HashMap<CodeAndLang, Lookup>(lookups.size());
		for (Lookup lookup : lookups) {
			map.put(new CodeAndLang(lookup.getCode(), lookup.getLang()), lookup);
		}
		return map;
	}*/
	
    /** 
     * Create a map: key = code, value = lookup, 
     * given that all lookups are of the same language.
     * @param lookups
     * @return map, indexed by code
     */
    public static <T extends Lookup> Map<String, T> makeCodeToLookupMap(List<T> lookups) {
        assert lookups != null;
        Map<String, T> map = new HashMap<>(lookups.size());
        for (T lookup : lookups) {
            map.put(lookup.getCode(), lookup);
        }
        return map;
    }

    /**
     * Same as {@link #makeCodeToLookupMap(List)}, but for EndGrades instead of Lookups.
     * @param endGrades
     * @return
     */
    public static Map<String, EndGrade> makeCodeToEndGradeMap(List<? extends EndGrade> endGrades) {
        assert endGrades != null;
        Map<String, EndGrade> map = new HashMap<String, EndGrade>(endGrades.size());
        for (EndGrade endGrade : endGrades) {
            map.put(endGrade.getCode(), endGrade);
        }
        return map;
    }

    /**
     * Make a map endGradeTypeCode -> list of endGrades.
     * @param endGrades
     * @return
     */
    public static Map<String, List<EndGrade>> makeEndGradeTypeCodeToEndGradesMap(List<? extends EndGrade> endGrades) {
        assert endGrades != null;
        Map<String, List<EndGrade>> map = new HashMap<String, List<EndGrade>>();
        for (EndGrade endGrade : endGrades) {
            String endGradeTypeCode = endGrade.getEndGradeTypeCode();
            List<EndGrade> endGradesPerGradeType = map.get(endGradeTypeCode);
            if (endGradesPerGradeType == null) {
                endGradesPerGradeType = new ArrayList<>();
                map.put(endGradeTypeCode, endGradesPerGradeType);
            }
            endGradesPerGradeType.add(endGrade);
        }
        return map;
    }

    /** 
     * Create a map: key = code, value = description
     * given that all lookups are of the same language.
     * This method is useful if only the description is needed 
     * rather than other fields of the lookup object.
     * @param lookups
     * @return map, indexed by code
     */
    public static Map<String, String> makeCodeToDescriptionMap(List<? extends Lookup> lookups) {
        assert lookups != null;
        Map<String, String> map = new HashMap<>(lookups.size());
        for (Lookup lookup : lookups) {
            map.put(lookup.getCode(), lookup.getDescription());
        }
        return map;
    }
 
    /**
     * Retrieves list of lookups from request (e.g. allGradeTypes),
     * then creates a map (code -> description),
     * and finally sets the map on the request as an attribute with the name given in mapName.
     * @param request
     * @param lookupsName
     * @param mapName the name of the request attribute under which the map will be set
     * @return the created map
     */
    public static Map<String, String> putCodeToDescriptionMap(HttpServletRequest request, String lookupsName, String mapName) {
        List<? extends Lookup> lookups = (List<? extends Lookup>) request.getAttribute(lookupsName);
        Map<String, String> map = makeCodeToDescriptionMap(lookups);
        request.setAttribute(mapName, map);
        return map;
    }

    public static Map<String, TimeUnit> makeCodeToTimeUnitMap(List<? extends TimeUnit> timeUnits) {
        Map<String, TimeUnit> map = new HashMap<String, TimeUnit>(timeUnits.size());
        if (timeUnits != null) {
            for (TimeUnit timeUnit : timeUnits) {
                map.put(TimeUnit.makeCode(timeUnit.getCardinalTimeUnit().getCode(), timeUnit.getCardinalTimeUnitNumber()), timeUnit);
            }
        }
        return map;
    }
    
    /**
     * Create a subset of lookup objects with only those that have the given codes.
     * @param lookups
     * @param codes
     * @return
     */
    public static <T extends Lookup> List<T> getSubSet(List<T> lookups, Collection<String> codes) {
        List<T> subset = new ArrayList<>();
        if (lookups != null) {
            for (T lookup: lookups) {
                for (String code: codes) {
                    if (code.equals(lookup.getCode())) {
                        subset.add(lookup);
                    }
                }
            }
        }
        return subset;
    }
    
    /**
     * Find the lookup object with the given key.
     * @param lookups
     * @param code
     * @return null in case no lookup is found
     */
    public static <T extends Lookup> T getLookupByCode(List<T> lookups, String code) {
        T result = null;
        if (lookups != null) {
            for (T lookup: lookups) {
                if (code.equals(lookup.getCode())) {
                    result = lookup;
                    break;
                }
            }
        }
        return result;
    }

    /**
     * Remove the lookup with the given code from the list of lookups.
     * @param lookups
     * @param code
     */
    public static void removeByCode(List<? extends Lookup> lookups, String code) {

        for (Lookup lookup: lookups) {
            if (code.equals(lookup.getCode())) {
                lookups.remove(lookup);
                break;
            }
        }
        
    }

    /**
     * Put first letter of each lookup's description into upper case.
     * @param lookups
     */
    public static <T extends Lookup> void capitalize(List<T> lookups) {
        if (lookups == null) {
            return;
        }

        for (T lookup : lookups) {
            lookup.setDescription(StringUtils.capitalize(lookup.getDescription()));
        }

    }
    
    public Lookup getLookupWithMessage(HttpServletRequest request, String message) {
        Lookup lookup = new Lookup();
        lookup.setCode("0");
        lookup.setDescription(messageSource.getMessage(message, null, RequestContextUtils.getLocale(request)));
        return lookup;
    }
    
    public Lookup getLookupCalledAny(HttpServletRequest request) {
        Lookup any = getLookupWithMessage(request, "jsp.general.any");
        return any;
    }
    
}
