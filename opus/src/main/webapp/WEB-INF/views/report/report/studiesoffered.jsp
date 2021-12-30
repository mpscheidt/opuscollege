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

<%--
 * author : Stelio Macumbe
 Note: Please see file javascriptfunctions.jsp for support in how reports are
 created 
--%>

<%@ include file="../../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />

<body>
<%@ include file="../../includes/javascriptfunctions.jsp"%>
<%@ include file="../../includes/report_jqueryfunctions.jsp"%>

<style type="text/css">
    <%@ include file="../../includes/report.css"%>
</style>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
            <legend>
                <a href="<c:url value='/report/curriculumreportsoverview.view'/>">
                <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
                <fmt:message key="jsp.general.studiesOffered" />
            </legend>

            <form id="mainForm" name="mainForm">
            <input type="hidden" name="operation" id="operation" value="" />     
                              <%@ include file="../../includes/filtersStudiesOfferedTable.jsp"%>
            
</form>
        </fieldset>

        <form name="reportForm" id="reportForm" target="_blank" >
            <fieldset>
                <table>
                    <tr >
                        <td style="vertical-align:bottom;" width="100">
                            <fmt:message key="jsp.reports.OutPutReport"/>
                        </td>
                        <td>
                            <%@ include file="../../includes/ReportFormatsScreenPdfExcel_ajax.jsp"%>
                        </td>
                    </tr>
                    <tr>
                    <td width="200" style="padding:20px 0px 10px 0px" >
                         <input type="submit" id="reportButton"  value="<fmt:message key='jsp.general.create.report' />"/>
                         <input type="hidden" name="operation" value="makereport"/>                        
                     </td>
                    </tr>
                </table>
            </fieldset>
                      
            <input type="hidden" name="reportName" class="reportParam" value="${reportName}"/>
            <input type="hidden" name="downloadFileName" class="reportParam" value="<fmt:message key="jsp.general.studiesOffered" />_${institution.institutionDescription}"/>
            <input type="hidden" name="whereNot0.s1.currentAcademicYearId" value="${academicYearId}"/>
            <input type="hidden" name="whereNot0.s2.currentAcademicYearId" value="${academicYearId}"/>
            <input type="hidden" name="whereNot0.s3.currentAcademicYearId" value="${academicYearId}"/>
            <input type="hidden" name="whereNot0.s4.currentAcademicYearId" value="${academicYearId}"/>
            
        </form>             
        
    
        <br /><br />
    </div>

</div>

<%@ include file="../../footer.jsp"%>