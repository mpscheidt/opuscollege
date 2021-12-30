<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College college module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen.
Portions created by the Initial Developer are Copyright (C) 2008
the Initial Developer. All Rights Reserved.

Contributor(s):
  For Java files, see Javadoc @author tags.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

***** END LICENSE BLOCK *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- 
    Subject and block selection using lists of subjects and subjectBlocks.
    See subjectAndBlockSGTSelection for a similar implementation using subjectSGT and subjectBlockSGT.

    Expecting the following variables to be present:
    - subjectAndBlockSelection

    Expecting a surrounding form:form element with the following paths:
    - subjectBlockIds
    - subjectIds
 --%>

<!-- subject blocks on the left -->
<td>
    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
        <table style="width:100%;">
            <tr>
                <th><fmt:message key="jsp.general.compulsorysubjectblocks" /></th>
            </tr>
            <tr><td>
                <c:forEach var="sb" items="${subjectAndBlockSelection.compulsorySubjectBlocks}" >
                    <form:checkbox id="sb${sb.id}" path="subjectBlockIds" value="${sb.id}" disabled="${subjectAndBlockSelection.disabledSubjectBlocks[sb.id]}"/>
                    <label style="font-weight:normal" for="sb${sb.id}">
                        <c:out value="
                        ${sb.subjectBlockDescription}
                        (${subjectAndBlockSelection.codeToStudyTimeMap[sb.studyTimeCode].description})
                        "/>
                    </label>
                    <br/>
                </c:forEach>
            </td></tr>
            <tr>
                <th><fmt:message key="jsp.general.optionalsubjectblocks" /></th>
            </tr>
            <tr><td>
                <c:forEach var="sb" items="${subjectAndBlockSelection.optionalSubjectBlocks}">
                    <form:checkbox id="sb${sb.id}" path="subjectBlockIds" value="${sb.id}" disabled="${subjectAndBlockSelection.disabledSubjectBlocks[sb.id]}"/>
                    <label style="font-weight:normal" for="sb${sb.id}">
                        <c:out value="
                        ${sb.subjectBlockDescription}
                        (${subjectAndBlockSelection.codeToStudyTimeMap[sb.studyTimeCode].description})
                        "/>
                    </label>
                    <br/>
                </c:forEach>
            </td></tr> 
        </table>
    </c:if>
</td>
<!-- subjects on the right -->
<td>
    <table style="width:100%;">
        <tr>
            <th><fmt:message key="jsp.general.compulsorysubjects" /></th>
        </tr>
        <tr>
            <td>
                <c:forEach var="subject" items="${subjectAndBlockSelection.compulsorySubjects}" >
                    <form:checkbox id="subject${subject.id}" path="subjectIds" value="${subject.id}" disabled="${subjectAndBlockSelection.disabledSubjects[subject.id]}"/>
                    <label style="font-weight:normal" for="subject${subject.id}">
                        <c:out value="${subject.subjectDescription} (${subjectAndBlockSelection.codeToStudyTimeMap[subject.studyTimeCode].description})"/>
                    </label>
                    <br/>
                </c:forEach>
            </td>
        </tr>
        <tr>
            <th><fmt:message key="jsp.general.optionalsubjects" /></th>
        </tr>
        <tr>
            <td>
                <c:forEach var="subject" items="${subjectAndBlockSelection.optionalSubjects}" >
                    <form:checkbox id="subject${subject.id}" path="subjectIds" value="${subject.id}" disabled="${subjectAndBlockSelection.disabledSubjects[subject.id]}"/>
                    <label style="font-weight:normal" for="subject${subject.id}">
                        <c:out value="${subject.subjectDescription} (${subjectAndBlockSelection.codeToStudyTimeMap[subject.studyTimeCode].description})"/>
                    </label>
                    <br/>
                </c:forEach>
            </td>
        </tr>
    </table>
</td>
