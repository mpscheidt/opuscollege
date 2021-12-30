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
<%@ include file="../../header.jsp"%>


<body>
    <spring:bind path="studyPlanForm.newObtainedQualification">
        <c:set var="newObtainedQualification" value="${status.value}" scope="page" />
    </spring:bind>
    <div id="tabwrapper">
        <%@ include file="../../menu.jsp"%>
        <div id="tabcontent">
                    
            <fieldset>
                <legend>
                    <fmt:message key="jsp.register" />
                </legend>
            </fieldset>
        
            <c:set var="accordion" value="0"/>
            <form name="formdata" method="post">
            <div id="tp1" class="TabbedPanel">
                <div class="TabbedPanelsContentGroup">           
                    <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                        <!-- qualifications obtained -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.qualification.obtained" /></div>
                            <div class="AccordionPanelContent">    
                    
                                <table>
                                <spring:bind path="studyPlanForm.newObtainedQualification.university">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.qualification.university" /></td>
                                    <td><input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="studyPlanForm.newObtainedQualification.startDate">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                                    <td>
                                        <table>
                                        <tr>
                                            <td><fmt:message key="jsp.general.day" /></td>
                                            <td><fmt:message key="jsp.general.month" /></td>
                                            <td><fmt:message key="jsp.general.year" /></td>
                                        </tr>
                                        <tr>
                                            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                            <td><input class="numericField" type="text" id="start_day" name="start_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('newObtainedQualification.startDate','day',document.getElementById('start_day').value);"  /></td>
                                            <td><input class="numericField" type="text" id="start_month" name="start_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('newObtainedQualification.startDate','month',document.getElementById('start_month').value);" /></td>
                                            <td><input class="numericField" type="text" id="start_year" name="start_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('newObtainedQualification.startDate','year',document.getElementById('start_year').value);" /></td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="studyPlanForm.newObtainedQualification.endDate">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.enddate" /></td>
                                    <td>
                                        <table>
                                        <tr>
                                            <td><fmt:message key="jsp.general.day" /></td>
                                            <td><fmt:message key="jsp.general.month" /></td>
                                            <td><fmt:message key="jsp.general.year" /></td>
                                        </tr>
                                        <tr>
                                            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                            <td><input class="numericField" type="text" id="end_day" name="end_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('newObtainedQualification.endDate','day',document.getElementById('end_day').value);"  /></td>
                                            <td><input class="numericField" type="text" id="end_month" name="end_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('newObtainedQualification.endDate','month',document.getElementById('end_month').value);" /></td>
                                            <td><input class="numericField" type="text" id="end_year" name="end_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('newObtainedQualification.endDate','year',document.getElementById('end_year').value);" /></td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="studyPlanForm.newObtainedQualification.qualification">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.qualification.qualification" /></td>
                                    <td><input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="studyPlanForm.newObtainedQualification.endGradeDate">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.qualification.endgrade.date" /></td>
                                    <td>
                                        <table>
                                        <tr>
                                            <td><fmt:message key="jsp.general.day" /></td>
                                            <td><fmt:message key="jsp.general.month" /></td>
                                            <td><fmt:message key="jsp.general.year" /></td>
                                        </tr>
                                        <tr>
                                            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />"  />
                                            <td><input class="numericField" type="text" id="grade_day" name="grade_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('newObtainedQualification.endGradeDate','day',document.getElementById('grade_day').value);"  /></td>
                                            <td><input class="numericField" type="text" id="grade_month" name="grade_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('newObtainedQualification.endGradeDate','month',document.getElementById('grade_month').value);" /></td>
                                            <td><input class="numericField" type="text" id="grade_year" name="grade_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('newObtainedQualification.endGradeDate','year',document.getElementById('grade_year').value);" /></td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>

                                <!--  STUDY GRADE TYPE -->
                                <spring:bind path="studyPlanForm.newObtainedQualification.gradeTypeCode">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.gradetypeallover" /></td>
                                        <td>
                                            <select name="${status.expression}" id="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneGradeType" items="${allGradeTypes}">
                                                   <c:choose>
                                                        <c:when test="${oneGradeType.code == status.value}"> 
                                                            <option value="${oneGradeType.code}" selected="selected">${oneGradeType.description}</option> 
                                                        </c:when>
                                                        <c:otherwise>
                                                             <option value="${oneGradeType.code}">${oneGradeType.description}</option> 
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach> 
                                            </select>
                                        </td> 
                                        <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                </spring:bind>
                                </table>   
                                <table>
                                    <tr>
                                        <td class="label">&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td><input type="button" name="submitRequestData" value="<fmt:message key="jsp.button.submit" />" onclick="document.formdata.submit();" /></td>
                                    </tr>
                                </table>
                            </div>  <!-- end AccordionPanelContent -->
                        </div>  <!-- end AccordionPanel -->
                    </div> <!-- Accordion -->
                    </div>  <!-- end TabbedPanelsContent -->
                </div> <!-- tabbedPanelsContentGroup -->
            </div>  <!-- end tabbedPanel -->
            </form>   
        </div>  <!-- end tabcontent --> 
                        
    </div> <!-- end tabwrapper -->

   <%@ include file="../../footer.jsp"%>
   