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
 * Copyright (c) 2012 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<div class="Accordion" id="Accordion1" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab"><fmt:message key="general.deadlines" /></div>
			<div class="AccordionPanelContent">

		
		<div style="padding:10px;text-align: right; width:98%">		
        	<a class="button" 
           		href="<c:url value='/fee/feedeadline.view?feeId=${feeSubjectAndSubjectBlockForm.fee.id}&amp;branchId=${feeSubjectAndSubjectBlockForm.branch.id}&amp;newForm=true&amp;tab=1&amp;panel=0&amp;from=feeSubjectAndSubjectBlock&amp;subjectId=${feeSubjectAndSubjectBlockForm.subject.id}&amp;subjectBlockId=${feeSubjectAndSubjectBlockForm.fee.subjectBlockId}&amp;studyId=${feeSubjectAndSubjectBlockForm.study.id}&amp;subjectId=${feeSubjectAndSubjectBlockForm.subject.id}&amp;currentPageNumber=${feeSubjectAndSubjectBlockForm.navigationSettings.currentPageNumber}'/>"
         	>
        	<fmt:message key="jsp.href.add" />
        	</a>
		</div>
		
		<table  id="TblData">
    
           <th><fmt:message key="jsp.general.deadline" /></th>
            <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
            <th><fmt:message key="jsp.general.cardinaltimeunit.number" /></th>
            <th><fmt:message key="jsp.general.status" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            
            	<c:forEach items="${feeSubjectAndSubjectBlockForm.feeDeadlines}" var="feeDeadline">
                        <tr>
                           <td style="text-align: center">
                           		<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                           </td>
                           <td style="text-align:center;">
                           		${feeDeadline.cardinalTimeUnit}
                           </td>
                           <td style="text-align:center;">
                           		${feeDeadline.cardinalTimeUnitNumber}
                           </td>
                           <td style="text-align:center;font-weight:bold;width: 20%">
                                <c:choose>
                                    <c:when test="${not empty feeDeadline.deadline && (feeDeadline.deadline < currentDate)}">
                                        <span style="color:#bf1616;"><fmt:message key="jsp.general.expired"/></span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color:#036f43;"><fmt:message key="jsp.general.active"/></span> 
                                    </c:otherwise>
                                </c:choose> 
                            </td>
                       	  <td style="width:7%;text-align: center">
                                <c:choose>
                                	<c:when test="${feeDeadline.active == 'Y'}">
                                		<fmt:message key="jsp.general.yes"/>
                                	</c:when>
                                	<c:otherwise>
                                		<fmt:message key="jsp.general.no"/>
                                	</c:otherwise>
                                </c:choose>
                           </td>
                           
                           <td class="buttonsCell" style="width:7%;text-align: center">
                                    <a 
                                    href="<c:url value='/fee/feedeadline.view?feeId=${feeSubjectAndSubjectBlockForm.fee.id}&amp;feeDeadlineId=${feeDeadline.id}&amp;branchId=${feeSubjectAndSubjectBlockForm.branch.id}&amp;newForm=true&amp;tab=1&amp;panel=0&amp;from=feeSubjectAndSubjectBlock&amp;subjectId=${feeSubjectAndSubjectBlockForm.subject.id}&amp;subjectBlockId=${feeSubjectAndSubjectBlockForm.fee.subjectBlockId}&amp;studyId=${feeSubjectAndSubjectBlockForm.study.id}&amp;currentPageNumber=${feeSubjectAndSubjectBlockForm.navigationSettings.currentPageNumber}'/>"
                                    ><img src="<c:url value='/images/edit.gif' />" 
                                    		 alt="<fmt:message key="jsp.href.edit" />" 
                                    		 title="<fmt:message key="jsp.href.edit" />" /></a>
                                    &nbsp;&nbsp;
                                    <a href="<c:url value='/fee/feeSubjectAndSubjectBlockDeadline_delete.view?feeId=${feeDeadline.feeId}&amp;feeDeadlineId=${feeDeadline.id}&amp;studyId=${feeSubjectAndSubjectBlockForm.study.id}&amp;from=feeSubjectAndSubjectBlock&amp;currentPageNumber=${feeSubjectAndSubjectBlockForm.navigationSettings.currentPageNumber}&amp;tab=1'/>"
                                   	    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
		                    </td>
                        </tr>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>


		</div><%-- AccordionPanelContent --%>
	</div><%-- AccordionPanel --%>
</div><%-- Accordion0 --%>

 <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
</script>