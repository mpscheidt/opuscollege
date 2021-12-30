package org.uci.opus.scholarship.util;

public class ScholarshipApplicationUtil {

/*    public static String calculateLatePayment(SponsorPayment sponsorPayment){
           String latePayment = "N";
		   DateUtil du = new DateUtil();
		   Date paymentDueDate=sponsorPayment.getPaymentDueDate();
	       Date paymentReceivedDate =sponsorPayment.getPaymentReceivedDate(); 
	       if(paymentDueDate!=null){
	        	if(paymentReceivedDate==null){
	        		if(du.isPastDate(paymentDueDate)){
	        			latePayment = "Y";
	        		}
	        			
	        	}
	        	else{
	        		if(paymentReceivedDate.getTime() > paymentDueDate.getTime()){
	        			latePayment = "Y";
	        		}
	        	}
	        }
	        return latePayment;
	}

    public static List<SponsorPayment> findMissingSponsorPayments(ScholarshipApplication scholarshipApplication,List <? extends StudyGradeType> studyGradeTypesForStudyPlan, int validFromYear, int validUntilYear, List <AcademicYear> allAcademicYears){
		ArrayList <SponsorPayment> missingSponsorPayments = new ArrayList<SponsorPayment>();
		boolean found = false;
		int academicYear = 0;
		for(StudyGradeType studyGradeType:studyGradeTypesForStudyPlan){
			academicYear = Integer.parseInt(AcademicYearUtil.getAcademicYearById(allAcademicYears, studyGradeType.getCurrentAcademicYearId()).getDescription());
			if(academicYear >= validFromYear && academicYear <= validUntilYear){
				found = false;
				if (scholarshipApplication.getSponsorPayments() != null) {
					for(SponsorPayment sponsorPayment: scholarshipApplication.getSponsorPayments()){
						if(sponsorPayment.getAcademicYearId()==studyGradeType.getCurrentAcademicYearId()){
							found = true;
							break;
						}	
					}
					if(!found){
						SponsorPayment sponsorPayment = new SponsorPayment();
						sponsorPayment.setAcademicYearId(studyGradeType.getCurrentAcademicYearId());
						sponsorPayment.setScholarshipApplicationId(scholarshipApplication.getId());
						missingSponsorPayments.add(sponsorPayment);
					}
				}
			}
		}
		return missingSponsorPayments;
	}
	public static List<SponsorPayment> findSponsorPaymentsToDelete(ScholarshipApplication scholarshipApplication,List <? extends StudyGradeType> studyGradeTypesForStudyPlan, int validFromYear, int validUntilYear, List <AcademicYear> allAcademicYears){
		ArrayList <SponsorPayment> sponsorPaymentsToDelete = new ArrayList<SponsorPayment>();
		int academicYear = 0;
		for(StudyGradeType studyGradeType:studyGradeTypesForStudyPlan){
			academicYear = Integer.parseInt(AcademicYearUtil.getAcademicYearById(allAcademicYears, studyGradeType.getCurrentAcademicYearId()).getDescription());
			if(academicYear < validFromYear || academicYear > validUntilYear){
				if (scholarshipApplication.getSponsorPayments() != null) {
					for(SponsorPayment sponsorPayment: scholarshipApplication.getSponsorPayments()){
						if(sponsorPayment.getAcademicYearId()==studyGradeType.getCurrentAcademicYearId()){
							sponsorPaymentsToDelete.add(sponsorPayment);
						}	
					}
				}
			}
		}
		return sponsorPaymentsToDelete;
	}	*/
}
