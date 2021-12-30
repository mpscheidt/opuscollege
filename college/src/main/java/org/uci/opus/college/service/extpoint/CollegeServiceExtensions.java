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

package org.uci.opus.college.service.extpoint;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.OrderComparator;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.AppVersionAccessor;
import org.uci.opus.college.service.ProgressCalculationDefault;
import org.uci.opus.college.service.ResultsCalculationsMock99;
import org.uci.opus.college.service.StudentBalanceEvaluationDefault;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.web.extpoint.IExtensionCollection;
import org.uci.opus.college.web.user.UserRoleExtPoint;
import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;

/**
 * The different extensions on the service layer. This class can be used to provide an overview of all available service extensions.
 * 
 * @author Markus Pscheidt
 *
 */
public class CollegeServiceExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(CollegeServiceExtensions.class);

    @Autowired
    private ExtensionPointUtil extensionPointUtil;

    // system extension points
    private StudentBalanceEvaluation studentBalanceEvaluation;
    private StudentNumberGeneratorInterface studentNumberGenerator;
    private Collection<DBUpgradeListener> dbUpgradeListeners;
    private Collection<UserRoleExtPoint> userRoleExtPoints;
    private List<AppVersionAccessor> appVersionAccessors;

    // listeners on domain objects
    private Collection<IStudyPlanDetailListener> studyPlanDetailListeners;
    private Collection<IStudyPlanCardinalTimeUnitListener> studyPlanCardinalTimeUnitListeners;
    private Collection<IStudyPlanListener> studyPlanListeners;
    private Collection<IStudyGradeTypeListener> studyGradeTypeListeners;
    private Collection<ISubjectStudyGradeTypeListener> subjectStudyGradeTypeListeners;
    private Collection<ISubjectBlockStudyGradeTypeListener> subjectBlockStudyGradeTypeListeners;

    // calculators
    private ResultsCalculations resultsCalculationsExtension;
    private ProgressCalculation progressCalculationExtension;

    // curriculum transition
    private Collection<StudyGradeTypeTransitionExtPoint> studyGradeTypeTransitionExtensions; // if needed, repeat the same for subject and
                                                                                             // subject blocks
    private Collection<AcademicYearTransitionExtPoint> academicYearTransitionsExtensions;
    private Collection<SubjectStudyGradeTypeTransitionExtPoint> subjectStudyGradeTypeTransitionsExtensions;
    private Collection<SubjectBlockStudyGradeTypeTransitionExtPoint> subjectBlockStudyGradeTypeTransitionsExtensions;

    @Autowired(required = false)
    public void setResultsCalculationsExtension(ResultsCalculations resultsCalculationsExtension) {
        this.resultsCalculationsExtension = resultsCalculationsExtension;
        // log.info("Found resultsCalculations extension: " + resultsCalculationsExtension);
        extensionPointUtil.logExtensions(log, ResultsCalculations.class, resultsCalculationsExtension);
    }

    public ResultsCalculations getResultsCalculationsExtension() {
        if (log.isDebugEnabled()) {
            log.debug("resultsCalculationsExtension = " + resultsCalculationsExtension);
        }
        if (resultsCalculationsExtension == null)
            return new ResultsCalculationsMock99();
        return resultsCalculationsExtension;
    }

    @Autowired(required = false)
    public void setProgressCalculationExtension(ProgressCalculation progressCalculationExtension) {
        this.progressCalculationExtension = progressCalculationExtension;
        // log.info("Found resultsCalculations extension: " + progressCalculationExtension);
        extensionPointUtil.logExtensions(log, ProgressCalculation.class, progressCalculationExtension);
    }

    public ProgressCalculation getProgressCalculationExtension() {
        if (log.isDebugEnabled()) {
            log.debug("progressCalculation extension = " + progressCalculationExtension);
        }
        if (progressCalculationExtension == null)
            return new ProgressCalculationDefault();
        return progressCalculationExtension;
    }

    @Autowired(required = true)
    public void setStudentNumberGenerator(StudentNumberGeneratorInterface studentNumberGenerator) {
        this.studentNumberGenerator = studentNumberGenerator;
        // log.info("Found custom student number generator: " + studentNumberGenerator);
        extensionPointUtil.logExtensions(log, StudentNumberGeneratorInterface.class, studentNumberGenerator);
    }

    public StudentNumberGeneratorInterface getStudentNumberGenerator() {
        return studentNumberGenerator;
    }

    /**
     * Delegate.
     * 
     * @param key
     * @param organizationalUnitId
     * @param student
     * @return the unique student code or null, if the generator does not apply to the given key
     */
    public String createUniqueStudentCode(String key, int organizationalUnitId, Student student) {
        String studentCode = null;
        if (studentNumberGenerator.applies(key)) {
            studentCode = studentNumberGenerator.createUniqueStudentCode(key, organizationalUnitId, student);
        }
        return studentCode;
    }

    public Collection<StudyGradeTypeTransitionExtPoint> getStudyGradeTypeTransitionExtensions() {
        return studyGradeTypeTransitionExtensions;
    }

    @Autowired(required = false)
    public void setStudyGradeTypeTransitionExtensions(List<StudyGradeTypeTransitionExtPoint> studyGradeTypeTransitionExtensions) {
        this.studyGradeTypeTransitionExtensions = studyGradeTypeTransitionExtensions;
        if (studyGradeTypeTransitionExtensions != null) {
            Collections.sort(studyGradeTypeTransitionExtensions, new OrderComparator());
        }
        extensionPointUtil.logExtensions(log, StudyGradeTypeTransitionExtPoint.class, studyGradeTypeTransitionExtensions);
    }

    public Collection<AcademicYearTransitionExtPoint> getAcademicYearTransitionsExtensions() {
        return academicYearTransitionsExtensions;
    }

    @Autowired(required = false)
    public void setAcademicYearTransitionsExtensions(List<AcademicYearTransitionExtPoint> academicYearTransitionsExtensions) {
        this.academicYearTransitionsExtensions = academicYearTransitionsExtensions;
        if (academicYearTransitionsExtensions != null) {
            Collections.sort(academicYearTransitionsExtensions, new OrderComparator());
        }
        extensionPointUtil.logExtensions(log, AcademicYearTransitionExtPoint.class, academicYearTransitionsExtensions);
    }

    public Collection<SubjectStudyGradeTypeTransitionExtPoint> getSubjectStudyGradeTypeTransitionsExtensions() {
        return subjectStudyGradeTypeTransitionsExtensions;
    }

    @Autowired(required = false)
    public void setSubjectStudyGradeTypeTransitionsExtensions(List<SubjectStudyGradeTypeTransitionExtPoint> subjectStudyGradeTypeTransitionsExtensions) {
        this.subjectStudyGradeTypeTransitionsExtensions = subjectStudyGradeTypeTransitionsExtensions;
        if (subjectStudyGradeTypeTransitionsExtensions != null) {
            Collections.sort(subjectStudyGradeTypeTransitionsExtensions, new OrderComparator());
        }
        extensionPointUtil.logExtensions(log, SubjectStudyGradeTypeTransitionExtPoint.class, subjectStudyGradeTypeTransitionsExtensions);
    }

    public Collection<SubjectBlockStudyGradeTypeTransitionExtPoint> getSubjectBlockStudyGradeTypeTransitionsExtensions() {
        return subjectBlockStudyGradeTypeTransitionsExtensions;
    }

    @Autowired(required = false)
    public void setSubjectBlockStudyGradeTypeTransitionsExtensions(
            List<SubjectBlockStudyGradeTypeTransitionExtPoint> subjectBlockStudyGradeTypeTransitionsExtensions) {
        this.subjectBlockStudyGradeTypeTransitionsExtensions = subjectBlockStudyGradeTypeTransitionsExtensions;
        if (subjectBlockStudyGradeTypeTransitionsExtensions != null) {
            Collections.sort(subjectBlockStudyGradeTypeTransitionsExtensions, new OrderComparator());
        }
        extensionPointUtil.logExtensions(log, SubjectBlockStudyGradeTypeTransitionExtPoint.class, subjectBlockStudyGradeTypeTransitionsExtensions);
    }

    public StudentBalanceEvaluation getStudentBalanceEvaluation() {
        if (studentBalanceEvaluation == null)
            return new StudentBalanceEvaluationDefault();
        return studentBalanceEvaluation;
    }

    @Autowired(required = false)
    public void setStudentBalanceEvaluation(StudentBalanceEvaluation studentBalanceEvaluation) {
        this.studentBalanceEvaluation = studentBalanceEvaluation;
        // log.info("Found studentBalanceEvaluation extension: " + studentBalanceEvaluation);
        extensionPointUtil.logExtensions(log, StudentBalanceEvaluation.class, studentBalanceEvaluation);
    }

    @Autowired(required = false)
    public void setStudyPlanDetailListeners(Collection<IStudyPlanDetailListener> studyPlanDetailListeners) {
        this.studyPlanDetailListeners = studyPlanDetailListeners;
        extensionPointUtil.logExtensions(log, IStudyPlanDetailListener.class, studyPlanDetailListeners);
    }

    public Collection<IStudyPlanDetailListener> getStudyPlanDetailListeners() {
        return studyPlanDetailListeners;
    }

    /**
     * Delegate method.
     * 
     * @param studyPlanDetail
     * @param request
     */
    public void beforeStudyPlanDetailDelete(final int studyPlanDetailId, HttpServletRequest request) {
        if (studyPlanDetailListeners != null) {
            for (IStudyPlanDetailListener extension : studyPlanDetailListeners) {
                extension.beforeStudyPlanDetailDelete(studyPlanDetailId, request);
            }
        }
    }

    public Collection<DBUpgradeListener> getDbUpgradeListeners() {
        return dbUpgradeListeners;
    }

    @Autowired(required = false)
    public void setDbUpgradeListeners(Collection<DBUpgradeListener> dbUpgradeListeners) {
        this.dbUpgradeListeners = dbUpgradeListeners;
        extensionPointUtil.logExtensions(log, DBUpgradeListener.class, dbUpgradeListeners);
    }

    /**
     * Delegate method.
     * 
     * @param upgrades
     */
    public void dbUpgradesExecuted(List<DbUpgradeCommandInterface> upgrades) {
        if (dbUpgradeListeners != null) {
            for (DBUpgradeListener extension : dbUpgradeListeners) {
                extension.dbUpgradesExecuted(upgrades);
            }
        }
    }

    public Collection<IStudyPlanCardinalTimeUnitListener> getStudyPlanCardinalTimeUnitListeners() {
        return studyPlanCardinalTimeUnitListeners;
    }

    @Autowired(required = false)
    public void setStudyPlanCardinalTimeUnitListeners(Collection<IStudyPlanCardinalTimeUnitListener> studyPlanCardinalTimeUnitListeners) {
        this.studyPlanCardinalTimeUnitListeners = studyPlanCardinalTimeUnitListeners;
        extensionPointUtil.logExtensions(log, IStudyPlanCardinalTimeUnitListener.class, studyPlanCardinalTimeUnitListeners);
    }

    /**
     * Delegate method.
     * 
     * @param studyPlanCardinalTimeUnit
     * @param previousStudyPlanCardinalTimeUnit
     *            If student is transferred from previous time unit, null otherwise.
     * @param request
     */
    public void studyPlanCardinalTimeUnitAdded(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit,
            HttpServletRequest request) {
        if (studyPlanCardinalTimeUnitListeners != null) {
            for (IStudyPlanCardinalTimeUnitListener extension : studyPlanCardinalTimeUnitListeners) {
                extension.studyPlanCardinalTimeUnitAdded(studyPlanCardinalTimeUnit, previousStudyPlanCardinalTimeUnit, request);
            }
        }
    }

    public void isDeleteAllowed(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, BindingResult bindingResult) {
        if (studyPlanCardinalTimeUnitListeners != null) {
            for (IStudyPlanCardinalTimeUnitListener extension : studyPlanCardinalTimeUnitListeners) {
                extension.isDeleteAllowed(studyPlanCardinalTimeUnit, bindingResult);
            }
        }
    }

    /**
     * Delegate method.
     * 
     * @param studyPlanCardinalTimeUnitId
     * @param writeWho
     */
    public void beforeStudyPlanCardinalTimeUnitDelete(final int studyPlanCardinalTimeUnitId, String writeWho) {
        if (studyPlanCardinalTimeUnitListeners != null) {
            for (IStudyPlanCardinalTimeUnitListener extension : studyPlanCardinalTimeUnitListeners) {
                extension.beforeStudyPlanCardinalTimeUnitDelete(studyPlanCardinalTimeUnitId, writeWho);
            }
        }
    }

    public Collection<IStudyPlanListener> getStudyPlanListeners() {
        return studyPlanListeners;
    }

    @Autowired(required = false)
    public void setStudyPlanListeners(Collection<IStudyPlanListener> studyPlanListeners) {
        this.studyPlanListeners = studyPlanListeners;
        extensionPointUtil.logExtensions(log, IStudyPlanCardinalTimeUnitListener.class, studyPlanCardinalTimeUnitListeners);
    }

    /**
     * Delegate.
     * 
     * @param studyPlan
     * @param writeWho
     */
    public void studyPlanAdded(StudyPlan studyPlan, String writeWho) {
        if (studyPlanListeners != null) {
            for (IStudyPlanListener extension : studyPlanListeners) {
                extension.studyPlanAdded(studyPlan, writeWho);
            }
        }
    }

    /**
     * Delegate method.
     * 
     * @param studyPlanId
     * @param writeWho
     */
    public void beforeStudyPlanDelete(int studyPlanId, String writeWho) {
        if (studyPlanListeners != null) {
            for (IStudyPlanListener extension : studyPlanListeners) {
                extension.beforeStudyPlanDelete(studyPlanId, writeWho);
            }
        }
    }

    /**
     * Delegate.
     * 
     * @param studyPlan
     * @param writeWho
     */
    public void beforeStudyPlanUpdate(StudyPlan studyPlan, String writeWho) {
        if (studyPlanListeners != null) {
            for (IStudyPlanListener extension : studyPlanListeners) {
                extension.beforeStudyPlanUpdate(studyPlan, writeWho);
            }
        }
    }

    /**
     * Delegate.
     * 
     * @param studyPlan
     * @param writeWho
     */
    public void beforeStudyPlanStatusUpdate(StudyPlan studyPlan, String writeWho) {
        if (studyPlanListeners != null) {
            for (IStudyPlanListener extension : studyPlanListeners) {
                extension.beforeStudyPlanStatusUpdate(studyPlan, writeWho);
            }
        }
    }

    public Collection<IStudyGradeTypeListener> getStudyGradeTypeListeners() {
        return studyGradeTypeListeners;
    }

    @Autowired(required = false)
    public void setStudyGradeTypeListeners(Collection<IStudyGradeTypeListener> studyGradeTypeListeners) {
        this.studyGradeTypeListeners = studyGradeTypeListeners;
        extensionPointUtil.logExtensions(log, IStudyGradeTypeListener.class, studyGradeTypeListeners);
    }

    /**
     * Delegate.
     * 
     * @param studyGradeTypeId
     * @param request
     */
    public void beforeStudyGradeTypeDelete(int studyGradeTypeId, HttpServletRequest request) {
        if (studyGradeTypeListeners != null) {
            for (IStudyGradeTypeListener extension : studyGradeTypeListeners) {
                extension.beforeStudyGradeTypeDelete(studyGradeTypeId, request);
            }
        }
    }

    public Collection<ISubjectStudyGradeTypeListener> getSubjectStudyGradeTypeListeners() {
        return subjectStudyGradeTypeListeners;
    }

    @Autowired(required = false)
    public void setSubjectStudyGradeTypeListeners(Collection<ISubjectStudyGradeTypeListener> subjectStudyGradeTypeListeners) {
        this.subjectStudyGradeTypeListeners = subjectStudyGradeTypeListeners;
        extensionPointUtil.logExtensions(log, ISubjectStudyGradeTypeListener.class, subjectStudyGradeTypeListeners);
    }

    /**
     * Delegate.
     * 
     * @param studyGradeTypeId
     * @param request
     */
    public void beforeSubjectStudyGradeTypeDelete(int subjectStudyGradeTypeId, HttpServletRequest request) {
        if (subjectStudyGradeTypeListeners != null) {
            for (ISubjectStudyGradeTypeListener extension : subjectStudyGradeTypeListeners) {
                extension.beforeSubjectStudyGradeTypeDelete(subjectStudyGradeTypeId, request);
            }
        }
    }

    public Collection<ISubjectBlockStudyGradeTypeListener> getSubjectBlockStudyGradeTypeListeners() {
        return subjectBlockStudyGradeTypeListeners;
    }

    @Autowired(required = false)
    public void setSubjectBlockStudyGradeTypeListeners(Collection<ISubjectBlockStudyGradeTypeListener> subjectBlockStudyGradeTypeListeners) {
        this.subjectBlockStudyGradeTypeListeners = subjectBlockStudyGradeTypeListeners;
        extensionPointUtil.logExtensions(log, ISubjectBlockStudyGradeTypeListener.class, subjectBlockStudyGradeTypeListeners);
    }

    /**
     * Delegate.
     * 
     * @param subjectBlockStudyGradeTypeId
     * @param request
     */
    public void beforeSubjectBlockStudyGradeTypeDelete(int subjectBlockStudyGradeTypeId, HttpServletRequest request) {
        if (subjectBlockStudyGradeTypeListeners != null) {
            for (ISubjectBlockStudyGradeTypeListener extension : subjectBlockStudyGradeTypeListeners) {
                extension.beforeSubjectBlockStudyGradeTypeDelete(subjectBlockStudyGradeTypeId, request);
            }
        }
    }

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

    public Collection<UserRoleExtPoint> getUserRoleExtPoints() {
        return userRoleExtPoints;
    }

    @Autowired(required = false)
    public void setUserRoleExtPoints(Collection<UserRoleExtPoint> userRoleExtPoints) {
        this.userRoleExtPoints = userRoleExtPoints;
        extensionPointUtil.logExtensions(log, UserRoleExtPoint.class, userRoleExtPoints);
    }

    /**
     * Delegate.
     * 
     * @param authorities
     */
    public void authoritiesLoaded(List<GrantedAuthority> authorities) {
        if (userRoleExtPoints != null) {
            for (UserRoleExtPoint extension : userRoleExtPoints) {
                extension.authoritiesLoaded(authorities);
            }
        }
    }

    public List<AppVersionAccessor> getAppVersionAccessors() {
        return appVersionAccessors;
    }

    @Autowired(required = true)
    public void setAppVersionAccessors(List<AppVersionAccessor> appVersionAccessors) {
        this.appVersionAccessors = appVersionAccessors;
        extensionPointUtil.logExtensions(log, AppVersionAccessor.class, appVersionAccessors);
    }

}
