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

    <%@ include file="../../menu.jsp"%>
    
    <c:set var="studyPlanCTUs" value="" scope="page" />
    <c:set var="studyPlanDetails" value="" scope="page" />
    
    <spring:bind path="cancelStudentFeeForm.studentBalance">
        <c:set var="studentBalance" value="${status.value}" />
    </spring:bind>
    
    
   
    <spring:bind path="cancelStudentFeeForm.student">
        <c:set var="student" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="cancelStudentFeeForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" />
    </spring:bind>
    
    <div id="tabcontent">
    
        <form name="formdata" method="POST"> 
            <fieldset>
                <legend>
                    <a href="<c:url value='/fee/paymentsstudent.view?currentPageNumber=${navigationSettings.currentPageNumber}&studentId=${student.id}'/>"><fmt:message key="jsp.general.backtooverview" /></a>
                    &nbsp;>&nbsp;
                    <c:choose>
                        <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                            <c:set var="studentLastname" value="${student.surnameFull}" scope="page" />
                            <c:set var="studentFirstname" value="${student.firstnamesFull}" scope="page" />
                            <c:set var="studentName" value="${studentLastname}, ${studentFirstname}" scope="page" />
                            <a href="<c:url value='/fee/paymentsstudent.view?studentId=${student.studentId}&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                            </a>
                        </c:when>
                    </c:choose>
                    &nbsp;>&nbsp;
                </legend>

                
                
            </fieldset>

            <div id="tp1" class="TabbedPanel">
                <ul class="TabbedPanelsTabGroup">
                    <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
                </ul>

            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.cancellationfee.general" /></div>
                            <div class="AccordionPanelContent">
 
                            <table>
                            	<tr><td>&nbsp;</td></tr>
                                <tr><td class="msgwide"><fmt:message key="jsp.cancellationfee.help" /></td></tr>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td>
                                	<table>
		                                <spring:bind path="cancelStudentFeeForm.studentBalance.amount">
		                                <tr>
		                                	<td>&nbsp;</td>
				                            <td class="label"><fmt:message key="jsp.general.amount" /></td>
				                            <td>
					                       		<input name="${status.expression}" id="${status.expression}" value="${status.value}">  
					                        </td>
				                            <td class="emptywide"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
					                    </tr>
				                     	</spring:bind>
				                     	<!-- SUBMIT BUTTON -->
                                <tr>
                                	<td>&nbsp;</td>
                                    <td>
                                        <input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" />
                                    </td>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                   </table>
                               </td></tr>
                                
                                
                            </table>
                              
                            <!--  einde accordionpanelcontent -->
                            </div>
                        <!--  einde accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 1 -->
                    </div>
                    
                <!--  end tabbedpanelscontent -->
                </div>
            <!--  end tabbed panelscontentgroup -->    
            </div>
        <!--  end tabbed panel -->    
        </div>
        </form>
    <!-- end tabcontent -->
    </div>
   
<!-- einde tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

