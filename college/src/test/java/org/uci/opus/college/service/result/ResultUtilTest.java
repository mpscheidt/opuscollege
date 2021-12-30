package org.uci.opus.college.service.result;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.domain.result.ExaminationResult;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ResultUtilTest {
    
    @Autowired
    private ResultUtil resultUtil;

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testGetHighestMarkResults() {
        
        // Create a results array for 3 examinations with some duplicate results per examination, in a random order
        List<ExaminationResult> results = Arrays.asList(
                new ExaminationResult(3, 3, 3, 3, "3.8", "N"),
                new ExaminationResult(3, 3, 3, 3, "3.1", "N"),
                new ExaminationResult(2, 2, 2, 2, "2", "N"),
                new ExaminationResult(1, 1, 1, 1, "1.2", "N"),
                new ExaminationResult(1, 1, 1, 1, "1.7", "N")
                );
        
        List<ExaminationResult> highest = resultUtil.getHighestMarkResults(results);

        assertEquals(3, highest.size());

        // expected order is by examinationId
        assertEquals("1.7", highest.get(0).getMark());
        assertEquals("2", highest.get(1).getMark());
        assertEquals("3.8", highest.get(2).getMark());
    }

}
