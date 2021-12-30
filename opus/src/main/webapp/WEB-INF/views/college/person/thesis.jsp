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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="navigationSettings" value="${staffMemberForm.navigationSettings}" />
    <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
    <c:set var="tab" value="${navigationSettings.tab}" />
    <c:set var="panel" value="${navigationSettings.panel}" />

    <c:set var="thesisId"  value="${thesisForm.thesis.id}" scope="page" />
    <c:set var="thesisSupervisors"  value="${thesisForm.thesis.thesisSupervisors}" scope="page" />
    <c:set var="thesisStatuses"  value="${thesisForm.thesis.thesisStatuses}" scope="page" />
    <c:set var="student"  value="${thesisForm.student}" />
    <c:set var="studyPlan"  value="${thesisForm.studyPlan}" />

    <sec:authorize access="hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA','UPDATE_STUDY_PLANS')">
        <c:set var="editSubscriptionData" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA')">
        <sec:authorize access="hasRole('READ_STUDENT_SUBSCRIPTION_DATA') or ${personId == opusUser.personId}">
            <c:set var="showSubscriptionData" value="${true}"/>
        </sec:authorize>
    </sec:authorize>

    <div id="tabcontent">
        <fieldset>
            <legend>
                <a href="<c:url value='/college/students.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                <a href="<c:url value='/college/student/subscription.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
                <c:choose>
                    <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                        <c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                        <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
                </a> 
                &nbsp;>&nbsp;<a href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=0&panel=0&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
                <c:choose>
                    <c:when test="${studyPlan.studyPlanDescription != null && studyPlan.studyPlanDescription != ''}" >
                        <c:out value="${fn:substring(studyPlan.studyPlanDescription,0,initParam.iTitleLength)}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
                </a>
                &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.thesis" />
            </legend>
        </fieldset>

        <form:form modelAttribute="thesisForm" method="post" >

        <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value="<c:out value="${thesisForm.navigationSettings.tab}" />" />
        <input type="hidden" id="navigationSettings.panel" name="navigationSettings.panel" value="<c:out value="${thesisForm.navigationSettings.panel}" />" />

        <div id="tp1" class="TabbedPanel" onclick="document.getElementById('navigationSettings.tab').value=tp1.getCurrentTabIndex();document.getElementById('navigationSettings.panel').value=window['Accordion'+tp1.getCurrentTabIndex()].getCurrentPanelIndex(); ">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.thesis" /></li>    
                <c:choose>
                    <c:when test="${0 != thesisId}">
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.content" /></li>  
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.thesis.people.involved" /></li>  
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.thesis.committees" /></li>                           
                    </c:when>
                </c:choose>
            </ul>

            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.details" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <tr><td colspan="2">&nbsp;</td></tr>
        
                                    <!-- CODE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.code" /></td>
                                        <td>
                                            <form:input path="thesis.thesisCode" size="40" />
<%--                                             <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /> --%>
                                        </td>
                                        <td><fmt:message key="jsp.general.message.codegenerated" />
<%--                                             <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach> --%>
                                            <form:errors path="thesis.thesisCode" cssClass="error"/>
                                        </td>
                                    </tr>

                                    <!-- DESCRIPTION -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.name" /></td>
                                        <td class="required">
                                            <form:input path="thesis.thesisDescription" size="40" />
<%--                                             <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.thesisDescription" cssClass="error"/>
                                        </td>
                                    </tr>

                                    <!-- CREDIT AMOUNT -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.subject.credit" /></td>
                                        <td class="required">
                                            <form:input path="thesis.creditAmount" size="40" />
<%--                                             <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.creditAmount" cssClass="error"/>
                                        </td>
                                    </tr>

                                    <!-- BRs PASSING THESIS -->
								    <c:choose>
								        <c:when test="${!endGradesPerGradeType}">
  		                                    <tr>
		                                        <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
		                                        <td>
                                                    <form:input path="thesis.brsPassingThesis" size="3" maxlength="6" />
<%-- 		                                            <input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" /> --%>
		                                            &nbsp;&nbsp;<fmt:message key="jsp.general.minimummark" />: ${study.minimumMarkSubject}, <fmt:message key="jsp.general.maximummark" />: ${study.maximumMarkSubject}
		                                        </td>
		                                        <td>
                                                    <form:errors path="thesis.brsPassingThesis" cssClass="error"/>
                                                </td>
		                                    </tr>
                                        </c:when>
                                    </c:choose>

                                    <!-- academic year in which the thesis is started -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                        <td class="required">
                                            <form:select path="thesis.startAcademicYearId">
                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="academicYear" items="${thesisForm.allAcademicYears}">
                                                    <form:option value="${academicYear.id}" label="${academicYear.description}" />
<%--                                                     <c:choose>
                                                         <c:when test="${academicYear.id != 0
                                                                      && academicYear.id == status.value}">
                                                             <option value="${academicYear.id}" selected="selected"><c:out value="${academicYear.description}"/></option> 
                                                         </c:when>
                                                         <c:otherwise>
                                                             <option value="${academicYear.id}"><c:out value="${academicYear.description}"/></option> 
                                                         </c:otherwise>
                                                     </c:choose> --%>
                                                </c:forEach>
                                            </form:select>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.startAcademicYearId" cssClass="error"/>
                                        </td>
                                    </tr>

                                    <!--  ACTIVE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.active" /></td>
                                        <td>
                                            <form:select path="thesis.active">
                                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                            </form:select>
<%--                                        <select name="${status.expression}">
                                            <c:choose>
                                                <c:when test="${'Y' == status.value}">
                                                    <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                    <option value="N"><fmt:message key="jsp.general.no" /></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                    <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                                </c:otherwise>
                                               </c:choose>
                                        </select> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.active" cssClass="error"/>
                                        </td>
                                    </tr>

                                    <!-- submit button -->  
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                        <td>&nbsp;</td>
                                    </tr>

                                    <c:if test="${0 != thesisId}">

                                    <!-- THESIS STATUS -->
                                    <tr><td colspan="3">&nbsp;</td></tr>
                                    <tr><td colspan="3"><hr/></td></tr>
                                    <tr>
                                        <td class="header">
                                            <fmt:message key="jsp.general.status" />
                                        </td>
                                        <td colspan="2" align="right">
                                            <c:if test="${editSubscriptionData}">
                                                <a class="button" href="<c:url value='/college/thesisstatus.view'/>?<c:out value='newForm=true&tab=0&panel=0&thesisId=${thesisId}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </c:if>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="3">
                                            <table class="tabledata2" id="TblData2_thesisstatuses">
                                            <c:if test="${thesisStatuses != null && not empty thesisStatuses}">  
                                                <tr>
                                                    <th><fmt:message key="jsp.general.startdate" /></th>
                                                    <th><fmt:message key="jsp.general.thesisstatus" /></th>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="thesisStatus" items="${thesisStatuses}">
                                                <tr>
                                                    <td>
                                                        <c:if test="${editSubscriptionData}">
                                                            <a href="<c:url value='/college/thesisstatus.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${student.studentId}&studyPlanId=${studyPlan.id}&thesisId=${thesisId}&thesisStatusId=${thesisStatus.id}&currentPageNumber=${currentPageNumber}'/>">
                                                            <fmt:formatDate value="${thesisStatus.startDate}" pattern="dd/MM/yyyy"/>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${showSubscriptionData}">
                                                            <fmt:formatDate value="${thesisStatus.startDate}" pattern="dd/MM/yyyy"/>
                                                        </c:if>
                                                    </td>
                                                    <td><c:out value="${thesisStatus.status.description}"/></td>
                                                    <td align="right">
                                                        <c:if test="${editSubscriptionData}">
                                                            <a href="<c:url value='/college/thesisstatus.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${student.studentId}&studyPlanId=${studyPlan.id}&thesisId=${thesisId}&thesisStatusId=${thesisStatus.id}&currentPageNumber=${currentPageNumber}'/>">
                                                                <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                                            </a>
                                                            &nbsp;&nbsp;
                                                            <a href="<c:url value='/college/thesisstatus_delete.view'/>?<c:out value='tab=0&panel=0&studentId=${student.studentId}&studyPlanId=${studyPlan.id}&thesisId=${thesisId}&thesisStatusId=${thesisStatus.id}&currentPageNumber=${currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.thesisstatus.delete.confirm" />')">
                                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </table>
                                            <script type="text/javascript">alternate('TblData2_thesisstatuses',true)</script>
                                        </td>
                                    </tr>
                                    </c:if>
                                </table>

                            <!--  einde accordionpanelcontent -->
                            </div>
                        <!--  einde accordionpanel -->
                        </div>
                        <c:choose>
                        <c:when test="${0 != thesisId}">
                        <!-- RESEARCH -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.research" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.research" /></td>
<%--                                         <spring:bind path="command.research"> --%>
                                        <td>
                                            <form:textarea path="thesis.research" cols="50" rows="10" />
<%--                                             <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.research" cssClass="error"/>
                                        </td>
<%--                                         </spring:bind> --%>
                                    </tr>
                                    <!-- submit button -->
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>

                            </div> <!--  einde accordionpanelcontent -->
                        </div> <!--  einde accordionpanel -->
                        
                        <!-- PUBLICATIONS -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.publications" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.publications" /></td>
<%--                                         <spring:bind path="command.publications"> --%>
                                        <td>
                                            <form:textarea path="thesis.publications" cols="50" rows="10" />
<%--                                             <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.publications" cssClass="error"/>
                                        </td>
<%--                                         </spring:bind> --%>
                                    </tr>
                                    <!-- submit button -->  
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                            </div> <!--  einde accordionpanelcontent -->
                        </div> <!--  einde accordionpanel -->

                        <!-- KEYWORDS -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.keywords" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.keywords" /></td>
<%--                                         <spring:bind path="command.keywords"> --%>
                                        <td>
                                            <form:textarea path="thesis.keywords" cols="50" rows="10" />
<%--                                             <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea> --%>
                                        </td>
                                        <td>
                                            <form:errors path="thesis.keywords" cssClass="error"/>
                                        </td>
<%--                                         </spring:bind> --%>
                                    </tr>
                                    <!-- submit button -->  
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                
                            </div> <!--  einde accordionpanelcontent -->
                        </div> <!--  einde accordionpanel -->
                    </c:when>
                    </c:choose>
                    <!-- end of accordion 1 -->
                    </div>

                    <script type="text/javascript">
                        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
                    </script>
                 
                <!--  einde tabbedpanelscontent -->
                </div>

<!--------------------------------- THESISCONTENT TAB ------------------------------------->
                <c:choose>
                    <c:when test="${'' != thesisId && 0 != thesisId}">
                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion1" tabindex="0">
        
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.content" /></div>
                                    <div class="AccordionPanelContent">

                                             <table>
                                        		<tr><td>&nbsp;</td></tr>
                                                <!-- CONTENT DESCRIPTION -->
                                                <tr>
                                                    <spring:bind path="thesis.thesisContentDescription">
                                                    <%-- height to avoid disappearance of submit button can be set either with td height or textarea rows --%>
                                                    <td height="400">
                                                        <textarea id="${status.expression}" name="${status.expression}" ><c:out value="${status.value}"/></textarea>
                                                        <script>
                                                            // Replace the <textarea id="..."> with a CKEditor
                                                            CKEDITOR.replace( '${status.expression}', {
                                                                height: 280
                                                            } );
                                                        </script>
                                                    </td>
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </tr>
                                                <!-- submit button -->  
                                                <tr><td>&nbsp;</td></tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                </tr>
                                            </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>
                            
                            <!-- end of accordion 1 -->
                            </div>
                            <script type="text/javascript">
                                var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                                
                            </script>
                           
                        <!--  einde tabbedpanelscontent -->
                        </div>
                
<!--------------------------------- END THESISCONTENT TAB ------------------------------------->

<!--------------------------------- PEOPLE INVOLVED TAB ------------------------------------->
                
                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion2" tabindex="0">
        
                                <!-- accordion researchers -->
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.researchers" /></div>
                                    <div class="AccordionPanelContent">
                                    
        
                                            <table>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.researchers" /></td>
                                                    <spring:bind path="thesis.researchers">
                                                    <td>
                                                        <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea>
                                                    </td>
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </tr>
                                                <!-- submit button -->  
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>
                                
                                <!-- accordion supervisors -->
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.supervisors" /></div>
                                    <div class="AccordionPanelContent">
                                        <table>
                                            <tr><td colspan="3">&nbsp;</td></tr>
                                            <tr>
                                                <td colspan="2" class="emptywide">
                                                    <c:if test="${not empty txtMsg}">
                                                        <p class="msgwide">
                                                            ${txtMsg }
                                                        </p>
                                                    </c:if>
                                                </td>
                                                <td align="right"><a class="button"  href="<c:url value='/college/thesissupervisor.view'/>?<c:out value='newForm=true&tab=2&panel=1&thesisId=${thesisId}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a></td>
                                            </tr>
                                            <tr><td colspan="3">&nbsp;</td></tr>
                                            <c:choose>
                                                <c:when test="${thesisSupervisors != null && not empty thesisSupervisors}">  
                                                    <tr>
                                                        <td colspan="3">
                                                            <table class="tabledata2" id="thesisSupervisorTblData">   
                                                            <tr>
                                                                <th><fmt:message key="jsp.general.name" /></th>
                                                                <th><fmt:message key="jsp.general.address" /></th>
                                                                <th><fmt:message key="jsp.general.telephone" /></th>
                                                                <th><fmt:message key="jsp.general.email" /></th>
                                                                <th><fmt:message key="jsp.general.active" /></th>
                                                                <th><fmt:message key="jsp.thesis.principal.supervisor" /></th>
                                                            </tr>
                                                            <c:forEach var="thesisSupervisor" items="${thesisSupervisors}">
                                                                <tr>
                                                                    <td><c:out value="${thesisSupervisor.name}"/></td>
                                                                    <td><c:out value="${thesisSupervisor.address}"/></td>
                                                                    <td><c:out value="${thesisSupervisor.telephone}"/></td>
                                                                    <td><c:out value="${thesisSupervisor.email}"/></td>
                                                                    <td><c:out value="${thesisSupervisor.active}"/></td>
                                                                    <td><c:out value="${thesisSupervisor.principal}"/></td>
                                                                    <td class="buttonsCell">
                                                                        <a href="<c:url value='/college/thesissupervisor.view'/>?<c:out value='newForm=true&tab=2&panel=1&thesisId=${thesisId}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}&thesisSupervisorId=${thesisSupervisor.id}'/>" >
                                                                            <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                                                        </a>&nbsp;<a href="<c:url value='/college/thesissupervisor_delete.view'/>?<c:out value='tab=2&panel=1&thesisId=${thesisId}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}&thesisSupervisorId=${thesisSupervisor.id}'/>" onclick="return confirm('<fmt:message key="jsp.thesissupervisor.delete.confirm" />')">
                                                                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                        </a>
                                                                    </td> 
                                                                </tr>
                                                            </c:forEach>
                                                            </table>
                                                            <script type="text/javascript">alternate('thesisSupervisorTblData',true)</script>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                            </c:choose>
                                        </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>

                            <!-- end of accordion 1 -->
                            </div>
                            <script type="text/javascript">
                                var Accordion2 = new Spry.Widget.Accordion("Accordion2",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                            </script>
                           
                        <!--  einde tabbedpanelscontent -->
                        </div>

<!--------------------------------- END PEOPLE INVOLVED TAB ------------------------------------->

<!--------------------------------- COMMITTEES TAB ------------------------------------->
                
                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion3" tabindex="0">
        
                                <!-- accordion reading committee -->
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.committee.reading" /></div>
                                    <div class="AccordionPanelContent">
                                    
        
                                            <table>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.committee.reading" /></td>
                                                    <spring:bind path="thesis.readingCommittee">
                                                    <td>
                                                        <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea>
                                                    </td>
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </tr>
                                                <!-- submit button -->  
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>
                                
                                <!-- accordion defense committee -->
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.committee.defense" /></div>
                                    <div class="AccordionPanelContent">
                                    
        
                                            <table>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.committee.defense" /></td>
                                                    <spring:bind path="thesis.defenseCommittee">
                                                    <td>
                                                        <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea>
                                                    </td>
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </tr>
                                                <!-- submit button -->  
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>
                                
                                <!-- accordion statusOfClearness -->
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab"><fmt:message key="jsp.committee.statusofclearness" /></div>
                                    <div class="AccordionPanelContent">
                                    
        
                                            <table>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.committee.statusofclearness" /></td>
                                                    <spring:bind path="thesis.statusOfClearness">
                                                    <td>
                                                        <textarea id="${status.expression}" name="${status.expression}" cols="50" rows="10"><c:out value="${status.value}"/></textarea>
                                                    </td>
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </tr>
                                                <!-- submit button -->  
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                    <!--  einde accordionpanelcontent -->
                                    </div>
                                <!--  einde accordionpanel -->
                                </div>
                            
                            <!-- end of accordion 1 -->
                            </div>
                            <script type="text/javascript">
                                var Accordion3 = new Spry.Widget.Accordion("Accordion3",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                                
                            </script>
                           
                        <!--  einde tabbedpanelscontent -->
                        </div>
                
<!--------------------------------- END COMMITTEES TAB ------------------------------------->
                    </c:when>
                </c:choose>  <!-- end check if thesis exists --> 
  
            <!--  einde tabbed panelscontentgroup -->    
            </div>
            
        <!--  einde tabbed panel -->    
        </div>

        </form:form>
        
    <!-- einde tabcontent -->
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>
   
<!-- einde tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>