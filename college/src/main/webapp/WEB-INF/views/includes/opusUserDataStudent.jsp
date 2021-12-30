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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:set var="form" value="${studentOpusUserForm}" />

<div class="AccordionPanel">
    <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.opususerdata" /></div>
    <div class="AccordionPanelContent">
        <form:form modelAttribute="studentOpusUserForm" method="post">
            <%-- navigationsettings.tab/panel should be in the one and only global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="0" />
<%--        <form name="opususerdata" id="opususerdata" method="post">
            <input type="hidden" name="tab_opususer" value="1" /> 
            <input type="hidden" name="panel_opususer" value="0" />
            <input type="hidden" name="submitFormObject" id="submitFormObject" value="" /> --%>

            <table>
                    <spring:bind path="personOpusUserRole.userName">
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.username" /></td>
                            <c:if test="${editOpusUserData}">

                                <td class="required"><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                                <c:choose>
                                    <c:when test="${not empty showUserNameError}">
                                        <td class="error">
                                        <c:choose>
                                            <c:when test="${not empty userNameError}">
                                                <fmt:message key="jsp.error.username.exists.start" /><c:out value="${userNameError}"/>
                                                <fmt:message key="jsp.error.username.exists.end" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="invalid.empty.format" />
                                            </c:otherwise>
                                        </c:choose>
                                        </td>
                                    </c:when>
                                   <c:otherwise>
                                        <td></td>
                                   </c:otherwise>
                                </c:choose>
                          </c:if>
                          <c:if test="${showOpusUserData}">
                                <td colspan="2"><c:out value="${status.value}"/></td>
                          </c:if>
                        </tr>
                    </spring:bind>

                    <spring:bind path="studentOpusUserForm.opusUser.lang">
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.language" /></td>
                            <c:if test="${editOpusUserData}">
                                <td class="required">
                                <select name="${status.expression}">
                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="language" items="${appConfigManager.appLanguages}">
                                        <c:choose>
                                            <c:when test="${language eq fn:trim(status.value)}">
                                                <option value="${language}" selected="selected"><fmt:message key="jsp.language.${language}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${language}"><fmt:message key="jsp.language.${language}"/></option>
                                            </c:otherwise>
                                        </c:choose> 
                                    </c:forEach>
                                </select>
                                </td>
                                <c:choose>
                                    <c:when test="${not empty showUserLangError}">
                                        <td class="error"><fmt:message key="invalid.empty.format" /></td>
                                    </c:when>
                                </c:choose>
                            </c:if>
                            <c:if test="${showOpusUserData}">
                                <td>
                                <c:forEach var="language" items="${appConfigManager.appLanguages}">
                                    <c:choose>
                                        <c:when test="${language eq fn:trim(status.value)}">
                                            <fmt:message key="jsp.language.${language}"/>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                                </td>
                            </c:if>
                        </tr>
                    </spring:bind>

                    <spring:bind path="studentOpusUserForm.opusUser.failedLoginAttempts">
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.failedloginattempts" /></td>
                            <td>
                                <c:out value="${status.value}"/>
                                <c:choose>
                                   <c:when test="${not studentOpusUserForm.opusUser.accountNonLocked}">
                                        (<fmt:message key="jsp.general.accountlocked" />)
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                        <c:if test="${editOpusUserData && status.value != 0}">
                            <tr>
                                <td class="label"><fmt:message key="jsp.general.resetfailedloginattempts" /></td>
                                <td>
                                   <input type="checkbox" name="opusUser_resetFailedLoginAttempts" />
                                </td>
                            </tr>
                        </c:if>
                    </spring:bind>
                 <c:if test="${editOpusUserData}">
                    <tr>
                    <td class="label">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><input type="submit" name="submitopususerdata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
                    </tr>
                </c:if>
            </table>
        </form:form>
    </div> <!-- end accordionpanelcontent -->
</div> <!--  added -->
    
<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.password" /></div>
    <div class="AccordionPanelContent">
        <form name="pwuserdata" id="pwuserdata" method="post">
            <input type="hidden" name="tab_opususer" value="1" /> 
            <input type="hidden" name="panel_password" value="1" />
            <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
            <table>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td class="label" colspan="3"><fmt:message key="jsp.password.change" /></td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>

                <sec:authorize access="!hasRole('RESET_PASSWORD')">
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.current.password" /></td>
                            <td>
                                <form:password path="studentOpusUserForm.currentPassword" />
                            </td>
                            <td>
                                <fmt:message key="jsp.general.message.passwordgenerated" />
                                <form:errors path="studentOpusUserForm.currentPassword" cssClass="error" />
                            </td>
                        </tr>
                </sec:authorize>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.new.password" /></td>
                    <td>
                        <form:password path="studentOpusUserForm.newPassword" />
                    </td>
                    <td><form:errors path="studentOpusUserForm.newPassword" cssClass="error" /></td>
                </tr>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.confirm" />&nbsp;<fmt:message key="jsp.general.new.password" /></td>
                    <td>
                        <form:password path="studentOpusUserForm.confirmPassword" />
                    </td>
                    <td><form:errors path="studentOpusUserForm.confirmPassword" cssClass="error" /></td>
                </tr>
                <tr>
                    <td class="label">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><input type="submit" name="submitpwuserdata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
                </tr>
            </table>
        </form>
    </div> <!-- end accordionpanelcontent -->
</div> <!-- end accordionpanel -->

<div class="AccordionPanel">
    <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.opususerroles" /></div>
    <div class="AccordionPanelContent">
        <br />

                <sec:authorize access="hasRole('UPDATE_USER_ROLES')">
                    <a class="button" href="<c:url value='/college/userrole.view'/>?<c:out value='userName=${studentOpusUserForm.personOpusUserRole.userName}&from=${from}&staffMemberId=${commandStaffMemberid}&studentId=${studentId}'/>">
                        <fmt:message key="jsp.href.add" />
                    </a>
                </sec:authorize>  

                <table class="tabledata2" id="rolesTable">
                    <tr>
                        <th></th>
                        <th><fmt:message key="jsp.general.role" /></th>
                        <th><fmt:message key="jsp.general.description" /></th>
                        <th><fmt:message key="jsp.general.organizationalunit" /></th>
                        <th><fmt:message key="jsp.general.branch" /></th>
                        <th><fmt:message key="jsp.general.validfrom" /></th>
                        <th><fmt:message key="jsp.general.validthrough" /></th>
                        <th><fmt:message key="jsp.general.status" /></th>
                        <th>&nbsp;</th>
                    </tr>
                    <% request.setAttribute("currentDate",  new java.util.Date()); %>
                    <c:forEach var="role" items="${studentOpusUserForm.userRoles}">
                        <tr>
                            <td>
                                <c:if test="${role.organizationalUnitId == studentOpusUserForm.opusUser.preferredOrganizationalUnitId}">
                                    (<fmt:message key="jsp.general.default"/>)
                                </c:if>
                            </td>
                            <td><c:out value="${role.role}"/></td>
                            <td><c:out value="${role.roleDescription}"/></td>
                            <td><c:out value="${role.organizationalUnit}"/></td>
                            <td><c:out value="${role.branchDescription}"/></td>
                            <td><fmt:formatDate pattern="dd/MM/yyyy" value="${role.validFrom}" /></td>
                            <td><fmt:formatDate pattern="dd/MM/yyyy" value="${role.validThrough}" /></td>
                            <td style="text-align:center;font-weight:bold;">
                                <c:choose>
                                    <c:when test="${not empty role.validThrough && (role.validThrough < currentDate)}">
                                        <span style="color:#bf1616;"><fmt:message key="jsp.general.expired"/></span>
                                    </c:when>
                                    <c:when test="${not empty role.validFrom && (role.validFrom > currentDate)}">
                                        <span style="color:#1a0599;"><fmt:message key="jsp.general.unavailable"/></span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color:#036f43;"><fmt:message key="jsp.general.active"/></span> 
                                    </c:otherwise>
                                </c:choose> 
                            </td>
                            <td class="buttonsCell" >
                                <sec:authorize access="hasRole('UPDATE_USER_ROLES')">
                                    <a class="imageLink" href="<c:url value='/college/userrole.view'/>?tab=1&amp;panel=2&amp;userName=<c:out value='${studentOpusUserForm.personOpusUserRole.userName}'/>&amp;roleId=${role.id}&amp;from=${from}&amp;staffMemberId=${commandStaffMemberid}&amp;studentId=${studentId}"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                </sec:authorize>      

                                <sec:authorize access="hasRole('DELETE_USER_ROLES')">
                                    <c:if test="${fn:length(studentOpusUserForm.userRoles) > 1}">
                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/userrole_delete.view?tab=1&amp;panel=2&amp;id=${role.id}&amp;from=student&amp;staffMemberId=${commandStaffMemberid}&amp;studentId=${studentId}' />"
                                            onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"
                                        >
                                            <img src="<c:url value='/images/delete.gif' />" 
                                                alt="<fmt:message key="jsp.href.delete" />" 
                                                title="<fmt:message key="jsp.href.delete" />"
                                            />
                                        </a>
                                    </c:if>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
                <script type="text/javascript">alternate('rolesTable',true)</script>
           </div> <!--  role accordionpanelcontent -->
</div> <!--  role accordionpanel --> 
                                       
