package org.uci.opus.college.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.beanutils.BeanToPropertyValueTransformer;
import org.apache.commons.collections.CollectionUtils;

/**
 * Extends {@link ArrayList} and adds utility methods for the list of students.
 * 
 * Note that for {@link StudentList} to be created by iBatis a row handler could be written
 * as an alternative to the {@link DefaultRowHandler}.
 * 
 * @author markus
 *
 */
public class StudentList extends ArrayList<Student> {

    private static final long serialVersionUID = 1L;

    public StudentList() {
        super();
    }

    public StudentList(Collection<? extends Student> c) {
        super(c);
    }

    public StudentList(int initialCapacity) {
        super(initialCapacity);
    }

    /**
     * Retrieve a list of the all study plans of the students in this list
     * @return
     */
    public List<StudyPlan> getAllStudyPlans() {
        List<StudyPlan> allStudyPlans = new ArrayList<>();
        
        for (Student student : this) {
            List<StudyPlan> studyPlans = student.getStudyPlans();
            if (studyPlans != null) {
                allStudyPlans.addAll(studyPlans);
            }
        }
        
        return allStudyPlans;
    }

    /**
     * Retrieve a list of all study plan IDs of the student in this list
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Integer> getAllStudyPlanIds() {

        return (List<Integer>) CollectionUtils.collect(getAllStudyPlans(), new BeanToPropertyValueTransformer("id"));
    }

    /**
     * Retrieve a list of all study IDs of the students' study plans.
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Integer> getAllStudyIds() {

        return (List<Integer>) CollectionUtils.collect(getAllStudyPlans(), new BeanToPropertyValueTransformer("studyId"));
    }

}
