package org.uci.opus.college.service.result;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.result.ResultRounder;
import org.uci.opus.college.service.AppConfigManagerInterface;

/**
 * Set the scale of subject results.
 * 
 * @author markus
 *
 */
@Service
public class SubjectResultRounder implements ResultRounder {

    private AppConfigManagerInterface appConfigManager;
    private ResultUtil resultUtil;

    @Autowired
    public void setAppConfigManager(AppConfigManagerInterface appConfigManager) {
		this.appConfigManager = appConfigManager;
	}

    @Autowired
    public void setResultUtil(ResultUtil resultUtil) {
		this.resultUtil = resultUtil;
	}
    
    @Override
	public BigDecimal roundMark(BigDecimal mark) {
        int scale = appConfigManager.getSubjectResultScale();
        return resultUtil.round(mark, scale);
	}

}
