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

<c:set var="allEntities" value="${resultsForm.studentsList}"/>
<c:choose>
<c:when test="${empty resultsForm.studentsList}">
    <h2 align="center"><fmt:message key="jsp.results.noitemsfound"/></h2>
</c:when>
</c:choose>

    <%-- Header with no navigational buttons--%>
        <div id="abc">&nbsp;</div>

              <table class="tabledata" id="TblData">

          <tr> 
            <th><fmt:message key="jsp.general.studentcode" /></th>            
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.mark" /></th>
            <th><fmt:message key="jsp.general.resultdate" /></th>
            <th><fmt:message key="jsp.general.staffmember" /></th>
          </tr>
            <c:forEach var="student" items="${resultsForm.studentsList}">
                    <tr>
                        <td>${student.studentCode}</td>                        
                        <td>${student.studentName}</td>
                        <td>${student.mark}</td>
                        <td><fmt:formatDate dateStyle="medium" type="date" value="${student.subjectResultDate}"/></td>
                        <td>${student.writeWho}</td>
                    </tr>
            </c:forEach>
        </table>
              </form>
              <script type="text/javascript">
	        	 alternate('TblData',true);
        	</script>
        <%@ include file="pagingFooter.jsp"%>
