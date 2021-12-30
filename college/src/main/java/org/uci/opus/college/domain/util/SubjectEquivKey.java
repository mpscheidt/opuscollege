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

package org.uci.opus.college.domain.util;

/**
 * The fields that have to match in two subjects
 * to treat it as the same subject.
 * Typically needed to compare subjects that have been
 * transferred from one academic year to another.
 * Therefore, the academicYearId is not part of this key.
 * 
 * @author markus
 */
public class SubjectEquivKey {

    private String subjectCode;
    private String subjectDescription;
    
    public SubjectEquivKey(String subjectCode, String subjectDescription) {
        this.subjectCode = subjectCode;
        this.subjectDescription = subjectDescription;
    }
    
    public String getSubjectCode() {
        return subjectCode;
    }
    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }
    @Override
    public int hashCode() {
        int hash = 0;
        hash += subjectCode == null ? 0 : subjectCode.hashCode();
        hash += subjectDescription == null ? 0 : subjectDescription.hashCode();
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof SubjectEquivKey)) return false;

        SubjectEquivKey other = (SubjectEquivKey) obj;

        // pattern for comparison:   ((a == b) || ((a != null) && a.equals(b)))
        return (subjectCode == other.subjectCode || subjectCode != null && subjectCode.equals(other.subjectCode))
            && (subjectDescription == other.subjectDescription || subjectDescription != null && subjectDescription.equals(other.getSubjectDescription()));
    }

    public void setSubjectDescription(String subjectDescription) {
        this.subjectDescription = subjectDescription;
    }

    public String getSubjectDescription() {
        return subjectDescription;
    }
    
}
