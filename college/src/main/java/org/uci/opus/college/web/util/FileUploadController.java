/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.college.web.util;

import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.util.StringUtil;

/**
 * @author gena
 * FileUploadController will persist the uploaded file via 
 * personManager to the database.
 *
 */
@Controller
@RequestMapping(value = "/college/photographdata.view")
public class FileUploadController {
	
	private static Logger log = LoggerFactory.getLogger(FileUploadController.class);
	
	@Autowired private PersonManagerInterface personManager;
	@Autowired private StaffMemberManagerInterface staffMemberManager;
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private MessageSource messageSource;      
	@Autowired private AppConfigManagerInterface appConfigManager;

	/*
	@ExceptionHandler(MaxUploadSizeExceededException.class)
	  public String handleIOException(MaxUploadSizeExceededException ex, HttpServletRequest request) {
	    return "/college/students.view";
	  }*/
	
	@InitBinder
	protected final void initBinder(HttpServletRequest request, ServletRequestDataBinder binder)
 	throws ServletException {
 
 	binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
 }
    /**
     * {@inheritDoc}.
     * @see org.springframework.web.servlet.mvc.SimpleFormController
     * 		#onSubmit(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse
     * 		, java.lang.Object, org.springframework.validation.BindException)
     */
    @RequestMapping(method = RequestMethod.POST)
    protected ModelAndView onSubmit(@ModelAttribute("fileUploadBean") FileUploadBean fileUploadBean,
            HttpServletRequest request) {
    	//@RequestParam("file") MultipartFile mFile, 

        /** 
         * Cast the command bean to a FileUploadBean.
         */    	    
    	
    	String personId = request.getParameter("personId");
    	int pId = Integer.parseInt(personId);
    	String photoType = request.getParameter("photo_type");
    	String deletePhotogaph = request.getParameter("deletephoto");
    	String from  = request.getParameter("from");
    	String tab = request.getParameter("tab");
    	String panel = request.getParameter("panel");
    	Person person = new Person();
    	Student student = new Student();
    	String showDocTypeError = "";
    	String showPhotoTypeError = "";
    	
    	ModelAndView mav = new ModelAndView();
    	
    	/* with each call the preferred language may be changed */
        HttpSession session = request.getSession(false);        
        ServletContext context = session.getServletContext();
        
    	Locale currentLoc = RequestContextUtils.getLocale(request);
         
        /* navigation parameters */
        if (StringUtil.isNullOrEmpty(photoType)) {
        	// person-photo staffmember/student:
//        	 tab   = request.getParameter("tab_personaldata");
//        	 panel = request.getParameter("panel_photograph"); 

             person.setId(pId);

        } else {
        	if ("previnstdiplomaphotograph".equals(photoType)) {
            	// photo previous institution diploma from student:
//        		tab   = request.getParameter("tab_studyplan"); 
//        		panel = request.getParameter("panel_previnstdiplomaphotographdata");
            	student = studentManager.findStudentByPersonId(pId);
        	}
        }
        
        //byte[] file = mFile.getBytes();    
        
        /* cast to multipart file so we can get additional information */
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        CommonsMultipartFile commonsfile = (CommonsMultipartFile) multipartRequest.getFile("file");
        
        byte[] file = fileUploadBean.getFile();
        
        /* get Mimetype: */
        String fileType = commonsfile.getContentType();
        String fileName = commonsfile.getOriginalFilename();
        
        boolean isImage = false;
        boolean isDoc = false;
        
        String imagetypes = context.getInitParameter("image_mime");
        String[] imagetypeslist = imagetypes.split(",");
        
        /* see if mimetype is ok */
        for (int i = 0; i < imagetypeslist.length; i++) {        	
        	String onetype = imagetypeslist[i].trim(); 
        	if (onetype != null && onetype.equals(fileType)) {
        		isImage = true;
        		break;
        	}
        }

        String doctypes = context.getInitParameter("doc_mime");
        String[] doctypeslist = doctypes.split(",");
        
        /* see if mimetype is ok */
        for (int i = 0; i < doctypeslist.length; i++) {        	
        	String onetype = doctypeslist[i].trim(); 
        	if (onetype != null && onetype.equals(fileType)) {
        		isDoc = true;
        		break;
        	}
        }        
        
        if ("true".equals(deletePhotogaph)) {
    		/* delete regardless of uploaded file */	
        	if (StringUtil.isNullOrEmpty(photoType)) {
        		person.setPhotograph(null);
        		person.setPhotographName(null);
        		person.setPhotographMimeType(null);
        		personManager.updatePersonPhotograph(person);
        	} else {
            	if ("previnstdiplomaphotograph".equals(photoType)) {
            		/* delete regardless of uploaded file */	
            		student.setPreviousInstitutionDiplomaPhotograph(null);
            		student.setPreviousInstitutionDiplomaPhotographName(null);
            		student.setPreviousInstitutionDiplomaPhotographMimeType(null);
            		studentManager.updatePreviousInstitutionDiplomaPhotograph(student);
            	}
        	}        	
        } else if (file != null && file.length != 0) {

        	/* We have a non empty file, persist when allowed */
        	if (StringUtil.isNullOrEmpty(photoType)) {

        	    int maxUploadSizeImage = appConfigManager.getMaxUploadSizeImage();
                if (file.length > maxUploadSizeImage) {
                    showPhotoTypeError = messageSource.getMessage(
                            "invalid.uploadsize", new Object[] {maxUploadSizeImage}, currentLoc);
                    mav.addObject("showPhotoTypeError", showPhotoTypeError);

                } else if (!isImage) {
            		showPhotoTypeError = messageSource.getMessage(
        									"invalid.imagetype.format", null, currentLoc);
        			mav.addObject("showPhotoTypeError", showPhotoTypeError);
        			
        		} else {
	        		person.setPhotograph(file);
	        		person.setPhotographName(fileName);
	        		person.setPhotographMimeType(fileType);
	        		personManager.updatePersonPhotograph(person);
        		}
        	} else {     
        		
                int maxUploadSizeDoc = appConfigManager.getMaxUploadSizeDoc();
                if (file.length > maxUploadSizeDoc) {
                    showPhotoTypeError = messageSource.getMessage(
                            "invalid.uploadsize", new Object[] {maxUploadSizeDoc}, currentLoc);
                    mav.addObject("showDocTypeError", showPhotoTypeError);

                } else if (!isDoc) {
           			showDocTypeError = messageSource.getMessage(
           									"invalid.doctype.format", null, currentLoc);
        			mav.addObject("showDocTypeError", showDocTypeError);
        		} else {   		
	           		student.setPreviousInstitutionDiplomaPhotograph(file);
	           		student.setPreviousInstitutionDiplomaPhotographName(fileName);
	           		student.setPreviousInstitutionDiplomaPhotographMimeType(fileType);
	        		studentManager.updatePreviousInstitutionDiplomaPhotograph(student);
        		}
        	}
        }        
        
        /* handle flow */
        if ("staffmember".equals(from)) {
        	StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(
        			pId);
         	
        	mav.setViewName("redirect:staffmember.view?newForm=true&tab=" + tab + "&panel=" + panel        
         			+ "&staffMemberId=" + staffMember.getStaffMemberId() 
         			+ "&from=" + from + "&showPhotoTypeError="+showPhotoTypeError);         	
        }
        
        if ("student".equals(from)) {

        	student = studentManager.findStudentByPersonId(pId);

        	String viewString = "";
            switch (Integer.valueOf(tab)) {
		        case 0: viewString = "student/personal.view";
		        	break;
		        case 1: viewString = "student-opususer.view";
		        	break;
		        case 2: viewString = "student/subscription.view";
		        	break;
		        case 3: viewString = "student-absences.view";
		        	break;
		        case 4: viewString = "student-addresses.view";
		        	break;
		        default: viewString = "student/personal.view";
		        	break;
            }
            
        	mav.setViewName("redirect:"+ viewString + "?newForm=true&tab=" + tab + "&panel=" + panel        
         			+ "&studentId=" + student.getStudentId() 
         			+ "&from=" + from + "&showDocTypeError="+showDocTypeError
         			+ "&showPhotoTypeError="+showPhotoTypeError);         	
        }

        return mav;
    }

	/**
	 * @return personManager
	 */
	public PersonManagerInterface getPersonManager() {
		return personManager;
	}

	/**
	 * @param personManager can now be set efor example by Spring.
	 */
	public void setPersonManager(final PersonManagerInterface personManager) {
		this.personManager = personManager;
	}

	public void setStaffMemberManager(final StaffMemberManagerInterface staffMemberManager) {
		this.staffMemberManager = staffMemberManager;
	}

	public void setStudentManager(final StudentManagerInterface studentManager) {
		this.studentManager = studentManager;
	}

	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

}
