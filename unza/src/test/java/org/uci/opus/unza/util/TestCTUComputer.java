package org.uci.opus.unza.util;

import java.util.HashMap;
import java.util.Map;

public class TestCTUComputer {
	public static void main(){
		CTUComputer ctu = new CTUComputer();
		Map<String,Object> stdRecord = new HashMap<String, Object>();
		stdRecord.put("ayear", "20101");
		stdRecord.put("yrofpgm", "3");
		System.out.print(ctu.getAcademicYearSemester(stdRecord));
	}

}
