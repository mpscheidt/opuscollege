package org.uci.opus.ucm.web.service.formulariomatricula;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.ucm.web.service.JsonResponseFactory;
import org.uci.opus.ucm.web.service.campusonline.LatestTimeUnitDTOFactory;
import org.uci.opus.ucm.web.service.campusonline.ResultDTOFactory;
import org.uci.opus.util.OpusMethods;

@Controller
@RequestMapping("/formularioMatricula")
public class FormularioMatricula {
	
private static final String LANGUAGE = "pt";
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private LatestTimeUnitDTOFactory latestTimeUnitDTOFactory;
    
    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private ResultDTOFactory resultDTOFactory;
    
    @Autowired
    private JsonResponseFactory jsonResponseFactory;
	 
	 @Autowired
	 private ReportController reportcontroller;


	 @RequestMapping("/studyplanreport/{reportName}/{studentCode}/{hash}")
	   @ResponseBody
	   public ModelAndView getMatriculaInternos(HttpSession session, HttpServletRequest request, ModelAndView view, ModelMap map, @PathVariable("reportName")String reportName,
	   @PathVariable String studentCode, @PathVariable String hash ){
		 JsonResponse jsonResponse = jsonResponseFactory.fromMD5Hash(studentCode, hash);

	        // If hash invalid, return without reading from database
	        if (!jsonResponse.isSuccessful()) {
	            log.info("wrong hash given for studentCode " + studentCode);
	            return null;
	        }
		 Locale curLocale = OpusMethods.getPreferredLocale(request);
	    //map.put("format", "pdf");
        //String studentCode = new Student().getStudentCode();
	     view = reportcontroller.createReport(session, reportName, "AND student.studentcode='"+studentCode+"'", "pdf", curLocale);
	     return view;
	   }

}
