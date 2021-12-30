package org.uci.opus.college.persistence;

import java.util.List;

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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Penalty;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class PenaltyMapperTest extends OpusDBTestCase {

    private static final String PENALTYTYPE_1_PT = "pt: Late cardinal time-unit registration";
    private static final String PENALTY_1_REMARK = "R1";

    @Autowired
    private PenaltyMapper penaltyMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/PenaltyMapperTest-prepData.xml");
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { 
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"), 
                new DefaultTable("opuscollege.organizationalunit"), 
                new DefaultTable("opuscollege.classgroup"),
                new DefaultTable("opuscollege.examination"), 
                new DefaultTable("opuscollege.subjectclassgroup"),
                new DefaultTable("opuscollege.studyplan")
                });
        return dataSetToTruncate;
    }

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void findPenalty() {

        Penalty penalty = penaltyMapper.findPenalty(1, PT);
        assertEquals(1982, penalty.getStudentId());
        assertEquals(PENALTYTYPE_1_PT, penalty.getPenaltyType().getDescription());
        assertEquals(11.7, penalty.getAmount());
        assertEquals(PENALTY_1_REMARK, penalty.getRemark());
    }

    @Test
    public void findPenalties() {
        
        List<Penalty> penalties = penaltyMapper.findPenalties(1982, EN);
        assertEquals(2, penalties.size());
        assertEquals(1, penalties.get(0).getId());
        assertEquals(2, penalties.get(1).getId());
    }
    
    @Test
    public void addPenalty() {
        
        Lookup penaltyType = new Lookup(PT, "1", PENALTYTYPE_1_PT);
        penaltyType.setId(1);

        Penalty penalty = new Penalty(1993, penaltyType);
        penaltyMapper.addPenalty(penalty);
        assertEquals(2, penaltyMapper.findPenalties(1993, EN).size());
    }

    @Test
    public void updatePenalty() {
        
        Penalty penalty = penaltyMapper.findPenalty(2, PT);
        double amount = 111.11;
        penalty.setAmount(amount);
        penaltyMapper.updatePenalty(penalty);
        
        penalty = penaltyMapper.findPenalty(2, EN);
        assertEquals(amount, penalty.getAmount());
    }
    
    @Test
    public void deletePenalty() {
        
        penaltyMapper.deletePenalty(2);
        
        List<Penalty> penalties = penaltyMapper.findPenalties(1982, EN);
        assertEquals(1, penalties.size());
        assertEquals(1, penalties.get(0).getId());
    }

    @Test
    public void deletePenalties() {

        penaltyMapper.deletePenalties(1982);
        assertEquals(0, penaltyMapper.findPenalties(1982, PT).size());
        
    }
    
}
