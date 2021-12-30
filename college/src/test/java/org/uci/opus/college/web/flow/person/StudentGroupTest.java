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

package org.uci.opus.college.web.flow.person;


import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectSubjectBlock;


public class StudentGroupTest {

    private static final String CODE_1 = "Code1";
    private static final String CODE_2 = "Code2";
    private static final String DESCRIPTION_1 = "Description 1";
    private static final String DESCRIPTION_2 = "Description 2";

    private Subject subject1;
    private Subject subject2;
    private List<Subject> allSubjects;

    private Subject passedSubject1;
    private List<Subject> passedSubjects;

    private SubjectBlock subjectBlock1;
    private List<SubjectBlock> allSubjectBlocks;

    @Before
    public void setUp() throws Exception {
        subject1 = new Subject();
        subject1.setId(1);
        subject1.setSubjectCode(CODE_1);
        subject1.setSubjectDescription(DESCRIPTION_1);

        subject2 = new Subject();
        subject2.setId(2);
        subject2.setSubjectCode(CODE_2);
        subject2.setSubjectDescription(DESCRIPTION_2);

        allSubjects = new ArrayList<Subject>();
        allSubjects.add(subject1);
        allSubjects.add(subject2);

        // passedSubject1: same code and description as subject1
        passedSubject1 = new Subject();
        passedSubject1.setId(11);
        passedSubject1.setSubjectCode(new String(CODE_1));
        passedSubject1.setSubjectDescription(DESCRIPTION_1);

        passedSubjects = new ArrayList<Subject>();
        passedSubjects.add(passedSubject1);

        subjectBlock1 = new SubjectBlock();
        subjectBlock1.setId(1);

        SubjectSubjectBlock ssb = new SubjectSubjectBlock();
        ssb.setSubjectBlockId(1);
        ssb.setSubject(subject1);

        List<SubjectSubjectBlock> subjectSubjectBlocks = new ArrayList<SubjectSubjectBlock>();
        subjectSubjectBlocks.add(ssb);
        subjectBlock1.setSubjectSubjectBlocks(subjectSubjectBlocks);

        allSubjectBlocks = new ArrayList<SubjectBlock>();
        allSubjectBlocks.add(subjectBlock1);
    }

    @Test
    public void testMe() {
        StudentGroup data = new StudentGroup();
        data.setAllSubjects(allSubjects);
        data.setAllSubjectBlocks(allSubjectBlocks);
        data.setPassedSubjects(passedSubjects);

        assertTrue(data.hasPassed(subject1));
        assertTrue(!data.hasPassed(subject2));

        assertTrue(data.hasPassedAnySubject(subjectBlock1));

        Map<Number, Boolean> map = data.getPassedSubjectMap();
        assertTrue(!map.isEmpty());
        assertTrue(map.get(1));
        assertTrue(!map.containsKey(2));
    }

}
