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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<spring:bind path="command.id">
    <c:set var="commandId" value="${status.value}" scope="page" />
</spring:bind>

<spring:bind path="command.personId">
    <c:set var="commandPersonId" value="${status.value}" scope="page" />
</spring:bind>

<form method="post">
            <input type="hidden" name="tab_studyplan" value="2" /> 
            <input type="hidden" name="panel_studyplan" value="0" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
        <table>

            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td colspan="3">
                    <!-- list of studyplans -->
                    <table class="tabledata2">
                        <tr>
                            <td width="90"><b><fmt:message key="jsp.general.academicyear" /></b></td>
                            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                <th><fmt:message key="jsp.general.subjectblock" /></th>
                            </c:if>
                            <th><fmt:message key="jsp.general.subject" /></th>
                            <td width="30">&nbsp;</td>
                        </tr>
                        
                        <c:forEach var="oneStudyPlanDetail" items="${studyPlan.studyPlanDetails}">
                            <tr>
                                <td>
                                <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                                     <c:choose>
                                         <c:when test="${oneStudyPlanDetail.studyGradeTypeId != 0
                                                      && studyGradeType.id == studyGradeTypeId}">
			                                <c:forEach var="academicYear" items="${allAcademicYears}">
			                                     <c:choose>
			                                         <c:when test="${studyGradeType.academicYearId != 0
			                                                      && academicYear.id == studyGradeType.academicYearId}">
			                                            ${academicYear.description}
			                                         </c:when>
			                                     </c:choose>
			                                </c:forEach>
			                            </c:when>
			                        </c:choose>
			                    </c:forEach>
                                </td>
                                
                                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                <!-- subjectblock -->
                                <td>
                                    <c:forEach var="subjectBlock" items="${allSubjectBlocks}" >
                                        <c:choose>
                                            <c:when test="${oneStudyPlanDetail.subjectBlockId != 0 && subjectBlock.id == oneStudyPlanDetail.subjectBlockId}" >
                                                <c:forEach var="oneStudyGradeType" items="${allStudyGradeTypes}">
                                                    <c:choose>
                                                        <c:when test="${subjectBlock.studyGradeTypeId == oneStudyGradeType.id }">
                                                            <c:forEach var="oneStudy" items="${allStudies}">
                                                                <c:choose>
                                                                    <c:when test="${oneStudyGradeType.studyId == oneStudy.id }">
                                                                        <c:set var="studyId" value="${oneStudy.id }" scope="page" />
                                                                        <c:set var="studyGradeTypeId" value="${oneStudyGradeType.id }" scope="page" />
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <c:choose>
                                                    <c:when test="${opusUser.personId == commandPersonId}">
                                                        <a href="<c:url value='/college/subjectblock.view?tab=0&panel=0&from=student&studyId=${studyId}&subjectBlockId=${subjectBlock.id}'/>">
                                                             ${subjectBlock.subjectBlockDescription }
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${subjectBlock.subjectBlockDescription }
                                                    </c:otherwise>
                                                 </c:choose>
                                                </td>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                                </c:if>
                                
                                <!-- subject -->
                                <td colspan="3">
                                    <c:forEach var="subject" items="${allSubjects}" >
                                        <c:choose>
                                            <c:when test="${oneStudyPlanDetail.subjectId != 0 && subject.id == oneStudyPlanDetail.subjectId}" > 
                         						<c:choose>
                                                    <c:when test="${opusUser.personId == commandPersonId}">
                                                        <a href="<c:url value='/college/subject.view?tab=0&panel=0&from=student&subjectId=${subject.id}'/>">
                                                            ${subject.subjectDescription }
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${subject.subjectDescription }
                                                    </c:otherwise>
                                                </c:choose>
                                                <%-- (${subject.subjectStructureValidFromYear} - ${subject.subjectStructureValidThroughYear}) --%>   
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:forEach>
                    <tr>
                    	<td colspan="4">
                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    	</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>

