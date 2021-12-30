package org.uci.opus.college.persistence;

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
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.fixture.DisciplineGroupFixture;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-util.xml", "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/college/applicationContext-data.xml" })
public class DisciplineGroupMapperTest extends OpusDBTestCase {

    @Autowired
    private DisciplineGroupMapper disciplineGroupMapper;

    private DisciplineGroup disciplineGroup1;
    private DisciplineGroup disciplineGroup2;

    private int id1;
    private int id2;

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.disciplinegroup")
        });
        return dataSetToTruncate;
    }

    // NB: @Before method in superclass is guaranteed to be executed before this one
    @Before
    public void setUp() throws Exception {

        disciplineGroup1 = DisciplineGroupFixture.disciplineGroup1();
        disciplineGroup2 = DisciplineGroupFixture.disciplineGroup2();
        disciplineGroupMapper.add(disciplineGroup1);
        disciplineGroupMapper.add(disciplineGroup2);

        id1 = disciplineGroup1.getId();
        id2 = disciplineGroup2.getId();

        assertNotEquals(0, id1);
        assertNotEquals(0, id2);
    }

    @Test
    public void testFindById() {

        DisciplineGroup loaded1 = disciplineGroupMapper.findById(id1);
        assertDisciplineGroup(disciplineGroup1, loaded1);

        DisciplineGroup loaded2 = disciplineGroupMapper.findById(id2);
        assertDisciplineGroup(disciplineGroup2, loaded2);

    }

    private void assertDisciplineGroup(DisciplineGroup expected, DisciplineGroup loaded1) {
        assertEquals(expected.getCode(), loaded1.getCode());
        assertEquals(expected.getDescription(), loaded1.getDescription());
    }

    @Test
    public void testFindByCode() {
        assertDisciplineGroup(disciplineGroup1, disciplineGroupMapper.findByCode(DisciplineGroupFixture.CODE1));
        assertDisciplineGroup(disciplineGroup2, disciplineGroupMapper.findByCode(DisciplineGroupFixture.CODE2));
    }

    @Test
    public void testFindDisciplineGroupsWithMap() {
        
        Map<String, Object> map = new HashMap<>();
        map.put("searchValue", "One");
        List<DisciplineGroup> dgs = disciplineGroupMapper.findDisciplineGroups(map);
        assertEquals(1, dgs.size());
        assertDisciplineGroup(disciplineGroup1, dgs.get(0));
        
    }

    @Test
    public void testFindDisciplineGroupsWithSearchValue() {
        
        List<DisciplineGroup> dgs = disciplineGroupMapper.findDisciplineGroups("Two", null);
        assertEquals(1, dgs.size());
        assertDisciplineGroup(disciplineGroup2, dgs.get(0));
        
    }

    @Test
    public void testDeleteById() {
        
        disciplineGroupMapper.deleteById(id1);
        
        List<DisciplineGroup> dgs = disciplineGroupMapper.findDisciplineGroups(null);
        assertEquals(1, dgs.size());
        assertDisciplineGroup(disciplineGroup2, dgs.get(0));
        
    }

    @Test
    public void testUpdate() {
        
        disciplineGroup1.setDescription("other desc");
        disciplineGroupMapper.update(disciplineGroup1);
        
        DisciplineGroup loaded1 = disciplineGroupMapper.findByCode(DisciplineGroupFixture.CODE1);
        assertDisciplineGroup(disciplineGroup1, loaded1);
    }

    @Test
    public void testAdd() {
        
        String code = "NDG";
        String description = "new discipline group";
        DisciplineGroup newDg = new DisciplineGroup(code, description);
        disciplineGroupMapper.add(newDg);
        assertNotEquals(0, newDg.getId());
        
        DisciplineGroup loaded = disciplineGroupMapper.findByCode(code);
        assertDisciplineGroup(newDg, loaded);
        
    }

}
