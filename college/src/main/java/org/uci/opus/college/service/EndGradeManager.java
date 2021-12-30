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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.audit.EndGradeHistory;
import org.uci.opus.college.persistence.EndGradeMapper;

public class EndGradeManager implements EndGradeManagerInterface {

    private EndGradeMapper endGradeMapper;
    
    @Autowired
    public EndGradeManager(EndGradeMapper endGradeMapper) {
        this.endGradeMapper = endGradeMapper;
    }

    @Override
    public List<? extends EndGrade> findAllEndGrades(String lang) {

        Map<String, Object> map = new HashMap<>();
        map.put("lang", lang);
        return endGradeMapper.findEndGrades(map);
    }

    @Override
    public List<? extends EndGrade> findEndGrades(Map<String, Object> map) {
        return endGradeMapper.findEndGrades(map);
    }

    @Override
    public List<Map> findEndGradesAsMaps(Map<String, Object> map) {
        return endGradeMapper.findEndGradesAsMaps(map);
    }

    @Override
    public EndGrade findEndgrade(String code, String endGradeTypeCode, int academicYearId, String lang) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("endGradeTypeCode", endGradeTypeCode);
        map.put("academicYearId", academicYearId);
        map.put("lang", lang);
        return getOne(endGradeMapper.findEndGrades(map));
    }

    private EndGrade getOne(List<? extends EndGrade> endGrades) {
        return endGrades == null || endGrades.isEmpty() ? null : endGrades.get(0);
    }

    @Override
    public EndGrade findEndGradeById(int endGradeId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", endGradeId);
        return getOne(endGradeMapper.findEndGrades(map));
    }

    @Override
    public boolean isEndGradeExists(EndGrade endGrade) {
        return endGradeMapper.isEndGradeExists(endGrade);
    }

    @Override
    public void updateEndGrade(EndGrade endGrade) {
        endGradeMapper.updateEndGrade(endGrade);
        updateEndGradeHistory(endGrade, "U");
    }

    @Override
    public int addEndGrade(EndGrade endGrade) {
        int id = endGradeMapper.addEndGrade(endGrade);
        updateEndGradeHistory(endGrade, "I");
        return id;
    }

    @Override
    public void deleteEndGradeSet(String code, String endGradeTypeCode, int academicyearId, String writeWho) {
        Map<String, Object> deleteMap = new HashMap<>();
        deleteMap.put("academicYearId", academicyearId);
        deleteMap.put("code", code);
        deleteMap.put("endGradeTypeCode", endGradeTypeCode);
        List<? extends EndGrade> endGradeSet = findEndGrades(deleteMap);

        // getSqlMapClientTemplate().delete("EndGrade.deleteEndGrade", deleteMap);
        endGradeMapper.deleteEndGradeSet(code, endGradeTypeCode, academicyearId);

        for (EndGrade endGrade : endGradeSet) {

            endGrade.setWriteWho(writeWho);
            updateEndGradeHistory(endGrade, "D");
        }

    }

    @Override
    public void addEndGradeSet(List<? extends EndGrade> endGrades) {

        for (EndGrade endGrade : endGrades) {
            this.addEndGrade(endGrade);
        }
    }

    @Override
    public void updateEndGradeSet(List<? extends EndGrade> endGrades) {

        for (EndGrade endGrade : endGrades) {
            this.updateEndGrade(endGrade);
        }
    }

    /**
     * 
     * @param endGrade
     * @param operation
     */
    private void updateEndGradeHistory(EndGrade endGrade, String operation) {

        Map<String, Object> map = new HashMap<>();

        map.put("operation", operation);
        map.put("EndGrade", endGrade);

        endGradeMapper.updateEndGradeHistory(map);

    }

    /**
     * 
     * @param endGradeId
     * @return
     */
    @Override
    public List<EndGradeHistory> findEndGradeHistory(int endGradeId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", endGradeId);
        return endGradeMapper.findEndGradeHistory(map);
    }

}
