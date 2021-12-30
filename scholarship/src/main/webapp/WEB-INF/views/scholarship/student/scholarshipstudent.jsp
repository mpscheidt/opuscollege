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
 @Description: Page for editing scholarships
 @Author Stelio Macumbe25 of April 2008
--%>

<%@ include file="../../header.jsp"%>

<script type="text/javascript" src="<c:url value='/lib/scholarship/scholarship_functions.JS' />"></script>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="command.scholarship">
        <c:set var="appliedForScholarship" value="${status.value}" scope="page" />
    </spring:bind>    
    <spring:bind path="command.scholarshipStudentId">
        <c:set var="commandScholarshipStudentId" value="${status.value}" scope="page" />
    </spring:bind>
    
    <div id="tabcontent">   	
    	
    	
            <fieldset><legend>
                <a href="<c:url value='/scholarship/scholarshipapplications.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                
                <spring:bind path="command.surnameFull">
                <c:choose>
                    <c:when test="${status.value != null && status.value != ''}" >
                        <spring:bind path="command.surnameFull">
                            <c:set var="studentLastname" value="${status.value}" scope="page" />
                        </spring:bind>
                        <spring:bind path="command.firstnamesFull">
                            <c:set var="studentFirstname" value="${status.value}" scope="page" />
                        </spring:bind>
                        <c:set var="studentName" value="${studentLastname}, ${studentFirstname}" scope="page" />
                            <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                        </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
                </spring:bind>
            </legend></fieldset>

		<div id="tp1" class="TabbedPanel">
		    <ul class="TabbedPanelsTabGroup">
		        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.studentdetails"/></li>
                <c:choose>
                  <c:when test="${appliedForScholarship == 'Y'}">
		              <li class="TabbedPanelsTab"><fmt:message key="jsp.general.scholarshipapplications"/></li>
		              <c:if test="${appUseOfSubsidies == 'Y'}">
		                  <li class="TabbedPanelsTab"><fmt:message key="jsp.general.subsidies"/></li>
		              </c:if>
		              <li class="TabbedPanelsTab"><fmt:message key="jsp.general.accountinformation"/></li>
		          </c:when>
		        </c:choose>
		    </ul>   
		    
		    
		    <c:set var="accordion" value="0" />
                
		    <div class="TabbedPanelsContentGroup">
		        
		        <!-- student tab -->    
		        <div class="TabbedPanelsContent">
		            
		            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
		                    
		                <div class="AccordionPanel">
		                    <div class="AccordionPanelTab">
		                        <fmt:message key="jsp.general.studentdetails" />
		                    </div><!-- Title -->
		                    <div class="AccordionPanelContent">
		                    
		                        <%@ include file="../../includes/studentTab.jsp" %>
		                    
		                    </div><!-- Content -->
		                
		                </div><!-- AccordionPanel -->
		                
		            </div><!-- Accordion -->    
		                
		            <script type="text/javascript">
		                                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
		                                          {defaultPanel: 0,
		                                          useFixedPanelHeights: false,
		                                          nextPanelKeyCode: 78 /* n key */,
		                                          previousPanelKeyCode: 80 /* p key */
		                                         });
		                                </script>
		        </div><!-- TabbedPanelsContent -->
		        
		        
		        <!-- end of student tab -->
		        
		        <c:choose>
		          <c:when test="${appliedForScholarship == 'Y'}">
				        <!-- scholarships tab -->
				        
				        <c:set var="accordion" value="${accordion+1}" />
				        <div class="TabbedPanelsContent">
				            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
				                    
				                <div class="AccordionPanel">
				                    <div class="AccordionPanelTab"><!-- Title -->
				                        <fmt:message key="jsp.general.scholarshipapplications" />
				                    </div><!-- Title -->
				                    <div class="AccordionPanelContent">
				                        
				                        <%@ include file="../../includes/scholarshipsTab.jsp" %>    
				                    
				                    </div><!-- Content -->
				                
				                </div>
				                
				            </div>  
				                
			                <script type="text/javascript">
			                                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
			                                          {defaultPanel: 0,
			                                          useFixedPanelHeights: false,
			                                          nextPanelKeyCode: 78 /* n key */,
			                                          previousPanelKeyCode: 80 /* p key */
			                                         });
			                </script>
				        </div>
				        <!-- end of scholarships tab -->
		            </c:when>
		        </c:choose>
		            
		        
		        <!-- subsidies tab -->
                
                <c:if test="${appUseOfSubsidies == 'Y'}">
                    <c:choose>
	                  <c:when test="${appliedForScholarship == 'Y'}">
			        
			         <c:set var="accordion" value="${accordion+1}" />
                    
			        <div class="TabbedPanelsContent">
			            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
			                    
			                <div class="AccordionPanel"><!-- Degree in an accordion -->
			                    <div class="AccordionPanelTab"><!-- Title -->
			                        <fmt:message key="jsp.general.subsidies" />
			                    </div><!-- Title -->
			                    <div class="AccordionPanelContent">
			                        
			                        <%@ include file="../../includes/subsidiesTab.jsp" %>  
	
			                    </div><!-- Content -->
			                
			                </div><!-- AccordionPanel -->
			                
			            </div><!-- TabbedPanels --> 
			                
			                
			           <script type="text/javascript">
                               var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                 {defaultPanel: 0,
                                 useFixedPanelHeights: false,
                                 nextPanelKeyCode: 78 /* n key */,
                                 previousPanelKeyCode: 80 /* p key */
                                });
			           </script>
			                
			        </div><!-- End of TabbedPanelsContent -->
			    
			        <!-- End of subsidies tab -->
	                    </c:when>
	                </c:choose>
		         </c:if>
		    
              <!-- Complaints tab --> 
              <c:choose>
                  <c:when test="${appliedForScholarship == 'Y'}">
                  
                  <c:set var="accordion" value="${accordion+1}" />
		          <div class="TabbedPanelsContent">
		            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
		                    
		                <div class="AccordionPanel"><!-- Degree in an accordion -->
		                    <div class="AccordionPanelTab"><!-- Title -->
		                        <fmt:message key="jsp.general.details" />
		                    </div><!-- Title -->
		                    <div class="AccordionPanelContent">

                               <%@ include file="../../includes/accountInformationTab.jsp" %> 


		                    </div><!-- Content -->
		                
		                </div><!-- AccordionPanel -->
		                
		            </div><!-- TabbedPanels --> 
		                
		                
		           <script type="text/javascript">
                      var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                        {defaultPanel: 0,
                        useFixedPanelHeights: false,
                        nextPanelKeyCode: 78 /* n key */,
                        previousPanelKeyCode: 80 /* p key */
                       });
		           </script>
		                
		        </div><!-- End of TabbedPanelsContent -->
		    
		        <!-- end of account information tab -->
                    </c:when>
                </c:choose>
		    
		    
		    </div><!-- End of TabbedPanelsContentGroup -->
		</div><!-- End of TabbedPanel tp1-->
    	
    <!-- end of tabcontent -->
    </div>   
    
     <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(${param.tab});
        tp1.showPanel(<%=request.getParameter("tab")%>);
        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>
   
  
</div>

<%@ include file="../../footer.jsp"%>

