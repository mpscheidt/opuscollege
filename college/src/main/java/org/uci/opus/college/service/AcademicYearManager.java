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

package org.uci.opus.college.service;

import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.persistence.AcademicYearMapper;
import org.uci.opus.util.AcademicYearComparator;
import org.uci.opus.util.AcademicYearUtil;

/**
 * @author stelio2
 *
 */
public class AcademicYearManager implements AcademicYearManagerInterface {

	private static Logger log = LoggerFactory.getLogger(AcademicYearManager.class);
	
	private AcademicYearMapper academicYearMapper;

	@Autowired
	public AcademicYearManager(AcademicYearMapper academicYearMapper) {
	    this.academicYearMapper = academicYearMapper;
    }
	
    @Override
	public AcademicYear findAcademicYear(int id) {
		return academicYearMapper.findAcademicYear(id);
	}
	
    @Override
	public int addAcademicYear(AcademicYear academicYear) {
		return academicYearMapper.addAcademicYear(academicYear);
	}

    @Override
	public void deleteAcademicYear(int id) {
		academicYearMapper.deleteAcademicYear(id);
	}

    @Override
	public List<AcademicYear> findAcademicYears(Map<String, Object> map) {
		return academicYearMapper.findAcademicYears(map);
	}

	@Override
	public Integer findRequestAdmissionNumberOfSubjectsToGrade(final Date date) {
	    return academicYearMapper.findRequestAdmissionNumberOfSubjectsToGrade(date);
	}	

	@Override
    public AcademicYear getCurrentAcademicYear() {
        return getCurrentAcademicYear(this.findAllAcademicYears());
    }

	@Override
	public AcademicYear getCurrentAcademicYear(List<AcademicYear> allAcademicYears) {
        if (allAcademicYears == null || allAcademicYears.isEmpty()) {
            return null;
        }

        Date dateNow = new Date();

        for (AcademicYear y : allAcademicYears) {
            /* loop through the academic years to find the one for the current date */
            if (y.getStartDate().before(dateNow) && y.getEndDate().after(dateNow)) {
                if (log.isDebugEnabled()) {
                    log.debug("Determined current academic year: " + y);
                }
                return y;
            }
        }           

        return null;
	}

	@Override
	public AcademicYear getCurrentAcademicYearOfAdmission() {
		AcademicYear academicYear = null;
		List <AcademicYear> allAcademicYears = this.findAllAcademicYears();
    	
		Calendar c1 = Calendar.getInstance();
		c1.add(Calendar.YEAR,1);
		Date dateNowAndOneYear = new Date();
		dateNowAndOneYear = c1.getTime();
    	if (allAcademicYears != null) {
        	for (int x = 0; x < allAcademicYears.size(); x++) {
				/* loop through the academic years to find the one for the next academic year*/
				if (allAcademicYears.get(x).getStartDate().before(dateNowAndOneYear) 
						&& allAcademicYears.get(x).getEndDate().after(dateNowAndOneYear)) {
    					academicYear = allAcademicYears.get(x);
    					break;
				}
			}			
        }
        return academicYear;
	}
	
	@Override
    public List<AcademicYear> findAllAcademicYears() {
		return academicYearMapper.findAllAcademicYears();
	}

    @Override
	public List<AcademicYear> findAllAcademicYearsSorted() {
	
		List < AcademicYear> allAcademicYears = this.findAllAcademicYears();
		Collections.sort(allAcademicYears, new AcademicYearComparator());
		return allAcademicYears;
	}

    @Override
	public List<AcademicYear> findAcademicYears(String year) {
        return academicYearMapper.findAcademicYearsByMaxYear(year);
    }

    @Override
	public void updateAcademicYear(AcademicYear academicYear) {
		academicYearMapper.updateAcademicYear(academicYear);
	}

    @Override
    public AcademicYear findLastAcademicYear(Map<String, Object> map) {
        return academicYearMapper.findLastAcademicYear(map);
    }

    @Override
    public int getIntervalInDaysBetweenAcademicYears(int academicYearId1, int academicYearId2) {
        
        AcademicYear originalAcademicYear = academicYearMapper.findAcademicYear(academicYearId1);
        AcademicYear newAcademicYear = academicYearMapper.findAcademicYear(academicYearId2);
        Date originalStartDate = originalAcademicYear.getStartDate();
        Date newStartDate = newAcademicYear.getStartDate();
        long difference = 0;
        if (originalStartDate != null && newStartDate != null) {
            difference = (newStartDate.getTime() - originalStartDate.getTime()) / 1000 / 60 / 60 / 24;
        }
        return (int) difference;
    }

	@Override
	public Map<String, Object> findDependencies(Map<String, Object> map) {
		return academicYearMapper.findDependencies(map);
	}

	public Map<String, Object> findDependencies(int academicYearId) {
		
		Map<String,Object> map = new HashMap<>();
		map.put("academicYearId", academicYearId);
		
		return academicYearMapper.findDependencies(map);
	}
	

	@Override
	public AcademicYear getPreviousAcademicYear(int academicYearId) {
	    
        List <AcademicYear> allAcademicYears = this.findAllAcademicYears();
	    return AcademicYearUtil.getPreviousAcademicYear(allAcademicYears, academicYearId);
	}
}
