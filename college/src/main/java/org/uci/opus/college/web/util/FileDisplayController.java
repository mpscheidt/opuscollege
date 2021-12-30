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

import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.util.StringUtil;

/**
 * @author gena
 * FileDisplayController writes image bytes straight to the
 * response output stream in order to display an image found
 * by Person.id.
 */
@Controller
@RequestMapping("/college/photographview.view")
public class FileDisplayController {
	
	private static Logger log = LoggerFactory.getLogger(FileDisplayController.class);
	private PersonManagerInterface personManager;
	private StudentManagerInterface studentManager;
	
    @RequestMapping(method=RequestMethod.GET)
    public void streamImageContent(HttpServletRequest request, HttpServletResponse response) throws IOException {
	     
		 String personId = request.getParameter("personId");		 
	     int pId = Integer.parseInt(personId);
		 Person person   = new Person();
		 Student student = new Student();
		 String photoType = request.getParameter("photo_type");
	     String tab = request.getParameter("tab");
	     String panel = request.getParameter("panel");
	     byte[] photo = null;

	     if (StringUtil.isNullOrEmpty(photoType)) {
	         person = personManager.findPersonById(pId);
	         if (person != null) {			    		 	    		 
	             response.setContentType(person.getPhotographMimeType());
                 response.setHeader("Content-Disposition", "attachment;filename=" + person.getPhotographName());	    		 
	    		 photo = person.getPhotograph();
	    	 }
	     } else {
	    	 student   = studentManager.findStudentByPersonId(pId);
			 if (student != null) {
				 response.setContentType(student.getPreviousInstitutionDiplomaPhotographMimeType());
				 response.setHeader("Content-Disposition", "attachment;filename=" + student.getPreviousInstitutionDiplomaPhotographName());
	    		 photo = student.getPreviousInstitutionDiplomaPhotograph();
			 }
	     }
	     if (photo != null) {
			 /**
			  * We set no image extension (.gif/.jpg/..) since we only 
			  * have bytes and no filename in the database.
			  */
			 response.setStatus(HttpServletResponse.SC_OK);
			 ServletOutputStream out = response.getOutputStream();			 
			 out.write(photo);
			 out.flush();
			 out.close();
		 }
	}

    /**
     * @param personManager set for example by Spring.
     */
    public void setPersonManager(final PersonManagerInterface personManager) {
 		this.personManager = personManager;
    }

	/**
	 * @param studentManager to set.
	 */
	public void setStudentManager(final StudentManagerInterface studentManager) {
		this.studentManager = studentManager;
	}
    
}
