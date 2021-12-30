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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unilus.web.extension;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;

public class UnilusSubjectResultFormatter extends SubjectResultFormatter{

    @Autowired private ResultManagerInterface resultManager;
    @Autowired private SubjectManagerInterface subjectManager;
    
    private static Logger log = Logger.getLogger(UnilusSubjectResultFormatter.class);
    
    @Override
    public String get(Object obj) {
    	SubjectResult subjectResult = (SubjectResult) obj;
        StringBuilder s = new StringBuilder();
        s.append(subjectResult.getMark());
        s.append(" (");
        if (subjectResult.getEndGrade() != null) {
            s.append(subjectResult.getEndGrade());
        }
        s.append(")");
        return s.toString();
    }

    @Override
    public void loadAdditionalInfo(SubjectResult subjectResult,
            String endGradeTypeCode, String preferredLanguage) {
        
        if (log.isDebugEnabled()) {
            log.debug("UnzaSubjectResultFormatter.loadAdditionalInfo started...");
        }
        Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());
        String endGrade = resultManager.calculateEndGradeForMark(
        		subjectResult.getMark(), endGradeTypeCode, preferredLanguage,
        		subject.getCurrentAcademicYearId());
        subjectResult.setEndGrade(endGrade);
        if (subjectResult.getEndGradeComment() == null 
                || "".equals(subjectResult.getEndGradeComment())) {
            String endGradeComment = resultManager.calculateEndGradeCommentForMark(
            		subjectResult.getMark(), endGradeTypeCode, preferredLanguage,
            		subject.getCurrentAcademicYearId());
            subjectResult.setEndGradeComment(endGradeComment);
        }   
    }

}
