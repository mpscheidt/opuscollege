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

<%-- Expecting the following variables to be present:
        - appUseOfSubjectBlocks
        - editSubscriptionData
        - showSubscriptionData
        - studyPlanCardinalTimeUnit
        - studyPlanDetails
        - form.allSubjectBlockStudyGradeTypes
        - form.allSubjectStudyGradeTypes
        - form.idToAcademicYearMap
        - form.idToStudyGradeTypeMap
        - form.idToStudyMap
        - form.idToSubjectBlockMap
        - form.idToSubjectMap
        - form.codeToImportanceTypeMap
        - form.codeToRigidityTypeMap
        - form.codeToStudyFormMap
        - form.codeToStudyTimeMap
 --%>

<!--  STUDY PLAN DETAILS -->
<c:choose>
	<c:when test="${not empty studyPlanDetails && not empty studyPlanDetails[0]}" > 
        <!-- list of studyplandetails -->
		<tr>
		    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
      		    <th><fmt:message key="jsp.general.subjectblock" /></th>
      		</c:if>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.subject" /></th>
            <c:if test="${initParam.iMajorMinor == 'Y'}">
                <th class="width1"><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></th>
            </c:if>
            <th class="width1"><fmt:message key="jsp.general.compulsory" /> / <fmt:message key="jsp.general.elective" /></th>
            <th colspan="4"><fmt:message key="jsp.general.studygradetype" /></th>
            <th><fmt:message key="general.exempted" /></th>
            <th>&nbsp;</th>
        </tr>

		<c:forEach var="oneStudyPlanDetail" items="${studyPlanDetails}">
            
            <%-- Flag as indicator to the common columns (e.g. buttons) if row is shown.
                 Row is not shown if subject block, but use of subject blocks is disabled by appConfig parameter  --%>
            <c:set var="rowDisplayed" value="${false}" />
            <c:set var="subjectBlock" value="" />
            <c:set var="subject" value="" />

                 <%-- subject blocks --%>
                 <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                    <c:if test="${oneStudyPlanDetail.subjectBlockId != 0}" >
                        <c:set var="rowDisplayed" value="${true}" />
                        <c:set var="subjectBlock" value="${form.idToSubjectBlockMap[oneStudyPlanDetail.subjectBlockId]}" />

                        <%-- authorization: METADATA subjectblock - STUDYGRADETYPE has to be present --%>
				     	<c:forEach var="oneSubjectBlockStudyGradeType" items="${form.allSubjectBlockStudyGradeTypes}" >
	                        <c:choose>
	                        	<c:when test="${oneStudyPlanDetail.subjectBlockId == oneSubjectBlockStudyGradeType.subjectBlock.id
	                        				&& oneStudyPlanDetail.studyGradeTypeId == oneSubjectBlockStudyGradeType.studyGradeType.id}">
                                    <c:set var="subjectBlockStudyGradeType" value="${oneSubjectBlockStudyGradeType}" />
                                </c:when>
                            </c:choose>
                        </c:forEach>

                        <c:set var="oneStudyGradeType" value="${form.idToStudyGradeTypeMap[oneStudyPlanDetail.studyGradeTypeId]}" />

                        <c:set var="importanceTypeCode" value="${subjectBlockStudyGradeType.importanceTypeCode}" />
                        <c:set var="rigidityTypeCode" value="${subjectBlockStudyGradeType.rigidityTypeCode}" />

		         	</c:if> <%--oneStudyPlanDetail.subjectBlockId != 0 --%>
                </c:if>

		      	<!-- subject -->
		        <c:choose>
		          	<c:when test="${oneStudyPlanDetail.subjectId != 0}" >
                        <c:set var="rowDisplayed" value="${true}" />

                        <%-- TODO need to add rigidityTypeCode to StudyPlanDetail table and class because for repeated subjects the status is not clear,
                                  and it is randomly shown (optional or mandatory) simply depending on the previous displayed item  --%>
                    	<c:forEach var="oneSubjectStudyGradeType" items="${form.allSubjectStudyGradeTypes}" >
                    		<c:choose>
	                        	<c:when test="${oneStudyPlanDetail.subjectId == oneSubjectStudyGradeType.subjectId
	                        				&& oneStudyPlanDetail.studyGradeTypeId == oneSubjectStudyGradeType.studyGradeTypeId}">
                        		    <c:set var="currentSubjectStudyGradeType" value="${oneSubjectStudyGradeType}" scope="page" />
		                        </c:when>
                             </c:choose>
                        </c:forEach>
                        <c:set var="oneStudyGradeType" value="${form.idToStudyGradeTypeMap[oneStudyPlanDetail.studyGradeTypeId]}" />

                        <c:set var="subject" value="${form.idToSubjectMap[oneStudyPlanDetail.subjectId]}" />

                        <c:set var="importanceTypeCode" value="${currentSubjectStudyGradeType.importanceTypeCode}" />
                        <c:set var="rigidityTypeCode" value="${currentSubjectStudyGradeType.rigidityTypeCode}" />
						
                   	</c:when>
              	</c:choose> <%-- oneStudyPlanDetail.subjectId != 0 --%>
    
            <c:if test="${rowDisplayed}">

                <tr>
                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                        <td>
                            <c:if test="${not empty subjectBlock}">
                                <c:set var="subjectBlockString">
                                    <fmt:message key="format.subjectblockdescription.academicyear.studytime">
                                        <fmt:param><c:out value="${subjectBlock.subjectBlockDescription}"/></fmt:param>
                                        <fmt:param><c:out value="${form.idToAcademicYearMap[subjectBlock.currentAcademicYearId].description}"/></fmt:param>
                                        <fmt:param><c:out value="${form.codeToStudyTimeMap[subjectBlock.studyTimeCode].description}"/></fmt:param>
                                    </fmt:message>
                                </c:set>
                                <c:if test="${editSubscriptionData}">
                                    <a href="<c:url value='/college/subjectblock.view'/>?<c:out value='newForm=true&tab=0&panel=0&from=student&subjectBlockId=${subjectBlock.id}'/>">
                                        <c:out value="${subjectBlockString}"/>
                                    </a>
                                </c:if>
                                <c:if test="${showSubscriptionData || personId == opusUser.personId }">
                                     <c:out value="${subjectBlockString}"/>
                                </c:if>
                            </c:if>
                        </td>
                    </c:if>

                    <td>
                        <c:if test="${not empty subject}">
                            <c:out value="${subject.subjectCode}"/>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty subject}">
                            <c:set var="subjectString">
                                <fmt:message key="format.subjectdescription.academicyear.studytime">
                                    <fmt:param value="${subject.subjectDescription}" />
                                    <fmt:param value="${form.idToAcademicYearMap[subject.currentAcademicYearId].description}" />
                                    <fmt:param value="${form.codeToStudyTimeMap[subject.studyTimeCode].description}" />
                                </fmt:message>
                            </c:set>
                            <c:if test="${editSubscriptionData}">
                                <a href="<c:url value='/college/subject.view'/>?<c:out value='newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&from=student&subjectId=${subject.id}'/>">
                                    <c:out value="${subjectString}"/>
                                </a>
                            </c:if>
                            <c:if test="${showSubscriptionData || personId == opusUser.personId }">
                                <c:out value="${subjectString}"/>
                            </c:if>
                        </c:if>
                    </td>

                    <c:if test="${initParam.iMajorMinor == 'Y'}">
                        <td>
                            <c:out value="${form.codeToImportanceTypeMap[importanceTypeCode].description}"></c:out>
                         </td>
                    </c:if>
                    <td>
                        <c:out value="${form.codeToRigidityTypeMap[rigidityTypeCode].description}"/>
                    </td>
                    <td colspan="4">

                        <c:out value="${oneStudyGradeType.studyDescription}"/>

                        <c:set var="studyGradeTypeString">
                            <fmt:message key="format.gradetype.academicyear.studyform.studytime">
                                <fmt:param value="${oneStudyGradeType.gradeTypeDescription}" />
                                <fmt:param value="${form.idToAcademicYearMap[oneStudyGradeType.currentAcademicYearId].description}" />
                                <fmt:param value="${form.codeToStudyFormMap[oneStudyGradeType.studyFormCode].description}" />
                                <fmt:param value="${form.codeToStudyTimeMap[oneStudyGradeType.studyTimeCode].description}" />
                            </fmt:message>
                        </c:set>
                        <small><c:out value="${studyGradeTypeString}"/></small>
                    </td>
                    <td>
                        <fmt:message key="${booleanToYesNoMap[oneStudyPlanDetail.exempted]}" />
                    </td>

                    <%--  edit and delete button --%>
                    <td class="buttonsCell">
                        <%-- Rule for delete option is not clearly defined yet;
                             In some cases (Zambia) it might be correct to limit deletion to the CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT status,
                             but this does not make sense where this status is not even used.
                             So for now, for deletion use the editSubscriptionData (same as for create and update
                             
                             Further note: There is no "delete studyPlanDetails" privilege yet
                             --%>
                        <c:if test="${(editSubscriptionData) }">
                             <%-- && ( studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT) --%>
    
                            <a href="<c:url value='?deleteStudyPlanDetail=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studyPlanDetailId=${oneStudyPlanDetail.id}&amp;studyPlanId=${studyPlan.id}&amp;cardinalTimeUnitNumber=${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                                onclick="return confirm('<fmt:message key="jsp.studyplandetail.delete.confirm" />')">
                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                            </a>
                        </c:if>
                    </td>
                 </tr>
            </c:if>
         	
 		</c:forEach> <%-- studyplandetail for this studyplancardinaltimeunit --%>

	</c:when>
</c:choose> <%-- studyplandetails for this studyplancardinaltimeunit are not empty %>
<%-- END STUDYPLANDETAILS --%>	
						                                    
