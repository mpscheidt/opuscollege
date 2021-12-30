package org.uci.opus.ucm.web.service;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.ucm.domain.Greeting;
import org.uci.opus.ucm.domain.ResponseMessage;

@Controller
@RequestMapping("/student")
public class UcmStudentServiceController {

	@Autowired private StudentManagerInterface studentManager;
	private static final String template = "H, %s!";
	private final AtomicLong counter = new AtomicLong();

	@RequestMapping("/{studentCode}")
	public @ResponseBody
	Greeting greeting(@PathVariable String studentCode) {
		return new Greeting(counter.incrementAndGet(), String.format(template,
				studentCode));
	}

	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public String saveStudent(@RequestBody Student student) {
		
		//studentService.save(student);
		return "Saved : " + student.getFirstnamesFull() + " " + student.getSurnameFull();
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.GET)
	@ResponseBody
	public String saveStudentGet(@RequestBody Student student) {
		
		//studentService.save(student);
		return "Saved : " + student.getStudentCode();
	}
	
	@RequestMapping(value = "/save2", method = RequestMethod.GET)
	@ResponseBody
	public ResponseMessage saveStudent2() {
		
		//studentService.save(student);
		return new ResponseMessage("OK", "Student saved sucessfuly");
	}
	
	
}