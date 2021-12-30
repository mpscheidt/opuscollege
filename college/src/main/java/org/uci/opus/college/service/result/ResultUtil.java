package org.uci.opus.college.service.result;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Authorization;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.util.StringUtil;

@Service
public class ResultUtil {

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    /**
     * Get the authorization for the given result from the given authorizationMap.
     * 
     * @param result
     * @param authorizationMap
     * @return
     */
    public Authorization getAuthorization(IResult result, Map<String, ? extends Authorization> authorizationMap) {
        Authorization authorization = null;
        if (result != null) {
            String authorizationKey = result.getUniqueKey();
            authorization = authorizationMap == null ? null : authorizationMap.get(authorizationKey);
        }
        return authorization;
    }

    // This is similar to formatDoubleMark(double), which rounds to one decimal digit
    public BigDecimal roundSubjectMark(BigDecimal mark) {
        int scale = appConfigManager.getSubjectResultScale();
        return round(mark, scale);
    }

	/**
	 * If scale is smaller than 0, the given value returns unchanged.
	 * 
	 * @param d
	 *            value to round
	 * @param scale
	 *            number of digits after the comma
	 * @return rounded value, or given value if scale lower than 0
	 */
    public BigDecimal round(BigDecimal d, int scale) {
    	if (scale < 0) {
    		return d;
    	}
    	
        return d.setScale(scale, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * @param results
     *            The given list may have multiple results per subject/examination/test.
     * @return a list with the results that contain the highest marks per subject/examination/test, ordered by subject/examination/test ids.
     */
    public <T extends IResult> List<T> getHighestMarkResults(List<T> results) {

        // natural ordering of the keys is fine, because keys are integers
        SortedMap<Integer, T> idToHighestResultMap = new TreeMap<>();

        for (T r : results) {
            int subExTestId = r.getSubjectExamTestId();
            IResult highestResult = idToHighestResultMap.get(subExTestId);
            if (highestResult == null || new BigDecimal(r.getMark()).compareTo(new BigDecimal(highestResult.getMark())) > 0) {
                idToHighestResultMap.put(subExTestId, r);
            }
        }

        return new ArrayList<>(idToHighestResultMap.values());
    }

    /**
     * This simply converts a string mark to a decimal mark if possible.
     * 
     * NB: This shortcut method only makes sense as long letter grades are not used.
     * 
     * @param mark
     * @return converted mark or null
     */
    public BigDecimal toDecimalMark(String mark) {
		return toDecimalMark(mark, null);
	}

    /**
	 * Convert given mark to BigDecimal. If the given mark can be parsed as
	 * integer or BigDecimal then convert directly, otherwise it is looked up
	 * via endgrades table, e.g. for letter grades like 'A', 'A+'
	 * 
	 * @param mark
	 *            numeric (e.g. 12.5) or letter grade (e.g. A+).
	 * @param allEndGrades
	 *            list of end grades (if null, will not be considered for now)
	 * @return converted mark or null
	 */
	public BigDecimal toDecimalMark(String mark, List<EndGrade> allEndGrades) {
		if (mark == null || "".equals(mark)) {
//		    mark = "0.0";
			return null;
		}
		BigDecimal markDouble = null;
		if (StringUtil.checkValidInt(mark) == -1) {
		    if (StringUtil.checkValidDouble(mark) == -1) {
		    	if (allEndGrades != null) {
			        for (int j = 0; j < allEndGrades.size(); j++) {
			            if (StringUtil.lrtrim(mark).equals(allEndGrades.get(j).getCode())) {
			                markDouble = allEndGrades.get(j).getGradePoint();
			            }
			        }
		    	}
		    } else {
		        markDouble = StringUtil.toBigDecimalMark(mark);
		    }
		} else {
		    int brsPassingSubjectResultInt = Integer.parseInt(mark);
		    markDouble = new BigDecimal(brsPassingSubjectResultInt);
		}
		return markDouble;
	}

}
