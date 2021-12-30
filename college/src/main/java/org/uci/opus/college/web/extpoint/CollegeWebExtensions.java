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

package org.uci.opus.college.web.extpoint;

import java.lang.reflect.Field;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;

public class CollegeWebExtensions implements IExtensionCollection {

	private static Logger log = LoggerFactory.getLogger(CollegeWebExtensions.class);

	@Autowired private ExtensionPointUtil extensionPointUtil;
	
	private List<AddStudentScreen> addStudentScreenExtensions;

	// result formatter extensions
    private CtuResultFormatter ctuResultFormatter;
    private CtuResultFormatterForStudents ctuResultFormatterForStudents;
	private StudyPlanResultFormatter studyPlanResultFormatter;
	private StudyPlanResultFormatterForStudents studyPlanResultFormatterForStudents;
    private SubjectResultFormatter subjectResultFormatter;
    private ThesisResultFormatter thesisResultFormatter;
    private ThesisResultFormatterForStudents thesisResultFormatterForStudents;

    private SubjectResultFormatterForStudents subjectResultFormatterForStudents;

    // screen header extensions
    private List<StudentEditHeaderItem> studentEditHeaderItems;

    // tabs in the "Edit student" screen
    private List<StudentTab> studentTabs;

    @Autowired(required=false)
    public void setAddStudentScreenExtensions(List<AddStudentScreen> studentScreenExtensions) {
        this.addStudentScreenExtensions = studentScreenExtensions;
        extensionPointUtil.logExtensions(log, AddStudentScreen.class, studentScreenExtensions);
        
    }

	public List<AddStudentScreen> getAddStudentScreenExtensions() {
		return addStudentScreenExtensions;
	}

    public StudyPlanResultFormatter getStudyPlanResultFormatter() {
    	
    	boolean isStudent = SecurityContextHolder.getContext().getAuthentication().getAuthorities().contains(new SimpleGrantedAuthority("student"));

    	if(isStudent)
    		return studyPlanResultFormatterForStudents;
    	else    		
    		return studyPlanResultFormatter;
    }
    
    @Autowired(required=true)
    @Qualifier("StudyPlanResultFormatter")
    public void setStudyPlanResultFormatter(StudyPlanResultFormatter studyPlanResultFormatter) {
        this.studyPlanResultFormatter = studyPlanResultFormatter;
        extensionPointUtil.logExtensions(log, StudyPlanResultFormatter.class, studyPlanResultFormatter);
    }

    @Autowired(required=true)
    @Qualifier("StudyPlanResultFormatterForStudents")
    public void setStudyPlanResultFormatterForStudents(StudyPlanResultFormatterForStudents studyPlanResultFormatterForStudents) {
        this.studyPlanResultFormatterForStudents = studyPlanResultFormatterForStudents;
        extensionPointUtil.logExtensions(log, StudyPlanResultFormatterForStudents.class, studyPlanResultFormatterForStudents);
    }

    public ThesisResultFormatter getThesisResultFormatter() {
    	
    	boolean isStudent = SecurityContextHolder.getContext().getAuthentication().getAuthorities().contains(new SimpleGrantedAuthority("student"));

    	if(isStudent)
    		return thesisResultFormatterForStudents;
    	else    		
    		return thesisResultFormatter;
    }
    
    @Autowired(required=true)
    @Qualifier("ThesisResultFormatter")
    public void setThesisResultFormatter(ThesisResultFormatter thesisResultFormatter) {
        this.thesisResultFormatter = thesisResultFormatter;
        extensionPointUtil.logExtensions(log, ThesisResultFormatter.class, thesisResultFormatter);
    }
    
    @Autowired(required=true)
    @Qualifier("ThesisResultFormatterForStudents")
    public void setThesisResultFormatterForStudents(ThesisResultFormatterForStudents thesisResultFormatterForStudents) {
        this.thesisResultFormatterForStudents = thesisResultFormatterForStudents;
        extensionPointUtil.logExtensions(log, ThesisResultFormatterForStudents.class, thesisResultFormatterForStudents);
    }

    public CtuResultFormatter getCtuResultFormatter() {
    	
    	boolean isStudent = SecurityContextHolder.getContext().getAuthentication().getAuthorities().contains(new SimpleGrantedAuthority("student"));

    	if(isStudent)
    		return ctuResultFormatterForStudents;
    	else    		
    		return ctuResultFormatter;
    }
    
    @Autowired(required=true)
    @Qualifier("CtuResultFormatter")
    public void setCtuResultFormatter(CtuResultFormatter ctuResultFormatter) {
        this.ctuResultFormatter = ctuResultFormatter;
        extensionPointUtil.logExtensions(log, CtuResultFormatter.class, ctuResultFormatter);
    }
    
    @Autowired(required=true)
    @Qualifier("CtuResultFormatterForStudents")
    public void setCtuResultFormatterForStudents(CtuResultFormatterForStudents ctuResultFormatterForStudents) {
        this.ctuResultFormatterForStudents = ctuResultFormatterForStudents;
        extensionPointUtil.logExtensions(log, CtuResultFormatterForStudents.class, ctuResultFormatterForStudents);
    }

    public SubjectResultFormatter getSubjectResultFormatter() {
    	
    	boolean isStudent = SecurityContextHolder.getContext().getAuthentication().getAuthorities().contains(new SimpleGrantedAuthority("student"));

    	if(isStudent) {
    	    // if there is no specific formatter, use the same formatter as is used for everyone else
    	    if (subjectResultFormatterForStudents == null) {
    	        return subjectResultFormatter;
    	    }
    		return subjectResultFormatterForStudents;
    	} else {
    		return subjectResultFormatter;
    	}
    }
    
    @Autowired(required=true)
    @Qualifier("SubjectResultFormatter")
    public void setSubjectResultFormatter(SubjectResultFormatter subjectResultFormatter) {
        this.subjectResultFormatter = subjectResultFormatter;
        extensionPointUtil.logExtensions(log, SubjectResultFormatter.class, subjectResultFormatter);
    }
    
    @Autowired(required=false)
    @Qualifier("SubjectResultFormatterForStudents")
    public void setSubjectResultFormatterForStudents(
            SubjectResultFormatterForStudents subjectResultFormatterForStudents) {
        this.subjectResultFormatterForStudents = subjectResultFormatterForStudents;
    }

    @Autowired(required=false)
    public void setStudentEditHeaderItems(List<StudentEditHeaderItem> studentEditHeaderItems) {
        this.studentEditHeaderItems = studentEditHeaderItems;
        extensionPointUtil.logExtensions(log, StudentEditHeaderItem.class, studentEditHeaderItems);
    }

    public List<StudentEditHeaderItem> getStudentEditHeaderItems() {
        return studentEditHeaderItems;
    }

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

    public List<StudentTab> getStudentTabs() {
        return studentTabs;
    }

    @Autowired(required=false)
    public void setStudentTabs(List<StudentTab> studentTabs) {
        this.studentTabs = studentTabs;
        extensionPointUtil.logExtensions(log, StudentTab.class, studentTabs);
    }
    
}
