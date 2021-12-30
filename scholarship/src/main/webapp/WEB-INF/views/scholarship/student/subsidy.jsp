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
 * Copyright (c) 2008 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
 @Description: This script is the content for the scolarship details tab
 @Author Stelio Macumbe 13 of May 2008
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

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
                    &nbsp;>&nbsp;
                    <spring:bind path="command.subsidyTypeCode">
                    <c:choose>
                        <c:when test="${status.value != null && status.value != ''}" >
		                    <c:forEach var="subsidyType" items="${allSubsidyTypes}">
		                        <c:choose>
		                           <c:when test="${subsidyType.code == status.value}">
		                              <c:set var="subsidyDescription"  value="${subsidyType.description} - ${subsidy.subsidyDate}" scope="page" />
		                              ${fn:substring(subsidyDescription,0,initParam.iTitleLength)}
		                           </c:when>
		                        </c:choose>
		                    </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    </spring:bind>
                    &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subsidy" /> 
            </legend>
        </fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.subsidy"/></li>
            </ul>   

            <div class="TabbedPanelsContentGroup">
                    
                <!-- student tab -->    
                <div class="TabbedPanelsContent">
                    
                    <div class="Accordion" id="Accordion0" tabindex="0">
                            
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab">
                                <fmt:message key="jsp.general.subsidy" />
                            </div><!-- Title -->
                            <div class="AccordionPanelContent">
            

						    <form id="subsidydata" name="subsidydata" method="POST">
                                <input type="hidden" name="tab" value="${tab}" /> 
                                <input type="hidden" name="panel" value="${panel}" />
                                    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
						
							<table>
						            <tr>
						                <td class="label"><fmt:message key="scholarship.subsidytype" /></td>
						                <spring:bind path="command.subsidyTypeCode">
                                        <td>
						                    <select name="${status.expression}" id="${status.expression}"'> 
						                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
								                    <c:forEach var="subsidyType" items="${allSubsidyTypes}">
						                               <c:choose>
						                                   <c:when test="${subsidyType.code == status.value}">
						                                       <option value="${subsidyType.code}" selected="selected">
						                                   </c:when>
						                                   <c:otherwise>
						                                        <option value="${subsidyType.code}">
						                                   </c:otherwise>
						                               </c:choose>
						                               ${subsidyType.description}</option>
						                            </c:forEach>
						                    </select>
						                </td>
						                <td>
						                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
						                </td>
						                </spring:bind>
						            </tr>
						
						            <tr>
						                <td class="label"><fmt:message key="scholarship.sponsor" /></td>
						                <spring:bind path="command.sponsorId">
                                        <td>
                                            <select name="${status.expression}" id="${status.expression}"'> 
                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="sponsor" items="${allSponsors}">
                                                       <c:choose>
                                                           <c:when test="${sponsor.id == status.value}">
                                                               <option value="${sponsor.id}" selected="selected">
                                                           </c:when>
                                                           <c:otherwise>
                                                                <option value="${sponsor.id}">
                                                           </c:otherwise>
                                                       </c:choose>
                                                       ${sponsor.name}</option>
                                                    </c:forEach>
                                            </select>
						                </td>
						                <td>
						                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
						                </td>
						                </spring:bind>
						            </tr>
					            
						            <tr>
					                     <td class="label"><fmt:message key="jsp.general.amount" /></td>
					                     <spring:bind path="command.amount"> 
                                         <td>
                                            <input type="text" name="${status.expression}" size="6" maxlength="10" value="<c:out value="${status.value}" />" />
					                     </td>
					                     <td>
					                     <c:forEach var="error" items="${status.errorMessages}">
					                     <span class="error">${error}</span></c:forEach>
					                     </td>
                                         </spring:bind>
						            </tr>
						            
						            <tr>
						            <td class="label"><fmt:message key="jsp.general.subsidydate" /></td>
                                        <spring:bind path="command.subsidyDate">
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="subsidydate_day" name="subsidydate_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('subsidyDate','day',document.getElementById('subsidydate_day').value);" /></td>
                                                    <td><input type="text" id="subsidydate_month" name="subsidydate_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('subsidyDate','month',document.getElementById('subsidydate_month').value);" /></td>
                                                    <td><input type="text" id="subsidydate_year" name="subsidydate_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('subsidyDate','year',document.getElementById('subsidydate_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
						             </tr>

                                    <tr>
                                         <td class="label"><fmt:message key="jsp.general.remarks" /></td>
                                         <spring:bind path="command.observation">
                                         <td>
                                            <textarea cols="30" rows="10" id="${status.expression}" name="${status.expression}" >${status.value}</textarea>
                                         </td>
                                         <td>
                                         <c:forEach var="error" items="${status.errorMessages}">
                                         <span class="error">${error}</span></c:forEach>
                                         </td>
                                         </spring:bind>
                                    </tr>
						            <tr>
						                <td>&nbsp;</td>
						                <td>
						                    <input type="button" name="submitsubsidydata" value="<fmt:message key="jsp.button.submit" />" onclick="document.subsidydata.submit();" />
						                </td>
						            </tr>
						        </table>
		
		                        </form>
		
                            
                            </div><!-- Content -->
                        
                        </div><!-- AccordionPanel -->
                        
                    </div><!-- Accordion -->    
                        
                    <script type="text/javascript">
                                                var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                                                  {defaultPanel: 0,
                                                  useFixedPanelHeights: false,
                                                  nextPanelKeyCode: 78 /* n key */,
                                                  previousPanelKeyCode: 80 /* p key */
                                                 });
                                        </script>
                </div><!-- TabbedPanelsContent -->
                
            </div><!-- End of TabbedPanelsContentGroup -->
        </div><!-- End of TabbedPanel tp1-->
        
    <!-- end of tabcontent -->
    </div>   
    
     <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(${param.tab});
        tp1.showPanel(0);
        Accordion0.defaultPanel = 0;
        Accordion0.openPanelNumber(0);
    </script>
   
  
</div>

<%@ include file="../../footer.jsp"%>


