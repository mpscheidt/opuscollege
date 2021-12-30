package org.uci.opus.college.web.flow;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.util.NestedServletException;
import org.uci.opus.college.domain.OpusUser;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({
        "/standardTestBeans.xml",
//        "/standardRestTestBeans.xml",
        "/org/uci/opus/college/applicationContext-data.xml",
        "/org/uci/opus/college/applicationContext-util.xml",
        "/org/uci/opus/college/applicationContext-service.xml",
//        "/org/uci/opus/ucm/applicationContext.xml",
//        "CampusOnlineTest-context.xml"
        "/org/uci/opus/college/applicationContext-web-flow.xml",
        "/org/uci/opus/college/applicationContext-web-util.xml",
        "/org/uci/opus/college/applicationContext-web-extensions.xml",
        "/org/uci/opus/college/applicationContext-security.xml"
})
public class StudentPersonalEditControllerTest {

//    @Autowired
//    FilterChainProxy springSecurityFilterChain;
    
    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Before
    public void setup() {

        // Spring Security test integration, see: 
        //   http://docs.spring.io/spring-security/site/docs/current/reference/html/test-mockmvc.html
        this.mockMvc = MockMvcBuilders
                .webAppContextSetup(wac)
                .alwaysDo(print())
                .apply(SecurityMockMvcConfigurers.springSecurity())
                .build();
//                MockMvcBuilders.webAppContextSetup(this.wac).apply(SecurityMockMvcConfigurers.springSecurity()).build();
    }

    private OpusUser admin() {
        OpusUser user = new OpusUser("admin", "en", 1);
        return user;
    }
    
    // TODO The following test would be fine if all the test data would be inserted in the database
//    @Test
//    public void testSetUpFormPersonal_NoStudentIdGiven() throws Exception {
//
//        this.mockMvc.perform(get("/college/student/personal")
//                .with(SecurityMockMvcRequestPostProcessors.user(admin()))
//                .accept(MediaType.parseMediaType("text/html; charset=UTF-8"))
//                )
//                .andExpect(status().isOk());
//    }

    @Test(expected = NestedServletException.class)
    public void testSetUpFormPersonal_InvalidStudentIdGiven() throws Exception {

        this.mockMvc.perform(get("/college/student/personal?studentId=1")
                .with(SecurityMockMvcRequestPostProcessors.user(admin())));
    }

}
