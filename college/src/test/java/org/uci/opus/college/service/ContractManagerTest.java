package org.uci.opus.college.service;

import java.util.HashMap;
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
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.fixture.ContractFixture;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ContractManagerTest extends OpusDBTestCase {

	@Autowired
	private ContractManagerInterface contractManager;
	
    // staffMemberId according to ContractManagerTest-prepData.xml
	private Contract full = ContractFixture.full(19);
	private Contract partial = ContractFixture.partial(19);

	@Before
	public void setUp() throws Exception {
		
	    contractManager.addContract(this.full);
		contractManager.addContract(this.partial);
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.contract"),
                new DefaultTable("opuscollege.studyplan"),
                new DefaultTable("opuscollege.branchacademicyeartimeunit")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/ContractManagerTest-prepData.xml");
    }

    @Test
    public void testFindOne() {

        Map<String, Object> findContractMap = new HashMap<>();
        findContractMap.put("contractCode", this.full.getContractCode());
        findContractMap.put("contractTypeCode", this.full.getContractTypeCode());
        findContractMap.put("contractDurationCode", this.full.getContractDurationCode());
        findContractMap.put("contractStartDate", this.full.getContractStartDate());
        Contract loadedFull = contractManager.findContractByParams(findContractMap);
        assertNotNull(loadedFull);
        assertEquals(full.getContractCode(), loadedFull.getContractCode());
        assertEquals(full.getContractTypeCode(), loadedFull.getContractTypeCode());
        assertEquals(full.getContractDurationCode(), loadedFull.getContractDurationCode());
        assertEquals(full.getContractStartDate(), loadedFull.getContractStartDate());
        assertEquals(full.getStaffMemberId(), loadedFull.getStaffMemberId());

        Contract loadedById = contractManager.findContract(loadedFull.getId());
        assertNotNull(loadedById);
        assertEquals(full.getContractCode(), loadedById.getContractCode());
        
    }
    
}
