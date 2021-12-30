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

The Original Code is Opus-College fee module code.

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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="feeBranchesForm.navigationSettings">
        <c:set var="navSettings" value="${status.value}" scope="page" />
    </spring:bind>  
    

	
    <div id="tabcontent">
 
		<fieldset>
		<legend>
		<fmt:message key="jsp.fees.header.studies" />
		&nbsp;&nbsp;&nbsp;
        <c:if test="${accessContextHelp}">
             <a class="white" href="<c:url value='/help/FeesDefinition.pdf'/>" target="_blank">
                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
             </a>&nbsp;
        </c:if>
		</legend>
        
		</fieldset>

		<c:set var="allEntities" value="${allStudies}" scope="page" />
		<c:set var="redirView" value="feesstudies" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <tr>
            <th class="label"><fmt:message key="jsp.general.academicyear" /></th>
            <th class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></th>
            <th class="label"><fmt:message key="jsp.general.studyintensity" /></th>
            <th class="label"><fmt:message key="jsp.general.studytime" /></th>
            <th class="label"><fmt:message key="jsp.general.studyform" /></th>            
            <th class="label"><fmt:message key="jsp.fees.category" /></th>
            <th class="label"><fmt:message key="jsp.general.feedue" /></th>
            <th class="label"><fmt:message key="jsp.fee.feeunit" /></th>
            <th class="label"><fmt:message key="jsp.general.active" /></th>
            <th class="buttonsCell">
                <a class="button" href="<c:url value='/fee/feeAcademicYear.view?tab=0&panel=0&currentPageNumber=${navSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
            </th>
        </tr>
        <c:forEach var="feeForBranch" items="${feeBranchesForm.allFeesForEducationAreas}">
            <tr>
                <td>
                    <c:forEach var="academicYear" items="${feeBranchesForm.allAcademicYears}">
                         <c:choose>
                             <c:when test="${academicYear.id != 0
                                          && academicYear.id == feeForBranch.academicYearId}">
                                &nbsp;${academicYear.description}
                             </c:when>
                         </c:choose>
                    </c:forEach>
                </td>
                <%-- cardinal time unit number: 0 (any), 1, 2, 3, ... --%>
                <td>
                    <c:choose>
                        <c:when test="${feeForBranch.cardinalTimeUnitNumber == 0}">
                            <fmt:message key="jsp.general.any" />
                        </c:when>
                        <c:otherwise>
                            ${feeForBranch.cardinalTimeUnitNumber }
                        </c:otherwise>
                    </c:choose>
                </td>
                 <%-- study intensity --%>
                <td>
                    ${feeBranchesForm.codeToStudyIntensityMap[feeForBranch.studyIntensityCode].description }
                </td>
                <%-- study time: day/evening --%>
                <td>
                    ${feeBranchesForm.codeToStudyTimeMap[feeForBranch.studyTimeCode].description }
                </td>
                <%-- study form: regular/parallel etc --%>
                <td>
                    ${feeBranchesForm.codeToStudyFormMap[feeForBranch.studyFormCode].description }
                </td>
				<%-- fee category: tuition/medical/examinations etc --%>
                <td>
                    ${feeBranchesForm.codeToFeeCategoryMap[feeForBranch.categoryCode].description }
                </td>
                <%-- feeDue --%>
                <td style="text-align: center">
                    <a href="<c:url value='/fee/feeAcademicYear.view?feeId=${feeForBranch.id}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                        ${feeForBranch.feeDue}
                    </a>
                </td>
                <%-- fee unit --%>
                <td>
                    ${feeBranchesForm.codeToFeeUnitMap[feeForBranch.feeUnitCode].description }
                </td>
                <td style="text-align: center">
					<c:choose>
						<c:when test="${'Y' == feeForBranch.active}">
							<fmt:message key="jsp.general.yes" />
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.general.no" />
						</c:otherwise>
						</c:choose>
				</td>
                <td class="buttonsCell"><a href="<c:url value='/fee/feeAcademicYear.view?branchId=${branch.id}&feeId=${feeForBranch.id}&currentPageNumber=${navSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                   &nbsp;&nbsp;
                    <a href="<c:url value='/fee/fee_delete.view?tab=1&panel=0&branchId=${branch.id}&feeId=${feeForBranch.id}&currentPageNumber=${navSettings.currentPageNumber}'/>" 
                       onclick="return confirm('<fmt:message key="jsp.fees.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                 </td>
            </tr>
        </c:forEach>

        <tr><th colspan="9">&nbsp;</th></tr> 
           
        <tr><td colspan="4"></td></tr>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooter.jsp"%>

        <br /><br />
    </div>
    
</div>

<%@ include file="../../footer.jsp"%>
