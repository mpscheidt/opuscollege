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

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.ImageIcon;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author mp
 *
 */
public abstract class ServletUtil {

    private static Logger log = LoggerFactory.getLogger(ServletUtil.class);

	/**
	 * Get the value of the parameter with the given name from the given request.
	 * If the value is not present initialize the value with the given default and
	 * set the value as an attribute in the request.
	 * NB: parameters are always stored as strings,
	 *     whereas attributes can have any object type
	 * @param request HTTP request
	 * @param paramName name of parameter to be get and set 
	 * @param def the default value for paramName if not yet set in the request
	 * @return the value from the request or the default
	 */
	public static int getParamSetAttrAsInt(HttpServletRequest request,
			String paramName,
			int def) {

	    int value = getIntParam(request, paramName, def);
	    request.setAttribute(paramName, value);
		return value;
	}

	public static int getIntParam(HttpServletRequest request,
			String paramName,
			int def) {
	    
	    int value;
	    
		String paramValue = request.getParameter(paramName);
		if (StringUtils.isNumeric(paramValue)) {
	        value = Integer.parseInt(paramValue);
	    } else {
	        value = def;
	    }
	    
		return value;
	}
	
	public static int[] getIntArrayParam(HttpServletRequest request,
            String paramName) {
        String[] paramValues = request.getParameterValues(paramName);
        int[] intValues = null;
        
        if (paramValues != null) {
            intValues = new int[paramValues.length];
            
            for(int i = 0; i < paramValues.length; i++) {
                intValues[i] = Integer.parseInt(paramValues[i]);
            }
        }
        
        return intValues;
    }

    public static int getIntValue(HttpSession session, HttpServletRequest request,
            String propertyName,
            int def) {
        String paramValue = request.getParameter(propertyName);
        if (paramValue != null && !paramValue.isEmpty()) {
            def = Integer.parseInt(paramValue);
        } else {
            Integer sessionValue = (Integer) session.getAttribute(propertyName);
            if (sessionValue != null) {
                def = sessionValue;
            }
        }
        return def;
    }

    public static int getIntValueSetOnSession(HttpSession session,
            HttpServletRequest request, String propertyName, int def) {
        
        int intValue = getIntValue(session, request, propertyName, def); 
        session.setAttribute(propertyName, intValue);
        return intValue;
    }
    
    /**
     * Return object without converting to primitive type.
     * This allows to have null values.
     * @param session
     * @param request
     * @param propertyName
     * @return
     */
    public static Integer getIntObject(HttpSession session, HttpServletRequest request,
            String propertyName) {
        
        Integer value = getIntObject(request, propertyName);
        if (value == null) {
            value = (Integer) session.getAttribute(propertyName);
        }
        return value;
    }

    /**
     * Return object without converting to primitive type.
     * This allows to have null values.
     * @param request
     * @param propertyName
     * @return
     */
    public static Integer getIntObject(HttpServletRequest request,
            String propertyName) {
        
        Integer value = null;
        String paramValue = request.getParameter(propertyName);
        if (paramValue != null && !paramValue.isEmpty()) {
            value = Integer.parseInt(paramValue);
        }
        return value;
    }

    public static boolean getBooleanValue(HttpSession session, HttpServletRequest request,
            String propertyName,
            boolean def) {
        String paramValue = request.getParameter(propertyName);
        if (paramValue != null && !paramValue.isEmpty()) {
            def = Boolean.parseBoolean(paramValue);
        } else {
            Boolean sessionValue = (Boolean) session.getAttribute(propertyName);
            if (sessionValue != null) {
                def = sessionValue;
            }
        }
        return def;
    }

    public static boolean getBooleanParam(HttpServletRequest request,
            String paramName,
            boolean def) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null) {
            def = Boolean.parseBoolean(paramValue);
        }
        
        return def;
    }

	/**
	 * see getParamSetAttrAsInt()
	 */
	public static String getParamSetAttrAsString(HttpServletRequest request,
			String paramName,
			String def) {
		String paramValue = request.getParameter(paramName);
		if (!StringUtil.isNullOrEmpty(paramValue, true)) {
	        def = paramValue;
	    }
	    request.setAttribute(paramName, def);
		return def;
	}
	
    public static boolean getParamSetAttrAsBoolean(HttpServletRequest request,
            String paramName,
            boolean def) {

        boolean b = getBooleanParam(request, paramName, def);
        request.setAttribute(paramName, b);
        return b;
    }
    
	public static String getStringValueSetOnSession(HttpSession session
	            , HttpServletRequest request, String paramName) {
        String stringValue = getStringValue(session, request, paramName); 
        session.setAttribute(paramName, stringValue);
        return stringValue;
	}

    public static String getStringValueSetOnSession(HttpSession session
            , HttpServletRequest request, String paramName, String def) {
        String stringValue = getStringValue(session, request, paramName, def); 
        session.setAttribute(paramName, stringValue);
        return stringValue;
    }

	public static String getStringValue(HttpSession session,
            HttpServletRequest request, String propertyName,
            String def) {
	    
	    String value = getStringValue(session, request, propertyName);
	    if (value == null || value.isEmpty()) {
	        value = def;
	    }
	    return value;
	}
	
	/**
	 * Look for the given String property in request parameters and in session attributes.
	 * @param session
	 * @param request
	 * @param propertyName
	 * @return
	 */
    public static String getStringValue(HttpSession session,
            HttpServletRequest request, String propertyName) {
        String stringValue = "";
        String tmpString = "";
        
        if (request != null && request.getParameter(propertyName) != null) {
            tmpString = request.getParameter(propertyName);
                if (!StringUtil.isNullOrEmpty(tmpString, true)) {
                    stringValue = tmpString;
                }
        } else if (session != null && session.getAttribute(propertyName) != null) {
            stringValue = (String) session.getAttribute(propertyName);
        }
        return stringValue;
    }

    public static int getIntParamSetOnSession(HttpSession session,
            HttpServletRequest request, String paramName) {
        int intValue = 0;
        
        if (request.getParameter(paramName) != null) {
            // request can only store String values, therefore need to convert to int
            intValue = StringUtil.intValue(request.getParameter(paramName));
        } else if (session.getAttribute(paramName) != null) {
            // session can handle objects, therefore we expect a number object
            Object sessionAttr = session.getAttribute(paramName);
            if (sessionAttr instanceof Number) {
                intValue = ((Number) sessionAttr).intValue();
            } else if (sessionAttr instanceof String) {
                intValue = StringUtil.intValue((String)sessionAttr);
            }

        }
        session.setAttribute(paramName, intValue);
        return intValue;
    }

    public static Map<String, String> getImageProperties(byte[] file) {
        Map<String, String> properties = new HashMap<String, String>();

        if (file != null) {
            ImageIcon image = new ImageIcon(file);

            properties.put("width", image.getIconWidth() + "");
            properties.put("height", image.getIconHeight() + "");
            properties.put("size", FileUtils.byteCountToDisplaySize(file.length));
        }

        return properties;
    }

    /**
     * Check if all dependentProperties are set in request or session (i.e. not 0).
     * If one of them is not set, then clear the property from the session and/or request.
     * This is useful to check dependencies between filters, e.g. if institutionId is 0,
     * then studygradetypeId should be empty.
     * @param session
     * @param request
     * @param dependentProperty
     * @param dependentOf
     */
    public static void assertDependentProperties(HttpSession session,
            HttpServletRequest request, String property, String[] dependentProperties) {
        boolean ok = true;
        for (String dependentProperty: dependentProperties) {
            int propValue = getIntValue(session, request, dependentProperty, 0);
            if (propValue == 0) {
                ok = false;
                break;
            }
        }
        if (!ok) {
            session.removeAttribute(property);
            request.removeAttribute(property);
        }
    }

}
