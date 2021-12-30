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
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class AddressManagerTest extends OpusDBTestCase {

	@Autowired
	private AddressManagerInterface addressManager;
	
	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.appconfig"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.address"),
                new DefaultTable("opuscollege.student")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/AddressManagerTest-prepData.xml");
    }

    @Test
    public void testPersonAddress() {
    	Address personAddress = addressManager.findAddress(1);
    	assertEquals("Home drive", personAddress.getStreet());
    	assertEquals(5, personAddress.getNumber());
    	assertEquals("8160", personAddress.getZipCode());
    	assertEquals("AT", personAddress.getCountryCode());
    }
    
	private void addHomeAddress() {
		Address a = new Address();
    	a.setAddressTypeCode(OpusConstants.HOME_ADDRESS);
    	a.setPersonId(16);
    	a.setCountryCode("AT");
    	a.setProvinceCode("0");
    	a.setDistrictCode("0");
    	addressManager.addAddress(a);
	}

    @Test
    public void testAddPersonHomeAddress() {

    	addHomeAddress();
 
    	Address loadedAddress = addressManager.findAddressByPersonId(OpusConstants.HOME_ADDRESS, 16);
		assertNotNull(loadedAddress);
		assertEquals("AT", loadedAddress.getCountryCode());

    }

    @Test
	public void testFindAddressesForStaffmember() {
    	
    	addHomeAddress();
    	
		Map<String, Object> map = new HashMap<>();
		map.put("entity", "staffmember");
		map.put("id", 16);
		List<Address> addresses = addressManager.findAddressesForEntity(map);
		assertEquals(2, addresses.size());
	}
    
    @Test
    public void testUnboundAddressesForStaffmember() {
		Map<String, Object> map = new HashMap<>();
        map.put("tableName", "addressType");
		map.put("entity", "staffmember");
		map.put("id", 16);
    	List<Lookup> addressTypes = addressManager.findUnboundAddressTypes(map);
    	assertEquals(1, addressTypes.size());
    }
    
    @Test
    public void testStudyAddress() {
    	Address address = addressManager.findAddressByStudyId(OpusConstants.FORMAL_ADDRESS_STUDY, 38);
    	assertNotNull(address);
    	assertEquals("University lane", address.getStreet());
    }

}
