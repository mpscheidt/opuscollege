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

<%@ include file="../../includes/standardincludes.jsp"%>


<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.absences" /></div>
    <div class="AccordionPanelContent">
            <table>
                <sec:authorize access="hasRole('CREATE_STUDENT_ABSENCES')">
                    <tr>
                        <td align="right">
                            <a class="button" href="<c:url value='/college/studentabsence.view'/>?<c:out value='tab=${accordion}&panel=0&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                        </td>
                    </tr>
                </sec:authorize>
                <tr>
                    <td>
                        <c:if test="${not empty student.studentAbsences}" >
                            <table class="tabledata2" id="TblData2_absences">
                                <tr>
                                    <th><fmt:message key="jsp.studentabsence.inactivityperiod" /></th>
                                    <th><fmt:message key="jsp.general.reasonforabsence" /></th>
                                    <th></th>
                                </tr>
                                <c:forEach var="studentAbsence" items="${student.studentAbsences}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${authorizedToEditAbsence}">
                                                    <a href="<c:url value='/college/studentabsence.view'/>?<c:out value='tab=${accordion}&panel=0&studentId=${studentId}&studentAbsenceId=${studentAbsence.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${studentAbsence.startdateTemporaryInactivity}" />
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${studentAbsence.startdateTemporaryInactivity}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${studentAbsence.enddateTemporaryInactivity != '' }">
                                                &nbsp;-&nbsp;<fmt:formatDate pattern="dd/MM/yyyy" value="${studentAbsence.enddateTemporaryInactivity}" />
                                            </c:if>
                                        </td>
                                        <td><c:out value="${studentAbsence.reasonForAbsence}"/></td>
                                        <td class="buttonsCell">
                                            <c:choose>
                                                <c:when test="${authorizedToEditAbsence}">
                                                    <a class="imageLink" href="<c:url value='/college/studentabsence.view'/>?<c:out value='tab=${accordion}&panel=0&studentId=${studentId}&studentAbsenceId=${studentAbsence.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                </c:when>
                                            </c:choose>
                                            <c:if test='${authorizedToDeleteAbsence}'>
                                                <a class="imageLinkPaddingLeft" href="<c:url value='/college/studentabsence_delete.view'/>?<c:out value='tab=${accordion}&panel=0&studentId=${studentId}&studentAbsenceId=${studentAbsence.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studentabsences.delete.confirm" />')">
                                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach> 
                            </table>
                            <script type="text/javascript">alternate('TblData2_absences',true)</script>
                        </c:if>
                    </td>
                </tr>
            </table>
<!-- ------------------------------------------- expulsion -------------------------------------------------------------------------->

    </div> <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->

<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.expellationdata" /></div>
    <div class="AccordionPanelContent">
        <table>
            <sec:authorize access="hasRole('CREATE_STUDENT_ABSENCES')">
                <tr>
                    <td align="right">
                        <a class="button" href="<c:url value='/college/studentexpulsion.view'/>?<c:out value='tab=${accordion}&panel=1&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                    </td>
                </tr>
            </sec:authorize>
            <tr>
                <td>
                    <c:if test="${not empty student.studentExpulsions}" >
                        <table class="tabledata2" id="TblData2_expulsions">
                            <tr>
                                <th><fmt:message key="jsp.general.expellationperiod" /></th>
                                <th><fmt:message key="jsp.general.expelledfor" /></th>
                                <th></th>
                            </tr>
                            <c:forEach var="studentExpulsion" items="${student.studentExpulsions}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${authorizedToEditAbsence}">
                                                <a href="<c:url value='/college/studentexpulsion.view'/>?<c:out value='tab=${accordion}&panel=1&studentId=${studentId}&studentExpulsionId=${studentExpulsion.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                <fmt:formatDate pattern="dd/MM/yyyy" value="${studentExpulsion.startDate}" />
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate pattern="dd/MM/yyyy" value="${studentExpulsion.startDate}" />
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${studentExpulsion.endDate != '' }">
                                            &nbsp;-&nbsp;<fmt:formatDate pattern="dd/MM/yyyy" value="${studentExpulsion.endDate}" />
                                        </c:if>
                                    </td>
                                    <td><c:out value="${studentExpulsion.expulsionType.description}"/></td>
                                    <td class="buttonsCell">
                                        <c:choose>
                                            <c:when test="${authorizedToEditAbsence}">
                                                <a class="imageLink" href="<c:url value='/college/studentexpulsion.view'/>?<c:out value='tab=${accordion}&panel=1&studentId=${studentId}&studentExpulsionId=${studentExpulsion.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                            </c:when>
                                        </c:choose>
                                        <c:if test='${authorizedToDeleteAbsence}'>
                                            <a class="imageLinkPaddingLeft" href="<c:url value='/college/studentexpulsion_delete.view'/>?<c:out value='tab=${accordion}&panel=1&studentId=${studentId}&studentExpulsionId=${studentExpulsion.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studentexpulsions.delete.confirm" />')">
                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach> 
                        </table>
                        <script type="text/javascript">alternate('TblData2_expulsions',true)</script>
                    </c:if>
                </td>
            </tr>
        </table>
    </div> <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->

<!----------------------------- Penalties/fines ------------------------------------------------->                            
<c:if test="${modules != null && modules != ''}">
    <c:forEach var="module" items="${modules}">
        <c:if test="${fn:toLowerCase(module.module) == 'fee'}">
            <c:choose>
                <c:when test="${(showAbsences || editAbsences)
                        && '' != form.student.studentId && 0 != form.student.studentId}">
                  
                    <div class="AccordionPanel">
                        <div class="AccordionPanelTab"><fmt:message key="jsp.general.penalties" /></div>
                        <div class="AccordionPanelContent">
                                <table>
                                    <sec:authorize access="hasRole('CREATE_STUDENT_ABSENCES')">
                                    <tr>
                                        <td colspan="3" align="right">
                                            <a class="button" href="<c:url value='/college/penalty.view'/>?<c:out value='tab=${accordion}&panel=2&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                        </td>
                                    </tr>
                                </sec:authorize>
                                <tr>
                                    <td colspan="3">
                                        <table class="tabledata2" id="TblData2_penalties">
                                        <c:if test="${not empty student.penalties}" >
                                            <tr>
                                                <th><fmt:message key="jsp.penalty.startdate" />&nbsp;-&nbsp;<fmt:message key="jsp.penalty.enddate" /></th>
                                                <th><fmt:message key="jsp.penalty.type" /></th>
                                                <th><fmt:message key="jsp.penalty.amount" /></th>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="penalty" items="${student.penalties}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${authorizedToEditAbsence}">
                                                            <a href="<c:url value='/college/penalty.view'/>?<c:out value='tab=${accordion}&panel=2&studentId=${studentId}&penaltyId=${penalty.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                            <fmt:formatDate pattern="dd/MM/yyyy" value="${penalty.startDate}" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatDate pattern="dd/MM/yyyy" value="${penalty.startDate}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${penalty.endDate != '' }">
                                                        &nbsp;-&nbsp;<fmt:formatDate pattern="dd/MM/yyyy" value="${penalty.endDate}" />
                                                    </c:if>
                                                </td>
                                                <td><c:out value="${penalty.penaltyType.description}"/></td>
                                                <td><c:out value="${penalty.amount}"/></td>
                                                <td class="buttonsCell">
                                                    <c:choose>
                                                        <c:when test="${authorizedToEditAbsence}">
                                                            <a class="imageLink" href="<c:url value='/college/penalty.view'/>?<c:out value='tab=${accordion}&panel=2&studentId=${studentId}&penaltyId=${penalty.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                        </c:when>
                                                    </c:choose>
                                                    <c:if test='${authorizedToDeleteAbsence}'>
                                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/penalty_delete.view'/>?<c:out value='tab=${accordion}&panel=2&studentId=${studentId}&penaltyId=${penalty.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.penalty.delete.confirm" />')">
                                                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                        </a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach> 
                                        </table>
                                    </td>
                                </tr>
                                <script type="text/javascript">alternate('TblData2_penalties',true)</script>
                            </table>
                              </div> <!--  end accordionpanelcontent -->
                    </div> <!--  end accordionpanel -->
                            
                </c:when>
            </c:choose>     
        </c:if>
    </c:forEach>
</c:if>

