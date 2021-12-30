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

The Original Code is Opus-College accommodation module code.

The Initial Developer of the Original Code is
Computer Center, Copperbelt University, Zambia
Portions created by the Initial Developer are Copyright (C) 2012
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

		<c:set var="navigationSettings" value="${accommodationFeeForm.navigationSettings}" scope="page" />
		<div id="tabcontent">

			<%-- Check it the request is coming from the overview page. If true then display 'back to overview' message and the name of the hostelType --%>
			<c:if test="${! empty param.fromView }">
				<fieldset>
					<legend>
						<a href="<c:url value='${param.fromView}?newForm=true'/>"><fmt:message key="jsp.general.backtooverview" /></a> &gt;
						<c:out value='${jsp.accommodation.accommodationFees}'/>
					</legend>
				</fieldset>
			</c:if>

	
	   <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
	            <li class="TabbedPanelsTab compulsoryTab">
	            	<fmt:message key="jsp.general.details" />
	            </li>  
    	        
    	        <c:if test="${accommodationFeeForm.accommodationFee.id != 0}">
    	        	<li class="TabbedPanelsTab">
    	        		<fmt:message key="general.deadlines" />
    	        	</li>
    	        </c:if>    
            </ul><%--tabpanel tabs--%>
 
 
  <div class="TabbedPanelsContentGroup">
  
  <%--details tab --%>
  	<div class="TabbedPanelsContent">
 			<%@ include file="fee-details.jsp"%>
     </div><%-- TabbedPanelsContent detailstab--%>
    
    <c:if test="${accommodationFeeForm.accommodationFee.id != 0}">
    	<div class="TabbedPanelsContent">
 			<%@ include file="fee-deadlines.jsp"%>
     	</div><%-- TabbedPanelsContent feespercentages--%>
    </c:if>
    
     </div><%-- TabbedPanelsContentGroup--%>
    </div><%--TabbedPanel --%>
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
        Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
        Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>



		</div><%--tabcontent --%>
	</div><%--tabwraper --%>

	<%@ include file="../../footer.jsp"%>