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


import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.uci.opus.college.domain.Lookup;

public class LookupUtilTest {
	
	List<Lookup> lookups;
	Lookup lookup1;
	Lookup lookup2;
	Lookup lookup3;
	

	@BeforeClass
	public static void setUpBeforeClass() {
	}

	@AfterClass
	public static void tearDownAfterClass() {
	}

	@Before
	public void setUp() {
		lookups = new ArrayList<Lookup>(3);
		lookup1 = new Lookup();
		lookup1.setId(2);
		lookup1.setCode("A");
		lookup1.setLang("pt");
		lookup1.setDescription("A");
		lookups.add(lookup1);
		
		lookup2 = new Lookup();
		lookup2.setId(3);
		lookup2.setCode("A");
		lookup2.setLang("de");
		lookup2.setDescription("A");
		lookups.add(lookup2);
		
		lookup3 = new Lookup();
		lookup3.setId(1);
		lookup3.setCode("B");
		lookup3.setLang("pt");
		lookup3.setDescription("B");
		lookups.add(lookup3);
		
	}

	@After
	public void tearDown() {
	}

/*	@Test
	public void testMakeMapByCodeAndLang() {
		Map<CodeAndLang, Lookup> map = lookupUtil.makeCodeAndLangToLookupMap(lookups);
		assertNotNull(map);
		assertEquals(3, map.size());
		Lookup lookup = map.get(new CodeAndLang("A", "pt"));
		assertNotNull(lookup);
		assertEquals(2, lookup.getId());
		
		lookup = map.get(new CodeAndLang("A", "de"));
		assertNotNull(lookup);
		assertEquals(3, lookup.getId());
		
		lookup = map.get(new CodeAndLang("B", "pt"));
		assertNotNull(lookup);
		assertEquals(1, lookup.getId());
	}*/
	
	@Test
	public void testLookupDescriptionComparator() {
		LookupDescriptionComparator comp =
			new LookupDescriptionComparator();
		assertEquals(0, comp.compare(lookup1, lookup2));
		assertTrue(comp.compare(lookup1, lookup3) < 0);
		assertTrue(comp.compare(lookup3, lookup2) > 0);
	}
	
}
