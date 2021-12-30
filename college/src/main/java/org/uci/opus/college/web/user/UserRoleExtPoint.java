package org.uci.opus.college.web.user;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;

/**
 * Extension points related to OpusUser and OpusRole.
 * 
 * @author Markus Pscheidt
 *
 */
public interface UserRoleExtPoint {

    /**
     * This is called when the list of authorities has been loaded.
     * The list of authorities can be modified.
     * 
     * @param authorities
     */
    void authoritiesLoaded(List<GrantedAuthority> authorities);

}
