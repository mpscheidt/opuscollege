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

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.persistence.TestMapper;
import org.uci.opus.util.OpusMethods;

/**
 * @author move
 *
 */
public class TestManager implements TestManagerInterface {

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private TestMapper testMapper;

    @Override
    public List<Test> findTests(final Map<String, Object> map) {

        return testMapper.findTests(map);
    }

    @Override
    public List<Test> findTests(Collection<Integer> testIds) {

        if (testIds == null || testIds.isEmpty()) {
            return new ArrayList<>();
        }

        Map<String, Object> findTestsMap = new HashMap<>();
        findTestsMap.put("testIds", testIds);
        return this.findTests(findTestsMap);
    }

    @Override
    public List<Test> findTestsNotForTeacher(final Map<String, Object> map) {

        return testMapper.findTestsNotForTeacher(map);
    }

    @Override
    public Test findTest(final int testId) {

        return testMapper.findTest(testId);
    }

    @Override
    public List<Test> findTestsForExamination(final int examinationId) {

        return testMapper.findTestsForExamination(examinationId);
    }

    @Override
    public List<Test> findActiveTestsForExamination(final int examinationId) {

        return testMapper.findActiveTestsForExamination(examinationId);
    }

    @Override
    public Test findTestByParams(final Map<String, Object> map) {

        Test test = null;

        test = testMapper.findTestByParams(map);

        return test;
    }

    @Override
    public void addTest(final Test test) {
        testMapper.addTest(test);
    }

    @Override
    public void updateTest(final Test test) {

        testMapper.updateTest(test);
    }

    @Override
    public void deleteTest(final int testId) {

        testMapper.deleteTest(testId);
    }

    @Override
    public TestTeacher findTestTeacher(final int testTeacherId) {

        return testMapper.findTestTeacher(testTeacherId);
    }

    @Override
    public List<TestTeacher> findTeachersForTest(final int testId) {

        return testMapper.findTeachersForTest(testId);
    }

    @Override
    public void addTestTeacher(final TestTeacher testTeacher, HttpServletRequest request) {

        testTeacher.setWriteWho(opusMethods.getWriteWho(request));
        testMapper.addTestTeacher(testTeacher);
    }

    @Override
    public void updateTestTeacher(final TestTeacher testTeacher, HttpServletRequest request) {

        testTeacher.setWriteWho(opusMethods.getWriteWho(request));
        testMapper.updateTestTeacher(testTeacher);
    }

    @Override
    public void deleteTestTeacher(final int testTeacherId) {

        testMapper.deleteTestTeacher(testTeacherId);
    }

    @Override
    public int findTotalWeighingFactor(int examinationId, int testIdToIgnore) {
        Map<String, Object> map = new HashMap<>();
        map.put("examinationId", examinationId);
        map.put("testIdToIgnore", testIdToIgnore);
        Integer percentage = testMapper.findTotalWeighingFactor(map);
        return percentage == null ? 0 : percentage;
    }

    @Override
    public int findTotalWeighingFactor(int examinationId) {
        Map<String, Object> map = new HashMap<>();
        map.put("examinationId", examinationId);
        Integer percentage = testMapper.findTotalWeighingFactor(map);
        return percentage == null ? 0 : percentage;
    }

    @Override
    public String getBRsPassingTest(Test test) {
        
        String br = test.getBRsPassingTest();
        if (StringUtils.isBlank(br) ) {
            br = appConfigManager.getDefaultBrPassingTest();
        }
        
        return br;
    }

}
