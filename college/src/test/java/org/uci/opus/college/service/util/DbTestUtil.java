package org.uci.opus.college.service.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DbTestUtil {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void deleteAllInTable(String table) {
        jdbcTemplate.execute("DELETE FROM opuscollege." + table);
    }
    
    public int count(String table) {
        return jdbcTemplate.queryForObject("SELECT count(*) FROM opuscollege." + table, Integer.class);
    }
    
}
