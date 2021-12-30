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

            <table>
            	<tr>
                	<td class="label"><fmt:message key="jsp.general.study" /></td>
                    <td width="200">
                    <select id="studySettings.studyId" name="studySettings.studyId" onchange="
                    	document.getElementById('studySettings.studyGradeTypeId').value='0';
                    	document.getElementById('studySettings.cardinalTimeUnitNumber').value='';
                        document.getElementById('studySettings.classgroupId').value='0';
                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                    	document.organizationandnavigation.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneStudy" items="${dropDownListStudies}">
                            <c:choose>
                            <c:when test="${(studySettings.studyId != null && studySettings.studyId != 0) }"> 
                                <c:choose>
                                    <c:when test="${oneStudy.id == studySettings.studyId}"> 
                                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                           </c:otherwise>
                           </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
            	</tr>
            </table>

            <table>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td width="200">
                    <select name="studySettings.studyGradeTypeId" id="studySettings.studyGradeTypeId" onchange="
                    	document.getElementById('studySettings.cardinalTimeUnitNumber').value='';
                        document.getElementById('studySettings.classgroupId').value='0';
                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                        document.organizationandnavigation.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                            <c:choose>
                                <c:when test="${(studySettings.studyId != null && studySettings.studyId != 0) }"> 
                                    <c:forEach var="gradeType" items="${allGradeTypes}">
		                           		<c:choose>
		                           			<c:when test="${gradeType.code == studyGradeType.gradeTypeCode}" >
		                           			    <c:set var="studySettingsGradeTypeDescription">${gradeType.description}</c:set>
			                           			<c:forEach var="academicYear" items="${allAcademicYears}">
			                           				<c:choose>
			                           					<c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
                                                            <c:set var="studySettingsAcademicYear">${academicYear.description}</c:set>
			                           					</c:when>
			                           				</c:choose>
			                           			</c:forEach>
			                           		</c:when>
			                           	</c:choose>
                                    </c:forEach>
                                    <c:forEach var="studyTime" items="${allStudyTimes}">
                                        <c:choose>
                                            <c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
                                                <c:set var="studySettingsStudyTime">${studyTime.description}</c:set>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>

                                    <c:forEach var="studyForm" items="${allStudyForms}">
                                        <c:choose>
                                            <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
                                                <c:set var="studySettingsStudyForm">${studyForm.description}</c:set>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>

                                    <c:set var="studyGradeTypeString">
                                        <fmt:message key="format.gradetype.academicyear.studyform.studytime">
                                            <fmt:param value="${studySettingsGradeTypeDescription}" />
                                            <fmt:param value="${studySettingsAcademicYear}" />
                                            <fmt:param value="${studySettingsStudyForm}" />
                                            <fmt:param value="${studySettingsStudyTime}" />
                                        </fmt:message>
                                    </c:set>

                                    <c:choose>
                                        <c:when test="${studyGradeType.id == studySettings.studyGradeTypeId}"> 
                                            <option value="${studyGradeType.id}" selected="selected"><c:out value="${studyGradeTypeString}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${studyGradeType.id}"><c:out value="${studyGradeTypeString}"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                   
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
                        
            <table>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
                    <c:choose>
                        <c:when test="${admissionFlow eq 'Y' || continuedRegistrationFlow eq 'Y'}">
                            <td width="200" class="required">
                        </c:when>
                        <c:otherwise>
                            <td width="200">
                        </c:otherwise>
                    </c:choose>
                    <!-- make one option for each cardinalTimeUnit -->
                    <select name="studySettings.cardinalTimeUnitNumber" id="studySettings.cardinalTimeUnitNumber" onchange="
                    	document.getElementById('navigationSettings.currentPageNumber').value='1';
                        document.organizationandnavigation.submit();">
                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:if test="${not empty studySettings.studyGradeType}">
	                        <c:forEach var="i" begin="1" end="${studySettings.studyGradeType.numberOfCardinalTimeUnits}" varStatus="varStatus">
	                                <c:choose>
	                                    <c:when test="${(studySettings.cardinalTimeUnitNumber == i) }"> 
	                                       <option value="${i}" selected="selected">${i}</option>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <option value="${i}">${i}</option>
	                                    </c:otherwise>
	                                </c:choose>
	                        </c:forEach>
				        </c:if>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>

            <!-- class -->            
            <table>
                <tr>
                    <td class="label"><fmt:message key="general.classgroup" /></td>
                    <td width="200">
                    <select name="studySettings.classgroupId" id="studySettings.classgroupId" onchange="
                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                        document.organizationandnavigation.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:if test="${not empty studySettings.studyGradeType}">
                            <c:forEach var="classgroup" items="${studySettings.studyGradeType.classgroups}">
                                <c:choose>
                                    <c:when test="${studySettings.classgroupId == classgroup.id}"> 
                                        <option value="${classgroup.id}" selected="selected">${classgroup.description}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${classgroup.id}">${classgroup.description}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:if>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>

            <c:if test="${admissionFlow eq 'Y'}">
                <table>
	                <tr>
	                    <td class="label"><fmt:message key="jsp.general.admissionstatus" /></td>
	                    <td width="200" class="required">
	                    <select name="studySettings.studyPlanStatus.code" id="studySettings.studyPlanStatus.code" onchange="
                                          document.getElementById('navigationSettings.currentPageNumber').value='1';
	                                      document.organizationandnavigation.submit();">
	                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
	                        <c:forEach var="studyPlanStatus" items="${allStudyPlanStatuses}">
	                           <c:choose>
	                                <c:when test="${studySettings.studyPlanStatus.code == studyPlanStatus.code}"> 
	                                    <option value="${studyPlanStatus.code}" selected="selected"><c:out value="${studyPlanStatus.description}"/></option>
	                                </c:when>
	                                <c:otherwise>
	                                    <option value="${studyPlanStatus.code}"><c:out value="${studyPlanStatus.description}"/></option>
	                                </c:otherwise>
	                            </c:choose>
	                        </c:forEach>
	                    </select>
	                    </td> 
	                    <td></td>
	               </tr>
	            </table>
            </c:if>

  