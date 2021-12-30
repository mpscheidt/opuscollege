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

            <form name="studygradetypes" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
            <!-- <input type="hidden" name="studyYearId" value="0" />
            <input type="hidden" name="yearNumber" value="0" /> -->
            <input type="hidden" name="cardinalTimeUnitNumber" value="0" />
            <input type="hidden" id="searchValue" name="searchValue" value="" />
            <input type="hidden" id="studentStatusCode" name="studentStatusCode" value="" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td>
                    <select name="studyGradeTypeId" onchange="document.getElementById('searchValue').value='';document.getElementById('cardinalTimeUnitNumber').value='0';document.studygradetypes.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                           <c:choose>
	                           <c:when test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
	                           		&& studyGradeType.id == studyGradeTypeId) }"> 
	                                <option value="${studyGradeType.id}" selected="selected">
	                            </c:when>
	                            <c:otherwise>
	                                <option value="${studyGradeType.id}">
	                            </c:otherwise>
                           </c:choose>
                           <c:forEach var="study" items="${allStudies}">
                           		<c:choose>
                           			<c:when test="${study.id == studyGradeType.studyId}" >
	                           			${study.studyDescription}
	                           		</c:when>
	                           	</c:choose>
                           </c:forEach>
                           <c:forEach var="gradeType" items="${allGradeTypes}">
                           		<c:choose>
                           			<c:when test="${gradeType.code == studyGradeType.gradeTypeCode}" >
	                           			- ${gradeType.description}
	                           		</c:when>
	                           	</c:choose>
                           </c:forEach>
                           <c:forEach var="academicYear" items="${allAcademicYears}">
                                <c:choose>
                                    <c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
                                        (${academicYear.description})
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            </option>
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
            </form>
            
            <form name="cardinaltimeunitnumbers" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}"/>
            <input type="hidden" name="searchValue" value="" />
            <input type="hidden" id="studentStatusCode" name="studentStatusCode" value="" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
                    <td>
                    <!-- make one option for each cardinalTimeUnit -->
                    <select name="cardinalTimeUnitNumber" id="cardinalTimeUnitNumber" onchange="document.getElementById('searchValue').value='';document.cardinaltimeunitnumbers.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:choose>
                        	<c:when test="${studyGradeTypeId != null && studyGradeTypeId != 0}">
		                        <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
		                           <c:choose>
			                           <c:when test="${studyGradeType.id == studyGradeTypeId}"> 
					                        <c:forEach var="i" begin="1" end="${maxNumberOfCardinalTimeUnits}" varStatus="varStatus">
					                                <c:choose>
					                                    <c:when test="${(cardinalTimeUnitNumber == i) }"> 
					                                       <option value="${i}" selected="selected">${i}</option>
					                                    </c:when>
					                                    <c:otherwise>
					                                        <option value="${i}">${i}</option>
					                                    </c:otherwise>
					                                </c:choose>
					                        </c:forEach>
					                    </c:when>
					                </c:choose>
					            </c:forEach>
					        </c:when>
					    </c:choose>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
            </form>
        