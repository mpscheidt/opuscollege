package org.uci.opus.mulungushi.service;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentPaymentChecker;

@Service
public class MulungushiStudentPaymentChecker {
    
    private Logger log = LoggerFactory.getLogger(MulungushiStudentPaymentChecker.class);
    
    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private StudentPaymentChecker studentPaymentChecker;

    // fixedDelay in ms: e.g. 5000 = 5 seconds, 300000 = 5 minutes
    @Scheduled(fixedDelay=300000)
    public void runStudentPaymentCheck() {
        log.info("Starting periodic student payment check");

        AcademicYear currentAcademicYear = academicYearManager.getCurrentAcademicYear();
        if (currentAcademicYear == null) {
            log.warn("No current academic year defined for today's date: " + new Date());
            return;
        }

        int academicYearId = currentAcademicYear.getId();
        studentPaymentChecker.checkSufficientPaymentsForRegistration(academicYearId);
    }
}
