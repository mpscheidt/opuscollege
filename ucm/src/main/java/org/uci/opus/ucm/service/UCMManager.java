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
 * The Original Code is Opus-College ucm module code.
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
 ******************************************************************************/
package org.uci.opus.ucm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.ucm.domain.StudentResult;
import org.uci.opus.ucm.persistence.UcmMapper;


/**
 * @author Markus Pscheidt
 */
public class UCMManager implements UCMManagerInterface {

    private static Logger log = LoggerFactory.getLogger(UCMManager.class);
    private UcmMapper ucmDao;

    @Autowired
    public UCMManager(UcmMapper ucmMapper) {
        this.ucmDao = ucmMapper;
    }

    public String findHighestStudentCode(String branchCode, String year) {
        return ucmDao.findHighestStudentCode(branchCode, year);
    }

    @Override
    public List<Map<String , Object>> findCTUsInStudyPlans(Map<String , Object> map) {

        return ucmDao.findCTUsInStudyPlans(map);
    }
    
    @Override
    public List<Map<String , Object>> findStudentsByNameAsMaps(Map<String, Object> map) {

        List<Map<String , Object>> students = null;
        students = ucmDao.findStudentsByNameAsMaps(map);
        return students;
    }


	@Override
	public List<Map<String, Object>> findStudentsForMoodle(
			Map<String, Object> map) {
		return ucmDao.findStudentsForMoodle(map);
	}


	@Override
	public List<Map<String, Object>> findStudentsForExport(
			Map<String, Object> map) {
		return ucmDao.findStudentsForExport(map);
	}

	@Override
	public StudentResult findStudentWithCode(String studentCode) {
		return ucmDao.findStudentWithCode(studentCode);
	}

	@Override
	public List<Map<String, Object>> findStudentsForExam(Map<String, Object> map) {
		return ucmDao.findStudentsForExam(map);
	}

	@Override
	public Map<String, Object> validateStudentForExam(Map<String, Object> map) {
		return ucmDao.validateStudentForExam(map);
	}

	@Override
	public Map<String, Object> validateStudentForExam(String studentCode,
			int subjectId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("studentCode", studentCode);
		map.put("subjectId", subjectId);
		return ucmDao.validateStudentForExam(map);
	}

	@Override
	public void addSubjectResults(SubjectResult... results) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateSubjectResults(SubjectResult... results) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public StudentResult findStudentResult(Map<String, Object> map) {
//		return ucmDao.findStudentResult(map);
	    List<StudentResult> list = findStudentsResults(map);
	    return list.isEmpty() ? null : list.get(0);
	}

	@Override
	public List<StudentResult> findStudentsResults(Map<String, Object> map) {
		return ucmDao.findStudentsResults(map);
	}

}
