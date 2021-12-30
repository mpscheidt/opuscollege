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
 @Description: This script is the content for the subsidies tab
 @Author Stelio Macumbe 13 of May 2008
--%>

<table class="tabledata2" id="TblData_subsidies">

     <tr>
          <th colspan=7 align="right">
              <a class="button" href="<c:url value='/scholarship/subsidy.view?tab=${accordion}&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
          </th>
      </tr>

      <tr>
            <th><fmt:message key="scholarship.subsidytype" /></th>
            <th><fmt:message key="scholarship.sponsor" /></th>
            <th><fmt:message key="jsp.general.amount" /></th>
            <th><fmt:message key="jsp.general.subsidydate" /></th>
            <th><fmt:message key="jsp.general.remarks" /></th>
            <th></th>
      </tr> 

        <spring:bind path="command.subsidies">
        <c:forEach var="subsidy" items="${status.value}">
            <tr>
                <td>
                     <c:forEach var="subsidyType" items="${allSubsidyTypes}">
                         <c:choose>
                            <c:when test="${subsidyType.code == subsidy.subsidyTypeCode}">
                               ${subsidyType.description}
                            </c:when>
                         </c:choose>
                     </c:forEach>
                </td>
       
                <td>
	                 <c:forEach var="sponsor" items="${allSponsors}">
	                    <c:choose>
	                        <c:when test="${sponsor.id == subsidy.sponsorId}">
	                           ${sponsor.name}
	                        </c:when>
	                    </c:choose>
	                 </c:forEach>
                </td>

               
                <td>
                    ${subsidy.amount}
                </td>

                <td>
                    <!-- The date from when this scholarship starts having effect -->
                    <fmt:formatDate pattern="dd/MM/yyyy" value="${subsidy.subsidyDate}" />
                </td>

                <td>
                    ${subsidy.observation}
                </td>       

                <td class="buttonsCell">
                   <a href="<c:url value='/scholarship/subsidy.view?tab=${accordion}&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&subsidyId=${subsidy.id}&currentPageNumber=${currentPageNumber}'/>">
                          <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                      &nbsp;&nbsp;
                      <a href="<c:url value='/scholarship/subsidy_delete.view?tab=${accordion}&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&subsidyId=${subsidy.id}&currentPageNumber=${currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.subsidy.delete.confirm" />')">
                          <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                      </a>
                </td>
            </tr>
        
        </c:forEach>
       </spring:bind>

</table>
<script type="text/javascript">alternate('TblData_subsidies',true)</script>
