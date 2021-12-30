package org.uci.opus.college.web.flow.person;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.IStudentForm;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

/**
 * Common functionality of the student edit screens such as StudentPersonalEditController.
 * 
 * <p>
 * It is expected that deriving controllers put the model attribute with name {@value #FORM_NAME_SHARED} on the session attributes in order to share between student screens.
 * 
 * @author Markus Pscheidt
 *
 */
public abstract class AbstractStudentEditController<F extends IStudentForm> {

    public static final String FORM_NAME_SHARED = "studentFormShared";

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private StudyManagerInterface studyManager;

    private boolean loadFormData;

    protected final String FORM_VIEW = "college/person/student";

    public AbstractStudentEditController() {
    }

    protected abstract F newFormInstance();

    protected F setupFormShared(String formName, ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession();

        boolean needNewForm = needNewForm(formName, model, request);
        opusMethods.removeSessionFormObject(formName, session, model, needNewForm);

        boolean needNewShared = needNewShared(model, request);
        opusMethods.removeSessionFormObject(FORM_NAME_SHARED, session, model, needNewShared);

        F form = getForm(formName, model);

        StudentFormShared shared = getSharedFromModel(model);
        if (shared == null) {
            shared = makeNewShared(model, request);
        }

        this.loadFormData = form == null;
        if (this.loadFormData) {
            form = newFormInstance();
            model.put(formName, form);
        }

        form.setStudentFormShared(shared);
        
        // shared form may have been updated, therefore always put on session
        model.put(FORM_NAME_SHARED, shared);
//        session.setAttribute(FORM_NAME_SHARED, shared);

        // NavigationSettings change when switching between tabs, even though the other data in the form is still valid and newForm=false
        NavigationSettings navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings);
        shared.setNavigationSettings(navigationSettings);

        return form;
    }

    protected F getForm(String formName, ModelMap model) {
        @SuppressWarnings("unchecked")
        F form = (F) model.get(formName);
        return form;
    }
    
    private StudentFormShared makeNewShared(ModelMap model, HttpServletRequest request) {
            
        // Shared form is kept as a separate session attribute in order to share the data between student screens
        StudentFormShared shared = new StudentFormShared();

        // EXISTING STUDENT
        int studentId = ServletUtil.getIntParam(request, "studentId", 0);

        if (studentId != 0) {
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Student student = studentManager.findStudent(preferredLanguage, studentId);
            shared.setStudent(student);
            
            shared.setPrimaryStudy(studyManager.findStudy(student.getPrimaryStudyId()));
        }
        
        return shared;

    }

    /**
     * Informs if new form object(s) need to be made.
     * 
     * This is to be called after {@link #setupFormShared(ModelMap, HttpServletRequest)} was called.
     */
    protected boolean isNewForm() {
        return loadFormData;
    }

    /**
     * Check if the cached form belongs to the student indicated by the studentId in the request.
     * @param formName name of the student form
     */
    protected boolean needNewForm(String formName, ModelMap model, HttpServletRequest request) {
        F form = getForm(formName, model);
        StudentFormShared sharedOfForm = form == null ? null : form.getStudentFormShared();
        
        int studentId = getStudentIdParam(request, false);
        return opusMethods.isNewForm(request) || form == null || getStudentId(sharedOfForm) != studentId;
    }

    /**
     * Check if the cached shared form belongs to the student indicated by the studentId in the request.
     */
    protected boolean needNewShared(ModelMap model, HttpServletRequest request) {
        StudentFormShared sharedOfModel = getSharedFromModel(model);

        int studentId = getStudentIdParam(request, false);
        return opusMethods.isNewForm(request) || sharedOfModel == null || getStudentId(sharedOfModel) != studentId;
    }

    private int getStudentId(StudentFormShared shared) {
        if (shared == null || shared.getStudent() == null) {
            return 0;
        }
        return shared.getStudent().getStudentId();
    }

    protected StudentFormShared getSharedFromModel(ModelMap model) {
        StudentFormShared studentFormShared = (StudentFormShared) model.get(FORM_NAME_SHARED);
        return studentFormShared;
    }
    
//    protected StudentFormShared getSharedFromFormOrModel(HttpSession session, F form, ModelMap model) {
//
////        StudentFormShared shared = null;
////        if (form != null) {
////            shared = form.getStudentFormShared();
////        }
////        
////        if (shared == null) {
////            shared = getSharedFromModel(model);
////        }
//        StudentFormShared shared = (StudentFormShared) session.getAttribute(FORM_NAME_SHARED);
//        
//        return shared;
//    }

    protected int getStudentIdParam(HttpServletRequest request, boolean mandatory) {
        int studentId = ServletUtil.getIntParam(request, "studentId", 0);
        if (mandatory && studentId == 0) {
            throw new RuntimeException("Parameter studentId not given");
        }
        return studentId;
    }

}
