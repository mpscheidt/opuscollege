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

package org.uci.opus.college.web.util.exam;

import static org.junit.Assert.assertEquals;

import java.util.Collection;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class SubjectResultsBuilderComparatorTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test public void testComparator() {
		Collection<SubjectResultLine> lines = 
			new TreeSet<>(new ResultsBuilderComparator("firstnamesFull"));
		
		SubjectResultLine line1 = new SubjectResultLine();
		line1.setFirstnamesFull("A");
		SubjectResultLine line2 = new SubjectResultLine();
		line2.setFirstnamesFull("B");
		SubjectResultLine line3 = new SubjectResultLine();
		line3.setFirstnamesFull("á");	// should be between A and B
		SubjectResultLine line4 = new SubjectResultLine();
		line4.setFirstnamesFull("A");	// A should appear twice

		lines.add(line4);
		lines.add(line3);
		lines.add(line2);
		lines.add(line1);
        Iterator<SubjectResultLine> it = lines.iterator();
        SubjectResultLine line = it.next();
		assertEquals("A", line.getFirstnamesFull());
        line = it.next();
		assertEquals("A", line.getFirstnamesFull());
        line = it.next();
		assertEquals("á", line.getFirstnamesFull());
        line = it.next();
		assertEquals("B", line.getFirstnamesFull());

	}
	
	@Test public void testSortedSet() {
		SortedSet<SubjectResultLine> set = new TreeSet<>(
				new ResultsBuilderComparator("firstnamesFull"));
		
		SubjectResultLine line1 = new SubjectResultLine();
		line1.setFirstnamesFull("C");
		set.add(line1);
		SubjectResultLine line2 = new SubjectResultLine();
		line2.setFirstnamesFull("B");
		line2.setSurnameFull("Z");
//		line2.setStudyPlanDetailId(1);
		set.add(line2);
		SubjectResultLine line3 = new SubjectResultLine();
		line3.setFirstnamesFull("B");
		line3.setSurnameFull("Z");
//		line3.setStudyPlanDetailId(2);
		set.add(line3);
		SubjectResultLine line4 = new SubjectResultLine();
		line4.setFirstnamesFull("A");
		line4.setSurnameFull("Y");
		set.add(line4);

		assertEquals(4, set.size());
		
		Iterator<SubjectResultLine> it = set.iterator();
		SubjectResultLine line = it.next();
		assertEquals("A", line.getFirstnamesFull());
		assertEquals("Y", line.getSurnameFull());
        line = it.next();
		assertEquals("B", line.getFirstnamesFull());
		assertEquals("Z", line.getSurnameFull());
        line = it.next();
		assertEquals("B", line.getFirstnamesFull());
		assertEquals("Z", line.getSurnameFull());
        line = it.next();
        assertEquals("C", line.getFirstnamesFull());
		
	}


}
