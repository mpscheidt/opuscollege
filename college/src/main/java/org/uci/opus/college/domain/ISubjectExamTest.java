package org.uci.opus.college.domain;

import java.util.List;

/**
 * An interface for the similarities between subject, examination and test,
 * to make it easier to work with these items and to avoid copy & pasted code.
 * 
 * @author markus
 *
 */
public interface ISubjectExamTest {

    boolean isAssignedTeacher(int staffMemberId, Integer classgroupId);
    
    int getId();
    String getCode();
    String getDescription();
    String getActive();

    List<? extends ISubjectExamTest> getSubItems();
}
