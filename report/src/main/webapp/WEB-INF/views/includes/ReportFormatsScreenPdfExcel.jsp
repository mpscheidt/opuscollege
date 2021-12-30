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

<!-- To use this include, the form needs to be named "reportFormatForm" -->

			<td width="80"><input id="reportFormatScreen" name="reportFormat" value="html" type="radio" onchange="document.reportFormatForm.submit();"
	            <c:choose><c:when test="${reportFormat == 'html'}">
	            checked="checked"
	            </c:when></c:choose>
			/>
				<label for="reportFormatScreen"><fmt:message key="jsp.report.output.screen" /></label>
			</td>
			<td width="80"><input id="reportFormatPDF" name="reportFormat" value="pdf" type="radio" onchange="document.reportFormatForm.submit();"
	            <c:choose><c:when test="${reportFormat == 'pdf'}">
	            checked="checked"
	            </c:when></c:choose>
			/>
               	<label for="reportFormatPDF">PDF</label>
			</td>
			<td width="100"><input id="reportFormatExcel" name="reportFormat" value="xls" type="radio" onchange="document.reportFormatForm.submit();"
	            <c:choose><c:when test="${reportFormat == 'xls'}">
	            checked="checked"
	            </c:when></c:choose>
			/>
				<label for="reportFormatExcel">Excel</label>
			</td>
