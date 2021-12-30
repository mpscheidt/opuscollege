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
<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <div id="tabcontent">
        <fieldset>
            <legend>
           
                <a href="<c:url value='/scholarship/banks.view?currentPageNumber=${currentPageNumber}' />"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                <spring:bind path="command.name">
                <c:choose>
                    <c:when test="${status.value != null && status.value != ''}" >
                    ${fn:substring(status.value,0,initParam.iTitleLength)}
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
                </spring:bind>
            </legend>
        </fieldset>

        <div id="tp1" class="TabbedPanel">
            <!-- <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.bank" /></li>    
            </ul> -->

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.details" /></div>
                            <div class="AccordionPanelContent">
                            
                                <table>
                                    <form name="formdata" method="POST">

                                        <!-- CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                            <spring:bind path="command.code">
                                            <td class="required">
                                                <input type="text" name="${status.expression}" size="10" maxlength="20" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
    
                                            
                                        <!-- CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.name" /></td>
                                            <spring:bind path="command.name">
                                            <td class="required">
                                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
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
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
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





