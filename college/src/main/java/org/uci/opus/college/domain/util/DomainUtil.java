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
import java.util.Collection;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

public abstract class DomainUtil {

    /**
     * Extract the ids from the given domain objects and return as a list.
     * This method calls {@link DomainUtil#getIntProperties(Collection, String)} with property = "id".
     * @param domainObjects
     * @return
     */
    public static List<Integer> getIds(Collection<?> domainObjects) {
        if (domainObjects == null) { return new ArrayList<Integer>(0); }
        return getIntProperties(domainObjects, "id");
    }

    /**
     * This method calls {@link DomainUtil#getProperties(Collection, String)}.
     * @param domainObjects
     * @param property
     * @return
     */
    public static List<Integer> getIntProperties(Collection<?> domainObjects, String property) {
        List<Integer> properties = getProperties(domainObjects, property);
        return properties;
    }

    /**
     * This method calls {@link DomainUtil#getProperties(Collection, String)}.
     * @param domainObjects
     * @param property
     * @return
     */
    public static List<String> getStringProperties(Collection<?> domainObjects, String property) {
        List<String> properties = getProperties(domainObjects, property);
        return properties;
    }

    /**
     * Return a list with the properties of the given list with the given name.
     * This methods never returns null; an empty list is returned in case no results are found or the given <code>domainObjects</code> collection is null.
     * @param domainObjects
     * @param property
     * @return
     */
    public static <T> List<T> getProperties(Collection<?> domainObjects, String property) {
        if (domainObjects == null) { return new ArrayList<>(0); }
        List<T> values = new ArrayList<>(domainObjects.size());
        for (Object object : domainObjects) {
            T value;
            try {
                value = (T) PropertyUtils.getSimpleProperty(object, property);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            values.add(value);
        }
        return values;
    }
    
    /**
     * Similar to {@link #getProperties(Collection, String)}, but the properties are of type {@link Collection}. 
     * The collections are merged into one {@link List} by using {@link List#addAll(Collection)}.
     * 
     * @param domainObjects
     * @param property
     * @return
     */
    public static <T> List<T> getMergedCollectionProperties(Collection<?> domainObjects, String property) {
        if (domainObjects == null) { return new ArrayList<>(0); }
        List<T> mergedValues = new ArrayList<>();
        for (Object object : domainObjects) {
            Collection<T> col;
            try {
                col = (Collection<T>) PropertyUtils.getSimpleProperty(object, property);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            mergedValues.addAll(col);
        }
        return mergedValues;
    }
    
    /**
     * Get the domain object with the given id from the given list of domain objects.
     * @param allDomainObjects
     * @param id
     * @return
     */
    public static <T> T getDomainObjectById(
            List<T> allDomainObjects, int id) {
        T foundObject = null;
        if (allDomainObjects != null && id != 0) {
            for (T domainObject: allDomainObjects) {
                int objectId;
                try {
                    objectId = (Integer) PropertyUtils.getSimpleProperty(domainObject, "id");
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                if (id == objectId) {
                    foundObject = domainObject;
                    break;
                }
            }
        }
        return foundObject;
    }

    /**
     * Get the domain object with the given property from the given list of domain objects.
     * @param allObjects
     * @param id
     * @return
     */
    public static <T> T getObjectByPropertyValue(List<T> allObjects, String propertyName, Object propertyValue) {
        T foundObject = null;
        if (allObjects != null && propertyValue != null) {
            for (T domainObject: allObjects) {
                Object objectValue;
                try {
                    objectValue = PropertyUtils.getSimpleProperty(domainObject, propertyName);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                if (propertyValue.equals(objectValue)) {
                    foundObject = domainObject;
                    break;
                }
            }
        }
        return foundObject;
    }

}
