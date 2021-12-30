package org.uci.opus.unza.dbconversion;


import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;

public class UnzaAccommodationMigrator {
    private static Logger log = Logger.getLogger(UnzaOrganizationalUnitMigrator.class);
    private DataSource srsDataSource;
    private DataSource opusDataSource;
    @Autowired 
    private BranchManagerInterface bManager;
    @Autowired
    private InstitutionManagerInterface iManager;
    public DataSource getSrsDataSource(){
        return srsDataSource;
    }
    public DataSource getOpusDataSource(){
        return opusDataSource;
    }
    public void setSrsDataSource(DataSource srsDataSource){
        this.srsDataSource=srsDataSource;
    }
    public void setOpusDataSource(DataSource opusDataSource){
        this.opusDataSource=opusDataSource;
    }
    public void migrateHostels(){
        JdbcTemplate srsStageTemplate = new JdbcTemplate(srsDataSource);
        List<Map<String,Object>> hostelList = srsStageTemplate.queryForList("select * from srsystem.hostel");

        JdbcTemplate opusTemplate = new JdbcTemplate(opusDataSource);

        for(Map<String,Object> hostel : hostelList){
            String hostelStudid = (String)hostel.get("studid");
            if (hostelStudid == null){
                hostelStudid="***";
            }

            String hostelAyear = ((Short)hostel.get("ayear")).toString();
            if (hostelAyear == null){
                hostelAyear="***";
            }

            String hostelCode = (String)hostel.get("code");
            if (hostelCode == null){
                hostelCode="***";
            }

            String hostelBlock = (String)hostel.get("block");
            if (hostelBlock == null){
                hostelBlock="***";
            }

            String hostelRoom = (String)hostel.get("room");
            if (hostelRoom == null){
                hostelRoom="***";
            }
            opusTemplate.update("INSERT INTO srsdatastage.hostel VALUES(?,?,?,?,?)", new Object[]{hostelStudid,hostelAyear,hostelCode,hostelBlock,hostelRoom});
        }
    }

    public void migrateHostMax(){
        JdbcTemplate srsStageTemplate = new JdbcTemplate(srsDataSource);
        List<Map<String,Object>> hostmaxList = srsStageTemplate.queryForList("select * from srsystem.hostmax");

        JdbcTemplate opusTemplate = new JdbcTemplate(opusDataSource);

        for(Map<String,Object> hostmax : hostmaxList){


            String hostelCode = (String)hostmax.get("code");
            if (hostelCode == null){
                hostelCode="***";
            }

            String hostelBlock = (String)hostmax.get("block");
            if (hostelBlock == null){
                hostelBlock="***";
            }

            String hostelRoom = (String)hostmax.get("room");
            if (hostelRoom == null){
                hostelRoom="***";
            }

            String hostelMaxno = (String)hostmax.get("maxno");
            if (hostelMaxno == null){
                hostelMaxno="***";
            }

            opusTemplate.update("INSERT INTO srsdatastage.hostmax VALUES(?,?,?,?)", new Object[]{hostelCode,hostelBlock,hostelRoom,hostelMaxno});
        }
    }

    public void migrateHostCode(){
        JdbcTemplate srsStageTemplate = new JdbcTemplate(srsDataSource);
        List<Map<String,Object>> hostcodeList = srsStageTemplate.queryForList("select * from srsystem.hostcode");

        JdbcTemplate opusTemplate = new JdbcTemplate(opusDataSource);

        for(Map<String,Object> hostcode : hostcodeList){


            String hostelName = (String)hostcode.get("hname");
            if (hostelName == null){
                hostelName="***";
            }

            String hostelFullname = (String)hostcode.get("fullname");
            if (hostelFullname == null){
                hostelFullname="***";
            }


            opusTemplate.update("INSERT INTO srsdatastage.hostcode VALUES(?,?)", new Object[]{hostelName,hostelFullname});
        }
    }
}

