package org.uci.opus.util;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class EncodeTest {

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testEncodeMd5() {
        
        assertEquals("61fac139ceb3daf388648eada1b1371d", Encode.encodeMd5("0F5DD14AE2E38C7EBD8814D29CF6F6F0705120131"));
        
    }

    @Test
    public void testEncodeMd5_HashWithLeadingZero() {

        // compare with postgres select md5() output (and PHP's md5 output according to Simone), which gives a leading zero
        assertEquals("04de05dd7dce58b54378f71b75e0a308", Encode.encodeMd5("0F5DD14AE2E38C7EBD8814D29CF6F6F0705160134"));
        assertEquals("02c987be7679aa5eca8f2d672452ff7e", Encode.encodeMd5("0F5DD14AE2E38C7EBD8814D29CF6F6F0705160339"));
        
    }

}
