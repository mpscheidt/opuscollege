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

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;

public class DomainObjectMapCreator {

    public static <T> Map<Number, T> makePropertyToObjectMap(List<T> domainObjects, String keyName) {
        if (domainObjects == null) return new HashMap<>(0);

        Map<Number, T> map = new HashMap<>(domainObjects.size());
        for (T object : domainObjects) {
            Number id;
            try {
                id = (Number) PropertyUtils.getSimpleProperty(object, keyName);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            map.put(id, object);
        }
        return map;
    }

    public static <T> Map<String, T> makePropertiesToObjectMap(List<T> domainObjects, String keyName1, String separator, String keyName2) {
        if (domainObjects == null) return new HashMap<String, T>(0);

        Map<String, T> map = new HashMap<>(domainObjects.size());
        for (T object : domainObjects) {
            Object value1;
            Object value2;
            try {
                value1 = (Number) PropertyUtils.getSimpleProperty(object, keyName1);
                value2 = (Number) PropertyUtils.getSimpleProperty(object, keyName2);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            map.put(value1 + separator + value2, object);
        }
        return map;
    }

    public static <T> Map<String, T> makePropertiesToObjectMap(List<T> domainObjects, String keyName1, String separator1, String keyName2, String separator2, String keyName3) {
        if (domainObjects == null) return new HashMap<String, T>(0);

        Map<String, T> map = new HashMap<>(domainObjects.size());
        for (T object : domainObjects) {
            Object value1;
            Object value2;
            Object value3;
            try {
                value1 = (Number) PropertyUtils.getSimpleProperty(object, keyName1);
                value2 = (Number) PropertyUtils.getSimpleProperty(object, keyName2);
                value3 = (Number) PropertyUtils.getSimpleProperty(object, keyName3);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            map.put(value1 + separator1 + value2 + separator2 + value3, object);
        }
        return map;
    }
    
    public static <T> Map<?, List<T>> makePropertyToListMap(List<T> domainObjects, String propertyName) {
        Map<Object, List<T>> map = new HashMap<Object, List<T>>();
        
        for (T object : domainObjects) {
            Object propertyValue;
            try {
                propertyValue = (Number) PropertyUtils.getSimpleProperty(object, propertyName);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            List<T> list = map.get(propertyValue);
            if (list == null) {
                list = new ArrayList<T>();
                map.put(propertyValue, list);
            }
            list.add(object);
        }
        
        return map;
    }

    /**
     * Create a map: key = "id", value = the domain object.
     * It is expected that each given domain object has an "id" property.
     * @param domainObjects
     * @return
     * @throws NoSuchMethodException 
     * @throws InvocationTargetException 
     * @throws IllegalAccessException 
     */
    public static <T> Map<Number, T> makeIdToObjectMap(List<T> domainObjects) {
        return makePropertyToObjectMap(domainObjects, "id");
    }

    public static Map<Number, String> makeIdToDescriptionMap(List<?> domainObjects) {
        return makeIdToDescriptionMap(domainObjects, "description");
    }

    public static Map<Number, String> makeIdToDescriptionMap(List<?> domainObjects, String descriptionColum) {
        if (domainObjects == null) return new HashMap<Number, String>(0);

        Map<Number, String> map = new HashMap<Number, String>(domainObjects.size());
        for (Object object : domainObjects) {
            Number id;
            String description;
            try {
                id = (Number) PropertyUtils.getSimpleProperty(object, "id");
                description = (String) PropertyUtils.getSimpleProperty(object, descriptionColum);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            map.put(id, description);
        }
        return map;
    }

}
