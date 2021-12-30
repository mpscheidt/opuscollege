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

<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>
    
    <div id="tabcontent">
    	<form>
    		<fieldset><legend>
                <a href="overview.view"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
    			<spring:bind path="command.aFieldOfObject">
    			<c:choose>
    				<c:when test="${status.value != null && status.value != ''}" >
        					${fn:substring(status.value,0,initParam.iTitleLength)}
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</spring:bind>
			</legend></fieldset>
		</form>
		
        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.tabone" /></li>               
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.tabtwo" /></li>       
            </ul>

            <div class="TabbedPanelsContentGroup">
			   
                <!-- start of tabbedpanelscontent (= start of tab one) -->
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.panelonetabone" /></div>

                            <div class="AccordionPanelContent">

                                <form name="tabonepanelone" method="post" scope="request" reset="true">
                                    <input type="hidden" name="tab_tabone" value="0" /> 
                                    <input type="hidden" name="panel_tabonepanelone" value="0" />
                                    <table>
                                            <tr>
                                                <td class="label">xx</td>
                                                <td class="required">xx</td> 
                                                <td>xx</td>
											 </tr>
											 <tr>
											     <td class="label">&nbsp;</td>
											     <td>&nbsp;</td>
											     <td><input type="button" name="submittabonepanelone" 
											     	value="<fmt:message key="jsp.button.submit" />" 
											     		onclick="document.tabonepanelone.submit();" /></td>
											 </tr>
						           </table>
						        </form>
						        
						    <!-- end of accordionpanelcontent -->    
						    </div>
						    
						<!-- end of accordionpanel -->     
						</div> 
						
						<div class="AccordionPanel">
						   <div class="AccordionPanelTab"><fmt:message key="jsp.general.background" /></div>
						   <div class="AccordionPanelContent">
						       <form name="backgrounddata" method="post">
						               <input type="hidden" name="tab_tabone" value="0" /> 
						               <input type="hidden" name="panel_tabonepaneltwo" value="1" />
                                    <table>
                                            <tr>
                                                <td class="label">xx</td>
                                                <td class="required">xx</td> 
                                                <td>xx</td>
											 </tr>
											 <tr>
											     <td class="label">&nbsp;</td>
											     <td>&nbsp;</td>
											     <td><input type="button" name="submittabonepaneltwo" 
											     	value="<fmt:message key="jsp.button.submit" />" 
											     		onclick="document.tabonepaneltwo.submit();" /></td>
											 </tr>
						           </table>
					          </form>
					      </div> <!-- einde accordionpanelcontent -->
					  </div> <!-- einde accordionpanel -->


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
                    
                <!--  end of tabbedpanelscontent (= end of tab one) -->
                </div>

                         
                <!-- start of tabbedpanelscontent (= start of tab two) -->
                <div class="TabbedPanelsContent">
		            <div class="Accordion" id="Accordion1" tabindex="0">

                		<!-- content: form / table / and so on (see above) -->

            		</div>
           
                    <script type="text/javascript">
                            var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                    </script>

        		<!--  end of tabbedpanelscontent (= end of tab two) -->
        		</div>
			
            <!-- end of TabbedPanelsContentGroup -->
            </div>

        <!--  end of TabbedPanel -->    
        </div>
        
    <!-- end of tabcontent -->
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
       	Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
       	Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>
   
<!-- end of tabwrapper -->    
</div>

<%@ include file="../footer.jsp"%>

