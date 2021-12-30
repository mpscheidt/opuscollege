package org.uci.opus.college.service.auth;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.util.OpusMethods;

/**
 * 
 * @author Markus Pscheidt
 *
 */
@Service
public class AssignedUserApplication {

    @Autowired
    private OpusMethods opusMethods;

    /**
     * When loading a list of e.g. students and user can only see data related to assigned subjects/examinations/tests, limit the list
     * accordingly.
     * 
     * @param request
     * @param parameterMap
     * @param parameterName
     */
    public void applyAssignedStaffMember(HttpServletRequest request, Map<String, Object> parameterMap, String parameterName) {

        // only apply to staff members, for students no logic exists yet
        if (!opusMethods.isStaffMember()) {
            return;
        }

        // if user has privilege to read all students, do nothing (no limitation required)
        // else apply subjectStaffMemberId to only return students subscribed to assigned subjects

        if (!request.isUserInRole(OpusPrivilege.READ_STUDENTS)) {
            OpusUser opusUser = opusMethods.getOpusUser();
            StaffMember staffMember = opusUser.getStaffMember();
            parameterMap.put(parameterName, staffMember.getStaffMemberId());
        }

    }

}
