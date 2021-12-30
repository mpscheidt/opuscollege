package org.uci.opus.college.persistence;

import static org.junit.Assert.assertNotEquals;

import java.util.List;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.fixture.ReportPropertyFixture;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", 
		"/org/uci/opus/college/applicationContext-util.xml", 
		"/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/college/applicationContext-data.xml" })
public class ReportPropertyMapperTest extends OpusDBTestCase {

    @Autowired
    private ReportPropertyMapper reportPropertyMapper;

    private ReportProperty reportProperty1, reportProperty2;

    private int id1;
    private int id2;

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.reportproperty")
        });
        return dataSetToTruncate;
    }

    // NB: @Before method in superclass is guaranteed to be executed before this one
    @Before
    public void setUp() throws Exception {

        reportProperty1 = ReportPropertyFixture.studentsBySubjectTitle();
        reportProperty2 = ReportPropertyFixture.studentsBySubjectLogo();
        reportPropertyMapper.add(reportProperty1);
        reportPropertyMapper.add(reportProperty2);

        id1 = reportProperty1.getId();
        id2 = reportProperty2.getId();

        assertNotEquals(0, id1);
        assertNotEquals(0, id2);
    }

    @Test
    public void testFindOne() {

        ReportProperty loaded1 = reportPropertyMapper.findOne(id1);
        assertReportProperty(reportProperty1, loaded1);

        ReportProperty loaded2 = reportPropertyMapper.findOne(id2);
        assertReportProperty(reportProperty2, loaded2);

    }

    @Test
    public void testFindPropertiesForReport() {

        List<ReportProperty> props = reportPropertyMapper.findPropertiesForReport(ReportPropertyFixture.STUDENTSBYSUBJECT_REPORTNAME);
        assertEquals(2, props.size());

        // we rely that the records are returned in the same order as they are inserted 
        // (the order doesn't really matter for Opus, but it makes testing easier) 
        assertReportProperty(reportProperty1, props.get(0));
        assertReportProperty(reportProperty2, props.get(1));

    }

    @Test
    public void testFindPropertiesByName() {

        List<ReportProperty> props = reportPropertyMapper.findPropertiesByName(ReportPropertyFixture.STUDENTSBYSUBJECT_REPORTNAME, ReportPropertyFixture.STUDENTSBYSUBJECT_TITLE_PROPERTYNAME);
        assertEquals(1, props.size());

        // we rely that the records are returned in the same order as they are inserted 
        // (the order doesn't really matter for Opus, but it makes testing easier) 
        assertReportProperty(reportProperty1, props.get(0));

    }

    private void assertReportProperty(ReportProperty expected, ReportProperty loaded1) {
        assertEquals(expected.getReportName(), loaded1.getReportName());
        assertEquals(expected.getName(), loaded1.getName());
        assertEquals(expected.getType(), loaded1.getType());
        assertEquals(expected.getText(), loaded1.getText());
    }

    @Test
    public void testDeleteById() {
        
        reportPropertyMapper.delete(id1);
        assertNull(reportPropertyMapper.findOne(id1));
        
    }

    @Test
    public void testUpdate() {
        
        reportProperty1.setText("other text");
        reportPropertyMapper.update(reportProperty1);
        
        assertReportProperty(reportProperty1, reportPropertyMapper.findOne(id1));
    }

    @Test
    public void testAdd() {

        String reportName = "my report";
        String propertyName = "my prop";
        String text = "random text";
        ReportProperty newItem = new ReportProperty(reportName, propertyName, text);
        reportPropertyMapper.add(newItem);
        assertNotEquals(0, newItem.getId());

        assertReportProperty(newItem, reportPropertyMapper.findOne(newItem.getId()));

    }

}
