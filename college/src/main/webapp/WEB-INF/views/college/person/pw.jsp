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

    <div id="tabcontent">
        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.account" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
<%
						String redirString = "";
						if ("staffmember".equals(request.getAttribute("from"))) {
							redirString = "/college/staffmember.view?newForm=true"
                                + "&tab=" + request.getAttribute("tab")
								+ "&panel=" + 0
						        + "&staffMemberId=" + request.getAttribute("staffMemberId")
						        + "&from=staffmembers"
						        + "&currentPageNumber="+ request.getAttribute("currentPageNumber");
						}
						if ("student".equals(request.getAttribute("from"))) {
							redirString = "/college/student-opususer.view?newForm=true"
                                + "&tab=" + request.getAttribute("tab")
								+ "&panel=" + 0
						    	+ "&studentId=" + request.getAttribute("studentId")
						    	+ "&from=student"
						    	+ "&currentPageNumber="+ request.getAttribute("currentPageNumber");
						}
%>
                
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.account" /></div>
                                <div class="AccordionPanelContent">

<%--                                 <form method="get" name="pwdata" action="<c:url value='<%=redirString%>'/>" > --%>
                                
                                    <table>
<%--                                     <tr><td align="right"> --%>
<%--                                     	<input type="button" name="print" value="<fmt:message key="jsp.button.print" />"  onclick="javascript:window.print();" /> --%>
<%--                                     </td></tr> --%>
                                    <tr><td>&nbsp;</td></tr>
<%--                                     <tr><td>${pwText}/></td></tr> --%>
                                    <tr><td>
                                        <fmt:message key="pw.statictext.introduction"/>
                                        <br/>
                                        <br/>
                                        <fmt:message key="jsp.general.username"/>:
                                        <c:out value="${username}"></c:out>
                                        <br/>
                                        <br/>
                                        <fmt:message key="jsp.general.password"/>:
                                        <c:out value="${password}"></c:out>
                                        <br/>
                                        <br/>
                                        <fmt:message key="pw.statictext.conclusion"/>
                                        
                                    </td></tr>
                                    <tr><td>&nbsp;</td></tr>
                                    <tr><td align="right">
<%--                                     	<input type="submit" name="continue" value="<fmt:message key="jsp.button.continue" />" /> --%>
                                        <a class="button" href="<c:url value='<%=redirString%>'/>">
                                            <fmt:message key="jsp.button.continue"/>
                                        </a>
                                    </td></tr>
                                    
                                    <%-- vertical spacing --%>
                                    <tr><td></td></tr>

                                </table>

<%--                                 </form> --%>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                            
                        </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getAttribute("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

