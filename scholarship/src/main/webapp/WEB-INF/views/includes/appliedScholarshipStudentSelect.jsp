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
        <form name="appliedScholarshipStudentForm" action="${action}" method="POST" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
            <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> -->
            <input type="hidden" name="yearNumber" value="${yearNumber}" />
            <input type="hidden" name="grantedScholarship" value="${grantedScholarship}" />
            <input type="hidden" name="grantedSubsidy" value="${grantedSubsidy}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            
            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.scholarship.student.select" /></td>
                    <td>
                    <select name="appliedForScholarship" onchange="document.appliedScholarshipStudentForm.submit();">
                        <% 
							String[] optionsAS = {"" , "Y" , "N"}; 
                            String[] keysAS = {"jsp.selectbox.all" , "jsp.general.yes" , "jsp.general.no"};
                           String appliedForScholarship = request.getParameter("appliedForScholarship");
                        
                           for(int i = 0; i < optionsAS.length ; i++) {
                        		if(optionsAS[i].equalsIgnoreCase(appliedForScholarship) ){
                         %>
                        			<option value="<%=optionsAS[i]%>" selected="selected"><fmt:message key="<%=keysAS[i] %>" /></option>				
                        <%
                        		} else {
                        %>
                        		<option value="<%=optionsAS[i]%>" ><fmt:message key="<%=keysAS[i] %>" /></option>
                        <%  
                        		}
                           }
                        
                        %>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
        </form>
       