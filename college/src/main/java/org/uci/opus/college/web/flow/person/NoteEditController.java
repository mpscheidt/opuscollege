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

package org.uci.opus.college.web.flow.person;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Note;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.NoteManager;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.NoteForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/note.view")
@SessionAttributes("noteForm")
public class NoteEditController {
    
     private static Logger log = LoggerFactory.getLogger(NoteEditController.class);

     @Autowired private SecurityChecker securityChecker;    
     @Autowired private OpusMethods opusMethods;
     @Autowired private StudentManagerInterface studentManager;
     @Autowired private NoteManager noteManager;
     
     private String formView;

    public NoteEditController() {
        super();
        this.formView = "college/person/note";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {
        
        if (log.isDebugEnabled()) {
            log.debug("NoteEditController.setUpForm entered...");
        }

        // declare variables
        NoteForm noteForm = null;
        NavigationSettings navSettings = null;
        Note note = null;
        int noteId = 0;
        int studentId = 0;
        Student student = null;

        HttpSession session = request.getSession(false);        

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        /* perform session-check. If wrong, an Exception is thrown towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        opusMethods.removeSessionFormObject("noteForm", session, true);
        
        /* fetch or create the form object */
        if ((NoteForm) session.getAttribute("noteForm") != null) {
            noteForm = (NoteForm) session.getAttribute("noteForm");
        } else {
            noteForm = new NoteForm();
            if (!StringUtil.isNullOrEmpty(request.getParameter("noteType"))) {
                noteForm.setNoteType(request.getParameter("noteType"));
            }
            
            if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
                studentId = Integer.parseInt(request.getParameter("studentId"));
            }
            
            if (!StringUtil.isNullOrEmpty(request.getParameter("tabtext"))) {
                noteForm.setTabtext(request.getParameter("tabtext"));
            }
            
            if (!StringUtil.isNullOrEmpty(request.getParameter("paneltext"))) {
                noteForm.setPaneltext(request.getParameter("paneltext"));
            }
            
            if (studentId != 0) {
                student = studentManager.findStudent(preferredLanguage, studentId);
                noteForm.setStudent(student);
            }
        }

        // entering the form: the NoteForm.note does not exist yet
        if (noteForm.getNote() == null) {

            if (!StringUtil.isNullOrEmpty(request.getParameter("noteId"))) {
              noteId = Integer.parseInt(request.getParameter("noteId"));
            }

            // note already exists
            if (noteId != 0) {
                note = noteManager.findNote(noteId, noteForm.getNoteType());
            } else {
                note = new Note();
                note.setForeignId(studentId);
            }
            noteForm.setNote(note);
            
        } else {
            note = noteForm.getNote();
        }
        
        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (noteForm.getNavigationSettings() != null) {
            navSettings = noteForm.getNavigationSettings();
        } else {
            navSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navSettings, "note.view");
        }
        noteForm.setNavigationSettings(navSettings);
        
        model.addAttribute("noteForm", noteForm);        
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("noteForm") NoteForm noteForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("NoteEditController.processSubmit entered...");
        }
        
        Note note = noteForm.getNote();
        NavigationSettings navSettings = noteForm.getNavigationSettings();

        if (note.getId() == 0) {
            noteManager.addNote(note, noteForm.getNoteType());
        } else {
            noteManager.updateNote(note, noteForm.getNoteType());
        }
            status.setComplete();

            return "redirect:/college/student/personal.view?newForm=true&tab=" + navSettings.getTab()
                                            + "&panel=" + navSettings.getPanel()
                                            + "&currentPageNumber="
                                            + navSettings.getCurrentPageNumber()
                                            + "&studentId=" + noteForm.getStudent().getStudentId();
    }
}
