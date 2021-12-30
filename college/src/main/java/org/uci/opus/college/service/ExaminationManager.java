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

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.persistence.ExaminationMapper;

/**
 * @author move
 *
 */
public class ExaminationManager implements ExaminationManagerInterface {

    @Autowired
    private ExaminationMapper examinationMapper;
    
    @Override
    public List < Examination > findExaminations(final Map<String, Object> map) {

    	return examinationMapper.findExaminations(map);
    }

    @Override
    public List<Examination> findExaminations(Collection<Integer> examinationIds) {
        
        // avoid loading all examinations into memory in case examinationIds are empty
        if (examinationIds == null || examinationIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        Map<String, Object> map = new HashMap<>(); 
        map.put("examinationIds", examinationIds);

        return findExaminations(map);
    }

    @Override
    public List < Examination > findExaminationsNotForTeacher(final Map<String, Object> map) {

    	return examinationMapper.findExaminationsNotForTeacher(map);
    }

    @Override
    public Examination findExamination(final int examinationId) {

    	return examinationMapper.findExamination(examinationId);
    }

    @Override
    public List < Examination > findExaminationsForSubject(final int subjectId) {

    	return examinationMapper.findExaminationsForSubject(subjectId);
    }
    

    @Override
    public List < Examination > findActiveExaminationsForSubject(final int subjectId) {

        return examinationMapper.findActiveExaminationsForSubject(subjectId);
    }

    @Override
    public Examination findExaminationByParams(final Map<String, Object> map) {

        Examination examination = null;

        examination = examinationMapper.findExaminationByParams(map);
        
        return examination;
    }

    @Override
    public void addExamination(final Examination examination) {

    	examinationMapper.addExamination(examination);
    }

    @Override
    public void updateExamination(final Examination examination) {

    	examinationMapper.updateExamination(examination);
    }
    
    @Override
    public void deleteExamination(final int examinationId) {

    	examinationMapper.deleteExamination(examinationId);
    }
    
    @Override
    public ExaminationTeacher findExaminationTeacher(final int examinationTeacherId) {

    	return examinationMapper.findExaminationTeacher(examinationTeacherId);
    }

    @Override
    public List < ExaminationTeacher > findExaminationTeachers(
    		final int examinationId) {

    	return examinationMapper.findExaminationTeachers(examinationId);
    }

    @Override
    public void addExaminationTeacher(final ExaminationTeacher examinationTeacher) {

    	examinationMapper.addExaminationTeacher(examinationTeacher);
    }

    @Override
    public void updateExaminationTeacher(final ExaminationTeacher examinationTeacher) {
        examinationMapper.updateExaminationTeacher(examinationTeacher);
    }

    @Override
    public void deleteExaminationTeacher(final int examinationTeacherId) {

    	examinationMapper.deleteExaminationTeacher(examinationTeacherId);
    }

    @Override
    public int findTotalWeighingFactor(int subjectId, int examinationIdToIgnore) {
        Map<String, Object> map = new HashMap<>();
        map.put("subjectId", subjectId);
        map.put("examinationIdToIgnore", examinationIdToIgnore);
        Integer percentage = examinationMapper.findTotalWeighingFactor(map);
        return percentage == null ? 0 : percentage;
    }

    @Override
    public int findTotalWeighingFactor(int subjectId) {
        Map<String, Object> map = new HashMap<>();
        map.put("subjectId", subjectId);
        Integer percentage = examinationMapper.findTotalWeighingFactor(map);
        return percentage == null ? 0 : percentage;
    }

}
