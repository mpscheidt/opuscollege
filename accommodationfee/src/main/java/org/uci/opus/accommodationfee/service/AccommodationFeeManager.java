/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2011
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
 ******************************************************************************/
package org.uci.opus.accommodationfee.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.accommodationfee.persistence.AccommodationFeeMapper;
import org.uci.opus.college.domain.Student;

@Service
public class AccommodationFeeManager implements AccommodationFeeManagerInterface {

	private static Logger log = LoggerFactory.getLogger(AccommodationFeeManager.class);
	
	@Autowired private AccommodationFeeMapper accommodationFeeMapper;

    @Override
    public void addAccommodationFee(AccommodationFee accommodationFee) {
        accommodationFeeMapper.addAccommodationFee(accommodationFee);
        accommodationFeeMapper.updateAccommodationFeeHistory(accommodationFee, "I");
    }

    @Override
    public void updateAccommodationFee(AccommodationFee accommodationFee) {
        accommodationFeeMapper.updateAccommodationFee(accommodationFee);
        accommodationFeeMapper.updateAccommodationFeeHistory(accommodationFee, "U");
    }

    @Override
    public int deleteAccommodationFee(int id, String writeWho) {

        AccommodationFee accommodationFee = findAccommodationFee(id);
        accommodationFee.setWriteWho(writeWho);

        int rows = accommodationFeeMapper.deleteAccommodationFee(id);
        accommodationFeeMapper.updateAccommodationFeeHistory(accommodationFee, "D");

        return rows;
    }

    @Override
    public AccommodationFee findAccommodationFee(int id) {
        return accommodationFeeMapper.findAccommodationFee(id);
    }

    @Override
    public AccommodationFee findAccommodationFeeByFeeId(int id) {
        return accommodationFeeMapper.findAccommodationFeeByFeeId(id);
    }

    @Override
    public AccommodationFee findAccommodationFeeByParams(Map<String, Object> params) {
        return accommodationFeeMapper.findAccommodationFeeByParams(params);
    }
    
    @Override
    public List<AccommodationFee> findAccommodationFeesByParams(Map<String, Object> params) {
        return accommodationFeeMapper.findAccommodationFeesByParams(params);
    }

    @Override
    public BigDecimal getStudentAccommodationBalance(int studentId) {
        return accommodationFeeMapper.getStudentAccommodationBalance(studentId);
    }

    @Override
    public List<BigDecimal> getStudentAccommodationPaymentByAcademicYearID(int studentId, int academicYearId) {
        return accommodationFeeMapper.getStudentAccommodationPaymentByAcademicYearID(studentId, academicYearId);
    }

    @Override
    public List<Student> getOwingStudents(int academicYearId) {
        Map<String, Object> criteria = new HashMap<>();
        criteria.put("academicYearId", academicYearId);
        return accommodationFeeMapper.getOwingStudents(criteria);
    }

    @Override
    public List<Student> getOwingStudents(int academicYearId,int studyGradeTypeId) {
        Map<String, Object> criteria = new HashMap<>();
        criteria.put("academicYearId", academicYearId);
        criteria.put("studyGradeTypeId",studyGradeTypeId);
        return accommodationFeeMapper.getOwingStudents(criteria);
    }

    @Override
    public List<Student> getOwingStudents(int academicYearId,int studyGradeTypeId, int cardinalTimeUnitId) {
        Map<String, Object> criteria = new HashMap<>();
        criteria.put("academicYearId", academicYearId);
        criteria.put("studyGradeTypeId",studyGradeTypeId);
        criteria.put("cardinalTimeUnitId", cardinalTimeUnitId);
        return accommodationFeeMapper.getOwingStudents(criteria);
    }

}
