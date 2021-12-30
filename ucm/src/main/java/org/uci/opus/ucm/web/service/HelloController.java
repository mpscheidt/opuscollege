package org.uci.opus.ucm.web.service;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicLong;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.uci.opus.ucm.domain.Greeting;

@Controller
public class HelloController {

    private static final String template = "Hello, %s!";
    private final AtomicLong counter = new AtomicLong();

    @RequestMapping("/hello.view")
    public @ResponseBody Greeting greeting(
            @RequestParam(value="name", required=false, defaultValue="World") String name) {
        return new Greeting(counter.incrementAndGet(),
                            String.format(template, name));
    }
    
    @RequestMapping(value="/hello5.svc",headers="Accept=*/*", produces="application/json")
    public @ResponseBody Greeting greetingService(
            @RequestParam(value="name", required=false, defaultValue="World") String name) {
        return new Greeting(counter.incrementAndGet(),
                            String.format(template, name));
    }
    
    @RequestMapping("/hello2.view")
    public void greeting(HttpServletRequest request, HttpServletResponse response,
            @RequestParam(value="name", required=false, defaultValue="World") String name) throws IOException {
        
    	response.getWriter().write("Name is:" + name);
    }
    @RequestMapping("/hello2.svc")
    public void greetingSvc2(HttpServletRequest request, HttpServletResponse response,
            @RequestParam(value="name", required=false, defaultValue="World") String name) throws IOException {
        
    	response.getWriter().write("SVC 2:" + name);
    }
    
    @RequestMapping("/ucm/greeting.svc")
    public @ResponseBody Greeting greetingSer(
            @RequestParam(value="name", required=false, defaultValue="World") String name) {
        return new Greeting(counter.incrementAndGet(),
                            String.format(template, name));
    }
    
    
    @RequestMapping("/svc/person")
    public @ResponseBody Greeting personSvc(
            @RequestParam(value="name", required=false, defaultValue="World") String name) {
        return new Greeting(counter.incrementAndGet(),
                            String.format(template, name));
    }
}