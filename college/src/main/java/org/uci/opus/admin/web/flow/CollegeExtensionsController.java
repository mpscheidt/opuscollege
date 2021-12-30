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
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.admin.web.flow;

import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;

@Controller
@RequestMapping(value="/college/collegeextensions.view")
public class CollegeExtensionsController {

    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    
    @Autowired private List<IExtensionCollection> extensionCollections;
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        model.addAttribute("collegeServiceExtensions", collegeServiceExtensions);
        
        Map<IExtensionCollection, Collection<Map<String, Object>>> extensionCollectionToFields = new HashMap<IExtensionCollection, Collection<Map<String, Object>>>();
        model.put("extensionCollectionToFields", extensionCollectionToFields);
        
        for (IExtensionCollection extensionCollection : extensionCollections) {
//            extensionCollection.getExtensions();
            Collection<Map<String, Object>> fields = getFields(extensionCollection);
            extensionCollectionToFields.put(extensionCollection, fields);
        }
        
        return "admin/collegeExtensions";
    }

    public Collection<Map<String, Object>> getFields(IExtensionCollection extensionCollection) {
        List<Map<String, Object>> fields = new ArrayList<Map<String, Object>>();
        for (Field field : extensionCollection.getExtensions()) {
            String propertyName = field.getName();
            if ("log".equalsIgnoreCase(propertyName))
                continue;

            Object value = null;
            Type type = null;
            field.setAccessible(true);
            try {
                value = field.get(extensionCollection);
                type = field.getGenericType();
            } catch (IllegalArgumentException e) {
                throw new RuntimeException(e);
            } catch (IllegalAccessException e) {
                throw new RuntimeException(e);
            }

            if (type.toString().contains(ExtensionPointUtil.class.getName()))
                continue;

            Map<String, Object> fieldMap = new HashMap<String, Object>();
            fields.add(fieldMap);
            fieldMap.put("fieldName", propertyName);
            
            fieldMap.put("fieldValue", value);
            fieldMap.put("fieldType", type);
//            log.debug("propertyName = " + propertyName
//                    + ": type " + type + "; value = " + value);
        }

        return fields;
    }


}
