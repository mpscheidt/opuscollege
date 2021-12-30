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

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;

/**
 * @author move
 *
 */
public interface ExaminationManagerInterface {

    /**
     * @param map
     * @return List of Examination objects or null
     */
    List<Examination> findExaminations(final Map<String, Object> map);

    /**
     * 
     * @param examinationIds
     * @return
     */
    List<Examination> findExaminations(Collection<Integer> examinationIds);

    /**
     * @param staffMemberId
     * @return List of Examination objects or null
     */
    List<Examination> findExaminationsNotForTeacher(final Map<String, Object> map);

    /**
     * @param examinationId id of Examination
     * @return Examination object or null
     */
    Examination findExamination(final int examinationId);

    /**
     * @param subjectId
     * @return List of Examination objects or null
     */
    List<Examination > findExaminationsForSubject(final int subjectId);

    /**
     * @param subjectId
     * @return List of Examination objects or null
     */
    List<Examination> findActiveExaminationsForSubject(final int subjectId);

    /**
     * @param map with params to find the examinatino with
     * @return Examination object or null
     */
    Examination findExaminationByParams(final Map<String, Object> map);

    /**
     * @param examination to add
     */
    void addExamination(final Examination examination);

    /**
     * @param examination to update
     */
    void updateExamination(final Examination examination);

    /**
     * Delete examination and cascaded examination teachers and examination results.
     * 
     * @param examinationId id of Examination to delete
     */
    void deleteExamination(final int examinationId);

    /**
     * @param examinationTeacherId
     * @return ExaminationTeacher object or null
     */
    ExaminationTeacher findExaminationTeacher(final int examinationTeacherId);

    /**
     * Find a list of given combination of examination and teacher.
     * @param examinationId id of the combination
     * @return List of ExaminationTeacher objects or null
     */
    List<ExaminationTeacher> findExaminationTeachers(final int examinationId);

    /**
     * @param examinationTeacher id of the examinationteacher
     * @return 
     */
    void addExaminationTeacher(final ExaminationTeacher examinationTeacher);

    /**
     * @param examinationTeacher id of the examinationteacher
     * @return 
     */
    void updateExaminationTeacher(final ExaminationTeacher examinationTeacher);

    /**
     * @param examinationTeacherId id of the examinationteacher
     * @return 
     */
    void deleteExaminationTeacher(final int examinationTeacherId);

    /**
     * Get the sum of the weights of all examinations for the subject
     * with the given subjectId.
     * @param subjectId
     * @param examinationIdToignore the examination with the given id will not be counted.
     * @return
     */
    int findTotalWeighingFactor(int subjectId, int examinationIdToignore);

    /**
     * Get the sum of the weights of all examinations for the subject
     * with the given subjectId.
     * @param subjectId
     * @return
     */
    int findTotalWeighingFactor(int subjectId);

}
