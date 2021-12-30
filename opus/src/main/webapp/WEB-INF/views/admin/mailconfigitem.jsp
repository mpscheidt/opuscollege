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
<spring:htmlEscape defaultHtmlEscape="true"></spring:htmlEscape>
<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

	
    <div id="tabcontent">
    
<fieldset>
<legend>
<a href="<c:url value='/college/mailconfigitems.view?newForm=true&?currentPageNumber=${currentPageNumber}'/>">
    <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
	${mailConfigItem.msgSubject}
    </legend>
    </fieldset>
    
    <form:form  modelAttribute="mailConfigItem" >        
    	<input type="hidden" name="currentPageNumber" value="${currentPageNumber}"/>
	<table>
	<tr>
		<td class="label"><fmt:message key="jsp.mail.subject"/></td>
		<td class="required"><form:input path="msgSubject" size="50"/></td>
		<form:errors path="msgSubject" cssClass="error" element="td"/>
	</tr>
	<tr>
		<td class="label"><fmt:message key="jsp.mail.sender"/></td>
		<td class="required"><form:input path="msgSender"  size="50"/></td>
		<form:errors path="msgSender" cssClass="error" element="td"/>
	</tr>
	
	<tr>
		<td class="label"><fmt:message key="jsp.general.type"/></td>
		<td><form:input path="msgType" readonly="true"  size="50"/></td>
	</tr>
	<tr>
		<td class="label"><fmt:message key="jsp.general.date"/></td>
		<td>
			<input type="text" value='<fmt:formatDate value="${mailConfigItem.writeWhen}" dateStyle="SHORT"/>' readonly="readonly" class="readOnly"  size="50"/>
		
		</td>
	</tr>	
	</table>
	<table>
	<tr>
		<td class="label"><fmt:message key="jsp.mail.message"/></td>		
	</tr>
	<tr>	
		<td colspan = "10" class="required">
			<form:textarea path="msgBody" id="editor" cssStyle="width:700px;height:300px;border: 1px solid gray"/>
            <script>
                // Replace the <textarea id="editor"> with a CKEditor
                CKEDITOR.replace( 'editor', {
                    height: 280
                } );
            </script>
		</td>
		<form:errors path="msgBody" cssClass="error" element="td"/>
	</tr>

	<tr>
     <td colspan="3" align="center" style="padding:20px;">
        <input type="submit" value="<fmt:message key="jsp.button.submit" />" />
   	 </td>
	</tr>    
</table>

</form:form>

    </div><%---tabContent --%>
    
</div><%-- tabwrapper --%>

<%@ include file="../footer.jsp"%>
