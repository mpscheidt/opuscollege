package org.uci.opus.admin.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginController {

    public static final String REQUEST_URL = "/login";
    private static final String VIEW = "login";

    @Autowired
    private HttpSession httpSession;

    public LoginController() {
    }

    @RequestMapping(value = REQUEST_URL)
    public String prepareLogin(HttpServletRequest request, ModelMap model) {

        // avoid lingering session attributes if previously logged into a specific tenant
        httpSession.removeAttribute("tenantCode");
        httpSession.removeAttribute("tenantTxt");

        return VIEW;
    }

}
