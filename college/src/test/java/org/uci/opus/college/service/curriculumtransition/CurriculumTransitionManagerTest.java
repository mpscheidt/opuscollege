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

package org.uci.opus.college.service.curriculumtransition;

import java.util.ArrayList;
import java.util.List;

import org.dbunit.Assertion;
import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectBlockCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectCT;
import org.uci.opus.college.web.flow.study.CurriculumTransitionData;

/*
 * Note: To run this test in Eclipse:
 * - Run Ant build so that sqlmaps are available and up-to-date in the opus project
 * - add to classpath (see Run configurations...): opus/src/main/webapp/WEB-INF/classes
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml"
    })
public class CurriculumTransitionManagerTest extends OpusDBTestCase {
    private static final Logger LOG = LoggerFactory.getLogger(CurriculumTransitionManagerTest.class);

    @Autowired
    private CurriculumTransitionManagerInterface ctManager;

    private List<StudyGradeTypeCT> studyGradeTypes;
    private List<SubjectCT> subjects;
    private List<SubjectBlockCT> subjectBlocks;

    @Override
    protected IDataSet getDataSet() throws Exception {

        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/college/service/curriculumtransition/prepData.xml");
        return dataSet;
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.branch"),
                new DefaultTable("opuscollege.appconfig"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.branchacademicyeartimeunit"),
                new DefaultTable("opuscollege.studyplan"),
                new DefaultTable("opuscollege.studyplancardinaltimeunit"),
                new DefaultTable("opuscollege.studyplandetail")
//                new DefaultTable("opuscollege.acc_studentaccommodation"),
//                new DefaultTable("opuscollege.sch_student"),
//                new DefaultTable("opuscollege.sch_scholarshipapplication"),
//                new DefaultTable("opuscollege.sch_sponsor"),
//                new DefaultTable("opuscollege.sch_scholarship"),
//                new DefaultTable("opuscollege.sch_scholarshipfeepercentage")
        });
        return dataSetToTruncate;
    }

    @Before
    public void setUp() throws Exception {
        LOG.info("Setting up...");

        // -- setup other data structures
        // -- StudyGradeTypes
        StudyGradeTypeCT studyGradeType1 = new StudyGradeTypeCT();
        studyGradeType1.setOriginalId(58);
        studyGradeType1.setStudyId(38);
        studyGradeType1.setGradeTypeCode("4");
        studyGradeType1.setTargetExists(false);
        studyGradeType1.setHasAssociatedSubjects(false);

        StudyGradeTypeCT studyGradeType2 = new StudyGradeTypeCT();
        studyGradeType2.setOriginalId(158);
        studyGradeType2.setStudyId(38);
        studyGradeType2.setGradeTypeCode("3");
        studyGradeType2.setTargetExists(false);
        studyGradeType2.setHasAssociatedSubjects(false);

        studyGradeTypes = new ArrayList<>();
        studyGradeTypes.add(studyGradeType1);
        studyGradeTypes.add(studyGradeType2);

        // -- Subjects
        SubjectCT subject1 = new SubjectCT();
        subject1.setOriginalId(3240);

        SubjectCT subject2 = new SubjectCT();
        subject2.setOriginalId(3242);

        SubjectCT subject3 = new SubjectCT();
        subject3.setOriginalId(3246);

        subjects = new ArrayList<>(3);
        subjects.add(subject1);
        subjects.add(subject2);
        subjects.add(subject3);

        // -- Subject blocks
        SubjectBlockCT subjectBlock570;
        subjectBlock570 = new SubjectBlockCT();
        subjectBlock570.setOriginalId(1);

        SubjectBlockCT subjectBlock572;
        subjectBlock572 = new SubjectBlockCT();
        subjectBlock572.setOriginalId(2);
        
        subjectBlocks = new ArrayList<>();
        subjectBlocks.add(subjectBlock570);
        subjectBlocks.add(subjectBlock572);

        
    }
    
    @Test
    public void testIntegrityOfPrepData() throws Exception {
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/college/service/curriculumtransition/prepData.xml");

        ITable actualTable = databaseDataSet.getTable("opuscollege.subject");
        ITable expectedTable = expectedDataSet.getTable("opuscollege.subject");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.subjectteacher");
        expectedTable = expectedDataSet.getTable("opuscollege.subjectteacher");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.studygradetype");
        expectedTable = expectedDataSet.getTable("opuscollege.studygradetype");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.cardinaltimeunitstudygradetype");
        expectedTable = expectedDataSet.getTable("opuscollege.cardinaltimeunitstudygradetype");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.studygradetypeprerequisite");
        expectedTable = expectedDataSet.getTable("opuscollege.studygradetypeprerequisite");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.classgroup");
        expectedTable = expectedDataSet.getTable("opuscollege.classgroup");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.secondaryschoolsubjectgroup");
        expectedTable = expectedDataSet.getTable("opuscollege.secondaryschoolsubjectgroup");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.groupedsecondaryschoolsubject");
        expectedTable = expectedDataSet.getTable("opuscollege.groupedsecondaryschoolsubject");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.subjectstudygradetype");
        expectedTable = expectedDataSet.getTable("opuscollege.subjectstudygradetype");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.subjectblock");
        expectedTable = expectedDataSet.getTable("opuscollege.subjectblock");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.subjectblockstudygradetype");
        expectedTable = expectedDataSet.getTable("opuscollege.subjectblockstudygradetype");
        Assertion.assertEquals(expectedTable, actualTable);
    }

    @Test
    public void testLoadData() throws Exception {
        
        // 44 = 2009, 48 = 2010
        CurriculumTransitionData data = ctManager.loadCurriculumTransitionData(44, 48, null);
        assertEquals(2, data.getStudyGradeTypes().size());
        assertEquals(2, data.getEligibleStudyGradeTypeCount());
        assertEquals(3, data.getSubjects().size());
        assertEquals(3, data.getEligibleSubjectCount());
        assertEquals(2, data.getSubjectBlocks().size());
        assertEquals(2, data.getEligibleSubjectBlockCount());

        // verify links between items
//        assertEquals(3, data.getStudyGradeTypes().get(58).getSubjects().size());
//        assertEquals(2, data.getSubjectBlock(1).getSubjects().size());
//        assertEquals(2, data.getSubjectBlock(2).getSubjects().size());
    }

    @Test
    public void testTransferEmptyStudyGradeTypes() throws Exception {
        // check that empty subjects do not lead to exceptions
        ctManager.transferStudyGradeTypes(null, 0);
        ctManager.transferStudyGradeTypes(new ArrayList<StudyGradeTypeCT>(), 0);
    }

    @Test
    public void testTransferStudyGradeType() throws Exception {

        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);
        assertTrue(0 != studyGradeTypes.get(0).getNewId());
        assertTrue(0 != studyGradeTypes.get(1).getNewId());
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/service/curriculumtransition/postData.xml");

        ITable actualStudygradeTypeTable = databaseDataSet.getTable("opuscollege.studygradetype");
        ITable expectedStudyGradeTypeTable = expectedDataSet.getTable("opuscollege.studygradetype");
        Assertion.assertEqualsIgnoreCols(expectedStudyGradeTypeTable, 
                actualStudygradeTypeTable,
                new String[] {"id", "writewhen", "writewho"});
        
        // there are now duplicated study grade types
        assertEquals(4, actualStudygradeTypeTable.getRowCount());
        assertNotNull(actualStudygradeTypeTable.getValue(2, "id"));
        assertNotNull(actualStudygradeTypeTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualStudygradeTypeTable.getValue(2, "id"));
        assertTrue(0 != (Integer) actualStudygradeTypeTable.getValue(3, "id"));
        assertTrue((Integer) actualStudygradeTypeTable.getValue(2, "id") == studyGradeTypes.get(0).getNewId()
                || (Integer) actualStudygradeTypeTable.getValue(3, "id") == studyGradeTypes.get(0).getNewId());

        // CardinalTimeUnitStudyGradeType are part of the study grade type and are copied as well
        ITable expectedCardinalTimeUnitStudyGradeTypeTable = expectedDataSet.getTable("opuscollege.cardinaltimeunitstudygradetype");
        ITable actualCardinalTimeUnitStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.cardinaltimeunitstudygradetype");
        assertEquals(2, actualCardinalTimeUnitStudyGradeTypeTable.getRowCount());
        Assertion.assertEqualsIgnoreCols(expectedCardinalTimeUnitStudyGradeTypeTable, 
                actualCardinalTimeUnitStudyGradeTypeTable,
                new String[] {"id", "studygradetypeid", "writewhen", "writewho"});

        // secondary subject groups are part of the study grade type and are copied as well
        ITable expectedSubjectGroupTable = expectedDataSet.getTable("opuscollege.secondaryschoolsubjectgroup");
        ITable actualSubjectGroupTable = databaseDataSet.getTable("opuscollege.secondaryschoolsubjectgroup");
        assertEquals(2, actualSubjectGroupTable.getRowCount());
        Assertion.assertEqualsIgnoreCols(expectedSubjectGroupTable, 
                actualSubjectGroupTable,
                new String[] {"id", "studygradetypeid", "writewhen", "writewho"});

        // grouped subjects are part of the secondary subject groups
        ITable expectedGroupedSubjectsTable = expectedDataSet.getTable("opuscollege.groupedsecondaryschoolsubject");
        ITable actualGroupedSubjectsTable = databaseDataSet.getTable("opuscollege.groupedsecondaryschoolsubject");
        assertEquals(2, actualGroupedSubjectsTable.getRowCount());
        Assertion.assertEqualsIgnoreCols(expectedGroupedSubjectsTable, 
                actualGroupedSubjectsTable,
                new String[] {"id", "secondaryschoolsubjectgroupid", "writewhen", "writewho"});

    }

    @Test
    public void testTransferEmptySubjects() throws Exception {
        // check that empty subjects do not lead to exceptions
        ctManager.transferSubjects(null, 0);
        ctManager.transferSubjects(new ArrayList<SubjectCT>(), 0);
    }

    @Test
    public void testTransferSubjects() throws Exception {

        ctManager.transferSubjects(subjects, 48);
        
        assertTrue(0 != subjects.get(0).getNewId());
        assertTrue(0 != subjects.get(1).getNewId());
        assertTrue(0 != subjects.get(2).getNewId());
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/service/curriculumtransition/postData.xml");

        ITable actualSubjectTable = databaseDataSet.getTable("opuscollege.subject");
        ITable expectedSubjectTable = expectedDataSet.getTable("opuscollege.subject");
        Assertion.assertEqualsIgnoreCols(expectedSubjectTable, 
                actualSubjectTable,
                new String[] {"id", "writewhen", "writewho"});
        
        // there are now duplicated subjects
        assertEquals(6, actualSubjectTable.getRowCount());
        assertNotNull(actualSubjectTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualSubjectTable.getValue(3, "id"));

        // examinations and tests are part of the subject and are copied as well
        ITable expectedExaminationTable = expectedDataSet.getTable("opuscollege.examination");
        ITable expectedTestTable = expectedDataSet.getTable("opuscollege.test");
        ITable expectedExaminationTeacherTable = expectedDataSet.getTable("opuscollege.examinationteacher");
        ITable expectedTestTeacherTable = expectedDataSet.getTable("opuscollege.testteacher");
        ITable actualExaminationTable = databaseDataSet.getTable("opuscollege.examination");
        ITable actualTestTable = databaseDataSet.getTable("opuscollege.test");
        ITable actualExaminationTeacherTable = databaseDataSet.getTable("opuscollege.examinationteacher");
        ITable actualTestTeacherTable = databaseDataSet.getTable("opuscollege.testteacher");

        assertEquals(6, actualExaminationTable.getRowCount());
        assertEquals(4, actualTestTable.getRowCount());
        assertEquals(4, actualExaminationTeacherTable.getRowCount());
        assertEquals(4, actualTestTeacherTable.getRowCount());

        Assertion.assertEqualsIgnoreCols(expectedExaminationTable, 
                actualExaminationTable,
                new String[] {"id", "subjectid", "writewhen", "writewho"});
        Assertion.assertEqualsIgnoreCols(expectedTestTable, 
                actualTestTable,
                new String[] {"id", "examinationid", "writewhen", "writewho"});
        Assertion.assertEqualsIgnoreCols(expectedExaminationTeacherTable, 
                actualExaminationTeacherTable,
                new String[] {"id", "examinationid", "classgroupid", "writewhen", "writewho"});
        Assertion.assertEqualsIgnoreCols(expectedTestTeacherTable, 
                actualTestTeacherTable,
                new String[] {"id", "testid", "classgroupid", "writewhen", "writewho"});

    }

    /**
     * For subject teachers that have a reference to classgroups it is required to first transfer
     * the respective studygradetype and its associated classgroups.
     * @throws Exception
     */
    @Test
    public void testTransferSubjectTeachers() throws Exception {
        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);
        ctManager.transferSubjects(subjects, 48);
        ctManager.transferSubjectTeachers(44, 48);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/college/service/curriculumtransition/postData.xml");

        // Verify subject teachers
        ITable actualSubjectTeacherTable = databaseDataSet.getTable("opuscollege.subjectteacher");
        ITable expectedSubjectTeacherTable = expectedDataSet.getTable("opuscollege.subjectteacher");
        Assertion.assertEqualsIgnoreCols(expectedSubjectTeacherTable, actualSubjectTeacherTable, new String[] { "id", "subjectid", "classgroupid", "writewhen", "writewho" });

        // there are now duplicated subject teachers
        assertEquals(4, actualSubjectTeacherTable.getRowCount());
        assertNotNull(actualSubjectTeacherTable.getValue(2, "id"));
        assertNotNull(actualSubjectTeacherTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualSubjectTeacherTable.getValue(2, "id"));
        assertTrue(0 != (Integer) actualSubjectTeacherTable.getValue(3, "id"));
        assertNotNull(actualSubjectTeacherTable.getValue(2, "classgroupid"));
        assertTrue(0 != (Integer) actualSubjectTeacherTable.getValue(2, "classgroupid"));
        // The second subjectTeacher doesn't have a classgroup assigned
        assertNull(actualSubjectTeacherTable.getValue(3, "classgroupid"));
        assertEquals(19, actualSubjectTeacherTable.getValue(0, "staffmemberid"));
        assertEquals(19, actualSubjectTeacherTable.getValue(1, "staffmemberid"));
        assertEquals(19, actualSubjectTeacherTable.getValue(2, "staffmemberid"));
        assertEquals(19, actualSubjectTeacherTable.getValue(3, "staffmemberid"));

        // Verify examination teachers
        ITable actualExaminationTeacherTable = databaseDataSet.getTable("opuscollege.examinationteacher");
        ITable expectedExaminationTeacherTable = expectedDataSet.getTable("opuscollege.examinationteacher");
        Assertion.assertEqualsIgnoreCols(expectedExaminationTeacherTable, actualExaminationTeacherTable, new String[] { "id", "examinationid", "classgroupid", "writewhen", "writewho" });

        // there are now duplicated examination teachers
        assertEquals(4, actualExaminationTeacherTable.getRowCount());
        assertNotNull(actualExaminationTeacherTable.getValue(2, "id"));
        assertNotNull(actualExaminationTeacherTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualExaminationTeacherTable.getValue(2, "id"));
        assertTrue(0 != (Integer) actualExaminationTeacherTable.getValue(3, "id"));
        assertNotNull(actualExaminationTeacherTable.getValue(2, "classgroupid"));
        assertTrue(0 != (Integer) actualExaminationTeacherTable.getValue(2, "classgroupid"));
        // The second examinationTeacher doesn't have a classgroup assigned
        assertNull(actualExaminationTeacherTable.getValue(3, "classgroupid"));
        assertEquals(19, actualExaminationTeacherTable.getValue(2, "staffmemberid"));
        assertEquals(19, actualExaminationTeacherTable.getValue(3, "staffmemberid"));

        // Verify test teachers
        ITable actualTestTeacherTable = databaseDataSet.getTable("opuscollege.testteacher");
        ITable expectedTestTeacherTable = expectedDataSet.getTable("opuscollege.testteacher");
        Assertion.assertEqualsIgnoreCols(expectedTestTeacherTable, actualTestTeacherTable, new String[] { "id", "testid", "classgroupid", "writewhen", "writewho" });

        // there are now duplicated examination teachers
        assertEquals(4, actualTestTeacherTable.getRowCount());
        assertNotNull(actualTestTeacherTable.getValue(2, "id"));
        assertNotNull(actualTestTeacherTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualTestTeacherTable.getValue(2, "id"));
        assertTrue(0 != (Integer) actualTestTeacherTable.getValue(3, "id"));
        assertNotNull(actualTestTeacherTable.getValue(2, "classgroupid"));
        assertTrue(0 != (Integer) actualTestTeacherTable.getValue(2, "classgroupid"));
        // The second TestTeacher doesn't have a classgroup assigned
        assertNull(actualTestTeacherTable.getValue(3, "classgroupid"));
        assertEquals(19, actualTestTeacherTable.getValue(2, "staffmemberid"));
        assertEquals(19, actualTestTeacherTable.getValue(3, "staffmemberid"));

    }
    
    @Test
    public void testTransferSubjectStudyTypes() throws Exception {
        ctManager.transferSubjects(subjects, 48);
        ctManager.transferSubjectStudyTypes(44, 48);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectStudyTypeTable = databaseDataSet.getTable("opuscollege.subjectstudytype");
        String code1 = (String) actualSubjectStudyTypeTable.getValue(2, "studytypecode");
        String code2 = (String) actualSubjectStudyTypeTable.getValue(3, "studytypecode");
        assertFalse(code1.equals(code2));
        assertTrue("3".equals(code1) || "5".equals(code1));
        assertTrue("3".equals(code2) || "5".equals(code2));
    }
    
    @Test
    public void testTransferSubjectStudyGradeTypes() throws Exception {

        ctManager.transferSubjects(subjects, 48);
        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);
        
//        int newStudyGradeTypeId = studyGradeTypes.get(0).getNewId();
//        assertTrue(newStudyGradeTypeId != 0);
        
        int newSubjectId1 = subjects.get(0).getNewId();
        int newSubjectId2 = subjects.get(1).getNewId();
        int newSubjectId3 = subjects.get(2).getNewId();
        assertTrue(0 != newSubjectId1);
        assertTrue(0 != newSubjectId2);
        assertTrue(0 != newSubjectId3);
        
//        int originalStudyGradeTypeId = studyGradeType.getOriginalId();
//        assertTrue(newStudyGradeTypeId != originalStudyGradeTypeId);
        
        int originalSubjectId1 = subjects.get(0).getOriginalId();
        int originalSubjectId2 = subjects.get(1).getOriginalId();
        int originalSubjectId3 = subjects.get(2).getOriginalId();
        assertTrue(newSubjectId1 != originalSubjectId1);
        assertTrue(newSubjectId2 != originalSubjectId2);
        assertTrue(newSubjectId3 != originalSubjectId3);
        
        ctManager.transferSubjectStudyGradeTypes(44, 48);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.subjectstudygradetype");
        assertEquals(6, actualSubjectStudyGradeTypeTable.getRowCount());
        
        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/service/curriculumtransition/postData.xml");
        ITable expectedSubjectStudyGradeTypeTable = expectedDataSet.getTable("opuscollege.subjectstudygradetype");
        Assertion.assertEqualsIgnoreCols(expectedSubjectStudyGradeTypeTable, 
                actualSubjectStudyGradeTypeTable,
                new String[] {"id", "subjectid", "studygradetypeid", "writewhen", "writewho"});
    }
    
    @Test
    public void testTransferSubjectPrerequisites() throws Exception {

        ctManager.transferSubjects(subjects, 48);
        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);
        ctManager.transferSubjectStudyGradeTypes(44, 48);
        ctManager.transferSubjectPrerequisites(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectprerequisite");
        assertEquals(6, actualSubjectPrerequisiteTable.getRowCount());
    }
    
    @Test
    public void testTransferEmptySubjectBlocks() throws Exception {
        // check that empty subject blocks do not lead to exceptions
        ctManager.transferSubjectBlocks(null, 0);
        ctManager.transferSubjectBlocks(new ArrayList<SubjectBlockCT>(), 0);
    }

    @Test
    public void testTransferSubjectBlocks() throws Exception {
        
        ctManager.transferSubjectBlocks(subjectBlocks, 48);
        
        assertTrue(0 != subjectBlocks.get(0).getNewId());
        assertTrue(0 != subjectBlocks.get(1).getNewId());

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/service/curriculumtransition/postData.xml");

        ITable actualSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectBlock");
        ITable expectedSubjectBlockTable = expectedDataSet.getTable("opuscollege.subjectBlock");
        Assertion.assertEqualsIgnoreCols(expectedSubjectBlockTable, 
                actualSubjectBlockTable,
                new String[] {"id", "writewhen", "writewho"});
        
        // there are now duplicated study grade types
        assertEquals(4, actualSubjectBlockTable.getRowCount());
        assertNotNull(actualSubjectBlockTable.getValue(2, "id"));
        assertNotNull(actualSubjectBlockTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualSubjectBlockTable.getValue(2, "id"));
        assertTrue(0 != (Integer) actualSubjectBlockTable.getValue(3, "id"));
        
    }
    
    @Test
    public void testTransferSubjectBloclkPrerequisites() throws Exception {

        ctManager.transferSubjectBlocks(subjectBlocks, 48);
        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);
        ctManager.transferSubjectBlockStudyGradeTypes(44, 48);
        ctManager.transferSubjectBlockPrerequisites(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectblockprerequisite");
        assertEquals(2, actualSubjectPrerequisiteTable.getRowCount());
    }
    

    @Test
    public void testTransferSubjectSubjectBlocks() throws Exception {

        ctManager.transferSubjects(subjects, 48);
        ctManager.transferSubjectBlocks(subjectBlocks, 48);
        
        int newSubjectBlockId1 = subjectBlocks.get(0).getNewId();
        int newSubjectBlockId2 = subjectBlocks.get(1).getNewId();
        assertTrue(0 != newSubjectBlockId1);
        assertTrue(0 != newSubjectBlockId2);
        
        int newSubjectId1 = subjects.get(0).getNewId();
        int newSubjectId2 = subjects.get(1).getNewId();
        int newSubjectId3 = subjects.get(2).getNewId();
        assertTrue(0 != newSubjectId1);
        assertTrue(0 != newSubjectId2);
        assertTrue(0 != newSubjectId3);
        
        int originalSubjectBlockId1 = subjectBlocks.get(0).getOriginalId();
        int originalSubjectBlockId2 = subjectBlocks.get(1).getOriginalId();
        assertTrue(newSubjectBlockId1 != originalSubjectBlockId1);
        assertTrue(newSubjectBlockId2 != originalSubjectBlockId2);
        
        int originalSubjectId1 = subjects.get(0).getOriginalId();
        int originalSubjectId2 = subjects.get(1).getOriginalId();
        int originalSubjectId3 = subjects.get(2).getOriginalId();
        assertTrue(newSubjectId1 != originalSubjectId1);
        assertTrue(newSubjectId2 != originalSubjectId2);
        assertTrue(newSubjectId3 != originalSubjectId3);

        // see prepData.xml for relationship subjects <-> subject blocks
        ctManager.transferSubjectSubjectBlocks(44, 48);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectsubjectblock");
        assertEquals(8, actualSubjectSubjectBlockTable.getRowCount());

    }

    @Test
    public void testTransferEndGrades() throws Exception {

        ctManager.transferEndGrades(44, 48);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/service/curriculumtransition/postData.xml");

        ITable actualEndGradeTable = databaseDataSet.getTable("opuscollege.endgrade");
        ITable expectedEndGradeTable = expectedDataSet.getTable("opuscollege.endgrade");
        Assertion.assertEqualsIgnoreCols(expectedEndGradeTable, 
                actualEndGradeTable,
                new String[] {"id", "writewhen", "writewho"});
        
        // there are now duplicated records
        assertEquals(6, actualEndGradeTable.getRowCount());
        assertNotNull(actualEndGradeTable.getValue(3, "id"));
        assertTrue(0 != (Integer) actualEndGradeTable.getValue(3, "id"));
    }
    
    @Test
    public void testTransition() throws Exception {

        CurriculumTransitionData data = ctManager.loadCurriculumTransitionData(44, 48, null);
        ctManager.transferCurriculum(data);
        
        // in assertTrasition() the transition will be repeated, but it shall
        // be recognized that everything has already been transferred already,
        // so no further records shall be created in the target year
        assertTransition();

    }

    @Test
    public void testSubsetTransition() throws Exception {

        CurriculumTransitionData data = ctManager.loadCurriculumTransitionData(44, 48, null);
        data.getSelectedStudyGradeTypeIds().clear();    // only 1 (of 2) SGTs
        data.getSelectedStudyGradeTypeIds().add(58);
        data.getSelectedSubjectBlockIds().clear();      // only 1 (of 2) subject blocks
        data.getSelectedSubjectBlockIds().add(2);
        ctManager.transferCurriculum(data);             // all subjects

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();
        
        ITable actualSubjectTable = databaseDataSet.getTable("opuscollege.subject");
        ITable actualSubjectTeacherTable = databaseDataSet.getTable("opuscollege.subjectteacher");
        ITable actualSubjectStudyTypeTable = databaseDataSet.getTable("opuscollege.subjectstudytype");
        ITable actualStudygradeTypeTable = databaseDataSet.getTable("opuscollege.studygradetype");
        ITable actualStudygradeTypePrerequisiteTable = databaseDataSet.getTable("opuscollege.studygradetypeprerequisite");
        ITable actualClassgroupTable = databaseDataSet.getTable("opuscollege.classgroup");
        ITable actualSubjectStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.subjectstudygradetype");
        ITable actualSubjectPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectprerequisite");
        ITable actualSubjectBlockStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.subjectblockstudygradetype");
        ITable actualSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectblock");
        ITable actualSubjectBlockPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectblockprerequisite");
        ITable actualSubjectSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectsubjectblock");
        
        // there are now duplicated study grade type and subjects
        assertEquals(3, actualStudygradeTypeTable.getRowCount());
        assertEquals(1, actualStudygradeTypePrerequisiteTable.getRowCount());
        assertEquals(4, actualClassgroupTable.getRowCount());
        assertEquals(6, actualSubjectTable.getRowCount());
        assertEquals(4, actualSubjectTeacherTable.getRowCount());
        assertEquals(4, actualSubjectStudyTypeTable.getRowCount());
        assertEquals(6, actualSubjectStudyGradeTypeTable.getRowCount());
        assertEquals(6, actualSubjectPrerequisiteTable.getRowCount());
        assertEquals(3, actualSubjectBlockTable.getRowCount());
        assertEquals(3, actualSubjectBlockStudyGradeTypeTable.getRowCount());
        assertEquals(1, actualSubjectBlockPrerequisiteTable.getRowCount());
        assertEquals(6, actualSubjectSubjectBlockTable.getRowCount());

        // now transfer the rest, and the result should be the same as ever
        data.getSelectedStudyGradeTypeIds().clear();    // remaining 1 (of 2) SGTs
        data.getSelectedStudyGradeTypeIds().add(158);
        data.getSelectedSubjectBlockIds().clear();      // remaining 1 (of 2) subject blocks
        data.getSelectedSubjectBlockIds().add(1);
        data.getSelectedSubjectIds().clear();           // all subjects already transferred
        ctManager.transferCurriculum(data);
        assertTransition();

    }

    /**
     * This test method first transfers study grade type, followed by rest. The
     * challenge is to recognize that the study grade type has already been
     * transferred and transfer the subject-study grade type record correctly.
     * 
     * @throws Exception
     */
    @Test
    public void testStagedTransitionSGT() throws Exception {

        // first transfer the study grade type
        ctManager.transferStudyGradeTypes(studyGradeTypes, 48);

        // now we do the transition, and we expect the same outcome as in an all-at-once transition
        assertTransition();
    }

    /**
     * This test method first transfers the subjects, followed by the rest. The
     * challenge is to recognize that the subject have already been transferred
     * and transfer the subject-study grade type records correctly.
     * 
     * @throws Exception
     */
    @Test
    public void testStagedTransitionSubjects() throws Exception {

        // first transfer the subjects
        ctManager.transferSubjects(subjects, 48);        

        // now we do the transition, and we expect the same outcome as in an all-at-once transition
        assertTransition();
    }

    /**
     * This test method first transfers the subject blocks, followed by the
     * rest. The challenge is to recognize that the subject blocks have already
     * been transferred and transfer the subject block-study grade type records
     * as well as the subject-subject block records correctly.
     * 
     * @throws Exception
     */
    @Test
    public void testStagedTransitionSubjectBlocks() throws Exception {

        // first transfer the subject blocks
        ctManager.transferSubjectBlocks(subjectBlocks, 48);

        // now we do the transition, and we expect the same outcome as in an all-at-once transition
        assertTransition();
    }

    /**
     * This test method first transfers the subjects, then the subject blocks,
     * and finally the rest. The challenge is to recognize that the subjects and
     * subject blocks have already been transferred and transfer the subject
     * block-study grade type records as well as the subject-subject block
     * records correctly.
     * 
     * @throws Exception
     */
    @Test
    public void testStagedTransitionSubjectsAndSubjectBlocks() throws Exception {

        // first transfer the subjects and subject blocks
        ctManager.transferSubjects(subjects, 48);
        ctManager.transferSubjectBlocks(subjectBlocks, 48);

        // now we do the transition, and we expect the same outcome as in an all-at-once transition
        testTransition();
    }
    private void assertTransition() throws Exception {

        // transition everything possible (i. e. not yet transferred)
        CurriculumTransitionData data = ctManager.loadCurriculumTransitionData(44, 48, null);
        ctManager.transferCurriculum(data);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSubjectTable = databaseDataSet.getTable("opuscollege.subject");
        ITable actualSubjectTeacherTable = databaseDataSet.getTable("opuscollege.subjectteacher");
        ITable actualSubjectStudyTypeTable = databaseDataSet.getTable("opuscollege.subjectstudytype");
        ITable actualStudygradeTypeTable = databaseDataSet.getTable("opuscollege.studygradetype");
        ITable actualStudygradeTypePrerequisiteTable = databaseDataSet.getTable("opuscollege.studygradetypeprerequisite");
        ITable actualClassgroupTable = databaseDataSet.getTable("opuscollege.classgroup");
        ITable actualSubjectStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.subjectstudygradetype");
        ITable actualSubjectPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectprerequisite");
        ITable actualSubjectBlockStudyGradeTypeTable = databaseDataSet.getTable("opuscollege.subjectblockstudygradetype");
        ITable actualSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectblock");
        ITable actualSubjectBlockPrerequisiteTable = databaseDataSet.getTable("opuscollege.subjectblockprerequisite");
        ITable actualSubjectSubjectBlockTable = databaseDataSet.getTable("opuscollege.subjectsubjectblock");
        ITable actualExaminationTable = databaseDataSet.getTable("opuscollege.examination");
        ITable actualExaminationTeacherTable = databaseDataSet.getTable("opuscollege.examinationteacher");
        ITable actualTestTable = databaseDataSet.getTable("opuscollege.test");
        ITable actualTestTeacherTable = databaseDataSet.getTable("opuscollege.testteacher");

        // there are now duplicated study grade type and subjects
        assertEquals(4, actualStudygradeTypeTable.getRowCount());
        assertEquals(2, actualStudygradeTypePrerequisiteTable.getRowCount());
        assertEquals(4, actualClassgroupTable.getRowCount());
        assertEquals(6, actualSubjectTable.getRowCount());
        assertEquals(4, actualSubjectTeacherTable.getRowCount());
        assertEquals(4, actualSubjectStudyTypeTable.getRowCount());
        assertEquals(6, actualSubjectStudyGradeTypeTable.getRowCount());
        assertEquals(6, actualSubjectPrerequisiteTable.getRowCount());
        assertEquals(4, actualSubjectBlockTable.getRowCount());
        assertEquals(4, actualSubjectBlockStudyGradeTypeTable.getRowCount());
        assertEquals(2, actualSubjectBlockPrerequisiteTable.getRowCount());
        assertEquals(8, actualSubjectSubjectBlockTable.getRowCount());
        assertEquals(6, actualExaminationTable.getRowCount());
        assertEquals(4, actualExaminationTeacherTable.getRowCount());
        assertEquals(4, actualTestTable.getRowCount());
        assertEquals(4, actualTestTeacherTable.getRowCount());
    }

}
