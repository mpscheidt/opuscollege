package org.uci.opus.mulungushi.accpac;

import static org.junit.Assert.*;

import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestTemplate;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.mulungushi.data.AccPacDao;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/mulungushi/applicationContext-service.xml"
    })
public class AccPacDaoTest {

    private static final String STUDENT_201404014 = "201404014";
    private static final String STUDENT_201404015 = "201404015";

    private final static String BASE_URL = "/AccPackService/balance/";
    
    private MockRestServiceServer mockServer;

    @Autowired
    private AccPacDao accPacDao;

    @Before
    public void setUp() {
        accPacDao.setUrl(BASE_URL + "{studentCode}");

        RestTemplate restTemplate = accPacDao.getRestTemplate();
        mockServer =  MockRestServiceServer.createServer(restTemplate);
    }

    @Test
    public void testAccPac201404014() {
        mockServer.expect(requestTo(BASE_URL + STUDENT_201404014)).andRespond(withSuccess(AccPacDaoFixture.xml("-5527.500", true, "3150.000", "Nswana Lillian"), MediaType.TEXT_XML));
        StudentBalanceInformation balanceInfo = accPacDao.findBalanceInformationAccPac(STUDENT_201404014);
        assertEquals(true, balanceInfo.getSufficientPaymentsForRegistration());
    }

    @Test
    public void testAccPac201404015() {
        mockServer.expect(requestTo(BASE_URL + STUDENT_201404015)).andRespond(withSuccess(AccPacDaoFixture.xml("0", false, "3150.000", "Mario Ngulu"), MediaType.TEXT_XML));
        StudentBalanceInformation balanceInfo = accPacDao.findBalanceInformationAccPac(STUDENT_201404015);
        assertEquals(false, balanceInfo.getSufficientPaymentsForRegistration());
    }

    @Test
    public void testAccPacEmptyStudentNumber() {
        StudentBalanceInformation balanceInfo = accPacDao.findBalanceInformationAccPac(null);
        assertEquals(false, balanceInfo.getSufficientPaymentsForRegistration());
    }


}
