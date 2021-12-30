package org.uci.opus.cbu.data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.beanutils.PropertyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;

public class DimensionsDao {
    
    private static Logger log = LoggerFactory.getLogger(DimensionsDao.class);
    
	private DataSource dataSource;
	
	private boolean postgres = false;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
		
		// For testing outside CBU, use a dummy dimensions database in PostgreSQL
		try {
		    String driverClassName = (String) PropertyUtils.getSimpleProperty(dataSource, "driverClassName");
	        if ("org.postgresql.Driver".equalsIgnoreCase(driverClassName)) {
	            postgres = true;
	        }
	        if (log.isDebugEnabled()) {
	        	log.debug("DimensionsDao.setDataSource postgres = " + postgres);
	        }
		} catch (Exception e) {
		    // no action required
		}
	}
	
	public void testDimensionsView() {
//      String sql = "select * from dbo.AA_SL_TRANSACTION_HEADER_SIMPLE_VIEW where ST_COPYCUST like '10271008'";
        String sql = "select * from dbo.VW_Studentdetail where CUCODE like '10271008'";
//	    String sql = "select 1";
//        String sql = "select distinct ST_USER1 from dbo.AA_SL_TRANSACTION_HEADER_SIMPLE_VIEW";
        JdbcTemplate jdbc=new JdbcTemplate(dataSource);
        List<Map<String,Object>> result=jdbc.queryForList(sql);
        log.info("size: " + result.size());
        for (Map<String,Object> map : result) {
            log.info("----------------------------------------------------");
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                log.info(entry.getKey() + ": " + entry.getValue());
            }
        }
	}
	
	public void test2() {
	    String sql = "SELECT "
            + "*"
            //+  "CUNAME"
            //+ ",CUCODE" // CUCODE
            //+ ",DET_DATE" // DET_DATE
            //+ ",DET_BATCH_REF" // DET_BATCH_REF
            //+ ",DET_TYPE" // DET_TYPE
            //+ ",DET_DESCRIPTION" // DET_DESCRIPTION
            //+ ",DET_NETT" // DET_NETT
            //+ ",CUBALANCE" // CUBALANCE
            + " FROM dbo.\"VW_Studentdetail\" "
            + " WHERE 1=1"
            + " AND CUCODE = " + "'10271008'"
            + " ORDER BY DET_DATE";

        JdbcTemplate jdbc=new JdbcTemplate(dataSource);
        List<Map<String,Object>> result=jdbc.queryForList(sql);
        log.info("size: " + result.size());
        for (Map<String,Object> map : result) {
            log.info("----------------------------------------------------");
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                log.info(entry.getKey() + ": " + entry.getValue());
            }
        }
	}
	
//	public List<Map<String,Object>> findBalanceInformationDimensions(String studentCode) {
//        String sql = "select * from dbo.\"VW_Studentdetail\" where 1=1 AND \"CUCODE\" = '"+studentCode+ "'";
//        JdbcTemplate jdbc=new JdbcTemplate(dataSource);
//        List<Map<String,Object>> result=jdbc.queryForList(sql);
//
//        if (log.isDebugEnabled()) {
//            log.debug("studentCode: " + studentCode + ", number of header records: " + result.size());
//        }
//        
//        return result;
//	}

    public StudentBalanceInformation findBalanceInformationDimensions(String studentCode) {
        StudentBalanceInformation studentBalanceInformation = new StudentBalanceInformation();
        studentBalanceInformation.setStudentCode(studentCode);

        String sql = "exec CBUDIM_ACC.dbo.SP_OPUS_FINANCE "+ studentCode +"";
        
        if (postgres) {
            sql = "select * from dbo.\"SP_OPUS_FINANCE\" where \"StudentID\" = '" + studentCode + "'";
        }
        
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        List<Map<String, Object>> resultList = jdbc.queryForList(sql);
        
        if (resultList != null && !resultList.isEmpty()) {
            Map<String, Object> resultLine = resultList.get(0);

            Double invoicedDouble = (Double) resultLine.get("Invoiced");
            BigDecimal invoicedDecimal = BigDecimal.valueOf(invoicedDouble);
            studentBalanceInformation.setInvoiced(invoicedDecimal);

            Double balanceDouble = (Double) resultLine.get("Balance");
            BigDecimal balanceDecimal = BigDecimal.valueOf(balanceDouble);
            studentBalanceInformation.setBalance(balanceDecimal);

            Double paidPercentageDouble = (Double) resultLine.get("paidPercentage");
            BigDecimal paidPercentageDecimal = BigDecimal.valueOf(paidPercentageDouble);
            studentBalanceInformation.setPaidPercentage(paidPercentageDecimal);

            if (resultList.size() > 1) {
                log.warn("Found more than one results for studentCode=" + studentCode + ": " + resultList.size() + " results found. Ignoring all but first result.");
            }
        }

        return studentBalanceInformation;
    }

/*	public List<Map<String,Object>> findInvoiceInformationDimensions(String studentCode) { // TODO add time period: for semesters different!
	    int currYear = Calendar.getInstance().get(Calendar.YEAR);
	    int subsequentYear = currYear + 1;
        
	    String sql = "select * from dbo.\"VW_Studentdetail\" where \"CUCODE\" = '" + studentCode
        + "' AND \"ST_TRANTYPE\" = 'INV' AND \"ST_DATE\" >= '01/01/"+ currYear + "' AND \"ST_DATE\" < '01/01/" + subsequentYear + "'";
        JdbcTemplate jdbc=new JdbcTemplate(dataSource);
        List<Map<String,Object>> result=jdbc.queryForList(sql);

        if (log.isDebugEnabled()) {
            log.debug("studentCode: " + studentCode + ", number of invoice records for year " + currYear + ": " + result.size());
        }

        return result;
    }*/
    
    public String findAdmissionPaymentInformation(String identificationNumber) {

        String sql = "exec CBUDIM_ACC.dbo.SP_OPUS_FINANCE_ADMISSION '"+ identificationNumber +"'";

        if (postgres) {
            sql = "select * from dbo.\"SP_OPUS_FINANCE_ADMISSION\" where \"IDNumber\" = '" + identificationNumber + "'";
        }

        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        List<Map<String, Object>> resultList = jdbc.queryForList(sql);

        String applicationType = null;
        if (resultList != null && !resultList.isEmpty()) {
            Map<String, Object> resultLine = resultList.get(0);

            applicationType = (String) resultLine.get("ApplicationType");

            if (resultList.size() > 1) {
                log.warn("Found more than one results for identificationNumber=" + identificationNumber + ": " + resultList.size() + " results found. Ignoring all but first result.");
            }
        }

        return applicationType;
    }
    
}
