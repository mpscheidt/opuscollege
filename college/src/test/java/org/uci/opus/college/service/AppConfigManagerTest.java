package org.uci.opus.college.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.AppConfigAttribute;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml"
    })
public class AppConfigManagerTest extends OpusDBTestCase {

	@Autowired
	private AppConfigManagerInterface appConfigManager;

	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.appconfig")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/AppConfigManagerTest-prepData.xml");
    }

    @Test
    public void testGetAppConfig() {
        List<AppConfigAttribute> appConfigs = appConfigManager.getAppConfig();
        assertNotNull(appConfigs);
        assertEquals(6, appConfigs.size());
    }

    @Test
    public void testGetAppConfigAsMaps() {
        Map<String, Object> map = new HashMap<>();
        map.put("appConfigAttributeName", "academicYearOfAdmission");
        List<Map<String, Object>> appConfigs = appConfigManager.findAppConfigAsMaps(map);
        assertNotNull(appConfigs);
        assertEquals(3, appConfigs.size());
    }

    @Test
    public void testFindAppConfigAttribute() {
        AppConfigAttribute attr = appConfigManager.findAppConfigAttribute("useOfSubjectBlocks");
        assertNotNull(attr);
        assertEquals("Y", attr.getAppConfigAttributeValue());
    }

    @Test
    public void testFindAppConfigAttributeById() {
        AppConfigAttribute attr = appConfigManager.findOne(39);
        assertNotNull(attr);
        assertEquals("52", attr.getAppConfigAttributeValue());
    }

    @Test
    public void testUpdateAppConfigAttribute() {
        AppConfigAttribute attr = appConfigManager.findOne(25);
        attr.setAppConfigAttributeValue("N");
        appConfigManager.updateAppConfigAttribute(attr);

        AppConfigAttribute attrReloaded = appConfigManager.findOne(25);
        assertNotNull(attrReloaded);
        assertEquals("N", attrReloaded.getAppConfigAttributeValue());
    }

    @Test
    public void getAppLanguages_ExpectListOfTrimmedStrings() {
        
        List<String> appLanguages = appConfigManager.getAppLanguages();
        assertEquals(2, appLanguages.size());
        assertEquals("en", appLanguages.get(0));
        // we don't want " pt" with leading space, but the trimmed String "pt"
        assertEquals("pt", appLanguages.get(1));
    }
    
    @Test
    public void getCountryCode_NullValue() {
        
        assertNull(appConfigManager.getCountryCode());
    }
    
}
