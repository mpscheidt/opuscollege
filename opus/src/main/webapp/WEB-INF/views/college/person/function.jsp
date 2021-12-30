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

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="navigationSettings" value="${functionForm.navigationSettings}" scope="page" />

    <div id="tabcontent">

   		<fieldset>
   			<legend>
                   <a href="<c:url value='/college/staffmembers.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
   				<a href="<c:url value='/college/staffmember.view?newForm=true&tab=2&panel=0&staffMemberId=${functionForm.staffMember.staffMemberId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${staffMember.surnameFull != null && staffMember.surnameFull != ''}" >
       					<c:set var="staffMemberName" value="${functionForm.staffMember.surnameFull}, ${functionForm.staffMember.firstnamesFull}" scope="page" />
       					${fn:substring(staffMemberName,0,initParam.iTitleLength)}
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
			&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />&nbsp;<fmt:message key="jsp.general.function" />
			</legend>
		</fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab">add</li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.functions" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="functionForm" method="post" >
                                    
                                    <table>
                                                            
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.function" /></td>
                                            <td>
                                           <%-- <spring:bind path="command.functions"> --%>
                                            <form:select path="lookupCode">
                                                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
<%--                                                 <option value="0"><fmt:message key="jsp.selectbox.choose" /></option> --%>
                                                <c:forEach var="function" items="${functionForm.allFunctions}">
                                                    <c:set var="disabled" value="" scope="page" />
                                                    <c:forEach var="staffMemberFunction" items="${functionForm.allStaffMemberFunctions}">
                                                        <c:choose>
                                                           <c:when test="${staffMemberFunction.functionCode == function.code}">
                                                               <c:set var="disabled" value="disabled" scope="page" />
                                                           </c:when>
                                                       </c:choose>
                                                    </c:forEach> 
                                                    <c:choose>
                                                    <c:when test="${disabled==''}">
                                                         <form:option value="${function.code}">${function.description}</form:option>
                                                    </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </form:select>
                                            </td> 
                                            <td> <%--<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach></spring:bind>--%></td>
                                        </tr>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.function.level" /></td>
                                            <td>
                                            <form:select path="functionLevelCode">
                                                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                                                <c:forEach var="functionLevel" items="${functionForm.allFunctionLevels}">
                                                    <form:option value="${functionLevel.code}">${functionLevel.description}</form:option>
                                                </c:forEach>
                                            </form:select>
                                            </td> 
                                            <td></td>
                                        </tr>
                                     
                                    <tr><td class="label">&nbsp;</td><td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>

                                </table>

                                </form:form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                        </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

