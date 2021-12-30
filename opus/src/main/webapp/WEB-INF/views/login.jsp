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
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>

<%@ page language="java" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 

<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<jsp:useBean class="org.uci.opus.util.OpusMethods" id="opusMethods" scope="page" />

<%-- 
   en: Zambia 
   pt: Mozambique  
--%>
<fmt:setLocale value="en" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Opus</title>
    <jwr:style src="/styles/login.css" />
    <jwr:style src="/styles/login1024.css" />
    <jwr:style src="/styles/loginUniversity.css" />
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8"/>
</head>


<body>

<% 
ServletContext context = this.getServletContext();
WebApplicationContext webContext = WebApplicationContextUtils.getWebApplicationContext(context);
java.util.List<org.uci.opus.college.module.Module> moduleList = opusMethods.getModules(webContext);
%>

    <%-- make a JSP variable out of the servlet variable --%>
    <c:set var="modules" value="<%=moduleList%>" />

    <div id="page">
        
        <div id="HeaderLogin">&nbsp;
            <p id="Language">
            <br />
                | <a href="http://www.opuscollege.net/instruction" target="_blank"><fmt:message key="jsp.general.message.help" /></a>
                <c:if test="${modules != null && modules != ''}">
                    <c:forEach var="module" items="${modules}">
                   
                        <c:if test="${fn:toLowerCase(module.module) == 'admission'}">
                            | <a href="<c:url value='/request_admission.view?newForm=true'/>"><fmt:message key="jsp.register" /></a>
                       </c:if>
                    </c:forEach>
                </c:if>
                |
            </p>
        </div>

        <c:if test="${not empty upgradeException}">
            <c:set var="disabledAttr" value='disabled="disabled"' />
        </c:if>

        <c:url var="loginUrl" value="/j_spring_security_check"/>
<%--         <c:url var="loginUrl" value="/login"/> --%>
        <form id="LoginForm" action="${loginUrl}" method="post">

            <%-- LoginContent: the big white area, see css --%>        
            <div id="LoginContent">

                <%-- login: the light blue colored box, see css --%>
                <div id="login">
                    <div style="display: table;">
                        <div style="display: table-row;">
                            <div style="display: table-cell;">
                                <img src="<c:url value='/images/logo_b.gif' />" alt="OPUS College" style="float:left; margin:0px 10px; border:1px solid black" />
                            </div>
                            <div style="display: table-cell; vertical-align: middle;">
                                <div style="display: inline-table; border-spacing: 4px;">
                                    <div style="display: table-row;">
                                        <div class="logotxt" style="display: table-cell; height: 50px;" >
                                            OPUS-College<br/>
                                            <fmt:message key="jsp.login.system.name" />
                                        </div>
                                    </div>

                                    <div style="display: table-row;">
                                        <div style="display: table-cell;">
                                            <div style="display: table; width: 220px;">

                                                <div style="display: table-row; text-align: left;">
                                                    <div style="display: table-cell;">
                                                        <%-- width: 99 percent to (more or less perfectly) right aligne text field with submit button; Edge and Chrome seem to render better than Firefox here --%>
                                                        <fmt:message var="usernameMsg" key="jsp.login.username" />
                                                        <input style="width: 99%;" type="text" name="j_username" id="username" placeholder="${usernameMsg}" ${disabledAttr} value='<c:if test="${not empty param.loginError}"><c:out value="${SPRING_SECURITY_LAST_USERNAME}" /></c:if>'/>
                                                    </div>
                                                </div>

                                                <div style="display: table-row; text-align: left;">
                                                    <div style="display: table-cell;">
                                                        <fmt:message var="pwdMsg" key="jsp.login.password" />
                                                        <input style="width: 99%;" type="password" name="j_password" id="password" placeholder="${pwdMsg}" ${disabledAttr} />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="display: table-row;">
                                        <div style="display: table-cell;">
                                            <div style="display: table; width: 220px;">
        
                                                <div style="display: table-row; height: 25px" >
                                                    <div style="display: table-cell; width: 70%; text-align: center; vertical-align: bottom;">
                                                        <c:if test="${not empty param.loginError}">
                                                            <div class="error">
                                                                <fmt:message key="error.login.${param.loginError}" />
                                                            </div>
                                                        </c:if>
                                                    </div>
        
                                                    <div class="label" style="display: table-cell; width: 30%; text-align: right; vertical-align: bottom;">
                                                        <input type="submit" value="Log in" ${disabledAttr} style="width: 100%;" />
                                                    </div>
                                                </div>
                                                
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <%-- updateException: a light red box that displays the exception during database upgrade --%>
                <c:if test="${not empty upgradeException}">
                    <div id="upgradeException">
                        ERROR ON SYSTEM UPGRADE:
                        <br/>
                        <c:out value="${fn:substring(upgradeException.cause.message,0,100)}" />...
                    </div>
                </c:if>

            </div>
        </form>
        
        <%@ include file="footerDiv.jsp"%>
    </div>

    <script type="text/javascript">document.forms[0].username.focus()</script>

</body>
</html>
