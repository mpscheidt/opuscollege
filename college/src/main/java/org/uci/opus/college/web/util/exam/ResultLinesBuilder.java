/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 */

package org.uci.opus.college.web.util.exam;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.LimitedStudyPlanAndStudent;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.persistence.StudyplanMapper;
import org.uci.opus.util.OpusInit;

public abstract class ResultLinesBuilder<R extends IResult, L extends ResultLine<R>, T extends List<L>> {

	@Autowired
	private StudyplanMapper studyplanMapper;

	@Autowired
	private OpusInit opusInit;

	List<StudyPlanDetail> allStudyPlanDetails;

	private T resultLines;
	private String preferredPersonSorting;

	private Map<Integer, LimitedStudyPlanAndStudent> studyPlanAndStudentMap;

	public ResultLinesBuilder() {
		resultLines = newResultLines();
	}
	
	@PostConstruct
	public void postConstruct() {
		this.preferredPersonSorting = opusInit.getPreferredPersonSorting();
	}

	protected abstract T newResultLines();

	public void build() {
        if (allStudyPlanDetails != null && allStudyPlanDetails.size() > 0) {
        	// fetch all relevant studyplans and students to avoid many round trips to the DB
        	List<Integer> studyPlanIds = DomainUtil.getIntProperties(allStudyPlanDetails, "studyPlanId");
        	List<LimitedStudyPlanAndStudent> limitedStudyPlanAndStudents = studyplanMapper.findLimitedStudyPlanAndStudent(studyPlanIds);
        	studyPlanAndStudentMap = limitedStudyPlanAndStudents.stream().collect(Collectors.toMap(
        			s -> s.getStudyPlanId(), s -> s));

            for (Iterator<StudyPlanDetail> it = allStudyPlanDetails.iterator(); it.hasNext(); ) {
                StudyPlanDetail sdp = it.next();
                L line = buildLine(sdp);
                // add line after setting properties so that comparator can sort
                resultLines.add(line);
            }
            ResultsBuilderComparator comparator = new ResultsBuilderComparator(preferredPersonSorting);
            Collections.sort(resultLines, comparator);
        }
    }

	/**
	 * This method implements the creation of a new line. Inherit to add custom
	 * functionality.
	 * 
	 * @param sdp
	 * @return a line to be added to 'allLines'.
	 */
	protected L buildLine(StudyPlanDetail sdp) {
		int studyPlanDetailId = sdp.getId();

		// create a new line for display
		L line = makeNewResultLine(); // factory method
		line.setExempted(sdp.isExempted());

		List<R> results = findResults(studyPlanDetailId);
		line.setResults(results);

		// String studyPlanDescription =
		// calcStudyPlanDescription(sdp.getStudyPlanId());
//		StudyPlan studyPlan = studentManager.findStudyPlan(sdp.getStudyPlanId());
//		line.setStudyPlanStatusCode(studyPlan.getStudyPlanStatusCode());
//		line.setStudyPlanDescription(studyPlan.getStudyPlanDescription());
		LimitedStudyPlanAndStudent s = studyPlanAndStudentMap.get(sdp.getStudyPlanId());
		line.setStudyPlanStatusCode(s.getStudyPlanStatusCode());
		line.setStudyPlanDescription(s.getStudyPlanDescription());

//		Student st = studentManager.findStudent(null, studyPlan.getStudentId());
//		line.setSurnameFull(st.getSurnameFull());
//		line.setFirstnamesFull(st.getFirstnamesFull());
//		line.setStudentId(st.getStudentId());
//		line.setStudentCode(st.getStudentCode());
		line.setSurnameFull(s.getSurnameFull());
		line.setFirstnamesFull(s.getFirstnamesFull());
		line.setStudentId(s.getStudentId());
		line.setStudentCode(s.getStudentCode());

		// clone results
		if (results != null) {
			List<R> resultsInDB = new ArrayList<>(results.size());
			for (R result : results) {
				try {
					@SuppressWarnings("unchecked")
					R resultClone = (R) BeanUtils.cloneBean(result);
					resultsInDB.add(resultClone);
				} catch (IllegalAccessException | InstantiationException | InvocationTargetException
						| NoSuchMethodException e) {
					throw new RuntimeException(e);
				}
			}
			line.setResultsInDB(resultsInDB);
		}

		return line;
	}

	/**
	 * Factory method to create a new result line object. To have subclasses of
	 * ResultLine is mainly for convenience.
	 */
	protected abstract L makeNewResultLine();

	/**
	 * Return a list of results for the given studyPlanDetailId.
	 * 
	 * @param studyPlanDetailId
	 * @return null if no result yet exists.
	 */
	protected abstract List<R> findResults(int studyPlanDetailId);

	public List<StudyPlanDetail> getAllStudyPlanDetails() {
		return allStudyPlanDetails;
	}

	public void setAllStudyPlanDetails(List<StudyPlanDetail> allStudyPlanDetails) {
		this.allStudyPlanDetails = allStudyPlanDetails;
	}

	public T getResultLines() {
		return resultLines;
	}

	/**
	 * Go through all lines and return a list of all results. This includes the
	 * newly created results.
	 * 
	 * @return
	 */
	public List<R> getAllResultsOfLines() {
		List<R> results = new ArrayList<>();

		for (L line : getResultLines()) {
			results.addAll(line.getResults());
		}

		return results;
	}

}
