package org.uci.opus.college.domain.result;

import java.math.BigDecimal;

/**
 * Rounding (setting the scale) interface for subject results, examination results etc.,
 * taking into account rounding rules that apply to the specific kind of result and possibly its context.
 * 
 * @author markus
 *
 */
public interface ResultRounder {

	BigDecimal roundMark(BigDecimal mark); 

}
