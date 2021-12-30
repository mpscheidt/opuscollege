package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

import java.util.ArrayList;
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
import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup1;
import org.uci.opus.college.domain.Lookup2;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup4;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.StaffMember;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class LookupManagerTest extends OpusDBTestCase {

    @Autowired
	private LookupManagerInterface lookupManager;
	
	@Autowired
	private StaffMemberManagerInterface staffMemberManager;

	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.appconfig"),
                new DefaultTable("opuscollege.lookuptable"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.student"),
                new DefaultTable("opuscollege.studyplan"),
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/LookupManagerTest-prepData.xml");
    }

    @Test
    public void testFindAllLookup() {
        List<Lookup> addressTypes = lookupManager.findAllRows("en", "addresstype");
        assertNotNull(addressTypes);
        assertEquals(2, addressTypes.size());
        assertEquals("home", addressTypes.get(1).getDescription());
    }
    
    @Test
    public void testFindAllRowsForCode() {
        List<Lookup> addressTypes = lookupManager.findAllRowsForCode(null, "addresstype", "code", "1");
        assertNotNull(addressTypes);
        assertEquals(2, addressTypes.size());
        assertEquals("casa", addressTypes.get(0).getDescription());
        assertEquals("home", addressTypes.get(1).getDescription());
    }

    @Test
    public void testFindAllLookup1() {
        List<Lookup1> languages = lookupManager.findAllRows("pt", "language");
        assertNotNull(languages);
        assertEquals(2, languages.size());
        assertEquals("Changana", languages.get(0).getDescription());
        assertEquals("ca", languages.get(0).getDescriptionShort());
    }

    @Test
    public void testFindAllLookup2() {
        List<Lookup2> districts = lookupManager.findAllRows("en", "district");
        assertNotNull(districts);
        assertEquals(2, districts.size());
        assertEquals("Beira City", districts.get(0).getDescription());
        assertEquals("MZ-08", districts.get(0).getProvinceCode());
    }

    @Test
    public void testFindAllLookup3() {
        List<Lookup3> countries = lookupManager.findAllRows("pt", "country");
        assertNotNull(countries);
        assertEquals(2, countries.size());
        assertEquals("ALEMANHA", countries.get(0).getDescription());
        assertEquals("DE", countries.get(0).getShort2());
        assertEquals("DEU", countries.get(0).getShort3());
    }

    @Test
    public void testFindAllLookup4() {
        List<Lookup4> posts = lookupManager.findAllRows("en", "administrativepost");
        assertNotNull(posts);
        assertEquals(2, posts.size());
        assertEquals("Pemba City", posts.get(1).getDescription());
        assertEquals("MZ-01-14", posts.get(1).getDistrictCode());
    }

    @Test
    public void testFindAllLookup5() {
        List<Lookup5> provinces = lookupManager.findAllRows("pt", "province");
        assertNotNull(provinces);
        assertEquals(2, provinces.size());
        assertEquals("Cidade de Maputo", provinces.get(1).getDescription());
        assertEquals("508", provinces.get(1).getCountryCode());
    }

    @Test
    public void testFindAllRowsForCode5() {
        List<Lookup5> allProvinces = lookupManager.findAllRowsForCode("pt", "province", "countryCode", "508");
        assertNotNull(allProvinces);
        assertEquals(2, allProvinces.size());
        assertEquals("Cabo Delgado", allProvinces.get(0).getDescription());
        assertEquals("Cidade de Maputo", allProvinces.get(1).getDescription());
    }

    @Test
    public void testFindAllLookup7() {
        List<Lookup7> progressStatuses = lookupManager.findAllRows("en", "progressstatus");
        assertNotNull(progressStatuses);
        assertEquals(2, progressStatuses.size());
        assertEquals("Clear pass", progressStatuses.get(0).getDescription());
        assertEquals("N", progressStatuses.get(0).getCarrying());
    }

    @Test
    public void testFindAllLookup8() {
        List<Lookup8> ctus = lookupManager.findAllRows("pt", "cardinaltimeunit");
        assertNotNull(ctus);
        assertEquals(3, ctus.size());
        assertEquals("Ano", ctus.get(0).getDescription());
        assertEquals(1, ctus.get(0).getNrOfUnitsPerYear());
    }

    @Test
    public void testFindAllLookup9() {
        List<Lookup9> gradeTypes = lookupManager.findAllRows("en", "gradetype");
        assertNotNull(gradeTypes);
        assertEquals(2, gradeTypes.size());
        assertEquals("Bachelor of art", gradeTypes.get(0).getDescription());
        assertEquals("B.A.", gradeTypes.get(0).getTitle());
    }

    @Test
    public void testFindLookup() {
        Lookup addressType = lookupManager.findLookup("pt", "1", "addresstype");
        assertNotNull(addressType);
        assertEquals("casa", addressType.getDescription());
    }

    @Test
    public void testFindLookup1() {
        Lookup language = lookupManager.findLookup("pt", "cha", "language");
        assertNotNull(language);
        assertEquals("Changana", language.getDescription());
    }
    
    // TODO move this test to the StaffMemberManagerTest
    @Test
    public void testDeleteLookupFromEntity() {
        lookupManager.deleteLookupFromEntity("staffmember", 19, "5", "function");

        // TODO verify after StaffMember has been implemented
        StaffMember staffMember = staffMemberManager.findStaffMember("en", 19);
        assertEquals(1, staffMember.getFunctions().size());
    }

    @Test
    public void testGetCoreModule() {
        AppVersion coreVersion = lookupManager.getCoreModule();
        assertNotNull(coreVersion);
        assertEquals("college", coreVersion.getModule());
        assertEquals(4.39, coreVersion.getDbVersion());
    }

    @Test
    public void testGetAppVersions() {
        List<AppVersion> appVersions = lookupManager.getAppVersions();
        assertNotNull(appVersions);
        assertEquals(4, appVersions.size());
    }

    @Test
    public void testGetAppVersion() {
        AppVersion appVersion = lookupManager.getAppVersion("ucm");
        assertNotNull(appVersion);
        assertEquals(4.03, appVersion.getDbVersion());
    }
    
    @Test
    public void addAppVersion() {
        AppVersion appVersion = new AppVersion("my ridiculously awesome opus module", 0.1);
        lookupManager.add(appVersion);

        assertEquals(5, lookupManager.getAppVersions().size());
    }
    
    @Test
    public void updateAppVersion() {

        final double newVersion = 4.04;

        AppVersion appVersion = lookupManager.getAppVersion("ucm");
        appVersion.setDbVersion(newVersion);
        lookupManager.update(appVersion);

        assertEquals(newVersion, lookupManager.getAppVersion("ucm").getDbVersion());
    }

    @Test
    public void testGetNextId() {
        String tableName = "academicfield";
        int id1 = lookupManager.getNextId(tableName);
        int id2 = lookupManager.getNextId(tableName);
        assertTrue(id2 > id1);
        assertNotEquals(0, id2);
        assertEquals(1, id2 - id1);
    }
    
    @Test
    public void testFindAllLookupTables() {
        List<LookupTable> lookupTables = lookupManager.findAllLookupTables();
        assertNotNull(lookupTables);
        assertTrue(!lookupTables.isEmpty());
        // 8 active, 2 non-active lookup tables
        assertEquals(8, lookupTables.size());
    }

    @Test
    public void testFindLookupTableByName() {
        String tableName = "language";
        LookupTable lookupTable = lookupManager.findLookupTableByName(tableName);
        assertNotNull(lookupTable);
        assertEquals(tableName, lookupTable.getTableName());
        assertEquals("Lookup1", lookupTable.getLookupType());
    }

    @Test
    public void testAddLookup() {
        Lookup1 language = new Lookup1("en", "de", "German", "ger");
        String tableName = "language";
        lookupManager.addLookup(language, tableName);

        // read all items (ordered by description)
        List<Lookup1> languages = lookupManager.findAllRows("en", tableName);
        assertEquals(3, languages.size());
        assertEquals("ger", languages.get(1).getDescriptionShort());
        
        assertEquals(2, lookupManager.findAllRows("pt", tableName).size());
    }

    @Test
    public void testUpdateLookup() {
        String tableName = "language";
        String newDescription = "modified";
        String newDescriptionShort = "mod";

        Lookup1 languageChangana = lookupManager.findLookup("en", "cha", tableName);
        languageChangana.setDescription(newDescription);
        languageChangana.setDescriptionShort(newDescriptionShort);
        lookupManager.updateLookup(languageChangana, tableName);

        Lookup1 languageModified = lookupManager.findLookup("en", "cha", tableName);
        assertEquals(newDescription, languageModified.getDescription());
        assertEquals(newDescriptionShort, languageModified.getDescriptionShort());
    }

    @Test
    public void testDeleteLookupByCode() {
        String tableName = "language";
        String code = "cha";
        String lang = "en";
        lookupManager.deleteLookupByCode(lang, code, tableName);

        List<Lookup1> languages = lookupManager.findAllRows(lang, tableName);
        assertEquals(1, languages.size());
    }

    @Test
    public void testFindRowsByDescription() {
        
        List<Lookup8> ctus = lookupManager.findRowsByDescription("en", "cardinaltimeunit", "mester");
        assertNotNull(ctus);
        assertEquals(2, ctus.size());
    }

    @Test
    public void testHasDependentValues() {
        assertTrue(lookupManager.hasDependentValues("person", "gradetypecode", "BSC"));
        assertFalse(lookupManager.hasDependentValues("person", "gradetypecode", "BA"));
    }
    
    @Test
    public void testFindLookupTablesByName() {
        List<LookupTable> lookupTables = lookupManager.findLookupTablesByName("type");
        assertNotNull(lookupTables);
        // only lookupTable records with active='Y' are returned
        assertEquals(1, lookupTables.size());
    }

    @Test
    public void testAddLookupSet() {
        String tableName = "gradetype";
        String description = "Doctorate";
        String title = "Dr.";
        String educationAreaCode = "S";
        String educationLevelCode = "P";

        // code will be created by lookupManager.addLookupSet() method
        List<Lookup9> gradetypes = new ArrayList<>();
        gradetypes.add(new Lookup9("en", null, description, title, educationAreaCode, educationLevelCode));
        gradetypes.add(new Lookup9("pt", null, description, title, educationAreaCode, educationLevelCode));
        lookupManager.addLookupSet(gradetypes, tableName);
        
        Map<String, Object> map = new HashMap<>();
        map.put("description", description);
        map.put("preferredLanguage", "en");
        Lookup9 enGradetype = lookupManager.findLookup(tableName, map);
        map.put("preferredLanguage", "pt");
        Lookup9 ptGradetype = lookupManager.findLookup(tableName, map);

        assertNotNull(enGradetype);
        assertEquals(title, enGradetype.getTitle());
        assertEquals(educationAreaCode, enGradetype.getEducationAreaCode());
        assertEquals(educationLevelCode, enGradetype.getEducationLevelCode());
        assertNotNull(enGradetype.getCode());

        assertNotNull(ptGradetype);
        assertEquals(enGradetype.getCode(), ptGradetype.getCode());
    }
}
