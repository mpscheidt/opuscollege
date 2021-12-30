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

<!-- <select name="secondaryLanguage" id="secondaryLanguage" onchange="this.form.submit()">
    <c:choose>
        <c:when test="${secondaryLanguage == 'pt'}">
        <option value="pt" selected="selected"><fmt:message
            key="jsp.language.english" /> - <fmt:message
            key="jsp.language.portuguese" /></option>
        </c:when>
        <c:otherwise>
            <option value="pt"><fmt:message key="jsp.language.english" />
            - <fmt:message key="jsp.language.portuguese" /></option>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${secondaryLanguage == 'nl'}">
        <option value="nl" selected="selected"><fmt:message
            key="jsp.language.english" /> - <fmt:message key="jsp.language.dutch" /></option>
        </c:when>
        <c:otherwise>
            <option value="nl"><fmt:message key="jsp.language.english" />
            - <fmt:message key="jsp.language.dutch" /></option>
        </c:otherwise>
    </c:choose>
</select>-->

<select name="selectedLanguages" id="selectedLanguages" onchange="this.form.submit()">
    <c:forEach var="appLanguage" items="${availableLanguages}">
        <c:choose>
	        <c:when test="${selectedLanguages == appLanguage}">
	            <option value="${appLanguage}" selected="selected">
	                <fmt:message key="jsp.language.${appLanguage}" />
	             </option>
	        </c:when>
	        <c:otherwise>
	            <option value="${appLanguage}">
	                <fmt:message key="jsp.language.${appLanguage}" />
	             </option>
	        </c:otherwise>
        </c:choose>
    </c:forEach>
    
    <c:forEach var="appLanguage1" items="${availableLanguages}">
        <c:forEach var="appLanguage2" items="${availableLanguages}">
            <c:set var="concatLang" value="${appLanguage1}-${appLanguage2}" />
			   <c:choose>     
			     <c:when test="${appLanguage1 != appLanguage2}">
			         <c:choose>
			             <c:when test="${selectedLanguages == concatLang}">
			                 <option value="${concatLang}" selected="selected">
			                     <fmt:message key="jsp.language.${appLanguage1}" /> -
			                     <fmt:message key="jsp.language.${appLanguage2}" />
			                 </option>
			             </c:when>
			             <c:otherwise>
			                     <option value="${concatLang}">
			                         <fmt:message key="jsp.language.${appLanguage1}" /> -
			                         <fmt:message key="jsp.language.${appLanguage2}" />
			                     </option>
			             </c:otherwise>
			         </c:choose>
			      </c:when>        
			 </c:choose>
        </c:forEach>
    </c:forEach>
</select>
