package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.fixture.InstitutionFixture;
import org.uci.opus.college.persistence.InstitutionMapper;
import org.uci.opus.college.service.fixture.BranchFixtureService;
import org.uci.opus.college.service.fixture.InstitutionFixtureService;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml"
    // entfernen, wenn keine DAOs mehr benoetigt werden
    ,"/org/uci/opus/college/applicationContext-data.xml"
    })
public class InstitutionManagerTest extends OpusDBTestCase {
    
    private Institution ucm, mu, sec1, sec2;
    private Branch ucmFcs;

    @Autowired
    private BranchFixtureService branchFixtureService;
    
    @Autowired
    private InstitutionFixtureService institutionFixtureService;
    
	@Autowired
	private InstitutionManagerInterface institutionManager;
	
	@Autowired
	private InstitutionMapper institutionMapper;

	@Before
	public void setUp() throws Exception {

	    ucm = institutionFixtureService.saveUcm();
	    assertNotEquals(0, ucm.getId());
        mu = institutionFixtureService.saveMu();
        sec1 = institutionFixtureService.saveSec1();
        sec2 = institutionFixtureService.saveSec2();
        
        ucmFcs = branchFixtureService.saveUcmFcs();

	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.institution")
        });
        return dataSetToTruncate;
    }

//    @Override
//    protected IDataSet getDataSet() throws Exception {
//        DataFileLoader loader = new FlatXmlDataFileLoader();
//        return loader.load("/org/uci/opus/college/service/InstitutionManagerTest-prepData.xml");
//    }

    @Test
    public void testFindInstitutions() {
        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_SECONDARY_SCHOOL);
        List<Institution> institutions = institutionManager.findInstitutions(map);
        assertNotNull(institutions);
        assertEquals(2, institutions.size());
        assertEquals(InstitutionFixture.SEC2_DESCRIPTION, institutions.get(0).getInstitutionDescription());
        assertEquals(InstitutionFixture.SEC1_DESCRIPTION, institutions.get(1).getInstitutionDescription());
    }

    @Test
    public void testFindInstitutionOfBranch() {
        int institutionId = institutionManager.findInstitutionOfBranch(ucmFcs.getId());
        assertEquals(ucm.getId(), institutionId);
    }

    @Test
    public void testFindInstitution() {
        Institution institution = institutionManager.findInstitution(ucm.getId());
        assertNotNull(institution);
        assertEquals("UCM", institution.getInstitutionCode());
    }

    @Test
    public void testFindInstitutionByCode() {
        // NB: findInstitutionByCode moved to InstitutionMapper
        Institution institution = institutionMapper.findInstitutionByCode("MU");
        assertNotNull(institution);
        assertNotEquals(0, institution.getId());
    }

    @Test
    public void testAddInstitution() {
        String code = "RU";
        String description = "Radboud University";
        String institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        Institution institution = new Institution(code, description, institutionTypeCode);
        institutionManager.addInstitution(institution);

        Institution loaded = institutionMapper.findInstitutionByCode(code);
        assertNotNull(loaded);
        assertNotEquals(0, loaded.getId());
        assertEquals(code, loaded.getInstitutionCode());
    }

    @Test
    public void testUpdateInstitution() {
        String description = "modified description";

        sec1.setInstitutionDescription(description);
        institutionManager.updateInstitution(sec1);

        Institution loaded = institutionManager.findInstitution(sec1.getId());
        assertEquals(description, loaded.getInstitutionDescription());
    }

    @Test
    public void testDeleteInstitution() {
        int institutionId = 17;
        institutionManager.deleteInstitution(institutionId);
        assertNull(institutionManager.findInstitution(institutionId));
    }

}
