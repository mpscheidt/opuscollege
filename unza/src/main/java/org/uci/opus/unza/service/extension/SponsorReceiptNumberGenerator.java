package org.uci.opus.unza.service.extension;

import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.service.extpoint.ISponsorReceiptNumberGenerator;
import org.uci.opus.unza.service.UnzaManagerInterface;
import org.uci.opus.util.StringUtil;

@Service
public class SponsorReceiptNumberGenerator implements ISponsorReceiptNumberGenerator {

    private static final String INITIAL_RUNNING_NUMBER = "0001";
    
    private static final Logger log = Logger.getLogger(SponsorReceiptNumberGenerator.class);
    
    @Autowired private UnzaManagerInterface unzaManager;

    @Override
    public void generateSponsorReceiptNumber(SponsorPayment sponsorPayment) {
        Date paymentReceivedDate = sponsorPayment.getPaymentReceivedDate();
        if (paymentReceivedDate == null) {
            if (log.isDebugEnabled()) {
                log.debug("Cannot create receipt number: paymentReceivedDate must not be null in order to create automatic sponsor receipt number");
            }
            return;
        }
        
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(paymentReceivedDate);
        int year = calendar.get(Calendar.YEAR);
        String prefix = "RCT" + year;   // example invoice number: RCT20130001, RCT20130002, RCT20130003
        String highestReceiptNumber = unzaManager.findHighestSponsorReceiptNumber(prefix);;
        String newRunningNumber = null;
        if (highestReceiptNumber == null) {
            newRunningNumber = INITIAL_RUNNING_NUMBER;
        } else {
            String highestRunningNumber = highestReceiptNumber.substring(prefix.length());
            try {
                int currRunningNrInt = Integer.parseInt(highestRunningNumber);
                String newRunningNr = String.valueOf(currRunningNrInt + 1);
                // running number has to have 4 digits, eventually starting with zeroes 
                newRunningNumber = StringUtil.prefixChars(newRunningNr, INITIAL_RUNNING_NUMBER.length(), '0');
            } catch (Exception e) {
                log.warn("sponsor receipt number is somehow wrong - current highest application number used in student codes for year " + year + ": " + highestRunningNumber);
                newRunningNumber = INITIAL_RUNNING_NUMBER;
            }
        }

        String receiptNumber = prefix + newRunningNumber;
        
        sponsorPayment.setReceiptNumber(receiptNumber);
    }

}
