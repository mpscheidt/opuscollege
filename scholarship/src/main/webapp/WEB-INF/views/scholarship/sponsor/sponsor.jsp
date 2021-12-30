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

    <c:set var="navigationSettings" value="${sponsorForm.navigationSettings}" scope="page" />
    <c:set var="sponsor" value="${sponsorForm.sponsor}" scope="page" />

    <div id="tabcontent">

    <fieldset>
    	<legend>
        	<a href="<c:url value='/scholarship/sponsors.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
        	<fmt:message key="scholarship.sponsor"/>
    	</legend>
 	</fieldset>

    <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
	            <li class="TabbedPanelsTab compulsoryTab">
	            	<fmt:message key="jsp.general.details" />
	            </li>
    	        
<%--                <c:if test="${sponsor.id != 0}">
                    <li class="TabbedPanelsTab">
                        <fmt:message key="scholarship.outstandingamounts" />
                    </li>
                </c:if> --%>    
            </ul><%--tabpanel tabs--%>
 
 
      <div class="TabbedPanelsContentGroup">

      <%--details tab --%>
      	<div class="TabbedPanelsContent">
            <%@ include file="sponsor-details.jsp"%>
        </div><%-- TabbedPanelsContent detailstab--%>

<%--        <c:if test="${sponsor.id != 0}">
            <div class="TabbedPanelsContent">
                <%@ include file="sponsor-outstandingamounts.jsp"%>
            </div>
        </c:if> --%>
        
     </div><%-- TabbedPanelsContentGroup--%>
    </div><%--TabbedPanel --%>
    
    
     <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
        Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
        Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>
    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../../footer.jsp"%>
