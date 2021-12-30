package org.uci.opus.college.service;

import java.text.ParseException;
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
import org.uci.opus.college.domain.Person;
import org.uci.opus.util.DateUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class PersonManagerTest extends OpusDBTestCase {

	@Autowired
	private PersonManagerInterface personManager;

	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.person"),
                new DefaultTable("opuscollege.academicyear")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/PersonManagerTest-prepData.xml");
    }

    @Test
    public void testFindPersonById() {
        Person person = personManager.findPersonById(17);
        assertNotNull(person);
        assertEquals("Alexander", person.getSurnameFull());
    }
    
    @Test
    public void testFindPersonByCode() {
        Person person = personManager.findPersonByCode("71");
        assertNotNull(person);
        assertEquals("Hesse", person.getSurnameFull());
    }
    
    @Test
    public void testFindAllDirectors() {
        List<? extends Person> persons = personManager.findAllDirectors(107);
        assertNotNull(persons);
        assertEquals(2, persons.size());
    }
    
    @Test
    public void testFindDirectors() {
        Map<String, Object> map = new HashMap<>();
        map.put("institutionId", 107);
        map.put("branchId", 0);
        map.put("organizationalUnitId", 0);
        List<? extends Person> persons = personManager.findDirectors(map);
        assertNotNull(persons);
        assertEquals(2, persons.size());

        map.put("organizationalUnitId", 19);
        persons = personManager.findDirectors(map);
        assertEquals(1, persons.size());
    }

    @Test
    public void testAddPerson() throws ParseException {
        Person person = new Person("123", "last", "first", DateUtil.parseIsoDate("1970-01-01"));
        personManager.addPerson(person);
        assertTrue(person.getId() != 0);
    }

    @Test
    public void testUpdatePerson() {
        int personId = 26;
        String surnameAlias = "hehe";

        Person person = personManager.findPersonById(personId);
        person.setSurnameAlias(surnameAlias);
        personManager.updatePerson(person);
        
        person = personManager.findPersonById(personId);
        assertEquals(surnameAlias, person.getSurnameAlias());
    }
    
    @Test
    public void testUpdatePersonPhoto() {
        int personId = 26;
        byte[] photo = new byte[] { 1, 2 };

        Person person = personManager.findPersonById(personId);
        person.setPhotograph(photo);
        personManager.updatePersonPhotograph(person);

        person = personManager.findPersonById(personId);
        assertEquals(photo[0], person.getPhotograph()[0]);
        assertEquals(photo[1], person.getPhotograph()[1]);
    }
    
    @Test
    public void testDeletePerson() {
        int personId = 26;
        personManager.deletePerson(personId, "unittest");
        assertNull(personManager.findPersonById(personId));
    }

    @Test
    public void testIsStaffMember() {
        assertTrue(personManager.isStaffMember(16));
        assertFalse(personManager.isStaffMember(26));
    }

    @Test
    public void testIsSudent() {
        assertFalse(personManager.isStudent(16));
        assertTrue(personManager.isStudent(26));
    }

}
