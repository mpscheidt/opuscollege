package org.uci.opus.unza.service.extension;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.service.extpoint.ISponsorInvoiceNumberGenerator;
import org.uci.opus.unza.service.UnzaManagerInterface;
import org.uci.opus.util.StringUtil;

@Service
public class SponsorInvoiceNumberGenerator implements ISponsorInvoiceNumberGenerator {

    private static final String INITIAL_RUNNING_NUMBER = "0001";
    
    private static final Logger log = Logger.getLogger(SponsorInvoiceNumberGenerator.class);
    
    @Autowired private UnzaManagerInterface unzaManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;

    @Override
    public void generateSponsorInvoiceNumber(SponsorInvoice sponsorInvoice, int academicYearId) {
        
        String invoiceNumber = null;

        AcademicYear academicYear = academicYearManager.findAcademicYear(academicYearId);
        String year = academicYear.getDescription();
        String prefix = "INV" + year;   // example invoice number: INV20130001, INV20130002, INV20130003
        String highestInvoiceNumber = unzaManager.findHighestSponsorInvoiceNumber(prefix);;
        String newRunningNumber = null;
        if (highestInvoiceNumber == null) {
            newRunningNumber = INITIAL_RUNNING_NUMBER;
        } else {
            String highestRunningNumber = highestInvoiceNumber.substring(prefix.length());
            try {
                int currRunningNrInt = Integer.parseInt(highestRunningNumber);
                String newRunningNr = String.valueOf(currRunningNrInt + 1);
                // running number has to have 4 digits, eventually starting with zeroes 
                newRunningNumber = StringUtil.prefixChars(newRunningNr, INITIAL_RUNNING_NUMBER.length(), '0');
            } catch (Exception e) {
                log.warn("sponsor invoice number is somehow wrong - current highest application number used in student codes for year " + year + ": " + highestRunningNumber);
                newRunningNumber = INITIAL_RUNNING_NUMBER;
            }
        }

        invoiceNumber = prefix + newRunningNumber;
        
        sponsorInvoice.setInvoiceNumber(invoiceNumber);
    }

}
