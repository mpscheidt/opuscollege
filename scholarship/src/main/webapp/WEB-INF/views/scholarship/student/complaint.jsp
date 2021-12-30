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

The Original Code is Opus-College scholarship module code.

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
    
    <div id="tabcontent">

            <fieldset><legend>
                <a href="<c:url value='/scholarship/students.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=${tab}&panel=${panel}&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
                    <c:choose>
                        <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                            <c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                            ${fn:substring(studentName,0,initParam.iTitleLength)}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                </a>
                    <br />&nbsp;&nbsp;&nbsp;>&nbsp;
                    <c:choose>
                        <c:when test="${scholarshipApplication.scholarshipAppliedForId != null 
                                    && scholarshipApplication.scholarshipAppliedForId != ''}" >
                            <c:forEach var="scholarship" items="${allScholarships}">
                                <c:choose>
                                   <c:when test="${scholarship.id == scholarshipApplication.scholarshipAppliedForId}">
                                       <c:forEach var="scholarshipType" items="${allScholarshipTypes}">
                                           <c:choose>
                                               <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                                   <c:forEach var="academicYear" items="${allAcademicYears}">
                                                        <c:choose>
                                                            <c:when test="${academicYear.id == scholarship.sponsor.academicYearId}">
                                                                   <c:set var="academicYearDescription"  value="${academicYear.description}" scope="page" />
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>      
                                                    <c:set var="scholarshipAppDescription"  value="${scholarshipType.description} - ${academicYearDescription}" scope="page" />
                                                    <a href="<c:url value='/scholarship/scholarshipapplication.view?scholarshipApplicationId=${scholarshipApplication.id }&studentId=${studentId}&currentPageNumber=${currentPageNumber}'/>">
                                                    ${fn:substring(scholarshipAppDescription,0,initParam.iTitleLength)}
                                                    </a>
                                               </c:when>
                                           </c:choose>
                                       </c:forEach>
                                   </c:when>
                                </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    &nbsp;>&nbsp;
                    <spring:bind path="command.reason">
                    <c:choose>
                        <c:when test="${status.value != null 
                                    && status.value != ''}" >
                              ${fn:substring(status.value,0,initParam.iTitleLength)}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    </spring:bind>
                    &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" /> <fmt:message key="jsp.general.complaint"/>
                     
            </legend>
        </fieldset>
        
        <div id="tp1" class="TabbedPanel">
           <!-- <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.complaint" /></li>    
            </ul> -->

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.complaint" /></div>
                            <div class="AccordionPanelContent">
                            
                                <table>
                                    <form name="formdata" method="POST">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.date" /></td>
                                            <spring:bind path="command.complaintDate">
                                                <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                <td class="required">
                                                <table>
                                                    <tr>
                                                        <td><fmt:message key="jsp.general.day" /></td>
                                                        <td><fmt:message key="jsp.general.month" /></td>
                                                        <td><fmt:message key="jsp.general.year" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td><input type="text" id="complaint_day" name="complaint_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('complaintDate','day',document.getElementById('complaint_day').value);"  /></td>
                                                        <td><input type="text" id="complaint_month" name="complaint_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('complaintDate','month',document.getElementById('complaint_month').value);" /></td>
                                                        <td><input type="text" id="complaint_year" name="complaint_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('complaintDate','year',document.getElementById('complaint_year').value);" /></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <fmt:message key="jsp.general.message.dateformat" />
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
                                        </tr>
                                        <!-- REASON FOR COMPLAINT -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.reason" /></td>
                                            <spring:bind path="command.reason">
                                            <td class="required">
                                                <textarea rows="6" cols="24" name="${status.expression }">${status.value }</textarea>
                                            </td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- STATUS OF DECISION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.status" /></td>
                                            
                                            <spring:bind path="command.complaintStatusCode">
                                            <td>
                                                <select name="${status.expression }">
                                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneStatus" items="${allComplaintStatuses }" >
                                                    <c:choose>
                                                        <c:when test="${oneStatus.code == status.value }">
                                                            <option value="${oneStatus.code }" selected="selected"> ${oneStatus.description }</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${oneStatus.code }"> ${oneStatus.description }</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                </select>
                                                </td>
                                                
                                                <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- RESULT -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.result" /></td>
                                            <spring:bind path="command.result">
                                                <td>
                                                    <textarea rows="6" cols="24" name="${status.expression }">${status.value }</textarea>
                                                </td>
                                                <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!--  ACTIVE -->
                                        <spring:bind path="command.active">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <td>
                                            <select name="${status.expression}">
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
                                            </select>
                                            </td>
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                        </tr>
                                        </spring:bind>
    
                                       
                                        <!-- SUBMIT BUTTON -->
                                           <tr><td class="label">&nbsp;</td>
                                           <td>
                                           <input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" />
                                           </td>
                                           </tr>
                                    </table>
                                </form>
                                
                            <!--  einde accordionpanelcontent -->
                            </div>
                            
                        <!--  einde accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 0 -->
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
            <!--  einde tabbedpanelscontentgroup -->
            </div>
        <!--  einde tabbed panel -->    
        </div>
        
    <!-- einde tabcontent -->
    </div>   
    
    <%--script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script --%>
   
<!-- einde tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>





