package org.uci.opus.util;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class CompareUtilTest {

    @Test
    public void testCompareString() {
        
        assertTrue(CompareUtil.compare("A", "B") < 0);
        assertTrue(CompareUtil.compare("A", "A") == 0);
        assertTrue(CompareUtil.compare("B", "A") > 0);

        assertTrue(CompareUtil.compare(null, "B") < 0);
        assertTrue(CompareUtil.compare(null, null) == 0);
        assertTrue(CompareUtil.compare("A", null) > 0);
    }

}
