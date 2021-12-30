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



import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mock.web.MockHttpServletRequest;

/**
 * @author mp
 *
 */
public class ServletUtilTest {

	private static Logger log = LoggerFactory.getLogger(ServletUtilTest.class);
	
	/**
	 * @throws java.lang.Exception
	 */
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
	}
	
	@Test public void getParamSetAttrAsInt_noParamValue() {
		MockHttpServletRequest request = new MockHttpServletRequest();
		String param = "dummyparam";
		int def = 0;
		assertNull(request.getParameter(param));
		int i = ServletUtil.getParamSetAttrAsInt(request, param, def);
		assertTrue(def == i);
		assertEquals(new Integer(def), request.getAttribute(param));
	}

	@Test public void getParamSetAttrAsInt_paramValue() {
		MockHttpServletRequest request = new MockHttpServletRequest();
		String param = "dummyparam";
		int value = 7;
		int def = 0;
		request.setParameter(param, Integer.toString(value));
		int i = ServletUtil.getParamSetAttrAsInt(request, param, def);
		assertTrue(value == i);
		assertEquals(new Integer(value), request.getAttribute(param));
	}

	@Test public void getParamSetAttrAsInt_paramValueSpace() {
		MockHttpServletRequest request = new MockHttpServletRequest();
		String param = "dummyparam";
		int def = 0;
		request.setParameter(param, " ");
		int i = ServletUtil.getParamSetAttrAsInt(request, param, def);
		assertTrue(def == i);
		assertEquals(new Integer(def), request.getAttribute(param));
	}

	@Test public void getParamSetAttrAsString_noParamValue() {
		MockHttpServletRequest request = new MockHttpServletRequest();
		String param = "dummyparam";
		String def = "a";
		assertNull(request.getParameter(param));
		String ret = ServletUtil.getParamSetAttrAsString(request, param, def);
		assertEquals(def, ret);
		assertEquals(def, request.getAttribute(param));
	}

	@Test public void getParamSetAttrAsString_paramValue() {
		MockHttpServletRequest request = new MockHttpServletRequest();
		String param = "dummyparam";
		String value = "myval";
		String def = "a";
		request.setParameter(param, value);
		String ret = ServletUtil.getParamSetAttrAsString(request, param, def);
		assertEquals(value, ret);
		assertEquals(value, request.getAttribute(param));
	}

}
