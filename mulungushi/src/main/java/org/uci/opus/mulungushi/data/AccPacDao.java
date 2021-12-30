package org.uci.opus.mulungushi.data;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.RestTemplate;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;

public class AccPacDao {

    private String url;
    private RestTemplate restTemplate = new RestTemplate();

    private static Logger log = LoggerFactory.getLogger(AccPacDao.class);
    
	public void testAccPac(String studentCode) {
	    
	    AccPacStudentBalance result = getRestTemplate().getForObject(url, AccPacStudentBalance.class, studentCode);
        log.info("result: " + result);
	}

	/**
	 * Returns the {@link StudentBalanceInformation} object for the given student
	 * with the {@link StudentBalanceInformation#getSufficientPaymentsForRegistration()} flag.
	 * @param studentCode
	 * @return
	 */
    public StudentBalanceInformation findBalanceInformationAccPac(String studentCode) {
        StudentBalanceInformation studentBalanceInformation = new StudentBalanceInformation();
        studentBalanceInformation.setStudentCode(studentCode);

        AccPacStudentBalance result = null;
        if (studentCode != null && !studentCode.isEmpty()) {
            result = getRestTemplate().getForObject(url, AccPacStudentBalance.class, studentCode);
            if (log.isDebugEnabled()) {
                log.debug("AccPac student balance information for " + studentCode + ":" + result);
            }
        }

        boolean canregister = result != null && result.getCanRegisterFlag();
        studentBalanceInformation.setSufficientPaymentsForRegistration(canregister);

        return studentBalanceInformation;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public RestTemplate getRestTemplate() {
        return restTemplate;
    }

    public void setRestTemplate(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

}
