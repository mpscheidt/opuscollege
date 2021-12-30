package org.uci.opus.college.service.factory;

import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.EndGrade;

@Service
public class EndGradeFactory {

	/**
	 * Create a new {@link EndGrade} for a given academic year, which - except for the academicYearId - has
	 * the same properties as the given end grade.
	 * 
	 * Note that the <code>writewho</code> property is not set.
	 * 
	 * @param origEndGrade
	 * @param academicYearId
	 * @return
	 */
	public EndGrade newEndGrade(EndGrade origEndGrade, int academicYearId) {
		EndGrade newEndGrade = new EndGrade();
		newEndGrade.setAcademicYearId(academicYearId);
		newEndGrade.setActive(origEndGrade.getActive());
		newEndGrade.setCode(origEndGrade.getCode());
		newEndGrade.setComment(origEndGrade.getComment());
		newEndGrade.setDescription(origEndGrade.getDescription());
		newEndGrade.setEndGradeTypeCode(origEndGrade.getEndGradeTypeCode());
		newEndGrade.setGradePoint(origEndGrade.getGradePoint());
		newEndGrade.setLang(origEndGrade.getLang().trim());
		newEndGrade.setPassed(origEndGrade.getPassed());
		newEndGrade.setPercentageMax(origEndGrade.getPercentageMax());
		newEndGrade.setPercentageMin(origEndGrade.getPercentageMin());
		newEndGrade.setTemporaryGrade(origEndGrade.getTemporaryGrade());
		return newEndGrade;
	}

}
