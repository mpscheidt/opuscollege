package org.uci.opus.admin.web.flow;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.ws.Response;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Deal with session expiration, which happens when a users logs in more than once.
 * 
 * Instead of simply getting the default message on a white background ('This session has been expired (possibly due to multiple concurrent
 * logins being attempted as the same user).'), we want and have to deal with this situation a bit more specific, especially as a reload
 * doesn't anymore forward to the login page because the session doesn't get automatically invalidated anymore.
 * 
 * @author Markus Pscheidt
 *
 */
@Controller
@RequestMapping(value = "/sessionExpired")
public class SessionExpiredController {

    @RequestMapping(method = RequestMethod.GET)
    public void expireSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        System.out.println("sess exp");

        String tenantCode = null;
        HttpSession session = request.getSession(false);
        if (session != null) {
            tenantCode = (String) session.getAttribute("tenantCode");
//            session.invalidate();
            request.getSession();
        }

        String URL = request.getContextPath() + "/login";
        if (tenantCode != null) {
            URL += "/" + tenantCode;
        }

        response.setStatus(HttpStatus.OK.value());
        response.sendRedirect(URL);
    }

}
