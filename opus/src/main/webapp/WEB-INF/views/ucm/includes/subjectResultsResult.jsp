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

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
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

<div id="tp1" class="TabbedPanel">
	<ul class="TabbedPanelsTabGroup">
		<%--tabpanel tabs--%>

		<li class="TabbedPanelsTab"><fmt:message key="jsp.message.studentsonsubject" />
		</li>

		<c:if test="${resultsForm.formStatus == 'ResultsProcessed'}">
			<li class="TabbedPanelsTab"><fmt:message
					key="jsp.general.validentries" /></li>

			<c:if test="${not empty resultsForm.studentsResults}">
				<li class="TabbedPanelsTab"><fmt:message
						key="jsp.general.invalidentries" /></li>
			</c:if>

			<c:if test="${not empty duplicatedEntries}">
				<li class="TabbedPanelsTab"><fmt:message
						key="jsp.general.duplicatedentries" /></li>
			</c:if>

			<c:if test="${not empty missingEntries}">
				<li class="TabbedPanelsTab"><fmt:message
						key="jsp.general.mssingentries" /></li>
				</c:if>

			<c:if test="${not empty info}">
				<li class="TabbedPanelsTab"><fmt:message key="general.info" />
				</li>
			</c:if>

			<c:if test="${not empty errors}">
				<li class="TabbedPanelsTab"><fmt:message key="general.errors" />
				</li>
			</c:if>
		</c:if>
		<%--ResultsProcessed --%>

	</ul>
	<%-- end of tabpanel tabs--%>



	<div class="TabbedPanelsContentGroup">

		<div class="TabbedPanelsContent">
			<%@ include file="tables/table_subjectResults.jsp"%>
		</div>
		<%-- TabbedPanelsContent all students--%>

		<c:if test="${resultsForm.formStatus == 'ResultsProcessed'}">
		
			<div class="TabbedPanelsContent">
				<c:choose>
					<c:when test="${not empty resultsForm.studentsResults}">
						<%@ include file="subjectResults-validEntries.jsp"%>
					</c:when>
					<c:otherwise>
						<h2><fmt:message key="general.nodata"/></h2>
					</c:otherwise>
				</c:choose>
				
			</div>
			<%-- TabbedPanelsContent validEntries--%>

			<c:if test="${not empty invalidEntries}">
				<div class="TabbedPanelsContent">
					<%@ include file="subjectResults-invalidEntries.jsp"%>
				</div>
				<%-- TabbedPanelsContent invalidEntries--%>
			</c:if>

			<c:if test="${not empty duplicatedEntries}">
				<div class="TabbedPanelsContent">
					<%@ include file="subjectResults-duplicatedEntries.jsp"%>
				</div>
				<%-- TabbedPanelsContent duplicatedEntries--%>
			</c:if>
			
			<c:if test="${not empty missingEntries}">
				<div class="TabbedPanelsContent">
					<%@ include file="subjectResults-missingEntries.jsp"%>
				</div>
				<%-- TabbedPanelsContent missingEntries--%>
			</c:if>

			<c:if test="${not empty info}">
				<div class="TabbedPanelsContent">
					<%@ include file="subjectResults-info.jsp"%>
				</div>
				<%-- TabbedPanelsContent info--%>
			</c:if>

			<c:if test="${not empty errors}">
				<div class="TabbedPanelsContent">
					<%@ include file="subjectResults-errors.jsp"%>
				</div>
				<%-- TabbedPanelsContent errors--%>
			</c:if>
		</c:if>
	</div>
	<%-- TabbedPanelsContentGroup--%>
	
</div>
<%--TabbedPanel id="tp1" --%>


<script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(0);
        Accordion1.defaultPanel = 0;
        Accordion1.openPanelNumber(0);
    </script>
